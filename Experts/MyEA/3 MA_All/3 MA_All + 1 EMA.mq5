//+------------------------------------------------------------------+
//|                                          3 MA_All + 1 EMA EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict
#property indicator_buffers 5
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
long NumeroAccount5 = NumeroAccountOk[5] = 67107668;
long NumeroAccount6 = NumeroAccountOk[6] = 62039500;
long NumeroAccount7 = NumeroAccountOk[7] = 62039500;
long NumeroAccount8 = NumeroAccountOk[8] = 62039500;
long NumeroAccount9 = NumeroAccountOk[9] = 68168753;

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
   SLPoints         = 1,               //Stop Loss in Points
   SLMA             = 2,               //Stop Loss alla MA più distante
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
input int CloseOrdDopoNumCandDalPrimoOrdine_  =   0;       //Close Single Order after n° candles lateral (0 = Disable)
input Type_Orders            Type_Orders_     =   0;       //Type of order opening
input bool                   compounding      = true;      //Compounding
input double                 lotsEA           = 0.1;       //Lots
input	string 		           commentALL_      =    "=== ALLOCAZIONE ===";					//=========
input double   	       capitalToAllocateEA  =    0;												// Capitale da allocare per l'EA (0 = intero capitale)
input ulong                  magic_number     = 7777;      //Magic Number
input string                 Commen           = "EA";      //Comment
input int                    Deviazione       = 3;         //Slippage 

input bool     LivImp        =      false;                 //Livello / Impulso
input int      chiudincand   =      false;                 //Chiudi ordine dopo n° candele


input string   comment_PEND  =       "--- PATTERN PENDENZE All_MA ---";        // --- PATTERN PENDENZE All_MA (veloce,media,lenta)---
input bool     pendenze      =       true;                          //Quando le pendenze delle MA sono uguali apre ordine
input bool     closeOrdPend  =       false;                          //quando le pendenze MA sono discordi chiude ordine

input string   comment_PATT  =       "--- PATTERN All_MA ---";          // --- PATTERN All_MA ---
input bool     patternMA     =       false;                          //Pattern MA1 veloce/ MA2 media / MA3 lenta: in ordine

input string   comment_MinD     =       "--- DISTANZA MINIMA DA EMA PER APRIRE ORDINI---";    // --- DISTANZA MINIMA DA EMA PER APRIRE ORDINI ---

input int DistanceAll_MASuperiore            =        4000;        //Distanza min EMA sup. Se 0: No filtro
input int DistanceAll_MAInferiore            =        4000;        //Distanza min EMA inf. Se 0: No filtro

input string   comment_MinMA     =       "--- DISTANZA MINIMA TRA All_MA PER APRIRE ORDINI---";    // --- DISTANZA MINIMA TRA All_MA PER APRIRE ORDINI ---
input int      DistanzaTraMA                 =        0;        //Distanza min TRA All_MA per aprire Ordini. Se 0: disable

input string   comment_MAXD     =       "--- DISTANZA MASSIMA TRA All_MA PER APRIRE ORDINI---";    // --- DISTANZA MASSIMA TRA All_MA PER APRIRE ORDINI ---
input int      DistanzaMaxSup                =       10000;        //Distanza massima All_MA Superiore in Points per aprire ordini
input int      DistanzaMaxInf                =       10000;        //Distanza massima All_MA Inferiore in Points per aprire ordini

input string   comment_MA0                =    "--- EMA SETTING ---";   // --- EMA SETTING ---
input int                  Moving_period       =         13;       //Period of MA
input int                  Moving_shift        =          0;       //Shift
input ENUM_MA_METHOD       Moving_method       =       MODE_EMA;   //Type di smussamento
input ENUM_APPLIED_PRICE   Moving_applied_price=    PRICE_CLOSE;   //Type of price
input ENUM_TIMEFRAMES      periodMoving       =  PERIOD_CURRENT;   //Timeframe
input int                  indexMA            =           0;       //Index MA0


input string   comment_All_MA1                =    "--- MA VELOCE SETTING ---";   // --- MA VELOCE SETTING ---
//input bool              Enable_All_MA1        =       true;        //Enable All_MA
bool              Enable_All_MA1        =       true;        //Enable MA Veloce
input ENUM_TIMEFRAMES   TimeFrame1            =           0;       // Timeframe
input ENUM_PRICE        Price1                =           0;       // Apply To
input int               MA_Period1            =          14;       // Period
input int               MA_Shift1             =           0;       // Shift
input ENUM_MA_MODE      MA_Method1            =         LSMA;      // Method
input bool              ShowInColor1          =        true;       // Show In Color
input int               CountBars1            =           0;       // Number of bars counted: 0-all bars 


input string   comment_All_MA2                =     "--- MA MEDIA SETTING ---";   // --- MA MEDIA SETTING ---
input bool              Enable_All_MA2        =       true;        //Enable MA Media
input ENUM_TIMEFRAMES   TimeFrame2            =           0;       // Timeframe
input ENUM_PRICE        Price2                =           0;       // Apply To
input int               MA_Period2            =          14;       // Period
input int               MA_Shift2             =           0;       // Shift
input ENUM_MA_MODE      MA_Method2            =         LSMA;      // Method
input bool              ShowInColor2          =        true;       // Show In Color
input int               CountBars2            =           0;       // Number of bars counted: 0-all bars 


input string   comment_All_MA3                =      "--- MA LENTA SETTING ---";   // --- MA LENTA SETTING ---
input bool              Enable_All_MA3        =       true;        //Enable MA LENTA
input ENUM_TIMEFRAMES   TimeFrame3            =           0;       // Timeframe
input ENUM_PRICE        Price3                =           0;       // Apply To
input int               MA_Period3            =          14;       // Period
input int               MA_Shift3             =           0;       // Shift
input ENUM_MA_MODE      MA_Method3            =         LSMA;      // Method
input bool              ShowInColor3          =        true;       // Show In Color
input int               CountBars3            =           0;       // Number of bars counted: 0-all bars 


input string   comment_CAN   =       "--- FILTER CANDLE ORDERS ---";      // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;      //Abilita più ordini sulla stessa candela
//bool                       OrdiniSuStessaCandela           = true;      //Orders in same CANDLE
input bool                   OrdEChiuStessaCandela           = true;      //Abilita News Orders sulla candela di ordini già aperti e/o chiusi

input string   comment_DIR   =       "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))

input string   comment_BRk =           "--- BREAKOUT FILTER---"; // --- BREAKOUT FILTER---
input bool     BreakOutEnable = false;           //BreakOut enable   
input ENUM_TIMEFRAMES timeFrBreak      = PERIOD_CURRENT;   
input int      candPrecedent  = 100;             //Candele precedenti
input int      deltaPlus_     = 1000;            //Plus Points for BreakOut
input int      CandCons       = 3;

input string   comment_SL =           "--- STOP LOSS ---"; // --- STOP LOSS ---
input StopLoss StopLoss_                =     1;            //Stop Loss Points / MA
input int      Sl_n_pips                = 10000;            //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
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
/*
input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input bool     FilterZigZag   = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad   = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe*/
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
string symbol_=Symbol();             // simbolo 
double capitalToAllocate = 		0;
bool   autoTradingOnOff = 			true;
bool   enableTrading=true;
int    handle_iCustom;// Variabile Globale


int    LSMA_Handle1;
int    LSMA_Handle2;
int    LSMA_Handle3;

double LabelBuffer1[];
double LabelBuffer2[];
double LabelBuffer3[];

int    copy1;
int    copy2;
int    copy3;

double lsma1;
double lsma2;
double lsma3;
int  BARRE=0;
double valMA0=0;
bool semCand = false;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent())
     {Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}

	Allocazione_Init();
       
//--- mappatura buffers indicatore
   //for(int i=0;i<ArraySize(LabelBuffer1);i++){LabelBuffer1[i]=0;}
   //SetIndexBuffer(0,LabelBuffer1,INDICATOR_DATA);
   //ResetLastError();           
   LSMA_Handle1=iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1);   

   //for(int i=0;i<ArraySize(LabelBuffer2);i++){LabelBuffer2[i]=0;}
   //SetIndexBuffer(0,LabelBuffer2,INDICATOR_DATA);
   //ResetLastError();           
   LSMA_Handle2=iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2);   
   
   //for(int i=0;i<ArraySize(LabelBuffer3);i++){LabelBuffer3[i]=0;}
   //SetIndexBuffer(0,LabelBuffer3,INDICATOR_DATA);
   //ResetLastError();           
   LSMA_Handle3=iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3);  
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
resetIndicators();     
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
if(!autoTradingOnOff) return;
	
Allocazione_Check(magic_number); 

static bool qq = false;
if(!qq && !Enable_All_MA2 && !Enable_All_MA3) {Alert("Devono essere abilitate almeno 2 (DUE) MA");qq = true;return;}

semCand = semaforoCandela(0); 
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Libra from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
      
if(!IsMarketTradeOpen(Symbol())) return; 
 
Indicators(Enable_All_MA1,LSMA_Handle1,Enable_All_MA2,LSMA_Handle2,Enable_All_MA3,LSMA_Handle3); 
     
enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);   
double ask=Ask(Symbol());
double bid=Bid(Symbol());

ChiudiOrdDopoNumCand(chiudincand,symbol_,magic_number,Commen);
if(semCand)valMA0 = iMA(symbol_,periodMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price,indexMA);

gestioneBreakEven();
gestioneTrailStop();
if(semCand)gestioneOrdini();

  }
//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
double ASK=Ask(Symbol());
double BID=Bid(Symbol());
double c1 = iClose(Symbol(),PERIOD_CURRENT,1);
double o1 = iOpen(Symbol(),PERIOD_CURRENT,1);

double MA0SuperPoint = valMA0 + DistanzaMaxSup*Point();
double MA0InferPoint = valMA0 - DistanzaMaxInf*Point(); 
 
double valAlto=ValoreSuperiore(lsma1,lsma2,lsma3);
double valBasso=ValoreInferiore(lsma1,lsma2,lsma3);

int pendenzaMA1 = 0;int pendenzaMA2 = 0;int pendenzaMA3 = 0;
   
BARRE=iBarShift(symbol_,TimeFrame1,Yesterday());
   //BARRE=iBars(symbol_,PERIOD_CURRENT);  
   
bool BuyEnab, SellEnab = false;
bool BuySignBreakout, SellSignBreakout=false;
      BreakOutFilterSignal(BreakOutEnable,candPrecedent,timeFrBreak,CandCons,deltaPlus_,BuyEnab,SellEnab,BuySignBreakout,SellSignBreakout);   

copy1=CopyBuffer(LSMA_Handle1,0,0,3,LabelBuffer1);lsma1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy2=CopyBuffer(LSMA_Handle2,0,1,3,LabelBuffer2);lsma2=LabelBuffer2[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy3=CopyBuffer(LSMA_Handle3,0,2,3,LabelBuffer3);lsma3=LabelBuffer3[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 
 
if(LabelBuffer1[1] > LabelBuffer1[2]){pendenzaMA1=-1;
//Print(" MA fast Rossa");
} if(LabelBuffer1[1] < LabelBuffer1[2]){pendenzaMA1=1;
//Print(" MA fast Blu");
} 
if(LabelBuffer2[1] > LabelBuffer2[2]){pendenzaMA2=-1;
//Print(" MA media Rossa");
} if(LabelBuffer2[1] < LabelBuffer2[2]){pendenzaMA2=1;
//Print(" MA media Blu");
} 
if(LabelBuffer3[1] > LabelBuffer3[2]){pendenzaMA3=-1;
//Print(" MA slow Rossa");
} if(LabelBuffer3[1] < LabelBuffer3[2]){pendenzaMA3=1;
//Print(" MA slow Blu");
} 


pendenzeDiscordi(pendenzaMA1,pendenzaMA2,pendenzaMA3);

bool livimpbuy = true,livimpsell = true;
livimp(livimpbuy,livimpsell);

//Print(" OpenOrdPendenzeBuy(pendenzaMA1,pendenzaMA2,pendenzaMA3)",OpenOrdPendenzeBuy(pendenzaMA1,pendenzaMA2,pendenzaMA3));
//Print(" pendenzaMA1: ",pendenzaMA1," pendenzaMA2: ",pendenzaMA2," pendenzaMA3: ",pendenzaMA3);

if (Type_Orders_!=2 && !NumOrdini(magic_number,Commen) && distanzaMABuy(c1,valAlto) && distanzaMinTraMA(valAlto,valBasso)
                    && patternMABuy(patternMA,lsma1,lsma2,lsma3) && c1<MA0SuperPoint && BuyEnab && OpenOrdPendenzeBuy(pendenzaMA1,pendenzaMA2,pendenzaMA3)
                    && livimpbuy)
                    
      {double lots = myVolume(magic_number,symbol_);
       SendPosition(Symbol(),ORDER_TYPE_BUY, lots,0,Deviazione, StopLossCheck("Buy",ASK,valBasso),calcoloTakeProf("Buy",ASK),Commen,magic_number);}//////////////   Inserimento ordine buy


//Print(" OpenOrdPendenzeSell(pendenzaMA1,pendenzaMA2,pendenzaMA3)",OpenOrdPendenzeSell(pendenzaMA1,pendenzaMA2,pendenzaMA3));

if (Type_Orders_!=1 && !NumOrdini(magic_number,Commen) && distanzaMASell(c1,valBasso) && distanzaMinTraMA(valAlto,valBasso) 
                    && patternMASell(patternMA,lsma1,lsma2,lsma3) && c1>MA0InferPoint && SellEnab && OpenOrdPendenzeSell(pendenzaMA1,pendenzaMA2,pendenzaMA3)
                    && livimpsell)
                    
      {double lots = myVolume(magic_number,symbol_);
       SendPosition(Symbol(),ORDER_TYPE_SELL,lots,0,Deviazione, StopLossCheck("Sell",BID,valAlto), calcoloTakeProf("Sell",BID),Commen,magic_number);}////// Inserimento ordine sell

//if(direzioneCandUno(true,"Buy")) SendPosition(Symbol(),ORDER_TYPE_BUY, lotsEA,0,Deviazione, calcoloStopLoss("Buy",ASK),calcoloTakeProf("Buy",ASK),Commen,magic_number);//////////////   Inserimento ordine buy
//if(direzioneCandUno(true,"Sell")) SendPosition(Symbol(),ORDER_TYPE_SELL,lotsEA,0,Deviazione, calcoloStopLoss("Sell",BID), calcoloTakeProf("Sell",BID),Commen,magic_number);////// Inserimento ordine sell
//Print(" Ticket: ",TicketPrimoOrdine(magic_number),"TypeOrder: ",TypeOrder(TicketPrimoOrdine(magic_number))," NumPosizioni: ",NumPosizioni(magic_number,Commen));
} 

void livimp(bool &buy,bool &sell)
{
if(!LivImp) {buy = sell = true;return;}
static bool oldbuy  = false;
static bool oldsell = false;

bool tikbuy = TicketPrimoOrdineBuy(magic_number,Commen);
bool tiksell= TicketPrimoOrdineSell(magic_number,Commen);

if(tikbuy)  {buy = false;oldbuy=true;oldsell = false;}
if(oldbuy)  {buy = false;sell = true;}
//if(tikbuy && oldbuy)   {buy = false;oldsell = false;return;}
//if(!tikbuy && oldbuy)  {buy = false;oldbuy=false;oldsell = true;return;}

if(tiksell)  {sell = false;oldsell=true;oldbuy = false;}
if(oldsell)  {sell = false;buy=true;}
//if(tiksell && oldsell)   {sell = false;oldbuy = false;return;}
//if(!tiksell && oldsell)  {sell = false;oldbuy=true;oldsell = false;return;}
}

bool distanzaMinTraMA(double valAlto, double valBasso)
{
bool a = true;
if(!DistanzaTraMA){a=true;return a;}
//Print(" (valAlto-valBasso)/Point(): ",(valAlto-valBasso)/Point()," DistanzaTraMA: ",DistanzaTraMA);
if((valAlto-valBasso)/Point() < DistanzaTraMA)a = false;
return a;
}

bool distanzaMABuy(double c1_,double valAlto_)
{
bool a = true;
if(!DistanceAll_MASuperiore){a=true;return a;}
if(c1_>valAlto_+DistanceAll_MASuperiore*Point()){a=true;return a;}
if(c1_<valAlto_+DistanceAll_MASuperiore*Point()){a=false;return a;}
{
//Print(" a BUY: ",a);
return a;}
}

bool distanzaMASell(double c1_,double valBasso_)
{
bool a = true;
if(!DistanceAll_MASuperiore){a=true;return a;}
if(c1_<valBasso_-DistanceAll_MAInferiore*Point()){a=true;return a;}
if(c1_>valBasso_-DistanceAll_MAInferiore*Point()){a=false;return a;}
{
//Print(" a SELL: ",a);
return a;}

}

bool OpenOrdPendenzeBuy(int pend1,int pend2,int pend3)
{
bool a = false;
if(!pendenze) {a = true; return a;}
if(pendenze && Enable_All_MA2 && Enable_All_MA3 && pend1==1 && pend2==1 && pend3==1) {a= true; return a;} 
if(pendenze && !Enable_All_MA2 && Enable_All_MA3 && pend1==1 && pend3==1) {a= true; return a;} 
if(pendenze && Enable_All_MA2 && !Enable_All_MA3 && pend1==1 && pend2==1) {a= true; return a;}  
return a;
}

bool OpenOrdPendenzeSell(int pend1,int pend2,int pend3)
{
bool a = false;
if(!pendenze) {a = true; return a;}
if(pendenze && Enable_All_MA2 && Enable_All_MA3 && pend1==-1 && pend2==-1 && pend3==-1) {a= true; return a;}
if(pendenze && !Enable_All_MA2 && Enable_All_MA3 && pend1==-1 && pend3==-1) {a= true; return a;}
if(pendenze && Enable_All_MA2 && !Enable_All_MA3 && pend1==-1 && pend2==-1) {a= true; return a;}
return a;
}

void pendenzeDiscordi(int pend1,int pend2,int pend3)
{
bool a = false;
if(!closeOrdPend || NumOrdini(magic_number,Commen)==0)return;
if(NumOrdini(magic_number,Commen)>0) 
{
if(Enable_All_MA1 && Enable_All_MA2 && Enable_All_MA3 && (pend1 != pend2 || pend2 != pend3 || pend1 != pend3)) a = true; 
if(Enable_All_MA1 && Enable_All_MA2 && !Enable_All_MA3 && (pend1 != pend2 )) a = true; 
if(Enable_All_MA1 && !Enable_All_MA2 && Enable_All_MA3 && (pend1 != pend3)) a = true; 
if(a)brutalCloseTotal(symbol_,magic_number);
}}
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
if(BuySell=="Buy")SL=openPrOrd-Sl_n_pips*Point();
if(BuySell=="Sell")SL=openPrOrd+Sl_n_pips*Point();
return SL;
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

double TrailStopCandle_()
  {
  double TsCandle=0;
if(TicketPrimoOrdineBuy(magic_number,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
if(TicketPrimoOrdineSell(magic_number,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
  return TsCandle;}

double calcoloTakeProf(string BuySell,double openPrOrd)
{
double TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1)
if(BuySell=="Buy")TP=openPrOrd+TpPoints * Point();
if(BuySell=="Sell")TP=openPrOrd-TpPoints * Point();
return TP;
}  
//+------------------------------------------------------------------+
//|                           Indicators                             |
//+------------------------------------------------------------------+
void Indicators(bool Enable_All_MA1_,int Handle1,bool Enable_All_MA2_,int Handle2,bool Enable_All_MA3_,int Handle3)
  {
   char index=0;
     {
      ChartIndicatorAdd(0,0,iMA(symbol_,periodMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price));
      
      if(Enable_All_MA1_){ChartIndicatorAdd(0,0,LSMA_Handle1);}

      if(Enable_All_MA2_){ChartIndicatorAdd(0,0,LSMA_Handle2);}

      if(Enable_All_MA3_){ChartIndicatorAdd(0,0,LSMA_Handle3);}

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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double myVolume(ulong magic,string symbol=NULL){
	double lots = lotsEA*compEA(magic,symbol);
	
	lots = NormalizeDouble(lots,2);
	
	return lots;
}

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
//| ALLOCAZIONE CAPITALE                                             |
//+------------------------------------------------------------------+

void Allocazione_Init(){
	capitalToAllocate = 	capitalToAllocateEA > 0 ? capitalToAllocateEA : AccountBalance();
}  

bool patternMABuy(bool patternMA_,double ma1,double ma2,double ma3)
{
if(!patternMA_)return true;
if(ma1>ma2 && ma2>ma3)return true;
else return false;
}


bool patternMASell(bool patternMA_,double ma1,double ma2,double ma3)
{
if(!patternMA_)return true;
if(ma1<ma2 && ma2<ma3)return true;
else return false;
}

double StopLossCheck(string BuySell, double price, double valAltBass)
{
double a=0;
if(StopLoss_==1) 
{if(BuySell=="Buy"){a=calcoloStopLoss("Buy",price);return a;}if(BuySell=="Sell"){a=calcoloStopLoss("Sell",price);return a;}}

if(StopLoss_==2) {a=valAltBass; return a;}
return a;
}


