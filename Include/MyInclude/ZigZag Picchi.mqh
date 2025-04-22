#include <MyLibrary\MyLibrary.mqh>
/*
input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---                                      // Incollare dopo "enum""
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe
*/
//int Handle_iCustomZigZag=iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InptBackstep); // Incollare in OnInit
/*                                                                                                               // Esempio di visualizzazione dati
  int IndexZZ[1000];
  double ValZZ[1000];
  
	ZIGZAGPik(IndexZZ,ValZZ,Handle_iCustomZigZag,InpDepth,InpCandlesCheck,disMinCandZZ);
	for(int i=0;i<ArraySize(ValZZ);i++)
	{
	if(ValZZ[i]!=0)Print(" index ",IndexZZ[i],": ",ValZZ[i]);
	}
	*/
//+------------------------------------------------------------------+
//|                            ZIGZAGPik()                           |
//+------------------------------------------------------------------+

double ZIGZAGPik(int &ZigzagCandele[], double &ZigzagValori[], int HandleiCustomZigZag=0, int INPDepth=0, int INPCandlesCheck=0, int dISMinCandZZ=0)
  {
   
   bool semaforo=true;
   static double valoreZigZag;
   static int conta=0;
   static long counter=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return  valoreZigZag;

   double ZigzagBuffer[];

   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}
   for(int i=0; i<ArraySize(ZigzagCandele); i++) {ZigzagCandele[i]=0;}
   for(int i=0; i<ArraySize(ZigzagValori); i++) {ZigzagValori[i]=0;}
   ArraySetAsSeries(ZigzagBuffer,true);ArraySetAsSeries(ZigzagCandele,true);ArraySetAsSeries(ZigzagValori,true);
   int start_pos=0,count=INPCandlesCheck+1;
   if(!iGetArrayzzPik(HandleiCustomZigZag,0,start_pos,count,ZigzagBuffer))
      return  valoreZigZag;
   
   conta=0;
   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0)
        {
         ZigzagCandele[conta]=i;ZigzagValori[conta]=ZigzagBuffer[i];conta++;
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && dISMinCandZZ <= i)
           {
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
           }
        }
     }
   Comment(text);
   //Print(text);
   return valoreZigZag;//
  }

//+------------------------------------------------------------------+
//|                        handleZigZagPik()                         |
//+------------------------------------------------------------------+
int handleZigZagPik(int HandleiCustomZigZag=0)
  {
//--- create handle of the indicator iCustom
//   Handle_iCustomZigZag=iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",INPDepth,InpDeviation,InptBackstep);
//--- if the handle is not created
   if(HandleiCustomZigZag==INVALID_HANDLE)
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
double iGetArrayzzPik(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
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

//------------------------------------- ultimopicco() ----------------------------------------------- 
double ultimopicco(string ordBuySell,int InpDepthZZ,int InpDeviationZZ,int InpBackstepZZ,int InpCandlesCheckZZ,ENUM_TIMEFRAMES timeframeZZ)
{
double a = 0;

int IndiceZZ[100];ArrayInitialize(IndiceZZ,0);                                                          // Escludere se vengono riportati gli array IndiceZZ e ValoriZZ (riferimento) o sono nelle globali
double ValoriZZ[100];ArrayInitialize(ValoriZZ,0);                                                       // Escludere se vengono riportati gli array IndiceZZ e ValoriZZ (riferimento) o sono nelle globali
zigzagPicchi(InpDepthZZ,InpDeviationZZ,InpBackstepZZ,InpCandlesCheckZZ,0,timeframeZZ,ValoriZZ,IndiceZZ);// Escludere se vengono riportati gli array IndiceZZ e ValoriZZ (riferimento) o sono nelle globali
int barra = 0;
for(int i=0;i<ArraySize(ValoriZZ);i++)
{if(ordBuySell=="Buy"  && ValoriZZ[i] != 0 && IndiceZZ[i] != 0 && tipopiccozigzag(ValoriZZ[i],IndiceZZ[i],timeframeZZ)=="Dw") {a = ValoriZZ[i];barra = IndiceZZ[i];return a;}
 if(ordBuySell=="Sell" && ValoriZZ[i] != 0 && IndiceZZ[i] != 0 && tipopiccozigzag(ValoriZZ[i],IndiceZZ[i],timeframeZZ)=="Up") {a = ValoriZZ[i];barra = IndiceZZ[i];return a;}
}
return a;
}  
  