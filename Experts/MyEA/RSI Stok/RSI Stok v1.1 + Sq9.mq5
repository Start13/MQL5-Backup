//+------------------------------------------------------------------+
//|                                          RSI Stok v1.1 + Sq9.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+


#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.10"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor....."
string versione = "v1.10";

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


enum input_ruota_
  {
   Ventiquattro      = 0,        //Advanced Formula Levels by Pivot Set
   Da_Square_of_NIne = 1,        //Levels Square of 9 by Pivot Set
  };

enum gradi_ciclo
  {
   Ciclosetteventi   = -1,       //Cycle 720°
   Ciclo_intero      = 0,        //Cycle 360°
   Ciclo_diciotto    = 1,        //Cycle 270°
   Ciclo_dodici      = 2,        //Cycle 180°
   Ciclo_sei         = 3,        //Cycle  90°
   Ciclo_tre         = 4,        //Cycle  45°
   Ciclo_un_terzo    = 5         //Cycle  33°
  };

enum PeriodoPrecRuota
  {
   Daily             = 0,            //Day After
   Weekly            = 1,            //Week After
   Mounthly          = 2,            //Mounth After
   //SixMounthly       = 3,            //6 Mounths After
  };
enum PriceTypeW
  {
   No                = 0,        // No
   PivotWHL_2        = 1,        // Pivot W HL:2
   PivotWHLC_3       = 2         // Pivot W HL:3
  };
enum PriceTypeD
  {
   No                = 0,        // No
   PivotDHL_2        = 2,        // Pivot D HL:2
   PivotDHLC_3       = 3         // Pivot D HL:3
  };
enum PivD_SR_Sqnine
  {
   Niente             = 0,        //Not displayed
   Pivot_Daily        = 1,        //Pivot Daily
   Res_Supp_Sq_nine   = 2         //Square of 9 Resistences and Supports
  };
//------------- Zig Zag ---------------------------
enum periodoRicercaCand
  {
   giorno                = 0,
   Week                  = 1,
   Mese                  = 2,
   SeiMesi               = 3,
   Anno                  = 4,
  };
enum AlertType       //Alarms
  {
   NoAlert           = 0,
   PlaySoundAlert    = 1,
   ShowAlertMessage  = 2,
   SendMobileMessage = 3,
   SendEmail         = 4
  };

enum LineType       //Type of lines
  {
   Solid      = 0,
   Dash       = 1,
   Dot        = 2,
   DashDot    = 3,
   DashDotDot = 4
  };

enum LineWidth       //Lines
  {
   VeryThin   = 1,
   Thin       = 2,
   Normal     = 3,
   Thick      = 4,
   VeryThick  = 5
  };

enum Alerts
  {
   R5  = 0,
   R4  = 1,
   R3  = 2,
   R2  = 3,
   R1  = 4,
   S1  = 5,
   S2  = 6,
   S3  = 7,
   S4  = 8,
   S5  = 9,
   compraSopra = 10,
   vendiSotto  = 11,
   Pivot       = 12
  };


enum PriceType
  {
   PreviousDayOpen  = 0,        //Prezzo ingresso Sq 9: apertura giorno precedente
   PreviousDayLow   = 1,        //Prezzo ingresso Sq 9: Low giorno precedente
   PreviousDayHigh  = 2,        //Prezzo ingresso Sq 9: High giorno precedente
   PreviousDayClose = 3,        //Prezzo ingresso Sq 9: chiusura giorno precedente
   PivotDailyHL     = 4,        //Prezzo ingresso Sq 9: Pivot Daily
   PivotWeek        = 5,        //Prezzo ingresso Sq 9: Pivot Weekly
   Custom           = 6,        //Prezzo ingresso Sq 9: prezzo Custom
   HiLoZigZag       = 7,        //Ultimo picco Shadow Zig Zag indicator
   HigLowZigZag     = 8,        //Ultimo picco Body Zig Zag indicator
   LastHLDayPrima   = 9,        //Ultimo Top o Bottom del giorno precedente
   LastBodyDayPrima =10,        //Ultimo Body del giorno precedente
  };

enum GannInput
  {
   due_Cifre              = 2,            //Digits: 2
   tre_Cifre              = 3,            //Digits: 3
   quattro_Cifre          = 4,            //Digits: 4
   cinque_Cifre           = 5,            //Digits: 5
   sei_Cifre              = 6,            //Digits: 6
   sette_Cifre            = 7             //Digits: 7
  };
enum Divisione
  {
   un_Decimillesimo = -4,                       //Multiply: 10.000
   Un_Millesimo     = -3,                       //Multiply: 1.000
   Un_Centesimo     = -2,                       //Multiply: 100
   Un_Decimo        = -1,                       //Multiply: 10
   Uno              =  0,                       //1 / 1
   Dieci            =  1,                       //Divided: 10
   Cento            =  2,                       //Divided: 100
   Mille            =  3,                       //Divided: 1.000
   Diecimila        =  4,                       //Divided: 10.000
   Centomila        =  5                        //Divided: 100.000
  };
enum filtroPivot
  {
   NoPivot               = 0, //No Filtro Pivot
   PivotD                = 1, //Filtro Daily
   PivotW                = 2, //Filtro Weekly
  };
enum TypePivot
  {
   PivotDHL_2            = 2, // Pivot HL:2
   PivotDHLC_3           = 3  // Pivot HL:3
  };

enum Grid_Hedge
  {
   NoGrid_NoHedge        = 0, //No Griglia / No Hedging
   Grid_                 = 1, //Griglia
   Hedge                 = 2, //Hedging
  };
enum TipoMultipliGriglia
  {
   Fix                   = 0,
   Progressive           = 1,
  };
enum nMaxPos
  {
   Una_posizione         = 1,  //Max 1 Ordine
   Due_posizioni         = 2,  //Max 2 Ordini
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
   Buy_Sell         = 0,                       //Orders Buy e Sell
   Buy              = 1,                       //Only Buy Orders
   Sell             = 2                        //Only Sell Orders
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
enum crossStok
  {
   NO                             = 0,    //No     
   free                           = 1,    //Si
   Level                          = 2,    //Solo oltre i livelli
  };  
enum zzbodsha
  {
   No                             =-1,    //No
   Picco                          = 0,    //Picco     
   Body                           = 1,    //Body
   Shadow                         = 2,    //Shadow
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
input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput              gannInputDigit   = 4;         //Number of price digits used: Calibration
input Divisione              DIVIS            = 0;         //Multiplication / Division of digits: Calibration

input PriceType              gannInputType    = 6;         //Type of Input in Calculation
 string                      gannCustomPrice  = "";
 PivD_SR_Sqnine              PivotDaily       = 0;         //Sul grafico: Pivot Daily or Resistances/Supports Sq 9

input PriceTypeW             TypePivW         = 2;         //Pivot Weekly Type 
input PriceTypeD             PriceTypeD_      = 3;         //Pivot Daily Type 
 input_ruota_                input_ruota      = 1;         //Advanced Formula Levels / Levels Square of 9
 PeriodoPrecRuota            PeriodoPrecRuota_= 1;         //Period after for Route 24
 gradi_ciclo                 gradi_Ciclo                     = 0;         //Advanced Formula Angles: 360°/270°/180°/90°  
input string       comment_IC =        "--- SETTINGS CHART ---";   // --- SETTINGS CHART ---
input bool VisibiliInChart                    = true;
input bool         shortLines                 = true;
input bool         showLineName               = true;
      AlertType    alert1                     = 0;
      AlertType    alert2                     = 0;

      int          pipDeviation               = 0;         //Sensibility for alert
input string       CommentStyle               = "--- Style Settings ---";
input bool         drawBackground             = true;
input bool         disableSelection           = true;
input color        resistanceColor            = clrRed;
input LineType     resistanceType             = 2;
input LineWidth    resistanceWidth            = 1;
input color        supportColor               = clrLime;
input LineType     supportType                = 2;
input LineWidth    supportWidth               = 1;
      string       ButtonStyle                = "--- Toggle Style Settings ---";
      bool         buttonEnable               = false;
//input bool         buttonEnable               = false;
 int          xDistance_                 = 250;
 int          yDistance_                 = 5;
 int          width                      = 100;
 int          hight                      = 30;
 string       label                      = " ";

input string       comment_ZZG                = "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input int          InpDepthG                  = 12;             // ZigZag: Depth
input int          InpDeviationG              =  5;             // ZigZag: Deviation
input int          InpBackstepG               =  3;             // ZigZag: Backstep
input int          InpCandlesCheckG           = 50;             // ZigZag: how many candles to check back
input char         MinCandZZG                 =  3;             //Min candle distance
input ENUM_TIMEFRAMES periodZigzagG           = PERIOD_CURRENT; //Timeframe
input periodoRicercaCand periodoRicNumCandG   = 0;              //Picchi zigzag nel periodo prima di 1 giorno/1 settimana/1 mese/6 mesi/1 anno
input ENUM_TIMEFRAMES TfPeridoRicCandG           ;



input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
//input bool                   StopNewsOrders                  = false;      //Ferma l'EA quando terminano gli Ordini
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =  100;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
//input char                   maxDDPerc                       =   0;        //Max DD% (0 Disable)
//input int                    MaxSpread                       =   0;        //Max Spread (0 = Disable)
input Type_Orders            Type_Orders_                    =   0;        //Tipo di Ordini


input nMaxPos                N_Max_pos                       =   2;        //Massimo numero di Ordini contemporaneamente
//input int                    N_max_orders                    = 50;       //Massimo numero di Ordini nella giornata
input ulong                  magic_number                    = 9999;       //Magic Number
input string                 Commen                          = "RSIStok v1.1";       //Comment
input int                    Deviazione                      = 0;          //Slippage 

input string   comment_RSIStoK =           "--- RSIStok ---"; // --- RSIStok ---
input bool StopOrdLineaOpposta              = false;      //Chiude Ordine quando K (o D) raggiunge linea opposta
input crossStok crossStok_                  = 0;          //Chiudi Ordine con incrocio K/D: No / Si / Solo oltre i Livelli
input ENUM_TIMEFRAMES InpTF                 = PERIOD_CURRENT;
input int InpKPeriod                        = 5;          //K period
input int InpDPeriod                        = 3;          //D period 
input int InpSlowing                        = 3;          //Slowing
input ENUM_MA_METHOD InpMetod               = MODE_EMA;   //Metodo 
input ENUM_STO_PRICE InpCalcMetod           = STO_LOWHIGH;//Metodo prezzo
input double LivSuperiore                   = 80;         //Livello Superiore
input double LivInferiore                   = 20;         //Livello Inferiore 

input string   comment_ZigZag =           "--- ZigZag ---"; // --- ZigZag ---
input zzbodsha bodyshadowZZ   =  0;     // Soglia candela ZigZag: Picco/Body/Shadow
 bool     candelaZero    = false;  // Legge candela zero (0)
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InpBackstep    =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: numero candele analizzate
input int      MinCandZZ      =  3;     // Minimo di candele per approvare il valore dell'ultimo ZigZag
input ENUM_TIMEFRAMES TimeframeZZ = PERIOD_CURRENT;

input string   comment_SL =           "--- STOP LOSS ---"; // --- STOP LOSS ---
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
input int      TpPoints                 = 1000;              //Take Profit Points

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

input string   comment_MM   =          "--- MONEY MANAGEMENT ---";        // --- MONEY MANAGEMENT ---
 bool     EnableAllocazione   =   false;                   //Abilita/disabilita l'allocazione di capitale
input double   capitalToAllocateEA =  		 0;									  // Capitale da allocare per l'EA (0 = intero capitale)
input bool     compounding  =           true;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100]
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot

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

ulong magicNumber       =  magic_number;   // Magic Number

double capitalToAllocate =            0;
bool    autoTradingOnOff = 	     true;

double capitaleBasePerCompounding = AccountBalance();
double distanzaSL = 0;

double ASK = 0;
double BID = 0;

string symbol_ = Symbol();

bool semCand = false;

int spread;
string Commento = "";
bool enableTrading = true;

datetime OraNews;

int handle_iCustom;// Variabile Globale
int handleATR;
int handleRSIStok;
int handleiZZ;

string aaa= "0"; 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
      resetIndicators();
	Allocazione_Init();  
	handleRSIStok=iStochastic(symbol_,InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod); 
   handleiZZ = iCustom(Symbol(),TimeframeZZ,"Examples\\ZigZag",InpDepth,InpDeviation,InpBackstep);
  /* handle_iCustom=
   iCustom(symbol_,0,"Gann Sq 9 Indicator\\Gann_Pivots_3EA",comment_CS9,gannInputDigit,DIVIS,gannInputType,gannCustomPrice,PivotDaily,TypePivW,PriceTypeD_,input_ruota,
	        PeriodoPrecRuota_,gradi_Ciclo,comment_IC,VisibiliInChart,shortLines,showLineName,alert1,alert2,pipDeviation,CommentStyle,drawBackground,disableSelection,
	        resistanceColor,resistanceType,resistanceWidth,supportColor,supportType,supportWidth,ButtonStyle,buttonEnable,xDistance_,yDistance_,width,hight,label,
	        comment_ZZG,InpDepthG,InpDeviationG,InpBackstepG,InpCandlesCheckG,MinCandZZG,periodZigzagG
	        ); */


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
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Libra from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);     
  

ASK=Ask(symbol_);
BID=Bid(symbol_);
spread = (int)((ASK - BID)/Point());
Commento = "Spead "+ (string)spread;
Comment (Commento);
semCand = semaforoCandela(0); 
//Print(" gannInputTypeEA ",gannInputType); 
   gannCustomPrice=DoubleToString(ASK);
   //handle_iCustom=
   iCustom(symbol_,0,"Gann Sq 9 Indicator\\Gann_Pivots_3EA",comment_CS9,gannInputDigit,DIVIS,gannInputType,gannCustomPrice,PivotDaily,TypePivW,PriceTypeD_,input_ruota,
	        PeriodoPrecRuota_,gradi_Ciclo,comment_IC,VisibiliInChart,shortLines,showLineName,alert1,alert2,pipDeviation,CommentStyle,drawBackground,disableSelection,
	        resistanceColor,resistanceType,resistanceWidth,supportColor,supportType,supportWidth,ButtonStyle,buttonEnable,xDistance_,yDistance_,width,hight,label,
	        comment_ZZG,InpDepthG,InpDeviationG,InpBackstepG,InpCandlesCheckG,MinCandZZG,periodZigzagG
	        ); 



Indicators();

ChiudiOrdDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,symbol_,magic_number,Commen);
gestioneCloseOrdLineaOpposta();
gestioneCloseOrdIncrocio();
gestioneCloseOrdIncrLiv();
gestioneBreakEven();
gestioneTrailStop();
//if(semCand)
gestioneOrdini();

  }

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
if(NumOrdini(magic_number,Commen)>=N_Max_pos)return;
// Rossa D      Blu K 
 double Rsi_K1 = 0;
 double Rsi_K2 = 0;
 double Rsi_D1 = 0;
 double Rsi_D2 = 0;
 
 /*
 ////////
double arrSq9livelli[];ArraySetAsSeries(arrSq9livelli,true);
Buffer(handle_iCustom,1,0,10,arrSq9livelli);
for(int i=0;i<ArraySize(arrSq9livelli);i++)
{
Print(" Level Sq9 ",i," ",arrSq9livelli[i]);
}*/
/////////
RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,1,Rsi_K1,Rsi_D1);
RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,2,Rsi_K2,Rsi_D2);

//Print(" NumOrdBuy(magic_number,Commen)==0: ",NumOrdBuy(magic_number,Commen)==0," NumOrdSell(magic_number,Commen)==0: ",NumOrdSell(magic_number,Commen)==0);
/*
Print(" K1: ",Rsi_K1," D1: ",Rsi_D1,
   " Rsi_K2<Rsi_D2 && Rsi_K1>Rsi_D1: ",Rsi_K2<Rsi_D2 && Rsi_K1>Rsi_D1," Rsi_K1<LivInferiore && Rsi_D1<LivInferiore: ",Rsi_K1<LivInferiore && Rsi_D1<LivInferiore);
Print(" K2: ",Rsi_K2," D2: ",Rsi_D2,
   " Rsi_K2>Rsi_D2 && Rsi_K1<Rsi_D1: ",Rsi_K2>Rsi_D2 && Rsi_K1<Rsi_D1," Rsi_K1>LivSuperiore && Rsi_D1>LivSuperiore: ",Rsi_K1>LivSuperiore && Rsi_D1>LivSuperiore);
*/

//Print(" Buy ",zigzagBodyShadow("Buy",bodyshadowZZ,candelaZero,symbol_,InpDepth, InpDeviation, InpBackstep, InpCandlesCheck, MinCandZZ, TimeframeZZ),
//      " Sell ",zigzagBodyShadow("Sell",bodyshadowZZ,candelaZero,symbol_,InpDepth, InpDeviation, InpBackstep, InpCandlesCheck, MinCandZZ, TimeframeZZ));
if(                   maxOrd_BuySellBuy(N_Max_pos,Type_Orders_,magicNumber,Commen)
                   && Rsi_K2<Rsi_D2 && Rsi_K1>Rsi_D1 
                   //&& Rsi_K1<LivInferiore && Rsi_D1<LivInferiore 
                   && Rsi_D2<LivInferiore && Rsi_K2<LivInferiore
                   && zigzagBodyShadow("Buy",bodyshadowZZ,candelaZero,symbol_,InpDepth, InpDeviation, InpBackstep, InpCandlesCheck, MinCandZZ, TimeframeZZ)) 
                     {SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,Sl_n_pips,TpPoints,Commen,magic_number);}

if(                   maxOrd_BuySellSell(N_Max_pos,Type_Orders_,magicNumber,Commen)
                   && Rsi_K2>Rsi_D2 && Rsi_K1<Rsi_D1 
                   //&& Rsi_K1>LivSuperiore && Rsi_D1>LivSuperiore 
                   && Rsi_D2>LivSuperiore && Rsi_K2>LivSuperiore
                   && zigzagBodyShadow("Sell",bodyshadowZZ,candelaZero,symbol_,InpDepth, InpDeviation, InpBackstep, InpCandlesCheck, MinCandZZ, TimeframeZZ)) 
                     {SendTradeSellInPoint(symbol_,lotsEA,Deviazione,Sl_n_pips,TpPoints,Commen,magic_number);}
//handleStok=iStochastic(symbol_,periodstok,Kperiod,Dperiod,SlowDown_,stokmethod,InpCalcMetod);
}
//+------------------------------------------------------------------+
//|                            Buffer()                              |
//+------------------------------------------------------------------+
double Buffer(int handle,int buff,int index1,int quantita,double &arrSq9livelli[])
{
   bool a = false;
   if(handle > INVALID_HANDLE){
      ArrayInitialize(arrSq9livelli,0);
		if(CopyBuffer(handle,buff,index1,quantita,arrSq9livelli) > 0){
			if(ArraySize(arrSq9livelli) > 0){
				a=true;return a;
			}
		}
	}
	return -1;
} 	 
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void gestioneCloseOrdLineaOpposta()// StopOrdLineaOpposta
{
double RsiStokK = 0;
double RsiStokD = 0;

RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,0,RsiStokK,RsiStokD);

if(StopOrdLineaOpposta && NumOrdBuy(magic_number,Commen)>0  && (RsiStokK>=LivSuperiore||RsiStokD>=LivSuperiore)) brutalCloseBuyTrades(symbol_,magic_number);
if(StopOrdLineaOpposta && NumOrdSell(magic_number,Commen)>0 && (RsiStokK<=LivInferiore||RsiStokD<=LivInferiore)) brutalCloseSellTrades(symbol_,magic_number);
}

//+------------------------------------------------------------------+
void gestioneCloseOrdIncrocio()
{
if(crossStok_ != 1 || NumOrdini(magic_number,Commen)==0)return;
 double Rsi_K1 = 0;
 double Rsi_K2 = 0;
 double Rsi_D1 = 0;
 double Rsi_D2 = 0;

RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,1,Rsi_K1,Rsi_D1);
RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,2,Rsi_K2,Rsi_D2);

if(NumOrdBuy(magic_number,Commen)>0 && Rsi_K2>Rsi_D2 && Rsi_K1<Rsi_D1) brutalCloseBuyTrades(symbol_,magic_number);
if(NumOrdSell(magic_number,Commen)>0 && Rsi_K2<Rsi_D2 && Rsi_K1>Rsi_D1) brutalCloseSellTrades(symbol_,magic_number);
}
//+------------------------------------------------------------------+
void gestioneCloseOrdIncrLiv()//StopOrdIncroLiv
{
if(crossStok_ != 2 || NumOrdini(magic_number,Commen)==0)return;
 double Rsi_K1 = 0;
 double Rsi_K2 = 0;
 double Rsi_D1 = 0;
 double Rsi_D2 = 0;

RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,1,Rsi_K1,Rsi_D1);
RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,2,Rsi_K2,Rsi_D2);

if(NumOrdBuy(magic_number,Commen)>0 && Rsi_K2>Rsi_D2 && Rsi_K1<Rsi_D1 && Rsi_K2>LivSuperiore && Rsi_D2>LivSuperiore) brutalCloseBuyTrades(symbol_,magic_number);
if(NumOrdSell(magic_number,Commen)>0 && Rsi_K2<Rsi_D2 && Rsi_K1>Rsi_D1 && Rsi_K2<LivInferiore && Rsi_D2<LivInferiore) brutalCloseSellTrades(symbol_,magic_number);
}
//-------------------------------------- RSI ()---------------------------------------------

void RSIStokCustom(int index,double &K,double &D)
  {
   RSIStochastic(InpTF,InpKPeriod,InpDPeriod,InpSlowing,InpMetod,InpCalcMetod,index,K,D);
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
//|                          Indicators()                            |
//+------------------------------------------------------------------+
void Indicators()
  {

        ChartIndicatorAdd(0,1,handleRSIStok);
        ChartIndicatorAdd(0,0,handleiZZ);
     }

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
  
/*
input int      Inp_RSI_Period       = 14;             // Period
input color    Inp_RSI_Color        = clrDodgerBlue;  // Color line
input int      Inp_RSI_Width        = 1;              // Width
input int      Inp_RSI_Level1       = 30.0;           // Value Level #1
input double   Inp_RSI_Level2       = 70.0;           // Value Level #2
*/ 

/*
//+------------------------------------------------------------------+Restituisce true quando BuySell == Buy, bodyshadow == 0, ultimo picco supera in barre MinCand e l'ultimo picco è basso
//|                           zigzagvalido()                         |Restituisce true quando BuySell == Buy, bodyshadow == 1, ultimo picco supera in barre MinCand, l'ultimo picco è basso e prezzo è superiore al body
//+------------------------------------------------------------------+Restituisce true quando BuySell == Buy, bodyshadow == 2, ultimo picco supera in barre MinCand, l'ultimo picco è basso e prezzo è superiore alla shadow

bool zigzagvalido(bool filtroOnOff,string BuySell,int bodyshadow,string symbol,int Depth,int Deviation,int Backstep,int candleCheck,int MinCand,ENUM_TIMEFRAMES timeframeZZ) //Testare per Include
  {
   bool a = false;
   if(!filtroOnOff) {a=true;return a;}
   double valorezz=0; 
   int indexZZ=0;
   int handleiCustom = iCustom(Symbol(),timeframeZZ,"Examples\\ZigZag",Depth,Deviation,Backstep);
   if(handleiCustom>INVALID_HANDLE)
     {
      double datiZZ[];        
      ArraySetAsSeries(datiZZ,true);
      ArrayInitialize(datiZZ,0);

      if(CopyBuffer(handleiCustom,0,0,candleCheck,datiZZ)>0) 
      {for(int i=0;i<ArraySize(datiZZ);i++) {if(datiZZ[i]!=0 && i>=MinCand){valorezz=datiZZ[i];indexZZ=i; break;}}}}

   double open  = iOpen(symbol,timeframeZZ,indexZZ);
   double close = iClose(symbol,timeframeZZ,indexZZ); 
      
      if(BuySell=="Buy" && (valorezz < open || valorezz < close))
         {Print(" ASK ",Ask(symbol_)," iHigh(symbol,timeframeZZ,indexZZ) ",iHigh(symbol,timeframeZZ,indexZZ));
          if(bodyshadow==0 && Ask(symbol_) >= valorezz) {a=true;return a;}
          if(bodyshadow==1 && Ask(symbol_) >= valoreSuperiore(open,close)) {a=true;return a;}
          if(bodyshadow==2 && Ask(symbol_) >= iHigh(symbol,timeframeZZ,indexZZ)) {a=true;return a;}
         }
      
      if(BuySell=="Sell" && (valorezz > open || valorezz > close))
         {
          if(bodyshadow==0 && Bid(symbol_) <= valorezz) {a=true;return a;}
          if(bodyshadow==1 && Bid(symbol_) <= valoreInferiore(open,close)) {a=true;return a;}
          if(bodyshadow==2 && Bid(symbol_) <= iLow(symbol,timeframeZZ,indexZZ)) {a=true;return a;}
         }
   return a;
   }*/ 
