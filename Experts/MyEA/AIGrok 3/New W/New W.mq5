//+------------------------------------------------------------------+
//|                                                PriceTrends.mq5   |
//|                                    Corrado Bruni Copyright @2025 |
//|                                      https://www.cbalgotrade.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni"
#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh> // Inclusione della libreria di trading

//+------------------------------------------------------------------+
//| Input Parametri                                                  |
//+------------------------------------------------------------------+
input color TrendUpColor = clrLime;         // Colore trend line rialziste (default: lime)
input color TrendDownColor = C'255,160,122'; // Colore trend line ribassiste (default: light salmon)
input int TrendWidth = 1;                   // Spessore linee trend
input ENUM_TIMEFRAMES Timeframe = PERIOD_CURRENT; // Timeframe
input int LookbackBars = 100;               // Numero di barre da analizzare
input int MinDistance = 5;                  // Distanza minima tra massimi/minimi (barre)
input int BreakCandles = 2;                 // Numero di candele consecutive per confermare la rottura
input double SlopeThreshold = 30.0;         // Soglia pendenza in gradi per considerare la trend line valida
input double LotSize = 0.1;                 // Dimensione del lotto per gli ordini
input int StopLossPips = 100;               // Stop Loss in pips
input int TakeProfitPips = 200;             // Take Profit in pips

//+------------------------------------------------------------------+
//| Variabili globali                                                |
//+------------------------------------------------------------------+
string TrendUpName = "TrendUp_";        // Prefisso per trend line rialziste
string TrendDownName = "TrendDown_";    // Prefisso per trend line ribassiste
string SlopeTextName = "SlopeText_";    // Prefisso per testi pendenza
double HighBuffer[];                    // Buffer per i massimi
double LowBuffer[];                     // Buffer per i minimi
double CloseBuffer[];                   // Buffer per i prezzi di chiusura
datetime LastBarTime = 0;               // Tempo dell'ultima barra elaborata

struct Extremum
{
   datetime time;
   double price;
   bool isHigh;                        // True se massimo, False se minimo
};
Extremum extrema[];                     // Array per massimi e minimi relativi

struct TrendLine
{
   string name;
   datetime startTime;
   double startPrice;
   datetime endTime;
   double endPrice;
   double slope;                       // Pendenza in unità prezzo/barra
   double slopeDeg;                    // Pendenza in gradi
   int breakCount;                     // Contatore candele sopra/sotto
   bool isUp;                          // True per rialzista, False per ribassista
   bool isValidForOrder;               // True se valida per ordini
};
TrendLine trendLines[];                 // Array per memorizzare le trend line attive

//+------------------------------------------------------------------+
//| Inizializzazione dell'EA                                         |
//+------------------------------------------------------------------+
int OnInit()
{
   ArraySetAsSeries(HighBuffer, true);
   ArraySetAsSeries(LowBuffer, true);
   ArraySetAsSeries(CloseBuffer, true);

   Print("PriceTrends EA inizializzato con successo");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Deinizializzazione dell'EA                                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   DeleteTrendLines();
   Print("PriceTrends EA deinizializzato, motivo: ", reason);
}

//+------------------------------------------------------------------+
//| Funzione principale eseguita a ogni tick                        |
//+------------------------------------------------------------------+
void OnTick()
{
   datetime currentBarTime = iTime(_Symbol, Timeframe, 0);
   if(currentBarTime != LastBarTime)
   {
      UpdatePriceTrends();
      LastBarTime = currentBarTime;
   }
}

//+------------------------------------------------------------------+
//| Aggiorna le trend line basate sull'andamento del prezzo         |
//+------------------------------------------------------------------+
void UpdatePriceTrends()
{
   int bars = iBars(_Symbol, Timeframe);
   if(bars < LookbackBars) return;

   // Ridimensiona i buffer
   ArrayResize(HighBuffer, LookbackBars);
   ArrayResize(LowBuffer, LookbackBars);
   ArrayResize(CloseBuffer, LookbackBars);

   // Carica i dati
   if(CopyHigh(_Symbol, Timeframe, 0, LookbackBars, HighBuffer) <= 0 ||
      CopyLow(_Symbol, Timeframe, 0, LookbackBars, LowBuffer) <= 0 ||
      CopyClose(_Symbol, Timeframe, 0, LookbackBars, CloseBuffer) <= 0)
   {
      Print("Errore nel caricamento dei dati: ", GetLastError());
      return;
   }

   // Trova massimi e minimi relativi
   FindExtrema();

   // Elimina le trend line precedenti
   DeleteTrendLines();

   // Disegna le trend line basate sui massimi e minimi relativi
   int trendUpCount = 0, trendDownCount = 0;
   ArrayResize(trendLines, ArraySize(extrema));
   int trendLineIndex = 0;

   // Variabili per tenere traccia dell'ultimo massimo/minimo
   datetime lastHighTime = 0, lastLowTime = 0;
   double lastHighPrice = 0, lastLowPrice = 0;

   for(int i = 0; i < ArraySize(extrema); i++)
   {
      if(extrema[i].isHigh) // Massimo relativo
      {
         if(lastHighTime != 0 && extrema[i].price < lastHighPrice) // Trend ribassista
         {
            string trendName = TrendDownName + IntegerToString(trendDownCount);
            ObjectCreate(0, trendName, OBJ_TREND, 0, lastHighTime, lastHighPrice, extrema[i].time, extrema[i].price);
            ObjectSetInteger(0, trendName, OBJPROP_COLOR, TrendDownColor);
            ObjectSetInteger(0, trendName, OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, trendName, OBJPROP_WIDTH, TrendWidth);
            ObjectSetInteger(0, trendName, OBJPROP_BACK, false);
            ObjectSetInteger(0, trendName, OBJPROP_RAY_RIGHT, true);

            // Calcola la pendenza
            double deltaPrice = extrema[i].price - lastHighPrice;
            double deltaBars = (double)(extrema[i].time - lastHighTime) / PeriodSeconds(Timeframe);
            double slopeRad = MathArctan(deltaPrice / deltaBars);
            double slopeDeg = slopeRad * 180 / M_PI;
            bool isValidForOrder = (slopeDeg < -SlopeThreshold); // Valida se più ripida di -SlopeThreshold

            // Testo pendenza
            string slopeText = SlopeTextName + IntegerToString(trendDownCount);
            ObjectCreate(0, slopeText, OBJ_TEXT, 0, extrema[i].time, extrema[i].price + 10 * _Point);
            ObjectSetString(0, slopeText, OBJPROP_TEXT, StringFormat("Slope: %.2f°", slopeDeg));
            ObjectSetInteger(0, slopeText, OBJPROP_COLOR, TrendDownColor);
            ObjectSetInteger(0, slopeText, OBJPROP_FONTSIZE, 8);

            // Salva la trend line
            trendLines[trendLineIndex].name = trendName;
            trendLines[trendLineIndex].startTime = lastHighTime;
            trendLines[trendLineIndex].startPrice = lastHighPrice;
            trendLines[trendLineIndex].endTime = extrema[i].time;
            trendLines[trendLineIndex].endPrice = extrema[i].price;
            trendLines[trendLineIndex].slope = deltaPrice / deltaBars;
            trendLines[trendLineIndex].slopeDeg = slopeDeg;
            trendLines[trendLineIndex].breakCount = 0;
            trendLines[trendLineIndex].isUp = false;
            trendLines[trendLineIndex].isValidForOrder = isValidForOrder;
            trendLineIndex++;

            trendDownCount++;
         }
         lastHighTime = extrema[i].time;
         lastHighPrice = extrema[i].price;
      }
      else // Minimo relativo
      {
         if(lastLowTime != 0 && extrema[i].price > lastLowPrice) // Trend rialzista
         {
            string trendName = TrendUpName + IntegerToString(trendUpCount);
            ObjectCreate(0, trendName, OBJ_TREND, 0, lastLowTime, lastLowPrice, extrema[i].time, extrema[i].price);
            ObjectSetInteger(0, trendName, OBJPROP_COLOR, TrendUpColor);
            ObjectSetInteger(0, trendName, OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, trendName, OBJPROP_WIDTH, TrendWidth);
            ObjectSetInteger(0, trendName, OBJPROP_BACK, false);
            ObjectSetInteger(0, trendName, OBJPROP_RAY_RIGHT, true);

            // Calcola la pendenza
            double deltaPrice = extrema[i].price - lastLowPrice;
            double deltaBars = (double)(extrema[i].time - lastLowTime) / PeriodSeconds(Timeframe);
            double slopeRad = MathArctan(deltaPrice / deltaBars);
            double slopeDeg = slopeRad * 180 / M_PI;
            bool isValidForOrder = (slopeDeg > SlopeThreshold); // Valida se più ripida di SlopeThreshold

            // Testo pendenza
            string slopeText = SlopeTextName + IntegerToString(trendUpCount);
            ObjectCreate(0, slopeText, OBJ_TEXT, 0, extrema[i].time, extrema[i].price - 10 * _Point);
            ObjectSetString(0, slopeText, OBJPROP_TEXT, StringFormat("Slope: %.2f°", slopeDeg));
            ObjectSetInteger(0, slopeText, OBJPROP_COLOR, TrendUpColor);
            ObjectSetInteger(0, slopeText, OBJPROP_FONTSIZE, 8);

            // Salva la trend line
            trendLines[trendLineIndex].name = trendName;
            trendLines[trendLineIndex].startTime = lastLowTime;
            trendLines[trendLineIndex].startPrice = lastLowPrice;
            trendLines[trendLineIndex].endTime = extrema[i].time;
            trendLines[trendLineIndex].endPrice = extrema[i].price;
            trendLines[trendLineIndex].slope = deltaPrice / deltaBars;
            trendLines[trendLineIndex].slopeDeg = slopeDeg;
            trendLines[trendLineIndex].breakCount = 0;
            trendLines[trendLineIndex].isUp = true;
            trendLines[trendLineIndex].isValidForOrder = isValidForOrder;
            trendLineIndex++;

            trendUpCount++;
         }
         lastLowTime = extrema[i].time;
         lastLowPrice = extrema[i].price;
      }
   }
   ArrayResize(trendLines, trendLineIndex);

   // Verifica la rottura delle trend line e gestisci gli ordini
   CheckTrendLineBreaks();

   Print("Disegnate ", trendUpCount, " trend line rialziste, ", trendDownCount, " trend line ribassiste");
}

//+------------------------------------------------------------------+
//| Trova massimi e minimi relativi                                 |
//+------------------------------------------------------------------+
void FindExtrema()
{
   ArrayResize(extrema, LookbackBars);
   int count = 0;

   for(int i = LookbackBars - 1; i >= 0; i--)
   {
      bool isHigh = true, isLow = true;
      for(int j = 1; j <= MinDistance && (i - j >= 0 || i + j < LookbackBars); j++)
      {
         if(i - j >= 0 && HighBuffer[i - j] >= HighBuffer[i]) isHigh = false;
         if(i + j < LookbackBars && HighBuffer[i + j] >= HighBuffer[i]) isHigh = false;
         if(i - j >= 0 && LowBuffer[i - j] <= LowBuffer[i]) isLow = false;
         if(i + j < LookbackBars && LowBuffer[i + j] <= LowBuffer[i]) isLow = false;
      }

      if(isHigh)
      {
         extrema[count].time = iTime(_Symbol, Timeframe, i);
         extrema[count].price = HighBuffer[i];
         extrema[count].isHigh = true;
         count++;
      }
      else if(isLow)
      {
         extrema[count].time = iTime(_Symbol, Timeframe, i);
         extrema[count].price = LowBuffer[i];
         extrema[count].isHigh = false;
         count++;
      }
   }
   ArrayResize(extrema, count);
   Print("Trovati ", count, " estremi (massimi e minimi relativi)");
}

//+------------------------------------------------------------------+
//| Verifica la rottura delle trend line e gestisci gli ordini      |
//+------------------------------------------------------------------+
void CheckTrendLineBreaks()
{
   for(int i = 0; i < ArraySize(trendLines); i++)
   {
      datetime currentTime = iTime(_Symbol, Timeframe, 0); // Ultima candela chiusa
      int shift = iBarShift(_Symbol, Timeframe, currentTime);
      double currentClose = CloseBuffer[shift];

      // Calcola il valore della trend line al tempo corrente
      double timeDiff = (double)(currentTime - trendLines[i].startTime) / PeriodSeconds(Timeframe);
      double trendValue = trendLines[i].startPrice + trendLines[i].slope * timeDiff;

      if(trendLines[i].isUp) // Rialzista
      {
         if(currentClose < trendValue) // Prezzo sotto la linea
         {
            trendLines[i].breakCount++;
            if(trendLines[i].breakCount >= BreakCandles && trendLines[i].isValidForOrder)
            {
               Print("Rottura confermata della trend line rialzista ", trendLines[i].name, " (Slope: ", trendLines[i].slopeDeg, "°). Apertura ordine SELL");
               OpenSellOrder();
               ObjectSetInteger(0, trendLines[i].name, OBJPROP_COLOR, clrGray);
            }
         }
         else
         {
            trendLines[i].breakCount = 0; // Resetta se il prezzo torna sopra
         }
      }
      else // Ribassista
      {
         if(currentClose > trendValue) // Prezzo sopra la linea
         {
            trendLines[i].breakCount++;
            if(trendLines[i].breakCount >= BreakCandles && trendLines[i].isValidForOrder)
            {
               Print("Rottura confermata della trend line ribassista ", trendLines[i].name, " (Slope: ", trendLines[i].slopeDeg, "°). Apertura ordine BUY");
               OpenBuyOrder();
               ObjectSetInteger(0, trendLines[i].name, OBJPROP_COLOR, clrGray);
            }
         }
         else
         {
            trendLines[i].breakCount = 0; // Resetta se il prezzo torna sotto
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Apertura ordine Buy                                             |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   CTrade trade; // Dichiarazione dell'oggetto trade
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl = price - StopLossPips * _Point;
   double tp = price + TakeProfitPips * _Point;

   if(trade.Buy(LotSize, _Symbol, price, sl, tp, "Buy da trend line ribassista"))
   {
      Print("Ordine Buy aperto, ticket: ", trade.ResultOrder());
   }
   else
   {
      Print("Errore apertura ordine Buy: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Apertura ordine Sell                                            |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   CTrade trade; // Dichiarazione dell'oggetto trade
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = price + StopLossPips * _Point;
   double tp = price - TakeProfitPips * _Point;

   if(trade.Sell(LotSize, _Symbol, price, sl, tp, "Sell da trend line rialzista"))
   {
      Print("Ordine Sell aperto, ticket: ", trade.ResultOrder());
   }
   else
   {
      Print("Errore apertura ordine Sell: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Elimina tutte le trend line e testi dal grafico                 |
//+------------------------------------------------------------------+
void DeleteTrendLines()
{
   for(int i = 0; i < 1000; i++)
   {
      ObjectDelete(0, TrendUpName + IntegerToString(i));
      ObjectDelete(0, TrendDownName + IntegerToString(i));
      ObjectDelete(0, SlopeTextName + IntegerToString(i));
   }
}

//+------------------------------------------------------------------+