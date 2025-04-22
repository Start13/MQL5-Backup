//+------------------------------------------------------------------+
//|                                                        ITime.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
  int shift=1;   //// scelta candela precedente
  int u=3;       //// tipo di TimeToString
  datetime t=iTime(Symbol(),PERIOD_CURRENT,shift);  
  string y=TimeToString(t,u);
  
  datetime x=iTime(Symbol(),PERIOD_CURRENT,shift-1);  
  string z=TimeToString(x,u);  
  
//  Print (t) ;
    Print (y) ;
    Print (z) ;    
if (y == z) 
 Print(iClose(Symbol(),PERIOD_CURRENT,shift));
 Print("day of Week: ",DayOfWeek());
 
 
 
 
    
  }
/*+------------------------------------------------------------------+
datetime  iTime( 
   const string        symbol,          // Simbolo 
   ENUM_TIMEFRAMES     timeframe,       // Periodo 
   int                 shift            // Slittamento 
   );
   
   
   
   string  TimeToString( 
   datetime  value,                           // numero 
   int       mode=TIME_DATE|TIME_MINUTES      // formato di output 
   );
   */