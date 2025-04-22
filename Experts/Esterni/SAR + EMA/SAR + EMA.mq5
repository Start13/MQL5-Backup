//|                                                    SAR + EMA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade obj_Trade;

int handleEMA10, handleEMA20, handleSAR;

double ema10_data[],ema20_data[],sar_data[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   
   handleEMA10 = iMA(_Symbol,_Period,10,0,MODE_EMA,PRICE_CLOSE);
   handleEMA20 = iMA(_Symbol,_Period,20,0,MODE_EMA,PRICE_CLOSE);
   handleSAR = iSAR(_Symbol,_Period,0.02,0.2);
   
   if (handleEMA10 == INVALID_HANDLE || handleEMA20 == INVALID_HANDLE || handleSAR == INVALID_HANDLE){
      Print("ERROR CREATING THE IND HANDLES. REVERTING NOW");
      return (INIT_FAILED);
   }
   
   ArraySetAsSeries(ema10_data,true);
   ArraySetAsSeries(ema20_data,true);
   ArraySetAsSeries(sar_data,true);
   
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
   
   if (CopyBuffer(handleEMA10,0,0,3,ema10_data) < 3){
      Print("UNABLE TO COPY DATA FROM EMA 10 FOR FURTHER ANALYSIS. REVERTING");
      return;
   }
   if (CopyBuffer(handleEMA20,0,0,3,ema20_data) < 3){return;}
   if (CopyBuffer(handleSAR,0,0,3,sar_data) < 3){return;}
   
   double low0 = iLow(_Symbol,_Period,0);
   double high0 = iHigh(_Symbol,_Period,0);
   
   datetime currBarTime0 = iTime(_Symbol,_Period,0);
   static datetime signalTime = currBarTime0;
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if (ema10_data[0] > ema20_data[0] && ema10_data[1] < ema20_data[1]
      && sar_data[0] < low0 && signalTime != currBarTime0){
      Print("BUY SIGNAL @ ",TimeCurrent());
      signalTime = currBarTime0;
      if (PositionsTotal()==0){
         obj_Trade.Buy(0.01,_Symbol,Ask,Ask-300*_Point,Ask+300*_Point);
      }
   }
   else if (ema10_data[0] < ema20_data[0] && ema10_data[1] > ema20_data[1]
      && sar_data[0] > high0 && signalTime != currBarTime0){
      Print("SELL SIGNAL @ ",TimeCurrent());
      signalTime = currBarTime0;
      if (PositionsTotal()==0){
         obj_Trade.Sell(0.01,_Symbol,Bid,Bid+300*_Point,Bid-300*_Point);
      }
   }
   
}
//+------------------------------------------------------------------+