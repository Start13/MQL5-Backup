//+------------------------------------------------------------------+
//|                                                         MACD.mq5 |
//|                             Copyright 2000-2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2000-2024, MetaQuotes Ltd."
#property link        "https://www.mql5.com"
#property description "Moving Average Convergence/Divergence"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   1
#property indicator_type1   DRAW_HISTOGRAM

#property indicator_color1  clrYellow,Red,Green

#property indicator_width1  1

#property indicator_label1  "Mayer"
#property indicator_label2  "Signal"
//--- input parameters
input int                InpFastEMA=12;               // Fast EMA period
input int                InpSlowEMA=26;               // Slow EMA period
input int                InpSignalSMA=9;              // Signal SMA period
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_CLOSE; // Applied price

input string   comment_MA =        "--- MA  SETTING ---";   // --- MA  SETTING ---
input int                  periodMAFast  = 30;              //Periodo MA 
input int                  shiftMAFast   =  0;              //Shift MA 
input ENUM_MA_METHOD       methodMAFast=MODE_EMA;           //Metodo MA 
input ENUM_APPLIED_PRICE   applied_priceMAFast=PRICE_CLOSE; //Tipo di  prezzo MA 
input color                coloreMAFast = clrAzure;         //Colore MA 

input string   comment_MAY =        "--- MAYER  SETTING ---";   // --- MAYER  SETTING ---
input double   maxSoglia       = 1.0021;  //Max soglia permessa x Ordine Sell
input double   MaxValore       = 1.0000;  //Max Valore x Ordine Sell
input double   MinValore       = 1.0000;  //Min Valore X Ordine Buy
input double   minSoglia       = 0.9968;  //min soglia permessa x Ordine Buy

int handle_iCustomMAFast;

//--- indicator buffers
double ExtMacdBuffer[];
double ExtSignalBuffer[];
double ExtFastMaBuffer[];
double ExtSlowMaBuffer[];

string symbol_;

int    ExtFastMaHandle;
int    ExtSlowMaHandle;

double C1 = 0;

static double ma1 = 0;
static double ma2 = 0;
static double coeff = 0;
static double coeff2 = 0;
 
//static string a = "Flat";
static string oldA = "Flat";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtMacdBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtSignalBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ExtFastMaBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,ExtSlowMaBuffer,INDICATOR_CALCULATIONS);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,InpSignalSMA-1);
//--- name for indicator subwindow label
   string short_name=StringFormat("MACD(%d,%d,%d)",InpFastEMA,InpSlowEMA,InpSignalSMA);
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
//--- get MA handles
   handle_iCustomMAFast = iCustom(symbol_,0,"Examples\\Custom Moving Average Input Color",periodMAFast,shiftMAFast,methodMAFast,coloreMAFast);
   ExtFastMaHandle=iMA(NULL,0,InpFastEMA,0,MODE_EMA,InpAppliedPrice);
   ExtSlowMaHandle=iMA(NULL,0,InpSlowEMA,0,MODE_EMA,InpAppliedPrice);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
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
  symbol_=_Symbol;
   if(rates_total<InpSignalSMA)
      return(0);
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtFastMaHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtFastMaHandle is calculated (",calculated," bars). Error ",GetLastError());
      return(0);
     }
   calculated=BarsCalculated(ExtSlowMaHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtSlowMaHandle is calculated (",calculated," bars). Error ",GetLastError());
      return(0);
     }
bool semCand = semaforoCANDELA(0);      
if(semCand) 
{
C1  = iClose(symbol_,PERIOD_CURRENT,1);
//copy1=CopyBuffer(handle1,0,0,3,LabelBuffer1);iCust1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 
ma1 = MAFast(1);

coeff  = iClose(symbol_,PERIOD_CURRENT,1) / ma1;

}
double sogliaSup = maxSoglia*ma1;
double maxLiv    = MaxValore*ma1;
double minLiv    = MinValore*ma1;
double sogliaInf = minSoglia*ma1;
 /*
if(doubleCOMPRESO(coeff,MinValore,minSoglia) && barreArrowBuy!=barre){barreArrowBuy=barre;
                     createArrow(0,"ArrBuy"+(string)count,"Buy",x1,y5,0,241,clrLime);count++;}//198   ///////////////////
if(!doubleCOMPRESO(coeff,MinValore,minSoglia) && barreArrowBuy!=0)barreArrowBuy=0;

if(doubleCOMPRESO(coeff,MaxValore,maxSoglia) && barreArrowSell!=barre){barreArrowSell=barre;
                     createArrow(0,"ArrSell"+(string)count,"Sell",x1,y5,0,242,clrRed);count++;}//196   ///////////////////
if(!doubleCOMPRESO(coeff,MaxValore,maxSoglia) && barreArrowSell!=0)barreArrowSell=0;

if(!doubleCOMPRESO(coeff,MinValore,minSoglia) && !doubleCompreso(coeff,MaxValore,maxSoglia) &&  barreArrowSell!=barre)
                     {barreArrowFlat=barre;createArrow(0,"ArrSell"+(string)count,"Sell",x1,y5,0,244,clrYellow);count++;}
 */ 
//--- we can copy not all data
   int to_copy;
   if(prev_calculated>rates_total || prev_calculated<0)
      to_copy=rates_total;
   else
     {
      to_copy=rates_total-prev_calculated;
      if(prev_calculated>0)
         to_copy++;
     }
//--- get Fast EMA buffer
   if(IsStopped()) // checking for stop flag
      return(0);
   if(CopyBuffer(ExtFastMaHandle,0,0,to_copy,ExtFastMaBuffer)<=0)
     {
      Print("Getting fast EMA is failed! Error ",GetLastError());
      return(0);
     }
//--- get SlowSMA buffer
   if(IsStopped()) // checking for stop flag
      return(0);
   if(CopyBuffer(ExtSlowMaHandle,0,0,to_copy,ExtSlowMaBuffer)<=0)
     {
      Print("Getting slow SMA is failed! Error ",GetLastError());
      return(0);
     }
//---
   int start;
   if(prev_calculated==0)
      start=0;
   else
      start=prev_calculated-1;
//--- calculate MACD
   for(int i=start; i<rates_total && !IsStopped(); i++)
   {
   if(doubleCOMPRESO(iClose(symbol_,PERIOD_CURRENT,1) / MAFast(i),MinValore,minSoglia)) ExtMacdBuffer[i]=1;

   if(doubleCOMPRESO(iClose(symbol_,PERIOD_CURRENT,1) / MAFast(i),MaxValore,maxSoglia)) ExtMacdBuffer[i]=-1;
   
   if(!doubleCOMPRESO(iClose(symbol_,PERIOD_CURRENT,1) / MAFast(i),MinValore,minSoglia)) ExtMacdBuffer[i]=0;
Print(" I ",i," handle_iCustomMAFast ",handle_iCustomMAFast," MAFast(i) ",MAFast(i)," ExtMacdBuffer[i] ",ExtMacdBuffer[i]);
   }
//--- calculate Signal
   SimpleMAOnBuffer(rates_total,prev_calculated,0,InpSignalSMA,ExtMacdBuffer,ExtSignalBuffer);
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
bool doubleCOMPRESO(double priceVal, double value1, double value2)
  {
   bool a = false;
   if((priceVal <= value1 && priceVal>= value2)||(priceVal >= value1 && priceVal<= value2))
      a=true;
   return a;

  }  
//+------------------------------------------------------------------+
bool semaforoCANDELA(ushort idContatore,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   static datetime barTime[USHORT_MAX] = {0};
   if(iTime(symbol_,timeframe,0) > barTime[idContatore]){
      return (barTime[idContatore] = iTime(symbol_,timeframe,0)) >= 0;
   }
   return false;
}
double MAFast(int index)
  {
   double a =0;
   if(handle_iCustomMAFast>INVALID_HANDLE)
     {
      double valoriMAFast[];//ArraySetAsSeries(valoriMAFast,true);
      if(CopyBuffer(handle_iCustomMAFast,0,index,1,valoriMAFast)>0){a = valoriMAFast[0];}
     }
   return a;
  } 