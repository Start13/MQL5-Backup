//+------------------------------------------------------------------+
//|                             TreAll_MA iCustom v3.0 Dom & Off.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version     "3.0"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor....."
string versione     = "v3.0";

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

enum ENUM_PRICE
{
   close,               // Close
   open,                // Open
   high,                // High
   low,                 // Low
   median,              // Median
   typical,             // Typical
   weightedClose,       // Weighted Close
   medianBody,          // Median Body (Open+Close)/2
   average,             // Average (High+Low+Open+Close)/4
   trendBiased,         // Trend Biased
   trendBiasedExt,      // Trend Biased(extreme)
   haClose,             // Heiken Ashi Close
   haOpen,              // Heiken Ashi Open
   haHigh,              // Heiken Ashi High   
   haLow,               // Heiken Ashi Low
   haMedian,            // Heiken Ashi Median
   haTypical,           // Heiken Ashi Typical
   haWeighted,          // Heiken Ashi Weighted Close
   haMedianBody,        // Heiken Ashi Median Body
   haAverage,           // Heiken Ashi Average
   haTrendBiased,       // Heiken Ashi Trend Biased
   haTrendBiasedExt     // Heiken Ashi Trend Biased(extreme)   
};


enum ENUM_MA_MODE
{
   SMA,                 // Simple Moving Average
   EMA,                 // Exponential Moving Average
   Wilder,              // Wilder Exponential Moving Average
   LWMA,                // Linear Weighted Moving Average
   SineWMA,             // Sine Weighted Moving Average
   TriMA,               // Triangular Moving Average
   LSMA,                // Least Square Moving Average (or EPMA, Linear Regression Line)
   SMMA,                // Smoothed Moving Average
   HMA,                 // Hull Moving Average by Alan Hull
   ZeroLagEMA,          // Zero-Lag Exponential Moving Average
   DEMA,                // Double Exponential Moving Average by Patrick Mulloy
   T3_basic,            // T3 by T.Tillson (original version)
   ITrend,              // Instantaneous Trendline by J.Ehlers
   Median,              // Moving Median
   GeoMean,             // Geometric Mean
   REMA,                // Regularized EMA by Chris Satchwell
   ILRS,                // Integral of Linear Regression Slope
   IE_2,                // Combination of LSMA and ILRS
   TriMAgen,            // Triangular Moving Average generalized by J.Ehlers
   VWMA,                // Volume Weighted Moving Average
   JSmooth,             // Smoothing by Mark Jurik
   SMA_eq,              // Simplified SMA
   ALMA,                // Arnaud Legoux Moving Average
   TEMA,                // Triple Exponential Moving Average by Patrick Mulloy
   T3,                  // T3 by T.Tillson (correct version)
   Laguerre,            // Laguerre filter by J.Ehlers
   MD,                  // McGinley Dynamic
   BF2P,                // Two-pole modified Butterworth filter by J.Ehlers
   BF3P,                // Three-pole modified Butterworth filter by J.Ehlers
   SuperSmu,            // SuperSmoother by J.Ehlers
   Decycler,            // Simple Decycler by J.Ehlers
   eVWMA,               // Modified eVWMA
   EWMA,                // Exponential Weighted Moving Average
   DsEMA,               // Double Smoothed EMA
   TsEMA,               // Triple Smoothed EMA
   VEMA                 // Volume-weighted Exponential Moving Average(V-EMA)
}; 

enum filtroPivot
  {
   NoPivot         = 0, //No Filtro Pivot
   PivotD          = 1, //Filtro Daily
   PivotW          = 2, //Filtro Weekly
  };
enum TypePivot
  {
   PivotDHL_2      = 2, // Pivot HL:2
   PivotDHLC_3     = 3  // Pivot HL:3
  };

enum Grid_Hedge
  {
   NoGrid_NoHedge  = 0, //No Griglia / No Hedging
   Grid_           = 1, //Griglia
   Hedge           = 2, //Hedging
  };
enum TipoMultipliGriglia
  {
   Fix             = 0,
   Progressive     = 1,
  };
enum numMaxOrd
  {
   Una_posizione   = 1,  //Max 1 Ordine
   Due_posizioni   = 2,  //Max 2 Ordini
  };
enum capitBasePerCompoundingg
  {
   Equity          = 0,
   Margine_libero  = 1, //Free margin
   Balance         = 2,
  };
enum Fuso_
  {
   GMT              = 0,
   Local            = 1,
   Server           = 2
  };
enum TipoOrdini
  {
   Buy_Sell         = 0,  //Orders Buy e Sell
   Buy              = 1,  //Only Buy Orders
   Sell             = 2   //Only Sell Orders
  };
enum TipoStopLoss
  {
   No               = 0,  //No Stop Loss
   Points           = 1,  //Stop Loss Points
  };
enum StopLoss
   {
   No               = 0,  //No
   SLPoints         = 1,  //Stop Loss in Points
   MA               = 2,  //Stop Loss alla MA 
   };   
enum TypeMA
   {
   MA1              = 1,  //Stop Loss alla MA1
   MA2              = 2,  //Stop Loss alla MA2 
   MA3              = 3,  //Stop Loss alla MA3
   };          
enum TStop
  {
   NoTS             = 0,  //No Trailing Stop
   Pointstop        = 1,  //Trailing Stop Points
   TSPointTradiz    = 2,  //Trailing Stop Points Traditional
   TsTopBotCandle   = 3,  //Trailing Stop Previous Candle
  };
enum TypeCandle
  {
   Stesso           = 0,  //Trailing Stop sul min/max della candela "index"
   Una              = 1,  //Trailing Stop sul min/max del corpo della candela "index"
   Due              = 2,  //Trailing Stop sul max/min del corpo della candela "index"
   Tre              = 3,  //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE            = 0,  //No Breakeven
   BEPoints         = 1,  //Breakeven Points
  };      
enum Tp
  {
   No_Tp            = 0,  //No Tp
   TpPoints         = 1,  //Tp in Points
  };
  
enum StopBefore_
  {
   cinqueMin        =  5, //5 Min
   dieciMin         = 10, //10 min
   quindMin         = 15, //15 min
   trentaMin        = 30, //30 min
   quarantacinMin   = 45, //45 min
   unOra            = 60, //1 Hour
   unOraeMezza      = 90, //1:30 Hour
   dueOre           =120, //2 Hours
   dueOreeMezza     =150, //2:30 Hours
   treOre           =180, //3 Hours
   quattroOre       =240, //4 Hours
  };
enum StopAfter_
  {
   cinqueMin        =  5, //5 Min
   dieciMin         = 10, //10 min
   quindMin         = 15, //15 min
   trentaMin        = 30, //30 min
   quarantacinMin   = 45, //45 min
   unOra            = 60, //1 Hour
   unOraeMezza      = 90, //1:30 Hour
   dueOre           =120, //2 Hours
   dueOreeMezza     =150, //2:30 Hours
   treOre           =180, //3 Hours
   quattroOre       =240, //4 Hours
  };    
enum pattImpLiv
{
impulso     =   1,
livello     =   2,
};  
enum pendImpLiv
{
impulso     =   1,
livello     =   2,
};  
enum patternChiudeOrdini
   {
   no                      = 1,  //No
   yes                     = 2,  //Si 
   soloProfit              = 3,  //Solo se in profitto
   };     
enum Filter_ATR_ 
  {
   Flat                    = 0,  //Flat
   Sotto                   = 1,  //Abilita Ordini Sopra il livello impostato
   Sopra                   = 2,  //Abilita Ordini Sotto il livello impostato
  };     
enum inputMA 
  {
   All_MA                    = 0,  //ALL_MA
   MA                        = 1,  //MA
  };
enum oltreMa
  {
   superamMA                 = 0,  //tocca MA
   rimbalzoMA                = 1,  //rientro da MA
  };
enum direzCand
  {
 //No                        = 0,  //Flat
   candN                     = 1,  //N° Candele congrue con l'Ordine
   candNeSuperamBody         = 2,  //N° Candele congrue e superam body cand preced                               
   candNeSuperamShadow       = 3,  //N° Candele congrue e superam shadow cand preced
  };   
enum pendenzaChiudeOrdini
   {
   no               = 1,               //No
   yes              = 2,               //Si 
   soloProfit       = 3,               //Solo se in profitto
   soloTutteOpposte = 4,               //Se TUTTE le pend opposte
   };         
/*  
input string   commentMAS      =    "---  SCELTA MEDIA MOBILE ---";   // --- SCELTA MEDIA MOBILEG ---
input inputMA  inputMA_        =      0;  //Scelta MA  
*/
   
input string   comment_PATT    = "--- PATTERN MEDIE MOBILI ---";   // --- PATTERN MEDIE MOBILI ---
input int distanzaMin3MA       =   100;                            //Distanza Min Points tra le Medie per permettere Ordini
//input pattImpLiv pattImpLiv_   =        1;                       //Apertura Ordine: impulso / livello
input int 	   nCandles        =    10;			    	             //Candele trend per apertura Ordine. Min 1
input oltreMa  oltreMA_        =     1;                            //Aprertura Ordine: tocca MA/rientro da MA  
input string   comment_RIENTRO = "--- se \"rientro da MA\" ---";   // --- se "rientro da MA" ---
input direzCand  direzCand_    =     1;                            //Permette Ordine Cand a favore: No/N°Cand/N°Cand+Body/N°Cand+Shadow    
input int      numCandDirez    =     1;                            //Numero Candele a favore. Minimo 1.
input ENUM_TIMEFRAMES timeFrCand =   PERIOD_CURRENT;               //Time Frame Candele         

input string   comment_PEND      =   "--- PENDENZE  ---";    // --- PENDENZE ---
input int      numcandpendenze                               =  3;         //Numero candele per determinare la Pendenza. Min 2.                         
input string   comment_ClosPEND  =   "--- PATTERN PENDENZE CHIUDE ORDINE ---";    // --- PATTERN PENDENZE CHIUDE ORDINE ---
input pendenzaChiudeOrdini pendenzaChiudeOrdini_ =      1;          //NO/SI/Solo in profitto/Solo se tutte opposte

input string   comment_EnabPen   =   "--- FILTRO PATTERN PENDENZE ---";    // --- FILTRO PATTERN PENDENZE ---
input bool     NoPattNoOpenOrd                               =  true;      //Pendenze MA discordi: non apre Ordini 
 
input string   comment_OS        =   "--- ORDER SETTINGS ---";             // --- ORDER SETTINGS ---
input bool                   StopNewsOrders                  = false;      //Ferma l'EA quando terminano gli Ordini
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =  22;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
//input char                   maxDDPerc                       =   0;      //Max DD% (0 Disable)
input int                    MaxSpread                       =   0;        //Max Spread (0 = Disable)
input TipoOrdini             tipoOrdini                      =   0;        //Tipo di Ordini
input numMaxOrd              numMaxOrdini                    =   2;        //Massimo numero di Ordini contemporaneamente
//input int                   N_max_orders                   =  50;        //Massimo numero di Ordini nella giornata
input ulong                  magicNumber                     = 4444;       //Magic Number
input string                 Commen                          =  "";        //Comment
input int                    Deviazione                      =   3;        //Slippage 
/*
input string   comment_CAN   =     "--- FILTER CANDLE ORDERS ---";       // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;     //Abilita più ordini sulla stessa candela
input bool                   OrdEChiuStessaCandela           = true;     //Abilita News Orders sulla candela di ordini già aperti e/o chiusi
input string   comment_DIR   =     "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))
*/

input string   comment_SL=           "--- STOP LOSS ---"; // --- STOP LOSS ---
input StopLoss StopLoss_ =              1;            //Stop Loss Points / MA 
input TypeMA TypeMA_     =              1;            //Stop loss su quale MA 
input int SlPoints       =          10000;            //Stop loss Points / Distanza Points MA   

input string   comment_BE =        "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      BeStartPoints            = 2500;              //Be Start in Points
input int      BeStepPoints             =  200;              //Be Step in Points

input string   comment_TS =        "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points da Profit/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points

input string   comment_TSC =       "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TipoTSCandele          =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =        "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit Type
input int      TpPoints                 = 1000;              //Take Profit Points

input string   comment_TFMA =           "--- Time Frame Scan MA ---"; // --- Time Frame Scan MA ---
input ENUM_TIMEFRAMES PeriodPattern1 = PERIOD_CURRENT; // TF Pattern 1
input ENUM_TIMEFRAMES PeriodPattern2 = PERIOD_CURRENT; // TF Pattern 2

input string   comment_MA1 =           "--- All_MA 1 ---"; // --- All_MA 1 ---
input ENUM_TIMEFRAMES   TimeFrame1            =           0;       // Timeframe
input ENUM_PRICE        Price1                =           0;       // Apply To
input int               MA_Period1            =          14;       // Period
input int               MA_Shift1             =           0;       // Shift
input ENUM_MA_MODE      MA_Method1            =         LSMA;      // Method
input bool              ShowInColor1          =        true;       // Show In Color
input int               CountBars1            =           0;       // Number of bars counted: 0-all bars 

input string   comment_MA2 =           "--- All_MA 2 ---"; // --- All_MA 2 ---
input ENUM_TIMEFRAMES   TimeFrame2            =           0;       // Timeframe
input ENUM_PRICE        Price2                =           0;       // Apply To
input int               MA_Period2            =          14;       // Period
input int               MA_Shift2             =           0;       // Shift
input ENUM_MA_MODE      MA_Method2            =         LSMA;      // Method
input bool              ShowInColor2          =        true;       // Show In Color
input int               CountBars2            =           0;       // Number of bars counted: 0-all bars 

input string   comment_MA3 =           "--- All_MA 3 ---"; // --- All_MA 3 ---
input ENUM_TIMEFRAMES   TimeFrame3            =           0;       // Timeframe
input ENUM_PRICE        Price3                =           0;       // Apply To
input int               MA_Period3            =          14;       // Period
input int               MA_Shift3             =           0;       // Shift
input ENUM_MA_MODE      MA_Method3            =         LSMA;      // Method
input bool              ShowInColor3          =        true;       // Show In Color
input int               CountBars3            =           0;       // Number of bars counted: 0-all bars 


input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input Filter_ATR_          Filter_ATR   = 0;                    //Permette Ordini con ATR: Flat/Sopra/Sotto
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

input string   comment_MM          = "--- MONEY MANAGEMENT ---";// --- MONEY MANAGEMENT ---
input bool     EnableAllocazione   =   false;                   //Abilita/disabilita l'allocazione di capitale
input double   capitalToAllocateEA =  		 0;					    // Capitale da allocare per l'EA (0 = intero capitale)
input bool     compounding         =    true;                   //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;    //Reference capital for Compounding
input double   lotsEA              =     0.1;                   //Lots
input double   riskEA              =       0;                   //Risk in % [0-100]
input double   riskDenaroEA        =       0;                   //Risk in money
input double   commissioni         =       4;                   //Commissions per lot

input string     comment_TT  =        "--- TRADING TIME SETTINGS ---";   // --- TRADING TIME SETTINGS ---
input string     comment_TT1 =        "--- TIME SETTINGS 1 ---";   // --- TRADING TIME SETTINGS 1 ---
input bool       FusoEnable             = false;    //Trading Time
input Fuso_      Fuso                   =  2;       //Time Zone Settings
input int        InpStartHour           =  2;       //Session1 Start Time
input int        InpStartMinute         =  0;       //Session1 Start Minute
input int        InpEndHour             = 15;       //Hours1 End of Session
input int        InpEndMinute           = 15;       //Minute1 End of Session
input string     comment_TT2 =        "--- TIME SETTINGS 2 ---";   // --- TRADING TIME SETTINGS 2 ---
input int        InpStartHour1          = 16;       //Session2 Start Time
input int        InpStartMinute1        = 15;       //Session2 Start Minute
input int        InpEndHour1            = 23;       //Hours2 End of Session
input int        InpEndMinute1          = 00;       //Minute2 End of Session

input string     comment_NEW  =           "--- FILTER NEWS ---";             // --- FILTER NEWS ---
input bool       FilterNews   =          false;                             //Filter News
input ENUM_CALENDAR_EVENT_IMPORTANCE    levelImpact= CALENDAR_IMPORTANCE_LOW ;
input StopBefore_ StopBefore            = 30;       //Stop Before
input StopAfter_  StopAfter             = 30;       //Stop After
ENUM_TIMEFRAMES   startime_             = PERIOD_D1  ;
ENUM_TIMEFRAMES   endtime_              = PERIOD_D1  ;
ENUM_TIMEFRAMES   rangetime_            = PERIOD_D1  ;


double capitalToAllocate       =    0;
bool    autoTradingOnOff       = true;

double capitaleBasePerCompounding;
double distanzaSL  = 0;

int handle1,handle2,handle3,handle4,handle5,handle6,shift1,shift2,shift3;
double LabelBuffer1[];
double LabelBuffer2[];
double LabelBuffer3[];

int    copy1;
int    copy2;
int    copy3;

double iCust1;
double iCust2;
double iCust3;

double ASK         = 0;
double BID         = 0;

string symbol_     = Symbol();

bool semCand       = false;

string Commento    = "";
bool enableTrading = true;

datetime OraNews;

int handleATR;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
	Allocazione_Init();  

   controlloAccounts(TimeLicens,NumeroAccount0,NumeroAccount1,NumeroAccount2,NumeroAccount3,NumeroAccount4,
                                NumeroAccount5,NumeroAccount6,NumeroAccount7,NumeroAccount8,NumeroAccount9);
	
   handle1 = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1); 
   handle2 = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_1MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2); 
   handle3 = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_2MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3); 	 
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
void OnTick()
  {
	
	if(!autoTradingOnOff) return;
	
	Allocazione_Check(magicNumber);  
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
  
  
ASK=Ask(symbol_);
BID=Bid(symbol_);
Commento = spreadComment();
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);   
semCand = semaforoCandela(0); 

CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);
   BEcheck();
   gestioneTrailStop();
if(semCand && pendenza("Buy"))Print(" pendenza BUY");if(semCand && pendenza("Sell"))Print(" pendenza SELL");if(semCand && !pendenza("Sell") && !pendenza("Sell"))Print(" pendenza DISCORDE");
   if(semCand)EA_Strategia(magicNumber,symbol_);
   
   //Comment (Commento);
   
   Indicators();
   

  }
 

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  

void EA_Strategia(ulong magic,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT)
{
   if(!enableTrading)return;
   
	bool 	candeleInTrend = 	patternEMACongruent_TrendBuy(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3) || patternEMACongruent_TrendSell(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3);
	int 	n_Candele_Trend = patternEMACongruent_TrendBuy_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3) + patternEMACongruent_TrendSell_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3);
	
   //ArrayInitialize(LabelBuffer1,0);
   //copy1=CopyBuffer(handle1,0,0,3,LabelBuffer1);iCust1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
	
	//Print("Nelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend);Commento=Commento+"\nNelle ultime "+(string)nCandles+" candele vi è una formazione in trend? -> "+(string)candeleInTrend;
	//Print("Numero candele in trend: ",n_Candele_Trend);Commento=Commento+"\nNumero candele in trend: "+(string)n_Candele_Trend;
	
	bool patternBuy0; bool patternSell0; 
	patternBuy0 = patternSell0 = !ManualStopNewsOrders() && SpreadMax() && GestioneATR() && pendenzeDiscordi() && distanzaMin3MA(); 
	
	// BUY
	bool patternBuy1 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern1,symbol,MA_Period1,MA_Period2,MA_Period3);
	bool patternBuy2 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern2,symbol,MA_Period1,MA_Period2,MA_Period3);
	bool patternBuy3 = false;
	if(oltreMA_==0 && BID <= MaCustom(handle1,0)) patternBuy3 = true;
	if(oltreMA_==1 && numCandeleCongrueConSogliaIniziale(direzCand_,"Buy",numCandDirez,timeFrCand)) patternBuy3 = true;
	
	if(patternBuy0 && patternBuy1 && patternBuy2 && patternBuy3 && maxOrd_BuySellBuy(numMaxOrdini,tipoOrdini,magicNumber,Commen)){
		SendTradeBuyInPoint(symbol_,lotsEA,0,StopLossCheckBuy(),gestioneTP(),Commen,magicNumber);
	}
	
	// SELL
	bool patternSell1 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern1,symbol,MA_Period1,MA_Period2,MA_Period3);
	bool patternSell2 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern2,symbol,MA_Period1,MA_Period2,MA_Period3);
	bool patternSell3 = false;
	if(oltreMA_==0 && ASK >= MaCustom(handle1,0)) patternSell3 = true;
	if(oltreMA_==1 && numCandeleCongrueConSogliaIniziale(direzCand_,"Sell",numCandDirez,timeFrCand)) patternSell3 = true;	

	
	if(patternSell0 && patternSell1 && patternSell2 && patternSell3 && maxOrd_BuySellSell(numMaxOrdini,tipoOrdini,magicNumber,Commen)){
		SendTradeSellInPoint(symbol_,lotsEA,0,StopLossCheckSell(),gestioneTP(),Commen,magicNumber);
	}Comment (Commento);
}

//+------------------------------------------------------------------+Nella funzione Body e Shadow,la candela più a sx (candela di verso inverso alle altre candele), 
//|           numCandeleCongrueConSogliaIniziale()                   |     per scelta, ho eliminato l'obbligo ad essere a cavallo del valore della prima MA (MA1)
//+------------------------------------------------------------------+  
bool numCandeleCongrueConSogliaIniziale(int TipodirezCand,string BuySell,int numCand,ENUM_TIMEFRAMES timeframe)
{
bool a = false;
if(!TipodirezCand){a=true;return a;}


if(TipodirezCand==1 && BuySell=="Buy")  
      {a=rientroMA(true,BuySell,numCand,timeframe);return a;}
      
if(TipodirezCand==1 && BuySell=="Sell") 
      {a=rientroMA(true,BuySell,numCand,timeframe);return a;}
      
if(TipodirezCand==2)
{
if(BuySell=="Buy" && rientroMA(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Sell") 
   && iClose(symbol_,timeframe,1) > iOpen(symbol_,timeframe,numCand+1)){a=true;return a;}                // Supera Body
   
if(BuySell=="Sell" && rientroMA(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Buy") 
   && iClose(symbol_,timeframe,1) < iOpen(symbol_,timeframe,numCand+1)){a=true;return a;}                // Supera Body
}
if(TipodirezCand==3)
{
if(BuySell=="Buy" && rientroMA(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Sell") 
   && iClose(symbol_,timeframe,1) > iHigh(symbol_,timeframe,numCand+1)){a=true;return a;}                // Supera Shadow
   
if(BuySell=="Sell" && rientroMA(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Buy") 
   && iClose(symbol_,timeframe,1) < iLow(symbol_,timeframe,numCand+1)){a=true;return a;}                 // Supera Shadow
}
return a;
}
//+------------------------------------------------------------------+
//|                        rientroMA( )                              |
//+------------------------------------------------------------------+
bool rientroMA(bool enable,string BuySell,int numCand,ENUM_TIMEFRAMES timeframe)
{
bool a = false;


for(int i=1;i<=numCand;i++)
{
if(BuySell=="Buy")
{
double ma1 = MaCustom(handle1,i);
double ma2 = MaCustom(handle2,i);
double ma3 = MaCustom(handle3,i);

double LowI = iLow(Symbol(),timeframe,i);
double close1 = iClose(symbol_,timeframe,1);
double valSup = valoreSuperiore(MaCustom(handle2,i),MaCustom(handle3,i));
static bool toccaMA = false;

if(!(ma1>ma2 && ma2>ma3) || LowI<valSup || !candelaNumIsBuyOSell(i,"Buy")) {toccaMA=false;a=false;return a;}

if(candelaNumIsBuyOSell(i,"Buy") && doubleCompreso(LowI,MaCustom(handle1,i),valSup)) toccaMA=true;
//Print(" i>=numCand ",i>=numCand," toccaMA ",toccaMA," I ",i," LowI ",LowI," close1 ",close1," valSup ",valSup," MaCustom(handle1,i) ",MaCustom(handle1,i));
if(toccaMA && iClose(symbol_,timeframe,1)>MaCustom(handle1,1) && i>=numCand) {toccaMA=false;a=true;return a;}

}
 
if(BuySell=="Sell")
{
double ma1 = MaCustom(handle1,i);
double ma2 = MaCustom(handle2,i);
double ma3 = MaCustom(handle3,i);

double HighI = iHigh(Symbol(),timeframe,i);
double close1 = iClose(symbol_,timeframe,1);
double valInf = valoreInferiore(MaCustom(handle2,i),MaCustom(handle3,i));
static bool toccaMA = false;

if(!(ma1<ma2 && ma2<ma3) || HighI>valInf || !candelaNumIsBuyOSell(i,"Sell")) {toccaMA=false;a=false;return a;}

if(candelaNumIsBuyOSell(i,"Sell") && doubleCompreso(HighI,MaCustom(handle1,i),valInf)) toccaMA=true;
//Print(" i>=numCand ",i>=numCand," toccaMA ",toccaMA," I ",i," LowI ",LowI," close1 ",close1," valSup ",valSup," MaCustom(handle1,i) ",MaCustom(handle1,i));
if(toccaMA && iClose(symbol_,timeframe,1)>MaCustom(handle1,1) && i>=numCand) {toccaMA=false;a=true;return a;}
}}

return a;
}

//+------------------------------------------------------------------+
//|                    pendenza(string BuySell)                      |
//+------------------------------------------------------------------+
bool pendenza(string BuySell)
{
bool a = false;
//if(!NoPattNoOpenOrd){a=true;return a;}
static int contpend = 0;
if(numcandpendenze<2 && !contpend){contpend++;Alert("Impostazione Numero Candele per determinare la Pendenza ERRATA! Minimo 2.");return false;}
if(BuySell=="Buy")
{
if(MaCustom(handle1,1) > MaCustom(handle1,numcandpendenze) && MaCustom(handle2,1) > MaCustom(handle2,numcandpendenze) && MaCustom(handle3,1) > MaCustom(handle3,numcandpendenze))
   {Commento=Commento+"\nMedie Mobili Rialziste";a=true;}
}

if(BuySell=="Sell")
{
if(MaCustom(handle1,1) < MaCustom(handle1,numcandpendenze) && MaCustom(handle2,1) < MaCustom(handle2,numcandpendenze) && MaCustom(handle3,1) < MaCustom(handle3,numcandpendenze))
{Commento=Commento+"\nMedie Mobili Ribassiste";a=true;}
}
if(!a)Commento=Commento+"\nMedie Mobili con PENDENZE DIVERSE";
return a;
}
//+------------------------------------------------------------------+
//|                       pendenzeDiscordi()                         |
//+------------------------------------------------------------------+
bool pendenzeDiscordi()  //NoPattNoOpenOrd
{
if(pendenzaChiudeOrdini_==2 && NumOrdini(magicNumber,Commen)>0 && !pendenza("Buy") && !pendenza("Sell")) brutalCloseTotal(symbol_,magicNumber);
if(pendenzaChiudeOrdini_==3 && NumOrdini(magicNumber,Commen)>0 && !pendenza("Buy") && !pendenza("Sell")) brutalCloseAllProfitablePositions(symbol_,magicNumber);
if(pendenzaChiudeOrdini_==4 && NumOrdBuy (magicNumber,Commen)>0 && pendenza("Sell")) {brutalCloseBuyPositions(symbol_,magicNumber);}
if(pendenzaChiudeOrdini_==4 && NumOrdSell(magicNumber,Commen)>0 && pendenza("Buy")) {brutalCloseSellPositions(symbol_,magicNumber);}
bool a = true;
if(NoPattNoOpenOrd && !pendenza("Buy") && !pendenza("Sell")) {a = false; return a;}
return a;
}
//+------------------------------------------------------------------+
//|                         distanzaMin3MA()                         |
//+------------------------------------------------------------------+
bool distanzaMin3MA()
{
bool a = true;
double ma1 = MA_Period1 > 0 ? MaCustom(handle1,0) : 0;    
double ma2 = MA_Period2 > 0 ? MaCustom(handle2,0) : 0;
double ma3 = MA_Period3 > 0 ? MaCustom(handle3,0) : 0;
if((ValoreSuperiore(ma1,ma2,ma3)-ValoreInferiore(ma1,ma2,ma3))/Point()<distanzaMin3MA)a=false;
return a;
}
//+------------------------------------------------------------------+
//|                      patternEMACongruent                         |
//+------------------------------------------------------------------+
bool patternEMACongruent(string type,int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){


   double ema1 = periodEMA_1 > 0 ? MaCustom(handle1,index) : 0; 
   double ema2 = periodEMA_2 > 0 ? MaCustom(handle2,index) : 0;
   double ema3 = periodEMA_3 > 0 ? MaCustom(handle3,index) : 0;
   double ema4 = periodEMA_4 > 0 ? ema(periodEMA_4,index,timeframe,symbol) : 0;
   double ema5 = periodEMA_5 > 0 ? ema(periodEMA_5,index,timeframe,symbol) : 0;
   double ema6 = periodEMA_6 > 0 ? ema(periodEMA_6,index,timeframe,symbol) : 0;
   
   if(ema1 > 0 && ema2 > 0){
      if(type == "OP_BUY"){
         if(ema3 == 0) return ema1 > ema2;
         if(ema4 == 0) return ema1 > ema2 && ema2 > ema3;
         if(ema5 == 0) return ema1 > ema2 && ema2 > ema3 && ema3 > ema4;
         if(ema6 == 0) return ema1 > ema2 && ema2 > ema3 && ema3 > ema4 && ema4 > ema5;
         return ema1 > ema2 && ema2 > ema3 && ema3 > ema4 && ema4 > ema5 && ema5 > ema6;
      }
      if(type == "OP_SELL"){
         if(ema3 == 0) return ema1 < ema2;
         if(ema4 == 0) return ema1 < ema2 && ema2 < ema3;
         if(ema5 == 0) return ema1 < ema2 && ema2 < ema3 && ema3 < ema4;
         if(ema6 == 0) return ema1 < ema2 && ema2 < ema3 && ema3 < ema4 && ema4 < ema5;
         return ema1 < ema2 && ema2 < ema3 && ema3 < ema4 && ema4 < ema5 && ema5 < ema6;
      }
   }
   return false;
}

bool patternEMACongruent_Buy (int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	return patternEMACongruent("OP_BUY",index,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6);
}
bool patternEMACongruent_Sell(int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	return patternEMACongruent("OP_SELL",index,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6);
}

bool patternEMACongruent_TrendBuy(int nCandlesToAnalyze,int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   for(int i=0;i<nCandlesToAnalyze;i++)	if(!patternEMACongruent_Buy(indexStart+i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) return false;
   return true;
}

bool patternEMACongruent_TrendSell(int nCandlesToAnalyze,int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   for(int i=0;i<nCandlesToAnalyze;i++)	if(!patternEMACongruent_Sell(indexStart+i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) return false;
   return true;
}

int patternEMACongruent_TrendBuy_nCandles(int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	int nCount = 0;
	for(int i=indexStart;i<iBars(Symbol(symbol),timeframe)-1;i++)	if(patternEMACongruent_Buy(i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) nCount++; else break;
   return nCount;
}

int patternEMACongruent_TrendSell_nCandles(int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	int nCount = 0;
	for(int i=indexStart;i<iBars(Symbol(symbol),timeframe)-1;i++)	if(patternEMACongruent_Sell(i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) nCount++; else break;
   return nCount;
} 

//+------------------------------------------------------------------+
//|                            GestioneATR()                         |
//+------------------------------------------------------------------+
bool GestioneATR()
  {
   bool a=true;
   if(!Filter_ATR) return a;
   if(Filter_ATR==1 && iATR(Symbol(),periodATR,ATR_period,0) < thesholdATR) a=false;
   if(Filter_ATR==2 && iATR(Symbol(),periodATR,ATR_period,0) > thesholdATR) a=false;   
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
	
	if(EquityEA(magic,symbol) <= 0){if(!EnableAllocazione)return;
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
   if(StopNewsOrders&&NumPosizioni(magicNumber)==0&&xxx==0)
     {
      Print("Auto Stop News Orders EA ",Symbol());
      Comment("Auto Stop News Orders EA ",Symbol());
      Alert("Auto Stop News Orders EA ",Symbol());
      xxx++;
     }
   if(StopNewsOrders&&NumPosizioni(magicNumber)==0)
      a = true;
   return a;
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
//----------------------------------------  
double MaCustom(int handle,int index)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,0,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}  
//----------------------------------------
int StopLossCheckBuy()
{
int a=0;
if(StopLoss_ == 1) {a = SlPoints;return a;}
if(StopLoss_ == 2) 
{
double ma1 = MA_Period1 > 0 ? MaCustom(handle1,0) : 0;    
double ma2 = MA_Period2 > 0 ? MaCustom(handle2,0) : 0;
double ma3 = MA_Period3 > 0 ? MaCustom(handle3,0) : 0;
if(TypeMA_==1) {a = (int)((ASK-ma1)/Point(symbol_)+SlPoints);return a;}
if(TypeMA_==2) {a = (int)((ASK-ma2)/Point(symbol_)+SlPoints);return a;}
if(TypeMA_==3) {a = (int)((ASK-ma3)/Point(symbol_)+SlPoints);return a;}
}
return a;
}
//----------------------------------------
int StopLossCheckSell()
{
int a=0;
if(StopLoss_ == 1) {a = SlPoints;return a;}
if(StopLoss_ == 2) 
{
double ma1 = MA_Period1 > 0 ? MaCustom(handle1,0) : 0;    
double ma2 = MA_Period2 > 0 ? MaCustom(handle2,0) : 0;
double ma3 = MA_Period3 > 0 ? MaCustom(handle3,0) : 0;
if(TypeMA_==1) {a = (int)((ma1-BID)/Point(symbol_)+SlPoints);return a;}
if(TypeMA_==2) {a = (int)((ma2-BID)/Point(symbol_)+SlPoints);return a;}
if(TypeMA_==3) {a = (int)((ma3-BID)/Point(symbol_)+SlPoints);return a;}
}
return a;
}

int gestioneTP()
{
int a=0;
if(TakeProfit==0)return a;
if(TakeProfit==1)a=TpPoints;
return a;
}
//----------------------------------------
void BEcheck()
{
if(BreakEven==0)return;
if(BreakEven==1) BEPoints(BeStartPoints,BeStepPoints,magicNumber,Commen);
}

/*
input int      BeStartPoints            = 2500;              //Be Start in Points
input int      BeStepPoints             =  200;              //Be Step in Points*/
//----------------------------------------
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magicNumber, Commen);
if(TrailingStop==2)PositionsTrailingStopInStep(TsStart,TsStep,Symbol(),magicNumber,0);
if(TrailingStop==3)TrailStopCandle_();
return TS;
}


//+------------------------------------------------------------------+
//|                       TrailStopCandle()                          |
//+------------------------------------------------------------------+
double TrailStopCandle_()
  {
  double TsCandle=0;
   if(TicketPrimoOrdineBuy(magicNumber,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magicNumber,Commen),TipoTSCandele,indexCandle_,TFCandle,0.0);
   if(TicketPrimoOrdineSell(magicNumber,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magicNumber,Commen),TipoTSCandele,indexCandle_,TFCandle,0.0);
  return TsCandle;} 
  
//+------------------------------------------------------------------+
//|                           Indicators                             |
//+------------------------------------------------------------------+
void Indicators()
  {
   char index=0;
     {
      ChartIndicatorAdd(0,0,handle1);  

      ChartIndicatorAdd(0,0,handle2);

      ChartIndicatorAdd(0,0,handle3);
      
      //ChartIndicatorAdd(0,0,handleDomOff);

      //if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,index,indicator_handleATR);}        
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