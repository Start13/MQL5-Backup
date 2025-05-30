//+------------------------------------------------------------------+
//|                                                 scarto tempo.mq5 |
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
  PositionSelectByIndex(0);
  datetime a = SYMBOL_TIME;
//Print("1: ",(int)((TimeCurrent() - TimeGMT()))/3600);
//Print("2: ",TimeCurrent());
  //Print("3: ",(string)a); 
  //Print("4: ",ChartPeriod());
  //Print("5: ",PERIOD_CURRENT );
   //Print((string)ChartPeriod(0));
   Print("7: ",Bars(Symbol(),PERIOD_CURRENT,PositionOpenTime(),TimeCurrent()  ));
   //Print("8: ",PositionOpenTime(),"9: ",(datetime)PositionGetInteger(POSITION_TIME));
   Print("9: ",PositionOpenTime());
   Print("Ticket: ",PositionTicket());
  }
//+------------------------------------------------------------------+
  /*
ENUM_TIMEFRAMES  ChartPeriod(
   long  chart_id=0      // Chart ID
   );