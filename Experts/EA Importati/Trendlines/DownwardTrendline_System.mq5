//+------------------------------------------------------------------+
//|                                     DownwardTrendline System.mq5 |
//+------------------------------------------------------------------+
/*
#property copyright "Corrado Bruni, Copyright ©2023"
#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict
*/
input char NumCandele = 32;

void OnInit()
{
//input char NumCandele = 32;

}



void OnTick()
  {
   //int candles = (int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
   int candles = NumCandele;
   double pHigh[];
   ArraySetAsSeries(pHigh,true);
   int copy_high = CopyHigh(_Symbol,_Period,0,candles,pHigh);
   if(copy_high>0)
     {
      int candleHigh = ArrayMaximum(pHigh,0,candles);
      MqlRates pArray[];
      ArraySetAsSeries(pArray,true);
      int Data = CopyRates(_Symbol,_Period,0,candles,pArray);
      ObjectDelete(0,"DnwardTrendline");
      ObjectCreate(0,"DnwardTrendline",OBJ_TREND,0,pArray[candleHigh].time,pArray[candleHigh].high,
                   pArray[0].time,pArray[0].high);
      ObjectSetInteger(0,"DnwardTrendline",OBJPROP_COLOR,Blue);
      ObjectSetInteger(0,"DnwardTrendline",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(0,"DnwardTrendline",OBJPROP_WIDTH,3);
      ObjectSetInteger(0,"DnwardTrendline",OBJPROP_RAY_RIGHT,true);
     }
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
ObjectDelete(0,"DnwardTrendline");

}