//+------------------------------------------------------------------+
//|                                           Prove time HI e Lo.mq5 |
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
   double LowD[1];
   CopyLow(Symbol(),PERIOD_D1,1,1,LowD);
Print(" LowD: ",(string)LowD[0]);

   double HighD[1];
   CopyHigh(Symbol(),PERIOD_D1,1,1,HighD);
Print(" HighD: ",(string)HighD[0]);

scanHiLow_H(LowD[0],HighD[0]);  
  }
//+------------------------------------------------------------------+

void scanHiLow_H(double HighD,double LowD)
   {
      double HighH[1];
/*   for(int i=0; i<20; i++)
//   double HighH[0];
   CopyHigh(Symbol(),PERIOD_H1,(int)i,20,HighH[0]);
   if (HighD==HighH[0])break;
   
   double LowH[1]=0;
   for(int l=0; i<20; l++)
//   double Low[1];
   CopyLow(Symbol(),PERIOD_H1,l,20,LowH[0]);
   if (LowD==LowH[0])break;
if(i & l == 0)Alert("Scan candele h1 giorno precedente ERRATA!");
if(i==l)return 1;
if(i<l)return 2;
if(l<i)return 3;  
  */                   
}