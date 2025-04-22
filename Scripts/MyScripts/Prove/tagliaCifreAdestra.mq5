//+------------------------------------------------------------------+
//|                                            tagliaCifreAdesra.mq5 |
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
  {char NumCifreEliminateDaDx_= 1;
double b_ = iHigh(Symbol(),PERIOD_CURRENT,0);;
 Print (cifraTagliata(NumCifreEliminateDaDx_,b_));
}
//+------------------------------------------------------------------+
/*

double cifraTagliata(char NumCifreEliminateDaDx,double b)
{
//b=iHigh(Symbol(),PERIOD_CURRENT,0);
for (int i=0; i < Digits(); i++)
{
b*=10;
}
b= NormalizeDouble(b,Digits());
for(int i= 0; i < NumCifreEliminateDaDx; i++)
{
b/=10;
}
b=(int)b;
return b;
}
*/

double cifraTagliata(char NumCifreEliminateDaDx,double b)
{
//b=iHigh(Symbol(),PERIOD_CURRENT,0);
/*
for (int i=0; i < Digits(); i++)
{
b*=10;
}
b= NormalizeDouble(b,Digits());*/
for(int i= 0; i < NumCifreEliminateDaDx; i++)
{
b/=10;
}
//b=(int)b;
return b;
}