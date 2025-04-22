//+------------------------------------------------------------------+
//|                                                  #02 PIRANHA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade obj_Trade;

int handleBB;
double bb_upper[],bb_lower[];

bool isPrevTradeBuy = false, isPrevTradeSell = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

   handleBB = iBands(_Symbol,_Period,12,0,2,PRICE_CLOSE);
   if (handleBB == INVALID_HANDLE){
      Print("ERROR: UNABLE TO CREATE THE BB HANDLE. REVERTING");
      return (INIT_FAILED);
   }
   
   ArraySetAsSeries(bb_upper,true);
   ArraySetAsSeries(bb_lower,true);
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   
   if (CopyBuffer(handleBB,UPPER_BAND,0,3,bb_upper) < 3) return;
   if (CopyBuffer(handleBB,LOWER_BAND,0,3,bb_lower) < 3) return;
   
   double low0 = iLow(_Symbol,_Period,0);
   double high0 = iHigh(_Symbol,_Period,0);
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   datetime currTimeBar0 = iTime(_Symbol,_Period,0);
   static datetime signalTime = currTimeBar0;
   
   if (low0 < bb_lower[0] && signalTime != currTimeBar0){
      Print("BUY SIGNAL @ ",TimeCurrent());
      signalTime = currTimeBar0;
      if (PositionsTotal()==0 && !isPrevTradeBuy){
         obj_Trade.Buy(0.01,_Symbol,Ask,Ask-100*_Point,Ask+50*_Point);
         isPrevTradeBuy = true; isPrevTradeSell = false;
      }
   }
   else if (high0 > bb_upper[0] && signalTime != currTimeBar0){
      Print("SELL SIGNAL @ ",TimeCurrent());
      signalTime = currTimeBar0;
      if (PositionsTotal()==0 && isPrevTradeSell==false){
         obj_Trade.Sell(0.01,_Symbol,Bid,Bid+100*_Point,Bid-50*_Point);
         isPrevTradeBuy = false; isPrevTradeSell = true;
      }
   }
   
   //ArrayPrint(bb_upper,6);
   
}
//+------------------------------------------------------------------+

