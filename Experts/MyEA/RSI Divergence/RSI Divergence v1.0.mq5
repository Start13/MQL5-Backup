//+------------------------------------------------------------------+
//|                                          RSI Divergence v1.0.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version     "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   5
//--- plot Arrow to up
#property indicator_label1  "Long signal"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Arrow to down
#property indicator_label2  "Short signal"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot divergence line to up
#property indicator_label3  "Line to up"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot divergence line to down
#property indicator_label4  "Line to down"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot AO
#property indicator_label5  "RSI"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1

#property description "The Expert Advisor....."
string versione     = "v1.00";

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
 
input string   comment_OS =       "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input bool                   StopNewsOrders                  = false;      //Ferma l'EA quando terminano gli Ordini
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =  22;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
input char                   maxDDPerc                       =   0;        //Max DD% (0 Disable)
input int                    MaxSpread                       =   0;        //Max Spread (0 = Disable)
input TipoOrdini             tipoOrdini                      =   0;        //Tipo di Ordini
input numMaxOrd              numMaxOrdini                    =   2;        //Massimo numero di Ordini contemporaneamente
//input int                   N_max_orders                   =  50;        //Massimo numero di Ordini nella giornata
input ulong                  magicNumber                    = 4444;       //Magic Number
input string                 Commen                          = "RSI Divergence v1.0";       //Comment
input int                    Deviazione                      = 3;          //Slippage 

input uint                 InpPeriod         =  14;            // Period
input ENUM_APPLIED_PRICE   InpAppliedPrice   =  PRICE_CLOSE;   // Applied price
input double               InpOverbought     =  70;            // Overbought
input double               InpOversold       =  30;            // Oversold
input color                InpColorBullish   =  clrBlue;       // Bullish color
input color                InpColorBearish   =  clrRed;        // Bearish color


input string   comment_CAN   =     "--- FILTER CANDLE ORDERS ---";       // --- FILTER CANDLE ORDERS ---
input bool                   OrdiniSuStessaCandela           = true;     //Abilita più ordini sulla stessa candela
input bool                   OrdEChiuStessaCandela           = true;     //Abilita News Orders sulla candela di ordini già aperti e/o chiusi
input string   comment_DIR   =     "--- FILTER DIREZ CANDLE ---";       // --- FILTER DIREZ CANDLE ---
input bool                   direzCandZero                   = false;     //Direction Candle attuale in favor (0))
input bool                   direzCandUno                    = false;     //Direction Candle precedente in favor (1))
input string   comment_BRk =       "--- BREAKOUT ---"; // --- BREAKOUT ---
input bool     BreakOutEnable      = false;           //BreakOut enable 
input int      Breakmode           = 2;               //Mode_1: aggiorna le soglie con ritardo.
input string   Mode_2 = "aggiorna le soglie quando la candela chiude sotto(buy) o sopra(sell) la soglia";  
input ENUM_TIMEFRAMES timeFrBreak  = PERIOD_CURRENT;  //Time frame BreakOut  
input int      candPrecedent       = 100;             //Check candele precedenti
input int      deltaPlus_          = 0;               //Plus Points for BreakOut
input int      CandCons            = 3;               //Candele consecutive


input string   comment_SL =        "--- STOP LOSS ---"; // --- STOP LOSS ---
input TipoStopLoss   TypeSl_                  =     1;            //Stop Loss: No / Sl Points
input int      SlPoints                 = 10000;            //Stop loss Points.

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

input string   comment_ZZ =        "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input bool     FilterZigZag             = false;  // Filter Body candle Pik ZigZag
input bool     FilterZZShad             = false;  // Filter Top/Bottom candle Pik ZigZag
input int      InpDepth                 = 12;     // ZigZag: Depth
input int      InpDeviation             =  5;     // ZigZag: Deviation
input int      InptBackstep             =  3;     // ZigZag: Backstep
input int    InpCandlesCheck            = 50;     // ZigZag: how many candles to check back
input int      disMinCandZZ             =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe


input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
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

double ASK         = 0;
double BID         = 0;

string symbol_     = Symbol();

bool semCand       = false;

string Commento    = "";
bool enableTrading = true;

datetime OraNews;

int handle_iCustom;// Variabile Globale
int handleATR;

int handle0,handle1,handle2,handle3,handle4,handle5;

double LabelBuffer0[];
double LabelBuffer1[];
double LabelBuffer2[];
double LabelBuffer3[];
double LabelBuffer4[];
double LabelBuffer5[];

int    copy0;
int    copy1;
int    copy2;
int    copy3;
int    copy4;
int    copy5;

double iCust0;
double iCust1;
double iCust2;
double iCust3;
double iCust4;
double iCust5;

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
	
	
	/*
input uint                 InpPeriod         =  14;            // Period
input ENUM_APPLIED_PRICE   InpAppliedPrice   =  PRICE_CLOSE;   // Applied price
input double               InpOverbought     =  70;            // Overbought
input double               InpOversold       =  30;            // Oversold
input color                InpColorBullish   =  clrBlue;       // Bullish color
input color                InpColorBearish   =  clrRed;        // Bearish color*/
    handle_iCustom   = iCustom(symbol_,0,"MyIndicators\\Divergenze\\RSI_Divergence",InpPeriod,InpAppliedPrice,InpOverbought,InpOversold,InpColorBullish,InpColorBearish);  
//---
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
	
	if(!autoTradingOnOff) return;
	
	Allocazione_Check(magicNumber);  
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);     
  
ASK=Ask(symbol_);
BID=Bid(symbol_);
Commento = spreadComment();
Comment (Commento);
semCand = semaforoCandela(0); 
/*
copy0=CopyBuffer(handle0,0,2,3,LabelBuffer0);iCust0=LabelBuffer0[0];if(copy0<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");
copy1=CopyBuffer(handle1,0,0,3,LabelBuffer1);iCust1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy2=CopyBuffer(handle2,0,1,3,LabelBuffer2);iCust2=LabelBuffer2[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy3=CopyBuffer(handle3,0,2,3,LabelBuffer3);iCust3=LabelBuffer3[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 
copy4=CopyBuffer(handle4,0,0,3,LabelBuffer4);iCust4=LabelBuffer4[0];if(copy4<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy5=CopyBuffer(handle5,0,1,3,LabelBuffer5);iCust5=LabelBuffer5[0];if(copy5<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
*/ 





Indicators();
CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);
gestioneBreakEven();
gestioneTrailStop();
gestioneOrdini();
bool enableBuy=0,enableSell=0;
double sogliaBuy=0,sogliaSell=0;

  }
 

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
if(!enableTrading)return;

maxOrd_BuySellBuy(numMaxOrdini,tipoOrdini,magicNumber,Commen);
maxOrd_BuySellSell(numMaxOrdini,tipoOrdini,magicNumber,Commen);

//SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf(),Commen,magicNumber);
//SendTradeSellInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf(),Commen,magicNumber);
//direzioneCandUno(bool a,string BuySell) 
}
//+------------------------------------------------------------------+
//|                          Indicators()                            |
//+------------------------------------------------------------------+
void Indicators()
  {
   char index=1;

         ChartIndicatorAdd(0,1,handle_iCustom);

           // index ++;
   //if(OnChart_ATR) int    indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);  
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
  
int calcoloStopLoss()
{
int a=0;
if(TypeSl_==0){a=0;return a;}
if(TypeSl_==1){a=SlPoints;return a;}
return a;
}
int calcoloTakeProf()
{
int TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1)TP=TpPoints;
return TP;
}
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(BeStartPoints, BeStepPoints, magicNumber, Commen);
return BreakEv;
}
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