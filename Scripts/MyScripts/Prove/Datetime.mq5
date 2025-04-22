//+------------------------------------------------------------------+
//|                                                     Datetime.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
datetime a = 30;
a= a*60;
datetime b = TimeCurrent();
Print("a: ",a);
Print("b: ",b);
datetime c = b+a;
Print("c: ",c);
Print(a+b);
Print("a>b: ",a>b);  
Print("a<b: ",a<b);
Print ("c>b: ",c>b); 
  }
//+------------------------------------------------------------------+
