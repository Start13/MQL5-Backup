//+------------------------------------------------------------------+
//|                                                  Zigulì v1.0.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.0"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor is...."
string versione = "v1.0";

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

enum levImp 
  {
   impul                     = 0,  //Impulso
   level                     = 1,  //Livello
  }; 
enum nMaxPos
  {
   Una_posizione   = 1,  //Max 1 Ordine
   Due_posizioni   = 2,  //Max 2 Ordini
  };

enum Type_Orders
  {
   Buy_Sell         = 0,               //Orders Buy e Sell
   Buy              = 1,               //Only Buy Orders
   Sell             = 2                //Only Sell Orders
  };
enum TypeSl
  {
   No               = 0,           //No Stop Loss
   Points           = 1,           //Stop Loss Points
   ZZPrec           = 2,           //Stop Loss all'ultimo ZigZag
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
   TpMA                      = 2,  //Tp alla Media Mobile
   TPSogliaOoopsta           = 3,  //Tp alla Soglia opposta
  };
 
enum direzCand
  {
   //No                        = 0,  //Flat
   candN                     = 1,  //N° Candele congrue con l'Ordine
   candNeSuperamBody         = 2,  //N° Candele congrue e superam body cand preced
   candNeSuperamShadow       = 3,  //N° Candele congrue e superam shadow cand preced
  }; 
enum bodyShSw 
  {
   bodySwing             = 0,  //Body candela Swing Chart
   shadowSwing           = 1,  //Shadow candela Swing Chart
  }; 
/*   
enum bodyShBo 
  {
   bodyBreakOut          = 0,  //Body candela Break Out
   shadowBreakOut        = 1,  //Shadow candela Break Out
  };  
*/ 
 
input string   comment_OS     =        "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input int CloseOrdDopoNumCandDalPrimoOrdine_                 =   0;        //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
input Type_Orders            Type_Orders_                    =   0;        //Tipo di Ordini
input nMaxPos                N_Max_pos                       =   1;        //Massimo numero di Ordini contemporaneamente
input ulong                  magic_number                    = 4444;       //Magic Number
input string                 Commen                          = "Zigulì v1.0";       //Comment
input int                    Deviazione                      =   0;        //Slippage  

input string   comment_Strat   =       "--- STRATEGIE SETTINGS ---";   // --- STRATEGIE SETTINGS ---
//input bool     SwingChart      = false;  //Swing Chart
input levImp   levelImpuls     =     0;   //Impulso / Livello
input bodyShSw bodyShadowSw    =     0;   //Body / Shadow Swing Chart
input ENUM_TIMEFRAMES timeFrPicco  = PERIOD_CURRENT;  // Time frame candela di Picco Zig Zag
input direzCand  direzCand_    =     1;   //Permette Ordine Cand a favore: No/N°Cand/N°Cand+Body/N°Cand+Shadow
input int      numCandDirez    =     1;   //Numero Candele a favore. Minimo 1.
input ENUM_TIMEFRAMES timeFrCand =   PERIOD_CURRENT; //Time Frame Candele
input int      perclevlev      =    65;   //Ordini consentiti fino alla % tra soglie   
input double   inclinazmin     =  2900;   //Ordini consentiti dall'inclinazione ZigZag

input string   comment_ZZ =           "--- ZIG ZAG ---"; // --- ZIG ZAG ---                               
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InpBackstep    =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  =200;     // ZigZag: numero candele analizzate
input int      MinCandZZ      =  0;     // Minimo di candele per approvare il valore dell'ultimo ZigZag
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe

input string   comment_SL =           "--- STOP LOSS ---"; // --- STOP LOSS ---
input TypeSl   TypeSl_                  =     1;            //Stop Loss: No / Sl Points / Picco ZigZag Precedente
input int      SlPoints                 = 10000;            //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      BeStartPoints            = 2500;              //Be Start in Points
input int      BeStepPoints             =  200;              //Be Step in Points

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    1;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit: No/Points/MA/Body cand opposta/Shad cand opp
input int      TpPoints                 = 1000;              //Take Profit Points

input string   comment_MA =        "--- MA  SETTING ---";   // --- MA  SETTING ---
input int                  periodMAFast  = 30;              //Periodo MA 
input int                  shiftMAFast   =  0;              //Shift MA 
input ENUM_MA_METHOD       methodMAFast=MODE_EMA;           //Metodo MA 
input ENUM_APPLIED_PRICE   applied_priceMAFast=PRICE_CLOSE; //Tipo di  prezzo MA 
input color                coloreMAFast = clrAzure;         //Colore MA 

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

input string     comment_CHART =      "--- SETTING CHART ---";   // --- SETTING CHART ---
input bool       shortLines             = true;     //Linee corte
input bool       SHowLineName           = true;     //Nome linea
input bool       DRawBackground         = true; 
input bool       DIsableSelection       = true;   
input color      colorelinea            = clrGold;  //Colore Soglie
input color      coloreminmax           = clrGreen; //Colore Max Buy/Min Sell
input LineType   tipodilinea            = 2;        //Tipo di linea
input LineWidth  Spessorelinea          = 1;        //Spessore linea

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

bool   Accumulative      =         true;

ulong  magicNumber       = magic_number;   // Magic Number

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

int handleATR;
int handle_iCustomMAFast;
int Handle_iCustomZigZag;

static double sogliaSup,sogliaInf=0;
string Pcode="Zigulì ";
static  bool datiSoglie = false;

double ultimoZZ = 0;

static int contaUno = 0;

double sogliabuycons = 0, sogliasellcons = 0;
double inclinometr = 0;
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
   handle_iCustomMAFast   = iCustom(symbol_,0,"Examples\\Custom Moving Average Input Color",periodMAFast,shiftMAFast,methodMAFast,coloreMAFast);  
   /*
input int InpDepth    =12;  // Depth
input int InpDeviation=5;   // Deviation
input int InpBackstep =3;   // Back Step*/ 
   Handle_iCustomZigZag=iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InpBackstep);
   sogliaSup=0;sogliaInf=0;datiSoglie = false;
   contaUno = 0;
   
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
static datetime timesogliasup = 0;
static datetime timesogliainf = 0;

string inclinazenable = "";
if(inclinazmin>inclinometr) inclinazenable = "L'Inclinazione NON CONSENTE Nuovi Ordini";
Commento = spreadComment() + "\nBarre nel grafico " + (string)numBarreInChart() + "\n\nInclinazione Minima consentita "+(string)inclinazmin+"\nInclinazione reale "+(string)inclinometr+"\n"+inclinazenable;

semCand = semaforoCandela(0); 

Indicators();

closeOrdineMA(MAFast(0),magic_number,Commen);
gestioneBreakEven();
gestioneTrailStop();
if(semCand || !contaUno) {gestioneOrdini(timesogliasup,timesogliainf);contaUno++;}

if(shortLines)DRawRectangleLine(timesogliasup,timesogliainf);
else drawHorizontalLevel();
WRiteLineName();
//Histogram();
Comment(Commento);
//Print("Soglia% Buy ",((sogliaSup-sogliaInf)/100*perclevlev)+sogliaInf);Print("Soglia% Sell ",sogliaSup-((sogliaSup-sogliaInf)/100*perclevlev));
}  

//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini(datetime &timesogliasup,datetime &timesogliainf)
{
	if(!autoTradingOnOff || !enableTrading) return;
	
	Allocazione_Check(magicNumber);  
  
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
static double StLossZzPrecedBuy = 0,StLossZzPrecedSell = 0;


if(
      sogliaBuySell("Buy",StLossZzPrecedBuy,timesogliasup,timesogliainf)
   && ordini_Tipo_NumMax( "Buy",Type_Orders_,N_Max_pos,magicNumber,Commen)
   && numCandeleCongrue(direzCand_,"Buy",numCandDirez,timeFrCand)
   && impulsoLivello("Buy")
   )
   {
   SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf("Buy"),Commen,magic_number);
   }                    

if(
      sogliaBuySell("Sell",StLossZzPrecedSell,timesogliasup,timesogliainf) 
   && ordini_Tipo_NumMax("Sell",Type_Orders_,N_Max_pos,magicNumber,Commen)
   && numCandeleCongrue(direzCand_,"Sell",numCandDirez,timeFrCand)
   && impulsoLivello("Sell")
   )
   {
   SendTradeSellInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss(),calcoloTakeProf("Sell"),Commen,magic_number);
   }
}  
//+------------------------------------------------------------------+
//|                        sogliaBuySell()                           |
//+------------------------------------------------------------------+ 
bool sogliaBuySell(string BuySell,double &SlZZPrecedente, datetime &timePiccoAlto, datetime &timePiccoBasso)
{
bool a = false;

double C1 = 0,H1 = 0,L1 = 0; 
if(semCand) {C1 = iClose(symbol_,PERIOD_CURRENT,1);H1 = iHigh(symbol_,PERIOD_CURRENT,1);L1 = iLow(symbol_,PERIOD_CURRENT,1);}

int IndexZZ[100];ArrayInitialize(IndexZZ,0);
double ValZZ[100];ArrayInitialize(ValZZ,0);

static  int indexSogliaSup=0; static int indexSogliaInf=0;

int IndexZZZ[100];ArrayInitialize(IndexZZZ,0);
double ValZZZ[100];ArrayInitialize(ValZZZ,0);

static double piccoalto = 0, piccobasso = 0;


if(semCand) 
{
zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,1,periodZigzag,ValZZZ,IndexZZZ);
ultimoZZ = ultimoZigZag(ValZZZ,IndexZZZ,indexSogliaSup,indexSogliaInf);
//Print(" ultimoZZ ",ultimoZZ);
}

if(datiSoglie==false)
{
 
 zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,MinCandZZ,periodZigzag,ValZZ,IndexZZ);


 if(ValZZ[0]==0 || ValZZ[1]==0 || ValZZ[2]==0)
     {Print("Picco 0 ",ValZZ[0],"Picco 1 ",ValZZ[1],"Picco 2 ",ValZZ[2],"Dati Zig Zag Incompleti. Controllare numero candele Backtest");
      Commento=Commento+(string)" No dati Zig Zag. Controllare numero candele Backtest";};
 

if(ValZZ[0]>0 && ValZZ[1]>0 && ValZZ[2]>0 && doubleCompreso(ValZZ[0],ValZZ[1],ValZZ[2]) && datiSoglie==false)
{
	if(ValZZ[1]>ValZZ[2]) {sogliaSup = piccoalto = ValZZ[1];indexSogliaSup=IndexZZ[1]; sogliaInf = piccobasso = ValZZ[2];indexSogliaInf=IndexZZ[2];} 
	if(ValZZ[1]<ValZZ[2]) {sogliaSup = piccoalto = ValZZ[2];indexSogliaSup=IndexZZ[2]; sogliaInf = piccobasso =  ValZZ[1];indexSogliaInf=IndexZZ[1];} 
}	
	
if(ValZZ[0]>0 && ValZZ[1]>0 && ValZZ[2]>0 && !doubleCompreso(ValZZ[0],ValZZ[1],ValZZ[2]) && datiSoglie==false)
{
	if(ValZZ[0]>ValZZ[1]) {sogliaSup = piccoalto = ValZZ[0];indexSogliaSup=IndexZZ[0]; sogliaInf = piccobasso =  ValZZ[1];indexSogliaInf=IndexZZ[1];} 
	if(ValZZ[0]<ValZZ[1]) {sogliaSup = piccoalto = ValZZ[1];indexSogliaSup=IndexZZ[1]; sogliaInf = piccobasso =  ValZZ[0];indexSogliaInf=IndexZZ[0];}
}		


timePiccoAlto = iTime(symbol_,periodZigzag,indexSogliaSup);
timePiccoBasso= iTime(symbol_,periodZigzag,indexSogliaInf);

indexSogliaSup=iBarShift(symbol_,timeFrPicco,timePiccoAlto);
indexSogliaInf=iBarShift(symbol_,timeFrPicco,timePiccoBasso);


if(!bodyShadowSw) //Body
{
if(candelaNumIsBuyOSellTF(indexSogliaSup,"Buy",timeFrPicco)) sogliaSup = iOpen(symbol_,timeFrPicco,indexSogliaSup);
if(candelaNumIsBuyOSellTF(indexSogliaSup,"Sell",timeFrPicco))sogliaSup = iClose(symbol_,timeFrPicco,indexSogliaSup);

if(candelaNumIsBuyOSellTF(indexSogliaInf,"Buy",timeFrPicco)) sogliaInf = iClose(symbol_,timeFrPicco,indexSogliaInf);
if(candelaNumIsBuyOSellTF(indexSogliaInf,"Sell",timeFrPicco))sogliaInf = iOpen(symbol_,timeFrPicco,indexSogliaInf);
}

if(bodyShadowSw) //Shadow
{
sogliaSup = iLow(symbol_,timeFrPicco,indexSogliaSup);
sogliaInf = iHigh(symbol_,timeFrPicco,indexSogliaInf);
}
/*
Print(" indexSogliaSup: ",indexSogliaSup," timePiccoAlto: ",timePiccoAlto," indexSogliaInf: ",indexSogliaInf," timePiccoBasso: ",timePiccoBasso);	
Print(" Barre Picco alto: ",iBarShift(symbol_,timeFrPicco,timePiccoAlto)," Barre Picco basso: ",iBarShift(symbol_,timeFrPicco,timePiccoBasso));
Print(" High : ",iHigh(symbol_,timeFrPicco,iBarShift(symbol_,timeFrPicco,timePiccoAlto))," Low : ",iLow(symbol_,timeFrPicco,iBarShift(symbol_,timeFrPicco,timePiccoBasso)));
*/

if(sogliaSup && sogliaInf) datiSoglie = true; //else(Print("No dati soglie"));
}
Print(" Picco alto ",piccoalto," Picco basso ",piccobasso," indexSogliaSup ",indexSogliaSup," indexSogliaInf ",indexSogliaInf);



if(datiSoglie && (H1>piccoalto || L1<piccobasso)) {datiSoglie=false;
sogliaSup=0;sogliaInf=0;indexSogliaInf=indexSogliaSup=0;piccoalto=piccobasso=0;a=0;
return a;}

/*
if(datiSoglie && (C1>sogliaSup || C1<sogliaInf)) {datiSoglie=false;
//sogliaSup=0;sogliaInf=0;
return false;}//////////////////////////////////////////////////////////
*/




if(sogliaSup < sogliaInf){Commento=Commento+"\n\n Soglia Superiore inferiore alla Soglia Inferiore: No Open Order";
                           Print("Soglia Superiore inferiore alla Soglia Inferiore: No Open Order"); a = false;return a;}

bool percSogliaSogliaBuy  = percsogliasoglia("Buy");
bool percSogliaSogliaSell = percsogliasoglia("Sell");

if(inclinometro(piccoalto, piccobasso, indexSogliaSup,indexSogliaInf,inclinometr) && passasogliaprima("Buy") && BuySell=="Buy"  && percSogliaSogliaBuy && C1>sogliaInf 
      && C1<sogliaSup && numCandeleCongrue(direzCand_,"Buy", numCandDirez,PERIOD_CURRENT)) 
      {a = true;
      //Print(" Congrue BUY ");
       return a;}

if(inclinometro(piccoalto, piccobasso, indexSogliaSup,indexSogliaInf,inclinometr) && passasogliaprima("Sell") && BuySell=="Sell" && percSogliaSogliaSell && C1<sogliaSup 
      && C1>sogliaInf && numCandeleCongrue(direzCand_,"Sell",numCandDirez,PERIOD_CURRENT)) 
      {a = true;
      //Print(" Congrue SELL ");
       return a;}

return a;
}
//------------------------------------- inclinometro() ----------------------------------------------- 
bool inclinometro(double piccoalto, double piccobasso, int indexSogliaSup,int indexSogliaInf,double &inclinometro)
{
bool a = false;

if(indexSogliaSup-indexSogliaInf > 0 && inclinazmin < (sogliaSup-sogliaInf)/(indexSogliaSup-indexSogliaInf)*1000000) {inclinometro = (sogliaSup-sogliaInf)/(indexSogliaSup-indexSogliaInf)*1000000;a = true;}
if(indexSogliaInf-indexSogliaSup > 0 && inclinazmin < (sogliaSup-sogliaInf)/(indexSogliaInf-indexSogliaSup)*1000000) {inclinometro = (sogliaSup-sogliaInf)/(indexSogliaInf-indexSogliaSup)*1000000;a = true;}
 //Print(" A ",a," Inclinometro ",inclinometro," indexSogliaSup ",indexSogliaSup," sogliaSup ",sogliaSup," indexSogliaInf ",indexSogliaInf," sogliaInf ",sogliaInf);
 return a;
}
//----------------------------------- percsogliasoglia() --------------------------------------------- 
bool percsogliasoglia(string BuySell)
{
bool a = false;
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
sogliabuycons  = ((sogliaSup-sogliaInf)/100*perclevlev)+sogliaInf;//Print("sogliabuycons ",sogliabuycons);
sogliasellcons = (sogliaSup-(sogliaSup-sogliaInf)/100*perclevlev);//Print("sogliasellcons ",sogliasellcons);
if(BuySell=="Buy"  && passasogliaprima("Buy")  && C1<= ((sogliaSup-sogliaInf)/100*perclevlev)+sogliaInf){a=true;return a;}
if(BuySell=="Sell" && passasogliaprima("Sell") && C1>= (sogliaSup-(sogliaSup-sogliaInf)/100*perclevlev)){a=true;return a;}
return a;
}
//----------------------------------- passasogliaprima() --------------------------------------------- 
bool passasogliaprima(string BuySell)
{
bool a = false;
static string prima = "Flat";

if(iOpen(symbol_,PERIOD_CURRENT,1)<sogliaInf && iClose(symbol_,PERIOD_CURRENT,1)>sogliaInf) {prima = "Buy";}
if(iOpen(symbol_,PERIOD_CURRENT,1)>sogliaSup && iClose(symbol_,PERIOD_CURRENT,1)<sogliaSup) {prima = "Sell";}
if(BuySell=="Buy" && prima == "Buy") {a = true;return a;}

if(BuySell=="Sell" && prima == "Sell") {a = true;return a;}

return a;
}
//----------------------------------- ultimoZigZag() --------------------------------------------- 
double ultimoZigZag(double &ValZ[],int &IndexZ[],int indexSogliaSup,int indexSogliaInf)
{
double a=0;
if(indexSogliaSup > indexSogliaInf)  //solo Buy
{for(int i=0;i<=indexSogliaInf;i++){if(ValZ[i] < iOpen(symbol_,periodZigzag,IndexZ[i])) {a = ValZ[i];return a;}}}

if(indexSogliaSup < indexSogliaInf)  //solo Sell
{for(int i=0;i<=indexSogliaSup;i++){if(ValZ[i] > iClose(symbol_,periodZigzag,IndexZ[i])) {a = ValZ[i];return a;}}}
return a;
}

//----------------------------------- impulsoLivello() --------------------------------------------- 
bool impulsoLivello(string BuySell)
{
bool a = true;
if(levelImpuls==1){a=true;return a;}

if(levelImpuls==0)
{
static string tipoultimoOrdine = "Flat";
static double oldsogliasup = 0, oldsogliainf = 0;
int   ordbuy  = NumOrdBuy(magicNumber,Commen);
int   ordsell = NumOrdSell(magicNumber,Commen);

if(sogliaSup != oldsogliasup || sogliaInf != oldsogliainf) {tipoultimoOrdine = "Flat"; oldsogliasup = sogliaSup; oldsogliainf = sogliaInf;}

if(ordbuy)  {tipoultimoOrdine = "Buy";}
if(ordsell) {tipoultimoOrdine = "Sell";}

if(BuySell=="Buy")
{
if(tipoultimoOrdine == "Buy"){a = false;return a;}
if(tipoultimoOrdine != "Buy"){a = true;return a;}
}

if(BuySell=="Sell")
{
if(tipoultimoOrdine == "Sell"){a = false;return a;}
if(tipoultimoOrdine != "Sell"){a = true;return a;}
}}
return a;
}

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
if(TypeSl_==2)
{
if(ASK-ultimoZZ > 0) {a=(int)((ASK-ultimoZZ)/Point());return a;}
if(ultimoZZ-BID > 0) {a=(int)((ultimoZZ-BID)/Point());return a;}
}
return a;
}
//----------------------------- calcoloTakeProf()--------------------------------------------- 
int calcoloTakeProf(string BuySell)
{
int TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1){TP=TpPoints;return TP;}

if(TakeProfit==3 && BuySell=="Buy"){TP=(int)((sogliaSup-BID)/Point());return TP;}
if(TakeProfit==3 && BuySell=="Sell"){TP=(int)((ASK-sogliaInf)/Point());return TP;}
return TP;
}
//------------------------------ gestioneBreakEven()--------------------------------------------- 
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(BeStartPoints, BeStepPoints, magic_number, Commen);
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
//|                        closeOrdineMA()                          |
//+------------------------------------------------------------------+
void closeOrdineMA(double valMA,ulong magic,string comment)
{
if(TakeProfit==2) chiudeOrdineMA(valMA,magic,comment);
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
   char index=1;

         ChartIndicatorAdd(0,0,handle_iCustomMAFast);
         ChartIndicatorAdd(0,0,Handle_iCustomZigZag);
           // index ++;
   if(OnChart_ATR) int    indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);  
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
   
   if(ObjectFind(0,Pcode+"Max Buy ")>=0)ObjectDelete(0,Pcode+"Max Buy "); 
   if(ObjectFind(0,Pcode+"Min Sell ")>=0)ObjectDelete(0,Pcode+"Min Sell "); 
   if(ObjectFind(0,Pcode+"Max Buy")>=0)ObjectDelete(0,Pcode+"Max Buy"); 
   if(ObjectFind(0,Pcode+"Min Sell")>=0)ObjectDelete(0,Pcode+"Min Sell");       
   
  }
//+------------------------------------------------------------------+
//|                      WRiteLineName()                             |
//+------------------------------------------------------------------+
void WRiteLineName()
  {

   datetime time2,Time5[1];
/*
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
     }*/
   time2= TimeCurrent();
   if(SHowLineName)
     {
      if(sogliaSup!=0)
        {
         if(ObjectFind(0,Pcode+"Soglia Sup ")<0)
           {
            ObjectCreate(0,Pcode+"Soglia Sup ", OBJ_TEXT,0,time2,sogliaSup);
            ObjectSetString(0,Pcode+"Soglia Sup ",OBJPROP_TEXT,Pcode+"Soglia Sup "+DoubleToString(NormalizeDouble(sogliaSup,Digits()),Digits()));
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
         ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_COLOR,colorelinea);
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
         ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_COLOR,colorelinea);
        }


      if(sogliabuycons!=0)
        {
         if(ObjectFind(0,Pcode+"Max Buy ")<0)
           {
            ObjectCreate(0,Pcode+"Max Buy ", OBJ_TEXT,0,time2,sogliabuycons);
            ObjectSetString(0,Pcode+"Max Buy ",OBJPROP_TEXT,Pcode+"Max Buy "+DoubleToString(NormalizeDouble(sogliabuycons,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Max Buy ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Max Buy ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Max Buy ",OBJPROP_BACK,DRawBackground);
            ObjectSetInteger(0,Pcode+"Max Buy ",OBJPROP_SELECTABLE,!DIsableSelection);
            ObjectSetInteger(0,Pcode+"Max Buy ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Max Buy ",0,time2,sogliabuycons);
            ObjectSetString(0,Pcode+"Max Buy ",OBJPROP_TEXT,Pcode+"Max Buy "+DoubleToString(NormalizeDouble(sogliabuycons,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"Max Buy ",OBJPROP_COLOR,coloreminmax);
        }
 
      if(sogliasellcons!=0)
        {
         if(ObjectFind(0,Pcode+"Min Sell ")<0)
           {
            ObjectCreate(0,Pcode+"Min Sell ", OBJ_TEXT,0,time2,sogliasellcons);
            ObjectSetString(0,Pcode+"Min Sell ",OBJPROP_TEXT,Pcode+"Min Sell "+DoubleToString(NormalizeDouble(sogliasellcons,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Min Sell ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Min Sell ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Min Sell ",OBJPROP_BACK,DRawBackground);
            ObjectSetInteger(0,Pcode+"Min Sell ",OBJPROP_SELECTABLE,!DIsableSelection);
            ObjectSetInteger(0,Pcode+"Min Sell ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Min Sell ",0,time2,sogliasellcons);
            ObjectSetString(0,Pcode+"Min Sell ",OBJPROP_TEXT,Pcode+"Min Sell "+DoubleToString(NormalizeDouble(sogliasellcons,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"Min Sell ",OBJPROP_COLOR,coloreminmax);
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

      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_COLOR, colorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_HIDDEN, true);
     }


   if(sogliaInf!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Inf")<0)
         ObjectCreate(0,Pcode+"Soglia Inf", OBJ_HLINE, 0, Time5[0], sogliaInf);
      else
         ObjectMove(0,Pcode+"Soglia Inf",0,Time5[0],sogliaInf);

      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_COLOR, colorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_HIDDEN, true);
     }
     
     
   if(sogliabuycons!=0)
     {
      if(ObjectFind(0,Pcode+"Max Buy")<0)
         ObjectCreate(0,Pcode+"Max Buy", OBJ_HLINE, 0, Time5[0], sogliabuycons);
      else
         ObjectMove(0,Pcode+"Max Buy",0,Time5[0],sogliabuycons);

      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_COLOR, coloreminmax);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_HIDDEN, true);
     }


   if(sogliasellcons!=0)
     {
      if(ObjectFind(0,Pcode+"Min Sell")<0)
         ObjectCreate(0,Pcode+"Min Sell", OBJ_HLINE, 0, Time5[0], sogliasellcons);
      else
         ObjectMove(0,Pcode+"Min Sell",0,Time5[0],sogliasellcons);

      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_COLOR, coloreminmax);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_HIDDEN, true);
     }     
     
}

//+------------------------------------------------------------------+
//|                    DRawRectangleLine()                           |
//+------------------------------------------------------------------+
void DRawRectangleLine(datetime timepiccoalto,datetime timepiccobasso)
  {
   datetime time1,time2,time3;

   time1 = timepiccoalto; 

   time2 = TimeCurrent();

   time3 = timepiccobasso;

   if(sogliaSup!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Sup")<0)
         ObjectCreate(0,Pcode+"Soglia Sup", OBJ_RECTANGLE, 0, time1, sogliaSup, time2, sogliaSup);
      else
        {
         ObjectMove(0,Pcode+"Soglia Sup",0,time1,sogliaSup);
         ObjectMove(0,Pcode+"Soglia Sup",1,time2,sogliaSup);
        }
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_COLOR, colorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_HIDDEN, true);
     }


   if(sogliaInf!=0)
     {
      if(ObjectFind(0,Pcode+"Soglia Inf")<0)
         ObjectCreate(0,Pcode+"Soglia Inf", OBJ_RECTANGLE, 0, time3, sogliaInf, time2, sogliaInf);
      else
        {
         ObjectMove(0,Pcode+"Soglia Inf",0,time3,sogliaInf);
         ObjectMove(0,Pcode+"Soglia Inf",1,time2,sogliaInf);
        }
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_COLOR, colorelinea);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_HIDDEN, true);
     }
     



   if(sogliabuycons!=0)
     {
      if(ObjectFind(0,Pcode+"Max Buy")<0)
         ObjectCreate(0,Pcode+"Max Buy", OBJ_RECTANGLE, 0, time3, sogliabuycons, time2, sogliabuycons);
      else
        {
         ObjectMove(0,Pcode+"Max Buy",0,time3,sogliabuycons);
         ObjectMove(0,Pcode+"Max Buy",1,time2,sogliabuycons);
        }
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_COLOR, coloreminmax);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_HIDDEN, true);
     }
  


   if(sogliasellcons!=0)
     {
      if(ObjectFind(0,Pcode+"Min Sell")<0)
         ObjectCreate(0,Pcode+"Min Sell", OBJ_RECTANGLE, 0, time3, sogliasellcons, time2, sogliasellcons);
      else
        {
         ObjectMove(0,Pcode+"Min Sell",0,time3,sogliasellcons);
         ObjectMove(0,Pcode+"Min Sell",1,time2,sogliasellcons);
        }
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_WIDTH, Spessorelinea);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_COLOR, coloreminmax);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_HIDDEN, true);
     }  
     
     }  


  
  
  
  
  