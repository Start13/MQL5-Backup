//+------------------------------------------------------------------+
//|                                                   Trine MT5.mq5  |
//|                                   Corrado Bruni Copyright @2024  |
//|                                   "https://www.cbalgotrade.com"  |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.10"
#property strict
//#property indicator_separate_window
#property description "This EA includes third circle strategies."
string versione = "v1.10";
//#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   1

#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrYellow,clrDeepSkyBlue,clrOrangeRed
#property indicator_width1  2


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
long NumeroAccount5 = NumeroAccountOk[5] = 68170289;
long NumeroAccount6 = NumeroAccountOk[6] = 62039500;
long NumeroAccount7 = NumeroAccountOk[7] = 7051966;
long NumeroAccount8 = NumeroAccountOk[8] = 62039500;
long NumeroAccount9 = NumeroAccountOk[9] = 62039500;

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
enum Type_Orders
  {
   Buy_Sell         = 0, //Orders Buy e Sell
   Buy              = 1, //Only Buy Orders
   Sell             = 2  //Only Sell Orders
  };
enum TStop
  {
   No_TS            = 0, //No Trailing Stop
   Pointstop        = 1, //Trailing Stop in Points
   TSPointTradiz    = 2, //Trailing Stop in Points Traditional
   TsTopBotCandle   = 3, //Trailing Stop Previous Candle
  };
enum TypeCandle
  {
   Stesso           = 0, //Trailing Stop sul min/max della candela "index"
   Una              = 1, //Trailing Stop sul min/max del corpo della candela "index"
   Due              = 2, //Trailing Stop sul max/min del corpo della candela "index"
   Tre              = 3, //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE            = 0, //No Breakeven
   BEPoints         = 1, //Breakeven Points
  };      
enum Tp
  {
   No_Tp            = 0, //No Tp
   TpPoints         = 1, //Tp in Points
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
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =   0;       //Close Single Order after n° candles lateral (0 = Disable)
//input int frazioneBalance                                    =   0;       //Se il profitto >= a Balance/N°: chiude ordini
int frazioneBalance                                          =   0;       //Se il profitto >= a Balance/N°: chiude ordini
input Type_Orders            Type_Orders_                    =   0;       //Type of order opening
input bool                   SopraSottoMA_                   =   1;       //Ordini enable Sopra e Sotto TUTTE le medie
input ulong                  magic_number                    = 7777;      //Magic Number
input string                 Commen                          = "EA";      //Comment
input int                    Deviazione                      = 3;         //Slippage 

input string   comment_MM   =          "--- MONEY MANAGEMENT ---";       // --- MONEY MANAGEMENT ---
input bool     compounding  =           true;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100]
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot
/*
input string   comment_CAN   =       "--- FILTER CANDLE ORDERS ---";      // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;      //Abilita più ordini sulla stessa candela
//bool                       OrdiniSuStessaCandela           = true;      //Orders in same CANDLE
input bool                   OrdEChiuStessaCandela           = true;      //Abilita News Orders sulla candela di ordini chiusi*
input string   comment_DIR   =       "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))

input string   comment_BRk =           "--- BREAKOUT ---"; // --- BREAKOUT ---
input bool     BreakOutEnable = false;           //BreakOut enable   
input ENUM_TIMEFRAMES timeFrBreak      = PERIOD_CURRENT;   
input int      candPrecedent  = 100;             //Candele precedenti
input int      deltaPlus_     = 1000;            //Plus Points for BreakOut
input int      CandCons       = 3;
*/

input string   comment_SL =           "--- STOP LOSS ---";       // --- STOP LOSS ---
input int      Sl_n_pips                = 10000; //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";      // --- BREAK EVEN ---
input BE       BreakEven                =    1; //Be Type
input int      Be_Start_pips            = 2500; //Be Start in Points
input int      Be_Step_pips             =  200; //Be Step in Points

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1; //Ts No/Points da Profit/Points Traditional/Candle
input int      TsStart                  = 3000; //Ts Start in Points
input int      TsStep                   =  700; //Ts Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0; //Type Trailing Stop Candle
input int       indexCandle_            =    3; //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;  //Take Profit Type
input int      TpPoints                 = 10000; //Take Profit Points
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
//input string               symbol_="Symbol()";             // simbolo 


input string   comment_All_MA1 =            "--- All_MA 1 SETTING ---";   // --- All_MA 1 SETTING ---
//input bool              Enable_All_MA1        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame1            =           0;       // Timeframe
input ENUM_PRICE        Price1                =           0;       // Apply To
input int               MA_Period1            =          14;       // Period
input int               MA_Shift1             =           0;       // Shift
input ENUM_MA_MODE      MA_Method1            =         LSMA;      // Method
input bool              ShowInColor1          =        true;       // Show In Color
input int               CountBars1            =           0;       // Number of bars counted: 0-all bars 
input int DistanceAll_MASuperiore1            =        4000;       //Distance Points Superior for disable Orders 
input int DistanceAll_MAInferiore1            =        4000;       //Distance Points Inferior for disable Orders 

input string   comment_All_MA2 =            "--- All_MA 2 SETTING ---";   // --- All_MA 2 SETTING ---
input bool              Enable_All_MA2        =            true;   //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame2            =           0;       // Timeframe
input ENUM_PRICE        Price2                =           0;       // Apply To
input int               MA_Period2            =          14;       // Period
input int               MA_Shift2             =           0;       // Shift
input ENUM_MA_MODE      MA_Method2            =         LSMA;      // Method
input bool              ShowInColor2          =        true;       // Show In Color
input int               CountBars2            =           0;       // Number of bars counted: 0-all bars 
input int DistanceAll_MASuperiore2            =        4000;       //Distance Points Superior for disable Orders 
input int DistanceAll_MAInferiore2            =        4000;       //Distance Points Inferior for disable Orders 

input string   comment_All_MA3 =            "--- All_MA 3 SETTING ---";   // --- All_MA 3 SETTING ---
input bool              Enable_All_MA3        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame3            =           0;       // Timeframe
input ENUM_PRICE        Price3                =           0;       // Apply To
input int               MA_Period3            =          14;       // Period
input int               MA_Shift3             =           0;       // Shift
input ENUM_MA_MODE      MA_Method3            =         LSMA;      // Method
input bool              ShowInColor3          =        true;       // Show In Color
input int               CountBars3            =           0;       // Number of bars counted: 0-all bars 
input int DistanceAll_MASuperiore3            =        4000;       //Distance Points Superior for disable Orders 
input int DistanceAll_MAInferiore3            =        4000;       //Distance Points Inferior for disable Orders 


input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

bool enableTrading=true;
int handle_iCustom;// Variabile Globale

double ASK=0;
double BID=0;

string symbol_="";
bool semCand = false;

double c1 = 0;
double o1 = 0;

double capitaleBasePerCompounding;
double distanzaSL = 0;

int LSMA_Handle1;
int LSMA_Handle2;
int LSMA_Handle3;

double LabelBuffer1[];
double LabelBuffer2[];
double LabelBuffer3[];

int copy1;
int copy2;
int copy3;

double lsma1;
double lsma2;
double lsma3;
int BARRE=0;

bool uptrend=false;
bool notrend=false;
bool downtrend=false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent())
     {Alert("EA Trine: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
 
//--- mappatura buffers indicatore
   SetIndexBuffer(0,LabelBuffer1,INDICATOR_DATA);
   ResetLastError();           
   LSMA_Handle1=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1);   

   SetIndexBuffer(0,LabelBuffer2,INDICATOR_DATA);
   ResetLastError();           
   LSMA_Handle2=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2);   
   
   SetIndexBuffer(0,LabelBuffer3,INDICATOR_DATA);
   ResetLastError();           
   LSMA_Handle3=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3);         

   Indicators(true,LSMA_Handle1,Enable_All_MA2,LSMA_Handle2,Enable_All_MA3,LSMA_Handle3);

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
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Trine from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(Symbol())) return; 
   
semCand = semaforoCandela(0); 
     
enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);  

if(semCand)
{
ASK=Ask(Symbol());
BID=Bid(Symbol());  
c1 = iClose(Symbol(),PERIOD_CURRENT,1);
o1 = iOpen(Symbol(),PERIOD_CURRENT,1);  

   if(capitBasePerCompounding1 == 0)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_EQUITY);
   if(capitBasePerCompounding1 == 1)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(capitBasePerCompounding1 == 2)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_BALANCE); 
}

CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
closeInProfit();
gestioneBreakEven();
gestioneTrailStop();
if(semCand)gestioneOrdini();

  }
 

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
bool buy=true;
bool sell=true;
int ordBuy=NumOrdBuy(magic_number,Commen);
int ordSell=NumOrdSell(magic_number,Commen);
int Orders=NumOrdini(magic_number,Commen);
bool atr=GestioneATR(); 

//BARRE=BarsCalculated(LSMA_Handle1);
//BARRE=iBarShift(symbol_,TimeFrame1,Yesterday());
//BARRE=iBars(Symbol(),PERIOD_CURRENT);  
//BARRE=ratesTotal;
BARRE=1;
copy1=CopyBuffer(LSMA_Handle1,0,1,BARRE,LabelBuffer1);lsma1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy2=CopyBuffer(LSMA_Handle2,0,1,BARRE,LabelBuffer2);lsma2=LabelBuffer2[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy3=CopyBuffer(LSMA_Handle3,0,1,BARRE,LabelBuffer3);lsma3=LabelBuffer3[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
//Print(" lsma1: ",lsma1," lsma2 = ",lsma2," lsma3 = ",lsma3);

if(Type_Orders_==2)buy=false;
if(Type_Orders_==1)sell=false;
if(DistanceAll_MASuperiore1&&DistanceAll_MAInferiore1){if(doubleCompreso(ASK,DistanceAll_MASuperiore1*Point()+lsma1,lsma1-DistanceAll_MAInferiore1*Point())){buy=false;sell=false;}}
if(DistanceAll_MASuperiore2&&DistanceAll_MAInferiore2){if(doubleCompreso(ASK,DistanceAll_MASuperiore2*Point()+lsma1,lsma1-DistanceAll_MAInferiore2*Point())){buy=false;sell=false;}}
if(DistanceAll_MASuperiore3&&DistanceAll_MAInferiore3){if(doubleCompreso(ASK,DistanceAll_MASuperiore3*Point()+lsma1,lsma1-DistanceAll_MAInferiore3*Point())){buy=false;sell=false;}}

trendBars();

if(uptrend){sell=false;if(ordSell){brutalCloseSellPositions(symbol_,magic_number);}}//UpTrend = solo buy
if(downtrend){buy=false;if(ordBuy){brutalCloseBuyPositions(symbol_,magic_number);}} //DownTrend = solo sell
if(notrend){buy=false;sell=false;}                                                  //NoTrend = No orders
if(ASK>=lsma1)sell=false;                                                           //Ask sopra a MA1 = solo buy
if(BID<=lsma1)buy=false;                                                            //Bid sotto MA1 = solo sell

//Print(" uptrend: ",uptrend," downtrend: ",downtrend," notrend: ",notrend);Print(" buy: ",buy," sell: ",sell);
/*
if(priceCompreso(ASK,lsma1+(DistanceAll_MASuperiore1*Point()),lsma1-(DistanceAll_MAInferiore1*Point())))buy=false;
if(priceCompreso(ASK,lsma2+(DistanceAll_MASuperiore2*Point()),lsma2-(DistanceAll_MAInferiore2*Point())))buy=false; 
if(priceCompreso(ASK,lsma3+(DistanceAll_MASuperiore3*Point()),lsma3-(DistanceAll_MAInferiore3*Point())))buy=false;  

if(priceCompreso(BID,lsma1+(DistanceAll_MASuperiore1*Point()),lsma1-(DistanceAll_MAInferiore1*Point())))sell=false;
if(priceCompreso(BID,lsma2+(DistanceAll_MASuperiore2*Point()),lsma2-(DistanceAll_MAInferiore2*Point())))sell=false; 
if(priceCompreso(BID,lsma3+(DistanceAll_MASuperiore3*Point()),lsma3-(DistanceAll_MAInferiore3*Point())))sell=false;
*/
/*
if(lsma3==0)lsma3=lsma1;
if(lsma2==0)lsma2=lsma1;
if(lsma1>lsma2&&lsma2>lsma3)buy=true;
if(lsma1<lsma2||lsma1<lsma3||lsma2<lsma3)buy=false;
if(lsma1<lsma2&&lsma2<lsma3)sell=true;
if(lsma1>lsma2||lsma1>lsma3||lsma2>lsma3)sell=false;
*/

distanzaSL = calcoloStopLoss("Buy",ASK);
if(!notrend&&atr&&ordBuy==0&&buy)SendPosition(Symbol(),ORDER_TYPE_BUY, myLotSize(),0,Deviazione, calcoloStopLoss("Buy",ASK),calcoloTakeProf("Buy",ASK),Commen,magic_number);         ////////////// Inserimento ordine buy

distanzaSL = calcoloStopLoss("Sell",BID);
if(!notrend&&atr&&ordSell==0&&sell)SendPosition(Symbol(),ORDER_TYPE_SELL,myLotSize(),0,Deviazione, calcoloStopLoss("Sell",BID), calcoloTakeProf("Sell",BID),Commen,magic_number);    ////////////// Inserimento ordine sell
}
//+------------------------------------------------------------------+
//|                           trendBars()                            |
//+------------------------------------------------------------------+
int trendBars()
{
int a=0;
notrend=false;

double valCand1=lsma1;double Buffer2[];double Buffer3[];

int Copy2=CopyBuffer(LSMA_Handle1,0,2,1,Buffer2);if(Copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 
int Copy3=CopyBuffer(LSMA_Handle1,0,3,1,Buffer3);if(Copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 

double valCand2=Buffer2[0];double valCand3=Buffer3[0];
//Print(" valCand1: ",valCand1," valCand2: ",valCand2," valCand3: ",valCand3);
if(valCand1!=0&&valCand2!=0&&valCand3!=0)
{
if(doubleCompreso(valCand1,valCand3+valCand3*0.00005,valCand3-valCand3*0.00005)){notrend=true;uptrend=false;downtrend=false;a=0;return a;}   //valore cand 1 compreso val cand 2 +/- 0.00005(frazione) = notrend
if(valCand1>valCand2&&valCand2>valCand3){a=1;uptrend=true;downtrend=false;}          //valore candela 1 sup val cand 2 e val cand 2 sup val cand 3 = uptrend
if(valCand1<valCand2&&valCand2<valCand3){a=-1;downtrend=true;uptrend=false;}         //valore candela 1 inferiore val cand 2 eval cand 2 inf val cand 3 = downtrend
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
//|                          closeInProfit                           |
//+------------------------------------------------------------------+
void closeInProfit()
{
//if(frazioneBalance!=0&&ProfitOrdini(magic_number,Commen)>=AccountBalance()/frazioneBalance)brutalCloseTotal(symbol_,magic_number);
static int NumOrd=0;
int numPos=NumPosizioni(magic_number,Commen);
if(numPos==2)NumOrd=2;
//if(NumOrd==2&&numPos==1)brutalCloseTotal(symbol_,magic_number);
}

//+------------------------------------------------------------------+
//|                     timeframeToString                            |
//+------------------------------------------------------------------+
string timeframeToString(ENUM_TIMEFRAMES timeframe)
{
   switch(timeframe)
   {
   case PERIOD_CURRENT  : return("Current");
   case PERIOD_M1       : return("M1");   
   case PERIOD_M2       : return("M2");
   case PERIOD_M3       : return("M3");
   case PERIOD_M4       : return("M4");
   case PERIOD_M5       : return("M5");      
   case PERIOD_M6       : return("M6");
   case PERIOD_M10      : return("M10");
   case PERIOD_M12      : return("M12");
   case PERIOD_M15      : return("M15");
   case PERIOD_M20      : return("M20");
   case PERIOD_M30      : return("M30");
   case PERIOD_H1       : return("H1");
   case PERIOD_H2       : return("H2");
   case PERIOD_H3       : return("H3");
   case PERIOD_H4       : return("H4");
   case PERIOD_H6       : return("H6");
   case PERIOD_H8       : return("H8");
   case PERIOD_H12      : return("H12");
   case PERIOD_D1       : return("D1");
   case PERIOD_W1       : return("W1");
   case PERIOD_MN1      : return("MN1");      
   default              : return("Current");
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
//|                           Indicators                             |
//+------------------------------------------------------------------+
void Indicators(bool Enable_Ind1,int Handle1,bool Enable_Ind2,int Handle2,bool Enable_Ind3,int Handle3)
  {
   char index=0;
     {
      if(Enable_Ind1){ChartIndicatorAdd(0,0,Handle1);}

      if(Enable_Ind2){ChartIndicatorAdd(0,0,Handle2);}

      if(Enable_Ind3){ChartIndicatorAdd(0,0,Handle3);}
      
      if(Filter_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,index,indicator_handleATR);}     
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
   if(a == true) Print("EA Trine: Account Ok!");
   else
     {(Print("EA Trine: trial license expired or Account without permission")); ExpertRemove();}
   return a;
  }
//+------------------------------------------------------------------+
//|                        calcoloStopLoss                           |
//+------------------------------------------------------------------+  
double calcoloStopLoss(string BuySell,double openPrOrd)
{
double SL=0;
if(BuySell=="Buy")SL=openPrOrd-Sl_n_pips*Point();
if(BuySell=="Sell")SL=openPrOrd+Sl_n_pips*Point();
return SL;
}
//+------------------------------------------------------------------+
//|                        calcoloTakeProf                           |
//+------------------------------------------------------------------+  
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
//|                       gestioneBreakEven                          |
//+------------------------------------------------------------------+ 
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(Be_Start_pips, Be_Step_pips, magic_number, Commen);
return BreakEv;
}
//+------------------------------------------------------------------+
//|                       gestioneTrailStop                          |
//+------------------------------------------------------------------+ 
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