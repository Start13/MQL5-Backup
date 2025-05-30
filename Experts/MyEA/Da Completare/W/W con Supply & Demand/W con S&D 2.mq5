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

#property description "The Expert Advisor..."
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
   TpMaxMin                       = 4,    //Tp Max precedente (Buy), Min preced (Sell)
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
input int      distMinPicchi2_3                              = 0;        //Distanza minima Picchi 2 e 3 (Points)              
input double   maxRappPiccSoglBuy                            = 0.68;     //Soglia Picco/Base Buy
input double   maxRappPiccSoglSell                           = 0.68;     //Soglia Picco/Base Sell
input int      numCandBuy                                    = 7;        //Numero candele di conferma Buy
input int      numCandSell                                   = 7;        //Numero candele di conferma Sell
//input bool     mantienePrimaSoglia                           = true;     //Se Non apre ord x num cand: mantiene soglia
//input ImpLiv   ImpulsoLivello                                =  1;       //Nel Delta prezzo consentito: 
input double   lotsEA                                        = 0.1;      //Lots
input ulong    magic_number                                  = 7777;     //Magic Number
input string   Commen                                        = "EA";     //Comment
input int      Deviazione                                    = 0;        //Slippage 

input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---
//input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
//input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 24;     // ZigZag: Depth
input int      InpDeviation   = 20;     // ZigZag: Deviation
input int      InptBackstep   = 12;     // ZigZag: Backstep
input int    InpCandlesCheck  =300;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  1;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe

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
 
input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading 
 
input string   comment_Supply_Demand = "--- Supply & Demand ---";// "--- Supply & Demand ---"
input bool                 filtroDom_Offerta = false;           // Filtro Zone Domanda Offerta
//input bool                 domOffInChart     = true;           // Domanda & Offerta visibile
input int                  distSupp_Dem  = 1000;               // Distanza Points da zone S&D per Ordini
 
input ENUM_TIMEFRAMES      Timeframe = PERIOD_CURRENT;         // Timeframe
input int                  BackLimit = 1000;                   // Back Limit
input bool                 HistoryMode = false;                // History Mode (with double click)

input string               zone_settings = "--- Zone Settings ---";
input bool                 zone_show_weak = false;             // Show Weak Zones
input bool                 zone_show_untested = true;          // Show Untested Zones
input bool                 zone_show_turncoat = true;          // Show Broken Zones
input double               zone_fuzzfactor = 0.75;             // Zone ATR Factor
input bool                 zone_merge = true;                  // Zone Merge
input bool                 zone_extend = true;                 // Zone Extend
input double               fractal_fast_factor = 3.0;          // Fractal Fast Factor
input double               fractal_slow_factor = 6.0;          // Fractal slow Factor              

input string               alert_settings= "--- Alert Settings ---";
input bool                 zone_show_alerts  = false;        // Trigger alert when entering a zone
input bool                 zone_alert_popups = true;         // Show alert window
input bool                 zone_alert_sounds = true;         // Play alert sound
input bool                 zone_send_notification = false;   // Send notification when entering a zone
input int                  zone_alert_waitseconds = 300;     // Delay between alerts (seconds)

input string               drawing_settings = "--- Drawing Settings ---";
input string               string_prefix = "SRRR";             // Change prefix to add multiple indicators to chart
input bool                 zone_solid = true;                  // Fill zone with color
input int                  zone_linewidth = 1;                 // Zone border width
input ENUM_LINE_STYLE      zone_style = STYLE_SOLID;           // Zone border style
input bool                 zone_show_info = true;              // Show info labels
input int                  zone_label_shift = 10;              // Info label shift
input string               sup_name = "Sup";                   // Support Name
input string               res_name = "Res";                   // Resistance Name
input string               test_name = "Retests";              // Retest Name
input int                  Text_size = 8;                      // Text Size
input string               Text_font = "Courier New";          // Text Font
input color                Text_color = clrAzure;              // Text Color
input color color_support_weak     = clrDarkSlateGray;         // Color for weak support zone
input color color_support_untested = clrSeaGreen;              // Color for untested support zone
input color color_support_verified = clrGreen;                 // Color for verified support zone
input color color_support_proven   = clrLimeGreen;             // Color for proven support zone
input color color_support_turncoat = clrOliveDrab;             // Color for turncoat(broken) support zone
input color color_resist_weak      = clrIndigo;                // Color for weak resistance zone
input color color_resist_untested  = clrOrchid;                // Color for untested resistance zone
input color color_resist_verified  = clrCrimson;               // Color for verified resistance zone
input color color_resist_proven    = clrRed;                   // Color for proven resistance zone
input color color_resist_turncoat  = clrDarkOrange;            // Color for broken resistance zone


double Ask_=0;
double Bid_=0;
bool semCand = false;

string symbol_ = Symbol();


int ZigzagBufferCand[300];
double ZigzagBufferVal[300];

int barHighBuy,barLowBuy,barRialzoBuy,barRibassoBuy=0;
int barLowSell,barHighSell,barRibassoSellBuy,barRialzoSell=0;

double  ValPiccoLow_,ValSogliaBuy_=0;
// int    CandPiccoHigh  = 0;
// double ValPiccoHigh   = 0;
static double valHighMax,valLowMin,valPiccLow,valSogBuy=0;   //valSogBuy=0;static double valPiccLow

double  ValPiccoHigh_,ValSogliaSell_=0;
 int    CandPiccoLowS  = 0;
 double ValPiccoLowS   = 0;
static double valLowMaxS,valHighMin,valPiccHigh,valSogSell=0;   //valSogSell=0;static double valPiccHigh


double valHigh1Buy,valHigh2Buy,valLow1Buy,valLow2Buy=0;
double valHigh1Sell,valHigh2Sell,valLow1Sell,valLow2Sell=0;
double SogliaBuy,SogliaSell=0;
int    candHigh1Buy,candHigh2Buy,candLow1Buy,candLow2Buy,candSogliaBuy = 0;
int    candHigh1Sell,candHigh2Sell,candLow1Sell,candLow2Sell,candSogliaSell = 0;
int    handleSupp_Demand = 0;

int lastZoneHiLo;
int handle_iCustom;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


int OnInit() 
  {
     if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}

   handle_iCustom=HandleZigZag(periodZigzag,InpDepth,InpDeviation,InptBackstep);
      resetIndicators();Indicators();
      //handleSupp_Demand = iCustom(symbol_,0,"MyIndicators\\Supply & Demand\\shved_supply_and_demand_v1.71 per EA",Timeframe,BackLimit,HistoryMode,zone_settings,
      if(filtroDom_Offerta)handleSupp_Demand = iCustom(symbol_,0,"Examples\\shved_supply_and_demand_v1.71",Timeframe,BackLimit,HistoryMode,zone_settings,
                        zone_show_weak,zone_show_untested,zone_show_turncoat,zone_fuzzfactor,zone_merge,zone_extend,fractal_fast_factor,fractal_slow_factor,
                        alert_settings,zone_show_alerts,zone_alert_popups,zone_alert_sounds,zone_send_notification,zone_alert_waitseconds,drawing_settings,
                        string_prefix,zone_solid,zone_linewidth,zone_style,zone_show_info,zone_label_shift,sup_name,res_name,test_name,Text_size,Text_font,Text_color);                           
                        
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
resetIndicators();
   
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
      
     
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
bool enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);     
 
//int handle_iCustom=HandleZigZag(periodZigzag,InpDepth,InpDeviation,InptBackstep);   
double valPick[];   
Ask_=Ask(Symbol());
Bid_=Bid(Symbol());

semCand = semaforoCandela(0);

/*Print(" Last Zone S&D: ",lastZoneHiLo, " Enable Zone: ",enableSupply_Demand(lastZoneHiLo));
for(int d=4;d<=7;d++)
{
Print(" check ",d,": ",MaCustom(handleSupp_Demand,d,0,1));}
*/
/*
for(int d=0;d<100;d++)
{//if(MaCustomZ(handleSupp_Demand,buffer,d,quantitaDaCopiare))
Print(" High ",d,": ",MaCustom(handleSupp_Demand,buffer,d,quantitaDaCopiare)," Low ",MaCustom1(handleSupp_Demand,buffer1,d,quantitaDaCopiare));}
*/

//if(!enableSupply_Demand(lastZoneHiLo))Print(" Zone Disable");
enableTrading = enableTrading && GestioneATR() && enableSupply_Demand(lastZoneHiLo);

if(semCand)enableTrading = enableTrading && ZIGZAGPik(ZigzagBufferCand,ZigzagBufferVal,handle_iCustom,InpDepth,InpCandlesCheck,disMinCandZZ);
if(semCand)Indicators();
CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
gestioneBreakEven();
gestioneTrailStop();

if(semCand && enableTrading)gestioneOrdini();
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
int    CandPiccoHigh  = 0;
double ValPiccoHigh   = 0;

double valPicco              = 0;
int    cand                  = 0;

//BUY

int     TaPr=0;
int     StopLoss=0;

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
/*

int barHighBuy,barLowBuy,barRialzoBuy,barRibassoBuy=0;
int barLowSell,barHighSell,barRibassoSellBuy,barRialzoSell=0;*/
//Control Buy
//Picco Alto 

   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&valPicco>=ValPiccoHigh){ValPiccoHigh=valPicco;CandPiccoHigh=cand;barHighBuy=bars;}     
} 
/*
CandPiccoHigh=iHighest(symbol_,PERIOD_CURRENT,MODE_CLOSE,500);
ValPiccoHigh=iHigh(symbol_,PERIOD_CURRENT,1);
if(CandPiccoHigh)barHighBuy=bars;
*/
 //Print(" CandPiccoHigh: ",CandPiccoHigh," barHighBuy: ",barHighBuy," ValPiccoHigh: ",ValPiccoHigh);
//Picco Basso    
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{//Print(" ValPiccoHigh-valPicco: ",ValPiccoHigh-valPicco," distMinPicchiMaxMin*Point(): ",distMinPicchiMaxMin*Point());
   if(i==0&&ValPiccoLow==0)ValPiccoLow=ValPiccoHigh;
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];//if(valPicco==0)break;
   if(valPicco>0&&
   valPicco<=ValPiccoLow
   &&bars>barHighBuy
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco && iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   &&ValPiccoHigh-valPicco >= distMinPicchiMaxMin*Point())
   {ValPiccoLow=valPicco;CandPiccoLow=cand;barLowBuy=bars;} if(!CandPiccoLow)ValPiccoLow=0;                                          
}              

//Picco Rialzo             
   for(int i=0;i<CandPiccoLow;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0
   &&bars>barLowBuy
   &&valPicco>primoPiccoBuy
   &&iOpen(symbol_,PERIOD_CURRENT,cand)<=valPicco &&iClose(symbol_,PERIOD_CURRENT,cand)<=valPicco
   &&valPicco<=((ValPiccoHigh-ValPiccoLow)*maxRappPiccSoglBuy)+ValPiccoLow
   &&valPicco-ValPiccoLow > distMinPicchi2_3*Point()
   ){primoPiccoBuy=valPicco;CandPrimoPiccoBuy=cand;barRialzoBuy=bars;} if(!CandPrimoPiccoBuy)primoPiccoBuy=0;                                 
}

//Primo Picco Low e Valore Soglia   
   primoPiccoLow = primoPiccoBuy;       
   
   for(int i=0;i<CandPrimoPiccoBuy;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0
   &&bars>barRialzoBuy
   &&valPicco<primoPiccoLow
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco
   &&iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   ){primoPiccoLow=valPicco;CandPrimoPiccoLow=cand;ValSogliaBuy=primoPiccoBuy;CandSogliaBuy=CandPrimoPiccoBuy;}         
  // else Print("No Pattern BUY");
}   
   if(primoPiccoBuy==0){ValSogliaBuy=0;CandSogliaBuy=0;barRibassoBuy=bars;}    


//if(CandPiccoHigh&&ValPiccoHigh&&ValPiccoLow&&primoPiccoBuy&&ValSogliaBuy)
//Print(" CandPiccoHigh: ",CandPiccoHigh," ValPiccoHigh: ",ValPiccoHigh," CandPiccoLow: ",CandPiccoLow," ValPiccoLow: ",ValPiccoLow,
//      " CandPrimoPiccoBuy: ",CandPrimoPiccoBuy," primoPiccoBuy: ",primoPiccoBuy," CandSogliaBuy:",CandSogliaBuy," ValSogliaBuy: ",ValSogliaBuy);


   ValPiccoLow_=ValPiccoLow;ValSogliaBuy_=ValSogliaBuy;
       
   if(C1>ValSogliaBuy&&ValSogliaBuy!=0&&!semaNumCandBuy){numCandPreordBuy=bars;semaNumCandBuy=true;}
   if(ValSogliaBuy)

   if(semaNumCandBuy&&C1>=ValSogliaBuy&&primoPiccoBuy>0&&ValSogliaBuy!=0&&bars-numCandPreordBuy+1>=numCandBuy&&OrdBuy==0&&C1<=((ValPiccoHigh-ValPiccoLow)*maxRappPiccSoglBuy)+ValPiccoLow)
      //if(C1>=ValSogliaBuy&&primoPiccoBuy>0&&ValSogliaBuy!=0&&bars-numCandPreordBuy+1>=numCand&&OrdBuy==0)
      
   {TaPr=calcoloTakeProf("Buy",Ask_,ValPiccoHigh,ValPiccoLow,ValSogliaBuy);StopLoss=gestioneStopLoss("Buy",Ask_);
    SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,StopLoss,TaPr,Commen,magic_number);semaNumCandBuy=false;numCandPreordBuy=0;}   //Order BUY
   
   if((C1<ValSogliaBuy&&semaNumCandBuy)||ValSogliaBuy==0){semaNumCandBuy=false;numCandPreordBuy=0;}

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
int     TaPr=0;
int     StopLoss=0;

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

//Picco Basso  
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)                                           
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];//if(valPicco==0)break;
   if(i==0 && valPicco!=0)ValPiccoLowS = valPicco;
   if(valPicco>0&&valPicco<=ValPiccoLowS){ValPiccoLowS=valPicco;CandPiccoLowS=cand;}         
} 
Print(" CandPiccoLowS: ",CandPiccoLowS," ValPiccoLowS: ",ValPiccoLowS);
/*
//Picco Basso    
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{
   if(i==0&&ValPiccoLow==0)ValPiccoLow=ValPiccoHigh;
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&
   valPicco<=ValPiccoLow
   &&cand<CandPiccoHigh
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco && iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   &&ValPiccoHigh-valPicco >= distMinPicchiMaxMin*Point())
   {ValPiccoLow=valPicco;CandPiccoLow=cand;}                                             
}      */

//Picco High 
 //  CandPiccHighS = iHighest(symbol_,periodZigzag,MODE_HIGH,CandPiccoLowS,0);               
 //  ValPiccoHighS  = iHigh(symbol_,periodZigzag,CandPiccHighS);                            
   for(int i=0;i<ArraySize(ZigzagBufferVal);i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];//if(valPicco==0)break;
   if(valPicco>0&&valPicco>=ValPiccoHighS
   &&cand<CandPiccoLowS
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
   &&ValPiccoHighS-valPicco > distMinPicchi2_3*Point()
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
   &&cand<CandPrimoPiccoSell
   ){primoPiccoHigh=valPicco;CandPrimoPiccoHigh=cand;ValSogliaSell=primoPiccoSell;CandSogliaSell=CandPrimoPiccoSell;}//Primo picco high
   //if(!primoPiccoSell){CandSogliaSell=0;ValSogliaSell=0;}
   //Print(" primoPiccoHigh: ",primoPiccoHigh," candPrimoPiccoHigh: ",CandPrimoPiccoHigh);
   //else Print("No Pattern SELL");                                                                                                                                 //Primo Picco High e Valore Soglia
}  
//Print(" CandSogliaSell: ",CandSogliaSell," ValSogliaSell: ",ValSogliaSell);    
   
   //if(CandSogliaSell>=CandPrimoPiccoHigh){CandSogliaSell=0;ValSogliaSell=0;}
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
 //     " CandPrimoPiccoSell: ",CandPrimoPiccoSell," primoPiccoSell: ",primoPiccoSell," CandSogliaSell:",CandSogliaSell," ValSogliaSell: ",ValSogliaSell);
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
   if(a == true) Print("Account Ok!");
   else
     {(Print("EA trial license expired or Account without permission")); ExpertRemove();}
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
if(TakeProfit==1) {TP=(TpPoints);return TP;}
if(TakeProfit==2) {TP=gestioneTPFibo(BuySell,openPrOrd);}
if(TakeProfit==3) {TP=gestioneTPFibAuto(PickMax,PickLow,SoglBuy);}
if(TakeProfit==4)
{
if(BuySell=="Buy") TP=(int)((PickMax-Ask_)/Point());
if(BuySell=="Sell")TP=(int)((Bid_-PickLow)/Point());
}
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
 //     " Pos SL: ",PositionStopLoss(TikBuy)," valSogBuy+(StepTrStFibo_*i*(valSogBuy - valPiccLow)): ",valSogBuy+(StepTrStFibo_*i*(valSogBuy - valPiccLow)));qq++;
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
void BEFibo(double StartBEEstFib, double StepFib)
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
      if(filtroDom_Offerta)ChartIndicatorAdd(0,0,handleSupp_Demand);  
      ChartIndicatorAdd(0,0,handle_iCustom);
      if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,1,indicator_handleATR);}        
     }
  } 
  
//+------------------------------------------------------------------+
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
    
//
double MaCustom(int handle,int buff,int index1,int quantita)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,buff,index1,quantita,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
} 

double MaCustom1(int handle,int buff,int index1,int quantita)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,buff,index1,quantita,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
} 

double MaCustomZ(int handle,int buff,int index1,int quantita)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,buff,index1,quantita,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
} 

double MaCustomC(int handle,int buff,int index1,int quantita)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,buff,index1,quantita,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}


bool enableSupply_Demand(int &memo_)
{
bool a = true;
int static memo = 0;

if(!filtroDom_Offerta) return a;
double dist = distSupp_Dem * Point();
double levHH = MaCustom(handleSupp_Demand,4,0,1);
double levHL = MaCustom(handleSupp_Demand,5,0,1);
double levLH = MaCustom(handleSupp_Demand,6,0,1);
double levLL = MaCustom(handleSupp_Demand,7,0,1);
//Print(" Lev1 ",lev1);
//Print(" Lev2 ",lev2);
if(!levHH || !levHL || !levLH || !levLL) {Alert("NO DATA Indicator Supply & Demand");return a;}
//Print(" Lev Sup: ",levHL - dist," Compreso High: ",doubleCompreso(Ask_,levHH + dist,levHL - dist)," Compreso Low: ",doubleCompreso(Bid_,levLH + dist,levLL - dist));
if(doubleCompreso(Ask_,levHH + dist,levHL - dist)) {a = false; memo = 1;return a;} // prezzo tocca la fascia resistenza superiore
//if(C1 > levHH)memo = -1;

if(doubleCompreso(Bid_,levLH + dist,levLL - dist)) {a = false; memo = -1;} // prezzo tocca la fascia supporto inferiore

memo_ = memo; return a;
}

bool lastDomOffertaBuy()
{
bool a = true;
if(!filtroDom_Offerta) return a;
if(semCand)
{
double levHH = MaCustom(handleSupp_Demand,4,0,1);
double levHL = MaCustom(handleSupp_Demand,5,0,1);
double levLH = MaCustom(handleSupp_Demand,6,0,1);
double levLL = MaCustom(handleSupp_Demand,7,0,1);
if(!levHH || !levHL || !levLH || !levLL) {Alert("NO DATA Indicator Supply & Demand");return a;}
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
int barre = iBars(symbol_,PERIOD_CURRENT);
static int barreOrdDisable = 0;
double valSupH = valoreSuperiore(levHH,levHL);
double valInfH = valoreInferiore(levHH,levHL);

double valSupL = valoreSuperiore(levLH,levLL);
double valInfL = valoreInferiore(levLH,levLL);

if(!enableSupply_Demand(lastZoneHiLo)) barreOrdDisable = barre;
if(barre > barreOrdDisable && C1 < valInfH) a = false;
}
return a;
} 

bool lastDomOffertaSell()
{
bool a = true;
if(!filtroDom_Offerta) return a;
if(semCand)
{
double levHH = MaCustom(handleSupp_Demand,4,0,1);
double levHL = MaCustom(handleSupp_Demand,5,0,1);
double levLH = MaCustom(handleSupp_Demand,6,0,1);
double levLL = MaCustom(handleSupp_Demand,7,0,1);
if(!levHH || !levHL || !levLH || !levLL) {Alert("NO DATA Indicator Supply & Demand");return a;}
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
int barre = iBars(symbol_,PERIOD_CURRENT);
static int barreOrdDisable = 0;
double valSupH = valoreSuperiore(levHH,levHL);
double valInfH = valoreInferiore(levHH,levHL);

double valSupL = valoreSuperiore(levLH,levLL);
double valInfL = valoreInferiore(levLH,levLL);

if(!enableSupply_Demand(lastZoneHiLo)) barreOrdDisable = barre;
if(barre > barreOrdDisable && C1 > levLH) a = false;
}
return a;
}

//+------------------------------------------------------------------+
//|                            GestioneATR()                         |
//+------------------------------------------------------------------+
bool GestioneATR()
  {
   bool a=true;
   if(!Filter_ATR) return a;

   if(Filter_ATR && iATR(Symbol(),periodATR,ATR_period,0) < thesholdATR)
     {
      a=false;
     }
   return a;
  } 