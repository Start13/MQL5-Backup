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
long NumeroAccount0 = NumeroAccountOk[0] = 37114023;
long NumeroAccount1 = NumeroAccountOk[1] = 68152694;
long NumeroAccount2 = NumeroAccountOk[2] = 37127778;
long NumeroAccount3 = NumeroAccountOk[3] = 27081543;
long NumeroAccount4 = NumeroAccountOk[4] = 68170289;
long NumeroAccount5 = NumeroAccountOk[5] = 68168753;
long NumeroAccount6 = NumeroAccountOk[6] = 8918163;
long NumeroAccount7 = NumeroAccountOk[7] = 67113373;
long NumeroAccount8 = NumeroAccountOk[8] = 62039500;
long NumeroAccount9 = NumeroAccountOk[9] = 62039500;

enum ImpLiv
  {
   Impul            = 1,                //Ordini ad impulso
   Livell           = 2,                //Ordini a Livello
  }; 
enum filtroPivot
  {
   NoPivot               = 0, //No Filtro Pivot
   PivotD                = 1, //Filtro Daily
   PivotW                = 2, //Filtro Weekly
  };
enum TypePivot
  {
   PivotDHL_2            = 2, // Pivot HL:2
   PivotDHLC_3           = 3  // Pivot HL:3
  };

enum Grid_Hedge
  {
   NoGrid_NoHedge        = 0, //No Griglia / No Hedging
   Grid_                 = 1, //Griglia
   Hedge                 = 2, //Hedging
  };
enum TipoMultipliGriglia
  {
   Fix                   = 0,
   Progressive           = 1,
  };
enum nMaxPos
  {
   Una_posizione         = 1,  //Max 1 Ordine
   Due_posizioni         = 2,  //Max 2 Ordini
  };
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
enum StopBefore_
  {
   cinqueMin             =  5, //5 Min
   dieciMin              = 10, //10 min
   quindMin              = 15, //15 min
   trentaMin             = 30, //30 min
   quarantacinMin        = 45, //45 min
   unOra                 = 60, //1 Hour
   unOraeMezza           = 90, //1:30 Hour
   dueOre                =120, //2 Hours
   dueOreeMezza          =150, //2:30 Hours
   treOre                =180, //3 Hours
   quattroOre            =240, //4 Hours
  };
enum StopAfter_
  {
   cinqueMin             =  5, //5 Min
   dieciMin              = 10, //10 min
   quindMin              = 15, //15 min
   trentaMin             = 30, //30 min
   quarantacinMin        = 45, //45 min
   unOra                 = 60, //1 Hour
   unOraeMezza           = 90, //1:30 Hour
   dueOre                =120, //2 Hours
   dueOreeMezza          =150, //2:30 Hours
   treOre                =180, //3 Hours
   quattroOre            =240, //4 Hours
  };    
input string   comment_MM   =          "--- MONEY MANAGEMENT ---";        // --- MONEY MANAGEMENT ---
input double   capitalToAllocateEA =  		 0;									  // Capitale da allocare per l'EA (0 = intero capitale)
input bool     compounding  =           true;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100]
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot
 
input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input bool                   StopNewsOrders                  = false;      //Ferma l'EA quando terminano gli Ordini
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =  22;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
input char                   maxDDPerc                       =   0;        //Max DD% (0 Disable)
input int                    MaxSpread                       =   0;        //Max Spread (0 = Disable)
input Type_Orders            Type_Orders_                    =   0;        //Tipo di Ordini
input nMaxPos                N_Max_pos                       =   2;        //Massimo numero di Ordini contemporaneamente
//input int                    N_max_orders                    = 50;       //Massimo numero di Ordini nella giornata
input ulong                  magic_number                    = 4444;       //Magic Number
input string                 Commen                          = "W S&D 3";       //Comment
input int                    Deviazione                      = 0;          //Slippage 

input string   comment_WW =            "--- W SETTINGS ---";   // --- W SETTINGS ---
input int      distMinPicchiMaxMin                           = 0;        //Distanza minima Picchi Max/Min (Points)              
input double   maxRappPiccSoglBuy                            = 1;     //Soglia Picco/Base Buy
input double   maxRappPiccSoglSell                           = 1;     //Soglia Picco/Base Sell
input int      numCandBuy                                    = 1;        //Numero candele di conferma Buy
input int      numCandSell                                   = 7;        //Numero candele di conferma Sell
input bool     mantienePrimaSoglia                           = true;     //Se Non apre ord x num cand: mantiene soglia
//input ImpLiv   ImpulsoLivello                                =  1;       //Nel Delta prezzo consentito: 

input string   comment_CAN   =       "--- FILTER CANDLE ORDERS ---";       // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;     //Abilita più ordini sulla stessa candela
input bool                   OrdEChiuStessaCandela           = true;     //Abilita News Orders sulla candela di ordini già aperti e/o chiusi
input string   comment_DIR   =       "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))

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
input int      TsStart                  = 10000;              //Ts Start in Points
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

input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

input string   comment_TT =            "--- TRADING TIME SETTINGS ---";   // --- TRADING TIME SETTINGS ---
input string   comment_TT1 =           "--- TIME SETTINGS 1 ---";   // --- TRADING TIME SETTINGS 1 ---
input bool     FusoEnable     = false;                   //Trading Time
input Fuso_    Fuso           =  2;                      //Time Zone Settings
input int      InpStartHour   =  2;                      //Session1 Start Time
input int      InpStartMinute =  0;                      //Session1 Start Minute
input int      InpEndHour     = 15;                      //Hours1 End of Session
input int      InpEndMinute   = 15;                      //Minute1 End of Session
input string   comment_TT2 =            "--- TIME SETTINGS 2 ---";   // --- TRADING TIME SETTINGS 2 ---
input int      InpStartHour1   = 16;                     //Session2 Start Time
input int      InpStartMinute1 = 15;                     //Session2 Start Minute
input int      InpEndHour1     = 23;                     //Hours2 End of Session
input int      InpEndMinute1   = 00;                     //Minute2 End of Session

input string   comment_NEW  =           "--- FILTER NEWS ---";             // --- FILTER NEWS ---
input bool     FilterNews   =          false;                             //Filter News
input ENUM_CALENDAR_EVENT_IMPORTANCE    levelImpact= CALENDAR_IMPORTANCE_LOW ;
input StopBefore_                       StopBefore = 30;                      //Stop Before
input StopAfter_                        StopAfter  = 30;                      //Stop After
ENUM_TIMEFRAMES                   startime_  = PERIOD_D1  ;
ENUM_TIMEFRAMES                   endtime_   = PERIOD_D1  ;
ENUM_TIMEFRAMES                   rangetime_ = PERIOD_D1  ;

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

ulong magicNumber       =  magic_number;   // Magic Number

double capitalToAllocate =            0;
bool    autoTradingOnOff = 	     true;

double capitaleBasePerCompounding;
double distanzaSL = 0;

double ASK = 0;
double BID = 0;

string symbol_ = Symbol();

bool semCand = false;

int spread;
string Commento = "";

bool enableTrading = false;

datetime OraNews;

int Handle_iCustomZigZag;
double ZigZagiCustom;

int    handleSupp_Demand = 0;

int lastZoneHiLo;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
	Allocazione_Init(); 
	Handle_iCustomZigZag = HandleZigZag(periodZigzag,InpDepth,InpDeviation,InptBackstep);
   if(filtroDom_Offerta)handleSupp_Demand = iCustom(symbol_,0,"Examples\\shved_supply_and_demand_v1.71",Timeframe,BackLimit,HistoryMode,zone_settings,
                        zone_show_weak,zone_show_untested,zone_show_turncoat,zone_fuzzfactor,zone_merge,zone_extend,fractal_fast_factor,fractal_slow_factor,
                        alert_settings,zone_show_alerts,zone_alert_popups,zone_alert_sounds,zone_send_notification,zone_alert_waitseconds,drawing_settings,
                        string_prefix,zone_solid,zone_linewidth,zone_style,zone_show_info,zone_label_shift,sup_name,res_name,test_name,Text_size,Text_font,Text_color); 	
	
	
	  
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
	
	if(!autoTradingOnOff) return;
	
	Allocazione_Check(magicNumber);  
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Libra from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);     
 
int ZigzagBufferCand[300];
double ZigzagBufferVal[300];  

ASK=Ask(symbol_);
BID=Bid(symbol_);
spread = (int)((ASK - BID)/Point());
Commento = "Spead "+ (string)spread;
Comment (Commento);
semCand = semaforoCandela(0); 


enableTrading = enableTrading && ZIGZAGPik(ZigzagBufferCand,ZigzagBufferVal,Handle_iCustomZigZag,InpDepth,InpCandlesCheck,disMinCandZZ) && GestioneATR() && enableSupply_Demand(lastZoneHiLo);
Indicators();
CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);

if(enableTrading)
{
gestioneBreakEven();
gestioneTrailStop();
if(semCand)gestioneOrdini(ZigzagBufferCand,ZigzagBufferVal);
}




  }
 
void gestioneOrdini(int &ZigzagBufferCand[],double &ZigzagBufferVal[])
{
gestioneOrdiniBuy(ZigzagBufferCand,ZigzagBufferVal);

}
//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdiniBuy(int &ZigzagBufferCand[],double &ZigzagBufferVal[])
{
//BUY
if(Type_Orders_==0 || Type_Orders_==1)
{
   int    OrdBuy                = NumOrdBuy(magic_number,Commen);      
   int    contaCand             = 0;   

   double C1                    = iClose(symbol_,PERIOD_CURRENT,1);
   int    bars                  = iBars(symbol_,PERIOD_CURRENT);
   static bool   semaNumCandBuy = false;
   static int    numCandPreordBuy      = 0;

   int    candHighBuy    = 0;
   double ValHighBuy     = 0;
    
   int    candLowBuy     = 0;
   double ValLowBuy      = 0; 

   int CandRialzoBuy     = 0;
   double ValRialzoBuy   = 0;
 
   int CandRibassoBuy    = 0;
   double ValRibassoBuy  = 0; 
 
   static int barreHighBuy=0,barreLowBuy=0,barreRialzoBuy=0,barreRibassoBuy=0;
 
   static int     CandSogliaBuyMem = 0;
   static double  ValSogliaBuyMem  = 0;
   
   static double ValHighBuyMem = 0;
   static double ValLowBuyMem  = 0;
   
   static bool semMemDati = false;

int arraySize = ArraySize(ZigzagBufferVal);
//
//if(!semMemDati)
{
PiccoHighBuy(arraySize,ZigzagBufferCand,ZigzagBufferVal,candHighBuy,ValHighBuy,bars,barreHighBuy);
Print(" candela Max: ",candHighBuy," Valore Max: ",ValHighBuy," barreHighBuy: ",barreHighBuy);
/*
bool PiccoLowBuy(int counter,int &ZigzagBufferCand[],double &ZigzagBufferVal[],int &CandPiccoLow,double &ValPiccoLow,double valoreIniziale,int CandPiccoHigh,
                 double ValPiccoHigh,int bars,int barreHighBuy,int &barreLowBuy)*/
PiccoLowBuy(arraySize,ZigzagBufferCand,ZigzagBufferVal,candLowBuy,ValLowBuy,ValHighBuy,candHighBuy,
            ValHighBuy,bars,barreHighBuy,barreLowBuy);
Print(" candela Low: ",candLowBuy," Valore Low: ",ValLowBuy," barreLowBuy: ",barreLowBuy);

PiccoRialzoBuy(arraySize,ZigzagBufferCand,ZigzagBufferVal,CandRialzoBuy,ValRialzoBuy,ValHighBuy,ValLowBuy,candLowBuy);
//Print(" candela Rialzo: ",CandRialzoBuy," Valore Rialzo: ",ValRialzoBuy);

PiccoRibassoBuy(arraySize,ZigzagBufferCand,ZigzagBufferVal,ValRialzoBuy,CandRibassoBuy,ValRibassoBuy);
//Print(" candela Ribasso: ",CandRibassoBuy," Valore Ribasso: ",ValRibassoBuy);
}
/*
if(ValHighBuy&&ValLowBuy&&ValRialzoBuy&&ValRibassoBuy){CandSogliaBuyMem=CandRialzoBuy;ValSogliaBuyMem=ValRialzoBuy;ValHighBuyMem=ValHighBuy;ValLowBuyMem=ValLowBuy;semMemDati=true;}
if(semMemDati && ((iHigh(symbol_,PERIOD_CURRENT,1) >= ((ValHighBuyMem-ValLowBuyMem)*maxRappPiccSoglBuy)+ValLowBuyMem) || iLow(symbol_,PERIOD_CURRENT,1) < ValLowBuyMem))
                 {CandSogliaBuyMem=0;ValSogliaBuyMem=0;ValHighBuyMem=0;ValLowBuyMem=0;semMemDati=false;}
//
///
   if(semMemDati)
   {

   if(C1>ValSogliaBuyMem && ValSogliaBuyMem!=0 && !semaNumCandBuy){numCandPreordBuy=bars;semaNumCandBuy=true;}

   if(ValSogliaBuyMem && semaNumCandBuy && C1>=ValSogliaBuyMem && bars-numCandPreordBuy+1>=numCandBuy && !OrdBuy && C1<=((ValHighBuy-ValLowBuyMem)*maxRappPiccSoglBuy)+ValLowBuyMem)
      //if(C1>=ValSogliaBuy&&primoPiccoBuy>0&&ValSogliaBuy!=0&&bars-numCandPreordBuy+1>=numCand&&OrdBuy==0)
      
   {int TaPr=calcoloTakeProf("Buy",ASK,ValHighBuy,ValLowBuyMem,ValSogliaBuyMem);int StopLoss=gestioneStopLoss("Buy",ASK);
    SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,StopLoss,TaPr,Commen,magic_number);semaNumCandBuy=false;numCandPreordBuy=0;}          //Order BUY
    }                      
///
      if(!mantienePrimaSoglia && !OrdBuy && C1>ValSogliaBuyMem){CandSogliaBuyMem=numCandPreordBuy=bars;ValSogliaBuyMem=C1;semaNumCandBuy=true;} 


Print("Soglia Buy: ",ValSogliaBuyMem," semMemDati: ",semMemDati);
*/

}
}

//+------------------------------------------------------------------+
//|                          PiccoHighBuy()                          |
//+------------------------------------------------------------------+ 
/*
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&valPicco>=ValPiccoHigh){ValPiccoHigh=valPicco;CandPiccoHigh=cand;barHighBuy=bars;}   */
   
   
//PiccoHighBuy(arraySize,ZigzagBufferCand,ZigzagBufferVal,candHighBuy,ValHighBuy,bars,barreHighBuy); 
bool PiccoHighBuy(int counter,int &ZigzagBufferCand[],double &ZigzagBufferVal[],int &CandPiccoHigh,double &ValPiccoHigh,int barre,int &barreHighBuy)
{
bool a=false;
double valPicco=0;
int cand=0;
static int barreHighBuy_=0;

   for(int i=0;i<counter;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0&&valPicco>=ValPiccoHigh){ValPiccoHigh=valPicco;CandPiccoHigh=cand;if(!barreHighBuy_)barreHighBuy_=barre;}
   if(!CandPiccoHigh)ValPiccoHigh=barreHighBuy_=0;     
} 
barreHighBuy=barreHighBuy_;
return a;
} 

//+------------------------------------------------------------------+
//|                          PiccoLowBuy()                           |
//+------------------------------------------------------------------+  
//PiccoLowBuy(arraySize,ZigzagBufferCand,ZigzagBufferVal,candLowBuy,ValLowBuy,ValHighBuy,candHighBuy,
            //ValHighBuy,bars,barreHighBuy,barreLowBuy);
bool PiccoLowBuy(int counter,int &ZigzagBufferCand[],double &ZigzagBufferVal[],int &CandPiccoLow,double &ValPiccoLow,double valoreIniziale,int CandPiccoHigh,
                 double ValPiccoHigh,int bars,int barreHighBuy,int &barreLowBuy)
{
bool a=false;
ValPiccoLow=valoreIniziale;
double valPicco=0;
int cand=0;

   for(int i=0;i<counter;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];if(valPicco==0)break;
   if(valPicco>0
   &&valPicco<=ValPiccoLow
   &&bars>barreHighBuy
   //&&cand<CandPiccoHigh
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco && iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   )
   {ValPiccoLow=valPicco;CandPiccoLow=cand;barreLowBuy=bars;}if(!CandPiccoLow || ValPiccoHigh-valPicco < distMinPicchiMaxMin*Point()){ValPiccoLow=CandPiccoLow=barreLowBuy=0;}                                              
}   
return a;
} 

//+------------------------------------------------------------------+
//|                         PiccoRialzoBuy()                         |
//+------------------------------------------------------------------+  
bool PiccoRialzoBuy(int counter,int &ZigzagBufferCand[],double &ZigzagBufferVal[],int &CandPrimoPiccoBuy,double &primoPiccoBuy,double ValPiccoHigh,double ValPiccoLow,int CandPiccoLow)
{  
bool a=false;
double valPicco=0;
int cand=0;         
   for(int i=0;i<counter;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];//if(valPicco==0)break;
   if(valPicco>0
   &&cand<CandPiccoLow
   &&valPicco>primoPiccoBuy
   &&iOpen(symbol_,PERIOD_CURRENT,cand)<=valPicco &&iClose(symbol_,PERIOD_CURRENT,cand)<=valPicco
   &&valPicco<=((ValPiccoHigh-ValPiccoLow)*maxRappPiccSoglBuy)+ValPiccoLow
   ){primoPiccoBuy=valPicco;CandPrimoPiccoBuy=cand;}
   if(!cand)primoPiccoBuy=0; if(primoPiccoBuy>=((ValPiccoHigh-ValPiccoLow)*maxRappPiccSoglBuy)+ValPiccoLow){primoPiccoBuy=0;CandPrimoPiccoBuy=0;}                                  
}
return a;
}


//+------------------------------------------------------------------+
//|                        PiccoRibassoBuy()                         |
//+------------------------------------------------------------------+  

bool PiccoRibassoBuy(int counter,int &ZigzagBufferCand[],double &ZigzagBufferVal[],double valoreIniziale,int &CandPrimoPiccoLow,double &primoPiccoLow)
{  
bool a=false;
double valPicco=0;
int cand=0; 
   primoPiccoLow = valoreIniziale;       
   
   for(int i=0;i<counter;i++)
{
   valPicco=ZigzagBufferVal[i];cand=ZigzagBufferCand[i];//if(valPicco==0)break;
   if(valPicco>0&&cand<counter
   &&valPicco<primoPiccoLow
   &&iOpen(symbol_,PERIOD_CURRENT,cand)>=valPicco
   &&iClose(symbol_,PERIOD_CURRENT,cand)>=valPicco
   ){primoPiccoLow=valPicco;CandPrimoPiccoLow=cand;}  
   if(!CandPrimoPiccoLow)primoPiccoLow=0;
}
return a;   
} 


//+------------------------------------------------------------------+
//|                            Indicators()                          |
//+------------------------------------------------------------------+  
void Indicators()
  {
   char index=0;
     {
      if(filtroDom_Offerta)ChartIndicatorAdd(0,0,handleSupp_Demand);  
      ChartIndicatorAdd(0,0,Handle_iCustomZigZag);
      if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,1,indicator_handleATR);}        
     }
  } 
  
//+------------------------------------------------------------------+
//|                       resetIndicators()                          |
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

//+------------------------------------------------------------------+
//|                            GestioneATR()                         |
//+------------------------------------------------------------------+
bool GestioneATR()
  {
   bool a=true;
   if(!Filter_ATR) return a;
   if(Filter_ATR && iATR(Symbol(),periodATR,ATR_period,0) < thesholdATR) a=false;
   return a;
  }
//+------------------------------------------------------------------+
//|                         myLotSize()                              |
//+------------------------------------------------------------------+
double myLotSize()
  {
   return myLotSize(compounding,AccountEquity(),capitaleBasePerCompounding,lotsEA,riskEA,riskDenaroEA,(int)distanzaSL,commissioni);
  }  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double myVolume(ulong magic,string symbol=NULL){
	double lots = lotsEA*compEA(magic,symbol);
	
	lots = NormalizeDouble(lots,2);
	
	return lots;
}
  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| FUNZIONI AUSILIARIE                                              |
//+------------------------------------------------------------------+
bool semaforoSecondi(ushort idContatore,int secondiPerSemaforo=10){
   static datetime contatoreSecondi[USHORT_MAX] = {0};
   if(TimeCurrent() >= contatoreSecondi[idContatore]+secondiPerSemaforo){
      return (contatoreSecondi[idContatore] = TimeCurrent()) >= 0;
   }
   return false;
}

//+------------------------------------------------------------------+
//| ALLOCAZIONE CAPITALE                                             |
//+------------------------------------------------------------------+

void Allocazione_Init(){
	capitalToAllocate = 	capitalToAllocateEA > 0 ? capitalToAllocateEA : AccountBalance();
}


// Controllo Allocazione Capitale
void Allocazione_Check(ulong magic,string symbol=NULL){
	
	if(!semaforoSecondi(0,2)) return;
	
	if(EquityEA(magic,symbol) <= 0){
   	Print("Raggiunta soglia massima per Allocazione Capitale ("+currencySymbolAccount()+DoubleString(capitalToAllocate)+"), Chiusura totale ordini!");
   	brutalCloseTotal(symbol,magic);
   	autoTradingOnOff = false;
	}
}

double EquityEA(ulong magic,string symbol=NULL){
	return capitalToAllocate + profittiEA(magic,symbol);
}

double compEA(ulong magic,string symbol=NULL){
	if(compounding && capitalToAllocate > 0) return (EquityEA(magic,symbol))/capitalToAllocate;
	return 1;
}


double profittiEA(ulong magic,string symbol=NULL){
	static double profitHistory = 0;
	double profitFloating = 0;
	
	static int i = 0;
	
	#ifdef __MQL5__
	HistorySelect(0,D'3000.01.01');
	for(;i<HistoryDealsTotal();i++){
      if(HistoryDealSelectByPos(i) && HistoryDealIsSymbol(symbol) && HistoryDealIsMagicNumber(magic)){
         profitHistory += HistoryDealProfitFull();
      }
   }
   
   for(int j=0;j<PositionsTotal();j++){
      if(PositionSelectByPos(j) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         profitFloating += PositionProfitFull();
      }
   }
   #endif 
   
   #ifdef __MQL4__
   for(;i<OrdersHistoryTotal();i++){
   	if(OrderSelectByPos(i,MODE_HISTORY) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic)){
         profitHistory += OrderProfitFull();
      }
	}
	
	for(int j=0;j<OrdersTotal();j++){
      if(OrderSelectByPos(j) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic)){
         profitFloating += OrderProfitFull();
      }
   }
   #endif 
   
   
   return profitHistory + profitFloating;
}  
//+------------------------------------------------------------------+
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
//|                       gestioneStopLoss                           |
//+------------------------------------------------------------------+
int gestioneStopLoss(string BuySell,double openPrOrd)
{
int a=0;
if(Sl_==0)return 0;
if(Sl_==1)return calcoloStopLoss(BuySell,openPrOrd);
//if(Sl_==2)return StopLossPiccoZigZag(BuySell,openPrOrd);
return a;
}
//+------------------------------------------------------------------+
//|                       calcoloTakeProf()                          |
//+------------------------------------------------------------------+
int calcoloTakeProf(string BuySell,double openPrOrd,double PrimoPick,double SecondoPik,double Soglia)
{
int TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1) {TP=(TpPoints);return TP;}
if(TakeProfit==2) {TP=gestioneTPFibo(BuySell,openPrOrd,PrimoPick,SecondoPik,Soglia);}
if(TakeProfit==3) {TP=gestioneTPFibAuto(BuySell,PrimoPick,SecondoPik,Soglia);}
if(TakeProfit==4)
{
if(BuySell=="Buy") TP=(int)((PrimoPick-ASK)/Point());
if(BuySell=="Sell")TP=(int)((BID-SecondoPik)/Point());
}
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
//|                      gestioneTPFibAuto                           |static double valHighMax,valLowMin,valPiccLow,valSogBuy=0;
//+------------------------------------------------------------------+
int gestioneTPFibAuto(string BuySell,double PickMax,double PickLow,double SoglBuy)
{
double Tp1=0;

if(PickMax==0||SoglBuy==0||PickLow==0)return 0;
if(BuySell=="Buy")
{
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
}
return (int)(Tp1/Point());
}
//+------------------------------------------------------------------+"Buy" -> ValPicco è il valore minimo. "Sell" -> VallPicco è il vamore massimo
//|                        gestioneTPFibo                            |
//+------------------------------------------------------------------+

int gestioneTPFibo(string BuySell,double openPrOrd,double secondoPik,double ValPicco,double ValSoglia)//  
{
      int a = 0;
   if(BuySell=="Buy") {a = (int)((ValSoglia - ValPicco)/Point()*TP1);if(ValSoglia==0 || ValPicco==0)a = 0;}
   if(BuySell=="Sell"){a = (int)((ValPicco - ValSoglia)/Point()*TP1);if(ValSoglia==0 || ValPicco==0)a = 0;}
return a;
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
if(doubleCompreso(ASK,levHH + dist,levHL - dist)) {a = false; memo = 1;return a;} // prezzo tocca la fascia resistenza superiore
//if(C1 > levHH)memo = -1;

if(doubleCompreso(BID,levLH + dist,levLL - dist)) {a = false; memo = -1;} // prezzo tocca la fascia supporto inferiore

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