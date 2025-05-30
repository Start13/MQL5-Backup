//+------------------------------------------------------------------+
//|                                                 Struttura EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version     "1.00"
#property strict
#property indicator_separate_window
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

enum TypeCandle
  {
   Stesso           = 0,  //Trailing Stop sul min/max della candela "index"
   Una              = 1,  //Trailing Stop sul min/max del corpo della candela "index"
   Due              = 2,  //Trailing Stop sul max/min del corpo della candela "index"
   Tre              = 3,  //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE                     = 0,  //No Breakeven
   BEPoints                  = 1,  //Breakeven Points
   PercOpenTP                = 2,  //Breakeven Percentuale OpenPrice/Take Profit
  };    
enum TStop
  {
   No_TS                     = 0,  //No Trailing Stop
   Pointstop                 = 1,  //Trailing Stop in Points
   TSPointTradiz             = 2,  //Trailing Stop in Points Traditional
   TsTopBotCandle            = 3,  //Trailing Stop Previous Candle
   PercOpenTP                = 4,  //Trailing Stop Percentuale OpenPrice/Take Profit
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
enum Filter_ATR_ 
  {
   Flat                   = 0,  //Flat
   Sotto                  = 1,  //Abilita Ordini Sopra il livello impostato
   Sopra                  = 2,  //Abilita Ordini Sotto il livello impostato
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
input string                 Commen                          = "";       //Comment
input int                    Deviazione                      = 3;          //Slippage 

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

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      BeStartPoints            = 2500;              //Be Start in Points
input int      BeStepPoints             =  200;              //Be Step in Points
input double   BePercStart              = 61.8;              //Be % Start
input double   BePercStep               = 32.8;              //Be % Step

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points
input double   TsPercStart              = 61.8;              //Ts % Start
input double   TsPercStep               = 32.8;              //Ts % Step

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

double capitaleBasePerCompounding = AccountBalance();
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
	
	 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
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
Commento = spreadComment()+"\n"+swaplongshortComment();
Comment (Commento);
semCand = semaforoCandela(0); 

CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);
gestioneBreakEven(BreakEven,BeStartPoints,BeStepPoints,BePercStart,BePercStep,magicNumber,Commen);
gestioneTrailStop(TrailingStop,TsStart,TsStep,TsPercStart,TsPercStep,TipoTSCandele,indexCandle_,TFCandle,symbol_,magicNumber,Commen); 
/*
input TypeCandle TipoTSCandele          =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom*/ 
//int TrailingStop_,int TsStart_,int TsStep_,double TsPercStart_,double TsPercStep_,int TipoDiCandela,int indexCandela,ENUM_TIMEFRAMES TFCandela,string symb,ulong mag,string Comm
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



   {distanzaSL = NormalizeDouble((Ask(Symbol())-calcoloStopLoss())/Point(),Digits());
   SendTradeBuyInPoint(symbol_,myLotSize(),Deviazione,calcoloStopLoss(),calcoloTakeProf(),Commen,magicNumber);}
   {distanzaSL = NormalizeDouble((calcoloStopLoss()-Bid(Symbol()))/Point(),Digits());
   SendTradeSellInPoint(symbol_,myLotSize(),Deviazione,calcoloStopLoss(),calcoloTakeProf(),Commen,magicNumber);}
//direzioneCandUno(bool a,string BuySell) 
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
/*
//------------------------------ gestioneBreakEven()--------------------------------------------- 
double gestioneBreakEven(int BreakEven_,int BeStartPoints_,int BeStepPoints_,double BePercStart_,double BePercStep_,ulong magicNumber_,string Commen_)
{
double BreakEv=0;
if(BreakEven_==0)return BreakEv;
if(BreakEven_==1)BrEven(BeStartPoints_, BeStepPoints_, magicNumber_, Commen_);
if(BreakEven_==2)BePerc(BePercStart_,BePercStep_,magicNumber_,Commen_);
return BreakEv;
}
*/
/*
//------------------------------ gestioneTrailStop()--------------------------------------------- 
double gestioneTrailStop(int TrailingStop_,int TsStart_,int TsStep_,double TsPercStart_,double TsPercStep_,int TipoDiCandela,int indexCandela,ENUM_TIMEFRAMES TFCandela,string symb,ulong mag,string Comm)
{
double TS=0;
if(TrailingStop_==0)return TS;
if(TrailingStop_==1)TsPoints(TsStart_, TsStep_, mag, Comm);
if(TrailingStop_==2)PositionsTrailingStopInStep(TsStart_,TsStep_,symb,mag,0);///PositionTrailingStopInStep
//if(TrailingStop_==2){PositionTrailingStopInStep(TicketPrimoOrdineBuy(magic_number),TsStart,TsStep);PositionTrailingStopInStep(TicketPrimoOrdineSell(magic_number),TsStart,TsStep);}
if(TrailingStop_==3)TrailStopCandle_(TipoDiCandela,indexCandela,TFCandela,magicNumber,Commen);
if(TrailingStop_==4)TrailStopPerc(TsPercStart_,TsPercStep_,mag,Comm);
return TS;
}
*/
/*
//+------------------------------------------------------------------+
//|                       TrailStopCandle()                          |
//+------------------------------------------------------------------+
double TrailStopCandle_(int TipoTSCandele_,int indexCandle,ENUM_TIMEFRAMES TFCandle_,ulong mag,string Comm)
  {
  double TsCandle=0;
   if(TicketPrimoOrdineBuy(mag,Comm))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(mag,Comm),TipoTSCandele_,indexCandle,TFCandle_,0.0);
   if(TicketPrimoOrdineSell(mag,Comm))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(mag,Comm),TipoTSCandele_,indexCandle,TFCandle_,0.0);
  return TsCandle;}  */