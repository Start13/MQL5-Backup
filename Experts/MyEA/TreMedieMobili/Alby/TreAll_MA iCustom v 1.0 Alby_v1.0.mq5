#property copyright "Corrado Bruni, Copyright ©"
#property link      ""
#property version   "2.10"
#property strict
//---
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
enum StopLoss
   {
   SLPoints         = 1,               //Stop Loss in Points
   MA               = 2,               //Stop Loss alla MA 
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
enum NumMaxOrd
{
Uno     =   1,
Due     =   2,
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
enum Type_Orders
  {
   Buy_Sell         = 0,                       //Orders Buy e Sell
   Buy              = 1,                       //Only Buy Orders
   Sell             = 2                        //Only Sell Orders
  };

 
input string   comment_im =            "--- DISTANZE EMA 1---";   // --- DISTANZE EMA 1 ---   

input int DistanzaPoints     =            1000;             //Distanza Points da EMA 1 per apertura Ordini
input int DistanzaMaxPoints  =           10000;             //Distanza Points da EMA 1 Max per apertura Ordini

input string   comment_PATT    =       "--- PATTERN MEDIE MOBILI ---";     // --- PATTERN MEDIE MOBILI ---
input bool     patternMA       =     true;                          //Quando si presenta il Pattern Medie: apre Ordine
input pattImpLiv pattImpLiv_   =        1;                          //Apertura Ordine ad impulso o a livello
input int 	   nCandles        = 	   10;			    	           //Candele trend per apertura Ordine. Min 1
input bool     closeOrdNoPatt  =     true;                          //Quando il Pattern Medie non è allineato: chiude Ordine

input string   comment_PEND  =       "--- PATTERN PENDENZE ---";    // --- PATTERN PENDENZE ---
input bool     pendenze      =       true;                          //Quando le pendenze delle MA sono uguali: apre Ordine
input pendImpLiv pendImpLiv_ =          1;                          //Apertura Ordine ad impulso o a livello
input int 	   nCandlesPend  = 	      10;			    	           //Candele Pendenza uguali per apertura Ordine. Minimo 1
input bool     closeOrdPend  =      false;                          //Quando le pendenze MA sono discordi: chiude ordine
input bool     NoPattNoOpenOrd =     true;                          //Quando le pendenze MA sono discordi: non apre Ordini 

input string   comment_OS=            "--- ORDER SETTINGS ---";    // --- ORDER SETTINGS ---
input int CloseOrdDopoNumCandDalPrimoOrdine_  =   0;       //Close Single Order after n° candles lateral (0 = Disable)
//input Type_Orders            Type_Orders_     =   0;       //Type of order opening
Type_Orders            Type_Orders_     =   0;       //Type of order opening
input bool invertOrders=            false;            //Inverti Ordini Buy / Sell
input NumMaxOrd              NumMaxOrd_       =   1;       //Numero massimo di Ordini
input double lotsEA   =               0.1;            //Lots
input int magicNumber =				    1234;				//Magic Number
input string Comment  =             "TreMedieMobili iCustom"; 

input string   comment_SL=           "--- STOP LOSS ---"; // --- STOP LOSS ---
input StopLoss StopLoss_ =              1;            //Stop Loss Points / MA
input int SlPoints       =          10000;            //Stop loss Points
//input TypeMA TypeMA_     =              1;            //Stop loss su quale MA 
input int distMA         =           1000;            //Distanza Points Stop loss / MA    

input string   comment_BE=           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE  BreakEven      =             1;          //Be Type
input int BrStart        =          2500;          // Distanza BreakEven Start
input int BrStep_        =           200;          // Distanza BreakEven Step

input string   comment_TS=           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop TrailingStop =             1;          //Ts No/Points da Profit/Points Traditional/Candle
input int trailStop      =          4000;          // Distanza Points Trail Stop
input int trailStep      =           700;          // Distanza Points Trail Step

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit=    1;              //Take Profit Type
input int      TpPoints  = 1000;              //Take Profit Points

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

input ENUM_TIMEFRAMES PeriodPattern1 = PERIOD_CURRENT; // TF Pattern 1
input ENUM_TIMEFRAMES PeriodPattern2 = PERIOD_CURRENT; // TF Pattern 2

bool 	candeleInTrend;

string symbol_ = Symbol();

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

double ASK,BID;

int pendenzaMA1 = 0;int pendenzaMA2 = 0;int pendenzaMA3 = 0;
//---
#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
int OnInit(){
handle1 = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1); 
handle2 = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_1MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2); 
handle3 = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_2MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3);    
if(nCandles<1)Alert("Numero candele trend: Minimo 1");
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
resetIndicators(); 
Comment("");  
}

void OnTick(){

      bool semCand=semaforoCandela(0);
   CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);   
   TsPoints(trailStop,trailStep,magicNumber,Comment);
   BEPips(BrStart,BrStep_,magicNumber,Comment);
   NoPattcloseOrders();

   if(semCand)EA_Strategia(magicNumber);
   Indicators();
   ASK = Ask(symbol_);
   BID = Bid(symbol_);
}

void EA_Strategia(int magic,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
   double c1 = iClose(Symbol(),PERIOD_CURRENT,1);  
   double o1 = iOpen(Symbol(),PERIOD_CURRENT,1);  


copy1=CopyBuffer(handle1,0,0,3,LabelBuffer1);iCust1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy2=CopyBuffer(handle2,0,1,3,LabelBuffer2);iCust2=LabelBuffer2[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy3=CopyBuffer(handle3,0,2,3,LabelBuffer3);iCust3=LabelBuffer3[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 

string med1,med2,med3,medCongr;

if(LabelBuffer1[1] > LabelBuffer1[2]){pendenzaMA1=-1;
//Print("MA fast Rossa");
} 
if(LabelBuffer1[1] < LabelBuffer1[2]){pendenzaMA1=1;
//Print("MA fast Blu");
} 

if(pendenzaMA1==1)med1="Rialzista";if(pendenzaMA1==-1)med1="Ribassista";

if(LabelBuffer2[1] > LabelBuffer2[2]){pendenzaMA2=-1;
//Print("MA media Rossa");
} 

if(LabelBuffer2[1] < LabelBuffer2[2]){pendenzaMA2=1;
//Print("MA media Blu");
}
 
if(pendenzaMA2==1)med2="Rialzista";if(pendenzaMA2==-1)med2="Ribassista";

if(LabelBuffer3[1] > LabelBuffer3[2]){pendenzaMA3=-1;
//Print("MA slow Rossa");
} 

if(LabelBuffer3[1] < LabelBuffer3[2]){pendenzaMA3=1;
//Print("MA slow Blu");
} 

if(pendenzaMA3==1)med3="Rialzista";if(pendenzaMA3==-1)med3="Ribassista";

if(pendenzaMA1==1 && pendenzaMA2==1 && pendenzaMA3==1)medCongr="Medie Mobili Rialziste";
if(pendenzaMA1==-1 && pendenzaMA2==-1 && pendenzaMA3==-1)medCongr="Medie Mobili Ribassiste";
if(pendenzaMA1!=pendenzaMA2 || pendenzaMA2!=pendenzaMA3 || pendenzaMA1!=pendenzaMA3)medCongr="Medie Mobili con PENDENZE DIVERSE";

   pendenzeDiscordi(pendenzaMA1,pendenzaMA2,pendenzaMA3);
	
	candeleInTrend = 	patternEMACongruent_TrendBuy(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3)||patternEMACongruent_TrendSell(nCandles,1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3);
	int 	n_Candele_Trend = patternEMACongruent_TrendBuy_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3)+patternEMACongruent_TrendSell_nCandles(1,timeframe,symbol,MA_Period1,MA_Period2,MA_Period3);
	
   Comment(medCongr,"\nPendenza Media Mobile Fast  ",med1,"\nPendenza Media Mobile Med  ",med2,"\nPendenza Media Mobile Slow ",med3,"\n\nNelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend,
           "\nNumero candele in trend: ",n_Candele_Trend );
	Print("Nelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend);
	Print("Numero candele in trend: ",n_Candele_Trend);
   
   ImpulseLevel();

}

int patternPendRialzista(int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0)
   {
   int a = 0;
   for(int i=0;i<=nCandlesPend;i++)
   {
   double ema1 = periodEMA_1 > 0 ? MaCustom(handle1,i+1) : 0;
   double ema1x = periodEMA_1 > 0 ? MaCustom(handle1,i+2): 0;       
   double ema2 = periodEMA_2 > 0 ? MaCustom(handle2,i+1) : 0;
   double ema2x = periodEMA_2 > 0 ? MaCustom(handle2,i+2): 0;   
   double ema3 = periodEMA_3 > 0 ? MaCustom(handle3,i+1) : 0;
   double ema3x = periodEMA_3 > 0 ? MaCustom(handle3,i+2): 0;
    
   if(ema1>ema1x && ema2>ema2x && ema3>ema3x && i==nCandlesPend) {a=1;
   //Print("Num Cand pendenze rialziste ",i);
   break;}
   if(ema1<ema1x || ema2<ema2x || ema3<ema3x) {a=0;
   //Print("Num Cand rialziste ",i);
   break;}  
   }
   return a;
   }   

int patternPendRibassista(int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0) 
   {
   int a = 0;  
      for(int i=0;i<=nCandlesPend;i++)
   {
   double ema1 = periodEMA_1 > 0 ? MaCustom(handle1,i+1) : 0;
   double ema1x = periodEMA_1 > 0 ? MaCustom(handle1,i+2): 0;       
   double ema2 = periodEMA_2 > 0 ? MaCustom(handle2,i+1) : 0;
   double ema2x = periodEMA_2 > 0 ? MaCustom(handle2,i+2): 0;   
   double ema3 = periodEMA_3 > 0 ? MaCustom(handle3,i+1) : 0;
   double ema3x = periodEMA_3 > 0 ? MaCustom(handle3,i+2): 0;
    
   if(ema1<ema1x && ema2<ema2x && ema3<ema3x && i==nCandlesPend) {a=-1;
   //Print("Num Cand pendenze ribassiste ",i);
   break;}
   if(ema1>ema1x || ema2>ema2x || ema3>ema3x) {a=0;
   //Print("Num Cand ribassiste ",i);
   break;}
   }
   return a;
   }   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool patternEMACongruent(string type,int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   double ema1 = periodEMA_1 > 0 ? MaCustom(handle1,index) : 0;    
   double ema2 = periodEMA_2 > 0 ? MaCustom(handle2,index) : 0;
   double ema3 = periodEMA_3 > 0 ? MaCustom(handle3,index) : 0;
   double ema4 = periodEMA_4 > 0 ? MaCustom(handle4,index) : 0;
   double ema5 = periodEMA_5 > 0 ? MaCustom(handle5,index) : 0;
   double ema6 = periodEMA_6 > 0 ? MaCustom(handle6,index) : 0;

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

void NoPattcloseOrders()
{
if(closeOrdNoPatt && candeleInTrend==0 && NumOrdBuy(magicNumber))brutalCloseBuyTrades();
if(closeOrdNoPatt && candeleInTrend==0 && NumOrdSell(magicNumber))brutalCloseSellTrades();
}
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

bool OpenOrdPendenzeBuy()
{
bool a = false;
if(pendImpLiv_==2 && pattImpLiv_==2 && !pendenze) {a = true; return a;}
if((pendImpLiv_==1 || pattImpLiv_==1) && !pendenze) {a = false; return a;}
//if(pendenze && pend1==1 && pend2==1 && pend3==1) {a= true; return a;} 
if(pendenze && patternPendRialzista(MA_Period1,MA_Period2,MA_Period3)==1) {a= true; return a;}
return a;
}

bool OpenOrdPendenzeSell()
{
bool a = false;
if(pendImpLiv_==2 && pattImpLiv_==2 && !pendenze) {a = true; return a;}
if((pendImpLiv_==1 || pattImpLiv_==1) && !pendenze) {a = false; return a;}
//if(pendenze && pend1==-1 && pend2==-1 && pend3==-1) {a= true; return a;}
if(pendenze && patternPendRibassista(MA_Period1,MA_Period2,MA_Period3)==-1) {a= true; return a;}
return a;
}

bool pendenzeDiscordi(int pend1,int pend2,int pend3)  //NoPattNoOpenOrd
{
if(closeOrdPend && NumOrdini(magicNumber,Comment)>0 && (pend1 != pend2 || pend2 != pend3 || pend1 != pend3)) brutalCloseTotal(symbol_,magicNumber);
bool a = true;
if(NoPattNoOpenOrd && (pend1 != pend2 || pend2 != pend3 || pend1 != pend3)) {a = false; return a;}
return a;
}

void ImpulseLevel()   
{
   // BUY
   bool Buy = false;
	bool patternBuy1 = (ASK >= MaCustom(handle1,0)+DistanzaPoints*Point()) && (ASK < MaCustom(handle1,0)+DistanzaMaxPoints*Point()) 
	                   && NumOrdBuy(magicNumber,Comment)==0 && enableOrdini() && Type_Orders_!=2
	                   && pendenzeDiscordi(pendenzaMA1,pendenzaMA2,pendenzaMA3);	
	                   
	bool patternBuy2 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern1,symbol_,MA_Period1,MA_Period2,MA_Period3) 
	                   && patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern2,symbol_,MA_Period1,MA_Period2,MA_Period3);
	                   
	bool patternBuy2_= patternBuy2;  
	                   if((!patternMA && !pendenze) || (!patternMA && pendenze && pendImpLiv_==1)) patternBuy2_=false; 
	                   if(!patternMA && pendenze && pendImpLiv_==2) patternBuy2_=true; 
	                   if(patternMA && pattImpLiv_==1) {patternBuy2_=(daLevelAImpulse1(patternBuy2));} 
	                         
	bool patternBuy3 = OpenOrdPendenzeBuy();
	                   if(pendImpLiv_==1) {patternBuy3=(daLevelAImpulse2(patternBuy3));} 
	                   

	if(pattImpLiv_==2 && pendImpLiv_==2 && patternBuy1 && patternBuy2_ && patternBuy3) {Buy=true;}
	if(pattImpLiv_==2 && pendImpLiv_==1 && patternBuy1 && (patternBuy2_ || patternBuy3)) {Buy=true;}
	if(pattImpLiv_==1 && pendImpLiv_==2 && patternBuy1 && (patternBuy2_ || patternBuy3)) {Buy=true;}
	if(pattImpLiv_==1 && pendImpLiv_==1 && patternBuy1 && (patternBuy2_ || patternBuy3)) {Buy=true;}	

	if(invertOrders){if(Buy)SendTradeSellInPoint(symbol_,lotsEA,0,SlPoints,TpPoints,Comment,magicNumber);}
	if(!invertOrders){if(Buy)SendTradeBuyInPoint(symbol_,lotsEA,0,SlPoints,TpPoints,Comment,magicNumber);}
	
	// SELL
   bool Sell = false;
	bool patternSell1 = (BID <= MaCustom(handle1,0)-DistanzaPoints*Point()) && BID > MaCustom(handle1,0)-DistanzaMaxPoints*Point() 
	                    && NumOrdSell(magicNumber,Comment)==0 && enableOrdini() && Type_Orders_!=1
	                    && pendenzeDiscordi(pendenzaMA1,pendenzaMA2,pendenzaMA3);		

	bool patternSell2 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern1,symbol_,MA_Period1,MA_Period2,MA_Period3) 
	                    && patternEMACongruent_TrendSell(nCandles,1,PeriodPattern2,symbol_,MA_Period1,MA_Period2,MA_Period3);
	                    
	bool patternSell2_= patternSell2;  
	                    if((!patternMA && !pendenze) || (!patternMA && pendenze && pendImpLiv_==1)) patternSell2_=false;
	                    if(!patternMA && pendenze && pendImpLiv_==2) patternSell2_=true;
	                    if(patternMA && pattImpLiv_==1) patternSell2_=(daLevelAImpulse3(patternSell2));
	bool patternSell3 = OpenOrdPendenzeSell();
	                    if(pendImpLiv_==1) patternSell3=(daLevelAImpulse4(patternSell3));

	if(pattImpLiv_==2 && pendImpLiv_==2 && patternSell1 && patternSell2_ && patternSell3) {Sell=true;}
	if(pattImpLiv_==2 && pendImpLiv_==1 && patternSell1 &&(patternSell2_ || patternSell3)) {Sell=true;}
	if(pattImpLiv_==1 && pendImpLiv_==2 && patternSell1 &&(patternSell2_ || patternSell3)) {Sell=true;}
	if(pattImpLiv_==1 && pendImpLiv_==1 && patternSell1 &&(patternSell2_ || patternSell3)) {Sell=true;}
	
	if(invertOrders){if(Sell)SendTradeBuyInPoint(symbol_,lotsEA,0,SlPoints,TpPoints,Comment,magicNumber);}
	if(!invertOrders){if(Sell)SendTradeSellInPoint(symbol_,lotsEA,0,SlPoints,TpPoints,Comment,magicNumber);}
}

bool daLevelAImpulse(bool signal)
{
bool a=false;
static bool signal_ = 0;
int barre = iBars(symbol_,PERIOD_CURRENT);
static int barreSignal;
if(signal_!=signal && signal!=0){a=true;barreSignal=barre;signal_=true;}
if(barre>barreSignal){a=false;}
if(signal==0){signal_=false;}
return a;
}

bool daLevelAImpulse1(bool signal)
{
bool a = false;
static bool signal_ = 0;
static int qq = 0;
if(qq==0 && !signal && !signal_){a=false;return a;}
if(qq==0 && signal && !signal_){a=true;signal_=true;qq++;return a;}
if(qq>0 && signal && signal_){a=false;return a;}
if(qq>0 && !signal && signal_){a=false;signal_=false;qq=0;}
if(qq>0 && !signal && !signal_){a=false;signal_=false;qq=0;}
return a;
}
bool daLevelAImpulse2(bool signal)
{
bool a = false;
static bool signal_ = 0;
static int qq = 0;
if(qq==0 && !signal && !signal_){a=false;return a;}
if(qq==0 && signal && !signal_){a=true;signal_=true;qq++;return a;}
if(signal && signal_ && qq>0){a=false;return a;}
if(!signal && signal_ && qq>0){a=false;signal_=false;qq=0;}
if(qq>0 && !signal && !signal_){a=false;signal_=false;qq=0;}
return a;
}
bool daLevelAImpulse3(bool signal)
{
bool a = false;
static bool signal_ = 0;
static int qq = 0;
if(qq==0 && !signal && !signal_){a=false;return a;}
if(qq==0 && signal && !signal_){a=true;signal_=true;qq++;return a;}
if(signal && signal_ && qq>0){a=false;return a;}
if(!signal && signal_ && qq>0){a=false;signal_=false;qq=0;}
if(qq>0 && !signal && !signal_){a=false;signal_=false;qq=0;}
return a;
}
bool daLevelAImpulse4(bool signal)
{
bool a = false;
static bool signal_ = 0;
static int qq = 0;
if(qq==0 && !signal && !signal_){a=false;return a;}
if(qq==0 && signal && !signal_){a=true;signal_=true;qq++;return a;}
if(signal && signal_ && qq>0){a=false;return a;}
if(!signal && signal_ && qq>0){a=false;signal_=false;qq=0;}
if(qq>0 && !signal && !signal_){a=false;signal_=false;qq=0;}
return a;
}

bool enableOrdini()
{
bool a = true;
if(NumOrdini(magicNumber,Comment)>=NumMaxOrd_) a = false;
return a;
}