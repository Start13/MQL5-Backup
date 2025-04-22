//+------------------------------------------------------------------+
//|                                                 AllDrawTypes.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_plots 1
#property indicator_buffers 5
input ENUM_DRAW_TYPE WhatToDraw=DRAW_NONE;//What To Draw : 
input int WTD_Width1=1;//WTD Width 1
input int WTD_Width2=3;//WTD Width 2 
input ENUM_LINE_STYLE WTD_Style=STYLE_SOLID;//WTD Line Style :
input uchar WTD_Arrow=234;//WTD Arrow
enum color_mode
{
cm_single=0,//Single
cm_dual=1,//Dual
cm_triple=2//Triple
};
input color_mode ColorMode=cm_single;//Color Mode : 
input color WTD_Color1=clrRed;//WTD Color 1
input color WTD_Color2=clrGreen;//WTD Color 2
input color WTD_Color3=clrBlue;//WTD Color 3
input color WTD_Color4=clrYellow;//WTD Color 4
input color WTD_Color5=clrPurple;//WTD Color 5
input color WTD_Color6=clrWhite;//WTD Color 6
input color WTD_Color7=clrPink;//WTD Color 7
input color WTD_Color8=clrMagenta;//WTD Color 8
double index_1[];
double Line_Data[];
double Arrow_Data[];
double Histogram_Data[];
double Histogram2_Data_A[],Histogram2_Data_B[];
double ZigZag_Data_A[],ZigZag_Data_B[];
double Filling_Data_A[],Filling_Data_B[];
double Bars_Data_A[],Bars_Data_B[],Bars_Data_C[],Bars_Data_D[];
double Candles_Data_A[],Candles_Data_B[],Candles_Data_C[],Candles_Data_D[];
double Color_Index[];
/*
ENUM_DRAW_TYPE ID Description Data buffers Color buffers
DRAW_NONE Not drawn 1 0
DRAW_LINE Line 1 0
DRAW_SECTION Section 1 0
DRAW_HISTOGRAM Histogram from the zero line 1 0
DRAW_HISTOGRAM2 Histogram of the two indicator buffers 2 0
DRAW_ARROW Drawing arrows 1 0
DRAW_ZIGZAG Style Zigzag allows vertical section on the bar 2 0
DRAW_FILLING Color fill between the two levels 2 0
DRAW_BARS Display as a sequence of bars 4 0
DRAW_CANDLES Display as a sequence of candlesticks 4 0
DRAW_COLOR_LINE Multicolored line 1 1
DRAW_COLOR_SECTION Multicolored section 1 1
DRAW_COLOR_HISTOGRAM Multicolored histogram from the zero line 1 1
DRAW_COLOR_HISTOGRAM2 Multicolored histogram of the two indicator buffers 2 1
DRAW_COLOR_ARROW Drawing multicolored arrows 1 1
DRAW_COLOR_ZIGZAG Multicolored ZigZag 2 1
DRAW_COLOR_BARS Multicolored bars 4 1
DRAW_COLOR_CANDLES Multicolored candlesticks 4 1
*/
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
  int bi=-1;
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_NONE Not drawn 1 0
  if(WhatToDraw==DRAW_NONE)
  {
  bi++;SetIndexBuffer(bi,index_1,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_NONE);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_LINE Line 1 0    
  if(WhatToDraw==DRAW_LINE)
  {    
  bi++;SetIndexBuffer(bi,Line_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_LINE);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_SECTION Section 1 0    
  if(WhatToDraw==DRAW_SECTION)
  {
  bi++;SetIndexBuffer(bi,Line_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_SECTION);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_HISTOGRAM Histogram from the zero line 1 0
  if(WhatToDraw==DRAW_HISTOGRAM)
  {
  bi++;SetIndexBuffer(bi,Histogram_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_HISTOGRAM);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);//One Color

  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_HISTOGRAM2 Histogram of the two indicator buffers 2 0    
  if(WhatToDraw==DRAW_HISTOGRAM2)
  {
  bi++;SetIndexBuffer(bi,Histogram2_Data_A,INDICATOR_DATA);//histogram first data buffer 
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_HISTOGRAM2);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);//One Color
  bi++;SetIndexBuffer(bi,Histogram2_Data_B,INDICATOR_DATA);//histogram second data buffer

  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_ARROW Drawing arrows 1 0
  if(WhatToDraw==DRAW_ARROW)
  {
  bi++;SetIndexBuffer(bi,Arrow_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_ARROW);
       PlotIndexSetInteger(bi,PLOT_ARROW,WTD_Arrow);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_ZIGZAG Style Zigzag allows vertical section on the bar 2 0   
  if(WhatToDraw==DRAW_ZIGZAG)
  {
  bi++;SetIndexBuffer(bi,ZigZag_Data_A,INDICATOR_DATA);//zigzag first data buffer
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_ZIGZAG);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color
  bi++;SetIndexBuffer(bi,ZigZag_Data_B,INDICATOR_DATA);//zigzag second data buffer
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_FILLING Color fill between the two levels 2 0
  if(WhatToDraw==DRAW_FILLING)
  {
  bi++;SetIndexBuffer(bi,Filling_Data_A,INDICATOR_DATA);//Filling first data buffer
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_FILLING);
       if(ColorMode==cm_single){
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color1);
       }
       if(ColorMode==cm_dual){
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       }
       if(ColorMode==cm_triple){Alert("Triple Color does not apply to Filling type");}
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color       
  bi++;SetIndexBuffer(bi,Filling_Data_B,INDICATOR_DATA);//Filling second data buffer
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_BARS Display as a sequence of bars 4 0
  if(WhatToDraw==DRAW_BARS)
  {
  bi++;SetIndexBuffer(bi,Bars_Data_A,INDICATOR_DATA);//Bars first data buffer
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_BARS);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color          
  bi++;SetIndexBuffer(bi,Bars_Data_B,INDICATOR_DATA);//Bars second data buffer
  bi++;SetIndexBuffer(bi,Bars_Data_C,INDICATOR_DATA);//Bars third data buffer
  bi++;SetIndexBuffer(bi,Bars_Data_D,INDICATOR_DATA);//Bars fourth data buffer
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_CANDLES Display as a sequence of candlesticks 4 0
  if(WhatToDraw==DRAW_CANDLES)
  {
  bi++;SetIndexBuffer(bi,Candles_Data_A,INDICATOR_DATA);//Candles first data buffer 
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_CANDLES);
       if(ColorMode==cm_single){
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       }
       if(ColorMode==cm_dual){
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       }
       if(ColorMode==cm_triple){
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2); 
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);     
       }
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color         
  bi++;SetIndexBuffer(bi,Candles_Data_B,INDICATOR_DATA);//Candles second data buffer
  bi++;SetIndexBuffer(bi,Candles_Data_C,INDICATOR_DATA);//Candles third data buffer
  bi++;SetIndexBuffer(bi,Candles_Data_D,INDICATOR_DATA);//Candles fourth data buffer
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_LINE Multicolored line 1 1 
  if(WhatToDraw==DRAW_COLOR_LINE)
  {
  bi++;SetIndexBuffer(bi,Line_Data,INDICATOR_DATA);//ColorLine data buffer 
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_LINE);
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);       
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);//ColorLine color buffer
       PlotIndexSetDouble(bi,PLOT_EMPTY_VALUE,0);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_SECTION Multicolored section 1 1
  if(WhatToDraw==DRAW_COLOR_SECTION)
  {
  bi++;SetIndexBuffer(bi,Line_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_SECTION);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width2);
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);       
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_HISTOGRAM Multicolored histogram from the zero line 1 1
  if(WhatToDraw==DRAW_COLOR_HISTOGRAM)
  {
  bi++;SetIndexBuffer(bi,Histogram_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_HISTOGRAM);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width2);
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);          
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_HISTOGRAM2 Multicolored histogram of the two indicator buffers 2 1   
  if(WhatToDraw==DRAW_COLOR_HISTOGRAM2)
  {
  bi++;SetIndexBuffer(bi,Histogram2_Data_A,INDICATOR_DATA);//histogram first data buffer 
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_HISTOGRAM2);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);  
  bi++;SetIndexBuffer(bi,Histogram2_Data_B,INDICATOR_DATA);//histogram second data buffer
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_ARROW Drawing multicolored arrows 1 1 
  if(WhatToDraw==DRAW_COLOR_ARROW)
  {
  bi++;SetIndexBuffer(bi,Arrow_Data,INDICATOR_DATA);
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_ARROW);
       PlotIndexSetInteger(bi,PLOT_ARROW,WTD_Arrow);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width2);
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);          
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);       
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_ZIGZAG Multicolored ZigZag 2 1
  if(WhatToDraw==DRAW_COLOR_ZIGZAG)
  {
  bi++;SetIndexBuffer(bi,ZigZag_Data_A,INDICATOR_DATA);//zigzag first data buffer
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_ZIGZAG);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);         
  bi++;SetIndexBuffer(bi,ZigZag_Data_B,INDICATOR_DATA);//zigzag second data buffer
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_BARS Multicolored bars 4 1
  if(WhatToDraw==DRAW_COLOR_BARS)
  {
  bi++;SetIndexBuffer(bi,Bars_Data_A,INDICATOR_DATA);//Bars first data buffer
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_BARS);
       PlotIndexSetInteger(bi,PLOT_LINE_WIDTH,WTD_Width1);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color    
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);               
  bi++;SetIndexBuffer(bi,Bars_Data_B,INDICATOR_DATA);//Bars second data buffer
  bi++;SetIndexBuffer(bi,Bars_Data_C,INDICATOR_DATA);//Bars third data buffer
  bi++;SetIndexBuffer(bi,Bars_Data_D,INDICATOR_DATA);//Bars fourth data buffer
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);
  }
  //ENUM_DRAW_TYPE ID Description Data buffers Color buffers
  //DRAW_COLOR_CANDLES Multicolored candlesticks 4 1 
  if(WhatToDraw==DRAW_COLOR_CANDLES)
  {
  bi++;SetIndexBuffer(bi,Candles_Data_A,INDICATOR_DATA);//Candles first data buffer 
       PlotIndexSetInteger(bi,PLOT_DRAW_TYPE,DRAW_COLOR_CANDLES);
       PlotIndexSetInteger(bi,PLOT_LINE_STYLE,WTD_Style);//one color 
       PlotIndexSetInteger(bi,PLOT_COLOR_INDEXES,8);     
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,0,WTD_Color1);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,1,WTD_Color2);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,2,WTD_Color3);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,3,WTD_Color4);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,4,WTD_Color5);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,5,WTD_Color6);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,6,WTD_Color7);
       PlotIndexSetInteger(bi,PLOT_LINE_COLOR,7,WTD_Color8);                 
  bi++;SetIndexBuffer(bi,Candles_Data_B,INDICATOR_DATA);//Candles second data buffer
  bi++;SetIndexBuffer(bi,Candles_Data_C,INDICATOR_DATA);//Candles third data buffer
  bi++;SetIndexBuffer(bi,Candles_Data_D,INDICATOR_DATA);//Candles fourth data buffer
  bi++;SetIndexBuffer(bi,Color_Index,INDICATOR_COLOR_INDEX);
  }
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
  int i_from=rates_total-5,i_to=0;
  int i_diff=rates_total-prev_calculated;
  if(i_diff<=1){i_from=i_diff;}
  if(i_from<0){i_from=0;}
  for(int i=i_from;i>=i_to;i--){
  int j=rates_total-i-1;//point to the storage adress 
    //DRAW_LINE
    if(WhatToDraw==DRAW_LINE)
    {
    Line_Data[j]=close[j];
    }
    //DRAW SECTION
    if(WhatToDraw==DRAW_SECTION)
    {
    if((high[i]>high[i+1]&&high[i]>high[i+2])||(low[i]<low[i+1]&&low[i]<low[i+2]))
    {
    Line_Data[j]=close[j];
    }
    }
    //DRAW_HISTOGRAM
    if(WhatToDraw==DRAW_HISTOGRAM)
    {
    Histogram_Data[j]=close[j]-open[j];
    }
    //DRAW_HISTOGRAM2
    if(WhatToDraw==DRAW_HISTOGRAM2)
    {
    Histogram2_Data_A[j]=close[j];
    Histogram2_Data_B[j]=open[j];
    }
    //DRAW_ARROW
    if(WhatToDraw==DRAW_ARROW)
    {
    if((high[i]>high[i+1]&&high[i]>high[i+2])||(low[i]<low[i+1]&&low[i]<low[i+2]))
    {
    Arrow_Data[j]=close[j];
    }    
    }
    //DRAW_ZIGZAG
    if(WhatToDraw==DRAW_ZIGZAG)
    {
    if(high[i]>high[i+1]&&high[i]>high[i+2])
    {
    ZigZag_Data_A[j]=high[i];
    }    
    if(low[i]<low[i+1]&&low[i]<low[i+2])
    {
    ZigZag_Data_B[j]=low[i];
    }
    }  
    //DRAW_FILLING
    if(WhatToDraw==DRAW_FILLING)
    {
    Filling_Data_A[j]=open[j];
    Filling_Data_B[j]=close[j];
    }  
    //DRAW_BARS 
    if(WhatToDraw==DRAW_BARS)
    {
    Bars_Data_A[j]=open[j];
    Bars_Data_B[j]=high[j];
    Bars_Data_C[j]=low[j];
    Bars_Data_D[j]=close[j];
    }
    //DRAW_CANDLES
    if(WhatToDraw==DRAW_CANDLES)
    {
    Candles_Data_A[j]=open[j];
    Candles_Data_B[j]=high[j];
    Candles_Data_C[j]=low[j];
    Candles_Data_D[j]=close[j];
    }
    //DRAW_COLOR_LINE
    if(WhatToDraw==DRAW_COLOR_LINE)
    {
    Line_Data[j]=close[j];
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;
    }
    //DRAW_COLOR_SECTION
    if(WhatToDraw==DRAW_COLOR_SECTION)
    {
    if((high[i]>high[i+1]&&high[i]>high[i+2])||(low[i]<low[i+1]&&low[i]<low[i+2]))
    {
    Line_Data[j]=close[j];
    }
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;    
    }
    //DRAW_COLOR_HISTOGRAM
    if(WhatToDraw==DRAW_COLOR_HISTOGRAM)
    {
    Histogram_Data[j]=close[j]-open[j];
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;     
    }
    //DRAW_COLOR_HISTOGRAM2
    if(WhatToDraw==DRAW_COLOR_HISTOGRAM2)
    {
    Histogram2_Data_A[j]=close[j];
    Histogram2_Data_B[j]=open[j];
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;     
    }
    //DRAW_COLOR_ARROW
    if(WhatToDraw==DRAW_COLOR_ARROW)
    {
    if((high[i]>high[i+1]&&high[i]>high[i+2])||(low[i]<low[i+1]&&low[i]<low[i+2]))
    {
    Arrow_Data[j]=close[j];
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;      
    }    
    }
    //DRAW_COLOR_ZIGZAG
    if(WhatToDraw==DRAW_COLOR_ZIGZAG)
    {
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;        
    if(high[i]>high[i+1]&&high[i]>high[i+2])
    {
    ZigZag_Data_A[j]=high[i];
    }    
    if(low[i]<low[i+1]&&low[i]<low[i+2])
    {
    ZigZag_Data_B[j]=low[i];
    }
    } 
    //DRAW_COLOR_BARS 
    if(WhatToDraw==DRAW_COLOR_BARS)
    {
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k;       
    Bars_Data_A[j]=open[j];
    Bars_Data_B[j]=high[j];
    Bars_Data_C[j]=low[j];
    Bars_Data_D[j]=close[j];
    }
    //DRAW_COLOR_CANDLES
    if(WhatToDraw==DRAW_COLOR_CANDLES)
    {
    int k=i/20;
    k=MathMin(k,7);
    Color_Index[j]=k; 
    Candles_Data_A[j]=open[j];
    Candles_Data_B[j]=high[j];
    Candles_Data_C[j]=low[j];
    Candles_Data_D[j]=close[j];
    }
  }   

  return(rates_total);
  }

