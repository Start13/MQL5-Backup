//+------------------------------------------------------------------+
//|                                          Trading View to MT5.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+


////@version=5
//indicator(title="MA Cross", overlay=true, timeframe="", timeframe_gaps=true)
//shortlen = input.int(9, "Short MA Length", minval=1)
//longlen = input.int(21, "Long MA Length", minval=1)
//short = ta.sma(close, shortlen)
//long = ta.sma(close, longlen)
//plot(short, color = #FF6D00, title="Short MA")
//plot(long, color = #43A047, title="Long MA")
//plot(ta.cross(short, long) ? short : na, color=#2962FF, style = plot.style_cross, linewidth = 4, title="Cross")

input int short_ma = 9; // Short MA Length
input int long_ma = 21; // Long MA Length

//input color short_ma_clr = clrRed; // Short MA
//input color long_ma_clr = clrGreen; // Long MA
//input color cross_clr = clrBlue; // Cross MA


#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "5.00"
#property indicator_chart_window

#property indicator_buffers 3
#property indicator_plots 3

#property indicator_label1 "Short MA"
#property indicator_style1 STYLE_SOLID
#property indicator_color1 clrRed

#property indicator_label2 "Long MA"
#property indicator_style2 STYLE_SOLID
#property indicator_color2 clrGreen

#property indicator_label3 "Cross"
#property indicator_type3 DRAW_ARROW
#property indicator_color3 clrBlue
#property indicator_width3 4



int handleSMA_Short, handleSMA_Long;

double bufferSMA_Short[];
double bufferSMA_Long[];
double bufferSMA_Cross[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
   SetIndexBuffer(0,bufferSMA_Short);
   PlotIndexSetInteger(0,PLOT_DRAW_TYPE,DRAW_LINE);
   PlotIndexSetString(0,PLOT_LABEL,"Short MA");
   ArraySetAsSeries(bufferSMA_Short,true);
   
   SetIndexBuffer(1,bufferSMA_Long);
   PlotIndexSetInteger(1,PLOT_DRAW_TYPE,DRAW_LINE);
   PlotIndexSetString(1,PLOT_LABEL,"Long MA");
   ArraySetAsSeries(bufferSMA_Long,true);

   SetIndexBuffer(2,bufferSMA_Cross);
   PlotIndexSetInteger(2,PLOT_ARROW,170);
   PlotIndexSetString(2,PLOT_LABEL,"Cross");
   ArraySetAsSeries(bufferSMA_Cross,true);

   
   IndicatorSetString(INDICATOR_SHORTNAME,"MA Cross");
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   
   handleSMA_Short = iMA(_Symbol,_Period,short_ma,0,MODE_SMA,PRICE_CLOSE);
   handleSMA_Long = iMA(_Symbol,_Period,long_ma,0,MODE_SMA,PRICE_CLOSE);
   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   if (rates_total < long_ma) return (0);
   if (IsStopped()) return (0);
   
   int limit = (prev_calculated == 0) ? (rates_total - long_ma) : (rates_total - prev_calculated);
   
   CopyBuffer(handleSMA_Short,0,0,limit,bufferSMA_Short);
   CopyBuffer(handleSMA_Long,0,0,limit,bufferSMA_Long);
   
   for (int i=limit-1; i>=0; i--){
      
      bool UpCross = bufferSMA_Short[0] > bufferSMA_Long[0] &&
                     bufferSMA_Short[1] < bufferSMA_Long[1];
      bool DownCross = bufferSMA_Short[0] < bufferSMA_Long[0] &&
                     bufferSMA_Short[1] > bufferSMA_Long[1];
      
      bufferSMA_Cross[i] = (UpCross || DownCross) ? bufferSMA_Short[i] : EMPTY_VALUE;
      
   }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+