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
string versione = "v3.00";

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
enum ImpLiv
  {
   Impul            = 1,                //Ordini ad impulso
   Livell           = 2,                //Ordini a Livello
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
enum TStop
  {
   No_TS                          = 0,  //No Trailing Stop
   Pointstop                      = 1,  //Trailing Stop in Points
   TSPointTradiz                  = 2,  //Trailing Stop in Points Traditional
   TsTopBotCandle                 = 3,  //Trailing Stop Previous Candle
   TsFibo                         = 4,  //Trailing Stop Fibonacci
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
   BEFibo                         = 2, //Breakeven Fibonacci
  };      
enum Tp
  {
   No_Tp                          = 0,    //No Tp
   TpPoints                       = 1,    //Tp in Points
   TpFibo                         = 2,    //Tp Fibonacci Manuale
   TpFiboAuto                     = 3,    //Tp Fibonacci Auto
  };
 
enum Sl
  {
   No_Sl                          = 0,    //No Stop Loss
   SlPoints                       = 1,    //Stop Loss in Points
   SlZigZag                       = 2,    //Stop Loss Picco ZigZag
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

 
input string   comment_OS =            "--- ORDER SETTINGS ---";         // --- ORDER SETTINGS ---
input int      CloseOrdDopoNumCandDalPrimoOrdine_            = 0;        //Close Single Order after n° candles lateral (0 = Disable)
input Type_Orders            Type_Orders_                    = 0;        //Type of order opening
input int      distMinPicchiMaxMin                           = 0;        //Distanza minima Picchi Max/Min (Points)              
input double   maxRappPiccSoglBuy                            = 0.68;     //Soglia Picco/Base Buy
input double   maxRappPiccSoglSell                           = 0.68;     //Soglia Picco/Base Sell
input int      numCandBuy                                    = 7;        //Numero candele di conferma Buy
input int      numCandSell                                   = 7;        //Numero candele di conferma Sell
//input bool     mantienePrimaSoglia                           = true;     //Se Non apre ord x num cand: mantiene soglia
//input ImpLiv   ImpulsoLivello                                =  1;       //Nel Delta prezzo consentito: 
input double   lotsEA                                        = 0.1;      //Lots
input ulong    magic_number                                  = 7777;     //Magic Number
input string   Commen                                        = "EA";     //Comment
input int      Deviazione                                    = 3;        //Slippage 

input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---
//input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
//input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 24;     // ZigZag: Depth
input int      InpDeviation   = 20;     // ZigZag: Deviation
input int      InptBackstep   = 12;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  0;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe


input string   comment_CAN   =       "--- FILTER CANDLE ORDERS ---";       // --- FILTER CANDLE ORDERS ---
//input bool                   OrdiniSuStessaCandela           = true;     //Abilita più ordini sulla stessa candela
bool                       OrdiniSuStessaCandela           = true;     //Orders in same CANDLE
//input bool                   OrdEChiuStessaCandela           = true;     //Abilita News Orders sulla candela di ordini già aperti e/o chiusi
bool                   OrdEChiuStessaCandela           = true;  
//input string   comment_DIR   =       "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
//input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
bool                   direzCandZero                   = false;
//input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))
bool                   direzCandUno                    = false;
//input string   comment_BRk =           "--- BREAKOUT ---"; // --- BREAKOUT ---
//input bool     BreakOutEnable = false;           //BreakOut enable   
bool     BreakOutEnable = false;           //BreakOut enable 
//input ENUM_TIMEFRAMES timeFrBreak      = PERIOD_CURRENT;   
ENUM_TIMEFRAMES timeFrBreak      = PERIOD_CURRENT;  
//input int      candPrecedent  = 100;             //Candele precedenti
int      candPrecedent  = 100;             //Candele precedenti
//input int      deltaPlus_     = 1000;            //Plus Points for BreakOut
int      deltaPlus_     = 1000;            //Plus Points for BreakOut
//input int      CandCons       = 3;
int      CandCons       = 3;

input string   comment_SL =           "--- STOP LOSS ---"; // --- STOP LOSS ---
input Sl       Sl_                      = 1;                //Tipo di Stop Loss
input int      Sl_n_pips                = 10000;            //Stop loss Points.
input double moltiplSlPiccZigzag        =   1.5;            //Moltiplicatore SL picco ZigZag

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_pips            = 2500;              //Be Start in Points
input int      Be_Step_pips             =  200;              //Be Step in Points
input double   StartBeEstensFibo        =    1.618;          //Be Start al livello estensione Fibo 
input double   StepBEEstensFibo         =    1.382;          //Be Spet al livello estensione Fibo

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points da Profit/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TSF =           "--- TRAILING STOP FIBONACCI ---";   // --- TRAILING STOP FIBONACCI ---
input double   StartTrStFibo            =  618;              //Start TrailiStop. Ad ogni passo decimale raggiunto..
input double   StepTrStFibo             =  382;              //Step TrailStop. .. lo stop si muove al decimale.

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit Type
input int      TpPoints                 = 1000;              //Take Profit Points
input string   comment_TPFibM =       "--- TAKE PROFIT FIBO MANUAL---";   // --- TAKE PROFIT FIBO MANUAL ---
input double   TP1                      =1.618;              //Estensione Take Profit 1
input int      PercTP1                  =   50;              //Percentuale Take Profit 1
input double   TP2                      =2.618;              //Estensione Take Profit 2
input int      PercTP2                  =   50;              //Percentuale Take Profit 2
input string   comment_TPFibAuto =    "--- TAKE PROFIT FIBO AUTO---"; // --- TAKE PROFIT FIBO AUTO ---
//input double   maxTPAuto                =    1;
input string   comment_TP1FibAuto =    "--- TAKE PROFIT 1 FIBO AUTO ---"; // --- TAKE PROFIT 1 FIBO AUTO ---
input double   Tp1a                     =7.618;              //Tp 1
input double   Tp1b                     =6.618;              //Tp 2
input double   Tp1c                     =5.618;              //Tp 3
input double   Tp1d                     =4.618;              //Tp 4
input double   Tp1e                     =4.236;              //Tp 5
input double   Tp1f                     =3.618;              //Tp 6
input double   Tp1g                     =2.618;              //Tp 7
input double   Tp1h                     =1.618;              //Tp 8
              

double Ask_=0;
double Bid_=0;
bool semCand = false;
double valPick[];
string symbol_ = Symbol();
bool enableTrading=true;
int handle_iCustom;// Variabile Globale
int ZigzagBufferCand[300];
double ZigzagBufferVal[300];

int     TaPr=0;
int     StopLoss=0;

double  ValPiccoLow_,ValSogliaBuy_=0;
 int    CandPiccoHigh  = 0;
 double ValPiccoHigh   = 0;
static double valHighMax,valLowMin,valPiccLow,valSogBuy=0;   //valSogBuy=0;static double valPiccLow

double  ValPiccoHigh_,ValSogliaSell_=0;
 int    CandPiccoLowS  = 0;
 double ValPiccoLowS   = 0;
static double valLowMaxS,valHighMin,valPiccHigh,valSogSell=0;   //valSogSell=0;static double valPiccHigh


double  valHigh1Buy,valHigh2Buy,valLow1Buy,valLow2Buy=0;
double  valHigh1Sell,valHigh2Sell,valLow1Sell,valLow2Sell=0;
double SogliaBuy,SogliaSell=0;
int    candHigh1Buy,candHigh2Buy,candLow1Buy,candLow2Buy,candSogliaBuy = 0;
int    candHigh1Sell,candHigh2Sell,candLow1Sell,candLow2Sell,candSogliaSell = 0;
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
     
enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);   

Ask_=Ask(Symbol());
Bid_=Bid(Symbol());

semCand = semaforoCandela(0);
if(semCand)ZIGZAG(valPick);
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
gestioneOrdiniBuy();
gestioneOrdiniSell();
}
//+------------------------------------------------------------------+
//|                      gestioneOrdiniBuy()                         |
//+------------------------------------------------------------------+  
void gestioneOrdiniBuy()
{
if(Type_Orders_==0 || Type_Orders_==1)
{
double valPicco              = 0;
int    cand                  = 0;

//BUY

static int    CandSogliaBuy  = 0;
static double ValSogliaBuy   = 0; 

   CandPiccoHigh  = 0;
   ValPiccoHigh   = 0;
    
 int    CandPiccoLow   = 0;
 double ValPiccoLow    = 0; 

 int CandPrimoPiccoBuy = 0;
 double primoPiccoBuy  = 0;
 
 int CandPrimoPiccoLow = 0;
 double primoPiccoLow  = 0; 

int    OrdBuy                = NumOrdBuy(magic_number,Commen);      
int    contaCand             = 0;   

double C1                    = iClose(symbol_,PERIOD_CURRENT,1);
int    bars                  = iBars(symbol_,PERIOD_CURRENT);
static bool   semaNumCandBuy = false;
static int    numCandPreordBuy      = 0;
//Control Buy

   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&valPicco>=ValPiccoHigh){ValPiccoHigh=valPicco;CandPiccoHigh=cand;}     //Picco Alto 
} 
  // CandPiccoLow = iLowest(symbol_,periodZigzag,MODE_LOW,CandPiccoHigh,0);  
   //ValPiccoLow  = iLow(symbol_,periodZigzag,CandPiccoLow);                             //Picco Basso   
   
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{//Print(" ValPiccoHigh-valPicco: ",ValPiccoHigh-valPicco," distMinPicchiMaxMin*Point(): ",distMinPicchiMaxMin*Point());
   if(i==0&&ValPiccoLow==0)ValPiccoLow=ValPiccoHigh;
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&
   valPicco<=ValPiccoLow
   &&cand<CandPiccoHigh
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco && iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   &&ValPiccoHigh-valPicco >= distMinPicchiMaxMin*Point())
   {ValPiccoLow=valPicco;CandPiccoLow=cand;}                                             //Picco Basso 
}              
             
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&cand<CandPiccoLow
   &&valPicco>primoPiccoBuy
   &&iOpen(symbol_,PERIOD_CURRENT,cand)<=valPicco &&iClose(symbol_,PERIOD_CURRENT,cand)<=valPicco
   &&valPicco<=((ValPiccoHigh-ValPiccoLow)*maxRappPiccSoglBuy)+ValPiccoLow
   ){primoPiccoBuy=valPicco;CandPrimoPiccoBuy=cand;}                                   //Picco Rialzo
}
   
   primoPiccoLow = primoPiccoBuy;       
   
   for(int i=0;i<CandPrimoPiccoBuy;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&cand<CandPrimoPiccoBuy
   &&valPicco<primoPiccoLow
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco
   &&iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   ){primoPiccoLow=valPicco;CandPrimoPiccoLow=cand;ValSogliaBuy=primoPiccoBuy;CandSogliaBuy=CandPrimoPiccoBuy;}         //Primo Picco Low e Valore Soglia
  // else Print("No Pattern BUY");
}   
   if(primoPiccoBuy==0){ValSogliaBuy=0;CandSogliaBuy=0;}    

   ValPiccoLow_=ValPiccoLow;ValSogliaBuy_=ValSogliaBuy;
       
   if(C1>ValSogliaBuy&&ValSogliaBuy!=0&&!semaNumCandBuy){numCandPreordBuy=bars;semaNumCandBuy=true;}
   if(ValSogliaBuy)

   if(semaNumCandBuy&&C1>=ValSogliaBuy&&primoPiccoBuy>0&&ValSogliaBuy!=0&&bars-numCandPreordBuy+1>=numCandBuy&&OrdBuy==0&&C1<=((ValPiccoHigh-ValPiccoLow)*maxRappPiccSoglBuy)+ValPiccoLow)
      //if(C1>=ValSogliaBuy&&primoPiccoBuy>0&&ValSogliaBuy!=0&&bars-numCandPreordBuy+1>=numCand&&OrdBuy==0)
      
   {TaPr=calcoloTakeProf("Buy",Ask_,ValPiccoHigh,ValPiccoLow,ValSogliaBuy);StopLoss=gestioneStopLoss("Buy",Ask_);
    SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,StopLoss,TaPr,Commen,magic_number);semaNumCandBuy=false;numCandPreordBuy=0;}   //Order BUY
   
   if((C1<ValSogliaBuy&&semaNumCandBuy)||ValSogliaBuy==0){semaNumCandBuy=false;numCandPreordBuy=0;}

//if(CandPiccoHigh&&ValPiccoHigh&&ValPiccoLow&&primoPiccoBuy&&ValSogliaBuy)
//Print(" CandPiccoHigh: ",CandPiccoHigh," ValPiccoHigh: ",ValPiccoHigh," CandPiccoLow: ",CandPiccoLow," ValPiccoLow: ",ValPiccoLow,
//      " CandPrimoPiccoBuy: ",CandPrimoPiccoBuy," primoPiccoBuy: ",primoPiccoBuy," CandSogliaBuy:",CandSogliaBuy," ValSogliaBuy: ",ValSogliaBuy);
}
}
//+------------------------------------------------------------------+
//|                      gestioneOrdiniSell()                        |
//+------------------------------------------------------------------+  
void gestioneOrdiniSell()
{
if(Type_Orders_==0 ||Type_Orders_==2)
{
double valPicco              = 0;   //uguale 
int    cand                  = 0;   //uguale 

//SELL

static int    CandSogliaSell  = 0;
static double ValSogliaSell   = 0; 

// int    CandPiccoLowS  = 0;//iHighest(symbol_,periodZigzag,MODE_HIGH,InpCandlesCheck,0);
// double ValPiccoLowS   = 0;//iHigh(symbol_,periodZigzag,CandPiccoLowS);  //Print(" CandPiccoLowS: ",CandPiccoLowS," ValPiccoLowS: ",ValPiccoLowS);

   CandPiccoLowS        = 0;                                            //Picco Low Max
   ValPiccoLowS         = 0;
    
 int    CandPiccHighS   = 0;                                            //Picco High Max
 double ValPiccoHighS   = 0; 

 int CandPrimoPiccoSell = 0;
 double primoPiccoSell  = 0;                                            //Primo picco low
 
 int CandPrimoPiccoHigh = 0;
 double primoPiccoHigh  = 0;                                            //Primo picco high

int    OrdSell          = NumOrdSell(magic_number,Commen);      
int    contaCand        = 0;   //uguale a BUY

double C1                       = iClose(symbol_,PERIOD_CURRENT,1);
int    bars                     = iBars(symbol_,PERIOD_CURRENT);
static bool   semaNumCandSell   = false;
static int    numCandPreordSell = 0;
//Control Sell


  
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)                                           
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(i==0 && valPicco!=0 && ValPiccoLowS==0)ValPiccoLowS = valPicco;
   if(valPicco>0&&valPicco<=ValPiccoLowS){ValPiccoLowS=valPicco;CandPiccoLowS=cand;}        //Picco Low Max 
} 
//Print(" CandPiccoLowS: ",CandPiccoLowS," ValPiccoLowS: ",ValPiccoLowS); 
 //  CandPiccHighS = iHighest(symbol_,periodZigzag,MODE_HIGH,CandPiccoLowS,0);               
 //  ValPiccoHighS  = iHigh(symbol_,periodZigzag,CandPiccHighS);                            //Picco High Max 
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{

   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&valPicco>=ValPiccoHighS&&cand<CandPiccoLowS
   &&iOpen(symbol_,PERIOD_CURRENT,cand)<=valPicco &&iClose(symbol_,PERIOD_CURRENT,cand)<=valPicco
   &&valPicco-ValPiccoLowS >= distMinPicchiMaxMin*Point()
   ){ValPiccoHighS=valPicco;CandPiccHighS=cand;}                                            //Picco High Max 
}     
//Print(" CandPiccHighS: ",CandPiccHighS," ValPiccoHighS: ",ValPiccoHighS); 
   
   for(int i=0;i<CandPiccHighS;i++)
{
   if(i==0 && primoPiccoSell==0) primoPiccoSell=ValPiccoHighS;
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;//Print(" primoPiccoSell: ",primoPiccoSell," ZigzagBufferVal[i]: ",ZigzagBufferVal[i]," I: ",i); 
   if(valPicco>0&&cand<CandPiccHighS
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco && iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
      
   &&valPicco<primoPiccoSell

   &&valPicco>=ValPiccoHighS-((ValPiccoHighS-ValPiccoLowS)*maxRappPiccSoglSell)  
   
   ){primoPiccoSell=valPicco;CandPrimoPiccoSell=cand;}                                      //Primo picco low
   //else {primoPiccoSell=0;CandPrimoPiccoSell=0;}
} 
//Print(" CandPrimoPiccoSell: ",CandPrimoPiccoSell," primoPiccoSell: ",primoPiccoSell); 
   
   for(int i=0;i<CandPrimoPiccoSell;i++)                                                   
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&cand<CandPrimoPiccoSell
   &&valPicco>primoPiccoHigh
   &&iOpen(symbol_,PERIOD_CURRENT,cand)<=valPicco && iClose(symbol_,PERIOD_CURRENT,cand)<=valPicco
   ){primoPiccoHigh=valPicco;CandPrimoPiccoHigh=cand;ValSogliaSell=primoPiccoSell;CandSogliaSell=CandPrimoPiccoSell;}//Primo picco high
   if(!primoPiccoSell){CandSogliaSell=0;ValSogliaSell=0;}
   //Print(" primoPiccoHigh: ",primoPiccoHigh," candPrimoPiccoHigh: ",CandPrimoPiccoHigh);
   //else Print("No Pattern SELL");                                                                                                                                 //Primo Picco High e Valore Soglia
}  
//Print(" CandSogliaSell: ",CandSogliaSell," ValSogliaSell: ",ValSogliaSell);    

   if(primoPiccoSell==0){ValSogliaSell=0;CandSogliaSell=0;}    

       ValPiccoHigh_=ValPiccoHighS;ValSogliaSell_=ValSogliaSell;
   if(C1<ValSogliaSell&&ValSogliaSell!=0&&!semaNumCandSell){numCandPreordSell=bars;semaNumCandSell=true;}
   if(ValSogliaSell)

   if(semaNumCandSell&&C1<=ValSogliaSell&&primoPiccoSell>0&&ValSogliaSell!=0&&bars-numCandPreordSell+1>=numCandSell&&OrdSell==0&&C1>=ValPiccoHighS-((ValPiccoHighS-ValPiccoLowS)*maxRappPiccSoglSell))
      
   {TaPr=calcoloTakeProf("Sell",Bid_,ValPiccoLowS,ValPiccoHighS,ValSogliaSell);StopLoss=gestioneStopLoss("Sell",Bid_);
    SendTradeSellInPoint(symbol_,lotsEA,Deviazione,StopLoss,TaPr,Commen,magic_number);semaNumCandSell=false;numCandPreordSell=0;}   //Order Sell
   
   if((C1>ValSogliaSell&&semaNumCandSell)||ValSogliaSell==0){semaNumCandSell=false;numCandPreordSell=0;}

//if(CandPiccoLowS&&ValPiccoLowS&&ValPiccoHighS&&primoPiccoSell&&ValSogliaSell)
//Print(" CandPiccoLowS: ",CandPiccoLowS," ValPiccoLowS: ",ValPiccoLowS," CandPiccHighS: ",CandPiccHighS," ValPiccoHighS: ",ValPiccoHighS,
//      " CandPrimoPiccoSell: ",CandPrimoPiccoSell," primoPiccoSell: ",primoPiccoSell," CandSogliaSell:",CandSogliaSell," ValSogliaSell: ",ValSogliaSell);
}
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
   if(a == true) Print("EA: Account Ok!");
   else
     {(Print("EA: trial license expired or Account without permission")); ExpertRemove();}
   return a;
  }
//+------------------------------------------------------------------+
//|                       calcoloStopLoss()                          |
//+------------------------------------------------------------------+  
int calcoloStopLoss(string BuySell,double openPrOrd)
{//NormalizeDouble((Ask(Symbol()) - calcolatore_SL())/Point(),Digits());
int SL=0;
if(BuySell=="Buy"){SL=(int)(Sl_n_pips);//Print(" Sl: ",StopLoss," ASK: ",Ask_," Sl_n_pips: ",Sl_n_pips);
}
if(BuySell=="Sell")SL=(int)(Sl_n_pips);//Point()*
return SL;
}
//+------------------------------------------------------------------+
//|                       calcoloTakeProf()                          |
//+------------------------------------------------------------------+
int calcoloTakeProf(string BuySell,double openPrOrd,double PickMax,double PickLow,double SoglBuy)
{
int TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1)
{
if(BuySell=="Buy")TP=(TpPoints);
if(BuySell=="Sell")TP=(TpPoints);
return TP;
}
if(TakeProfit==2){TP=gestioneTPFibo(BuySell,openPrOrd);}
if(TakeProfit==3){TP=gestioneTPFibAuto(PickMax,PickLow,SoglBuy);}
return TP;
}
//+------------------------------------------------------------------+
//|                        gestioneTPFibo                            |
//+------------------------------------------------------------------+

int gestioneTPFibo(string BuySell,double openPrOrd)//  
{
      int a = 0;
   if(BuySell=="Buy") {a = (int)((ValSogliaBuy_ - ValPiccoLow_)/Point()*TP1);if(ValSogliaBuy_==0 || ValPiccoLow_==0)a = 0;}
   if(BuySell=="Sell"){a = (int)((ValPiccoHigh_ - ValSogliaSell_)/Point()*TP1);if(ValSogliaSell_==0 || ValPiccoHigh_==0)a = 0;}
return a;
}
//+------------------------------------------------------------------+
//|                      gestioneTPFibAuto                           |static double valHighMax,valLowMin,valPiccLow,valSogBuy=0;
//+------------------------------------------------------------------+
int gestioneTPFibAuto(double PickMax,double PickLow,double SoglBuy)
{
double Tp1=0;

if(PickMax==0||SoglBuy==0||PickLow==0)return 0;
double a=SoglBuy - PickLow;
//Print(" PickMax: ",PickMax," SoglBuy: ",SoglBuy," PickLow: ",PickLow);
if(PickMax>=(a*Tp1h)+SoglBuy)Tp1=(a*Tp1h);
if(PickMax>=(a*Tp1g)+SoglBuy)Tp1=(a*Tp1g);
if(PickMax>=(a*Tp1f)+SoglBuy)Tp1=(a*Tp1f);
if(PickMax>=(a*Tp1e)+SoglBuy)Tp1=(a*Tp1e);
if(PickMax>=(a*Tp1d)+SoglBuy)Tp1=(a*Tp1d);
if(PickMax>=(a*Tp1c)+SoglBuy)Tp1=(a*Tp1c);
if(PickMax>=(a*Tp1b)+SoglBuy)Tp1=(a*Tp1b);
if(PickMax>=(a*Tp1a)+SoglBuy)Tp1=(a*Tp1a);
//Print(" a: ",a," Tp1h: ",Tp1h," a*Tp1h)+ValSogliaBuy_: ",(a*Tp1h)+SoglBuy);
//Print(" Tp1: ",Tp1);
return (int)(Tp1/Point());
}
//+------------------------------------------------------------------+
//|                     gestioneBreakEven()                          |
//+------------------------------------------------------------------+
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(Be_Start_pips, Be_Step_pips, magic_number, Commen);
if(BreakEven==2)BEFibo(StartBeEstensFibo,StepBEEstensFibo);
return BreakEv;
}
//+------------------------------------------------------------------+
//|                     gestioneTrailStop()                          |
//+------------------------------------------------------------------+
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magic_number, Commen);
if(TrailingStop==2)PositionsTrailingStopInStep(TsStart,TsStep,Symbol(),magic_number,0);
if(TrailingStop==3)TrailStopCandle_();
if(TrailingStop==4)TrailStopFibo();
return TS;
}


//+------------------------------------------------------------------+
//|                       TrailStopCandle()                          |
//+------------------------------------------------------------------+
double TrailStopCandle_()
  {
      double TsCandle=0;
   if(TicketPrimoOrdineBuy(magic_number,Commen)) TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
   
   if(TicketPrimoOrdineSell(magic_number,Commen)) TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
  return TsCandle;}
//+------------------------------------------------------------------+
//|                         TrailStopFibo()                          |    Controllare
//+------------------------------------------------------------------+  
double TrailStopFibo()
{
      double TsFibo=0;
      static int qq=0;
      static double valSogBuy_;
   if(!TicketPrimoOrdineBuy(magic_number,Commen))valSogBuy_=0;
   if(TicketPrimoOrdineBuy(magic_number,Commen)) 
{
      if(qq==0)valSogBuy_=valSogBuy;
      double StartTrStFibo_=StartTrStFibo;
      double StepTrStFibo_=StepTrStFibo;
      double OpPrBuy = OpenPricePrimoOrdineBuy(magic_number,Commen);
      ulong TikBuy = TicketPrimoOrdineBuy(magic_number,Commen);
   for(int i = 1;i<7;i++)
{//Print(" Ask_: ",Ask_," valSogBuy+(StartTrStFibo_*i*(valSogBuy - valPiccLow)): ",valSogBuy+(StartTrStFibo_*i*(valSogBuy - valPiccLow)),
      //" Pos SL: ",PositionStopLoss(TikBuy)," valSogBuy+(StepTrStFibo_*i*(valSogBuy - valPiccLow)): ",valSogBuy+(StepTrStFibo_*i*(valSogBuy - valPiccLow)));qq++;
   if(Ask_>=valSogBuy+(StartTrStFibo_*i*(valSogBuy - valPiccLow))&&PositionStopLoss(TikBuy)<OpPrBuy+(StepTrStFibo_*i*(valSogBuy - valPiccLow)))
      {PositionModify(TikBuy,OpPrBuy+(StepTrStFibo_*i*(valSogBuy - valPiccLow)),PositionTakeProfit(TikBuy));}
}
} 

   if(TicketPrimoOrdineSell(magic_number,Commen)) 
{
      double StartTrStFibo_=StartTrStFibo;
      double StepTrStFibo_=StepTrStFibo;
      double OpPrSell = OpenPricePrimoOrdineSell(magic_number,Commen);
      ulong TikSell = TicketPrimoOrdineSell(magic_number,Commen);
   for(int i = 1;i<7;i++)
{
   if(Bid_<=valSogSell-(valSogBuy - valPiccLow)-(StartTrStFibo_*i*(valSogBuy - valPiccLow))*Point()&&PositionStopLoss(TikSell)>valSogSell-(valPiccHigh - valSogSell)-(StartTrStFibo_+i)*Point()-(StepTrStFibo_+i)*Point())
      {PositionModify(TikSell,OpPrSell-(StepTrStFibo_+i)*Point(),PositionTakeProfit(TikSell));}
}
} 
return TsFibo;
}  

//+------------------------------------------------------------------+ 
//|                           ZIGZAG()                               |
//+------------------------------------------------------------------+  
double ZIGZAG(double &ZigzagBuffer[])
  {
   //int  arrSiz=0;

   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=1)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();

   for(int i=0; i<ArraySize(ZigzagBuffer); i++) {ZigzagBuffer[i]=0;}//Reset Array
   for(int i=0; i<ArraySize(ZigzagBufferCand); i++) {ZigzagBufferCand[i]=0;}//Reset Array
   for(int i=0; i<ArraySize(ZigzagBufferVal); i++) {ZigzagBufferVal[i]=0;}//Reset Array   
   
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))return  valoreZigZag;

   string text="";
   
   for(int i=0,z=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0)//&& i > 0
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(ZigzagBuffer[i]!=0.0) {ZigzagBufferCand[z]=i; ZigzagBufferVal[z]=ZigzagBuffer[i];z++;}
         if(semaforo && i >= disMinCandZZ) {valoreZigZag=ZigzagBuffer[i];semaforo=false;}
      }
     }

Comment(text);

//VisualizzaArray(ZigzagBufferCand,ZigzagBufferVal);
   return valoreZigZag;//
  } 
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
  
void VisualizzaArray(int &ZigzagBuffer_[],double &ZigzagBufferVal_[])
{
for(int i=0;i<ArraySize(ZigzagBuffer_);i++)
{
if(ZigzagBuffer_[i]!=0 && i >= disMinCandZZ)
Print(ZigzagBuffer_[i],": ",ZigzagBufferVal_[i]);
}
}

//+------------------------------------------------------------------+
//|                       gestioneStopLoss                           |
//+------------------------------------------------------------------+
int gestioneStopLoss(string BuySell,double openPrOrd)
{
int a=0;
if(Sl_==0)return 0;
if(Sl_==1)return calcoloStopLoss(BuySell,openPrOrd);
if(Sl_==2)return StopLossPiccoZigZag(BuySell,openPrOrd);
return a;
}
//+------------------------------------------------------------------+
//|                        StopLossPiccoZigZag                       |
//+------------------------------------------------------------------+
int StopLossPiccoZigZag(string BuySell,double openPrOrd)
{
int a=0;
if(BuySell=="Buy"){a=(int)((Ask_ - ValPiccoLow_)/Point()*moltiplSlPiccZigzag);}
if(BuySell=="Sell"){
//Print(" Bid: ",Bid_," ValPiccoHigh_: ",ValPiccoHigh_);
a=(int)((ValPiccoHigh_ - Bid_)/Point());}

return a;
}
//StopLoss

//+------------------------------------------------------------------+
//|                             BEFibo                               |
//+------------------------------------------------------------------+
void BEFibo (double StartBEEstFib, double StepFib)
{
ulong TikBuy=TicketPrimoOrdineBuy(magic_number,Commen);
ulong TikSell=TicketPrimoOrdineSell(magic_number,Commen);
double spread = Ask_ - Bid_;
//Print(" spread: ",spread);
if(!TikBuy){valSogBuy=ValSogliaBuy_;valPiccLow=ValPiccoLow_;}
if(TikBuy)
{
double priceOrdBuy=OpenPricePrimoOrdineBuy(magic_number);
//Print(" valSogBuy: ",valSogBuy," valPiccLow: ",valPiccLow," ((valSogBuy - valPiccLow)*StartBEEstFib)+valSogBuy: ",((valSogBuy - valPiccLow)*StartBEEstFib)+valSogBuy);
//Print(" PositionStopLoss(TikBuy): ",PositionStopLoss(TikBuy)," ((valSogBuy - valPiccLow)*StepFib)+valSogBuy: ",((valSogBuy - valPiccLow)*StepFib)+valSogBuy);
if(Ask_>((valSogBuy - valPiccLow)*StartBEEstFib)+valSogBuy&&PositionStopLoss(TikBuy)<((valSogBuy - valPiccLow)*StepFib)+valSogBuy)
{PositionModify(TikBuy,((valSogBuy - valPiccLow)*StepFib)+priceOrdBuy+spread,PositionTakeProfit(TikBuy));}
}


if(!TikSell){valSogSell=ValSogliaSell_;valPiccHigh=ValPiccoHigh_;}
if(TikSell)
{//Print(" (valSogSell-((valPiccHigh - valSogSell)*StartBEEstFib): ",valSogSell-((valPiccHigh - valSogSell)*StartBEEstFib)," valSogSell: ",valSogSell);
double priceOrdSell=OpenPricePrimoOrdineSell(magic_number);
if(Bid_<valSogSell-((valPiccHigh - valSogSell)*StartBEEstFib)&&PositionStopLoss(TikSell)>valSogSell-(valPiccHigh - valSogSell)*StepFib)
{PositionModify(TikSell,priceOrdSell-((valPiccHigh - valSogSell)*StepFib)-spread,PositionTakeProfit(TikSell));}
}
}
void Indicators()
  {
   char index=0;
     {

      ChartIndicatorAdd(0,0,handle_iCustom);
      //if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,index,indicator_handleATR);}        
     }
  } 
void resetIndicators()

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

         if(!ChartIndicatorDelete(0, window, name))
           {
            if(GetLastError() != 0)
              {
               //  PrintFormat("Delete indicator error: %d", GetLastError());
               ResetLastError();
              }
           }
         else
           {
            Print("Delete indicator with handle:", name);
           }
        }
     }
  }


