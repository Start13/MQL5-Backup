//+------------------------------------------------------------------+
//|                                         Domanda Offerta v1.0.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
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
input string                 Commen                          = "";       //Comment
input int                    Deviazione                      = 3;          //Slippage 

input string   comment_Supply_Demand = "--- Supply & Demand ---";// "--- Supply & Demand ---"
input bool                 filtroDom_Offerta = true;           // Filtro Zone Domanda Offerta
//input bool                 domOffInChart     = true;           // Domanda & Offerta visibile
input int                  distSupp_Dem  = 1000;               // Distanza Points da zone S&D per Ordini
 
input ENUM_TIMEFRAMES      Timeframe = PERIOD_CURRENT;         // Timeframe
input int                  BackLimit = 1000;                   // Back Limit
input bool                 HistoryMode = false;                // History Mode (with double click)

input string               zone_settings = "--- Zone Settings ---";
input bool                 zone_show_weak = false;             // Show Weak Zones
input bool                 zone_show_untested = true;          // Show Untested Zones
input bool                 zone_show_turncoat = true;          // Show Broken Zones
input double               zone_fuzzfactor = 0.75;             // Zone ATR Factor
input bool                 zone_merge = true;                  // Zone Merge
input bool                 zone_extend = true;                 // Zone Extend
input double               fractal_fast_factor = 3.0;          // Fractal Fast Factor
input double               fractal_slow_factor = 6.0;          // Fractal slow Factor              

input string               alert_settings= "--- Alert Settings ---";
input bool                 zone_show_alerts  = false;        // Trigger alert when entering a zone
input bool                 zone_alert_popups = true;         // Show alert window
input bool                 zone_alert_sounds = true;         // Play alert sound
input bool                 zone_send_notification = false;   // Send notification when entering a zone
input int                  zone_alert_waitseconds = 300;     // Delay between alerts (seconds)

input string               drawing_settings = "--- Drawing Settings ---";
input string               string_prefix = "SRRR";             // Change prefix to add multiple indicators to chart
input bool                 zone_solid = true;                  // Fill zone with color
input int                  zone_linewidth = 1;                 // Zone border width
input ENUM_LINE_STYLE      zone_style = STYLE_SOLID;           // Zone border style
input bool                 zone_show_info = true;              // Show info labels
input int                  zone_label_shift = 10;              // Info label shift
input string               sup_name = "Sup";                   // Support Name
input string               res_name = "Res";                   // Resistance Name
input string               test_name = "Retests";              // Retest Name
input int                  Text_size = 8;                      // Text Size
input string               Text_font = "Courier New";          // Text Font
input color                Text_color = clrAquamarine;              // Text Color
input color color_support_weak     = clrDarkSlateGray;         // Color for weak support zone
input color color_support_untested = clrSeaGreen;              // Color for untested support zone
input color color_support_verified = clrGreen;                 // Color for verified support zone
input color color_support_proven   = clrLimeGreen;             // Color for proven support zone
input color color_support_turncoat = clrOliveDrab;             // Color for turncoat(broken) support zone
input color color_resist_weak      = clrIndigo;                // Color for weak resistance zone
input color color_resist_untested  = clrOrchid;                // Color for untested resistance zone
input color color_resist_verified  = clrCrimson;               // Color for verified resistance zone
input color color_resist_proven    = clrRed;                   // Color for proven resistance zone
input color color_resist_turncoat  = clrDarkOrange;            // Color for broken resistance zone


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
int handleDomOff = 0;
int lastZoneHiLo;
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
	handleDomOff = iCustom(symbol_,0,"Examples\\shved_supply_and_demand_v1.71",Timeframe,BackLimit,HistoryMode,zone_settings,
                        zone_show_weak,zone_show_untested,zone_show_turncoat,zone_fuzzfactor,zone_merge,zone_extend,fractal_fast_factor,fractal_slow_factor,
                        alert_settings,zone_show_alerts,zone_alert_popups,zone_alert_sounds,zone_send_notification,zone_alert_waitseconds,drawing_settings,
                        string_prefix,zone_solid,zone_linewidth,zone_style,zone_show_info,zone_label_shift,sup_name,res_name,test_name,Text_size,Text_font,Text_color); 
	 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
resetIndicators(); 
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
if(!IsMarketTradeOpen(symbol_)||IsMarketQuoteClosed(symbol_)) return;
   enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);     
  
   ASK=Ask(symbol_);
   BID=Bid(symbol_);
   Commento = spreadComment();
   Comment (Commento);
   semCand = semaforoCandela(0); 
   
   double levHH = DomOffCustom(handleDomOff,4,0,1);
   double levHL = DomOffCustom(handleDomOff,5,0,1);
   double levLH = DomOffCustom(handleDomOff,6,0,1);
   double levLL = DomOffCustom(handleDomOff,7,0,1);
   
   

   Indicators();

   CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);
   gestioneBreakEven();
   gestioneTrailStop();
//if(semCand)
   gestioneOrdini(levHH,levHL,levLH,levLL);
   bool enableBuy=0,enableSell=0;
   double sogliaBuy=0,sogliaSell=0;

  }
 

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini(double levHH,double levHL,double levLH,double levLL)
{
if(!enableTrading)return;

maxOrd_BuySellBuy(numMaxOrdini,tipoOrdini,magicNumber,Commen);
maxOrd_BuySellSell(numMaxOrdini,tipoOrdini,magicNumber,Commen);

enableSupply_Demand(lastZoneHiLo);

//SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf(),Commen,magicNumber);
//SendTradeSellInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf(),Commen,magicNumber);
//direzioneCandUno(bool a,string BuySell) 
}
bool prezzoinfascia(double levHH,double levHL,double levLH,double levLL)
{
return (levHH==levLH && levHL==levLL);
}
bool dativalidi(double levHH,double levHL,double levLH,double levLL)
{
return (levHH!=0 && levHL!=0 && levLH!=0 && levLL!=0);
}
bool fasciasparita(double levHH,double levHL,double levLH,double levLL)
{
bool a = true;
if(!dativalidi( levHH, levHL, levLH, levLL)){a=false;return a;}
static double levHHmem = levHH;
static double levHLmem = levHL;
static double levLHmem = levLH;
static double levLLmem = levLL;


return a;
}


bool enableSupply_Demand(int &memo_)
{
bool a = true;
int static memo = 0;

if(!filtroDom_Offerta) return a;
double dist = distSupp_Dem * Point();
double levHH = DomOffCustom(handleDomOff,4,0,1);
double levHL = DomOffCustom(handleDomOff,5,0,1);
double levLH = DomOffCustom(handleDomOff,6,0,1);
double levLL = DomOffCustom(handleDomOff,7,0,1);
Print(" levHH ",levHH," levHL ",levHL);
Print(" levLH ",levLH," levLL ",levLL);
if(!levHH || !levHL || !levLH || !levLL) 
{Print("NO DATA Indicator Supply & Demand");return a;}

if(levHH==levLH && levHL==levLL) Print(" Prezzo nella fascia");else Print(" Prezzo fuori fascia");

//Print(" Lev Sup: ",levHL - dist," Compreso High: ",doubleCompreso(Ask_,levHH + dist,levHL - dist)," Compreso Low: ",doubleCompreso(Bid_,levLH + dist,levLL - dist));
if(doubleCompreso(ASK,levHH + dist,levHL - dist)) {a = false; memo = 1;return a;} // prezzo tocca la fascia resistenza superiore
//if(C1 > levHH)memo = -1;

if(doubleCompreso(BID,levLH + dist,levLL - dist)) {a = false; memo = -1;} // prezzo tocca la fascia supporto inferiore

memo_ = memo; return a;
}

bool lastDomOffertaBuy()
{
bool a = true;
if(!filtroDom_Offerta) return a;
if(semCand)
{
double lev1 = DomOffCustom(handleDomOff,4,0,1);
double lev2 = DomOffCustom(handleDomOff,5,0,1);
if(!lev1 || !lev2) return a;
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
int barre = iBars(symbol_,PERIOD_CURRENT);
static int barreOrdDisable = 0;
double valSup = valoreSuperiore(lev1,lev2);
double valInf = valoreInferiore(lev1,lev2);

if(!enableSupply_Demand(lastZoneHiLo)) barreOrdDisable = barre;
if(barre > barreOrdDisable && C1 < valInf) a = false;
}
return a;
} 

bool lastDomOffertaSell()
{
bool a = true;
if(!filtroDom_Offerta) return a;
if(semCand)
{
double lev1 = DomOffCustom(handleDomOff,4,0,1);
double lev2 = DomOffCustom(handleDomOff,5,0,1);
if(!lev1 || !lev2) return a;
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
int barre = iBars(symbol_,PERIOD_CURRENT);
static int barreOrdDisable = 0;
double valSup = valoreSuperiore(lev1,lev2);
double valInf = valoreInferiore(lev1,lev2);

if(!enableSupply_Demand(lastZoneHiLo)) barreOrdDisable = barre;
if(barre > barreOrdDisable && C1 > valSup) a = false;
}
return a;
} 
//+------------------------------------------------------------------+
//|                      DomOffCustom()                              |
//+------------------------------------------------------------------+
double DomOffCustom(int handle,int buff,int index1,int quantita)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,buff,index1,quantita,val_Indicator) > 0){
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
void Indicators()
  {
   char index=0;
     {
      //ChartIndicatorAdd(0,0,handle1);  

      //ChartIndicatorAdd(0,0,handle2);

      //ChartIndicatorAdd(0,0,handle3);
      
      //ChartIndicatorAdd(0,0,handleDomOff);

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