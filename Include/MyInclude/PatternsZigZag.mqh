
#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>
/*// Le seguenti funzioni ombrate sono da utilizzare incollate nel codice principale insieme all'handleZigZag() e all'iGetArray
input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input char     disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe
*/

///////////// Da usare copiando e incollando le funzioni seguenti nel programma principale
/*
int handle_iCustom;// Variabile Globale

//+------------------------------------------------------------------+
//|                        handleZigZag()                            |
//+------------------------------------------------------------------+
int handleZigZag()
  {
//--- create handle of the indicator iCustom
   handle_iCustom=iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InptBackstep);
//--- if the handle is not created
   if(handle_iCustom==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iCustom indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
      return(INIT_FAILED);
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Get value of buffers                                             |
//+------------------------------------------------------------------+
double iGetArray(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
  {
   bool result=true;
   if(!ArrayIsDynamic(arr_buffer))
     {
      Print("This a no dynamic array!");
      return(false);
     }
   ArrayFree(arr_buffer);
//--- reset error code
   ResetLastError();
//--- fill a part of the iBands array with values from the indicator buffer
   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count)
     {
      //--- if the copying fails, tell the error code
      PrintFormat("Pending to copy data from the indicator");//PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
     }
   return(result);
  }  
//+------------------------------------------------------------------+Restituisce il valore Top o Bottom (shadow compresa) della candela di swing, 
//|                           ZIGZAG()                               |considerando le candele "disMinCandZZ" da superare (conferma)
//+------------------------------------------------------------------+  
double ZIGZAG()
  {
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=0)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))return  valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
           {
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
           }
        }
     }
//Print(text);
   return valoreZigZag;//
  }
//+------------------------------------------------------------------+Restituisce il valore High e Low esterno (più vicino al picco) del corpo della candela di swing (shadow escluse), 
//|                        ZIGZAGHiLo()                              |considerando le candele "disMinCandZZ" da superare (conferma)
//+------------------------------------------------------------------+
double ZIGZAGHiLo()
  {
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=0)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++){ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))
      return  valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         //text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
           {
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)){valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);}
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)){valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);}
              }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)){valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);}
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)){valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);}
              }
            semaforo=false;
           }
        }
     }
   return valoreZigZag;
  }

//+------------------------------------------------------------------+ Restituisce il valore di picco dell'ultimo zigzag. 
//|                        FilterZZBody()                            |     "  "    Il bool buy e sell: true quando il prezzo oltrepassa il valore "interno" del corpo della candela di zigzag.
//+------------------------------------------------------------------+     "  "    I valori interni della candela di zigzag
double FilterZZBody(bool &enableBuy, double &sogliaBuy, bool &enableSell, double &sogliaSell)
  {
   if(!FilterZigZag)
   {
   enableBuy=true;
   enableSell=true;
   return 0;
   }
   bool semaforo=true;
   static double valoreZigZag;
   static bool enableBuy_,enableSell_;
   static double sogliaBuy_,sogliaSell_;
   static long counter=0;
   counter++;
   if(counter>=0)
      counter=0;
   else
      return valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++)
     {
      ZigzagBuffer[i]=0;
     }
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))
      return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         //text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
         if(semaforo && 1 <= i)
           {enableBuy_=0;enableSell_=0;
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i))//Picco alto
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)){sogliaSell_=iClose(Symbol(),PERIOD_CURRENT,i);}//Candela ribassista
               
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)){sogliaSell_=iOpen(Symbol(),PERIOD_CURRENT,i);}//Candela rialzista
                     if (Bid(Symbol()) < sogliaSell_)enableSell_=true;//Print(" Bid: ",Bid(Symbol())," sogliaSell_ ",sogliaSell_);
                     if (Bid(Symbol()) >= sogliaSell_)enableSell_=false;
              }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)){sogliaBuy_=iOpen(Symbol(),PERIOD_CURRENT,i);}
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)){sogliaBuy_=iClose(Symbol(),PERIOD_CURRENT,i);}
                     if (Ask(Symbol()) > sogliaBuy_) enableBuy_=true; //Print(" Ask: ",Ask(Symbol())," sogliaBuy_ ",sogliaBuy_); 
                     if (Ask(Symbol()) <= sogliaBuy_) enableBuy_=false;   
              }
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
           }
        }
     }
   enableBuy=enableBuy_;
   enableSell=enableSell_;
   sogliaBuy=NormalizeDouble(sogliaBuy_,Digits());
   sogliaSell=NormalizeDouble(sogliaSell_,Digits());   
   return valoreZigZag;
  }
//+------------------------------------------------------------------+ Restituisce il valore di picco dell'ultimo zigzag. 
//|                        FilterZZShadow()                          |             Il bool buy e sell: true quando il prezzo oltrepassa il valore estremo interno "shadow" della candela di zigzag.(Swing Chart)
//+------------------------------------------------------------------+             I valori top e bottom della candela di zigzag
double FilterZZShadow(bool &enableBuy, double &sogliaBuy, bool &enableSell, double &sogliaSell)
  {
   if(!FilterZZShad)
   {
   enableBuy=true;
   enableSell=true;
   return 0;
   }
   bool semaforo=true;
   static double valoreZigZag;
   static bool enableBuy_,enableSell_;
   static double sogliaBuy_,sogliaSell_;
   static long counter=0;
   counter++;
   if(counter>=0)//15
      counter=0;
   else
      return valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++){ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))
      return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
         if(semaforo && 1 <= i)
           {enableBuy_=0;enableSell_=0;
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i))//Picco alto
              {
              {sogliaSell_=iLow(Symbol(),PERIOD_CURRENT,i);}
                     if (Bid(Symbol()) < sogliaSell_)enableSell_=true;//Print(" Bid: ",Bid(Symbol())," sogliaSell_ ",sogliaSell_);
                     if (Bid(Symbol()) >= sogliaSell_)enableSell_=false;
              }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i))//Picco basso
              {
              {sogliaBuy_=iHigh(Symbol(),PERIOD_CURRENT,i);}
                     if (Ask(Symbol()) > sogliaBuy_) enableBuy_=true; //Print(" Ask: ",Ask(Symbol())," sogliaBuy_ ",sogliaBuy_); 
                     if (Ask(Symbol()) <= sogliaBuy_) enableBuy_=false;   
              }
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
           }
        }
     }
   enableBuy=enableBuy_;
   enableSell=enableSell_;
   sogliaBuy=NormalizeDouble(sogliaBuy_,Digits());
   sogliaSell=NormalizeDouble(sogliaSell_,Digits());    
   return valoreZigZag;
  }
  
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
//+------------------------------------------------------------------+
//|                         ZigZag                                   |Restituisce il valore dell'ultimo picco zigzag. Controllata: OK
//+------------------------------------------------------------------+
////ZigZag(InpCandlesCheck,disMinCandZZ,periodZigzag,InpDepth,InpDeviation,InptBackstep);
double ZigZag(const int CandCheck,const int MinCand,const ENUM_TIMEFRAMES PeriodZZ,const int DepthZZ,const int DevZZ,const int BackstepZZ)
{
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   int handleiCustom;
   counter++;
   if(counter>=0)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleiCustom=HandleZigZag(PeriodZZ, DepthZZ, DevZZ, BackstepZZ);
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=CandCheck+1;   
   if(!iGetArr(handleiCustom,0,start_pos,count,ZigzagBuffer))return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++) 
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0) 
         {
         //text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && MinCand <= i) 
         {
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
         }
      }
   }
//Print(text);
   return valoreZigZag;//
}

//+------------------------------------------------------------------+ 
//|                          ZIGZAGHiLo_()                           |//Restituisce il valore High o Low (Body esterno) della candela di swing dell'ultimo picco zigzag. Controllata: OK
//+------------------------------------------------------------------+ 
////ZIGZAGHiLo_(InpCandlesCheck,disMinCandZZ,periodZigzag,InpDepth,InpDeviation,InptBackstep));
double ZIGZAGHiLo_(const int CandCheck,const int MinCand,const ENUM_TIMEFRAMES PeriodZZ,const int DepthZZ,const int DevZZ,const int BackstepZZ)
{
   bool semaforo=true;//Print(" MinCandZigZagHiLo inizio: ",MinCand);
   static double valoreZigZag;
   static long counter=0;
   int handleiCustom=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return  valoreZigZag;
//---

   handleiCustom=HandleZigZag(PeriodZZ, DepthZZ, DevZZ, BackstepZZ);
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=CandCheck+1;
      
   if(!iGetArr(handleiCustom,0,start_pos,count,ZigzagBuffer))return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++) 
   {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0) 
      {
         //text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && MinCand <= i) 
         {
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i)) 
               {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)) {valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);}
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)) {valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);}
               }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i)) 
            {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)) {valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);}
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)) {valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);}
            }
            semaforo=false;
         }
      }
   }
   return valoreZigZag;
}*/
//+------------------------------------------------------------------+ Restituisce il valore di picco dell'ultimo zigzag.
//|                       FilterZZBody_()    STILE SWING CHART       |     "  "    Il bool buy e sell: true quando il prezzo oltrepassa il valore "INTERNO" del corpo della candela di swing.
//+------------------------------------------------------------------+     "  "    I valori interni della candela di swing.
//FilterZZBody_(FilterZigZag,InpCandlesCheck,disMinCandZZ,periodZigzag,InpDepth,InpDeviation,InptBackstep,enableBuy, sogliaBuy,enableSell,sogliaSell));
double FilterZZBody_(bool FilterZigZagBody,const int CandCheck,const int MinCand,const ENUM_TIMEFRAMES PeriodZZ,const int DepthZZ,
                     const int DevZZ,const int BackstepZZ, bool &enableBuy, double &sogliaBuy, bool &enableSell, double &sogliaSell)
{
   if(!FilterZigZagBody) 
   {
      enableBuy=true;
      enableSell=true;
      return 0;
   }
   bool semaforo=true;
   static double valoreZigZag;
   static bool enableBuy_,enableSell_;
   static double sogliaBuy_,sogliaSell_;
   int handleiCustom;
   static long counter=0;
   counter++;
   if(counter>=0)//15
      counter=0;
   else
      return valoreZigZag;
//---
   handleiCustom=HandleZigZag(PeriodZZ, DepthZZ, DevZZ, BackstepZZ);
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=CandCheck+1;
   if(!iGetArr(handleiCustom,0,start_pos,count,ZigzagBuffer))
      return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++) {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0) {
         //text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && MinCand <= i)
         if(semaforo && 1 <= i) 
         {
            enableBuy_=0;
            enableSell_=0;
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i)) //Picco alto
            { 
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)) {sogliaSell_=iClose(Symbol(),PERIOD_CURRENT,i);}//Candela ribassista
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)) {sogliaSell_=iOpen(Symbol(),PERIOD_CURRENT,i);  }//Candela rialzista
               if (Bid(Symbol()) < sogliaSell_)enableSell_=true;
               if (Bid(Symbol()) >= sogliaSell_)enableSell_=false;
            }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i)) //Picco basso
            {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i)) {sogliaBuy_=iOpen(Symbol(),PERIOD_CURRENT,i);}//Candela ribassista
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)) {sogliaBuy_=iClose(Symbol(),PERIOD_CURRENT,i);}//Candela rialzista
               if (Ask(Symbol()) > sogliaBuy_) enableBuy_=true;
               if (Ask(Symbol()) <= sogliaBuy_) enableBuy_=false;
            }
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
         }
      }
   }
   enableBuy=enableBuy_;
   enableSell=enableSell_;
   sogliaBuy=NormalizeDouble(sogliaBuy_,Digits());
   sogliaSell=NormalizeDouble(sogliaSell_,Digits());//Print(" SogliaSell: ",sogliaSell);
   return valoreZigZag;
}

//+------------------------------------------------------------------+ Restituisce il valore di picco dell'ultimo zigzag.
//|                 FilterZZShadow()     Indicato per SWING CHART    |             Il bool buy e sell: true quando il prezzo oltrepassa il valore estremo interno "shadow" della candela di zigzag.(Swing Chart)
//+------------------------------------------------------------------+             I valori top e bottom della candela di zigzag
//FilterZZShadow_( FilterZZShad, InpCandlesCheck,disMinCandZZ,periodZigzag,InpDepth,InpDeviation,InptBackstep,enableBuy, sogliaBuy,enableSell,sogliaSell);
double FilterZZShadow_
(bool FilterZZShadow,const int CandCheck,const int MinCand,const ENUM_TIMEFRAMES PeriodZZ,const int DepthZZ,const int DevZZ,const int BackstepZZ, 
 bool &enableBuy, double &sogliaBuy, bool &enableSell, double &sogliaSell)
{
   if(!FilterZZShadow) 
   {
      enableBuy=true;
      enableSell=true;
      return 0;
   }
   bool semaforo=true;
   static double valoreZigZag;
   static bool enableBuy_,enableSell_;
   static double sogliaBuy_,sogliaSell_;
   int handleiCustom;
   static long counter=0;
   counter++;
   if(counter>=0)
      counter=0;
   else
      return valoreZigZag;
//---
   handleiCustom=HandleZigZag(PeriodZZ, DepthZZ, DevZZ, BackstepZZ);
   HandleZigZag(PeriodZZ, DepthZZ, DevZZ, BackstepZZ);
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=CandCheck+1;
   if(!iGetArr(handleiCustom,0,start_pos,count,ZigzagBuffer))return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++) {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0) 
      {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && MinCand <= i)
         if(semaforo && 1 <= i) 
            {
            enableBuy_=0;
            enableSell_=0;
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i)) //Picco alto
            { 
               {sogliaSell_=iLow(Symbol(),PERIOD_CURRENT,i);}
               if (Bid(Symbol()) < sogliaSell_)enableSell_=true;
               if (Bid(Symbol()) >= sogliaSell_)enableSell_=false;
            }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)&&ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i)) //Picco basso
            {
               {sogliaBuy_=iHigh(Symbol(),PERIOD_CURRENT,i);}
               if (Ask(Symbol()) > sogliaBuy_) enableBuy_=true;
               if (Ask(Symbol()) <= sogliaBuy_) enableBuy_=false;
            }
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
         }
      }
   }
   enableBuy=enableBuy_;
   enableSell=enableSell_;
   sogliaBuy=NormalizeDouble(sogliaBuy_,Digits());
   sogliaSell=NormalizeDouble(sogliaSell_,Digits());
   return valoreZigZag;
}
//+------------------------------------------------------------------+
//|                        handleZigZag()                            |
//+------------------------------------------------------------------+
int HandleZigZag(const ENUM_TIMEFRAMES PeriodZZ,const int DepthZZ,const int DevZZ,const int BackstepZZ)
{
//--- create handle of the indicator iCustom
   int handleiCustom=iCustom(Symbol(),PeriodZZ,"Examples\\ZigZag",DepthZZ,DevZZ,BackstepZZ);
//--- if the handle is not created
   if(handleiCustom==INVALID_HANDLE) {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iCustom indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
      return(INIT_FAILED);
   }
   return(handleiCustom);
}

//+------------------------------------------------------------------+
//| Get value of buffers                                             |
//+------------------------------------------------------------------+
double iGetArr(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
{
   bool result=true;
   if(!ArrayIsDynamic(arr_buffer)) {
      Print("This a no dynamic array!");
      return(false);
   }
   ArrayFree(arr_buffer);
//--- reset error code
   ResetLastError();
//--- fill a part of the iBands array with values from the indicator buffer
   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count) {
      //--- if the copying fails, tell the error code
      PrintFormat("Pending to copy data from the indicator");//PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
   }
   return(result);
}

//-----------------------------ICustom () Custom ZigZag -------------------------------------------------

//+------------------------------------------------------------------+
//|                              zigzag()                            |
//+------------------------------------------------------------------+
double zigzag()
  {
   double a =0;
   int handleiCustom = iCustom(Symbol(),PERIOD_CURRENT,"Examples\\ZigZag");
   if(handleiCustom>INVALID_HANDLE)
     {
      double valoriiCustom[];
      if(CopyBuffer(handleiCustom,0,0,1,valoriiCustom)>0) {a = valoriiCustom[0];}
     }
   return a;
  }
  
//+------------------------------------------------------------------+
//|                          zigzagPicchi()                          |
//+------------------------------------------------------------------+

/*
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InpBackstep    =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: numero candele analizzate
input int      MinCandZZ      =  3;     // Minimo di candele per approvare il valore dell'ultimo ZigZag
input ENUM_TIMEFRAMES timeframeZZ = PERIOD_CURRENT;    // Time frame ZigZag

double valoriZZ[]; int indexZZ[];

zigzagPicchi( InpDepth, InpDeviation, InpBackstep, InpCandlesCheck, MinCandZZ, TimeframeZZ,valoriZZ, indexZZ);
*/
double zigzagPicchi(int Depth,int Deviation,int Backstep,int candleCheck,int MinCand,ENUM_TIMEFRAMES timeframeZZ,double &valoriZZ[], int &indexZZ[])
  {
   int handleiCustom = iCustom(Symbol(),timeframeZZ,"Examples\\ZigZag",Depth,Deviation,Backstep);
   if(handleiCustom>INVALID_HANDLE)
     {
      double datiZZ[];   
      
      ArraySetAsSeries(datiZZ,true);
     
      ArrayInitialize(datiZZ,0);
       
      if(CopyBuffer(handleiCustom,0,0,candleCheck,datiZZ)>0) 
      {
      ArrayResize(valoriZZ,candleCheck+1);ArrayResize(indexZZ,candleCheck+1);////////////Ultima modifica
      ArrayInitialize(valoriZZ,0);ArrayInitialize(indexZZ,0);
     int conta = 0;
      for(int i=0;i<ArraySize(datiZZ);i++)
         {
         if(datiZZ[i]!=0 && i>=MinCand)
         {valoriZZ[conta]=datiZZ[i];indexZZ[conta]=i;//Print( conta," I: ",i," ",valoriZZ[conta]);
         conta++;}
         }
   }
   }
   return valoriZZ[0];
   }
   
//------------------------------------- tipopiccozigzag() ----------------------------------------------- Restituisce il Tipo di picco. Up: picco alto,Dw picco basso
string tipopiccozigzag(double pik,int barra,ENUM_TIMEFRAMES timeframe)
{
string a = "";
if(pik > iOpen(Symbol(),timeframe,barra) || pik > iClose(Symbol(),timeframe,barra)) a = "Up";
if(pik < iOpen(Symbol(),timeframe,barra) || pik < iClose(Symbol(),timeframe,barra)) a = "Dw";
return a;
}  
 
//+------------------------------------------------------------+Restituisce true quando BuySell == Buy, bodyshadow == 0, ultimo picco supera in barre MinCand e l'ultimo picco è basso
//|                        zigzagBodyShadow()                  |Restituisce true quando BuySell == Buy, bodyshadow == 1, ultimo picco supera in barre MinCand, l'ultimo picco è basso e prezzo è superiore al body
//+------------------------------------------------------------+Restituisce true quando BuySell == Buy, bodyshadow == 2, ultimo picco supera in barre MinCand, l'ultimo picco è basso e prezzo è superiore alla shadow

bool zigzagBodyShadow(string BuySell,int bodyshadow,bool candela0, string symbol,int Depth,int Deviation,int Backstep,int candleCheck,int MinCand,ENUM_TIMEFRAMES timeframeZZ)
  {
   bool a = false;
   if(!candela0 && MinCand==0){Alert("In questa versione di Zig Zag (Body/Shadow) il Numero minimo di candele check è: 1");return a;}
   if(bodyshadow==-1) {a=true;return a;}
   double valorezz=0; 
   int indexZZ=0;
   int handleiCustom = iCustom(Symbol(),timeframeZZ,"Examples\\ZigZag",Depth,Deviation,Backstep);
   
   if(handleiCustom<=INVALID_HANDLE){a=false;return a;}
   if(handleiCustom>INVALID_HANDLE)
     {
      double datiZZ[];        
      ArraySetAsSeries(datiZZ,true);
      ArrayInitialize(datiZZ,0);

      if(CopyBuffer(handleiCustom,0,0,candleCheck,datiZZ)>0) 
      {
       for(int i=0;i<ArraySize(datiZZ);i++) 
         {
          if(!candela0 && datiZZ[0]>0) {a=false;return a;}                                     //I valori sulla candela di 0 vengono rifiutati
          if(datiZZ[i]!=0 && i>=MinCand){valorezz=datiZZ[i];indexZZ=i; break;}}}}

   double open  = iOpen(symbol,timeframeZZ,indexZZ);
   double close = iClose(symbol,timeframeZZ,indexZZ); 
      
      if(BuySell=="Buy" && (valorezz < open || valorezz < close))
         {//Print(" ASK ",Ask(symbol)," iHigh(symbol,timeframeZZ,indexZZ) ",iHigh(symbol,timeframeZZ,indexZZ));
          if(bodyshadow==0 && Ask(symbol) >= valorezz) {a=true;return a;}
          if(bodyshadow==1 && Ask(symbol) >= valoreSuperiore(open,close)) {a=true;return a;}
          if(bodyshadow==2 && Ask(symbol) >= iHigh(symbol,timeframeZZ,indexZZ)) {a=true;return a;}
         }
      
      if(BuySell=="Sell" && (valorezz > open || valorezz > close))
         {
          if(bodyshadow==0 && Bid(symbol) <= valorezz) {a=true;return a;}
          if(bodyshadow==1 && Bid(symbol) <= valoreInferiore(open,close)) {a=true;return a;}
          if(bodyshadow==2 && Bid(symbol) <= iLow(symbol,timeframeZZ,indexZZ)) {a=true;return a;}
         }
   return a;
   } 
   
//+------------------------------------------------------------------+
//|                       resetIndicators()                          |
//+------------------------------------------------------------------+
void resetIndicators(string indicatordelete)

  {
   int num_windows = (int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);

   for(int window = num_windows - 1; window > -1; window--)
     {
      int numIndicators = ChartIndicatorsTotal(0, window);

      for(int index = numIndicators; index >= 0; index--)
        {
         ResetLastError();

         string name = ChartIndicatorName(0, window, index);

         if(GetLastError() != 0)
           {
            //PrintFormat("ChartIndicatorName error: %d", GetLastError());
            ResetLastError();
           }
         
         if(name == indicatordelete)  
            {ChartIndicatorDelete(0, window, indicatordelete); Print("Delete indicator with handle:", indicatordelete);}

        }
     }
  }    