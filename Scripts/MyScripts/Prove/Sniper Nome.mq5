//+------------------------------------------------------------------+
//|                                                  Sniper Nome.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <MyInclude/Patterns_Sq9.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
  long login=AccountInfoInteger(ACCOUNT_LOGIN); 
Print(login);
   
  }
//+------------------------------------------------------------------+
