//+------------------------------------------------------------------+
//|                                            Mayer Histo v3.15.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+


#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "3.15"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor is...."
string versione = "v3.15";

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>  
#include <Canvas\Charts\HistogramChart.mqh>

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
enum nMaxPos
  {
   Una_posizione   = 1,  //Max 1 Ordine
   Due_posizioni   = 2,  //Max 2 Ordini
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
   Buy_Sell         = 0,           //Orders Buy e Sell
   Buy              = 1,           //Only Buy Orders
   Sell             = 2            //Only Sell Orders
  };
enum TypeSl
  {
   No               = 0,           //No Stop Loss
   Points           = 1,           //Stop Loss Points
  };  
enum TStop
  {
   No_TS                     = 0,  //No Trailing Stop
   Pointstop                 = 1,  //Trailing Stop in Points
   TSPointTradiz             = 2,  //Trailing Stop in Points Traditional
   TsTopBotCandle            = 3,  //Trailing Stop Previous Candle
  };
enum TypeCandle
  {
   Stesso                    = 0,  //Trailing Stop sul min/max della candela "index"
   Una                       = 1,  //Trailing Stop sul min/max del corpo della candela "index"
   Due                       = 2,  //Trailing Stop sul max/min del corpo della candela "index"
   Tre                       = 3,  //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE                     = 0,  //No Breakeven
   BEPoints                  = 1,  //Breakeven Points
  };      
enum Tp
  {
   No_Tp                     = 0,  //No Tp
   TpPoints                  = 1,  //Tp in Points
   TpMA                      = 2,  //Chiude Ordine sulla Media Mobile (-Spread)
  };
enum levImp 
  {
   impul                     = 0,  //Impulso
   level                     = 1,  //Livello
  }; 
enum inputMA 
  {
   All_MA                    = 0,  //ALL_MA
   MA                        = 1,  //MA
  };   
enum rientro 
  {
   No                     = 0,  //No
   Si                     = 1,  //Abilita Ordini Anche da Rientro da Soglia
   Solo                   = 2,  //Abilita Ordini Solo da Rientro da Soglia
  }; 
enum chord 
  {
   No                     = 0,  //No
   LivOpp                 = 1,  //Chiude dal Livello Opposto
   SogliaOpp              = 2,  //Chiude dalla Soglia Opposta
  };     
enum Filter_ATR_ 
  {
   Flat                   = 0,  //Flat
   Sotto                  = 1,  //Abilita Ordini Sopra il livello impostato
   Sopra                  = 2,  //Abilita Ordini Sotto il livello impostato
  };    
enum direzCand
  {
   No                        = 0,  //Flat
   candN                     = 1,  //N° Candele congrue con l'Ordine
   candNeSuperamBody         = 2,  //N° Candele congrue e superam body cand preced
   candNeSuperamShadow       = 3,  //N° Candele congrue e superam shadow cand preced
  }; 
enum LineType           //Type of lines
  {
   Solid      = 0,
   Dash       = 1,
   Dot        = 2,
   DashDot    = 3,
   DashDotDot = 4
  };

enum LineWidth          //Lines
  {
   VeryThin   = 1,
   Thin       = 2,
   Normal     = 3,
   Thick      = 4,
   VeryThick  = 5
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
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =   0;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
input Type_Orders            Type_Orders_                    =   0;        //Tipo di Ordini
input nMaxPos                N_Max_pos                       =   1;        //Massimo numero di Ordini contemporaneamente
input ulong                  magic_number                    = 4444;       //Magic Number
input string                 Commen                          = "Mayer v3.15";       //Comment
input int                    Deviazione                      =   0;        //Slippage  


input string   comment_DIR     =       "--- TIPO ORDINE/RIENTRO/DIREZ CANDLE ---";       // --- TIPO ORDINE/RIENTRO/DIREZ CANDLE ---
input levImp   levelImpuls     = 0;      //Livello / Impulso
input bool     OrdSoloRientro  = false;  //Apre Ordine Solo a Rientro dalle Soglie
input direzCand  direzCand_    =     1;  //Permette Ordine Cand a favore: No/N°Cand/N°Cand+Body/N°Cand+Shadow
input int      numCandDirez    =     1;  //Numero Candele a favore. Minimo 1.
input ENUM_TIMEFRAMES timeFrCand =   PERIOD_CURRENT; //Time Frame Candele


/*
input string   comment_CANDL   =       "--- FILTER CANDELA SU LIVELLO ---";       // --- FILTER CANDELA SU LIVELLO ---
input bool     candAcavalloLivello      = false;            //Abilita Ordine DALLA candela di "rientro" a cavallo sul livello
*/

//--- input parameters
input string   comment_MAY =        "--- MAYER  SETTING ---";   // --- MAYER  SETTING ---
input double   maxSoglia       = 1.0021;  //Max soglia permessa x Ordine Sell
input double   MaxValore       = 1.0000;  //Max Valore x Ordine Sell
input double   MinValore       = 1.0000;  //Min Valore X Ordine Buy
input double   minSoglia       = 0.9968;  //min soglia permessa x Ordine Buy
input chord    chiudueordineopp=      0;  //Chiude ordine opposto

input string   commentMAS      =    "---  SCELTA MEDIA MOBILE ---";   // --- SCELTA MEDIA MOBILEG ---
input inputMA  inputMA_        =      0;  //Scelta MA

input string   comment_MA1     =    "--- All_MA ---"; // --- All_MA ---
input ENUM_TIMEFRAMES   TimeFrame1            =           0;       // Timeframe
input ENUM_PRICE        Price1                =           0;       // Apply To
input int               MA_Period1            =         100;       // Period
input int               MA_Shift1             =           0;       // Shift
input ENUM_MA_MODE      MA_Method1            =        LSMA;       // Method
input bool              ShowInColor1          =        true;       // Show In Color
input int               CountBars1            =           0;       // Number of bars counted: 0-all bars 

input string   comment_MA =        "--- MA  SETTING ---";   // --- MA  SETTING ---
input int                  periodMAFast  = 30;              //Periodo MA 
input int                  shiftMAFast   =  0;              //Shift MA 
input ENUM_MA_METHOD       methodMAFast=MODE_EMA;           //Metodo MA 
input ENUM_APPLIED_PRICE   applied_priceMAFast=PRICE_CLOSE; //Tipo di  prezzo MA 
input color                coloreMAFast = clrAzure;         //Colore MA 

input string   comment_SL =           "--- STOP LOSS ---"; // --- STOP LOSS ---
input TypeSl   TypeSl_                  =     1;            //Stop Loss: No / Sl Points
input int      SlPoints                 = 10000;            //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_pips            = 2500;              //Be Start in Points
input int      Be_Step_pips             =  200;              //Be Step in Points

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    1;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit Type
input int      TpPoints                 = 1000;              //Take Profit Points

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input Filter_ATR_          Filter_ATR   = 0;                    //Permette Ordini con ATR: Flat/Sopra/Sotto
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period   =    14;                //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

input string   comment_MM   =          "--- MONEY MANAGEMENT ---";        // --- MONEY MANAGEMENT ---
input double   capitalToAllocateEA =  		 0;									  // Capitale da allocare per l'EA (0 = intero capitale)
input bool     compounding  =           true;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100]
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot

input string   comment_MAYCH =        "--- MAYER  SETTING CHART ---";   // --- MAYER  SETTING CHART ---
input bool       shortLines             = true;     //Linee corte
input bool       SHowLineName           = true;     //Nome linea
input bool       DRawBackground         = true; 
input bool       DIsableSelection       = true;   
input color      SoglieColor            = clrGold;  //Colore Soglie
input color      MaxMinColor            = clrLime;  //Colore Livello Sup/Inf
input LineType   REsistanceType         = 2;        //Tipo di linea
input LineWidth  REsistanceWidth        = 1;        //Spessore linea

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

bool Accumulative=true;

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
bool enableTrading = true;

datetime OraNews;

int handle1;
int handleATR;
int handle_iCustomMAFast;

double sogliaSup,maxLiv,minLiv,sogliaInf=0;
string Pcode="Mayer ";
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
	ClearObj();
   //handleATR=iATR(Symbol(),periodATR,ATR_period);  
   if(inputMA_==0) handle_iCustomMAFast = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1);
   if(inputMA_==1) handle_iCustomMAFast = iCustom(symbol_,0,"Examples\\Custom Moving Average Input Color",periodMAFast,shiftMAFast,methodMAFast,coloreMAFast);
   //handle_iCustomMAFast = iCustom(symbol_,0,"MyIndicators\\MA\\AllAverages_v4.9_MT5",TimeFrame1,Price1,MA_Period1,MA_Shift1,MA_Method1,ShowInColor1,CountBars1);
   
   
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
resetIndicators();
ClearObj();
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
//if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_) && GestioneATR();     

ASK=Ask(symbol_);
BID=Bid(symbol_);
spread = (int)((ASK - BID)/Point());
Commento = "Spread "+ (string)spread;
//Comment (Commento);
semCand = semaforoCandela(0); 

Indicators();


CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);   
Chiudueordineopp();
chiudeOrdineMA();
gestioneBreakEven();
gestioneTrailStop();
if(semCand) gestioneOrdini();

if(shortLines)DRawRectangleLine();
else drawHorizontalLevel();
WRiteLineName();
//Histogram();

}  

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
	if(!autoTradingOnOff || !enableTrading) return;
	
	Allocazione_Check(magicNumber);  
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}

double C1 = 0;

static double ma1 = 0;
static double ma2 = 0;
static double coeff = 0;
static double coeff2 = 0;
 
static string a = "Flat";
static string oldA = "Flat";



if(semCand) 
{
C1  = iClose(symbol_,PERIOD_CURRENT,1);
//copy1=CopyBuffer(handle1,0,0,3,LabelBuffer1);iCust1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 
ma1 = MAFast(1);
ma2 = MAFast(2);
coeff  = iClose(symbol_,PERIOD_CURRENT,1) / ma1;
coeff2 = iOpen(symbol_,PERIOD_CURRENT,1) / ma2;
}
sogliaSup = maxSoglia*ma1;
maxLiv    = MaxValore*ma1;
minLiv    = MinValore*ma1;
sogliaInf = minSoglia*ma1;

pseudoHisto();

//Print(" Rientro Buy: ",soloRientroSogliaBuy()," Rientro Sell: ",soloRientroSogliaSell());
if(
      ordini_Tipo_NumMax( "Buy",Type_Orders_,N_Max_pos,magicNumber,Commen)
   && soloRientroSogliaBuy()
   && Type_Orders_!=2 
   && EnableVersoCand("Buy") 
   //&& candACavalloLiv("Buy",coeff,coeff2) 
   && numCandeleCongrue(direzCand_,"Buy",numCandDirez,timeFrCand)
   && doubleCompreso(coeff,MinValore,minSoglia) 
   )
   {
   a="Buy";if(((levelImpuls==0 && a!=oldA)||(levelImpuls == 1)))
   SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf("Buy"),Commen,magic_number);oldA="Buy";
   }                    

if(
      ordini_Tipo_NumMax("Sell",Type_Orders_,N_Max_pos,magicNumber,Commen)
   && soloRientroSogliaSell()
   && Type_Orders_!=1 
   && EnableVersoCand("Sell") 
   //&& candACavalloLiv("Sell",coeff,coeff2) 
   && numCandeleCongrue(direzCand_,"Sell",numCandDirez,timeFrCand)
   && doubleCompreso(coeff,MaxValore,maxSoglia)   
   )
   {
   a="Sell";if(((levelImpuls==0 && a!=oldA)||(levelImpuls == 1)))
   SendTradeSellInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf("Sell"),Commen,magic_number);oldA="Sell";
   }
if(!doubleCompreso(C1,MaxValore,maxSoglia) && oldA=="Buy") oldA="Flat";   
if(!doubleCompreso(C1,MinValore,minSoglia) && oldA=="Sell") oldA="Flat";     
   
}  
//----------------------------------- Chiudueordineopp()----------------------------------------
void Chiudueordineopp()
{
if(!chiudueordineopp)return;

double coeff  = iClose(symbol_,PERIOD_CURRENT,1) / MAFast(1);
if(chiudueordineopp==1){
if(NumOrdBuy(magicNumber,Commen)  && coeff>=MaxValore) {Print("SELL");brutalCloseTotal(symbol_,magic_number);}
if(NumOrdSell(magicNumber,Commen) && coeff<=MinValore) {Print("BUY");brutalCloseTotal(symbol_,magic_number);}
}

if(chiudueordineopp==2){
if(NumOrdBuy(magicNumber,Commen)  && coeff>=maxSoglia) {Print("SELL");brutalCloseTotal(symbol_,magic_number);}
if(NumOrdSell(magicNumber,Commen) && coeff<=minSoglia) {Print("BUY");brutalCloseTotal(symbol_,magic_number);}
}
}
//----------------------------------- pseudoHisto()----------------------------------------
void pseudoHisto()
{
   datetime x1 =     iTime(Symbol(),PERIOD_CURRENT,1);
  // datetime x2 =     TimeCurrent();//iTime(Symbol(),PERIOD_CURRENT,0);
  // datetime x3 =     iTime(symbol_,PERIOD_CURRENT,0);//iTime(Symbol(),PERIOD_CURRENT,0);
  // double   y1 =     Bid()+point(100);
   //double   y2 =     Bid()-point(100);
  // double   y3 =     iLow(symbol_,PERIOD_CURRENT,0)-point(20);
  // double   y4 =     iLow(symbol_,PERIOD_CURRENT,0)-point(100);
   double   y5 =     iLow(symbol_,PERIOD_D1,1)-point(10);  
  // double   y6 =     iLow(symbol_,PERIOD_D1,0)-point(10);   

static double ma1 = 0;
static double ma2 = 0;
static double coeff = 0;
static double coeff2 = 0;
 
static string a = "Flat";
static string oldA = "Flat";

int barre = 0;
if(semCand) barre = iBars(symbol_,PERIOD_CURRENT);
static int barreArrowBuy  = barre;
static int barreArrowSell = barre;
static int barreArrowFlat = barre;
static int count = 0;

if(semCand) 
{
//C1  = iClose(symbol_,PERIOD_CURRENT,1);
ma1 = MAFast(1);
ma2 = MAFast(2);
coeff  = iClose(symbol_,PERIOD_CURRENT,1) / ma1;
coeff2 = iOpen(symbol_,PERIOD_CURRENT,1)  / ma2;
}

Commento = Commento+"\n\nSoglia massima permessa x Ordini Sell "+(string)maxSoglia+"\nValore apertura Ordine Sell "+(string)MaxValore+"\n\nCoeff "
                   +(string)coeff+"\n\nValore apertura Ordine Buy "+(string)MinValore
                   +"\nSoglia minima permessa x Ordini Buy "+(string)minSoglia+"\n\nMayer "+a;
Comment(Commento);

if(doubleCompreso(coeff,MinValore,minSoglia) && barreArrowBuy!=barre){barreArrowBuy=barre;
                     createArrow(0,"ArrBuy"+(string)count,"Buy",x1,y5,0,241,clrLime);count++;}//198   ///////////////////
if(!doubleCompreso(coeff,MinValore,minSoglia) && barreArrowBuy!=0)barreArrowBuy=0;

if(doubleCompreso(coeff,MaxValore,maxSoglia) && barreArrowSell!=barre){barreArrowSell=barre;
                     createArrow(0,"ArrSell"+(string)count,"Sell",x1,y5,0,242,clrRed);count++;}//196   ///////////////////
if(!doubleCompreso(coeff,MaxValore,maxSoglia) && barreArrowSell!=0)barreArrowSell=0;

if(!doubleCompreso(coeff,MinValore,minSoglia) && !doubleCompreso(coeff,MaxValore,maxSoglia) &&  barreArrowSell!=barre)
                     {barreArrowFlat=barre;createArrow(0,"ArrSell"+(string)count,"Sell",x1,y5,0,244,clrYellow);count++;}

if(semCand && (doubleCompreso(coeff,MinValore,MaxValore))) a=oldA="Flat";
if(semCand && (!doubleCompreso(coeff,maxSoglia,minSoglia))) a=oldA="Flat";
//if(semCand && (coeff <= MaxValore && coeff >= MinValore) )a=oldA="Flat";

if(count>=numBarreInChart())
{
for(int i=0;i<count;i++)
{
Print("BUY ",ObjectFind(0,"ArrBuy"+(string)i));
Print("SELL ",ObjectFind(0,"ArrSell"+(string)i));
ObjectDelete(0,"ArrBuy"+(string)i);
ObjectDelete(0,"ArrSell"+(string)i);
count=0;
}}
}

//----------------------------------- soloRientroSogliaBuy()----------------------------------------
bool soloRientroSogliaBuy()
{
static bool Buy = false;

if(!OrdSoloRientro){Buy=true;return Buy;}
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
//Print(" C1: ",C1," (C1 < sogliaInf): ",(C1 < sogliaInf)," (C1 > minLiv): ",(C1 > minLiv)," (C1 > sogliaSup): ",(C1 > sogliaSup)," (C1 < maxLiv): ",(C1 < maxLiv));

if(C1 < sogliaInf) {Buy = true;return Buy;}
if(C1 > minLiv)    {Buy = false;return Buy;}

return Buy;
}
//----------------------------------- soloRientroSogliaSell()----------------------------------------
bool soloRientroSogliaSell()
{
static bool Sell = false;
if(!OrdSoloRientro){Sell=true;return Sell;}
double C1 = iClose(symbol_,PERIOD_CURRENT,1);

if(C1 > sogliaSup) {Sell = true;return Sell;}
if(C1 < maxLiv)    {Sell = false;return Sell;}

return Sell;
}

//----------------------------------- EnableVersoCand()----------------------------------------
bool EnableVersoCand(string BuySell)
{
bool a=true;
if(!direzCand_){a=true;return a;}
if(direzCand_==1){a=direzioneCandUno(true,BuySell);return a;}
return a;
}
/*
//+---------------------------------------------------------------------------------+
//|  direzioneCandeleConOltrepasso(bool a,string BuySell,int oltrepasso)            |controllo su n° candele e oltrepasso body o shadow cand precedente (oltrepasso: 0=no,1=body,2=shadow)
//+---------------------------------------------------------------------------------+/////////////////// Controllare direzione candele 
bool direzioneCandeleConOltrepasso(bool enable,string BuySell,int numCandele,int oltrepasso) 
{
if(!enable)return true;
bool a=false;
for(int i=1;i<=numCandele;i++)
{
if(BuySell=="Buy")
{
if(candelaNumIsBuyOSell(i,"Buy") && i>=numCandele && 
  (!oltrepasso 
  || (oltrepasso==1 && iClose(Symbol(),PERIOD_CURRENT,numCandele)>iOpen(Symbol(),PERIOD_CURRENT,numCandele+1)) 
  || (oltrepasso==2 && iClose(Symbol(),PERIOD_CURRENT,numCandele)>iHigh(Symbol(),PERIOD_CURRENT,numCandele+1) && candelaNumIsBuyOSell(numCandele+1,"Sell")))) // && tipoDiCandelaN("Sell")
                                                                                                  {a=true;return a;}
//---------------------------- candelaNumIsBuyOSell()----------------------------------------
if(candelaNumIsBuyOSell(i,"Sell")) {a=false;return a;}
}
if(BuySell=="Sell")
{
if(iOpen(Symbol(),PERIOD_CURRENT,i)>iClose(Symbol(),PERIOD_CURRENT,i) && i>=numCandele && 
   (!oltrepasso
   || (oltrepasso==1 && iClose(Symbol(),PERIOD_CURRENT,numCandele)<iOpen(Symbol(),PERIOD_CURRENT,numCandele+1)) 
   || (oltrepasso==2 && iClose(Symbol(),PERIOD_CURRENT,numCandele)<iLow(Symbol(),PERIOD_CURRENT,numCandele+1) && candelaNumIsBuyOSell(numCandele+1,"Buy")))) 
                                                                                                  {a=true;return a;}
if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)) {a=false;return a;}
}}
return a;
}  
*/
/*
//---------------------------------- tipoDiCandelaN()----------------------------------------
string tipoDiCandelaN(int candelaNum)
{
string a="";
if(iOpen(Symbol(),PERIOD_CURRENT,candelaNum)<iClose(Symbol(),PERIOD_CURRENT,candelaNum)){a="Buy";return a;}
if(iOpen(Symbol(),PERIOD_CURRENT,candelaNum)>iClose(Symbol(),PERIOD_CURRENT,candelaNum)){a="Sell";return a;}
return a;
}
*/

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
 
//------------------------------- calcoloStopLoss()---------------------------------------------   
int calcoloStopLoss()
{
int a=0;
if(TypeSl_==0){a=0;return a;}
if(TypeSl_==1){a=SlPoints;return a;}
return a;
}
//----------------------------- calcoloTakeProf()--------------------------------------------- 
int calcoloTakeProf(string BuySell)
{
int TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1){TP=TpPoints;return TP;}
//if(TakeProfit==2 && BuySell=="Buy"){TP=(int)((MAFast(0)-ASK)/Point());return TP;}
//if(TakeProfit==2 && BuySell=="Sell"){TP=(int)((BID-MAFast(0))/Point());return TP;}
return TP;
}
//------------------------------ gestioneBreakEven()--------------------------------------------- 
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(Be_Start_pips, Be_Step_pips, magic_number, Commen);
return BreakEv;
}
//------------------------------ gestioneTrailStop()--------------------------------------------- 
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
//|                        chiudeOrdineMA()                          |
//+------------------------------------------------------------------+
void chiudeOrdineMA()
{
if(TakeProfit==2)
{
if(NumOrdBuy(magic_number,Commen) && ASK >= MAFast(0)) brutalCloseBuyTrades(symbol_,magic_number);
if(NumOrdSell(magic_number,Commen) && BID <= MAFast(0)) brutalCloseSellTrades(symbol_,magic_number);
}
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
//|                         myVolume()                               |
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
//|                          Indicators()                            |
//+------------------------------------------------------------------+
void Indicators()
  {


         ChartIndicatorAdd(0,0,handle_iCustomMAFast);
         //ChartIndicatorAdd(0,0,handle_iCustomMA1Color);
           
         if(OnChart_ATR){handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,1,handleATR);}
     }
//+------------------------------------------------------------------+
//|                     resetIndicators()                            |
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
//|                           Histogram()                            |
//+------------------------------------------------------------------+
int Histogram(void)
  {
   int k=100;
   double arr[10];
//--- create chart
   CHistogramChart chart;
   if(!chart.CreateBitmapLabel("SampleHistogramChart",10,10,600,450))
     {
      Print("Error creating histogram chart: ",GetLastError());
      return(-1);
     }
   if(Accumulative)
     {
      chart.Accumulative();
      chart.VScaleParams(20*k*10,-10*k*10,20);
     }
   else
      chart.VScaleParams(20*k,-10*k,20);
   chart.ShowValue(true);
   chart.ShowScaleTop(false);
   chart.ShowScaleBottom(false);
   chart.ShowScaleRight(false);
   chart.ShowLegend();
   for(int j=0;j<5;j++)
     {
      for(int i=0;i<10;i++)
        {
         k=-k;
         if(k>0)
            arr[i]=k*(i+10-j);
         else
            arr[i]=k*(i+10-j)/2;
        }
      chart.SeriesAdd(arr,"Item"+IntegerToString(j));
     }
//--- play with values
   while(!IsStopped())
     {
      int i=rand()%5;
      int j=rand()%10;
      k=rand()%3000-1000;
      chart.ValueUpdate(i,j,k);
      Sleep(200);
     }
//--- finish
   chart.Destroy();
   return(0);
  }
//+------------------------------------------------------------------+
//|                           ClearObj()                             |
//+------------------------------------------------------------------+  
void ClearObj()
  {
   if(ObjectFind(0,Pcode+"Soglia Sup")>=0)ObjectDelete(0,Pcode+"Soglia Sup");
   if(ObjectFind(0,Pcode+"Liv Sup")>=0)ObjectDelete(0,Pcode+"Liv Sup");
   if(ObjectFind(0,Pcode+"Liv Inf")>=0)ObjectDelete(0,Pcode+"Liv Inf");
   if(ObjectFind(0,Pcode+"Soglia Inf")>=0)ObjectDelete(0,Pcode+"Soglia Inf");
   
   if(ObjectFind(0,Pcode+"Soglia Sup ")>=0)ObjectDelete(0,Pcode+"Soglia Sup ");
   if(ObjectFind(0,Pcode+"Liv Sup ")>=0)ObjectDelete(0,Pcode+"Liv Sup ");   
   if(ObjectFind(0,Pcode+"Liv Inf ")>=0)ObjectDelete(0,Pcode+"Liv Inf ");
   if(ObjectFind(0,Pcode+"Soglia Inf ")>=0)ObjectDelete(0,Pcode+"Soglia Inf ");   
   
  }
//+------------------------------------------------------------------+
//|                      WRiteLineName()                             |
//+------------------------------------------------------------------+
void WRiteLineName()
  {

   datetime time2,Time5[1];

   Time5[0]=0;

   CopyTime(Symbol(),Period(),0,1,Time5);

   if(!MQLInfoInteger(MQL_TESTER))
     {
      if(!ChartGetInteger(0,CHART_SHIFT,0)){time2 = Time5[0]-(PeriodSeconds(Period())*13);}
      else{time2 = Time5[0]+(PeriodSeconds(Period())*13);}
     }
   else
     {
      if(!ChartGetInteger(0,CHART_SHIFT,0)){time2 = Time5[0]-(PeriodSeconds(Period())*13);}
      else{time2 = Time5[0]+(PeriodSeconds(Period()));}
     }
//time2= Time5[0]+(PeriodSeconds(Period())*13);
   if(SHowLineName)
     {
      if(sogliaSup!=0)
        {
         if(ObjectFind(0,Pcode+"Soglia Sup ")<0)
           {
            ObjectCreate(0,Pcode+"Soglia Sup ", OBJ_TEXT,0,time2,sogliaSup);
            ObjectSetString(0,Pcode+"Soglia Sup ",OBJPROP_TEXT,Pcode+"sogliaSup "+DoubleToString(NormalizeDouble(sogliaSup,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Soglia Sup ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_BACK,DRawBackground);
            ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_SELECTABLE,!DIsableSelection);
            ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Soglia Sup ",0,time2,sogliaSup);
            ObjectSetString(0,Pcode+"Soglia Sup ",OBJPROP_TEXT,Pcode+"Soglia Sup "+DoubleToString(NormalizeDouble(sogliaSup,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_COLOR,SoglieColor);
        }

      if(maxLiv!=0)
        {
         if(ObjectFind(0,Pcode+"Liv Sup ")<0)
           {
            ObjectCreate(0,Pcode+"Liv Sup ", OBJ_TEXT,0,time2,maxLiv);
            ObjectSetString(0,Pcode+"Liv Sup ",OBJPROP_TEXT,Pcode+"Liv Sup "+DoubleToString(NormalizeDouble(maxLiv,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Liv Sup ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Liv Sup ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Liv Sup ",OBJPROP_BACK,DRawBackground);
            ObjectSetInteger(0,Pcode+"Liv Sup ",OBJPROP_SELECTABLE,!DIsableSelection);
            ObjectSetInteger(0,Pcode+"Liv Sup ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Liv Sup ",0,time2,maxLiv);
            ObjectSetString(0,Pcode+"Liv Sup ",OBJPROP_TEXT,Pcode+"Liv Sup "+DoubleToString(NormalizeDouble(maxLiv,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"Liv Sup ",OBJPROP_COLOR,MaxMinColor);
        }

      if(minLiv!=0)
        {
         if(ObjectFind(0,Pcode+"Liv Inf ")<0)
           {
            ObjectCreate(0,Pcode+"Liv Inf ", OBJ_TEXT,0,time2,minLiv);
            ObjectSetString(0,Pcode+"Liv Inf ",OBJPROP_TEXT,Pcode+"Liv Inf "+DoubleToString(NormalizeDouble(minLiv,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Liv Inf ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Liv Inf ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Liv Inf ",OBJPROP_BACK,DRawBackground);
            ObjectSetInteger(0,Pcode+"Liv Inf ",OBJPROP_SELECTABLE,!DIsableSelection);
            ObjectSetInteger(0,Pcode+"Liv Inf ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Liv Inf ",0,time2,minLiv);
            ObjectSetString(0,Pcode+"Liv Inf ",OBJPROP_TEXT,Pcode+"Liv Inf "+DoubleToString(NormalizeDouble(minLiv,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"Liv Inf ",OBJPROP_COLOR,MaxMinColor);
        }

      if(sogliaInf!=0)
        {
         if(ObjectFind(0,Pcode+"Soglia Inf ")<0)
           {
            ObjectCreate(0,Pcode+"Soglia Inf ", OBJ_TEXT,0,time2,sogliaInf);
            ObjectSetString(0,Pcode+"Soglia Inf ",OBJPROP_TEXT,Pcode+"Soglia Inf "+DoubleToString(NormalizeDouble(sogliaInf,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Soglia Inf ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_BACK,DRawBackground);
            ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_SELECTABLE,!DIsableSelection);
            ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Soglia Inf ",0,time2,sogliaInf);
            ObjectSetString(0,Pcode+"Soglia Inf ",OBJPROP_TEXT,Pcode+"Soglia Inf "+DoubleToString(NormalizeDouble(sogliaInf,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_COLOR,SoglieColor);
        }
}}  
//+------------------------------------------------------------------+
//|                    drawHorizontalLine()                          |
//+------------------------------------------------------------------+
void drawHorizontalLevel()
  {
   datetime Time5[1];
   CopyTime(Symbol(),PERIOD_D1,0,1,Time5);

   if(sogliaSup!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Sup")<0)
         ObjectCreate(0,Pcode+"Soglia Sup", OBJ_HLINE, 0, Time5[0], sogliaSup);
      else
         ObjectMove(0,Pcode+"Soglia Sup",0,Time5[0],sogliaSup);

      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_COLOR, SoglieColor);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_HIDDEN, true);
     }

   if(maxLiv!=0)
     {
      if(ObjectFind(0,Pcode+"Liv Sup")<0)
         ObjectCreate(0,Pcode+"Liv Sup", OBJ_HLINE, 0, Time5[0], maxLiv);
      else
         ObjectMove(0,Pcode+"Liv Sup",0,Time5[0],maxLiv);

      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_COLOR, MaxMinColor);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_HIDDEN, true);
     }

   if(minLiv!=0)
     {
      if(ObjectFind(0,Pcode+"Liv Inf")<0)
         ObjectCreate(0,Pcode+"Liv Inf", OBJ_HLINE, 0, Time5[0], minLiv);
      else
         ObjectMove(0,Pcode+"Liv Inf",0,Time5[0],minLiv);

      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_COLOR, MaxMinColor);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_HIDDEN, true);
     }

   if(sogliaInf!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Inf")<0)
         ObjectCreate(0,Pcode+"Soglia Inf", OBJ_HLINE, 0, Time5[0], sogliaInf);
      else
         ObjectMove(0,Pcode+"Soglia Inf",0,Time5[0],sogliaInf);

      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_COLOR, SoglieColor);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_HIDDEN, true);
     }
}

//+------------------------------------------------------------------+
//|                    DRawRectangleLine()                           |
//+------------------------------------------------------------------+
void DRawRectangleLine()
  {
   datetime time1,time2,Time5[1];

   Time5[0]=0;
   CopyTime(Symbol(),PERIOD_CURRENT,0,1,Time5);
   time1 = TimeCurrent();//Time5[0]-(PeriodSeconds(Period())*50);

   CopyTime(Symbol(),Period(),0,1,Time5);
   time2 = Time5[0]+(PeriodSeconds(Period())*50);

   if(sogliaSup!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Sup")<0)
         ObjectCreate(0,Pcode+"Soglia Sup", OBJ_RECTANGLE, 0, time1, sogliaSup, time2, sogliaSup);
      else
        {
         ObjectMove(0,Pcode+"Soglia Sup",0,time1,sogliaSup);
         ObjectMove(0,Pcode+"Soglia Sup",1,time2,sogliaSup);
        }
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_COLOR, SoglieColor);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_HIDDEN, true);
     }

   if(maxLiv!=0)
     {
      if(ObjectFind(0,Pcode+"Liv Sup")<0)
        {
         ObjectCreate(0,Pcode+"Liv Sup", OBJ_RECTANGLE,0,time1,maxLiv,time2,maxLiv);
        }
      else
        {
         ObjectMove(0,Pcode+"Liv Sup",0,time1,maxLiv);
         ObjectMove(0,Pcode+"Liv Sup",1,time2,maxLiv);
        }
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_COLOR, MaxMinColor);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Liv Sup", OBJPROP_HIDDEN, true);
     }

   if(minLiv!=0)
     {
      if(ObjectFind(0,Pcode+"Liv Inf")<0)
         ObjectCreate(0,Pcode+"Liv Inf", OBJ_RECTANGLE,0,time1,minLiv,time2,minLiv);
      else
        {
         ObjectMove(0,Pcode+"Liv Inf",0,time1,minLiv);
         ObjectMove(0,Pcode+"Liv Inf",1,time2,minLiv);
        }
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_COLOR, MaxMinColor);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Liv Inf", OBJPROP_HIDDEN, true);
     }

   if(sogliaInf!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Inf")<0)
         ObjectCreate(0,Pcode+"Soglia Inf", OBJ_RECTANGLE,0,time1,sogliaInf,time2,sogliaInf);
      else
        {
         ObjectMove(0,Pcode+"Soglia Inf",0,time1,sogliaInf);
         ObjectMove(0,Pcode+"Soglia Inf",1,time2,sogliaInf);
        }
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_WIDTH, REsistanceWidth);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_COLOR, SoglieColor);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_STYLE, REsistanceType);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_HIDDEN, true);
     }}  


  

  
  