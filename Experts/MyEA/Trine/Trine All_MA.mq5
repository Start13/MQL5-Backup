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
input int                   DistanzaBuyPoints                =  2000;     //Distanza Buy Points All MA 1
input int                   DistanzaSellPoints               =  2000;     //Distanza Sell Points All MA 1
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =   0;       //Close Single Order after n° candles lateral (0 = Disable)
//input int frazioneBalance                                    =   0;       //Se il profitto >= a Balance/N°: chiude ordini
int frazioneBalance                                          =   0;       //Se il profitto >= a Balance/N°: chiude ordini
input Type_Orders            Type_Orders_                    =   0;       //Type of order opening
input bool                   SopraSottoMA_                   =   1;       //Ordini enable Sopra e Sotto TUTTE le medie
input ulong                  magic_number                    = 7777;      //Magic Number
input string                 Commen                          = "EA";      //Comment
input int                    Deviazione                      =    3;      //Slippage 
int                          NumCandTrend                    =   10; 

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
input int      SlPoints                 = 10000; //Stop loss Points.

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


input string   comment_All_MA1 =            "--- All_MA 1 SETTING ---";   // --- All_MA1 SETTING ---
input ENUM_TIMEFRAMES   TimeFrame1            =           0;       // Timeframe
input ENUM_PRICE        Price1                =           0;       // Apply To
input int               MA_Period1            =          14;       // Period
input int               MA_Shift1             =           0;       // Shift
input ENUM_MA_MODE      MA_Method1            =         LSMA;      // Method
input bool              ShowInColor1          =        true;       // Show In Color
input int               CountBars1            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA2 =            "--- All_MA 2 SETTING ---";   // --- All_MA2 SETTING ---
input bool              Enable_All_MA2        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame2            =           0;       // Timeframe
input ENUM_PRICE        Price2                =           0;       // Apply To
input int               MA_Period2            =          14;       // Period
input int               MA_Shift2             =           0;       // Shift
input ENUM_MA_MODE      MA_Method2            =         LSMA;      // Method
input bool              ShowInColor2          =        true;       // Show In Color
input int               CountBars2            =           0;       // Number of bars counted: 0-all bars 

input string   comment_All_MA3 =            "--- All_MA 3 SETTING ---";   // --- All_MA3 SETTING ---
input bool              Enable_All_MA3        =        true;       //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame3            =           0;       // Timeframe
input ENUM_PRICE        Price3                =           0;       // Apply To
input int               MA_Period3            =          14;       // Period
input int               MA_Shift3             =           0;       // Shift
input ENUM_MA_MODE      MA_Method3            =         LSMA;      // Method
input bool              ShowInColor3          =        true;       // Show In Color
input int               CountBars3            =           0;       // Number of bars counted: 0-all bars 

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

bool enableTrading=true;
int handle_iCustom;// Variabile Globale

double ASK;
double BID;

string symbol_=Symbol();
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

int barreChart;
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
      LSMA_Handle1=iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1); 
      double val_Indicator[];
   if(CopyBuffer(LSMA_Handle1,0,1,1,val_Indicator) > 0){
   if(ArraySize(val_Indicator) > 0){
				lsma1 = val_Indicator[0];
			}
		}

   
   if(Enable_All_MA2){
   SetIndexBuffer(0,LabelBuffer2,INDICATOR_DATA);
   ResetLastError();           
   LSMA_Handle2=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame2,Price2,MA_Period2,MA_Shift2,MA_Method2,ShowInColor2,CountBars2);   
   }
   
   if(Enable_All_MA3){
   SetIndexBuffer(0,LabelBuffer3,INDICATOR_DATA);
   ResetLastError();           
   LSMA_Handle3=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame3,Price3,MA_Period3,MA_Shift3,MA_Method3,ShowInColor3,CountBars3);         
   }
   
   Indicators(true,LSMA_Handle1,Enable_All_MA2,LSMA_Handle2,Enable_All_MA3,LSMA_Handle3);

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
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Trine from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(Symbol())) return; 

  
semCand = semaforoCandela(0); 
ASK=Ask(Symbol());
BID=Bid(Symbol());     
enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);  

if(semCand)
{
   if(capitBasePerCompounding1 == 0)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_EQUITY);
   if(capitBasePerCompounding1 == 1)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(capitBasePerCompounding1 == 2)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_BALANCE); 

barreChart=ChartVisibleBars(0);
//Print(" Barre Chart: ",barreChart);     
c1 = iClose(Symbol(),PERIOD_CURRENT,1);
o1 = iOpen(Symbol(),PERIOD_CURRENT,1);
}



CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
closeInProfit();
gestioneBreakEven();
gestioneTrailStop();
//if(semCand)
gestioneOrdini();

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
   if(a == true) Print("EA Trine: Account Ok!");
   else
     {(Print("EA Trine: trial license expired or Account without permission")); ExpertRemove();}
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
bool buy=false;
bool sell=false;
int ordBuy=NumOrdBuy(magic_number,Commen);
int ordSell=NumOrdSell(magic_number,Commen);
int Orders=NumOrdini(magic_number,Commen);
bool atr=GestioneATR();

BARRE=iBarShift(symbol_,TimeFrame1,Yesterday());
barreChart=ChartVisibleBars(0);
   //BARRE=iBars(symbol_,PERIOD_CURRENT);  

copy1=CopyBuffer(LSMA_Handle1,0,1,1,LabelBuffer1);lsma1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
if(Enable_All_MA2){copy2=CopyBuffer(LSMA_Handle2,0,1,1,LabelBuffer2);lsma2=LabelBuffer2[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");}  
if(Enable_All_MA3){copy3=CopyBuffer(LSMA_Handle3,0,1,1,LabelBuffer3);lsma3=LabelBuffer3[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");}  
   //Print(" lsma1: ",lsma1," lsma2 = ",lsma2," lsma3 = ",lsma3);
      
//Print(" LSMA: ",lsma," direzLSMA: ",direzLSMA);
double valoreInferior=ValoreInferiore(lsma1,lsma2,lsma3);
double valoreSuperior=ValoreSuperiore(lsma1,lsma2,lsma3);
if(SopraSottoMA_&&((BID>valoreInferior||ASK<valoreSuperior)))buy=sell=false;

if(Type_Orders_==2)buy=false;
if(Type_Orders_==1)sell=false;

Pattern_All_MA("Buy",NumCandTrend,LSMA_Handle1,LSMA_Handle2,LSMA_Handle3,0,0,0);
/*
if(priceCompreso(ASK,lsma1+(DistanceAll_MASuperiore1*Point()),lsma1-(DistanceAll_MAInferiore1*Point())))buy=false;
if(priceCompreso(ASK,lsma2+(DistanceAll_MASuperiore2*Point()),lsma2-(DistanceAll_MAInferiore2*Point())))buy=false; 
if(priceCompreso(ASK,lsma3+(DistanceAll_MASuperiore3*Point()),lsma3-(DistanceAll_MAInferiore3*Point())))buy=false;  

if(priceCompreso(BID,lsma1+(DistanceAll_MASuperiore1*Point()),lsma1-(DistanceAll_MAInferiore1*Point())))sell=false;
if(priceCompreso(BID,lsma2+(DistanceAll_MASuperiore2*Point()),lsma2-(DistanceAll_MAInferiore2*Point())))sell=false; 
if(priceCompreso(BID,lsma3+(DistanceAll_MASuperiore3*Point()),lsma3-(DistanceAll_MAInferiore3*Point())))sell=false;
*/
//Print(" lsma1: ",lsma1," lsma2: ",lsma2," lsma3: ",lsma3);
//BUY
//Print("Valore lsma: ",lsma1," Valore lsma2: ",lsma2," Valore lsma3: ",lsma3);
if(!Enable_All_MA2&&!Enable_All_MA3&&ASK>=lsma1+DistanzaBuyPoints*Point())buy=true;
if(Enable_All_MA2&&!Enable_All_MA3&&lsma1>lsma2&&ASK>=lsma1+DistanzaBuyPoints*Point())buy=true;
if(Enable_All_MA2&&Enable_All_MA3&&lsma1>lsma2&&lsma2>lsma3&&ASK>=lsma1+DistanzaBuyPoints*Point())buy=true;

if(lsma1<lsma2||lsma1<lsma3||lsma2<lsma3||lsma1==0)buy=false;
//Print(" ASK: ",ASK," lsma1: ",lsma1," lsma1+DistanzaBuyPoints*Point(): ",lsma1+DistanzaBuyPoints*Point()," lsma2: ",lsma2," lsma3: ",lsma3," buy: ",(bool)buy);
//SELL
if(!Enable_All_MA2&&!Enable_All_MA3&&BID<=lsma1-DistanzaSellPoints*Point())sell=true;
if(Enable_All_MA2&&!Enable_All_MA3&&lsma1<lsma2&&BID<=lsma1-DistanzaSellPoints*Point())sell=true;
if(Enable_All_MA2&&Enable_All_MA3&&lsma1<lsma2&&lsma2<lsma3&&BID<=lsma1-DistanzaSellPoints*Point())sell=true;

if(lsma1>lsma2||lsma1>lsma3||lsma2>lsma3||lsma1==0)sell=false;


if(atr&&Orders==0&&buy){distanzaSL = calcoloStopLoss("Buy",ASK);SendTradeBuy(symbol_, myLotSize(),Deviazione, distanzaSL,calcoloTakeProf("Buy",ASK),Commen,magic_number);}         ////////////// Inserimento ordine buy
//Print(" BID: ",BID," lsma1: ",lsma1," lsma1-DistanzaPoints*Point(): ",lsma1-DistanzaPoints*Point()," lsma2: ",lsma2," lsma3: ",lsma3," sell: ",(bool)sell);

if(atr&&Orders==0&&sell){distanzaSL = calcoloStopLoss("Sell",BID);SendTradeSell(symbol_,myLotSize(),Deviazione,distanzaSL,calcoloTakeProf("Sell",BID),Commen,magic_number);}    ////////////// Inserimento ordine sell
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
      
      if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,index,indicator_handleATR);}        
     }
  }
//+------------------------------------------------------------------+
//|                      Pattern_All_MA()                            |
//+------------------------------------------------------------------+
bool Pattern_All_MA(string BuySell,int numCandeleanalist=10,int handle1=0,int handle2=0,int handle3=0,int handle4=0,int handle5=0,int handle6=0)
{
bool a=true;
Print(" handle1: ",handle1," handle2: ",handle2," handle3: ",handle3);

 
double Buffer1[5];double valoriMa1[],valoriMa2[],valoriMa3[],valoriMa4[],valoriMa5[],valoriMa6[];int Copy1;
for(int i=0;i<ArraySize(Buffer1);i++){Buffer1[i]=0;}
for(int i=0;i<ArraySize(valoriMa1);i++){valoriMa1[i]=0;}

for(int i = 1;i<ArraySize(Buffer1);i++){
Copy1=CopyBuffer(handle1,0,i,1,Buffer1);
valoriMa1[i]=Buffer1[0];
if(i<=numCandeleanalist-1 && valoriMa1[i+1]<valoriMa1[i])
Print("Hand1 Candela: ",i," Valore: ",valoriMa1[i]);
}

if(handle2>0){
//double valoriMa2[5];
for(int i = 1;i<ArraySize(Buffer1);i++){
Copy1=CopyBuffer(handle2,0,i,1,Buffer1);
valoriMa2[i]=Buffer1[0];
Print("Hand2 Candela: ",i," Valore: ",valoriMa2[i]);
}}

if(handle3>0){
//double valoriMa3[5];
for(int i = 1;i<ArraySize(Buffer1);i++){
Copy1=CopyBuffer(handle3,0,i,1,Buffer1);
valoriMa3[i]=Buffer1[0];
Print("Hand3 Candela: ",i," Valore: ",valoriMa3[i]);
}}

if(handle4>0){
//double valoriMa4[5];
for(int i = 1;i<ArraySize(Buffer1);i++){
Copy1=CopyBuffer(handle4,0,i,1,Buffer1);
valoriMa4[i]=Buffer1[0];
Print("Hand4 Candela: ",i," Valore: ",valoriMa4[i]);
}}

if(handle5>0){
//double valoriMa5[5];
for(int i = 1;i<ArraySize(Buffer1);i++){
Copy1=CopyBuffer(handle5,0,i,1,Buffer1);
valoriMa5[i]=Buffer1[0];
Print("Hand5 Candela: ",i," Valore: ",valoriMa5[i]);
}}

if(handle6>0){
//double valoriMa6[5];
for(int i = 1;i<ArraySize(Buffer1);i++){
Copy1=CopyBuffer(handle6,0,i,1,Buffer1);
valoriMa6[i]=Buffer1[0];
Print("Hand6 Candela: ",i," Valore: ",valoriMa6[i]);
}}
if(BuySell=="Buy"){
if(handle1>0&&handle2<1)return true;
if(handle1>0&&handle2>0&&handle3<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]<valoriMa2[i])return false;}}
if(handle1>0&&handle2>0&&handle3>0&&handle4<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]<valoriMa2[i]||valoriMa2[i]<valoriMa3[i])return false;}}

if(handle1>0&&handle2>0&&handle3>0&&handle4>0&&handle5<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]<valoriMa2[i]||valoriMa2[i]<valoriMa3[i]||valoriMa3[i]<valoriMa4[i])return false;}}

if(handle1>0&&handle2>0&&handle3>0&&handle4>0&&handle5>0&&handle6<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]<valoriMa2[i]||valoriMa2[i]<valoriMa3[i]||valoriMa3[i]<valoriMa4[i]
                       ||valoriMa4[i]<valoriMa5[i])return false;}}
                       
if(handle1>0&&handle2>0&&handle3>0&&handle4>0&&handle5>0&&handle6>0) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]<valoriMa2[i]||valoriMa2[i]<valoriMa3[i]||valoriMa3[i]<valoriMa4[i]
                       ||valoriMa4[i]<valoriMa5[i]||valoriMa5[i]<valoriMa6[i])return false;}}
}

if(BuySell=="Sell"){
if(handle1>0&&handle2<1)return true;
if(handle1>0&&handle2>0&&handle3<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]>valoriMa2[i])return false;}}
if(handle1>0&&handle2>0&&handle3>0&&handle4<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]>valoriMa2[i]||valoriMa2[i]>valoriMa3[i])return false;}}

if(handle1>0&&handle2>0&&handle3>0&&handle4>0&&handle5<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]>valoriMa2[i]||valoriMa2[i]>valoriMa3[i]||valoriMa3[i]>valoriMa4[i])return false;}}

if(handle1>0&&handle2>0&&handle3>0&&handle4>0&&handle5>0&&handle6<1) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]>valoriMa2[i]||valoriMa2[i]>valoriMa3[i]||valoriMa3[i]>valoriMa4[i]
                       ||valoriMa4[i]>valoriMa5[i])return false;}}
                       
if(handle1>0&&handle2>0&&handle3>0&&handle4>0&&handle5>0&&handle6>0) {for(int i=numCandeleanalist;i>1;i--){if(valoriMa1[i]>valoriMa2[i]||valoriMa2[i]>valoriMa3[i]||valoriMa3[i]>valoriMa4[i]
                       ||valoriMa4[i]>valoriMa5[i]||valoriMa5[i]>valoriMa6[i])return false;}}
}



/*

//Print(" valCand1: ",valCand1," valCand2: ",valCand2," valCand3: ",valCand3);
if(valCand1!=0&&valCand2!=0&&valCand3!=0)
{
//if(doubleCompreso(valCand1,valCand2+valCand2*0.0005,valCand2-valCand2*0.0005)){a=0;return a;}
if(valCand1>valCand2&&valCand2>valCand3)a=1;
if(valCand1<valCand2&&valCand2<valCand3)a=-1;
}
Print(" A: ",a);*/
return a;
}


int ChartVisibleBars(const long chart_ID=0) 
  { 
// --- preparara la variabile per ottenere il valore della proprietà 
   long result=-1; 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- ricevere il valore della proprietà 
   if(!ChartGetInteger(chart_ID,CHART_VISIBLE_BARS,0,result)) 
     { 
      //--- visualizza il messaggio di errore nel journal Experts 
      Print(__FUNCTION__+", Error Code = ",GetLastError()); 
     } 
//--- restituisce il valore della proprietà chart 
   return((int)result); 
  }