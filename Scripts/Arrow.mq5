//+------------------------------------------------------------------+
//|                                                        Arrow.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <MyLibrary\MyLibrary.mqh>  
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime x1 =     iTime(Symbol(),PERIOD_CURRENT,1);
   datetime x2 =     TimeCurrent();//iTime(Symbol(),PERIOD_CURRENT,0);
   double   y1 =     Bid()+point(100);
   double   y2 =     Bid()-point(100);
   double   y3 =     iLow(Symbol(),PERIOD_CURRENT,0)-point(20);
   double   y4 =     iLow(Symbol(),PERIOD_CURRENT,0)-point(100);
   double   y5 =     iLow(Symbol(),PERIOD_CURRENT,iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,30,1))-point(20);   

static double ma1 = 0;
static double coeff = 0;

static string a = "Flat";
static string oldA = "Flat";



createArrow(0,"Buy","Buy",x2,y5,4,1,clrLime);






return;
   
  }
//+------------------------------------------------------------------+
