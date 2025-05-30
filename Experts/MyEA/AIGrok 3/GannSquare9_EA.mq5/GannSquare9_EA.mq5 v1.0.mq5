//+------------------------------------------------------------------+
//| GannSquare9_EA.mq5 v1.0                                          |
//| Expert Advisor per XAUUSD basato su Gann Square of 9             |
//| Ottimizzato per RoboForex, timeframe M5-H4                       |
//+------------------------------------------------------------------+
#property copyright "xAI"
#property link      "https://www.xai.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh> // Libreria per operazioni di trading

// Input parametri
input double LotSize = 0.1;       // Dimensione del lotto
input int MagicNumber = 12345;    // Numero magico per identificare gli ordini
input double SpreadMax = 20.0;    // Spread massimo consentito (in punti)

// Variabili globali
double buyAbove, sellBelow;
double buyTarget[5], sellTarget[5]; // Array statici per evitare problemi di ridimensionamento
datetime lastBarTime = 0;
CTrade trade; // Oggetto per gestire le operazioni di trading

//+------------------------------------------------------------------+
//| Funzione di inizializzazione                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   // Controlla se il simbolo è XAUUSD
   if(Symbol() != "XAUUSD")
   {
      Print("Errore: L'EA deve essere eseguito su XAUUSD!");
      return(INIT_FAILED);
   }
   trade.SetExpertMagicNumber(MagicNumber); // Imposta il numero magico
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Funzione di calcolo dei livelli Gann                             |
//+------------------------------------------------------------------+
void CalculateGannLevels(double currentPrice)
{
   // Calcolo semplificato dei livelli Gann basato su radice quadrata
   double sqrtPrice = MathSqrt(currentPrice);
   int n = (int)MathFloor(sqrtPrice);
   
   // Calcolo dei livelli buyAbove e sellBelow
   buyAbove = MathPow(n + 1, 2);
   sellBelow = MathPow(n, 2);
   
   // Calcolo dei target di acquisto (5 livelli)
   for(int i = 0; i < 5; i++)
      buyTarget[i] = MathPow(n + 1 + i * 0.25, 2);
   
   // Calcolo dei target di vendita (5 livelli)
   for(int i = 0; i < 5; i++)
      sellTarget[i] = MathPow(n - i * 0.25, 2);
   
   // Normalizzazione dei valori
   buyAbove = NormalizeDouble(buyAbove, 2);
   sellBelow = NormalizeDouble(sellBelow, 2);
   for(int i = 0; i < 5; i++)
   {
      buyTarget[i] = NormalizeDouble(buyTarget[i], 2);
      sellTarget[i] = NormalizeDouble(sellTarget[i], 2);
   }
}

//+------------------------------------------------------------------+
//| Funzione principale di tick                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   // Controlla se è una nuova barra
   datetime currentBarTime = iTime(Symbol(), Period(), 0);
   if(currentBarTime == lastBarTime) return;
   lastBarTime = currentBarTime;

   // Recupera Bid e Ask
   double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

   // Controlla lo spread
   double spread = (ask - bid) / Point();
   if(spread > SpreadMax)
   {
      Print("Spread troppo alto: ", spread, " punti. Operazione bloccata.");
      return;
   }

   // Ottieni il prezzo attuale
   double currentPrice = (bid + ask) / 2;
   
   // Calcola i livelli Gann
   CalculateGannLevels(currentPrice);

   // Controlla le posizioni aperte
   if(PositionsTotal() > 0) return;

   // Cancella ordini pendenti precedenti
   ClosePendingOrders();

   // Logica di trading
   if(currentPrice >= buyAbove)
   {
      // Apri posizione Buy
      OpenBuyOrder(ask, bid);
   }
   else if(currentPrice <= sellBelow)
   {
      // Apri posizione Sell
      OpenSellOrder(bid);
   }
   else
   {
      // Piazza ordini pendenti
      PlaceBuyStopOrder(ask);
      PlaceSellStopOrder(bid);
   }
}

//+------------------------------------------------------------------+
//| Funzione per aprire un ordine Buy                                |
//+------------------------------------------------------------------+
void OpenBuyOrder(double ask, double bid)
{
   double sl = NormalizeDouble(sellBelow, 2);
   double tp = NormalizeDouble(buyTarget[0], 2);
   if(trade.Buy(LotSize, Symbol(), ask, sl, tp, "Gann Buy"))
      Print("Ordine Buy aperto con successo! SL: ", sl, " TP: ", tp);
   else
      Print("Errore apertura Buy: ", GetLastError());
}

//+------------------------------------------------------------------+
//| Funzione per aprire un ordine Sell                               |
//+------------------------------------------------------------------+
void OpenSellOrder(double bid)
{
   double sl = NormalizeDouble(buyAbove, 2);
   double tp = NormalizeDouble(sellTarget[0], 2);
   if(trade.Sell(LotSize, Symbol(), bid, sl, tp, "Gann Sell"))
      Print("Ordine Sell aperto con successo! SL: ", sl, " TP: ", tp);
   else
      Print("Errore apertura Sell: ", GetLastError());
}

//+------------------------------------------------------------------+
//| Funzione per piazzare un ordine Buy Stop                         |
//+------------------------------------------------------------------+
void PlaceBuyStopOrder(double ask)
{
   double price = NormalizeDouble(buyAbove, 2);
   double sl = NormalizeDouble(sellBelow, 2);
   double tp = NormalizeDouble(buyTarget[0], 2);
   if(ask < price) // Piazza solo se il prezzo è sotto il livello
   {
      if(trade.BuyStop(LotSize, price, Symbol(), sl, tp, ORDER_TIME_GTC, 0, "Gann Buy Stop"))
         Print("Ordine Buy Stop piazzato con successo! Prezzo: ", price);
      else
         Print("Errore piazzamento Buy Stop: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Funzione per piazzare un ordine Sell Stop                        |
//+------------------------------------------------------------------+
void PlaceSellStopOrder(double bid)
{
   double price = NormalizeDouble(sellBelow, 2);
   double sl = NormalizeDouble(buyAbove, 2);
   double tp = NormalizeDouble(sellTarget[0], 2);
   if(bid > price) // Piazza solo se il prezzo è sopra il livello
   {
      if(trade.SellStop(LotSize, price, Symbol(), sl, tp, ORDER_TIME_GTC, 0, "Gann Sell Stop"))
         Print("Ordine Sell Stop piazzato con successo! Prezzo: ", price);
      else
         Print("Errore piazzamento Sell Stop: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Funzione per chiudere ordini pendenti                            |
//+------------------------------------------------------------------+
void ClosePendingOrders()
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if(OrderSelect(ticket))
      {
         if(OrderGetInteger(ORDER_MAGIC) == MagicNumber)
         {
            if(trade.OrderDelete(ticket))
               Print("Ordine pendente chiuso: ", ticket);
            else
               Print("Errore chiusura ordine pendente: ", GetLastError());
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Funzione di deinizializzazione                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("EA rimosso. Motivo: ", reason);
}