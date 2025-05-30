//+------------------------------------------------------------------+
//|                                                 Struttura EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor Ofiuco is based on the levels zig zag"
string versione = "v1.00";

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>

//------------ Controllo Numero Licenze e tempo Trial, Corrado ----------------------
datetime TimeLicens = D'3000.01.01 00:00:00';
int NumeroAccount0 = 27081543;
int NumeroAccount1 = 8918163;
int NumeroAccount2 = 7015565;
int NumeroAccount3 = 7008209;
int NumeroAccount4 = 62039500;
char NumeroAccountMax = 1;
long NumeroAccountOk [10];

enum capitBasePerCompoundingg
  {
   Equity                           = 0,
   Margine_libero                   = 1,//Free margin
   Balance                          = 2,
  };

enum Fuso_
  {
   GMT              = 0,
   Local            = 1,
   Server           = 2
  };
enum Type_Orders
  {
   Buy_Sell    = 0,                       //Orders Buy e Sell
   Buy         = 1,                       //Only Buy Orders
   Sell        = 2                        //Only Sell Orders
  };


input string   comment_MM =            "--- MONEY MANAGEMENT ---";   // --- MONEY MANAGEMENT ---
input bool     compounding =           true;                         //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;         //Reference capital for Compounding
input double   lotsEA =                0;                            //Lots
input double   riskEA =                0;                            //Risk in % [0-100]
input double   riskDenaroEA =          20;                           //Risk in money
input double   commissioni =           6;                            //Commissions per lot

input string   comment_TT =            "--- TRADING TIME SETTINGS ---";   // --- TRADING TIME SETTINGS ---
input bool     FusoEnable = false;                       //Trading Time
input Fuso_    Fuso = 1;                                 //Time Zone Settings
input int      InpStartHour = 0;                         //Session Start Time
input int      InpStartMinute = 59;                      //Session Start Minute
input int      InpEndHour = 23;                          //Hours End of Session
input int      InpEndMinute = 58;                        //Minute End of Session


input ulong                  magic_number                    = 7777;      //Magic Number
input string                 Commen                          = "EA LIBRA";//Comment
input int                    Deviazione                      = 3;         //Slippage

//--- input parameters
input int      InpDepth       = 12;    // ZigZag: Depth
input int      InpDeviation   = 5;     // ZigZag: Deviation
input int      InptBackstep   = 3;     // ZigZag: Backstep
input ENUM_TIMEFRAMES TimeFeameZigZag         = PERIOD_M15;
input uchar    InpCandlesCheck= 210;   // ZigZag: how many candles to check back

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string commentoLinee = "Proprietà per le linee (numero linee totali 100)";
//input int distanzaLinee = 50;
//input int lineeSotto = 50;
input int stile = 2;
input color coloreLinee = clrWhite;

input int DistanzaMinLev = 100;
input int DistanzaTP     = 100;

double prezziLinee[100];
double PuntoPartenzaGriglia;
int numeroLineeTotali = 100;

int contatore = 0;

double capitaleBasePerCompounding;

double ZIgzagBuffer[];
double ZigzagPicchi[1000];

int   handle_iCustom;                  // variable for storing the handle of the iCustom indicator

bool enableTrading=true;

int con=0;

string nomeLinea = "linea";
int ArrayIndex[1000];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(TimeLicens < TimeCurrent())
     {
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Print("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      ExpertRemove();
     }
     
   con = 0;
   
   if(capitBasePerCompounding1 == 0)
      capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_EQUITY);
   if(capitBasePerCompounding1 == 1)
      capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(capitBasePerCompounding1 == 2)
      capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_BALANCE);

//--- create handle of the indicator iCustom
   handle_iCustom=iCustom(Symbol(),TimeFeameZigZag,"Examples\\ZigZag",InpDepth,InpDeviation,InptBackstep);
//--- if the handle is not created
   if(handle_iCustom==INVALID_HANDLE)
     {
      PrintFormat("Failed to create handle of the iCustom indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(TimeFeameZigZag),
                  GetLastError());
      return(INIT_FAILED);
     }
   return(INIT_SUCCEEDED);  
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
   DeleteLinea();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(TimeLicens < TimeCurrent())
     {
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Print("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      ExpertRemove();
     }

   enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);
//if(NuovaCandela()){Print("EnableOrdersForDistance: ",EnableOrdersForDistance());}

   static long counter=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return;

   ArraySetAsSeries(ZIgzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZIgzagBuffer))
      return;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZIgzagBuffer[i]!=PLOT_EMPTY_VALUE && ZIgzagBuffer[i]!=0.0 && i!=0)
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZIgzagBuffer[i],Digits());
         PendenzaTrendLine(i,ZIgzagBuffer);
     }
   Comment(text);
   static double PrimoZigZag=ZigzagPicchi[1];
   static int Day_=Day();
   static string TimeFrame=StringTimeFrame(0);

//Print("ZigzagPicchi[0]: ",ZigzagPicchi[0]," Day(): ",Day()," Day_: ",Day_," con: ",con," StringTimeFrame(0);: ",StringTimeFrame(0));
   if(ZigzagPicchi[1]!=PrimoZigZag||Day_!=Day()||TimeFrame!=StringTimeFrame(0)||con<1)
     {
      con++;
      TimeFrame=StringTimeFrame(0);
      PrimoZigZag=ZigzagPicchi[1];
      Day_=Day();
      DeleteLinea();
      inizializzaGriglia();
      disegnaLinee();
     }
//if(con<1){DeleteLinea();inizializzaGriglia();disegnaLinee();con++;}
//if(Minute()||NuovaCandela()){DeleteLinea();inizializzaGriglia();disegnaLinee();}//////// Se usato la griglia compare subito

   GestioneOrdiniOfiuco();
  }

//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
//---

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
      PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
     }
   return(result);

  }

//+------------------------------------------------------------------+
//|                    inizializzaGriglia()                          | inizializzazione array ZigzagPicchi, riempimento picchi != 0 in ZigzagPicchi[], primo picco in PuntoPartenzaGriglia
//+------------------------------------------------------------------+
void inizializzaGriglia()
  {

   for(int i=0; i<ArraySize(ZigzagPicchi); i++)
     {
      ZigzagPicchi[i]=0.0;
     }
   for(int a=0,i=0; i<=InpCandlesCheck; i++)
     {
      if(ZIgzagBuffer[i]!=0.0&&i!=0)
        {
         ZigzagPicchi[a]=ZIgzagBuffer[i];
         a++;
        }
     }
   PuntoPartenzaGriglia = ZigzagPicchi[0];
  }

//+------------------------------------------------------------------+
//|                      disegnaLinee()                              |
//+------------------------------------------------------------------+
void disegnaLinee()
  {
   double prezzoLinea = 0;
   for(int a=0,i=0; i<InpCandlesCheck; i++,a++)
     {
      if(ZigzagPicchi[i]!=0.0)
        {
         prezzoLinea = ZigzagPicchi[i];
         creazioneLinea(i,prezzoLinea);
         ArrayIndex[i]=i+1;
        }
     }
  }

//+------------------------------------------------------------------+
//|                       creazioneLinea()                           |creazione ogetto per linea orizzontale (disegnare la linea sul grafico)
//+------------------------------------------------------------------+
void creazioneLinea(int indexLinea,double valorePrezzo)
  {
   string nomeLinea_="linea";
   if(valorePrezzo!=0.0)
     {
      StringAdd(nomeLinea_," "+IntegerToString(indexLinea));
      if(!ObjectCreate(0,nomeLinea_,OBJ_HLINE,0,0,valorePrezzo))
        {
         Print("Errore di creazione linea in ",__FUNCTION__,GetLastError());
         return;
        }
      ObjectSetInteger(0,nomeLinea_,OBJPROP_COLOR,coloreLinee);
      ObjectSetInteger(0,nomeLinea_,OBJPROP_STYLE,stile);
     }
  }

//+------------------------------------------------------------------+
//|                        NuovaCandela()                             |
//+------------------------------------------------------------------+
bool NuovaCandela()
  {
   static int a = iBars(Symbol(),PERIOD_CURRENT);
   bool b = false;
   if(a != iBars(Symbol(),PERIOD_CURRENT))
     {
      b=true;
      a = iBars(Symbol(),PERIOD_CURRENT);
     }
   return b;
  }

//+------------------------------------------------------------------+
//|                    EnableOrdersForDistance()                     |
//+------------------------------------------------------------------+
bool EnableOrdersForDistance()
  {
   bool a=true;

   double ask= Ask(Symbol(),1);
   double bid= Bid(Symbol(),1);
   int distanceMinLev = (int)(DistanzaMinLev*Point());

   for(int i = 0; i<ArraySize(ZIgzagBuffer); i++)
     {
      if(ZigzagPicchi[i])
        {
         if((ask) <= (ZIgzagBuffer[i]+distanceMinLev) || (bid) <=ZIgzagBuffer[i]-distanceMinLev)
           {
            a=false;
           }
        }
     }
   return a;
  }

//+------------------------------------------------------------------+
//|                      GestioneOrdiniOfiuco()                      |
//+------------------------------------------------------------------+
void GestioneOrdiniOfiuco()
  {//Print("NuovaCandela(): ",NuovaCandela()," EnableOrdersForDistance() :",EnableOrdersForDistance()," SegnoCandPreced(): ",SegnoCandPreced());
   if(NuovaCandela())
     {
      //Print("NuovaCandela(): ",NuovaCandela()," EnableOrdersForDistance() :",EnableOrdersForDistance()," SegnoCandPreced(): ",SegnoCandPreced());
  
   if(EnableOrdersForDistance() && SegnoCandPreced()=="Buy")
     {//Print("Buy: ","NuovaCandela(): ",NuovaCandela()," EnableOrdersForDistance() :",EnableOrdersForDistance()," SegnoCandPreced(): ",SegnoCandPreced()," myLotSize(): ",myLotSize());
     SendPosition(Symbol(),ORDER_TYPE_BUY, myLotSize(),0,Deviazione,ValoreSL(),ValoreTP(),Commen,magic_number);}
   if(EnableOrdersForDistance() && SegnoCandPreced()=="Sell")
     {//Print("Sell: ","NuovaCandela(): ",NuovaCandela()," EnableOrdersForDistance() :",EnableOrdersForDistance()," SegnoCandPreced(): ",SegnoCandPreced()," myLotSize(): ",myLotSize());
     SendPosition(Symbol(),ORDER_TYPE_SELL, myLotSize(),0,Deviazione,ValoreSL(),ValoreTP(),Commen,magic_number);}
  }
}
//+------------------------------------------------------------------+
//|                        SegnoCandPreced()                         |
//+------------------------------------------------------------------+
string SegnoCandPreced()
  {
   string a="";
   if(iOpen(Symbol(),PERIOD_CURRENT,1)>iClose(Symbol(),PERIOD_CURRENT,1))
     {a="Sell";}
   if(iOpen(Symbol(),PERIOD_CURRENT,1)<=iClose(Symbol(),PERIOD_CURRENT,1))
     {a="Buy";}
   return a;
  }

//+------------------------------------------------------------------+
//|                         myLotSize()                              |
//+------------------------------------------------------------------+
double myLotSize()
  {
   return myLotSize(compounding,AccountEquity(),capitaleBasePerCompounding,lotsEA,riskEA,riskDenaroEA,(int)ValoreSL(),commissioni);
  }

//+------------------------------------------------------------------+
//|                         ValoreSL()                               |
//+------------------------------------------------------------------+
double ValoreSL()
  {
   double a=0.0;
   if(SegnoCandPreced()=="Buy")
     {a = (iLow(Symbol(),PERIOD_CURRENT,1));}
   if(SegnoCandPreced()=="Sell")
     {a = (iHigh(Symbol(),PERIOD_CURRENT,1));}
   return a;
  }

//+------------------------------------------------------------------+
//|                         ValoreTP()                               |
//+------------------------------------------------------------------+
double ValoreTP()
  {
   double a=0.0;
   if(SegnoCandPreced()=="Buy")
     {a=Ask(Symbol(),1)+DistanzaTP*Point();}
   if(SegnoCandPreced()=="Sell")
     {a=Bid(Symbol(),1)-DistanzaTP*Point();}
   if(SegnoCandPreced()=="")
     {a=0.0;}
   return a;
  }

//+------------------------------------------------------------------+
//|                         DeleteLinea()                            |
//+------------------------------------------------------------------+
void DeleteLinea()
  {
   string nomeLinea_="linea";
   for(int i=0; i<ArraySize(ArrayIndex); i++)
     {
      nomeLinea_="linea";
      if(ArrayIndex[i]!=0)
        {
         StringAdd(nomeLinea_," "+IntegerToString(ArrayIndex[i]-1));
         if(ObjectFind(0,nomeLinea_)>=0)
            ObjectDelete(0,nomeLinea_);
        }
     }
   /*
   for(int i=0;i<ArraySize(ArrayIndex);i++)
   {
   ArrayIndex[i]=0;
   }
   */
  }
//+------------------------------------------------------------------+
//|                         PendenzaTrendLine()                      |
//+------------------------------------------------------------------+
double PendenzaTrendLine(int i, const double &ZigZagBuffer[])
{
double pend = 0;
double Picchi[1000];
int numCandele[1000];
   for(int i=0; i<ArraySize(ZigZagBuffer); i++)
     {
      if(ZIgzagBuffer[i]!=PLOT_EMPTY_VALUE && ZIgzagBuffer[i]!=0.0 && i!=0)
         {Picchi[i]=ZIgzagBuffer[i]; numCandele[i]=i;pend=(Picchi[i]-Picchi[i-1])/numCandele[i];//Print(" Picchi[i]: ",Picchi[i]," numCandele[i]: ",numCandele[i]," pend: ",pend);
         }
     }
return pend;
}

