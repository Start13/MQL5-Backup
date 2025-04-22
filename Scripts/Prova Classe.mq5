//+------------------------------------------------------------------+
//|                                                        Prove.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//#property script_show_inputs
//#include <MyInclude/MyInclude.mqh>


class pivot
{ 
public:
double s1;
double s2;
double s3;
double r1;
double r2;
double r3;

void pivot()
{
s1=45;
s2=543;
s3=0.8765;
Print("s1 ",s1," s2 ",s2," s3 ", s3);
Print("funzione pivot");
}


void print_s(){
Print("Void print_s");
}
};

void OnStart()
  {

pivot daily;
daily.r1=98;
daily.print_s();

pivot weekly;
 return;  
  }
//+------------------------------------------------------------------+
