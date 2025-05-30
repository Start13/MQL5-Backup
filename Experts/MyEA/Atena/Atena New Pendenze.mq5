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
#property icon        "Atena MT5.ico"

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
enum combEnable
  {
   MAFast                = 0, //MAFast
   MA1MA2                = 1, //Ma1 + MA2
   MAFast_1_2            = 2, //MaFast + MA1 + MA 2
  };
enum combClos
  {
   MAFast                = 0, //MAFast
   MA1MA2                = 1, //Ma1 + MA2
   MAFast_1_2            = 2, //MaFast + MA1 + MA 2
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
enum pendenzaChiudeOrdini
   {
   //no                  = 1,  //No
   yes                   = 2,  //Solo senza ordini griglia
   soloProfit            = 3,  //Solo se in profitto e senza ordini griglia
   };  

enum nMaxPos
  {
   Una_posizione         = 1,  //Max 1 Ordine
   Due_posizioni         = 2,  //Max 2 Ordini
  };

enum capitBasePerCompoundingg
  {
   Equity                = 0,  //Equity
   Margine_libero        = 1,  //Margine Libero
   Balance               = 2,  //Balance
  };

enum Fuso_
  {
   GMT                   = 0,
   Local                 = 1,
   Server                = 2
  };
enum Type_Orders
  {
   Buy_Sell              = 0,  //Orders Buy e Sell
   Buy                   = 1,  //Only Buy Orders
   Sell                  = 2   //Only Sell Orders
  };
enum TStop
  {
   No_TS                 = 0,  //No Trailing Stop
   Pointstop             = 1,  //Trailing Stop in Points
   TSPointTradiz         = 2,  //Trailing Stop in Points Traditionale
   TsTopBotCandle        = 3,  //Trailing Stop Previous Candle
  };
enum TypeCandle
  {
   Stesso                = 0,  //Trailing Stop sul min/max della candela "index"
   Una                   = 1,  //Trailing Stop sul min/max del corpo della candela "index"
   Due                   = 2,  //Trailing Stop sul max/min del corpo della candela "index"
   Tre                   = 3,  //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE                 = 0,  //No Breakeven
   BEPoints              = 1,  //Breakeven Points
  };      
enum Tp
  {
   No_Tp                 = 0,  //No Tp
   TpPoints              = 1,  //Tp in Points
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
   
input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input bool                   StopNewsOrders                  = false;      //Ferma l'EA quando terminano gli Ordini
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =  22;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
input char                   maxDDPerc                       =   0;        //Max DD% (0 Disable)
input int                    MaxSpread                       =   0;        //Max Spread (0 = Disable)
input Type_Orders            Type_Orders_                    =   0;        //Tipo di Ordini
input nMaxPos                N_Max_pos                       =   2;        //Massimo numero di Ordini contemporaneamente
//input int                    N_max_orders                    = 50;       //Massimo numero di Ordini nella giornata
input ulong                  magic_number                    = 4444;       //Magic Number
input string                 Commen                          = "Atena New Pendenze";       //Comment
input int                    Deviazione                      = 3;          //Slippage 

//input string   comment_PIV   =       "--- FILTER PIVOT ORDERS ---";       // --- FILTER PIVOT ORDERS ---
//input filtroPivot            filtroPivot_                    = 0;        //Tipo Filtro Pivot. Manca visualizzazione
filtroPivot            filtroPivot_                    = 0;        //Tipo Filtro Pivot. Manca visualizzazione
//input TypePivot              TypePivot_                      = 3;        //Tipo Pivot. Manca visualizzazione
TypePivot              TypePivot_                      = 3;        //Tipo Pivot. Manca visualizzazione

input string   comment_CAN   =       "--- FILTER CANDLE ORDERS ---";       // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;     //Permette apertura primi ordini sulla stessa candela
input bool                   OrdEChiuStessaCandela           = true;     //Permette apertura primi Ordini sulla candela di ordini già aperti e/o chiusi

input string   comment_DIR   =       "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Permette l'Ordine in direzione della candela 0
input bool                   direzCandUno                    = false;     //Permette l'Ordine in direzione della candela 1

input string   comment_DI   =          "--- DISTANZE ---";                // --- DISTANZE ---
input int  DistanzaMASuperiore           = 2000;               //Distanza Points Minima Superiore per Ordini Buy
input int  DistanzaMAMaxSuperiore        =10000;               //Distanza Points Massima Superiore per Ordini Buy. 0: No Limit.
input int  DistanzaMAInferiore           = 2000;               //Distanza Points Minima Inferiore per Ordini Sell
input int  DistanzaMAMaxInferiore        =10000;               //Distanza Points Massima Inferiore oer Ordini Sell. 0: No Limit.

input string   comment_PE   =          "--- PENDENZE ---";                // --- PENDENZE ---
input combEnable combEnab   =              2;                             //Abilita Ordini sulla pendenza delle MA
input int      CandCheckOpe =              1;                             //N° cand con pendenza uguale permette Ordini. 0 disable.
input combClos combClose    =              1;                             //Chiude Ordini sulla pendenza delle MA
input int      CandCheckClo =              2;                             //N° cand con pendenza diversa x Chiudere Ord. 0 disable.
input pendenzaChiudeOrdini  pendClosOrd  = 2;                             //Pendenza MA non congrue per n° cand: chiude ordini 

input string   comment_MAFast =        "--- MA Fast SETTING ---";   // --- MA Fast SETTING ---
input int                  periodMAFast  = 30;              //Periodo MA Fast
input int                  shiftMAFast   =  0;              //Shift MA Fast
input ENUM_MA_METHOD       methodMAFast=MODE_EMA;           //Metodo MA Fast
input ENUM_APPLIED_PRICE   applied_priceMAFast=PRICE_CLOSE; //Tipo di  prezzo MA Fast
input color                coloreMAFast = clrAzure;         //Colore MA Fast

input string   comment_MO =            "--- MA1 SETTING ---";// --- MA1 SETTING ---
input int                  Moving_period= 200;               //Period of MA
input int                  Moving_shift=0;                   //Shift
input ENUM_MA_METHOD       Moving_method=MODE_EMA;           //Type di smussamento
input ENUM_APPLIED_PRICE   Moving_applied_price=PRICE_CLOSE; //Type of price
input ENUM_TIMEFRAMES      TimeFrameMoving=PERIOD_CURRENT;   //Timeframe
input color              MA1ColorFrom  = Lime;               //"Fast up" color
input color              MA1ColorTo    = Lime;               //"Fast down" color
input int                MA1MaxAngle   = 20;                 //Angle threshhold for color steps

input string   comment_TEMA  =          "--- MA2 SETTING (TEMA) ---"; // --- MA2 SETTING (TEMA) ---
input int                  TEMA_period   = 200;              //MA2 Period
input int                  TEMAShift     = 0;                //MA2 Shift
input ENUM_APPLIED_PRICE   TEMA_method=PRICE_CLOSE;          //MA2_method
input ENUM_TIMEFRAMES      TimeFrTEMA =PERIOD_CURRENT;       //MA2 Timeframe

input string   comment_BRk =           "--- BREAKOUT ---"; // --- BREAKOUT ---
input bool     BreakOutEnable      = false;           //BreakOut enable 
input int      Breakmode           = 2;               //Mode_1: aggiorna le soglie con ritardo.
input string   Mode_2 = "aggiorna le soglie quando la candela chiude sotto(buy) o sopra(sell) la soglia";  
input ENUM_TIMEFRAMES timeFrBreak  = PERIOD_CURRENT;  //Time frame BreakOut  
input int      candPrecedent       = 100;             //Check candele precedenti
input int      deltaPlus_          = 0;               //Plus Points for BreakOut
input int      CandCons            = 3;               //Candele consecutive

input string   comment_SL =           "--- STOP LOSS ---";   // --- STOP LOSS ---
input int      SlPoints                 = 10000;             //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";  // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_pips            = 2500;              //Be Start in Points
input int      Be_Step_pips             =  220;              //Be Step in Points
input bool     BEPointConGridOHedgeActive = false;           //Be Points abilitato se presenti ordini opposti di Griglia/Hedge

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts: No/Points da Profit/Points Traditional/Candle
input int      TsStart                  = 3500;              //Ts: Start in Points
input int      TsStep                   =  700;              //Ts: Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Precedente
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit Type
input int      TpPoints                 =10000;              //Take Profit Points
input bool     TpSlInProfit             = true;              //Take Profit: cancellato se Ts/Be in profitto

input string   comment_GRHE =         "--- GRID/HEDGING ---"; // --- GRID/HEDGING ---

input Grid_Hedge GridHedge    =    1;        //Enable Grid/Hedging
input bool     HedgPend       = true;        //Hedging Orders Pendulum
input int      StartGrid      = 3000;        //Start Grid/Hedging (Points)
input int      StepGrid       = 2000;        //Step Grid/Hedging (Points)
input double   moltStepGrid   =    1;        //Multiplicator Step Grid
input char     NumMaxGrid     =   30;        //Numaro max di Grid/Hedging
input double   profitGrid     =    5;        //Profit in Grid/Hedging
//input int      ProfGridPoints  = 100;        //Profit Grid/Hedging Points
input char     MoltipliNumGrid =   1;        //After n° Grid/Hedging
input TipoMultipliGriglia TypeGrid = 1;      //Type Multipl Grid/Hedging: Fix/Progressive
input double   MoltiplLotStep  = 1.3;        //Multipl Lots Fix/Progressive
//input int CloseOrdDopoNumCandDalPrimoOrdine = 18;    //Close Single Order after n° candles lateral (0 = Disable)
int CloseOrdDopoNumCandDalPrimoOrdine =  0;    //Close Single Order after n° candles lateral (0 = Disable)
input bool     TpSeDueOrdini                = true; //With 2 orders on Grid: Disable TP

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

input string   comment_MM   =          "--- MONEY MANAGEMENT ---";        // --- MONEY MANAGEMENT ---
input double   capitalToAllocateEA =  		 0;									  // Capitale da allocare per l'EA (0 = intero capitale)
input bool     compounding  =          false;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100] MM da semplificare
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot
input bool     lotOrderInversoGrid =   false;                             //Lot Order Grid active == Lot Last Order inverse

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

ulong magicNumber                            = magic_number;         			// Magic Number

double capitalToAllocate = 		0;
bool    autoTradingOnOff = 	true;

double capitaleBasePerCompounding;
double distanzaSL = 0;

double ASK=0;
double BID=0;

string symbol_=Symbol();
bool semCand = false;

bool GridBuyActive=false;
bool GridSellActive=false;

ulong TicketHedgeBuy [1000];
ulong TicketHedgeSell[1000];

datetime OraNews;

static bool enableBuyZZ,enableSellZZ;
static double sogliaBuyZZ,sogliaSellZZ;

int spread;
string Commento = "";

bool BreakEnableBuy,BreakEnableSell,BreakSignalBuy,BreakSignalSell=true;

bool enableTrading=true;
int handle_iCustomZigZag;
int handle_iCustomMAFast;
int handle_iCustomMA1Color;
int handle_MA;
int handle_TEMA;
int handleATR;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
      controlAccounts();
     if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
	Allocazione_Init(); 
 
	if(FilterZigZag || FilterZZShad)handle_iCustomZigZag   = iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InptBackstep);
	if(periodMAFast>0 && (combEnab!=1 || combClose!=1))handle_iCustomMAFast   = iCustom(symbol_,0,"Examples\\Custom Moving Average Input Color",periodMAFast,shiftMAFast,methodMAFast,coloreMAFast);
	handle_MA = iCustom(symbol_,0,"Examples\\moving_averages",Moving_period,Moving_applied_price,Moving_method,MA1ColorFrom,MA1ColorTo,MA1MaxAngle);	
	//handle_MA              = iMA(Symbol(),TimeFrameMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price);
	handle_TEMA            = iTEMA(Symbol(),TimeFrTEMA,TEMA_period,TEMAShift,TEMA_method);
	handleATR              = iATR(Symbol(),periodATR,ATR_period);
	
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
resetIndicators();
Comment("");
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

/*
input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe*/
void OnTick()
  {
	if(!autoTradingOnOff) return;
	
	Allocazione_Check(magicNumber);  
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return; 

//enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);   
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_); 
ASK=Ask(symbol_);
BID=Bid(symbol_);
spread=(int)SymbolInfoInteger(symbol_,SYMBOL_SPREAD);
//spread = (int)((ASK - BID)/Point());
Commento = "Spead "+ (string)spread;
Comment (Commento);
semCand = semaforoCandela(0); 

//Print(" GestionePendEnableBuy(): ",GestionePendEnableBuy()," GestionePendEnableSell(): ",GestionePendEnableSell());  
//Print(" GestionePendenzeBuy(): ",GestionePendenzeBuy()," GestionePendenzeSell(): ",GestionePendenzeSell());
Indicators();

BreakOutFilterSignal(BreakOutEnable,candPrecedent,timeFrBreak,CandCons,deltaPlus_,BreakEnableBuy,BreakEnableSell,BreakSignalBuy,BreakSignalSell,Breakmode);
CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
gestioneBreakEven();
gestioneTrailStop();
gestioneOrdini();
GestioneGrid();
GestioneHedge();

bool enableBuy=0,enableSell=0;
double sogliaBuy=0,sogliaSell=0;

  }

//-------------------------------------- MAFast()--------------------------------------------- 
double MAFast(int index)
  {
   double a =0;
   if(handle_iCustomMAFast>INVALID_HANDLE)
     {
      double valoriMAFast[];
      if(CopyBuffer(handle_iCustomMAFast,0,index,1,valoriMAFast)>0){a = valoriMAFast[0];}
     }
   return a;
  }
//-------------------------------------- MA1Color()--------------------------------------------- 
double MA1Color(int index)
  {
   double a =0;
   if(handle_iCustomMA1Color>INVALID_HANDLE)
     {
      double valoriMA1Color[];
      if(CopyBuffer(handle_iCustomMA1Color,0,index,1,valoriMA1Color)>0){a = valoriMA1Color[0];}
     }
   return a;
  }



/*-------------------------------------- Moving ()---------------------------------------------
double Moving()
  {
   return iMA(Symbol(),TimeFrameMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price,0);
  }
*/
//-------------------------------------- Moving ()--------------------------------------------- Moving con iCustom
double Moving()
  {
      double a =0;

   if(handle_MA>INVALID_HANDLE)
     {
      double valoriMA[];
      if(CopyBuffer(handle_MA,0,0,1,valoriMA)>0){a = valoriMA[0];}
     }
   return a;
  }
  /*
//-------------------------------------- MovingSh ()---------------------------------------------

double MovingSh(int index)
  {
   return iMA(Symbol(),TimeFrTEMA,Moving_period,Moving_shift,Moving_method,Moving_applied_price,index);
  }*/
  
//-------------------------------------- MovingSh ()--------------------------------------------- MovingSh con iCustom

double MovingSh(int index)
  {
      double a =0;

   if(handle_MA>INVALID_HANDLE)
     {
      double valoriMA[];
      if(CopyBuffer(handle_MA,0,index,1,valoriMA)>0){a = valoriMA[0];}
     }
   return a;
  }  
//-------------------------------------- iTEMA ()---------------------------------------------
double TEMA()
  {
   double a =0;
   int handleTEMA = iTEMA(Symbol(),TimeFrTEMA,TEMA_period,TEMAShift,TEMA_method);
   if(handleTEMA>INVALID_HANDLE)
     {
      double valoriTEMA[];
      if(CopyBuffer(handleTEMA,0,0,1,valoriTEMA)>0){a = valoriTEMA[0];}
     }
   return a;
  }
//-------------------------------------- TEMASh ()---------------------------------------------

double TEMASh(int index)
  {
   double a =0;
   int handleTEMA = iTEMA(Symbol(),TimeFrTEMA,TEMA_period,TEMAShift,TEMA_method);
   if(handleTEMA>INVALID_HANDLE)
     {
      double valoriTEMA[];
      if(CopyBuffer(handleTEMA,0,index,1,valoriTEMA)>0){a = valoriTEMA[0];}
     }
   return a;
  }
/*

bool OrdiniSuStessaCandela(bool ordStCand, ulong mag,string comm)
  {
   bool a = true;
   if(ordStCand)return a;
     
   int static pos = 0;    // Numero posizioni aperte
   int static cand = 0;   // Numero candela all'apertura ordine
   int numOrd = NumPrimiOrdini(mag);
   
   if(numOrd < pos) {pos  = numOrd;}   //se chiude posizioni
   if(numOrd > pos)    //se apre nuove posizioni o chiude posizioni
     {
      pos  = numOrd;    // "a" memorizza il numero di posizioni aperte
      cand = iBars(Symbol(),PERIOD_CURRENT);
     } // "b" memorizza la candela di variazione posizioni

   if(pos == numOrd && cand == iBars(Symbol(),PERIOD_CURRENT)) {a = false;}

   if(pos == numOrd && cand != iBars(Symbol(),PERIOD_CURRENT)) {a = true;}

   return a;
  }
*/

// Pendenze Enable Ordini
bool GestionePendEnableBuy()
   {
   bool a = true;
   if(CandCheckOpe==0){return a;}  
   if(combEnab==0)
   {
 for(int i=0;i<=CandCheckOpe;i++)
   {
   double ema1 = MAFast(i+1);
   double ema1x = MAFast(i+2); 
    
   if(ema1>ema1x && i>=CandCheckOpe) {a=true;
   //Print("Num Cand pendenze rialziste ",i);
   break;}
   if(ema1<ema1x) {a=false;
   //Print("Num Cand rialziste ",i);
   break;}  
   }} 
      if(combEnab==1)
   {
   for(int i=0;i<=CandCheckOpe;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2);         
// Print(" Medie rialziste: ",ema1>ema1x && ema2>ema2x);     
   if(ema1>ema1x && ema2>ema2x && i>=CandCheckOpe) {a=true;
   //Print("Num Cand pendenze rialziste ",i);
   break;}
   if(ema1<ema1x || ema2<ema2x) {a=false;
   //Print("Num Cand rialziste ",i);
   break;}  
   }}
   
      if(combEnab==2)
   {
   for(int i=0;i<=CandCheckOpe;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2);         
   double ema3 = MAFast(i+1);
   double ema3x = MAFast(i+2); 
    
   if(ema1>ema1x && ema2>ema2x && ema3>ema3x && i>=CandCheckOpe) {a=true;
//Print("Num Cand pendenze rialziste ",i);
   break;}
   if(ema1<ema1x || ema2<ema2x || ema3<ema3x) {a=false;
   //Print("Num Cand rialziste ",i);
   break;}  
   }}   
   return a;
   }   

bool GestionePendEnableSell() 
   {
//Print(" combClose: ",combClose," CandCheckOpe: ",CandCheckOpe);
   bool a = true;  
   if(CandCheckOpe==0){return a;}  

      if(combEnab==0)
   {    
   for(int i=0;i<=CandCheckOpe;i++)
   {
   double ema1 = MAFast(i+1);
   double ema1x = MAFast(i+2); 
 
   if(ema1<ema1x && i==CandCheckOpe) {a=true;
   //Print("Num Cand pendenze ribassiste ",i);
   break;}
   if(ema1>ema1x) {a=false;
   //Print("Num Cand ribassiste ",i);
   break;}
   }}
   
      if(combEnab==1)
   {    
   for(int i=0;i<=CandCheckOpe;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2); 
//Print(" ema1:",ema1," ema1x: "," ema2: ",ema2," ema2x: ",ema2x);
   if(ema1<ema1x && ema2<ema2x && i==CandCheckOpe) {a=true;
   //Print("Num Cand pendenze ribassiste ",i);
   break;}
   if(ema1>ema1x || ema2>ema2x) {a=false;
   //Print("Num Cand ribassiste ",i);
   break;}
   }}
   
      if(combEnab==2)
   {
   for(int i=0;i<=CandCheckOpe;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2);         
   double ema3 = MAFast(i+1);
   double ema3x = MAFast(i+2); 
    
   if(ema1<ema1x && ema2<ema2x && ema3<ema3x && i>=CandCheckOpe) {a=true;
   //Print("Num Cand pendenze rialziste ",i);
   break;}
   if(ema1>ema1x || ema2>ema2x || ema3>ema3x) {a=false;
   //Print("Num Cand rialziste ",i);
   break;}  
   }}  
   
   return a;
   }     

// Pendenze Chiudi Ordini

    
bool GestionePendenzeBuy()
   {
   bool a = true;
   if(CandCheckClo>0) a = patternPendRialzista();
   return a;
   }  

bool GestionePendenzeSell()
   {
   bool a = true;
   if(CandCheckClo>0) a = patternPendRibassista();
   return a;
   } 
bool patternPendRialzista()
   {
   bool a = false;
   if(CandCheckClo==0){return a;}  
   
     if(combClose==0)
   {
 for(int i=0;i<=CandCheckClo;i++)
   {
   double ema1 = MAFast(i+1);
   double ema1x = MAFast(i+2); 
    
   if(ema1>ema1x) {a=true;
//Print("Num Cand pendenze rialziste ",i);
   break;}
   if(ema1<ema1x && i>=CandCheckClo) {a=false;
   //Print("Num Cand rialziste ",i);
   break;}  
   }} 
      if(combClose==1)
   {
   for(int i=0;i<=CandCheckClo;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2);         
  
   if(ema1>ema1x && ema2>ema2x) {a=true;
//Print("Num Cand pendenze rialziste ",i);
   break;}
   if((ema1<ema1x || ema2<ema2x) && i>=CandCheckClo) {a=false;
//Print("Num Cand rialziste ",i);
   break;}  
   }}
   
      if(combClose==2)
   {
   for(int i=0;i<=CandCheckClo;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2);         
   double ema3 = MAFast(i+1);
   double ema3x = MAFast(i+2); 
    
   if(ema1>ema1x && ema2>ema2x && ema3>ema3x) {a=true;
//Print("Num Cand pendenze rialziste ",i);
   break;}
   if((ema1<ema1x || ema2<ema2x || ema3<ema3x) && i>=CandCheckClo) {a=false;
//Print("Num Cand rialziste ",i);
   break;}  
   }}   
   return a;
   }   

bool patternPendRibassista() 
   {
//Print(" combClose: ",combClose," CandCheckOpe: ",CandCheckOpe);
   bool a = false;  
   if(CandCheckClo==0){return a;}  

      if(combClose==0)
   {    
   for(int i=0;i<=CandCheckClo;i++)
   {
   double ema1 = MAFast(i+1);
   double ema1x = MAFast(i+2); 
 
   if(ema1<ema1x) {a=true;
//Print("Num Cand pendenze ribassiste ",i);
   break;}
   if(ema1>ema1x && i==CandCheckClo) {a=false;
//Print("Num Cand ribassiste ",i);
   break;}
   }}
   
      if(combClose==1)
   {    
   for(int i=0;i<=CandCheckClo;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2); 
//Print(" ema1:",ema1," ema1x: "," ema2: ",ema2," ema2x: ",ema2x);
   if(ema1<ema1x && ema2<ema2x) {a=true;
//Print("Num Cand pendenze ribassiste ",i);
   break;}
   if((ema1>ema1x || ema2>ema2x) && i==CandCheckClo) {a=false;
//Print("Num Cand ribassiste ",i);
   break;}
   }}
   
      if(combClose==2)
   {
   for(int i=0;i<=CandCheckClo;i++)
   {
   double ema1 = TEMASh(i+1);
   double ema1x = TEMASh(i+2); 
   double ema2 = MovingSh(i+1);
   double ema2x = MovingSh(i+2);         
   double ema3 = MAFast(i+1);
   double ema3x = MAFast(i+2); 
    
   if(ema1<ema1x && ema2<ema2x && ema3<ema3x) {a=true;
//Print("Num Cand pendenze rialziste ",i);
   break;}
   if((ema1>ema1x || ema2>ema2x || ema3>ema3x) && i>=CandCheckClo) {a=false;
//Print("Num Cand rialziste ",i);
   break;}  
   }}  
   
   return a;
   }     
   
void ChiudeOrdPendenze()
{
//Print(" Rialzista(): ",patternPendRialzista()," Ribassista(): ",patternPendRibassista());  
   if(!CandCheckClo || pendClosOrd == 1)return;
   if(CandCheckClo && pendClosOrd==2) 
{
//Print(" NumOrdBuy: ",NumOrdBuy(magic_number,Commen)," !patternPendRialzista(): ",!patternPendRialzista());
//Print(" NumOrdSell: ",NumOrdSell(magic_number,Commen)," !patternPendRibassista(): ",!patternPendRibassista());
   if(NumOrdBuy(magic_number,Commen)==1 && !patternPendRialzista()) {brutalCloseBuyPositions(Symbol());}
   if(NumOrdSell(magic_number,Commen)==1 && !patternPendRibassista()) {brutalCloseSellPositions(Symbol());}
}
   if(CandCheckClo && pendClosOrd==3) 
{
   if(NumOrdBuy(magic_number,Commen)==1 && !patternPendRialzista()) brutalCloseAllProfitableTrades(Symbol());
   if(NumOrdSell(magic_number,Commen)==1 && !patternPendRibassista()) brutalCloseAllProfitableTrades(Symbol());
}
}   
   
//+------------------------------------------------------------------+
//|                       Input e variabili export                   |
//+------------------------------------------------------------------+
void inputVar(char Ts_Be,char n)
  {
   char Ts_Be_=Ts_Be;
  }

//+------------------------------------------------------------------+
//|                        calcoloTakeProfitBuy                      |
//+------------------------------------------------------------------+
int calcoloTakeProfitBuy()
  {
  ulong TikBuy = TicketPrimoOrdineBuy(magicNumber,Commen);
   if(TpSlInProfit && TikBuy!=0 && PositionTakeProfit(TikBuy)>0 && PositionStopLoss(TikBuy) > OrderOpenPrice(TikBuy)) PositionModify(TikBuy,PositionStopLoss(TikBuy),0);
  
   if(TakeProfit == 0) return 0; //No Take profit
   if(TakeProfit == 1)
      return TpPoints;  //Take profit Points
   else
     {
      Alert("Impostazione Modalità Take Profit Errata!");
      return 0;
     };
  }
//+------------------------------------------------------------------+
//|                        calcoloTakeProfitSell                     |
//+------------------------------------------------------------------+
int calcoloTakeProfitSell()
  {
  ulong TikSell = TicketPrimoOrdineSell(magicNumber,Commen);

   if(TpSlInProfit && TikSell!=0 && PositionTakeProfit(TikSell)>0 && PositionStopLoss(TikSell)!=0 && PositionStopLoss(TikSell) < PositionOpenPrice(TikSell)) PositionModify(TikSell,PositionStopLoss(TikSell),0);
   
   if(TakeProfit == 0) return 0; //No Take profit
   if(TakeProfit == 1)
      return TpPoints;  //Take profit Points
   else
     {
      Alert("Impostazione Modalità Take Profit Errata!");
      return 0;
     };
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
   if(a == true) Print("EA: Account Ok!");
   else
     {(Print("EA: trial license expired or Account without permission")); ExpertRemove();}
   return a;
  }
  
double calcoloStopLoss(string BuySell,double openPrOrd)
{
double SL=0;
if(BuySell=="Buy")SL=openPrOrd-SlPoints*Point();
if(BuySell=="Sell")SL=openPrOrd+SlPoints*Point();
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
//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{  
   double c1 = iClose(Symbol(),PERIOD_CURRENT,1);
   double o1 = iOpen(Symbol(),PERIOD_CURRENT,1);
   int StopLossBuy=0;
   int StopLossSell=0;
   bool buy=true;
   bool sell=true;
   int ordBuy=NumOrdBuy(magic_number,Commen);
   int ordSell=NumOrdSell(magic_number,Commen);
   int Orders=NumOrdini(magic_number,Commen);
   bool atr=GestioneATR();
  
   bool timeTrading=InTradingTime(InpStartHour,InpStartMinute,InpEndHour,InpEndMinute,Fuso,FusoEnable) || InTradingTime(InpStartHour1,InpStartMinute1,InpEndHour1,InpEndMinute1,Fuso,FusoEnable);
   if(IsMarketTradeOpen() && (!isNewsEvent())&&TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {enableTrading=true;}
   else
     {enableTrading=false;}
 /*    
Print(" enableTrading: ",enableTrading," timeTrading: ",timeTrading," SpreadMax(): ",SpreadMax()," !ManualStopNewsOrders(): ",!ManualStopNewsOrders());     
Print(" GestioneMASupInf(): ",GestioneMASupInf()," GestioneATR(): ",GestioneATR()," limiteNumOrd(): ",limiteNumOrd()," limiteOrdDay(): ",limiteOrdDay());        
Print(" OpenCloseOrderSameCandle(): ",OpenCloseOrderSameCandle()," OrdiniSuStessaCandela(OrdiniSuStessaCandela,magicNumber,Commen): ",OrdiniSuStessaCandela(OrdiniSuStessaCandela,magicNumber,Commen));           
  */   
//Print(" Ordini Aperti o Chiusi: ",OrdiniSuStessaCand(OrdEChiuStessaCandela,magic_number)); 
//Print(" Ordini Aperti: ",OrdiniSuStessaCandela(OrdiniSuStessaCandela,magicNumber,Commen));     
   enableTrading = 
                  enableTrading 
                  && timeTrading && SpreadMax() 
                  && !ManualStopNewsOrders() 
                  && GestioneMASupInf() 
                  && GestioneATR()
                  && limiteNumOrd() 
                  && limiteOrdDay()
                  && OrdiniSuStessaCand(OrdEChiuStessaCandela,magic_number)   
                  && OrdiniSuStessaCandela(OrdiniSuStessaCandela,magicNumber,Commen)
                  ;         
   
   FilterZZBody(InpCandlesCheck,enableBuyZZ,sogliaBuyZZ,enableSellZZ,sogliaSellZZ);  
   
   ChiudeOrdPendenze();

//+------------------------------------------------------------------+
//|                         Controllo Buy                            |
//+------------------------------------------------------------------+

      int TakeProfBuy = calcoloTakeProfitBuy();

      distanzaSL = NormalizeDouble((10000)/Point(),Digits());
      
   //if(GridHedge!=0){StopLossBuy=calcolatore_SL() - StartGrid*Point();}
   if(GridHedge!=0){StopLossBuy=0;}
   if(GridHedge==0){StopLossBuy=SlPoints;}           
/* 
Print(" enableTrading: ",enableTrading," !TicketPrimoOrdineBuy(magic_number): ",!TicketPrimoOrdineBuy(magic_number)," segnoUltimoZigaZagBuy(): ",segnoUltimoZigaZagBuy(),
      " direzioneCandZero: ",direzioneCandZero(direzCandZero,"Buy"));     
Print(" direzioneCandUno: ",direzioneCandUno(direzCandUno,"Buy")," FiltroPivot: ",FiltroPivot("Buy",filtroPivot_,TypePivot_),
      " TypeOrdBuySell: ",TypeOrdBuySell("Buy",Type_Orders_)," enableBuyZZ: ",enableBuyZZ);        
Print(" GestioneMASupBuy(): ",GestioneMASupBuy()," GestionePendenzeBuy: ",GestionePendenzeBuy()," GestionePendEnableBuy(): ",GestionePendEnableBuy());   
  */
//if(BreakEnableBuy)Print(" BreakEnableBuy: ",BreakEnableBuy); 
//if(BreakEnableSell)Print(" BreakEnableSell: ",BreakEnableSell);            
bool FiltroBuy = 
        enableTrading
      &&!TicketPrimoOrdineBuy(magic_number)
      //&&!NumPosizioni(magic_number)
      &&segnoUltimoZigaZagBuy()
      &&direzioneCandZero(direzCandZero,"Buy")
      &&direzioneCandUno(direzCandUno,"Buy")
      &&FiltroPivot("Buy",filtroPivot_,TypePivot_)
      &&TypeOrdBuySell("Buy",Type_Orders_)
      &&enableBuyZZ
      &&GestioneMASupBuy()
      &&GestionePendenzeBuy()
      &&GestionePendEnableBuy()
      &&BreakEnableBuy
      ;  
//Print(" Enable Total Buy: ", FiltroBuy);                           
  
   if(FiltroBuy) 
      {SendTradeBuyInPoint(symbol_,lotBuyOrderInversGrid(),Deviazione,StopLossBuy,TakeProfBuy,Commen,magic_number);}///////   Inserimento ordine buy
       TicketHedgeBuy[0] = ordBuy;
//+------------------------------------------------------------------+
//|                         Controllo Sell                           |
//+------------------------------------------------------------------+

      int TakeProfSell = calcoloTakeProfitSell();

      distanzaSL = NormalizeDouble((10000)/Point(),Digits());

      if(GridHedge!=0){StopLossSell=0;}
      if(GridHedge==0){StopLossSell=SlPoints;}
 
      bool FiltroSell=enableTrading
      &&!TicketPrimoOrdineSell(magic_number,Commen)
      //&&!NumPosizioni(magic_number)
      &&segnoUltimoZigaZagSell()
      &&direzioneCandZero(direzCandZero,"Sell")
      &&direzioneCandUno(direzCandUno,"Sell")
      &&FiltroPivot("Sell",filtroPivot_,TypePivot_)
      &&TypeOrdBuySell("Sell",Type_Orders_)
      &&enableSellZZ
      &&GestioneMAInfSell()
      &&GestionePendenzeSell()
      &&GestionePendEnableSell()
      &&BreakEnableSell
      ;  
//Print(" Enable Total Sell: ", FiltroSell);                 
   //if(FiltroSell&&Bid(Symbol())<TEMA()&&Bid(Symbol())>MovingSh(0)&&GestioneTEMASell()&&GestioneMASell())
    //  ||(FiltroSell&&Bid(Symbol())<TEMA()&&Bid(Symbol())<MovingSh(0)&&GestioneTEMASell()&&GestioneMASell())

   if(FiltroSell) 
      {SendTradeSellInPoint(symbol_,lotSellOrderInversGrid(),Deviazione,StopLossSell,TakeProfSell,Commen,magic_number);}////// Inserimento ordine sell
       TicketHedgeSell[0] = ordSell;
  }
  
bool limiteOrdDay() // Da fare
{
bool a = true;
return a;
}  
  
  
  
bool limiteNumOrd()
{
bool a = true;
if(NumOrdini(magicNumber,Commen)>=N_Max_pos) a = false;
return a;
} 
//+------------------------------------------------------------------+
//|                        handleZigZag()                            |
//+------------------------------------------------------------------+
int handleZigZag()
  {
//--- create handle of the indicator iCustom
//   handle_iCustomZigZag=iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InptBackstep);
//--- if the handle is not created
   if(handle_iCustomZigZag==INVALID_HANDLE)
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
//+------------------------ZIGZAG()--------------------------------+
double ZIGZAG()
  {
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++)
     {
      ZigzagBuffer[i]=0;
     }
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustomZigZag,0,start_pos,count,ZigzagBuffer))
      return  valoreZigZag;

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

//+-------------------------ZIGZAGHiLo()-----------------------------+
double ZIGZAGHiLo()
  {
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++)
     {
      ZigzagBuffer[i]=0;
     }
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustomZigZag,0,start_pos,count,ZigzagBuffer))
      return  valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
           {
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)||ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);
                 }
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);
                 }
              }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)||ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);
                 }
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);
                 }
              }
            semaforo=false;
           }
        }
     }
   return valoreZigZag;
  }
//+------------------------------------------------------------------+ Restituisce il valore di picco dell'ultimo zigzag. 
//|                        FilterZZBody()                            |             Il bool buy e sell: true quando il prezzo oltrepassa il valore "interno" della candela di zigzag.(Swing Chart)
//+------------------------------------------------------------------+             I valori interni della candela di zigzag
double FilterZZBody(int InpCandlesCheck_, bool &enableBuy, double &sogliaBuy, bool &enableSell, double &sogliaSell)
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
   if(counter>=15)
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
   int start_pos=0,count=InpCandlesCheck_+1;
   if(!iGetArray(handle_iCustomZigZag,0,start_pos,count,ZigzagBuffer))
      return valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         //if(semaforo && disMinCandZZ <= i)
         if(semaforo && 1 <= i)
           {enableBuy_=0;enableSell_=0;
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)||ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  sogliaSell_=iClose(Symbol(),PERIOD_CURRENT,i);
                 }
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  sogliaSell_=iOpen(Symbol(),PERIOD_CURRENT,i);
                 }
                     if (Bid(Symbol()) < sogliaSell_)enableSell_=true;//Print(" Bid: ",Bid(Symbol())," sogliaSell_ ",sogliaSell_);
                     if (Bid(Symbol()) >= sogliaSell_)enableSell_=false;
              }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)||ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  sogliaBuy_=iOpen(Symbol(),PERIOD_CURRENT,i);
                 }
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  sogliaBuy_=iClose(Symbol(),PERIOD_CURRENT,i);
                 }
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
   sogliaBuy=sogliaBuy_;
   sogliaSell=sogliaSell_;    
   return valoreZigZag;
  }
  


//+------------------------------------------------------------------+
//|                            SpreadMax                             |
//+------------------------------------------------------------------+
bool SpreadMax()
  {
   bool a=false;
   if(MaxSpread==0 || ((Spread(Symbol()) < MaxSpread) && MaxSpread!=0))
     {
      a=true;
     }
   return a;
  }
  
//+------------------------------------------------------------------+
//|                     ManualStopNewsOrders                         |
//+------------------------------------------------------------------+
bool ManualStopNewsOrders()
  {
   bool a=false;
   static char xxx=0;
   if(!StopNewsOrders)
     {
      xxx=0;
      a = false;
      return a;
     }
   if(StopNewsOrders&&NumPosizioni(magic_number)==0&&xxx==0)
     {
      Print("Auto Stop News Orders EA ",Symbol());
      Comment("Auto Stop News Orders EA ",Symbol());
      Alert("Auto Stop News Orders EA ",Symbol());
      xxx++;
     }
   if(StopNewsOrders&&NumPosizioni(magic_number)==0)
      a = true;
   return a;
  }

  
//+------------------------------------------------------------------+
//|                        GestioneMASupBuy()                        |
//+------------------------------------------------------------------+
bool GestioneMASupBuy()
  {
   bool a=false;
   
   if(!TEMA() || !MovingSh(0)) return a;

   double valSupMA = ValoreSuperiore(TEMA(),MovingSh(0))+(DistanzaMASuperiore+0.0001)*Point(); 
   double valSupMAMax = ValoreSuperiore(TEMA(),MovingSh(0))+(DistanzaMAMaxSuperiore+0.0001)*Point();  
 
      if(!DistanzaMAMaxSuperiore && ASK >= valSupMA) {a=true;return a;}
      if(DistanzaMAMaxSuperiore>0 && doubleCompreso(ASK,valSupMA,valSupMAMax)) {a=true;return a;}
     
   return a;
  }  
 
//+------------------------------------------------------------------+
//|                        GestioneMAInfSell()                       |
//+------------------------------------------------------------------+
bool GestioneMAInfSell()
  {
   bool a=false;
   
   if(!TEMA() || !MovingSh(0)) return a;  

   double valInfMA = ValoreInferiore(TEMA(),MovingSh(0))-(DistanzaMAInferiore+0.0001)*Point();
   double valInfMAMax = ValoreInferiore(TEMA(),MovingSh(0))-(DistanzaMAMaxInferiore+0.0001)*Point();     
  
      if(!DistanzaMAMaxInferiore && BID <= valInfMA) {a=true;return a;}  
      if(DistanzaMAMaxInferiore>0 && doubleCompreso(BID,valInfMA,valInfMAMax)) {a=true;return a;}  
     
   return a;
  }   
//+------------------------------------------------------------------+
//|                         GestioneMASupInf()                       |
//+------------------------------------------------------------------+
bool GestioneMASupInf()
  {
   bool a=false;
   if(!DistanzaMASuperiore && !DistanzaMAInferiore && !DistanzaMAMaxSuperiore && !DistanzaMAMaxInferiore){a=true;return a;} 
   if(!TEMA() || !MovingSh(0)){a=false;return a;}     
   
   double valSupMA = ValoreSuperiore(TEMA(),MovingSh(0))+(DistanzaMASuperiore+0.0001)*Point();
   double valSupMAMax = ValoreSuperiore(TEMA(),MovingSh(0))+(DistanzaMAMaxSuperiore+0.0001)*Point();    
   double valInfMA = ValoreInferiore(TEMA(),MovingSh(0))-(DistanzaMAInferiore+0.0001)*Point();
   double valInfMAMax = ValoreInferiore(TEMA(),MovingSh(0))-(DistanzaMAMaxInferiore+0.0001)*Point();   
         
   if(doubleCompreso(ASK,valSupMA,valSupMAMax)) {a=true;return a;} 
   if(doubleCompreso(BID,valInfMA,valInfMAMax)) {a=true;return a;}  
   
   return a;
  }    

//+------------------------------------------------------------------+
//|                            GestioneATR()                         |
//+------------------------------------------------------------------+
bool GestioneATR()
  {
   bool a=true;
   if(!Filter_ATR){return a;}
   if(Filter_ATR && iATR(Symbol(),periodATR,ATR_period,0) < thesholdATR)
     {a=false;}
   return a;
  }

//+------------------------------------------------------------------+
//|                   lotBuyOrderInversGrid()                        |
//+------------------------------------------------------------------+

double lotBuyOrderInversGrid()
{
double a=myLotSize();
if(lotOrderInversoGrid && GridHedge==1 && NumOrdSell(magic_number) > 0)
{a = LotsUltimoOrdineSell(magic_number);}
return a;
}
//+------------------------------------------------------------------+
//|                  lotSellOrderInversGrid()                        |
//+------------------------------------------------------------------+

double lotSellOrderInversGrid()
{
double a=myLotSize();
if(lotOrderInversoGrid && GridHedge==1 && NumOrdBuy(magic_number) > 0) {a = LotsUltimoOrdineBuy(magic_number);}
return a;
}
//+------------------------------------------------------------------+
//|                   direzionePrezzoZigZag()                        |restituisce  1 se il prezzo è inferiore all'ultimo picco dello ZigZag
//+------------------------------------------------------------------+            -1 se il prezzo è superiore all'ultimo picco dello ZigZag
int direzionePrezzoZigZag()
{
   if(!FilterZigZag)return 0;
   if(ZIGZAG()>iClose(Symbol(),PERIOD_CURRENT,1)) return 1;
   if(ZIGZAG()>iClose(Symbol(),PERIOD_CURRENT,1)) return -1;
   return 0;
}
//+------------------------------------------------------------------+
//|                   segnoUltimoZigaZagBuy()                        |
//+------------------------------------------------------------------+
bool segnoUltimoZigaZagBuy()
{
//Print("BUY--- ZIGZAG: ",ZIGZAG()," iClose(Symbol(),PERIOD_CURRENT,1): ",iClose(Symbol(),PERIOD_CURRENT,1));

   bool a=true;
   if(!FilterZigZag)return a;
   if(ZIGZAG()>iClose(Symbol(),PERIOD_CURRENT,1))a=false;
   return a;
}
//+------------------------------------------------------------------+
//|                   segnoUltimoZigaZagSell()                       |
//+------------------------------------------------------------------+

bool segnoUltimoZigaZagSell()
{//Print("SELL--- ZIGZAG: ",ZIGZAG()," iClose(Symbol(),PERIOD_CURRENT,1): ",iClose(Symbol(),PERIOD_CURRENT,1));
   bool a=true;
   if(!FilterZigZag)return a;
   if(ZIGZAG()<iClose(Symbol(),PERIOD_CURRENT,1))a=false;
   return a;
}

//+------------------------------------------------------------------+
//|                         FiltroPivot()                            |
//+------------------------------------------------------------------+
bool FiltroPivot(string BuySell, int FiltroPivot, int typePivot)
  {
   if(FiltroPivot==0) return true;
   bool a=true;
   if(FiltroPivot==1)
   {
   if(BuySell=="Buy" && Ask(Symbol())<pricePivotD((char)typePivot)) {a=false;return a;}
   if(BuySell=="Sell" && Bid(Symbol())>pricePivotD((char)typePivot)) {a=false;return a;}
   }
   if(FiltroPivot==2)
   {
   if(BuySell=="Buy" && Ask(Symbol())<pricePivotW((char)typePivot)) {a=false;return a;}
   if(BuySell=="Sell" && Bid(Symbol())>pricePivotW((char)typePivot)) {a=false;return a;}
   }
   return a;
   }

//+------------------------------------------------------------------+
//|                      TypeOrdBuySell()                            |
//+------------------------------------------------------------------+  
bool TypeOrdBuySell (string BuySell,int TypeOrders)
{
if(TypeOrders==3)return false;
bool a=false;
if(BuySell=="Buy" &&(TypeOrders==0||TypeOrders==1)){a=true;return a;}
if(BuySell=="Sell"&&(TypeOrders==0||TypeOrders==2)){a=true;return a;}
return a;
}

//+------------------------------------------------------------------+
//|                         Stop Loss da calcolare                   |
//+------------------------------------------------------------------+
double calcolatore_SL()
  {
     {
      return SlPoints;  
     }
  }

//+------------------------------------------------------------------+
//|                          Indicators()                            |
//+------------------------------------------------------------------+
void Indicators()
  {
   char index=0;
/*
input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag*/
         if(FilterZigZag || FilterZZShad)ChartIndicatorAdd(0,0,handle_iCustomZigZag);
         if(periodMAFast>0 && (combEnab!=1 || combClose!=1)) ChartIndicatorAdd(0,0,handle_iCustomMAFast);
         //ChartIndicatorAdd(0,0,handle_iCustomMA1Color);
         ChartIndicatorAdd(0,0,handle_MA);
         ChartIndicatorAdd(0,0,handle_TEMA);

            index ++;
         if(OnChart_ATR)ChartIndicatorAdd(0,index,handleATR);
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



//+------------------------------------------------------------------+
//|                     GestioneGriglia()                            |
//+------------------------------------------------------------------+
void GestioneGrigliaBuy(int TYPEGrid, int startGr, int stepGr, int moltiplStepGrid, int NumerMaxGrid,double Lot,int dev,int StL,int TakePr, ulong mag,string comm)
{
//Griglia Buy
static int countLeggi=0;
if(!TicketPrimoOrdineBuy(mag,comm)){return;}

static ulong TickBuyMem = 0;
static double arrBuy[];
ulong TickBuyNow = TicketPrimoOrdineBuy(mag,comm);

if(TickBuyNow>0 && TickBuyNow != TickBuyMem ) {TickBuyMem = TickBuyNow; componeGrigliaBuy(arrBuy,TickBuyNow,startGr,stepGr,moltStepGrid,NumerMaxGrid);}
if(TickBuyNow) leggeGrigliaBuy(TYPEGrid,arrBuy,TickBuyNow,countLeggi,Lot,dev,StL,TakePr,mag,comm);

}


void leggeGrigliaBuy(int TipoMultipliGriglia, double &arrBuy[], ulong TickBuyNow, int &i, double Lot,int dev,int StL,int TakePr, ulong mag,string comm)
{
for(;i<ArraySize(arrBuy);i++)
{
if(Ask(Symbol()) >= arrBuy[i]) SendTradeBuyInPoint(Symbol(),Lot,dev,StL,TakePr,comm,mag);
}
}


void componeGrigliaBuy(double &arrBuy[],ulong TikBuy,int startGr_, int stepGr_, double moltStGrid, int NumerMaxGrid_)
{
for(int i=0;i<ArraySize(arrBuy);i++){arrBuy[i]=0;}

double openPrBuy = OrderOpenPrice(TikBuy);
for(int i=0;i<NumerMaxGrid_;i++)
{
if(i==0) arrBuy[i] = openPrBuy + startGr_ * Point();
if(i==1) arrBuy[i] = arrBuy[0] + (startGr_ + stepGr_) * Point();
if(i>1) arrBuy[i] = arrBuy[i-1] + (startGr_ + (stepGr_ * moltStGrid)) * Point();
}
}


//+------------------------------------------------------------------+
//|                         isNewsEvent()                            |
//+------------------------------------------------------------------+
bool isNewsEvent()
  {
   if(!FilterNews)return false;
   bool isNews = false;
   int totalNews = 0;
   datetime OraOldNews=0;
   datetime OraNews_=0;
   datetime x = (datetime)0;
   datetime y = D'3000.01.01 00:00:00';

   MqlCalendarValue values[];
   datetime startTime = TimeTradeServer()-PeriodSeconds(startime_);
   datetime endTime = TimeTradeServer()+PeriodSeconds(endtime_);
   int valuesTotal = CalendarValueHistory(values,startTime,endTime);

//Print(">>> TOTAL VALUES = ",valuesTotal," || ArraySize = ",ArraySize(values));

   if(valuesTotal >= 0)
     {
      //Print("TIME CURRENT = ",TimeTradeServer());
      //ArrayPrint(values);
     }

   datetime timeRange = PeriodSeconds(rangetime_);
   datetime timeBefore = TimeTradeServer() - timeRange;
   datetime timeAfter = TimeTradeServer() + timeRange;

//Print("FURTHEST TIME LOOK BACK = ",timeBefore," >>> CURRENT = ",TimeTradeServer());
//Print("FURTHEST TIME LOOK FORE = ",timeAfter," >>> CURRENT = ",TimeTradeServer());

   for(int i=0; i < valuesTotal; i++)
     {
      MqlCalendarEvent event;
      CalendarEventById(values[i].event_id,event);

      MqlCalendarCountry country;
      CalendarCountryById(event.country_id,country);

      //Print("NAME = ",event.name,", COUNTRY = ",country.name);

      if(StringFind(_Symbol,country.currency) >= 0)
        {
         if(event.importance == levelImpact)
           {
            if(values[i].time <= TimeTradeServer() && values[i].time >= timeBefore)
              {
               //Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
               //     values[i].time," (ALREADY RELEASED)");

               if(values[i].time > x)
                 {
                  x = OraOldNews = values[i].time;
                 }
               totalNews++;
              }
            if(values[i].time >= TimeTradeServer() && values[i].time <= timeAfter)
              {
               //Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
               //      values[i].time," (NOT YET RELEASED)");

               if(values[i].time < y && values[i].time > (datetime) 0)
                 {
                  y = OraNews_ = values[i].time;
                 }
               //Print("totalNews: ",totalNews);
               totalNews++;
              }
           }
        }
     }
   OraNews=OraNews_;
 //  Print(" OraNews: ",OraNews);
  // Print(" OraOldNews: ",OraOldNews);

//Print(" totalNews: ",totalNews,
//      " OraNews : ",OraNews," <= "," TimeTradeServer() + (datetime)StopBefore*60: ",TimeTradeServer() + (datetime)StopBefore*60," || ");
//Print(" OraOldNews + (datetime)StopAfter*60: ",OraOldNews + (datetime)StopAfter*60," >= "," TimeTradeServer(): ",TimeTradeServer());
   
   
   if(OraNews!=0 && totalNews > 0){if(OraNews <= TimeTradeServer() + (datetime)StopBefore*60) isNews = true;}
   if(OraOldNews!=0 && totalNews > 0){if(OraOldNews + (datetime)StopAfter*60 >= TimeTradeServer()) isNews = true;}

   if(totalNews > 0)
     {
      //Print(" >>>>>>>> (FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
     }
   else
      if(totalNews <= 0)
        {
         isNews = false;
         //Print(" >>>>>>>> (NOT FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
        }
   //Print("isNews: ",isNews);
   return (isNews);
  }
//+------------------------------------------------------------------+
//|                        GestioneGrid()                            |
//+------------------------------------------------------------------+
void GestioneGrid()
  {
   if(GridHedge==1)
     {
      PositionSelectByIndex(0);
      double Ask,Bid;
      Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
      Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      static double arrayGridLossBuy[50];
      static double arraysGridLossSell[50];

      static char  NumOrdBuyGrid=0;
      static char  NumOrdSellGrid=0;
      double LotGridBuy=0;
      double LotGridSell=0;

      static int indexBuy ;
      static int indexSell;

      /////////////////////////////////
      if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
        {
         PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
        }
      if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
        {
         PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
        }

      /////////////////////////////////////


      if(!NumOrdBuy(magic_number) && !NumOrdSell(magic_number))
        {
         return;
        }

      if(NumOrdBuy(magic_number)>1&&NumOrdSell(magic_number)==1&&PositionTakeProfit(TicketPrimoOrdineSell(magic_number))!=0.0)
        {
         PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
        }
      if(NumOrdSell(magic_number)>1&&NumOrdBuy(magic_number)==1&&PositionTakeProfit(TicketPrimoOrdineBuy(magic_number)!=0.0))
        {
         PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
        }

      if(GridBuyActive && PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_BUY)>= profitGrid)
        {
         brutalCloseBuyPositions(Symbol(),magic_number);
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;
        }

      if(GridSellActive && PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_SELL)>= profitGrid)
        {
         brutalCloseSellPositions(Symbol(),magic_number);
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;
        }

      if(((GridBuyActive || GridSellActive) && (PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_BUY)
            +PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_SELL))>= profitGrid) || DDMax(maxDDPerc,magic_number) || SemaforoCandPrimoOrdine(CloseOrdDopoNumCandDalPrimoOrdine,magic_number))
        {
         brutalCloseTotal(Symbol(),magic_number);
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;
         return;
        }

      if(GridHedge!=0 && !NumOrdBuy(magic_number))
        {
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;

         //------------------azzera array arrayGridLossBuy -----------
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
           {
            arrayGridLossBuy[aa] = 0.0;
           }
        }

      if(GridHedge!=0 && !NumOrdSell(magic_number))
        {
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;

         if(!BEPointConGridOHedgeActive && (GridBuyActive || GridSellActive))
           {
            if(PositionStopLoss(TicketPrimoOrdineBuy(magic_number)))
              {
               PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
              }
            if(PositionStopLoss(TicketPrimoOrdineSell(magic_number)))
              {
               PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
              }
           }

         //------------------azzera array arraysGridLossSell -----------
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
           {
            arraysGridLossSell[aa] = 0.0;
           }
        }

      if((NumOrdBuy(magic_number)||NumOrdSell(magic_number)) && GridHedge!=0)
        {
         if(!NumOrdBuy(magic_number))
           {
            indexBuy=0;
            GridBuyActive=false;
            NumOrdBuyGrid=0;
           }

         if(NumOrdBuy(magic_number) && Bid<OpenPricePrimoOrdineBuy(magic_number))
           {
            if(NumOrdBuy(magic_number))
              {
               for(int i=0; i<=NumMaxGrid; i++)
                 {
                  if(i==0){arrayGridLossBuy[i]=OpenPricePrimoOrdineBuy(magic_number)-((StartGrid)*Point());}                                                                                                                                                                                                                                             

                  if(i>0){arrayGridLossBuy[i]=arrayGridLossBuy[i-1]-(((MathPow(moltStepGrid,i-1)*StepGrid))*Point());}
                 }

               for(int i=indexBuy; i<NumMaxGrid; i++)

                 {
                  if(MoltipliNumGrid<=(NumOrdBuy(magic_number)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0)
                       {
                        LotGridBuy=LotsPrimoOrdineBuy(magic_number)*MoltiplLotStep;
                       }
                     if(TypeGrid == 1)
                       {
                        LotGridBuy=NormalizeDoubleLots(LotsUltimoOrdineBuy(magic_number)*MoltiplLotStep);
                       }
                    }
                  if(MoltipliNumGrid> (NumOrdBuy(magic_number)-1) && MoltipliNumGrid >= 0)
                    {
                     LotGridBuy=LotsPrimoOrdineBuy(magic_number);
                    }

                  if(SymbolInfoDouble(Symbol(),SYMBOL_ASK)<=arrayGridLossBuy[indexBuy])

                    {
                     SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);
                     indexBuy=i+1;
                     GridBuyActive=true;
                     NumOrdBuyGrid++;
                     if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0)
                       {
                        PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
                       }
                     if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0&&TpSeDueOrdini)
                       {
                        PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
                       }
                    }
                 }
              }
           }

         if(!PositionsTotalSell(Symbol(),magic_number))
           {
            indexSell=0;
            GridSellActive=false;
            NumOrdSellGrid=0;
           }

         if(PositionsTotalSell(Symbol(),magic_number) && Ask>OpenPricePrimoOrdineSell(magic_number))
           {
            if(NumOrdSell(magic_number))
              {

               for(int i=0; i<=NumMaxGrid; i++)
                 {
                  if(i==0){arraysGridLossSell[i]=OpenPricePrimoOrdineSell(magic_number)+(StartGrid)*Point();}

                  if(i>0){arraysGridLossSell[i]=arraysGridLossSell[i-1]+(((MathPow(moltStepGrid,i-1)*StepGrid))*Point());}
                 }
              }
            for(int i=indexSell; i<NumMaxGrid; i++)
              {
               if(MoltipliNumGrid<=(NumOrdSell(magic_number)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0)
                    {
                     LotGridSell=LotsPrimoOrdineSell(magic_number)*MoltiplLotStep;
                    }
                  if(TypeGrid == 1)
                    {
                     LotGridSell=NormalizeDoubleLots(LotsUltimoOrdineSell(magic_number)*MoltiplLotStep);
                    }
                 }
               if(MoltipliNumGrid> (NumOrdSell(magic_number)-1) && MoltipliNumGrid >= 0)
                 {
                  LotGridSell=LotsPrimoOrdineSell(magic_number);
                 }

               if(SymbolInfoDouble(Symbol(),SYMBOL_BID)>=arraysGridLossSell[indexSell])

                 {
                  SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);
                  indexSell=i+1;
                  GridSellActive=true;
                  NumOrdSellGrid++;
                  if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0)
                    {
                     PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
                    }
                  if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0&&TpSeDueOrdini)
                    {
                     PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
                    }

                 }
              }
           }
        }
     }
  }
  
//+------------------------------------------------------------------+
//|                         GestioneHedge()                          |
//+------------------------------------------------------------------+
void GestioneHedge()
  {
   if(GridHedge!=2)
     {return;}
/*     
   if(SemaforoCandPrimoOrdine(CloseOrdDopoNumCandDalPrimoOrdine,magic_number))
     {brutalCloseTotal(Symbol(),magic_number);}
 */    
   ulong ticketPrimoOrdBuy = TicketPrimoOrdineBuy(magic_number);
   ulong ticketPrimoOrdSell= TicketPrimoOrdineSell(magic_number);   
      
   if(TicketHedgeBuy[0]==0.0 && TicketHedgeSell[0]==0.0)
     {
      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
        {TicketHedgeBuy[aa] = 0;}
        
      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
        {TicketHedgeSell[aa] = 0;}return;
     }

   if(!BEPointConGridOHedgeActive && (GridBuyActive || GridSellActive))
     {
      if(PositionStopLoss(ticketPrimoOrdBuy))
        {
         PositionModify(ticketPrimoOrdBuy,0,0,true);
        }
      if(PositionStopLoss(ticketPrimoOrdSell))
        {
         PositionModify(ticketPrimoOrdSell,0,0,true);
        }
     }
   if(PositionTakeProfit(ticketPrimoOrdBuy)>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
     {
      PositionModify(ticketPrimoOrdBuy,0,0,true);
     }
   if(PositionTakeProfit(ticketPrimoOrdSell)>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
     {
      PositionModify(ticketPrimoOrdSell,0,0,true);
     }

   PositionSelectByIndex(0);
   double Ask,Bid;
   Ask=ASK;
   Bid=BID;

   static ulong OldTicketPrimoOrdineBuy;   //x Semaforo creazione griglia Buy
   static ulong OldTicketPrimoOrdineSell;  //x Semaforo creazione griglia Sell

   static double arrayGridProfitBuy[50];   //Griglia profit Buy
   static double arrayGridLossBuy[50];     //Grilia Loss Buy

   static double arraysGridProfitSell[50]; //Griglia profit Sell
   static double arraysGridLossSell[50];   //Griglia Loss Sell

   double LotGridBuy=0;
   double LotGridSell=0;

   static int indexBuy ;
   static int indexSell;
   static int indexBuyProfit ;
   static int indexSellProfit;

   if(profitGrid<=PositionsProfitTotal(magic_number))
  {
      brutalCloseTotal(symbol_,magic_number);
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++){TicketHedgeBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++){arrayGridProfitBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++){TicketHedgeSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++){arraysGridProfitSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0;}
      return;
     }
   //if(TicketPresente(TicketHedgeBuy[0],magic_number) && TicketHedgeBuy[0]!=0.0)
      if(ticketPrimoOrdBuy)
     {
      if(OldTicketPrimoOrdineBuy!=ticketPrimoOrdBuy)
        {
         //a=1;
         OldTicketPrimoOrdineBuy=ticketPrimoOrdBuy;
         indexBuy=0;
         indexBuyProfit=0;
         GridBuyActive=false;

         for(int aa=1; aa<ArraySize(TicketHedgeBuy); aa++){TicketHedgeBuy[aa] = 0;}
         for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++){arrayGridProfitBuy[aa] = 0;}
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0;}
        }

      //Crea grid profit e loss BUY

      for(int i=0; i<=NumMaxGrid; i++)
        {
         if(i==0){arrayGridProfitBuy[i]=PositionOpenPrice(ticketPrimoOrdBuy)+((StepGrid)*Point());}
         
         if(i>0){arrayGridProfitBuy[i]=arrayGridProfitBuy[i-1]+(((MathPow(moltStepGrid,i-1)*StepGrid))*Point());}
        }
     }
     
   for(int i=0; i<=NumMaxGrid; i++)
     {
      if(i==0){arrayGridLossBuy[i]=PositionOpenPrice(ticketPrimoOrdBuy)-((StartGrid)*Point());}
        
      if(i>0){arrayGridLossBuy[i]=arrayGridLossBuy[i-1]-(((MathPow(moltStepGrid,i-1)*StepGrid))*Point());}
     }

   if(ticketPrimoOrdSell)
     {
      if(OldTicketPrimoOrdineSell!=ticketPrimoOrdSell)
        {
         //a=1;
         OldTicketPrimoOrdineSell=ticketPrimoOrdSell;
         indexSell=0;
         indexSellProfit=0;
         GridSellActive=false;

         for(int aa=1; aa<ArraySize(TicketHedgeSell); aa++){TicketHedgeSell[aa] = 0;}
         for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++){arraysGridProfitSell[aa] = 0;}
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0;}
        }

      //Crea grid profit e loss SELL

      for(int i=0; i<=NumMaxGrid; i++)
        {
         if(i==0){arraysGridProfitSell[i]=PositionOpenPrice(ticketPrimoOrdSell)-((StepGrid)*Point());}
         
         if(i>0){arraysGridProfitSell[i]=arraysGridProfitSell[i-1]-(((MathPow(moltStepGrid,i-1)*StepGrid))*Point());}
        }

      for(int i=0; i<=NumMaxGrid; i++)
        {
         if(i==0){arraysGridLossSell[i]=PositionOpenPrice(ticketPrimoOrdSell)+(StartGrid)*Point();}
         
         if(i>0){arraysGridLossSell[i]=arraysGridLossSell[i-1]+(((MathPow(moltStepGrid,i-1)*StepGrid))*Point());}
        }
     }

   if(((NumOrdHedgeBuy(TicketHedgeBuy)>1 || NumOrdHedgeSell(TicketHedgeSell)>1) && (ProfitHedgeBuy(TicketHedgeBuy)
         +ProfitHedgeSell(TicketHedgeSell))>= profitGrid) || DDMax(maxDDPerc,magic_number))
     {
      ClosePositionsHedgeBUY(TicketHedgeBuy);
      ClosePositionsHedgeSell(TicketHedgeSell);
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++){TicketHedgeBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++){arrayGridProfitBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++){TicketHedgeSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++){arraysGridProfitSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0;}
      return;
     }

   if(NumOrdHedgeBuy(TicketHedgeBuy)>1 && ProfitHedgeBuy(TicketHedgeBuy)>= profitGrid)   ////////////////////////////
     {
      ClosePositionsHedgeBUY(TicketHedgeBuy);
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++){TicketHedgeBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++){arrayGridProfitBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0;}
     }
  
   if(NumOrdHedgeSell(TicketHedgeSell)>1 && ProfitHedgeSell(TicketHedgeSell)>= profitGrid)   ////////////////////////////
     {
      ClosePositionsHedgeSell(TicketHedgeSell);
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++){TicketHedgeSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++){arraysGridProfitSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0;}
     }

   if(!NumOrdHedgeBuy(TicketHedgeBuy))
     {
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++){TicketHedgeBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++){arrayGridProfitBuy[aa] = 0;}
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0;}
     }

   if(!NumOrdHedgeSell(TicketHedgeSell))
     {
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++){TicketHedgeSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++){arraysGridProfitSell[aa] = 0;}
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0;}
     }

   if((NumOrdHedgeBuy(TicketHedgeBuy)>0||NumOrdHedgeSell(TicketHedgeSell)>0))
     {
      if(!NumOrdHedgeBuy(TicketHedgeBuy))
        {
         indexBuy=0;
         indexBuyProfit=0;
         GridBuyActive=false;

         for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++){TicketHedgeBuy[aa] = 0;}
         for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++){arrayGridProfitBuy[aa] = 0;}
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0;}
        }

      if(NumOrdHedgeBuy(TicketHedgeBuy)>1 && Ask>PositionOpenPrice(ticketPrimoOrdBuy))   //Ask o Bid?
        {
         if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))
           {
            for(int i=indexBuyProfit; i<NumMaxGrid; i++)
              {
               if(MoltipliNumGrid<=(NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0){LotGridBuy=UltimoLotHedge(magic_number)*MoltiplLotStep;}
                  
                  if(TypeGrid == 1){LotGridBuy=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);}
                 }
               if(MoltipliNumGrid> (NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0){LotGridBuy=UltimoLotHedge(magic_number);}
               
               if(SymbolInfoDouble(Symbol(),SYMBOL_ASK)>=arrayGridProfitBuy[indexBuyProfit])
                  if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))
                    {
                     TicketHedgeBuy[i+50]=SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);///////////////BUY Profit
                     indexBuyProfit=i+1;
                     GridBuyActive=true;

                     if(PositionTakeProfit(TicketHedgeBuy[0])>0.0){PositionModify(TicketHedgeBuy[0],0,0,true);}
                 }
              }
           }
        }

      if(NumOrdHedgeBuy(TicketHedgeBuy)>0 && Bid<PositionOpenPrice(ticketPrimoOrdBuy))
        {
         if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))
           {
            if(NumOrdHedgeBuy(TicketHedgeBuy))
              {

               for(int i=indexBuy; i<NumMaxGrid; i++)
                 {
                  if(MoltipliNumGrid<=(NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0){LotGridBuy=UltimoLotHedge(magic_number)*MoltiplLotStep;}
                     
                     if(TypeGrid == 1){LotGridBuy=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);}
                    }
                  if(MoltipliNumGrid> (NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0){LotGridBuy=UltimoLotHedge(magic_number);}
                  if(SymbolInfoDouble(Symbol(),SYMBOL_BID)<=arrayGridLossBuy[indexBuy])
                     if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))

                       {
                        TicketHedgeBuy[i+1]=SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);//////////BUY Loss
                        indexBuy=i+1;
                        GridBuyActive=true;

                        if(PositionTakeProfit(ticketPrimoOrdBuy)>0.0){PositionModify(ticketPrimoOrdBuy,0,0,true);}
                    }
                 }
              }
           }
        }

      if(!ticketPrimoOrdSell)
        {
         indexSell=0;
         indexSellProfit=0;
         GridSellActive=false;
         for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++){TicketHedgeSell[aa] = 0;}
         for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++){arraysGridProfitSell[aa] = 0.0;}
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0.0;}
        }

      //Inserire gridProfitHedgeSell

      if(NumOrdHedgeSell(TicketHedgeSell)>1 && Bid<PositionOpenPrice(ticketPrimoOrdSell))
        {
         if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))
           {
            for(int i=indexSellProfit; i<NumMaxGrid; i++)
              {
               if(MoltipliNumGrid<=(NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0){LotGridSell=UltimoLotHedge(magic_number)*MoltiplLotStep;}
                  
                  if(TypeGrid == 1){LotGridSell=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);}
                 }
               if(MoltipliNumGrid> (NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0){LotGridSell=UltimoLotHedge(magic_number);}
               if(SymbolInfoDouble(Symbol(),SYMBOL_BID)<=arraysGridProfitSell[indexSellProfit])
                  if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))
                    {
                     TicketHedgeSell[i+50]=SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);////////////////////Sell Profit
                     indexSellProfit=i+1;
                     GridSellActive=true;
                     if(PositionTakeProfit(ticketPrimoOrdSell)>0.0){PositionModify(ticketPrimoOrdSell,0,0,true);}
                 }
              }
           }
        }

      if(NumOrdHedgeSell(TicketHedgeSell)>0 && Ask>PositionOpenPrice(ticketPrimoOrdSell))
        {
         if(NumOrdHedgeSell(TicketHedgeSell)>0)
           {
            if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))
              {

               for(int i=indexSell; i<NumMaxGrid; i++)
                 {
                  if(MoltipliNumGrid<=(NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0){LotGridSell=UltimoLotHedge(magic_number)*MoltiplLotStep;}
                     
                     if(TypeGrid == 1){LotGridSell=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);}
                    }
                  if(MoltipliNumGrid> (NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0){LotGridSell=UltimoLotHedge(magic_number);}

                  if(Ask>=arraysGridLossSell[indexSell]&&NumOrdHedgeSell(TicketHedgeSell)>0)
                     if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))

                       {
                        TicketHedgeSell[i+1]=SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);    ////////////////////////Sell Loss
                        indexSell=i+1;
                        GridSellActive=true;
                        if(PositionTakeProfit(ticketPrimoOrdSell)>0.0){PositionModify(ticketPrimoOrdSell,0,0,true);}
                    }
                 }
              }
           }
        }
     }
  }