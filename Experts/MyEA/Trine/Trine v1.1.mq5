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
input string   comment_MO1 =            "--- Moving Average 1 SETTING ---";   // --- MOVING AVERAGE 1 SETTING ---
input bool                 Filter_MA1               = true;  //Enable Moving Average 1.
//input bool                 OnChart_Moving_Average1  = true;  //On chart
input int                  Moving_period1           =200;     //Period of MA
input int                  Moving_shift1            =0;       //Shift
input ENUM_MA_METHOD       Moving_method1=MODE_EMA;           //Type di smussamento
input ENUM_APPLIED_PRICE   Moving_applied_price1=PRICE_CLOSE; //Type of price
input ENUM_TIMEFRAMES      periodMoving1=PERIOD_CURRENT;      //Timeframe
input int DistanceMASuperiore1          = 4000;               //Distance Points Superior for disable Orders 
input int DistanceMAInferiore1          = 4000;               //Distance Points Inferior for disable Orders 

input string   comment_MO2 =            "--- Moving Average 2 SETTING ---";   // --- MOVING AVERAGE 2 SETTING ---
input bool                 Filter_MA2               = true;  //Enable Moving Average 2.
//input bool                 OnChart_Moving_Average2  = true;  //On chart
input int                  Moving_period2           =200;     //Period of MA
input int                  Moving_shift2            =0;       //Shift
input ENUM_MA_METHOD       Moving_method2=MODE_EMA;           //Type di smussamento
input ENUM_APPLIED_PRICE   Moving_applied_price2=PRICE_CLOSE; //Type of price
input ENUM_TIMEFRAMES      periodMoving2=PERIOD_CURRENT;      //Timeframe
input int DistanceMASuperiore2          = 4000;               //Distance Points Superior for disable Orders 
input int DistanceMAInferiore2          = 4000;               //Distance Points Inferior for disable Orders 

input string   comment_MO3 =            "--- Moving Average 3 SETTING ---";   // --- MOVING AVERAGE 3 SETTING ---
input bool                 Filter_MA3               = true;  //Enable Moving Average 3.
//input bool                 OnChart_Moving_Average3  = true;  //On chart
input int                  Moving_period3           =200;     //Period of MA
input int                  Moving_shift3            =0;       //Shift
input ENUM_MA_METHOD       Moving_method3=MODE_EMA;           //Type di smussamento
input ENUM_APPLIED_PRICE   Moving_applied_price3=PRICE_CLOSE; //Type of price
input ENUM_TIMEFRAMES      periodMoving3=PERIOD_CURRENT;      //Timeframe
input int DistanceMASuperiore3          = 4000;               //Distance Points Superior for disable Orders 
input int DistanceMAInferiore3          = 4000;               //Distance Points Inferior for disable Orders 

input string   comment_LSMA =            "--- LSMA SETTING ---";   // --- LSMA SETTING ---
input bool                 FilterBuySell             = false;  //Enable Buy and Sell con direzione LSMA
input bool                 Enable_LSMA               = false;  //Enable LSMA.
input int                  LSMA_period               =200;     //Period of MA
input int                  LSMA_shift                =0;       //Shift
input ENUM_MA_METHOD       LSMA_method               =MODE_EMA;//Type di smussamento
input ENUM_APPLIED_PRICE   LSMA_applied_price        =PRICE_CLOSE; //Type of price
input ENUM_TIMEFRAMES      periodLSMA=PERIOD_CURRENT;          //Timeframe
input int DistanceLSMASuperiore         = 4000;                //Distance Points Superior for disable Orders 
input int DistanceLSMAInferiore         = 4000;                //Distance Points Inferior for disable Orders 

input string   comment_All_MA =            "--- All_MA SETTING ---";   // --- All_MA SETTING ---
input bool              Enable_All_MA        = false;             //Enable All_MA
input ENUM_TIMEFRAMES   TimeFrame            =           0;       // Timeframe
input ENUM_PRICE        Price                =           0;       // Apply To
input int               MA_Period            =          14;       // Period
input int               MA_Shift             =           0;       // Shift
input ENUM_MA_MODE      MA_Method            =         LSMA;      // Method
input bool              ShowInColor          =        true;       // Show In Color
input int               CountBars            =           0;       // Number of bars counted: 0-all bars 
input int DistanceAll_MASuperiore            = 4000;                //Distance Points Superior for disable Orders 
input int DistanceAll_MAInferiore            = 4000;                //Distance Points Inferior for disable Orders 


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

int LSMA_Handle;
double Label1Buffer[];
int copy1;
int copy2;
int copy3;
double lsma0;
double lsma1;
double lsma2;
int BARRE=0;

double lsma;
double ma1;
double ma2;
double ma3;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA Trine: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}

 
 
//--- mappatura buffers indicatore
   SetIndexBuffer(0,Label1Buffer,INDICATOR_DATA);
   ResetLastError();           
   LSMA_Handle=iCustom(Symbol(),0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame,Price,MA_Period,MA_Shift,MA_Method,ShowInColor,CountBars);   
/*
input ENUM_TIMEFRAMES   TimeFrame            =           0;       // Timeframe
input ENUM_PRICE        Price                =           0;       // Apply To
input int               MA_Period            =          14;       // Period
input int               MA_Shift             =           0;       // Shift
input ENUM_MA_MODE      MA_Method            =         SMA;       // Method
input bool              ShowInColor          =        true;       // Show In Color
input int               CountBars            =           0;       // Number of bars counted: 0-all bars  */
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
   if(capitBasePerCompounding1 == 0)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_EQUITY);
   if(capitBasePerCompounding1 == 1)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(capitBasePerCompounding1 == 2)capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_BALANCE); 
      
 
   BARRE=iBarShift(symbol_,TimeFrame,Yesterday());
   //BARRE=iBars(symbol_,PERIOD_CURRENT);  

   copy1=CopyBuffer(LSMA_Handle,0,0,BARRE,Label1Buffer);lsma0=Label1Buffer[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
   copy2=CopyBuffer(LSMA_Handle,0,1,BARRE,Label1Buffer);lsma1=Label1Buffer[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
   copy3=CopyBuffer(LSMA_Handle,0,2,BARRE,Label1Buffer);lsma2=Label1Buffer[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
   //Print(" lsma0: ",lsma0," lsma1 = ",lsma1," lsma2 = ",lsma2);
      
      
ASK=Ask(Symbol());
BID=Bid(Symbol());

c1 = iClose(Symbol(),PERIOD_CURRENT,1);
o1 = iOpen(Symbol(),PERIOD_CURRENT,1);
}
CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
closeInProfit();
gestioneBreakEven();
gestioneTrailStop();
if(semCand)gestioneOrdini();
//bool enableBuy=0,enableSell=0;
//double sogliaBuy=0,sogliaSell=0;

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
if(BuySell=="Buy")SL=openPrOrd-Sl_n_pips*Point();
if(BuySell=="Sell")SL=openPrOrd+Sl_n_pips*Point();
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
bool buy=true;
bool sell=true;
int ordBuy=NumOrdBuy(magic_number,Commen);
int ordSell=NumOrdSell(magic_number,Commen);
bool atr=GestioneATR();
int    direzLSMA;

 ma1=iMA(symbol_,periodMoving1,Moving_period1,Moving_shift1,Moving_method1,Moving_applied_price1,0);
 ma2=iMA(symbol_,periodMoving2,Moving_period2,Moving_shift2,Moving_method2,Moving_applied_price2,0);
 ma3=iMA(symbol_,periodMoving3,Moving_period3,Moving_shift3,Moving_method3,Moving_applied_price3,0);
 lsma=iLSMA(LSMA_shift,LSMA_period,LSMA_applied_price,direzLSMA);
//Print(" LSMA: ",lsma," direzLSMA: ",direzLSMA);
double valoreInferior=ValoreInferiore(ma1,ma2,ma3,lsma);valoreInferior=ValoreInferiore(valoreInferior,lsma0);
double valoreSuperior=ValoreSuperiore(ma1,ma2,ma3,lsma);valoreSuperior=ValoreSuperiore(valoreSuperior,lsma0);
if(SopraSottoMA_&&(BID>valoreInferior)&&(ASK<valoreSuperior))buy=sell=false;

if(Type_Orders_==2)buy=false;
if(Type_Orders_==1)sell=false;

if(FilterBuySell&&direzLSMA<2)buy=false;//Enable_LSMA
if(Filter_MA1&&priceCompreso(ASK,ma1+(DistanceMASuperiore1*Point()),ma1-(DistanceMAInferiore1*Point())))buy=false;
if(Filter_MA2&&priceCompreso(ASK,ma2+(DistanceMASuperiore2*Point()),ma2-(DistanceMAInferiore2*Point())))buy=false; 
if(Filter_MA3&&priceCompreso(ASK,ma3+(DistanceMASuperiore3*Point()),ma3-(DistanceMAInferiore3*Point())))buy=false;  
if(Enable_LSMA&&priceCompreso(ASK,lsma+(DistanceLSMASuperiore*Point()),lsma-(DistanceLSMAInferiore*Point())))buy=false; 

if(FilterBuySell&&direzLSMA>-1)sell=false;
if(Filter_MA1&&priceCompreso(BID,ma1+(DistanceMASuperiore1*Point()),ma1-(DistanceMAInferiore1*Point())))sell=false;
if(Filter_MA2&&priceCompreso(BID,ma2+(DistanceMASuperiore2*Point()),ma2-(DistanceMAInferiore2*Point())))sell=false; 
if(Filter_MA3&&priceCompreso(BID,ma3+(DistanceMASuperiore3*Point()),ma3-(DistanceMAInferiore3*Point())))sell=false;
if(Enable_LSMA&&priceCompreso(BID,lsma+(DistanceLSMASuperiore*Point()),lsma-(DistanceLSMAInferiore*Point())))sell=false; 

distanzaSL = calcoloStopLoss("Buy",ASK);
if(atr&&ordBuy==0&&buy)SendPosition(Symbol(),ORDER_TYPE_BUY, myLotSize(),0,Deviazione, calcoloStopLoss("Buy",ASK),calcoloTakeProf("Buy",ASK),Commen,magic_number);         ////////////// Inserimento ordine buy

distanzaSL = calcoloStopLoss("Sell",BID);
if(atr&&ordSell==0&&sell)SendPosition(Symbol(),ORDER_TYPE_SELL,myLotSize(),0,Deviazione, calcoloStopLoss("Sell",BID), calcoloTakeProf("Sell",BID),Commen,magic_number);    ////////////// Inserimento ordine sell
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
//|                             iLsma                                |
//+------------------------------------------------------------------+
double iLSMA(int shift, int LSMAPeriod, int LSMAPrice_, int &direzioneLSMA)

{

double Lsma1=iMA(symbol_,0,LSMAPeriod,0,MODE_SMA ,LSMA_applied_price,shift);
double Lsma2=iMA(symbol_,0,LSMAPeriod,0,MODE_LWMA,LSMA_applied_price,shift);

double ma1_=iMA(symbol_,0,LSMAPeriod,0,MODE_SMA ,LSMA_applied_price,1);
double ma2_=iMA(symbol_,0,LSMAPeriod,0,MODE_LWMA,LSMA_applied_price,1);

double LSMA=3.0*ma2-2.0*ma1;
double LSMA1=3.0*ma2_-2.0*ma1_;
//Print(" LSMA1: ",LSMA1);
if(LSMA>LSMA1)direzioneLSMA=1;
if(LSMA<LSMA1)direzioneLSMA=-1;
if(LSMA==LSMA1)direzioneLSMA=0;

return LSMA;

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
void Indicators()
  {
   char index=0;
   bool delete_Indicators= false;
   static double OldarrParamInd [50];
   static int old_arr_Input [30];

   if(delete_Indicators==false){return;}
   if(delete_Indicators==true){resetIndicators();}
     {
{ChartIndicatorAdd(0,0,copy1);}
        {ChartIndicatorAdd(0,0,copy2);}
        {ChartIndicatorAdd(0,0,copy3);}

     }
  }
/*
double lsma0;
double lsma1;
double lsma2;*/