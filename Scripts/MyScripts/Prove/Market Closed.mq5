//+------------------------------------------------------------------+
//|                                                Market Closed.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//SymbolInfoSessionTrade(Symbol(),FRIDAY,0,TimeCurrent(2),TimeCurrent(0));
  
   Print(SymbolInfoDouble(Symbol(),SYMBOL_POINT)) ; 
   Print("Point(): ",Point());
   Print(SYMBOL_CALC_MODE_FOREX);
  }
//+------------------------------------------------------------------+
