#property copyright "Corrado Bruni"
#property link      "https://www.cbalgotrade.com"
#property version   "1.26"
#property strict

#include <Trade\Trade.mqh>

enum ENUM_TRADE_MODE
{
   TRADE_BOTH = 0,
   TRADE_BUY_ONLY = 1,
   TRADE_SELL_ONLY = 2
};

// Input parameters
input color TrendUpColor = C'0,255,0';    // Colore del trend rialzista (verde lime)
input color TrendDownColor = C'255,0,0';  // Colore del trend ribassista (rosso)
input color DemandColor = C'0,0,255';     // Colore delle zone di demand (blu)
input color SupplyColor = C'255,0,0';     // Colore delle zone di supply (rosso)
input int LineWidth = 1;                  // Spessore delle linee
input int LookbackBars = 50;              // Numero di barre per cercare massimi/minimi
input int PivotWindow = 5;                // Finestra per identificare i pivot
input double ZoneHeight = 0.0020;         // Altezza delle zone di supply/demand
input ENUM_TIMEFRAMES ZoneTimeframe = PERIOD_CURRENT; // Timeframe per le zone
input int BreakoutCandles = 2;            // Numero di candele chiuse per confermare il breakout
input ENUM_TRADE_MODE TradeMode = TRADE_BOTH; // Modalità di trading
input double LotSize = 0.1;               // Dimensione del lotto
input int StopLossPips = 50;              // Stop Loss iniziale in pips
input int TakeProfitPips = 100;           // Take Profit in pips
input int BreakevenPips = 30;             // Pips di profitto per breakeven
input int TrailStartPips = 40;            // Pips di profitto per iniziare il trailing
input int TrailStepPips = 10;             // Step in pips per il trailing
input uint TrendMAPeriod = 14;            // Periodo MA per il calcolo dell'angolo
input ENUM_MA_METHOD TrendMAMethod = MODE_EMA; // Metodo MA per il calcolo dell'angolo
input ENUM_APPLIED_PRICE TrendMAAppliedPrice = PRICE_CLOSE; // Prezzo applicato per MA
input bool AllowMultipleOrders = false;   // Permetti ordini Buy e Sell contemporaneamente

// Global variables
string TrendUpName = "TrendUp";
string TrendUpUpperName = "TrendUpUpper";
string TrendDownName = "TrendDown";
string TrendDownLowerName = "TrendDownLower";
string SlopeTextUpName = "SlopeTextUp";
string SlopeTextUpUpperName = "SlopeTextUpUpper";
string SlopeTextDownName = "SlopeTextDown";
string SlopeTextDownLowerName = "SlopeTextDownLower";
string DemandZoneName = "DemandZone_";
string SupplyZoneName = "SupplyZone_";
double FastDnPts[], FastUpPts[], SlowDnPts[], SlowUpPts[];
double ZoneHi[1000], ZoneLo[1000];
int ZoneStart[1000], ZoneHits[1000], ZoneType[1000], ZoneStrength[1000], ZoneCount = 0;
bool ZoneTurn[1000];
double ATR[], HighBuffer[], LowBuffer[], CloseBuffer[];
int iATR_handle, iMA_handle;
CTrade trade;

#define ZONE_SUPPORT 1
#define ZONE_RESIST  2
#define ZONE_WEAK      0
#define ZONE_TURNCOAT  1
#define ZONE_UNTESTED  2
#define ZONE_VERIFIED  3
#define ZONE_PROVEN    4
#define UP_POINT 1
#define DN_POINT -1

int OnInit()
{
   iATR_handle = iATR(_Symbol, ZoneTimeframe, 7);
   if(iATR_handle == INVALID_HANDLE)
   {
      Print("Errore nella creazione dell'indicatore ATR");
      return(INIT_FAILED);
   }
   
   iMA_handle = iMA(_Symbol, PERIOD_CURRENT, TrendMAPeriod, 0, TrendMAMethod, TrendMAAppliedPrice);
   if(iMA_handle == INVALID_HANDLE)
   {
      Print("Errore nella creazione dell'indicatore iMA(", TrendMAPeriod, ")");
      return(INIT_FAILED);
   }
   
   ArraySetAsSeries(FastDnPts, true);
   ArraySetAsSeries(FastUpPts, true);
   ArraySetAsSeries(SlowDnPts, true);
   ArraySetAsSeries(SlowUpPts, true);
   ArraySetAsSeries(ATR, true);
   ArraySetAsSeries(HighBuffer, true);
   ArraySetAsSeries(LowBuffer, true);
   ArraySetAsSeries(CloseBuffer, true);
   
   DrawTrendLines();
   DrawSupplyDemandZones();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   ObjectDelete(0, TrendUpName);
   ObjectDelete(0, TrendUpUpperName);
   ObjectDelete(0, TrendDownName);
   ObjectDelete(0, TrendDownLowerName);
   ObjectDelete(0, SlopeTextUpName);
   ObjectDelete(0, SlopeTextUpUpperName);
   ObjectDelete(0, SlopeTextDownName);
   ObjectDelete(0, SlopeTextDownLowerName);
   DeleteZones();
   if(iATR_handle != INVALID_HANDLE) IndicatorRelease(iATR_handle);
   if(iMA_handle != INVALID_HANDLE) IndicatorRelease(iMA_handle);
}

void OnTick()
{
   DrawTrendLines();
   DrawSupplyDemandZones();
   ManagePositions();
}

void DrawTrendLines()
{
   static datetime lastTrendTime = 0;
   datetime currentTime = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(currentTime == lastTrendTime) return;
   lastTrendTime = currentTime;

   int bars = iBars(_Symbol, PERIOD_CURRENT);
   if(bars < LookbackBars + PivotWindow + 1) return;

   ArrayResize(HighBuffer, LookbackBars);
   ArrayResize(LowBuffer, LookbackBars);
   CopyHigh(_Symbol, PERIOD_CURRENT, 0, LookbackBars, HighBuffer);
   CopyLow(_Symbol, PERIOD_CURRENT, 0, LookbackBars, LowBuffer);

   datetime timeLow1 = 0, timeLow2 = 0, timeHigh1 = 0, timeHigh2 = 0;
   double priceLow1 = 0, priceLow2 = 0, priceHigh1 = 0, priceHigh2 = 0;
   int lowCount = 0, highCount = 0;

   for(int i = PivotWindow; i < LookbackBars && (lowCount < 2 || highCount < 2); i++)
   {
      bool isLow = true, isHigh = true;
      double currentLow = LowBuffer[i];
      double currentHigh = HighBuffer[i];
      for(int j = 1; j <= PivotWindow; j++)
      {
         if(iLow(_Symbol, PERIOD_CURRENT, i - j) <= currentLow || iLow(_Symbol, PERIOD_CURRENT, i + j) <= currentLow) isLow = false;
         if(iHigh(_Symbol, PERIOD_CURRENT, i - j) >= currentHigh || iHigh(_Symbol, PERIOD_CURRENT, i + j) >= currentHigh) isHigh = false;
      }
      if(isLow && lowCount < 2)
      {
         if(lowCount == 0) { timeLow1 = iTime(_Symbol, PERIOD_CURRENT, i); priceLow1 = currentLow; }
         else { timeLow2 = iTime(_Symbol, PERIOD_CURRENT, i); priceLow2 = currentLow; }
         lowCount++;
      }
      if(isHigh && highCount < 2)
      {
         if(highCount == 0) { timeHigh1 = iTime(_Symbol, PERIOD_CURRENT, i); priceHigh1 = currentHigh; }
         else { timeHigh2 = iTime(_Symbol, PERIOD_CURRENT, i); priceHigh2 = currentHigh; }
         highCount++;
      }
   }

   if(lowCount < 2 || highCount < 2) return;

   if(timeLow2 > timeLow1) { Swap(timeLow1, timeLow2); Swap(priceLow1, priceLow2); }
   if(timeHigh2 > timeHigh1) { Swap(timeHigh1, timeHigh2); Swap(priceHigh1, priceHigh2); }

   // Canale rialzista (pendenza positiva)
   if(priceLow1 <= priceLow2) return; // Assicura pendenza positiva
   int barStartUp = iBarShift(_Symbol, PERIOD_CURRENT, timeLow2);
   int barEndUp = iBarShift(_Symbol, PERIOD_CURRENT, timeLow1);
   double highestUp = priceLow1;
   datetime timeHighestUp = timeLow1;
   for(int i = barStartUp; i >= barEndUp; i--)
   {
      bool isHigh = true;
      double currentHigh = HighBuffer[i];
      for(int j = 1; j <= PivotWindow; j++)
      {
         if(i + j >= bars || i - j < 0) { isHigh = false; break; }
         if(iHigh(_Symbol, PERIOD_CURRENT, i - j) >= currentHigh || iHigh(_Symbol, PERIOD_CURRENT, i + j) >= currentHigh) isHigh = false;
      }
      if(isHigh && currentHigh > highestUp)
      {
         highestUp = currentHigh;
         timeHighestUp = iTime(_Symbol, PERIOD_CURRENT, i);
      }
   }
   double maBuffer[];
   ArrayResize(maBuffer, LookbackBars);
   ArraySetAsSeries(maBuffer, true);
   CopyBuffer(iMA_handle, 0, 0, LookbackBars, maBuffer);
   double angleUp = CalculateTrendAngle(timeLow2, priceLow2, timeLow1, priceLow1, maBuffer);
   double priceUpStart = highestUp;
   double priceUpEnd = highestUp + (priceLow1 - priceLow2) * ((timeLow1 - timeHighestUp) / (timeLow1 - timeLow2));
   double angleUpUpper = CalculateTrendAngle(timeLow2, priceUpStart, timeLow1, priceUpEnd, maBuffer);

   UpdateTrendLine(TrendUpName, timeLow2, priceLow2, timeLow1, priceLow1, TrendUpColor, STYLE_SOLID, LineWidth + 1);
   UpdateTrendLine(TrendUpUpperName, timeLow2, priceUpStart, timeLow1, priceUpEnd, TrendUpColor, STYLE_DASH, LineWidth);
   UpdateSlopeText(SlopeTextUpName, timeLow1, priceLow1 + 10 * _Point, StringFormat("Angle: %.2f°", angleUp), TrendUpColor);
   UpdateSlopeText(SlopeTextUpUpperName, timeLow1, priceUpEnd + 10 * _Point, StringFormat("Angle: %.2f°", angleUpUpper), TrendUpColor);

   // Canale ribassista (pendenza negativa)
   if(priceHigh1 >= priceHigh2) return; // Assicura pendenza negativa
   int barStartDown = iBarShift(_Symbol, PERIOD_CURRENT, timeHigh2);
   int barEndDown = iBarShift(_Symbol, PERIOD_CURRENT, timeHigh1);
   double lowestDown = priceHigh1;
   datetime timeLowestDown = timeHigh1;
   for(int i = barStartDown; i >= barEndDown; i--)
   {
      bool isLow = true;
      double currentLow = LowBuffer[i];
      for(int j = 1; j <= PivotWindow; j++)
      {
         if(i + j >= bars || i - j < 0) { isLow = false; break; }
         if(iLow(_Symbol, PERIOD_CURRENT, i - j) <= currentLow || iLow(_Symbol, PERIOD_CURRENT, i + j) <= currentLow) isLow = false;
      }
      if(isLow && currentLow < lowestDown)
      {
         lowestDown = currentLow;
         timeLowestDown = iTime(_Symbol, PERIOD_CURRENT, i);
      }
   }
   double angleDown = CalculateTrendAngle(timeHigh2, priceHigh2, timeHigh1, priceHigh1, maBuffer);
   double priceLowStart = lowestDown;
   double priceLowEnd = lowestDown + (priceHigh1 - priceHigh2) * ((timeHigh1 - timeLowestDown) / (timeHigh1 - timeHigh2));
   double angleDownLower = CalculateTrendAngle(timeHigh2, priceLowStart, timeHigh1, priceLowEnd, maBuffer);

   UpdateTrendLine(TrendDownName, timeHigh2, priceHigh2, timeHigh1, priceHigh1, TrendDownColor, STYLE_SOLID, LineWidth + 1);
   UpdateTrendLine(TrendDownLowerName, timeHigh2, priceLowStart, timeHigh1, priceLowEnd, TrendDownColor, STYLE_DASH, LineWidth);
   UpdateSlopeText(SlopeTextDownName, timeHigh1, priceHigh1 - 10 * _Point, StringFormat("Angle: %.2f°", angleDown), TrendDownColor);
   UpdateSlopeText(SlopeTextDownLowerName, timeHigh1, priceLowEnd - 10 * _Point, StringFormat("Angle: %.2f°", angleDownLower), TrendDownColor);

   if(TradeMode != TRADE_SELL_ONLY) CheckBreakoutDown();
   if(TradeMode != TRADE_BUY_ONLY) CheckBreakoutUp();
}

double CalculateTrendAngle(datetime t1, double p1, datetime t2, double p2, double &maBuffer[])
{
   int x1, x2, y1, y2;
   ChartTimePriceToXY(0, 0, t1, p1, x1, y1);
   ChartTimePriceToXY(0, 0, t2, p2, x2, y2);
   double diff = double(y2 - y1);
   double angle = 90 - atan((x1 - x2) / (diff != 0 ? diff : DBL_MIN)) * 180.0 / M_PI;
   return NormalizeDouble(angle, 2);
}

void UpdateTrendLine(string name, datetime time1, double price1, datetime time2, double price2, color clr, ENUM_LINE_STYLE style, int width)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_TREND, 0, time1, price1, time2, price2);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_STYLE, style);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, true);
   }
   else
   {
      ObjectSetDouble(0, name, OBJPROP_PRICE, 0, price1);
      ObjectSetInteger(0, name, OBJPROP_TIME, 0, time1);
      ObjectSetDouble(0, name, OBJPROP_PRICE, 1, price2);
      ObjectSetInteger(0, name, OBJPROP_TIME, 1, time2);
   }
}

void UpdateSlopeText(string name, datetime time, double price, string text, color clr)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_TEXT, 0, time, price);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   }
   else
   {
      ObjectSetDouble(0, name, OBJPROP_PRICE, price);
      ObjectSetInteger(0, name, OBJPROP_TIME, time);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
   }
}

void CheckBreakoutDown()
{
   if(ObjectFind(0, TrendDownName) < 0) return;

   datetime time1 = (datetime)ObjectGetInteger(0, TrendDownName, OBJPROP_TIME, 0);
   datetime time2 = (datetime)ObjectGetInteger(0, TrendDownName, OBJPROP_TIME, 1);
   double price1 = ObjectGetDouble(0, TrendDownName, OBJPROP_PRICE, 0);
   double price2 = ObjectGetDouble(0, TrendDownName, OBJPROP_PRICE, 1);
   double slope = (price2 - price1) / ((time2 - time1) / PeriodSeconds(PERIOD_CURRENT));

   int breakoutCount = 0;
   for(int i = 0; i < BreakoutCandles; i++)
   {
      datetime time = iTime(_Symbol, PERIOD_CURRENT, i + 1); // +1 per considerare solo candele chiuse
      double trendPrice = price1 + slope * ((time - time1) / PeriodSeconds(PERIOD_CURRENT));
      double closePrice = iClose(_Symbol, PERIOD_CURRENT, i + 1);
      if(closePrice <= trendPrice) // Verifica che la candela sia chiusa sopra la trend line ribassista
      {
         breakoutCount = 0; // Resetta se una candela non rompe
         break;
      }
      breakoutCount++;
   }

   if(breakoutCount == BreakoutCandles && (AllowMultipleOrders || PositionsTotal() == 0))
   {
      double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl = price - StopLossPips * _Point;
      double tp = price + TakeProfitPips * _Point;
      if(trade.Buy(LotSize, _Symbol, price, sl, tp, "Breakout Buy"))
         Print("Buy order opened: Ticket #", trade.ResultOrder());
      else
         Print("OrderSend Buy failed with error #", GetLastError());
   }
}

void CheckBreakoutUp()
{
   if(ObjectFind(0, TrendUpName) < 0) return;

   datetime time1 = (datetime)ObjectGetInteger(0, TrendUpName, OBJPROP_TIME, 0);
   datetime time2 = (datetime)ObjectGetInteger(0, TrendUpName, OBJPROP_TIME, 1);
   double price1 = ObjectGetDouble(0, TrendUpName, OBJPROP_PRICE, 0);
   double price2 = ObjectGetDouble(0, TrendUpName, OBJPROP_PRICE, 1);
   double slope = (price2 - price1) / ((time2 - time1) / PeriodSeconds(PERIOD_CURRENT));

   int breakoutCount = 0;
   for(int i = 0; i < BreakoutCandles; i++)
   {
      datetime time = iTime(_Symbol, PERIOD_CURRENT, i + 1); // +1 per considerare solo candele chiuse
      double trendPrice = price1 + slope * ((time - time1) / PeriodSeconds(PERIOD_CURRENT));
      double closePrice = iClose(_Symbol, PERIOD_CURRENT, i + 1);
      if(closePrice >= trendPrice) // Verifica che la candela sia chiusa sotto la trend line rialzista
      {
         breakoutCount = 0; // Resetta se una candela non rompe
         break;
      }
      breakoutCount++;
   }

   if(breakoutCount == BreakoutCandles && (AllowMultipleOrders || PositionsTotal() == 0))
   {
      double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl = price + StopLossPips * _Point;
      double tp = price - TakeProfitPips * _Point;
      if(trade.Sell(LotSize, _Symbol, price, sl, tp, "Breakout Sell"))
         Print("Sell order opened: Ticket #", trade.ResultOrder());
      else
         Print("OrderSend Sell failed with error #", GetLastError());
   }
}

void ManagePositions()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
         
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
         double currentSL = PositionGetDouble(POSITION_SL);
         double currentTP = PositionGetDouble(POSITION_TP);
         double profitPips = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 
                             (currentPrice - openPrice) / _Point : 
                             (openPrice - currentPrice) / _Point;

         if(profitPips >= BreakevenPips && currentSL != openPrice)
         {
            double newSL = NormalizeDouble(openPrice, _Digits);
            if(trade.PositionModify(PositionGetTicket(i), newSL, currentTP))
               Print("Breakeven applicato al ticket #", PositionGetTicket(i));
            else
               Print("Errore modifica posizione (Breakeven): ", GetLastError());
         }

         if(profitPips >= TrailStartPips)
         {
            double trailDistance = MathFloor((profitPips - TrailStartPips) / TrailStepPips) * TrailStepPips + TrailStartPips;
            double newSL;
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               newSL = NormalizeDouble(openPrice + trailDistance * _Point, _Digits);
               if(newSL > currentSL && newSL < currentPrice)
               {
                  if(trade.PositionModify(PositionGetTicket(i), newSL, currentTP))
                     Print("Trailing Stop aggiornato per Buy, ticket #", PositionGetTicket(i), " SL: ", newSL);
                  else
                     Print("Errore modifica posizione (Trailing Buy): ", GetLastError());
               }
            }
            else
            {
               newSL = NormalizeDouble(openPrice - trailDistance * _Point, _Digits);
               if(newSL < currentSL && newSL > currentPrice)
               {
                  if(trade.PositionModify(PositionGetTicket(i), newSL, currentTP))
                     Print("Trailing Stop aggiornato per Sell, ticket #", PositionGetTicket(i), " SL: ", newSL);
                  else
                     Print("Errore modifica posizione (Trailing Sell): ", GetLastError());
               }
            }
         }
      }
   }
}

void Swap(datetime &a, datetime &b) { datetime temp = a; a = b; b = temp; }
void Swap(double &a, double &b) { double temp = a; a = b; b = temp; }

void DrawSupplyDemandZones()
{
   static datetime lastZoneTime = 0;
   datetime currentTime = iTime(_Symbol, ZoneTimeframe, 0);

   if(currentTime != lastZoneTime)
   {
      lastZoneTime = currentTime;
      int bars = iBars(_Symbol, ZoneTimeframe);
      Print("Bars disponibili su ", EnumToString(ZoneTimeframe), ": ", bars);
      if(bars < LookbackBars + 5)
      {
         Print("Non abbastanza barre per calcolare le zone: ", bars, " < ", LookbackBars + 5);
         return;
      }

      FastFractals();
      SlowFractals();
      FindZones();
      Print("Zone rilevate: ", ZoneCount);
   }
   UpdateZones();
}

void FastFractals()
{
   int limit = MathMin(iBars(_Symbol, ZoneTimeframe) - 1, LookbackBars);
   int P1 = (int)(PeriodSeconds(ZoneTimeframe) / 60 * 3.0);
   ArrayResize(FastUpPts, limit + 1);
   ArrayResize(FastDnPts, limit + 1);
   ArrayResize(HighBuffer, limit + 1);
   ArrayResize(LowBuffer, limit + 1);
   int copiedHigh = CopyHigh(_Symbol, ZoneTimeframe, 0, limit + 1, HighBuffer);
   int copiedLow = CopyLow(_Symbol, ZoneTimeframe, 0, limit + 1, LowBuffer);
   Print("FastFractals - Barre copiate: High=", copiedHigh, ", Low=", copiedLow);

   for(int shift = limit; shift > 5; shift--)
   {
      if(Fractal(UP_POINT, P1, shift)) FastUpPts[shift] = HighBuffer[shift]; else FastUpPts[shift] = 0.0;
      if(Fractal(DN_POINT, P1, shift)) FastDnPts[shift] = LowBuffer[shift]; else FastDnPts[shift] = 0.0;
   }
}

void SlowFractals()
{
   int limit = MathMin(iBars(_Symbol, ZoneTimeframe) - 1, LookbackBars);
   int P2 = (int)(PeriodSeconds(ZoneTimeframe) / 60 * 6.0);
   ArrayResize(SlowUpPts, limit + 1);
   ArrayResize(SlowDnPts, limit + 1);
   ArrayResize(HighBuffer, limit + 1);
   ArrayResize(LowBuffer, limit + 1);
   int copiedHigh = CopyHigh(_Symbol, ZoneTimeframe, 0, limit + 1, HighBuffer);
   int copiedLow = CopyLow(_Symbol, ZoneTimeframe, 0, limit + 1, LowBuffer);
   Print("SlowFractals - Barre copiate: High=", copiedHigh, ", Low=", copiedLow);

   for(int shift = limit; shift > 5; shift--)
   {
      if(Fractal(UP_POINT, P2, shift)) SlowUpPts[shift] = HighBuffer[shift]; else SlowUpPts[shift] = 0.0;
      if(Fractal(DN_POINT, P2, shift)) SlowDnPts[shift] = LowBuffer[shift]; else SlowDnPts[shift] = 0.0;
   }
}

bool Fractal(int M, int P, int shift)
{
   int bars = iBars(_Symbol, ZoneTimeframe);
   if(shift < P || shift > bars - P - 1) return false;
   ArrayResize(HighBuffer, shift + P + 1);
   ArrayResize(LowBuffer, shift + P + 1);
   CopyHigh(_Symbol, ZoneTimeframe, 0, shift + P + 1, HighBuffer);
   CopyLow(_Symbol, ZoneTimeframe, 0, shift + P + 1, LowBuffer);

   for(int i = 1; i <= P; i++)
   {
      if(M == UP_POINT)
      {
         if(HighBuffer[shift + i] > HighBuffer[shift] || HighBuffer[shift - i] >= HighBuffer[shift]) return false;
      }
      if(M == DN_POINT)
      {
         if(LowBuffer[shift + i] < LowBuffer[shift] || LowBuffer[shift - i] <= LowBuffer[shift]) return false;
      }
   }
   return true;
}

void FindZones()
{
   int shift = MathMin(iBars(_Symbol, ZoneTimeframe) - 1, LookbackBars);
   ArrayResize(CloseBuffer, shift + 1);
   ArrayResize(HighBuffer, shift + 1);
   ArrayResize(LowBuffer, shift + 1);
   ArrayResize(ATR, shift + 1);
   int copiedClose = CopyClose(_Symbol, ZoneTimeframe, 0, shift + 1, CloseBuffer);
   int copiedHigh = CopyHigh(_Symbol, ZoneTimeframe, 0, shift + 1, HighBuffer);
   int copiedLow = CopyLow(_Symbol, ZoneTimeframe, 0, shift + 1, LowBuffer);
   int copiedATR = CopyBuffer(iATR_handle, 0, 0, shift + 1, ATR);
   Print("FindZones - Barre copiate: Close=", copiedClose, ", High=", copiedHigh, ", Low=", copiedLow, ", ATR=", copiedATR);
   if(copiedATR <= 0)
   {
      Print("Errore nel caricamento ATR: ", GetLastError());
      return;
   }

   ZoneCount = 0;
   for(int i = shift; i > 5 && ZoneCount < 1000; i--)
   {
      double atr = ATR[i];
      double fu = atr / 2 * 0.75;
      bool isWeak, isBust = false;
      int bustcount = 0, testcount = 0;
      double hival, loval;
      bool turned = false, hasturned = false;

      if(FastUpPts[i] > 0.001)
      {
         isWeak = (SlowUpPts[i] <= 0.001);
         hival = HighBuffer[i] + fu;
         loval = MathMax(MathMin(CloseBuffer[i], HighBuffer[i] - fu), HighBuffer[i] - fu * 2);

         for(int j = i - 1; j >= 0; j--)
         {
            if((turned == false && HighBuffer[j] > hival) || (turned == true && LowBuffer[j] < loval))
            {
               bustcount++;
               if(bustcount > 1 || isWeak) { isBust = true; break; }
               turned = !turned;
               hasturned = true;
               testcount = 0;
            }
            if((turned == false && FastUpPts[j] >= loval && FastUpPts[j] <= hival) ||
               (turned == true && FastDnPts[j] <= hival && FastDnPts[j] >= loval))
            {
               bool touchOk = true;
               for(int k = j + 1; k < j + 11 && k < shift; k++)
               {
                  if((turned == false && FastUpPts[k] >= loval && FastUpPts[k] <= hival) ||
                     (turned == true && FastDnPts[k] <= hival && FastDnPts[k] >= loval))
                  {
                     touchOk = false;
                     break;
                  }
               }
               if(touchOk) { bustcount = 0; testcount++; }
            }
         }

         if(!isBust)
         {
            ZoneHi[ZoneCount] = hival;
            ZoneLo[ZoneCount] = loval;
            ZoneHits[ZoneCount] = testcount;
            ZoneTurn[ZoneCount] = hasturned;
            ZoneStart[ZoneCount] = i;
            ZoneType[ZoneCount] = (ZoneLo[ZoneCount] > CloseBuffer[0]) ? ZONE_RESIST : ZONE_SUPPORT;
            ZoneStrength[ZoneCount] = (testcount > 3) ? ZONE_PROVEN : 
                                      (testcount > 0) ? ZONE_VERIFIED : 
                                      (hasturned) ? ZONE_TURNCOAT : 
                                      (!isWeak) ? ZONE_UNTESTED : ZONE_WEAK;
            Print("Zona ", ZoneCount, ": Hi=", hival, ", Lo=", loval, ", Type=", ZoneType[ZoneCount] == ZONE_SUPPORT ? "Support" : "Resist", ", Strength=", ZoneStrength[ZoneCount]);
            ZoneCount++;
         }
      }
      else if(FastDnPts[i] > 0.001)
      {
         isWeak = (SlowDnPts[i] <= 0.001);
         loval = LowBuffer[i] - fu;
         hival = MathMin(MathMax(CloseBuffer[i], LowBuffer[i] + fu), LowBuffer[i] + fu * 2);

         for(int j = i - 1; j >= 0; j--)
         {
            if((turned == false && LowBuffer[j] < loval) || (turned == true && HighBuffer[j] > hival))
            {
               bustcount++;
               if(bustcount > 1 || isWeak) { isBust = true; break; }
               turned = !turned;
               hasturned = true;
               testcount = 0;
            }
            if((turned == false && FastDnPts[j] <= hival && FastDnPts[j] >= loval) ||
               (turned == true && FastUpPts[j] >= loval && FastUpPts[j] <= hival))
            {
               bool touchOk = true;
               for(int k = j + 1; k < j + 11 && k < shift; k++)
               {
                  if((turned == false && FastDnPts[k] <= hival && FastDnPts[k] >= loval) ||
                     (turned == true && FastUpPts[k] >= loval && FastUpPts[k] <= hival))
                  {
                     touchOk = false;
                     break;
                  }
               }
               if(touchOk) { bustcount = 0; testcount++; }
            }
         }

         if(!isBust)
         {
            ZoneHi[ZoneCount] = hival;
            ZoneLo[ZoneCount] = loval;
            ZoneHits[ZoneCount] = testcount;
            ZoneTurn[ZoneCount] = hasturned;
            ZoneStart[ZoneCount] = i;
            ZoneType[ZoneCount] = (ZoneLo[ZoneCount] > CloseBuffer[0]) ? ZONE_RESIST : ZONE_SUPPORT;
            ZoneStrength[ZoneCount] = (testcount > 3) ? ZONE_PROVEN : 
                                      (testcount > 0) ? ZONE_VERIFIED : 
                                      (hasturned) ? ZONE_TURNCOAT : 
                                      (!isWeak) ? ZONE_UNTESTED : ZONE_WEAK;
            Print("Zona ", ZoneCount, ": Hi=", hival, ", Lo=", loval, ", Type=", ZoneType[ZoneCount] == ZONE_SUPPORT ? "Support" : "Resist", ", Strength=", ZoneStrength[ZoneCount]);
            ZoneCount++;
         }
      }
   }

   MergeZones();
}

void MergeZones()
{
   int merge_count = 1, iterations = 0;
   bool temp_merge[];
   ArrayResize(temp_merge, ZoneCount);
   int merge1[], merge2[];
   ArrayResize(merge1, ZoneCount);
   ArrayResize(merge2, ZoneCount);

   while(merge_count > 0 && iterations < 3)
   {
      merge_count = 0;
      iterations++;
      ArrayFill(temp_merge, 0, ZoneCount, false);

      for(int i = 0; i < ZoneCount - 1; i++)
      {
         if(temp_merge[i]) continue;
         for(int j = i + 1; j < ZoneCount; j++)
         {
            if(temp_merge[j]) continue;
            if((ZoneHi[i] >= ZoneLo[j] && ZoneHi[i] <= ZoneHi[j]) ||
               (ZoneLo[i] <= ZoneHi[j] && ZoneLo[i] >= ZoneLo[j]) ||
               (ZoneHi[j] >= ZoneLo[i] && ZoneHi[j] <= ZoneHi[i]) ||
               (ZoneLo[j] <= ZoneHi[i] && ZoneLo[j] >= ZoneLo[i]))
            {
               merge1[merge_count] = i;
               merge2[merge_count] = j;
               temp_merge[i] = true;
               temp_merge[j] = true;
               merge_count++;
            }
         }
      }

      for(int i = 0; i < merge_count; i++)
      {
         int target = merge1[i], source = merge2[i];
         ZoneHi[target] = MathMax(ZoneHi[target], ZoneHi[source]);
         ZoneLo[target] = MathMin(ZoneLo[target], ZoneLo[source]);
         ZoneHits[target] += ZoneHits[source];
         ZoneStart[target] = MathMax(ZoneStart[target], ZoneStart[source]);
         ZoneStrength[target] = MathMax(ZoneStrength[target], ZoneStrength[source]);
         if(ZoneHits[target] > 3) ZoneStrength[target] = ZONE_PROVEN;
         else if(ZoneHits[target] > 0) ZoneStrength[target] = ZONE_VERIFIED;
         else if(ZoneTurn[target]) ZoneStrength[target] = ZONE_TURNCOAT;
         ZoneTurn[target] = ZoneTurn[target] || ZoneTurn[source];
         ZoneType[target] = (ZoneLo[target] > iClose(_Symbol, ZoneTimeframe, 0)) ? ZONE_RESIST : ZONE_SUPPORT;
         ZoneHi[source] = 0;
      }
   }

   int newCount = 0;
   for(int i = 0; i < ZoneCount; i++)
   {
      if(ZoneHi[i] > 0)
      {
         if(newCount != i)
         {
            ZoneHi[newCount] = ZoneHi[i];
            ZoneLo[newCount] = ZoneLo[i];
            ZoneHits[newCount] = ZoneHits[i];
            ZoneTurn[newCount] = ZoneTurn[i];
            ZoneStart[newCount] = ZoneStart[i];
            ZoneType[newCount] = ZoneType[i];
            ZoneStrength[newCount] = ZoneStrength[i];
         }
         newCount++;
      }
   }
   ZoneCount = newCount;
   Print("Zone dopo merge: ", ZoneCount);
}

void UpdateZones()
{
   datetime timeEnd = iTime(_Symbol, PERIOD_CURRENT, 0);

   for(int i = 0; i < ZoneCount; i++)
   {
      string name = (ZoneType[i] == ZONE_SUPPORT) ? DemandZoneName + IntegerToString(i) : SupplyZoneName + IntegerToString(i);
      datetime startTime = iTime(_Symbol, ZoneTimeframe, ZoneStart[i]);

      if(ObjectFind(0, name) < 0)
      {
         ObjectCreate(0, name, OBJ_RECTANGLE, 0, startTime, ZoneLo[i], timeEnd, ZoneHi[i]);
         ObjectSetInteger(0, name, OBJPROP_COLOR, (ZoneType[i] == ZONE_SUPPORT) ? DemandColor : SupplyColor);
         ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, name, OBJPROP_BACK, true);
         ObjectSetInteger(0, name, OBJPROP_FILL, true);
         Print("Disegnata zona: ", name, " da ", ZoneLo[i], " a ", ZoneHi[i]);
      }
      else
      {
         ObjectSetDouble(0, name, OBJPROP_PRICE, 0, ZoneLo[i]);
         ObjectSetInteger(0, name, OBJPROP_TIME, 0, startTime);
         ObjectSetDouble(0, name, OBJPROP_PRICE, 1, ZoneHi[i]);
         ObjectSetInteger(0, name, OBJPROP_TIME, 1, timeEnd);
      }
   }
}

void DeleteZones()
{
   for(int i = 0; i < ZoneCount; i++)
   {
      ObjectDelete(0, DemandZoneName + IntegerToString(i));
      ObjectDelete(0, SupplyZoneName + IntegerToString(i));
   }
}