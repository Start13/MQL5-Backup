//+------------------------------------------------------------------+
//|                                       UpwardTrendline System.mq5 |
//+------------------------------------------------------------------+
void OnTick()
  {
   int candles = (int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
   double pLow[];
   ArraySetAsSeries(pLow,true);
   int copy_low = CopyLow(_Symbol,_Period,0,candles,pLow);
   if(copy_low>0)
     {
      int candleLow = ArrayMinimum(pLow,0,candles);
      MqlRates pArray[];
      ArraySetAsSeries(pArray,true);
      int Data = CopyRates(_Symbol,_Period,0,candles,pArray);
      ObjectDelete(0,"UpwardTrendline");
      ObjectCreate(0,"UpwardTrendline",OBJ_TREND,0,pArray[candleLow].time,pArray[candleLow].low,
                   pArray[0].time,pArray[0].low);
      ObjectSetInteger(0,"UpwardTrendline",OBJPROP_COLOR,Blue);
      ObjectSetInteger(0,"UpwardTrendline",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(0,"UpwardTrendline",OBJPROP_WIDTH,3);
      ObjectSetInteger(0,"UpwardTrendline",OBJPROP_RAY_RIGHT,true);
     }
  }
//+------------------------------------------------------------------+
