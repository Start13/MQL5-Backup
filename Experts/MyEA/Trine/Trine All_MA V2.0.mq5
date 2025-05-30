#property copyright "Corrado Bruni, Copyright ©"
#property link      ""
#property version   "1.00"
#property strict
//---

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

input string comment_ORD =            "--- ORDERS SETTING ---";  // --- ORDERS SETTING ---
input int DistPointsBuy  =            50;          // Distanza Points da MA 1 per Buy
input int DistPointsSell =            50;          // Distanza Points da MA 1 per Sell
input int magicNumber    =			   4444;		      // Magic Number
input string Comment     =            ""; 
input int Deviazione     =             3;          //Slippage 
input int 	nCandles     = 			  10;				// Candele trend
//input int BrStart        =           150;          // Distanza BreakEven Start
//input int BrStep_        =            15;          // Distanza BreakEven Step

//input int trailStop      =           200;          // Distanza Points Trail Stop
//input int trailStep      =            50;          // Distanza Points Trail Step

input ENUM_TIMEFRAMES PeriodPattern1 = PERIOD_CURRENT;              // TF Pattern 1
input ENUM_TIMEFRAMES PeriodPattern2 = PERIOD_CURRENT;              // TF Pattern 2 
 
input string   comment_MM   =          "--- MONEY MANAGEMENT ---";       // --- MONEY MANAGEMENT ---
input bool     compounding  =           true;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100]
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot

input string   comment_SL =           "--- STOP LOSS ---";       // --- STOP LOSS ---
input int      SlPoints                = 10000; //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";      // --- BREAK EVEN ---
input BE       BreakEven                =    1; //Be Type
input int      BeStartPoints            = 2500; //Be Start in Points
input int      BeStepPoints             =  200; //Be Step in Points

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

input string   comment_All_MA1 =            "--- All_MA 1 SETTING ---";   // --- All_MA 1 SETTING ---
bool                    Enable_All_MA1        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame1            =           0;       // Timeframe
input ENUM_PRICE        Price1                =           0;       // Apply To
input int               MA_Period1            =          14;       // Period
input int               MA_Shift1             =           0;       // Shift
input ENUM_MA_MODE      MA_Method1            =         EMA;       // Method
input bool              ShowInColor1          =        true;       // Show In Color
input int               CountBars1            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA2 =            "--- All_MA 2 SETTING ---";   // --- All_MA 2 SETTING ---
bool                    Enable_All_MA2        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame2            =           0;       // Timeframe
input ENUM_PRICE        Price2                =           0;       // Apply To
input int               MA_Period2            =          14;       // Period
input int               MA_Shift2             =           0;       // Shift
input ENUM_MA_MODE      MA_Method2            =         EMA;       // Method
input bool              ShowInColor2          =        true;       // Show In Color
input int               CountBars2            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA3 =            "--- All_MA 3 SETTING ---";   // --- All_MA 3 SETTING ---
input bool              Enable_All_MA3        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame3            =           0;       // Timeframe
input ENUM_PRICE        Price3                =           0;       // Apply To
input int               MA_Period3            =          14;       // Period
input int               MA_Shift3             =           0;       // Shift
input ENUM_MA_MODE      MA_Method3            =         EMA;       // Method
input bool              ShowInColor3          =        true;       // Show In Color
input int               CountBars3            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA4 =            "--- All_MA 4 SETTING ---";   // --- All_MA 4 SETTING ---
input bool              Enable_All_MA4        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame4            =           0;       // Timeframe
input ENUM_PRICE        Price4                =           0;       // Apply To
input int               MA_Period4            =          14;       // Period
input int               MA_Shift4             =           0;       // Shift
input ENUM_MA_MODE      MA_Method4            =         EMA;       // Method
input bool              ShowInColor4          =        true;       // Show In Color
input int               CountBars4            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA5 =            "--- All_MA 5 SETTING ---";   // --- All_MA 5 SETTING ---
input bool              Enable_All_MA5        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame5            =           0;       // Timeframe
input ENUM_PRICE        Price5                =           0;       // Apply To
input int               MA_Period5            =          14;       // Period
input int               MA_Shift5             =           0;       // Shift
input ENUM_MA_MODE      MA_Method5            =         EMA;       // Method
input bool              ShowInColor5          =        true;       // Show In Color
input int               CountBars5            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA6 =            "--- All_MA 6 SETTING ---";   // --- All_MA 6 SETTING ---
input bool              Enable_All_MA6        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame6            =           0;       // Timeframe
input ENUM_PRICE        Price6                =           0;       // Apply To
input int               MA_Period6            =          14;       // Period
input int               MA_Shift6             =           0;       // Shift
input ENUM_MA_MODE      MA_Method6            =         EMA;       // Method
input bool              ShowInColor6          =        true;       // Show In Color
input int               CountBars6            =           0;       // Number of bars counted: 0-all bars 

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

double ASK=0;
double BID=0;
bool semCand;
double capitaleBasePerCompounding;
double distanzaSL = 0;
string symbol_=Symbol();
double c1,o1 = 0;
bool 	candeleInTrend;
bool enableTrading;
bool atr;

int handle_,handle_1,handle_2,handle_3,handle_4,handle_5,handle_6=0;
//---

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>  
//+------------------------------------------------------------------+
int OnInit(){

   if(TimeLicens < TimeCurrent())
      {Alert("EA Trine: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
      ASK=Ask(Symbol());
      BID=Bid(Symbol());  
   resetIndicators();
   
   handle_1=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1);
   handle_2=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2);
   if(Enable_All_MA3)handle_3=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3);
   if(Enable_All_MA4)handle_4=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame4,Price4,MA_Period4,MA_Shift4,MA_Method4,ShowInColor4,CountBars4);
   if(Enable_All_MA5)handle_5=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame5,Price5,MA_Period5,MA_Shift5,MA_Method5,ShowInColor5,CountBars5);
   if(Enable_All_MA6)handle_6=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame6,Price6,MA_Period6,MA_Shift6,MA_Method6,ShowInColor6,CountBars6);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
  resetIndicators(); 
}
//+------------------------------------------------------------------+
void OnTick(){

   if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Trine from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
      
      enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);       
      
      gestioneBreakEven();
      gestioneTrailStop();
      //TsPoints(trailStop,trailStep,magicNumber,Comment);
      //BEPips(BrStart,BrStep_,magicNumber,Comment);
      closeOrders();
      atr=GestioneATR(); 
      Indicators(Enable_All_MA1,handle_1,Enable_All_MA2,handle_2,Enable_All_MA3,handle_3,Enable_All_MA4,handle_4,Enable_All_MA5,handle_5,Enable_All_MA6,handle_6);
      semCand = semaforoCandela(0);
      
   if(semCand)
{   
   if(capitBasePerCompounding1 == 0)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_EQUITY);
   if(capitBasePerCompounding1 == 1)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(capitBasePerCompounding1 == 2)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_BALANCE);
   

      c1 = iClose(Symbol(),PERIOD_CURRENT,1);
      o1 = iOpen(Symbol(),PERIOD_CURRENT,1); 
       
   if(semCand) EA_Strategia(magicNumber);  
}   
 /* 
   double MA1=iAll_MA(symbol_,TimeFrame1,MA_Period1,MA_Shift1,MA_Method1,Price1,1,ShowInColor1,CountBars1);
   double MA2=iAll_MA(symbol_,TimeFrame2,MA_Period2,MA_Shift1,MA_Method2,Price2,1,ShowInColor2,CountBars2);
   double MA3=iAll_MA(symbol_,TimeFrame3,MA_Period3,MA_Shift3,MA_Method3,Price3,1,ShowInColor3,CountBars3);
   double MA4=iAll_MA(symbol_,TimeFrame4,MA_Period4,MA_Shift4,MA_Method4,Price4,1,ShowInColor4,CountBars4);
   double MA5=iAll_MA(symbol_,TimeFrame5,MA_Period5,MA_Shift5,MA_Method5,Price5,1,ShowInColor5,CountBars5);
   double MA6=iAll_MA(symbol_,TimeFrame6,MA_Period6,MA_Shift6,MA_Method6,Price6,1,ShowInColor6,CountBars6);
   Print(" MA1: ",MA1," MA2: ",MA2," MA3: ",MA3," MA4: ",MA4," MA5: ",MA5," MA6: ",MA6);
   */
   
   if(semCand)
   {   
   handle_1=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1);
if(Enable_All_MA2) handle_2=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2);
if(Enable_All_MA3) handle_3=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3);
if(Enable_All_MA4) handle_4=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame4,Price4,MA_Period4,MA_Shift4,MA_Method4,ShowInColor4,CountBars4);
if(Enable_All_MA5) handle_5=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame5,Price5,MA_Period5,MA_Shift5,MA_Method5,ShowInColor5,CountBars5);
if(Enable_All_MA6) handle_6=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame6,Price6,MA_Period6,MA_Shift6,MA_Method6,ShowInColor6,CountBars6);
   }
}
//+------------------------------------------------------------------+
//|                            EA_Strategia                          |
//+------------------------------------------------------------------+
void EA_Strategia(int magic,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){

	//candeleInTrend = 	patternMACongruent_TrendBuy(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6)
	candeleInTrend = 	patternMACongruent_TrendBuy(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3)
	                  //||patternMACongruent_TrendSell(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6);
	                  ||patternMACongruent_TrendSell(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3);
	//int 	n_Candele_Trend = patternMACongruent_TrendBuy_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6)
	int 	n_Candele_Trend = patternMACongruent_TrendBuy_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3)
	                        //+patternMACongruent_TrendSell_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6);
	                        +patternMACongruent_TrendSell_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3);
	

	Print("Nelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend);
	Print("Numero candele in trend: ",n_Candele_Trend);
	
	// BUY
	//bool patternBuy1 = patternMACongruent_TrendBuy(nCandles,1,PeriodPattern1,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6);
	bool patternBuy1 = patternMACongruent_TrendBuy(nCandles,1,PeriodPattern1,symbol,MA_Period1,MA_Period2,MA_Period3);
	//bool patternBuy2 = patternMACongruent_TrendBuy(nCandles,1,PeriodPattern2,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6);
	bool patternBuy2 = patternMACongruent_TrendBuy(nCandles,1,PeriodPattern2,symbol,MA_Period1,MA_Period2,MA_Period3);
	bool patternBuy3 = ASK >= iAll_MA(symbol_,0,TimeFrame1,MA_Period1,MA_Shift1,MA_Method1,Price1,1,ShowInColor1,CountBars1)+DistPointsBuy*Point();
	
	if(patternBuy1 && patternBuy2 && patternBuy3 && NumOrdBuy(magic,Comment)==0 && atr
	//&& c1>patternBuy3 
	//&& c1>=EMA1+DistanzaPoints*Point()
	)
	{//Print(" Distanza: ",calcoloStopLoss("Buy",ASK)," calcoloTakeProf: ",calcoloTakeProf("Buy",ASK));
	distanzaSL = calcoloStopLoss("Buy",ASK);SendTradeBuy(symbol_,myLotSize(),Deviazione,distanzaSL,calcoloTakeProf("Buy",ASK),Comment,magic);}
	
	// SELL
	//bool patternSell1 = patternMACongruent_TrendSell(nCandles,1,PeriodPattern1,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6);
	bool patternSell1 = patternMACongruent_TrendSell(nCandles,1,PeriodPattern1,symbol,MA_Period1,MA_Period2,MA_Period3);
	//bool patternSell2 = patternMACongruent_TrendSell(nCandles,1,PeriodPattern2,symbol,MA_Period1,MA_Period2,MA_Period3,MA_Period4,MA_Period5,MA_Period6);
	bool patternSell2 = patternMACongruent_TrendSell(nCandles,1,PeriodPattern2,symbol,MA_Period1,MA_Period2,MA_Period3);
	bool patternSell3 = BID <= iAll_MA(symbol_,0,TimeFrame1,MA_Period1,MA_Shift1,MA_Method1,Price1,1,ShowInColor1,CountBars1)-DistPointsSell*Point();
	
	if(patternSell1 && patternSell2 && patternSell3 && NumOrdSell(magic,Comment)==0 && atr
	//&& c1<patternSell3 
	//&& c1<=EMA1+DistanzaPoints*Point()
	)
	{//Print(" Distanza: ",calcoloStopLoss("Sell",BID)," calcoloTakeProf: ",calcoloTakeProf("Sell",BID));
	distanzaSL = calcoloStopLoss("Sell",BID);SendTradeSell(symbol_,myLotSize(),Deviazione,distanzaSL,calcoloTakeProf("Sell",BID),Comment,magic);}
}
//+------------------------------------------------------------------+
//|                      patternEMACongruent                         |
//+------------------------------------------------------------------+
bool patternMACongruent(string type,int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
   double ma1 = periodMA_1 > 0 ? iAll_MA(symbol_,0,TimeFrame1,periodMA_1,MA_Shift1,MA_Method1,Price1,index,ShowInColor1,CountBars1) : 0;
   double ma2 = periodMA_2 > 0 ? iAll_MA(symbol_,0,TimeFrame2,periodMA_2,MA_Shift2,MA_Method2,Price2,index,ShowInColor2,CountBars2) : 0;
   double ma3 = periodMA_3 > 0 ? iAll_MA(symbol_,0,TimeFrame3,periodMA_3,MA_Shift3,MA_Method3,Price3,index,ShowInColor3,CountBars3) : 0;
   double ma4 = periodMA_4 > 0 ? iAll_MA(symbol_,0,TimeFrame4,periodMA_4,MA_Shift4,MA_Method4,Price4,index,ShowInColor4,CountBars4) : 0;
   double ma5 = periodMA_5 > 0 ? iAll_MA(symbol_,0,TimeFrame5,periodMA_5,MA_Shift5,MA_Method5,Price5,index,ShowInColor5,CountBars5) : 0;
   double ma6 = periodMA_6 > 0 ? iAll_MA(symbol_,0,TimeFrame6,periodMA_6,MA_Shift6,MA_Method6,Price6,index,ShowInColor6,CountBars6) : 0;

   if(ma1 > 0 && ma2 > 0){
      if(type == "OP_BUY"){
         if(!Enable_All_MA3) return ma1 > ma2;
         if(!Enable_All_MA4) return ma1 > ma2 && ma2 > ma3;
         if(!Enable_All_MA5) return ma1 > ma2 && ma2 > ma3 && ma3 > ma4;
         if(!Enable_All_MA6) return ma1 > ma2 && ma2 > ma3 && ma3 > ma4 && ma4 > ma5;
         return ma1 > ma2 && ma2 > ma3 && ma3 > ma4 && ma4 > ma5 && ma5 > ma6;
      }
      if(type == "OP_SELL"){
         if(!Enable_All_MA3) return ma1 < ma2;
         if(!Enable_All_MA4) return ma1 < ma2 && ma2 < ma3;
         if(!Enable_All_MA5) return ma1 < ma2 && ma2 < ma3 && ma3 < ma4;
         if(!Enable_All_MA6) return ma1 < ma2 && ma2 < ma3 && ma3 < ma4 && ma4 < ma5;
         return ma1 < ma2 && ma2 < ma3 && ma3 < ma4 && ma4 < ma5 && ma5 < ma6;
      }
   }
   return false;
}

bool patternMACongruent_Buy (int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
	return patternMACongruent("OP_BUY",index,timeframe,symbol,periodMA_1,periodMA_2,periodMA_3,periodMA_4,periodMA_5,periodMA_6);
}
bool patternMACongruent_Sell(int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
	return patternMACongruent("OP_SELL",index,timeframe,symbol,periodMA_1,periodMA_2,periodMA_3,periodMA_4,periodMA_5,periodMA_6);
}

bool patternMACongruent_TrendBuy(int nCandlesToAnalyze,int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
   for(int i=0;i<nCandlesToAnalyze;i++)	if(!patternMACongruent_Buy(indexStart+i,timeframe,symbol,periodMA_1,periodMA_2,periodMA_3,periodMA_4,periodMA_5,periodMA_6)) return false;
   return true;
}

bool patternMACongruent_TrendSell(int nCandlesToAnalyze,int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
   for(int i=0;i<nCandlesToAnalyze;i++)	if(!patternMACongruent_Sell(indexStart+i,timeframe,symbol,periodMA_1,periodMA_2,periodMA_3,periodMA_4,periodMA_5,periodMA_6)) return false;
   return true;
}

int patternMACongruent_TrendBuy_nCandles(int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
	int nCount = 0;
	for(int i=indexStart;i<iBars(Symbol(symbol),timeframe)-1;i++)	if(patternMACongruent_Buy(i,timeframe,symbol,periodMA_1,periodMA_2,periodMA_3,periodMA_4,periodMA_5,periodMA_6)) nCount++; else break;
   return nCount;
}

int patternMACongruent_TrendSell_nCandles(int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodMA_1=0,int periodMA_2=0,int periodMA_3=0,int periodMA_4=0,int periodMA_5=0,int periodMA_6=0){
	int nCount = 0;
	for(int i=indexStart;i<iBars(Symbol(symbol),timeframe)-1;i++)	if(patternMACongruent_Sell(i,timeframe,symbol,periodMA_1,periodMA_2,periodMA_3,periodMA_4,periodMA_5,periodMA_6)) nCount++; else break;
   return nCount;
}
//+------------------------------------------------------------------+
//|                          closeOrders                             |
//+------------------------------------------------------------------+
void closeOrders()
{
if(candeleInTrend==0 && NumOrdBuy(magicNumber))brutalCloseBuyTrades();
if(candeleInTrend==0 && NumOrdSell(magicNumber))brutalCloseSellTrades();
}
//+------------------------------------------------------------------+
//|                           iAll_MA                                |
//+------------------------------------------------------------------+
double iAll_MA(string symbol,ENUM_TIMEFRAMES timeframe,ENUM_TIMEFRAMES timeframeIndic,int period,int ma_shift,ENUM_MA_MODE ma_method,ENUM_PRICE applied_price,int index,bool ShowInColor,int CountBars)
{//iAll_MA(symbol_,TimeFrame1,MA_Period1,MA_Shift1,MA_Method1,Price1,1,ShowInColor1,CountBars1)
   handle_=iCustom(symbol,timeframe,"MyIndicators\\MA\\AllAverages_v4.9_MT5",timeframeIndic,applied_price,period,ma_shift,ma_method,ShowInColor,CountBars);
   
   if(handle_ > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle_,0,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}

//+------------------------------------------------------------------+
//|                           Indicators                             |
//+------------------------------------------------------------------+
void Indicators(bool Enable_Ind1,int Handle1,bool Enable_Ind2,int Handle2,bool Enable_Ind3,int Handle3,bool Enable_Ind4,int Handle4,bool Enable_Ind5,int Handle5,bool Enable_Ind6,int Handle6)
  {
   char index=0;
     {
      int a[10];
      static int a_[10];
      a[0]=Enable_All_MA1;a[1]=Enable_All_MA2;a[2]=Enable_All_MA2;a[3]=Enable_All_MA3;a[4]=Enable_All_MA4;a[5]=Enable_All_MA5;
      for(int i=0;i<ArraySize(a);i++){if(a[i]!=a_[i]){break;for(int i=0;i<ArraySize(a);i++){a_[i]=a[i];};resetIndicators();}}
    
      if(Enable_All_MA1){ChartIndicatorAdd(0,0,Handle1);}

      if(Enable_All_MA2){ChartIndicatorAdd(0,0,Handle2);}

      if(Enable_All_MA3){ChartIndicatorAdd(0,0,Handle3);}
      
      if(Enable_All_MA4){ChartIndicatorAdd(0,0,Handle4);}
      
      if(Enable_All_MA5){ChartIndicatorAdd(0,0,Handle5);}
      
      if(Enable_All_MA6){ChartIndicatorAdd(0,0,Handle6);}
      
      if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,index,indicator_handleATR);}     
     }
  }
//+------------------------------------------------------------------+
//|                         resetIndicators                          |
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

         if(GetLastError() != 0){ResetLastError();}

         if(!ChartIndicatorDelete(0, window, name))
           {
            if(GetLastError() != 0){ResetLastError();}
           }
         else
           {Print("Delete indicator with handle:", name);}
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
   if(Filter_ATR && iATR(symbol_,periodATR,ATR_period,0) < thesholdATR) a=false;
   return a;
  }
//+------------------------------------------------------------------+
//|                        calcoloStopLoss                           |
//+------------------------------------------------------------------+  
double calcoloStopLoss(string BuySell,double openPrOrd)
{
double SL=0;
if(BuySell=="Buy")SL=openPrOrd-SlPoints*Point();
if(BuySell=="Sell")SL=openPrOrd+SlPoints*Point();
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
{
if(BuySell=="Buy")TP=openPrOrd+TpPoints * Point();
if(BuySell=="Sell")TP=openPrOrd-TpPoints * Point();
}
return TP;
}
//+------------------------------------------------------------------+
//|                       gestioneBreakEven                          |
//+------------------------------------------------------------------+ 
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(BeStartPoints, BeStepPoints, magicNumber, Comment);
return BreakEv;
}
//+------------------------------------------------------------------+
//|                       gestioneTrailStop                          |
//+------------------------------------------------------------------+ 
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magicNumber, Comment);
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
   if(TicketPrimoOrdineBuy(magicNumber, Comment))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magicNumber, Comment),TypeCandle_,indexCandle_,TFCandle,0.0);
   if(TicketPrimoOrdineSell(magicNumber, Comment))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magicNumber, Comment),TypeCandle_,indexCandle_,TFCandle,0.0);
  return TsCandle;}
//+------------------------------------------------------------------+
//|                         myLotSize()                              |
//+------------------------------------------------------------------+
double myLotSize()
  {
   return NormalizeDoubleLots(myLotSize(compounding,AccountEquity(),capitaleBasePerCompounding,lotsEA,riskEA,riskDenaroEA,(int)distanzaSL,commissioni));
  }  
    