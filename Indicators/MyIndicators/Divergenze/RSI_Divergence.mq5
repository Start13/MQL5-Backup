//+------------------------------------------------------------------+
//|                                               RSI_Divergence.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                                 https://mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com"
#property version   "1.00"
#property description "RSI Divergence indicator"
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   5
//--- plot Arrow to up
#property indicator_label1  "Long signal"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Arrow to down
#property indicator_label2  "Short signal"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot divergence line to up
#property indicator_label3  "Line to up"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot divergence line to down
#property indicator_label4  "Line to down"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot AO
#property indicator_label5  "RSI"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- input parameters
input uint                 InpPeriod         =  14;            // Period
input ENUM_APPLIED_PRICE   InpAppliedPrice   =  PRICE_CLOSE;   // Applied price
input double               InpOverbought     =  70;            // Overbought
input double               InpOversold       =  30;            // Oversold
input color                InpColorBullish   =  clrAquamarine; // Bullish color
input color                InpColorBearish   =  clrRed;        // Bearish color
//--- indicator buffers
double         BufferArrowToUP[];
double         BufferLineToUP[];
double         BufferArrowToDN[];
double         BufferLineToDN[];
double         BufferRSI[];
double         BufferATR[];
//--- global variables
double         overbought;
double         oversold;
string         prefix;
int            period;
int            handle_rsi;
int            handle_atr;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- setting global variables
   period=int(InpPeriod<2 ? 2 : InpPeriod);
   prefix="rsidiv";
   overbought=(InpOverbought>100 ? 100 : InpOverbought<0.1 ? 0.1 : InpOverbought);
   oversold=(InpOversold<0 ? 0 : InpOversold>=overbought ? overbought-0.1 : InpOversold);
//--- indicator buffers mapping
   SetIndexBuffer(0,BufferArrowToUP,INDICATOR_DATA);
   SetIndexBuffer(1,BufferArrowToDN,INDICATOR_DATA);
   SetIndexBuffer(2,BufferLineToUP,INDICATOR_DATA);
   SetIndexBuffer(3,BufferLineToDN,INDICATOR_DATA);
   SetIndexBuffer(4,BufferRSI,INDICATOR_DATA);
   SetIndexBuffer(5,BufferATR,INDICATOR_CALCULATIONS);
//--- settings indicators parameters
   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
   IndicatorSetInteger(INDICATOR_LEVELS,2);
   IndicatorSetDouble(INDICATOR_MAXIMUM,100);
   IndicatorSetDouble(INDICATOR_MINIMUM,0);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,overbought);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,oversold);
   IndicatorSetString(INDICATOR_LEVELTEXT,0,"Overbought");
   IndicatorSetString(INDICATOR_LEVELTEXT,1,"Oversold");
   IndicatorSetString(INDICATOR_SHORTNAME,"RSI Divergence");
//--- setting buffer arrays as timeseries
   ArraySetAsSeries(BufferArrowToUP,true);
   ArraySetAsSeries(BufferArrowToDN,true);
   ArraySetAsSeries(BufferLineToUP,true);
   ArraySetAsSeries(BufferLineToDN,true);
   ArraySetAsSeries(BufferRSI,true);
   ArraySetAsSeries(BufferATR,true);
//--- setting plot buffer colors
   PlotIndexSetInteger(0,PLOT_ARROW,241);
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,InpColorBullish);
   PlotIndexSetInteger(1,PLOT_ARROW,242);
   PlotIndexSetInteger(1,PLOT_LINE_COLOR,InpColorBearish);
   PlotIndexSetInteger(2,PLOT_LINE_COLOR,InpColorBullish);
   PlotIndexSetInteger(3,PLOT_LINE_COLOR,InpColorBearish);
//--- create RSI and ATR handles
   ResetLastError();
   handle_rsi=iRSI(NULL,PERIOD_CURRENT,period,InpAppliedPrice);
   if(handle_rsi==INVALID_HANDLE)
     {
      Print("The iRSI(",(string)period,") object was not created: Error ",GetLastError());
      return INIT_FAILED;
     }
   ResetLastError();
   handle_atr=iATR(Symbol(),PERIOD_CURRENT,14);
   if(handle_atr==INVALID_HANDLE)
     {
      Print("The iATR object was not created: Error ",GetLastError());
      return INIT_FAILED;
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,prefix);
   ChartRedraw();
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
//--- Проверка на минимальное количество баров для расчёта
   if(rates_total<period+6 || Point()==0) return 0;
//--- Установка индексации массивов как таймсерий
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(time,true);
//--- Проверка и расчёт количества просчитываемых баров
   int limit=rates_total-prev_calculated;
   if(limit>1)
     {
      limit=rates_total-10;
      ArrayInitialize(BufferArrowToUP,EMPTY_VALUE);
      ArrayInitialize(BufferArrowToDN,EMPTY_VALUE);
      ArrayInitialize(BufferLineToUP,EMPTY_VALUE);
      ArrayInitialize(BufferLineToDN,EMPTY_VALUE);
      ArrayInitialize(BufferRSI,0);
      ArrayInitialize(BufferATR,0);
     }
//--- Подготовка данных
   int copied=0,count=(limit==0 ? 1 : rates_total);
   copied=CopyBuffer(handle_rsi,0,0,count,BufferRSI);
   if(copied!=count) return 0;
   copied=CopyBuffer(handle_atr,0,0,count,BufferATR);
   if(copied!=count) return 0;
//--- Расчёт индикатора
   for(int i=limit; i>=0 && !IsStopped(); i--)
     {
      BufferLineToUP[i]=BufferLineToDN[i]=BufferArrowToUP[i]=BufferArrowToDN[i]=EMPTY_VALUE;
      ProcessBullish(rates_total,high,low,time,i+2);
      ProcessBearish(rates_total,high,low,time,i+2);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Ищет впадину и возвращает флаг                                   |
//+------------------------------------------------------------------+
bool IsTrough(const int &rates_total,const int index)
  {
   if(BufferRSI[index]<oversold && BufferRSI[index]<BufferRSI[index+1] && BufferRSI[index]<BufferRSI[index-1])
     {
      for(int n=index+1; n<rates_total-2; n++)
        {
         if(BufferRSI[n]>oversold)
            return true;
         else if(BufferRSI[index]>BufferRSI[n])
            return false;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Ищет предыдущую впадину и возвращает флаг                        |
//+------------------------------------------------------------------+
int PrevTrough(const int &rates_total,const int index)
  {
   for(int n=index+5; n<rates_total-3; n++)
     {
      if(BufferRSI[n]<=BufferRSI[n+1] && BufferRSI[n]<BufferRSI[n+2] && BufferRSI[n]<=BufferRSI[n-1] && BufferRSI[n]<BufferRSI[n-2])
         return n;
     }
   return WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Поиск бычьих дивергенций                                         |
//+------------------------------------------------------------------+
void ProcessBullish(const int &rates_total,const double &high[],const double &low[],const datetime &time[],const int index)
  {
   if(IsTrough(rates_total,index))
     {
      int curr=index;
      int prev=PrevTrough(rates_total,index);
      if(prev!=WRONG_VALUE)
        {
         if(BufferRSI[curr]>BufferRSI[prev] && low[curr]<low[prev])
            DrawDivergence(high,low,time,prev,curr,true);
         else if(BufferRSI[curr]<BufferRSI[prev] && low[curr]>low[prev])
            DrawDivergence(high,low,time,prev,curr,true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Ищет пик и возвращает флаг                                       |
//+------------------------------------------------------------------+
bool IsPeak(const int &rates_total,const int index)
  {
   if(BufferRSI[index]>overbought && BufferRSI[index]>BufferRSI[index+1] && BufferRSI[index]>BufferRSI[index-1])
     {
      for(int n=index+1; n<rates_total-2; n++)
        {
         if(BufferRSI[n]<overbought)
            return true;
         else if(BufferRSI[index]<BufferRSI[n])
            return false;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Ищет предыдущий пик и возвращает флаг                            |
//+------------------------------------------------------------------+
int PrevPeak(const int &rates_total,const int index)
  {
   for(int n=index+5; n<rates_total-3; n++)
     {
      if(BufferRSI[n]>=BufferRSI[n+1] && BufferRSI[n]>BufferRSI[n+2] && BufferRSI[n]>=BufferRSI[n-1] && BufferRSI[n]>BufferRSI[n-2])
         return n;
     }
   return WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Поиск медвежьих дивергенций                                      |
//+------------------------------------------------------------------+
void ProcessBearish(const int &rates_total,const double &high[],const double &low[],const datetime &time[],const int index)
  {
   if(IsPeak(rates_total,index))
     {
      int curr=index;
      int prev=PrevPeak(rates_total,index);
      if(prev!=WRONG_VALUE)
        {
         if(BufferRSI[curr]<BufferRSI[prev] && high[curr]>high[prev])
            DrawDivergence(high,low,time,prev,curr,false);
         else if(BufferRSI[curr]>BufferRSI[prev] && high[curr]<high[prev])
            DrawDivergence(high,low,time,prev,curr,false);
        }
     }
  }
//+------------------------------------------------------------------+
//| Отображает найденные дивергенции                                 |
//+------------------------------------------------------------------+
void DrawDivergence(const double &high[],const double &low[],const datetime &time[],const int first,const int second,const bool bull_flag)
  {
   string obj_name=prefix+(string)(long)time[first]+"_"+(string)(long)time[second];
   int wnd;
   if(ObjectFind(0,obj_name)<0)
     {
      wnd=ChartWindowFind();
      if(wnd!=WRONG_VALUE)
        {
         if(bull_flag)
           {
            BufferArrowToUP[second]=BufferRSI[second];
            for(int j=first; j>=second; j--)
               BufferLineToUP[j]=EquationDirect(first,BufferRSI[first],second,BufferRSI[second],j);
            //---
            ObjectCreate(0,obj_name+"~",OBJ_TREND,0,time[first],low[first],time[second],low[second]);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_COLOR,InpColorBullish);
            ObjectSetString(0,obj_name+"~",OBJPROP_TOOLTIP,"\n");
            //---
            ObjectCreate(0,obj_name+"~A",OBJ_ARROW,0,time[second],low[second]);
            ObjectSetInteger(0,obj_name+"~A",OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,obj_name+"~A",OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,obj_name+"~A",OBJPROP_COLOR,InpColorBullish);
            ObjectSetInteger(0,obj_name+"~A",OBJPROP_ARROWCODE,241);
            ObjectSetString(0,obj_name+"~A",OBJPROP_TOOLTIP,"Bullish signal: "+TimeToString(time[second]));
           }
         else
           {
            BufferArrowToDN[second]=BufferRSI[second];
            for(int j=first; j>=second; j--)
               BufferLineToDN[j]=EquationDirect(first,BufferRSI[first],second,BufferRSI[second],j);
            //---
            ObjectCreate(0,obj_name+"~",OBJ_TREND,0,time[first],high[first],time[second],high[second]);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_COLOR,InpColorBearish);
            ObjectSetString(0,obj_name+"~",OBJPROP_TOOLTIP,"\n");
            //---
            ObjectCreate(0,obj_name+"~A",OBJ_ARROW,0,time[second],high[second]+BufferATR[second]);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,obj_name+"~",OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,obj_name+"~A",OBJPROP_COLOR,InpColorBearish);
            ObjectSetInteger(0,obj_name+"~A",OBJPROP_ARROWCODE,242);
            ObjectSetString(0,obj_name+"~A",OBJPROP_TOOLTIP,"Bearish signal: "+TimeToString(time[second]));
           }
         ObjectSetInteger(0,obj_name+"~",OBJPROP_RAY,false);
        }
     }
  }
//+------------------------------------------------------------------+
//| Уравнение прямой                                                 |
//+------------------------------------------------------------------+
double EquationDirect(const int left_bar,const double left_price,const int right_bar,const double right_price,const int bar_to_search) 
  {
   return(right_bar==left_bar ? left_price : (right_price-left_price)/(right_bar-left_bar)*(bar_to_search-left_bar)+left_price);
  }
//+------------------------------------------------------------------+
