//+------------------------------------------------------------------+
//|                                                   MA + STOCH.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade obj_Trade;

int handleMA, handleSTOCH;

double maDATA[], stochDATA[];

bool isLastBuy = false, isLastSell = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   
   handleMA = iMA(_Symbol,_Period,100,0,MODE_SMA,PRICE_CLOSE);
   handleSTOCH = iStochastic(_Symbol,_Period,8,3,3,MODE_SMA,STO_LOWHIGH);
   
   if (handleMA == INVALID_HANDLE || handleSTOCH == INVALID_HANDLE){
      Print("ERROR: FAILED TO CREATE THE IND HANDLES. REVERTING");
      return (INIT_FAILED);
   }
   
   ArraySetAsSeries(maDATA,true);
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
   
   if (CopyBuffer(handleMA,0,0,3,maDATA) < 3){
      Print("ERROR: NOT ENOUGH DATA FROM MA IND FOR FURTHER ANALYSIS");
      return;
   }
   if (CopyBuffer(handleSTOCH,0,0,3,stochDATA) < 3){return;}
   
   //ArrayPrint(stochDATA,2);
   
   double low0 = iLow(_Symbol,_Period,0);
   double high0 = iHigh(_Symbol,_Period,0);
   
   datetime currBarTime0 = iTime(_Symbol,_Period,0);
   static datetime signalTime = currBarTime0;
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if (stochDATA[0] > 20 && stochDATA[1] < 20 && low0 < maDATA[0]
      && signalTime != currBarTime0){
      Print("BUY SIGNAL @ ",TimeCurrent());
      signalTime = currBarTime0;
      if (isLastBuy==false){
         obj_Trade.Buy(0.01,_Symbol,Ask,Ask-30000*_Point,Ask+3000*_Point);
         isLastBuy = true; isLastSell = false;
      }
   }
   else if (stochDATA[0] < 80 && stochDATA[1] > 80 && high0 > maDATA[0]
      && signalTime != currBarTime0){
      Print("SELL SIGNAL @ ",TimeCurrent());
      signalTime = currBarTime0;
      if (!isLastSell){
         obj_Trade.Sell(0.01,_Symbol,Bid,Bid+30000*_Point,Bid-3000*_Point);
         isLastBuy = false; isLastSell = true;
      }
   }
}