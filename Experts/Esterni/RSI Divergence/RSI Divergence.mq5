//+------------------------------------------------------------------+
//|                                        RSI DIVERGENCE IND EA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade obj_Trade;

int handle_RSI_DIV = INVALID_HANDLE; //-1

double signal_Buy_Sell[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   
   handle_RSI_DIV = iCustom(_Symbol,_Period,"Market//RSI Divergence Indicator MT5");
   
   Print("IND HANDLE = ",handle_RSI_DIV);
   
   if (handle_RSI_DIV == INVALID_HANDLE){
      Print("UNABLE TO INITIALIZE THE IND CORRECTLY. REVERTING NOW!");
      return (INIT_FAILED);
   }
   
   ArraySetAsSeries(signal_Buy_Sell,true);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
   if (CopyBuffer(handle_RSI_DIV,1,0,1,signal_Buy_Sell) < 1){
      Print("UNABLE TO GET ENOUGH REQUESTED DATA FOR BUY/SELL SIG'. REVERTING.");
      return;
   }
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   int currBars = iBars(_Symbol,_Period);
   static int prevBars = currBars;
   if (prevBars == currBars) return;
   prevBars = currBars;
   
   //Print(signal_Buy_Sell[0]);
   
   if (signal_Buy_Sell[0] == 1){
      Print("BUY SIGNAL = ",signal_Buy_Sell[0]);
      
      obj_Trade.Buy(0.01,_Symbol,Ask,0,Bid+300*_Point);
      
   }
   else if (signal_Buy_Sell[0] == -1){
      Print("SELL SIGNAL = ",signal_Buy_Sell[0]);
      
      obj_Trade.Sell(0.01,_Symbol,Bid,0,Ask-300*_Point);
      
   }
   
}
//+------------------------------------------------------------------+