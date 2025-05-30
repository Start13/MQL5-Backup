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


#property description "The Expert Advisor is based on the levels of W. D. Gann's Square of nine, adapted to the markets of our time."
string versione = "v1.00";

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>  

//------------ Controllo Numero Licenze e tempo Trial, Corrado ----------------------
datetime TimeLicens = D'3000.01.01 00:00:00';
long NumeroAccountOk [10];
long NumeroAccount0 = NumeroAccountOk[0] = 27081543;
long NumeroAccount1 = NumeroAccountOk[1] = 8918163;
long NumeroAccount2 = NumeroAccountOk[2] = 7015565;
long NumeroAccount3 = NumeroAccountOk[3] = 7008209;
long NumeroAccount4 = NumeroAccountOk[4] = 62039500;
long NumeroAccount5 = NumeroAccountOk[5] = 62039500;
long NumeroAccount6 = NumeroAccountOk[6] = 62039500;
long NumeroAccount7 = NumeroAccountOk[7] = 62039500;
long NumeroAccount8 = NumeroAccountOk[8] = 62039500;
long NumeroAccount9 = NumeroAccountOk[9] = 62039500;

enum capitBasePerCompoundingg
  {
   Equity          = 0,
   Margine_libero  = 1,//Free margin
   Balance         = 2,
  };

enum Fuso_
  {
   GMT              = 0,
   Local            = 1,
   Server           = 2
  };
enum Type_Orders
  {
   Buy_Sell         = 0,                       //Orders Buy e Sell
   Buy              = 1,                       //Only Buy Orders
   Sell             = 2                        //Only Sell Orders
  };
enum StopLoss
  {
   SL_Pips                          = 0,         //Stop loss Points
   SL_piccoPrecedente               = 1,         //Stop loss previous Pick
  };  
enum TStop
  {
   No_TS                          = 0,  //No Trailing Stop
   Pointstop                      = 1,  //Trailing Stop in Points
   TSPointTradiz                  = 2,  //Trailing Stop in Points Traditional
   TsTopBotCandle                 = 3,  //Trailing Stop Previous Candle
  };
enum TypeCandle
  {
   Stesso     = 0,                 //Trailing Stop sul min/max della candela "index"
   Una        = 1,                 //Trailing Stop sul min/max del corpo della candela "index"
   Due        = 2,                 //Trailing Stop sul max/min del corpo della candela "index"
   Tre        = 3,                 //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE                          = 0, //No Breakeven
   BEPoints                       = 1, //Breakeven Points
  };      
enum Tp
  {
   No_Tp                          = 0,    //No Tp
   TpPoints                       = 1,    //Tp in Points
  };
enum direzCand
  {
   No                        = 0,  //Flat
   candN                     = 1,  //N° Candele congrue con l'Ordine
   candNeSuperamBody         = 2,  //N° Candele congrue e superam body cand preced                                // Incollare negli enum
   candNeSuperamShadow       = 3,  //N° Candele congrue e superam shadow cand preced
  };   
  enum nMaxPos
  {
   Una_posizione   = 1,  //Max 1 Ordine
   Due_posizioni   = 2,  //Max 2 Ordini
  };

/*
input string   comment_TT =            "--- TRADING TIME SETTINGS ---";   // --- TRADING TIME SETTINGS ---
input bool     FusoEnable = false;                       //Trading Time
input Fuso_    Fuso = 1;                                 //Time Zone Settings
input int      InpStartHour = 0;                         //Session Start Time
input int      InpStartMinute = 59;                      //Session Start Minute
input int      InpEndHour = 23;                          //Hours End of Session
input int      InpEndMinute = 58;                        //Minute End of Session
*/

 
input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =    0;        //Close Single Order after n° candles lateral (0 = Disable)
input int SpreadMax                                          =    0;        //Spread Max consentito
input Type_Orders            Type_Orders_                    =    0;        //Type of order opening
input nMaxPos                N_Max_pos                       =   1;         //Massimo numero di Ordini contemporaneamente
input double                 lotsEA                          =  0.1;        //Lots
input ulong                  magic_number                    = 7777;        //Magic Number
input string                 Commen                          = "EA";        //Comment
input int                    Deviazione                      =    3;        //Slippage 

input string   comment_CCong   =       "--- CANDELE CONGRUE ---";       // --- CANDELE CONGRUE ---
input direzCand  direzCand_    =     1;  //Permette Ordine Cand a favore: No/N°Cand/N°Cand+Body/N°Cand+Shadow     // Incollare negl'input'
input int      numCandDirez    =     1;  //Numero Candele a favore. Minimo 1.
input ENUM_TIMEFRAMES timeFrCand =   PERIOD_CURRENT; //Time Frame Candele

input int                    numPrimeCandele                 =    7;        //Numero prime candele
input double                 moltiplicatoreTP                =    2;        //Moltiplicatore per Take Profit

input string   comment_CAN   =       "--- FILTER CANDLE ORDERS ---";       // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;     //Abilita più ordini sulla stessa candela
//bool                       OrdiniSuStessaCandela           = true;     //Orders in same CANDLE
input bool                   OrdEChiuStessaCandela           = true;     //Abilita News Orders sulla candela di ordini già aperti e/o chiusi
input string   comment_DIR   =       "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))
input string   comment_BRk =           "--- BREAKOUT ---"; // --- BREAKOUT ---
input bool     BreakOutEnable = false;           //BreakOut enable   
input ENUM_TIMEFRAMES timeFrBreak      = PERIOD_CURRENT;   
input int      candPrecedent  = 100;             //Candele precedenti
input int      deltaPlus_     = 1000;            //Plus Points for BreakOut
input int      CandCons       = 3;


input string   comment_SL =           "--- STOP LOSS ---";  // --- STOP LOSS ---
input StopLoss StopLoss_                =     1;            //Type Stop Loss
input int      Sl_n_pips                = 10000;            //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";  // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_pips            = 2500;              //Be Start in Points
input int      Be_Step_pips             =  200;              //Be Step in Points

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points da Profit/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit Type
input int      TpPoints                 = 1000;              //Take Profit Points

input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe
/*
bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
int      InpDepth       = 12;     // ZigZag: Depth
int      InpDeviation   =  5;     // ZigZag: Deviation
int      InptBackstep   =  3;     // ZigZag: Backstep
int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
int     disMinCandZZ   =  3;     //Min candle distance
ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe
*/
//input string               symbol_="Symbol()";             // simbolo 


string                     symbol_=Symbol();    // simbolo 

bool semCand;

bool enableTrading=true;
int handle_iCustom;// Variabile Globale

double c1;
double o1;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
  
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Libra from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(Symbol())) return; 
  
semCand = semaforoCandela(0);   
     
enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);   
double ask=Ask(Symbol());
double bid=Bid(Symbol());

c1 = iClose(Symbol(),PERIOD_CURRENT,1);
o1 = iOpen(Symbol(),PERIOD_CURRENT,1);


CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
gestioneBreakEven();
gestioneTrailStop();
if(semCand)gestioneOrdini();
bool enableBuy=0,enableSell=0;
double sogliaBuy=0,sogliaSell=0;

  }
//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
double ASK=Ask(Symbol());
double BID=Bid(Symbol());
//double takeProf;
static int numOrdBuy=0;
static int numOrdSell=0;
static int numTakeBuy=0;
static int numTakeSell=0;

if (Type_Orders_!=2
      //&&primeCandele("Buy", numPrimeCandele,takeProf)
      && FiltroSpreadMax(SpreadMax)
      && ordini_Tipo_NumMax( "Buy",Type_Orders_,N_Max_pos,magic_number,Commen)
      && numCandeleCongrue(direzCand_,"Buy",numCandDirez,timeFrCand))
      
      {SendPosition(Symbol(),ORDER_TYPE_BUY, lotsEA,0,Deviazione, calcoloStopLoss("Buy",ASK),0,Commen,magic_number);numOrdBuy++;}//////////////   Inserimento ordine buy
if (Type_Orders_!=1
      //&&primeCandele("Sell", numPrimeCandele,takeProf)
      && FiltroSpreadMax(SpreadMax)
      && ordini_Tipo_NumMax( "Sell",Type_Orders_,N_Max_pos,magic_number,Commen) 
      && numCandeleCongrue(direzCand_,"Sell",numCandDirez,timeFrCand))
      
      {SendPosition(Symbol(),ORDER_TYPE_SELL,lotsEA,0,Deviazione, calcoloStopLoss("Sell",BID), 0,Commen,magic_number);numOrdSell++;}////// Inserimento ordine sell
Comment("Ordini Buy ",numOrdBuy,"\nOrdini Sell ",numOrdSell);      
}

//+------------------------------------------------------------------+
//|                          primeCandele()                          |
//+------------------------------------------------------------------+   
bool primeCandele(string BuySell, int primCandele, double &takeProf)
{
bool a=false;
double High=0;
double Low=0;

int candHigh=iHighest(symbol_,PERIOD_CURRENT,MODE_HIGH,primCandele+1,1);
int candLow=iLowest(symbol_,PERIOD_CURRENT,MODE_LOW,primCandele+1,1);

//if(BuySell=="Buy"||BuySell=="Sell")
//{
High=iHigh(symbol_,PERIOD_CURRENT,iHighest(symbol_,PERIOD_CURRENT,MODE_HIGH,primCandele+1,1));
Low=iLow(symbol_,PERIOD_CURRENT,iLowest(symbol_,PERIOD_CURRENT,MODE_LOW,primCandele+1,1));
//}
//Print(" Candela High: ",candHigh+1," High: ",High," Candela Low: ",candLow+1," Low: ",Low);
if(BuySell=="Buy")
{
for(int i=1;i<=primCandele+2;i++)
{//Print(" I BUY: ",i," PrimeCand:",numPrimeCandele+1);
if(o1>c1 && iOpen(Symbol(),PERIOD_CURRENT,i+1)<iClose(Symbol(),PERIOD_CURRENT,i+1)&&i==primCandele)
      {takeProf=((High-Low)*moltiplicatoreTP)+Low; a = true;break;}
if(o1<c1 || iOpen(Symbol(),PERIOD_CURRENT,i+1)>iClose(Symbol(),PERIOD_CURRENT,i+1)){a = false;break;}
}}
if(BuySell=="Sell")
{
for(int i=1;i<=primCandele+2;i++)
{//Print(" I SELL: ",i);
if(o1<c1 && iOpen(Symbol(),PERIOD_CURRENT,i+1)>iClose(Symbol(),PERIOD_CURRENT,i+1)&&i==primCandele)
      {takeProf=(High-(High-Low)*moltiplicatoreTP);a = true;break;}
if(o1>c1 || iOpen(Symbol(),PERIOD_CURRENT,i+1)<iClose(Symbol(),PERIOD_CURRENT,i+1)){a = false;break;}
}
}
return a;
} 
 
//+------------------------------------------------------------------+
//|                       controlAccounts                            |
//+------------------------------------------------------------------+
bool controlAccounts()
  {
   if(!IsConnected())
     {
      Print("No connection");
      return true;
     }
   bool a = false;
   if(AccountNumber() == NumeroAccount0 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount1 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount2 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount3 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount4 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount5 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount6 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount7 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount8 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount9 && TimeLicens > TimeCurrent()) a = true;      
   if(a == true) Print("EA Libra: Account Ok!");
   else
     {(Print("EA Libra: trial license expired or Account without permission")); ExpertRemove();}
   return a;
  }
  
double calcoloStopLoss(string BuySell,double openPrOrd)
{
double SL=0;
if(StopLoss_==0)
{
if(BuySell=="Buy")SL=openPrOrd-Sl_n_pips*Point();
if(BuySell=="Sell")SL=openPrOrd+Sl_n_pips*Point();
}
if(StopLoss_==1)
{
if(BuySell=="Buy")SL=iLow(symbol_,PERIOD_CURRENT,iLowest(symbol_,PERIOD_CURRENT,MODE_LOW,numCandDirez+2,1));
if(BuySell=="Sell")SL=iHigh(symbol_,PERIOD_CURRENT,iHighest(symbol_,PERIOD_CURRENT,MODE_HIGH,numCandDirez+2,1));
}
return SL;
}
double calcoloTakeProf(string BuySell,double openPrOrd)
{
double TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1)
if(BuySell=="Buy")TP=openPrOrd+TpPoints * Point();
if(BuySell=="Sell")TP=openPrOrd-TpPoints * Point();
return TP;
}
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(Be_Start_pips, Be_Step_pips, magic_number, Commen);
return BreakEv;
}
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magic_number, Commen);
if(TrailingStop==2)PositionsTrailingStopInStep(TsStart,TsStep,Symbol(),magic_number,0);
if(TrailingStop==3)TrailStopCandle_();
return TS;
}


//+------------------------------------------------------------------+
//|                       TrailStopCandle()                          |
//+------------------------------------------------------------------+
double TrailStopCandle_()
  {
  double TsCandle=0;
   if(TicketPrimoOrdineBuy(magic_number,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
   if(TicketPrimoOrdineSell(magic_number,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
  return TsCandle;}





ENUM_TIMEFRAMES TfToTimeframe(int tf)
{
   switch(tf)
   {
   case 00              : return PERIOD_CURRENT;
   case 1               : return PERIOD_M1;   
   case 2               : return PERIOD_M2;
   case 3               : return PERIOD_M3;
   case 4               : return PERIOD_M4;
   case 5               : return PERIOD_M5;     
   case 6               : return PERIOD_M6;
   case 10              : return PERIOD_M10;
   case 12              : return PERIOD_M12;
   case 15              : return PERIOD_M15;
   case 20              : return PERIOD_M20;
   case 30              : return PERIOD_M30;
   case 60              : return PERIOD_H1;
   case 120             : return PERIOD_H2;
   case 180             : return PERIOD_H3;
   case 240             : return PERIOD_H4;
   case 360             : return PERIOD_H6;
   case 480             : return PERIOD_H8;
   case 720             : return PERIOD_H12;
   case 1440            : return PERIOD_D1;
   case 10080           : return PERIOD_W1;
   case 43200           : return PERIOD_MN1;      
   default              : return PERIOD_CURRENT;
   }
} 
 
