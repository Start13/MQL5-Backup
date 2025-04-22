//+------------------------------------------------------------------+
//|                                                   BB + STOCH.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade obj_Trade;

int handleBB, handleSTOCH;

double bb_upperDATA[], bb_lowerDATA[], stochDATA[];
input int StopLoss = 0;
input int TakeProfit = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   
   handleBB = iBands(_Symbol,_Period,20,0,2,PRICE_CLOSE);
   handleSTOCH = iStochastic(_Symbol,_Period,8,3,3,MODE_SMA,STO_LOWHIGH);
   
   if (handleBB == INVALID_HANDLE || handleSTOCH == INVALID_HANDLE){
      Print("UNABLE TO INITIALIZE THE IND HANDLES. REVERTING NOW");
      return (INIT_FAILED);
   }
   
   ArraySetAsSeries(bb_lowerDATA,true);
   ArraySetAsSeries(bb_upperDATA,true);
   ArraySetAsSeries(stochDATA,true);

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
   
   if (CopyBuffer(handleBB,UPPER_BAND,0,3,bb_upperDATA) < 3){
      Print("NOT ENOUGH DATA FROM UPPER BAND FOR FURTHER ANALYSIS. REVERTING");
      return;
   }
   if (CopyBuffer(handleBB,LOWER_BAND,0,3,bb_lowerDATA) < 3){return;}
   if (CopyBuffer(handleSTOCH,0,0,3,stochDATA) < 3){return;}
   
   double low0 = iLow(_Symbol,_Period,0);
   double high0 = iHigh(_Symbol,_Period,0);
   
   datetime currBarTime0 = iTime(_Symbol,_Period,0);
   static datetime signalTime = currBarTime0;
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if (stochDATA[0] > 20 && stochDATA[1] < 20 && low0 < bb_lowerDATA[0]
      && signalTime != currBarTime0){
      Print("BUY SIGNAL @ ",TimeCurrent());
      signalTime = currBarTime0;
      if (PositionsTotal()==0){
         obj_Trade.Buy(0.01,_Symbol,Ask,Ask-StopLoss*_Point,Ask+TakeProfit*_Point);
      }
   }
   else if (stochDATA[0] < 80 && stochDATA[1] > 80 && high0 > bb_upperDATA[0]
      && signalTime != currBarTime0){
      Print("SELL SIGNAL @ ",TimeCurrent());
      signalTime = currBarTime0;
      if (PositionsTotal()==0){
         obj_Trade.Sell(0.01,_Symbol,Bid,Bid+StopLoss*_Point,Bid-TakeProfit*_Point);
      }
   }
   
}
//+------------------------------------------------------------------+