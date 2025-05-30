//+------------------------------------------------------------------+
//|                                              GannPivots v3.0.mq5 |
//|                                   Copyright 2023, Corrado Bruni  |
//|                                   https://aligokay-duman.web.app |
//+------------------------------------------------------------------+
/*    
////////////////  Incollare negli enum
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
   PivotWHL_2        = 1,        // Pivot W HL:2
   PivotWHLC_3       = 2         // Pivot W HL:3
  };
enum PriceTypeD
  {
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
  
//////////////////  Incollare negl'Input
input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput              gannInputDigit   = 4;         //Number of price digits used: Calibration
input Divisione              DIVIS            = 0;         //Multiplication / Division of digits: Calibration

input PriceType              gannInputType    = 9;         //Type of Input in Calculation
input string                 gannCustomPrice  = "1.00000";
input PivD_SR_Sqnine         PivotDaily       = 0;         //Sul grafico: Pivot Daily or Resistances/Supports Sq 9

input PriceTypeW             TypePivW         = 2;         //Pivot Weekly Type (for Filter)
input PriceTypeD             PriceTypeD_      = 3;         //Pivot Daily Type (for Filter)
input input_ruota_           input_ruota      = 1;         //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_= 1;         //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;         //Advanced Formula Angles: 360°/270°/180°/90°  
input string       comment_IC =        "--- SETTINGS CHART ---";   // --- SETTINGS CHART ---
input bool VisibiliInChart                    = true;
input bool         shortLines                 = true;
input bool         showLineName               = true;
input AlertType    alert1                     = 0;
input AlertType    alert2                     = 0;

input int          pipDeviation               = 0;         //Sensibility for alert
input string       CommentStyle               = "--- Style Settings ---";
input bool         drawBackground             = true;
input bool         disableSelection           = true;
input color        resistanceColor            = clrRed;
input LineType     resistanceType             = 2;
input LineWidth    resistanceWidth            = 1;
input color        supportColor               = clrLime;
input LineType     supportType                = 2;
input LineWidth    supportWidth               = 1;
input string       ButtonStyle                = "--- Toggle Style Settings ---";
bool         buttonEnable               = false;
//input bool         buttonEnable               = false;
input int          xDistance_                 = 250;
input int          yDistance_                 = 5;
input int          WIdth                      = 100;
input int          hight                      = 30;
input string       label                      = " ";

input string       comment_ZZG                = "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input int          InpDepthG                  = 12;             // ZigZag: Depth
input int          InpDeviationG              =  5;             // ZigZag: Deviation
input int          InpBackstepG               =  3;             // ZigZag: Backstep
input int          InpCandlesCheckG           = 50;             // ZigZag: how many candles to check back
input char         MinCandZZG                 =  3;             //Min candle distance
input ENUM_TIMEFRAMES periodZigzagG           = PERIOD_CURRENT; //Timeframe
input periodoRicercaCand periodoRicNumCandG   = 0;              //Picchi zigzag nel periodo prima di 1 giorno/1 settimana/1 mese/6 mesi/1 anno
input ENUM_TIMEFRAMES TfPeridoRicCandG           ;


///////////// Richiamo funzione 
   iCustom(symbol_,0,"Gann Sq 9 Indicator\\Gann_Pivots_3",comment_CS9,gannInputDigit,DIVIS,gannInputType,gannCustomPrice,PivotDaily,TypePivW,PriceTypeD_,input_ruota,
	        PeriodoPrecRuota_,gradi_Ciclo,comment_IC,VisibiliInChart,shortLines,showLineName,alert1,alert2,pipDeviation,CommentStyle,drawBackground,disableSelection,
	        resistanceColor,resistanceType,resistanceWidth,supportColor,supportType,supportWidth,ButtonStyle,buttonEnable,xDistance_,yDistance_,WIdth,hight,label,
	        comment_ZZG,InpDepthG,InpDeviationG,InpBackstepG,InpCandlesCheckG,MinCandZZG,periodZigzagG
	        ); 
/////////// Recupero Buffer	  

 ////////
double arrSq9livelli[];ArraySetAsSeries(arrSq9livelli,true);
Buffer(handle_iCustom,1,0,10,arrSq9livelli);
for(int i=0;i<ArraySize(arrSq9livelli);i++)
{
Print(" Level Sq9 ",i," ",arrSq9livelli[i]);
}
/////////
      
//+------------------------------------------------------------------+
//|                            Buffer()                              |
//+------------------------------------------------------------------+
double Buffer(int handle,int buff,int index1,int quantita,double &arrSq9livelli[])
{Print(" handle ",handle);
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
	        
*/
#property copyright "Copyright 2023, Corrado Bruni"
#property link      "https://aligokay-duman.web.app"
#property version   "3.0"
#property description "This Indicator is based on levels Square of 9 di W.D.Gann."
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   2

string versione = "v3.0";

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>
#include <MyInclude\PosizioniTicket.mqh>

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

//--- input parameters

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
   PreviousDayClose = 1,        //Prezzo ingresso Sq 9: chiusura giorno precedente
   PreviousDayLow   = 2,        //Prezzo ingresso Sq 9: Low giorno precedente
   PreviousDayHigh  = 3,        //Prezzo ingresso Sq 9: High giorno precedente
   PivotDailyHL     = 4,        //Prezzo ingresso Sq 9: Pivot Daily
   PivotWeek        = 5,        //Prezzo ingresso Sq 9: Pivot Weekly
   Custom           = 6,        //Prezzo ingresso Sq 9: prezzo Custom
   HiLoZigZag       = 7,        //Ultimo picco Shadow Zig Zag indicator
   HigLowZigZag     = 8,        //Ultimo picco Body Zig Zag indicator
   LastHLDayPrima   = 9,        //Ultimo High o Low Shadow del giorno precedente
   LastBodyDayPrima =10,        //Ultimo High o Low Body del giorno precedente
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
   
input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput              gannInputDigit   = 4;         //Number of price digits used: Calibration
input Divisione              DIVIS            = 0;         //Multiplication / Division of digits: Calibration

input PriceType              gannInputType    = 9;         //Type of Input in Calculation
input string                 gannCustomPrice  = "1.00000";
input PivD_SR_Sqnine         PivotDaily       = 0;         //Sul grafico: Pivot Daily or Resistances/Supports Sq 9

input PriceTypeD             PriceTypeD_      = 3;         //Pivot Daily Type 
input PriceTypeW             TypePivW         = 2;         //Pivot Weekly Type 
input input_ruota_           input_ruota      = 1;         //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_= 1;         //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;         //Advanced Formula Angles: 360°/270°/180°/90°  
input string       comment_IC =        "--- SETTINGS CHART ---";   // --- SETTINGS CHART ---
input bool         VisibiliInChart            = true;
input bool         shortLines                 = true;
input bool         showLineName               = true;
input AlertType    alert1                     = 0;
input AlertType    alert2                     = 0;

input int          pipDeviation               = 0;         //Sensibility for alert
input string       CommentStyle               = "--- Style Settings ---";
input bool         drawBackground             = true;
input bool         disableSelection           = true;
input color        resistanceColor            = clrRed;
input LineType     resistanceType             = 2;
input LineWidth    resistanceWidth            = 1;
input color        supportColor               = clrLime;
input LineType     supportType                = 2;
input LineWidth    supportWidth               = 1;
input string       ButtonStyle                = "--- Toggle Style Settings ---";
input bool         buttonEnable               = false;
input int          xDistance_                 = 250;
input int          yDistance_                 = 5;
input int          WIdth                      = 100;  //width
input int          hight                      = 30;
input string       label                      = " ";

input string       comment_ZZ                 = "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input int          InpDepth                   = 12;             // ZigZag: Depth
input int          InpDeviation               =  5;             // ZigZag: Deviation
input int          InpBackstep                =  3;             // ZigZag: Backstep
input int          InpCandlesCheck            = 50;             // ZigZag: how many candles to check back
input char         MinCandZZ                  =  3;             //Min candle distance
input ENUM_TIMEFRAMES periodZigzag            = PERIOD_CURRENT; //Timeframe
/*
input periodoRicercaCand periodoRicNumCand    = 0;              //Picchi zigzag nel periodo prima: 1 giorno/1 settimana/1 mese/6 mesi/1 anno
//periodoRicercaCand   periodoRicNumCand      = 0;              //Picchi zigzag nel periodo prima: 1 giorno/1 settimana/1 mese/6 mesi/1 anno
input ENUM_TIMEFRAMES TfPeridoRicCand    ;
//ENUM_TIMEFRAMES      TfPeridoRicCand   ; 
*//*



input PriceType  GannInputType       ;
input string     GannCustomPrice     ;
input int        GannInputDigit      ;
input bool       ShortLines          ;
input bool       ShowLineName        ;
input AlertType  Alert1              ;
input AlertType  Alert2              ;
input int        PipDeviation        ;
input string     CommentStyle        ;
input bool       DrawBackground      ;
input bool       DisableSelection    ;
input color      ResistanceColor     ;
input LineType   ResistanceType      ;
input LineWidth  ResistanceWidth     ;
input color      SupportColor        ;
input LineType   SupportType         ;
input LineWidth  SupportWidth        ;
input string     ButtonStyle         ;
input bool       ButtonEnable        ;
input int        XDistance           ;
input int        YDistance           ;
input int        Width               ;
input int        Hight               ;
input string     Label               ;
*/
int    lastBar=0;
double lastAlarmPrice=0;
bool   timeToCalc=false;
double R1Price,R2Price,R3Price,R4Price,R5Price;
double S1Price,S2Price,S3Price,S4Price,S5Price;
string pcode="GannPivots_";
double LastAlert=-1;
double NewAlert=0;
string broker_name;


double sD1;
double rD1;
double sD2;
double rD2;
double sD3;
double rD3;

double sW1;
double rW1;
double sW2;
double rW2;
double sW3;
double rW3;

int    LastBar=0;
double LastAlarmPrice=0;
bool   TimeToCalc=false;
double R1Pricee,R2Pricee,R3Pricee,R4Pricee,R5Pricee;
double S1Pricee,S2Pricee,S3Pricee,S4Pricee,S5Pricee;
string Pcode="Square 9 ";
double LastAlert_=-1;
double NewAlert_=0;
//string broker_name;

double div;

string chartiD_ = "";
string buttonID_="ButtonGann";
double showGann_;

double HighD1;
double LowD1;


double HighW1;
double LowW1;
double OpenW1;
double CloseW1;
double HighM1;
double LowM1;

double PreviousWeekOpen;
double PreviousWeekLow;
double PreviousWeekHigh;
double PreviousWeekClose;
double priceW;

double compraSopra;
double primoLevBuy;
double secondoLevBuy;
double terzoLevBuy;
double quartoLevBuy;
double quintoLevBuy;

double vendiSotto;
double primoLevSell;
double secondoLevSell;
double terzoLevSell;
double quartoLevSell;
double quintoLevSell;

char levelByLevel;
//bool livelliOk = true;

bool enableNewsOrdes          = true;
bool timeTrading              = true;
bool enableTrading            = true;
bool TimeNewOrderEnable       = false;          //Abilitazione con impostazioni oraria di apertura di nuovi ordini

double gra_clcl=0;
double coeff_ruota=0;
double moltip_x_cifra_pivot=0;
double virgolaAsset=0;

int GannInputDigit_=0;
double PRiceIn = 0;
int Divis_ = 0;

double LowP[1];
double HighP[1];
double valoriArr [30];
double arrParamInd [50];

int    arrInput [50];
double arrPric[50];
string sniperString [30];

char Orders_LivellieNumero [15];
double Orders_Prezzi_Ordini [15];

char   Numero_Ordini_aperti   =  0;
double Prezzo_Stop_Loss;
double Prezzo_Break_Even;
double Prezzo_Take_Profit;

double SL_Pips_calcolato;
double Sl_N_Livelli_Prima_calcolato;
double Sl_Perc_Al_Livello_Prima_calcolato;
double BE_calcolato;
double Be_Start_pips_calcolato;
double BE_PercLevelbylevel_calcolato;
double Prezzo_TS_calcolato;
double Prezzo_TP_calcolato;
bool nuovoGiorno;
double openIeri;
double closeIeri;
int oggi;
double HiLoPrecRoute=0.0;

double prezzoPivot;
double PivDay;

static bool order_okBuy = false;
static bool order_okSell = false;
char lev_startBuy;
char lev_startSell;
int startBuy;
int startSell;
bool preordine_buy = false;
bool preordine_sell = false;
bool preordine = false;
string commento;
string segno_ordine;

double capitaleBasePerCompounding;
double distanzaSL = 0;

double percAggiunta=0;

int   handle_iCustom;                  // variable for storing the handle of the iCustom indicator Zig Zag

double StopLossBuy;
double StopLossSell;

bool GridBuyActive=false;
bool GridSellActive=false;

ulong TicketHedgeBuy [100];
ulong TicketHedgeSell[100];

datetime OraNews;

double ThresholdUp_;//Per visualizzazione grafica
double ThresholdDw_;//Per visualizzazione grafica

double ValZZ[100];
int IndexZZ[100];

double ResSuppGann[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed Indicator from this account!");
      Alert("EA: Trial period expired! Removed Indicator from this account!");}
  
  
   chartiD_ = IntegerToString(ChartID())+"-1973456"; //chartiD_+UniqueID
   EventSetTimer(10);
   clearObj();
   lastBar=0;
   broker_name = StringSubstr(AccountInfoString(ACCOUNT_COMPANY),0,5);

   
   ArraySetAsSeries(ResSuppGann,true);
   SetIndexBuffer(1, ResSuppGann);


   Div_(DIVIS); /////////////// inserito quando ho tolto OnCalculate
//*-----------------------------------------------------------------------------+

   if(buttonEnable)
     {
      if(GlobalVariableCheck(chartiD_+"-"+"showGann_"))
         showGann_ = GlobalVariableGet(chartiD_+"-"+"showGann_");
      else
         showGann_ = -1;

      ObjectCreate(0,buttonID_,OBJ_BUTTON,0,iTime(Symbol(),PERIOD_CURRENT,0),iHigh(Symbol(),PERIOD_CURRENT,0));
      ObjectSetInteger(0,buttonID_,OBJPROP_XDISTANCE,xDistance_);
      ObjectSetInteger(0,buttonID_,OBJPROP_YDISTANCE,yDistance_);
      ObjectSetInteger(0,buttonID_,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,buttonID_,OBJPROP_XSIZE,WIdth);
      ObjectSetInteger(0,buttonID_,OBJPROP_YSIZE,hight);
      ObjectSetInteger(0,buttonID_,OBJPROP_STATE,false);
      ObjectSetInteger(0,buttonID_,OBJPROP_BORDER_COLOR,clrGray);
      ObjectSetString(0,buttonID_,OBJPROP_TEXT,label);
      ObjectSetInteger(0,buttonID_,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,buttonID_,OBJPROP_HIDDEN,true);

      if(showGann_==1 || showGann_==-1)
        {
         ObjectSetInteger(0,buttonID_,OBJPROP_BGCOLOR,clrRed);
        }
      else
        {
         ObjectSetInteger(0,buttonID_,OBJPROP_BGCOLOR,clrGreen);
        }
      ObjectSetInteger(0,buttonID_,OBJPROP_FONTSIZE,12);
      ObjectSetInteger(0,buttonID_,OBJPROP_COLOR,clrWhite);
     }
   else
     {
      showGann_ = 1;
      GlobalVariableSet(chartiD_+"-"+"showGann_",showGann_);
     }   
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ClearObj();
   ObjectDelete(0,buttonID_);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {


      
               //+------------------------------------------------------------------+
               //|                  Valori Daily                                    |
               //+------------------------------------------------------------------+
               if(semaforominuto())
                 {
                  HighD1= iHigh(Symbol(),PERIOD_D1,1);

                  LowD1=  iLow(Symbol(),PERIOD_D1,1);
                 }

  /*
  enum PriceType
  {
   PreviousDayOpen  = 0,        //Prezzo ingresso Sq 9: apertura giorno precedente
   PreviousDayClose = 1,        //Prezzo ingresso Sq 9: chiusura giorno precedente
   PreviousDayLow   = 2,        //Prezzo ingresso Sq 9: Low giorno precedente
   PreviousDayHigh  = 3,        //Prezzo ingresso Sq 9: High giorno precedente
   PivotDailyHL     = 4,        //Prezzo ingresso Sq 9: Pivot Daily
   PivotWeek        = 5,        //Prezzo ingresso Sq 9: Pivot Weekly
   Custom           = 6,        //Prezzo ingresso Sq 9: prezzo Custom
   HiLoZigZag       = 7,        //Ultimo picco Shadow Zig Zag indicator
   HigLowZigZag     = 8,        //Ultimo picco Body Zig Zag indicator
   LastHLDayPrima   = 9,        //Ultimo Top o Bottom del giorno precedente
   LastBodyDayPrima =10,        //Ultimo Body del giorno precedente
  };*/             
               //+------------------------------------------------------------------+
               //|        Valore d'ingresso del calcolatore dello Square of 9       |
               //+------------------------------------------------------------------+
               double price = 0;
               if(gannInputType==0)price = iOpen(Symbol(),PERIOD_D1,1);       //Prezzo ingresso Sq 9: apertura giorno precedente
               if(gannInputType==1)price = iClose(Symbol(),PERIOD_D1,1);      //Prezzo ingresso Sq 9: chiusura giorno precedente
               if(gannInputType==2)price = LowD1;                             //Prezzo ingresso Sq 9: Low giorno precedente
               if(gannInputType==3)price = HighD1;                            //Prezzo ingresso Sq 9: High giorno precedente
               if(gannInputType==4)price = PivotDaily(PriceTypeD_);           //Prezzo ingresso Sq 9: Pivot Daily
               if(gannInputType==5)price = PivotWeekly(TypePivW);             //Prezzo ingresso Sq 9: Pivot Weekly
               if(gannInputType==6)price = StringToDouble(gannCustomPrice);   //Prezzo ingresso Sq 9: prezzo Custom
               if(gannInputType==7)price = zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,MinCandZZ,periodZigzag,ValZZ,IndexZZ);//Ultimo picco Shadow Zig Zag indicator
               if(gannInputType==8)price = ZIGZAGHiLo();                      //Ultimo picco Body Zig Zag indicator
               if(gannInputType==9)price = lastPikDayprew_(0);                //Ultimo High o Low Shadow del giorno precedente
               if(gannInputType==10)price = lastPikDayprew_(1);               //Ultimo High o Low Body del giorno precedente
               
   if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed Indicator from this account!");
      Alert("EA: Trial period expired! Removed Indicator from this account!");
      price = 0;resetIndicators();} 
      
   if(intCompreso(gannInputType,7,8))
   {                           
   ChartIndicatorAdd(0,0, iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InpBackstep));        
   } 
   if(!intCompreso(gannInputType,7,8)) resetIndicators("ZigZag("+(string)InpDepth+","+(string)InpDeviation+","+(string)InpBackstep+")");
    
               PRiceIn = price = NormalizeDouble(price,Digits());
               Print(" prezzo normanizzato ",prezzonormalizzato(price,DIVIS));
               //+------------------------------------------------------------------+
               //|                  Pivot Daily                                     |
               //+------------------------------------------------------------------+
               PivDay=PivotDaily(PriceTypeD_);
               if(PivotDaily==1)
                 {
                  double PuntoPivotDaily = PivotDaily(PriceTypeD_);
                  rD1 = 2 * PuntoPivotDaily - LowD1;
                  sD1 = 2 * PuntoPivotDaily - HighD1;

                  rD3 = HighD1 + 2 * (PuntoPivotDaily - LowD1);
                  rD2 = PuntoPivotDaily + (rD1 - sD1);

                  sD2 = PuntoPivotDaily - (rD1 - sD1);
                  sD3 = LowD1 - 2 * (HighD1 - PuntoPivotDaily);
                 }
               if(PivotDaily==0)   //(PivotDaily==false)
                 {
                  rD1=0;
                  sD1=0;
                  rD2=0;
                  sD2=0;
                  rD3=0;
                  sD3=0;
                 }
               //+------------------------------------------------------------------+
               //|                   Pivot Weekly                                   |
               //+------------------------------------------------------------------+
               HighM1= iHigh(Symbol(),PERIOD_MN1,1);

               LowM1= iLow(Symbol(),PERIOD_MN1,1);

               HighW1= iHigh(Symbol(),PERIOD_W1,1);

               LowW1=  iLow(Symbol(),PERIOD_W1,1);

               OpenW1= iOpen(Symbol(),PERIOD_W1,1);

               CloseW1= iClose(Symbol(),PERIOD_W1,1);

               HighP[0]=iHigh(Symbol(),PERIOD_D1,1);

               LowP[0]=iLow(Symbol(),PERIOD_D1,1);

               //+------------------------------------------------------------------+
               //|     Tipo Pivot Weekly:  1=/2, 2=/3 == TypePivW                   |
               //|          Valore Pivot W = priceW                                 |
               //+------------------------------------------------------------------+

               if(TypePivW == 1)
                  priceW = (LowW1+HighW1)/2;
               if(TypePivW == 2)
                  priceW = (LowW1+HighW1+CloseW1)/3;


               double PuntoPivotWeekly = (HighW1 + CloseW1 + LowW1) / 3;
               rW1 = 2 * PuntoPivotWeekly - LowW1;
               sW1 = 2 * PuntoPivotWeekly - HighW1;

               rW3 = HighW1 + 2 * (PuntoPivotWeekly - LowW1);
               rW2 = PuntoPivotWeekly + (rW1 - sW1);

               sW2 = PuntoPivotWeekly - (rW1 - sW1);
               sW3 = LowW1 - 2 * (HighW1 -PuntoPivotWeekly);


               prezzoPivot = PRiceIn;
               
               GannInputDigit_ = gannInputDigit;
               Divis_ = DIVIS;

               gannObj gann(price,gannInputDigit,iClose(Symbol(),PERIOD_CURRENT,1),Digits());

               R1Pricee = gann.getresistance1();
               R2Pricee=gann.getresistance2();
               R3Pricee=gann.getresistance3();
               R4Pricee=gann.getresistance4();
               R5Pricee=gann.getresistance5();

               S1Pricee=gann.getsupport1();
               S2Pricee=gann.getsupport2();
               S3Pricee=gann.getsupport3();
               S4Pricee=gann.getsupport4();
               S5Pricee=gann.getsupport5();


               ResSuppGann[4] = R1Pricee = primoLevBuy ;
               ResSuppGann[3] = R2Pricee = secondoLevBuy;
               ResSuppGann[2] = R3Pricee = terzoLevBuy;
               ResSuppGann[1] = R4Pricee = quartoLevBuy;
               ResSuppGann[0] = R5Pricee = quintoLevBuy;

               ResSuppGann[5] = S1Pricee = primoLevSell;
               ResSuppGann[6] = S2Pricee = secondoLevSell;
               ResSuppGann[7] = S3Pricee = terzoLevSell;
               ResSuppGann[8] = S4Pricee = quartoLevSell;
               ResSuppGann[9] = S5Pricee = quintoLevSell;


               if(showGann_&& VisibiliInChart)
                 {
                  if(shortLines)
                     DrawRectangleLine();
                  else
                     DrawHorizontalLine();
                  WriteLineName();
                  CheckAlarmPrice();
                 }

   return(rates_total);
  }

//+------------------------- prezzonormalizzato(price,DIVIS) ----------------------+
double prezzonormalizzato(double prezzo,int divmolt)
{
double a=0;
static int decimali = Digits();
double senzavirgole = Ask(NULL)*moltilica();
Print(" senza virgola ",senzavirgole);
a = senzavirgole * Div_(divmolt);;
Print(" prezzo divmolt ",a);

return a;
}

double moltilica()
{
double a = 1;
for(int i = 0;i<Digits();i++)
{
a=a*10;
}
Print(" moltiplica ",a);
return a;
}

//+-------------------------ZIGZAGHiLo()-----------------------------+
double ZIGZAGHiLo()
  {
   double a = 0;

   ArrayInitialize(ValZZ,0);ArrayInitialize(IndexZZ,0);

   zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,MinCandZZ,periodZigzag,ValZZ,IndexZZ);  
  
if(tipopiccozigzag(ValZZ[0],IndexZZ[0],periodZigzag)=="Up")
      {
       if(tipoDiCandelaN(IndexZZ[0])=="Buy")  a = iClose(Symbol(),periodZigzag,IndexZZ[0]);
       if(tipoDiCandelaN(IndexZZ[0])=="Sell") a = iOpen(Symbol(),periodZigzag,IndexZZ[0]);
      }
if(tipopiccozigzag(ValZZ[0],IndexZZ[0],periodZigzag)=="Dw")
      {
       if(tipoDiCandelaN(IndexZZ[0])=="Buy")  a = iOpen(Symbol(),periodZigzag,IndexZZ[0]);
       if(tipoDiCandelaN(IndexZZ[0])=="Sell") a = iClose(Symbol(),periodZigzag,IndexZZ[0]);
      }

   return a;
  }  
//+------------------------------------------------------------------+Restituisce il valore dell'ultimo High oppure Low del giorno precedente e
//|                          lastPikDayprew_()                       | se shadow_body==0 : restituisce il picco shadow
//+------------------------------------------------------------------+ se shadow_body==1 : restituisce il picco body 
double lastPikDayprew_(int shadow_body)
   {
   double lastPik=0;
   string  DateTScans=(string)iTime(Symbol(),PERIOD_CURRENT,1);
   string  DayShift=StringSubstr((string)TimeDay(1,Symbol()),0,10);
   int BarMax=0;
   int BarMin=2000;
   for(int i=0;i<=1200;i++)
   {
   DateTScans= StringSubstr((string)iTime(Symbol(),PERIOD_CURRENT,i),0,10); 
   if(StringCompare(DateTScans,DayShift)==0)
   {
   if(i>BarMax&&i!=0){BarMax=i;}    
   if(i<BarMin&&i!=0){BarMin=i;}    
   }}   //Print(" BarMax: ",BarMax," BarMin: ",BarMin);
   BarMax=BarMax-BarMin;
   int high=iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,BarMax,BarMin);//Print(" high: ",high);
   int low =iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,BarMax,BarMin);//Print(" low: ",low);
   if(shadow_body == 0 && high<low)lastPik=iHigh(Symbol(),PERIOD_CURRENT,high); //Print(" high: ",iHigh(Symbol(),PERIOD_CURRENT,high));Print(" low: ",iLow(Symbol(),PERIOD_CURRENT,low));
   if(shadow_body == 0 && low<high)lastPik=iLow(Symbol(),PERIOD_CURRENT,low);//Print(" lastPik: ",lastPik);
   
   if(shadow_body == 1 && high<low)
      {
       if(tipoDiCandelaN(high)=="Buy")  lastPik=iClose(Symbol(),PERIOD_CURRENT,high);
       if(tipoDiCandelaN(high)=="Sell") lastPik=iOpen(Symbol(),PERIOD_CURRENT,high);
       } //Print(" high: ",iHigh(Symbol(),PERIOD_CURRENT,high));Print(" low: ",iLow(Symbol(),PERIOD_CURRENT,low));
   if(shadow_body == 1 && low<high)
   {
   if(tipoDiCandelaN(low)=="Buy")  lastPik=iOpen(Symbol(),PERIOD_CURRENT,low);//Print(" lastPik: ",lastPik); 
   if(tipoDiCandelaN(low)=="Sell") lastPik=iClose(Symbol(),PERIOD_CURRENT,low);//Print(" lastPik: ",lastPik);   
   }
   return lastPik;
   } 


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawHorizontalLine()
  {

   datetime Time5[1];
   CopyTime(Symbol(),PERIOD_D1,0,1,Time5);


   if(R5Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R5")<0)
         ObjectCreate(0,Pcode+"R5", OBJ_HLINE, 0, Time5[0], R5Pricee);
      else
         ObjectMove(0,Pcode+"R5",0,Time5[0],R5Pricee);

      ObjectSetInteger(0,Pcode+"R5", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_HIDDEN, true);
     }

   if(R4Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R4")<0)
         ObjectCreate(0,Pcode+"R4", OBJ_HLINE, 0, Time5[0], R4Pricee);
      else
         ObjectMove(0,Pcode+"R4",0,Time5[0],R4Pricee);

      ObjectSetInteger(0,Pcode+"R4", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_HIDDEN, true);
     }

   if(R3Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R3")<0)
         ObjectCreate(0,Pcode+"R3", OBJ_HLINE, 0, Time5[0], R3Pricee);
      else
         ObjectMove(0,Pcode+"R3",0,Time5[0],R3Pricee);

      ObjectSetInteger(0,Pcode+"R3", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_HIDDEN, true);
     }

   if(R2Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R2")<0)
         ObjectCreate(0,Pcode+"R2", OBJ_HLINE, 0, Time5[0], R2Pricee);
      else
         ObjectMove(0,Pcode+"R2",0,Time5[0],R2Pricee);

      ObjectSetInteger(0,Pcode+"R2", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_HIDDEN, true);
     }

   if(R1Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R1")<0)
         ObjectCreate(0,Pcode+"R1", OBJ_HLINE, 0, Time5[0], R1Pricee);
      else
         ObjectMove(0,Pcode+"R1",0,Time5[0],R1Pricee);

      ObjectSetInteger(0,Pcode+"R1", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_HIDDEN, true);
     }

   if(compraSopra!=0)
     {
      if(ObjectFind(0,Pcode+"Compra Sopra")<0)
         ObjectCreate(0,Pcode+"Compra Sopra", OBJ_HLINE, 0, Time5[0], compraSopra);
      else
         ObjectMove(0,Pcode+"Compra Sopra",0,Time5[0],compraSopra);

      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_COLOR, clrGold);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_HIDDEN, true);
     }


   if(PRiceIn!=0)
     {
      if(ObjectFind(0,Pcode+"Pivot Line")<0)
         ObjectCreate(0,Pcode+"Pivot Line", OBJ_HLINE, 0, Time5[0], PRiceIn);
      else
         ObjectMove(0,Pcode+"Pivot Line",0,Time5[0],PRiceIn);

      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_COLOR, clrTurquoise);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_HIDDEN, true);
     }

   if(priceW!=0)
     {
      if(ObjectFind(0,Pcode+"PivotW")<0)
         ObjectCreate(0,Pcode+"PivotW", OBJ_HLINE, 0, Time5[0], priceW);
      else
         ObjectMove(0,Pcode+"PivotW",0,Time5[0],priceW);

      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_HIDDEN, true);
     }

   if(PivDay!=0)
     {
      if(ObjectFind(0,Pcode+"PivDay")<0)
         ObjectCreate(0,Pcode+"PivDay", OBJ_HLINE, 0, Time5[0], PivDay);
      else
         ObjectMove(0,Pcode+"PivDay",0,Time5[0],PivDay);

      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_COLOR, clrPink);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_HIDDEN, true);
     }

   if(rD3!=0)
     {
      if(ObjectFind(0,Pcode+"RD3")<0)
         ObjectCreate(0,Pcode+"RD3", OBJ_HLINE, 0, Time5[0], rD3);
      else
         ObjectMove(0,Pcode+"RD3",0,Time5[0],rD3);

      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_HIDDEN, true);
     }
   if(sD3!=0)
     {
      if(ObjectFind(0,Pcode+"SD3")<0)
         ObjectCreate(0,Pcode+"SD3", OBJ_HLINE, 0, Time5[0], sD3);
      else
         ObjectMove(0,Pcode+"SD3",0,Time5[0],sD3);

      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_HIDDEN, true);
     }

   if(rD2!=0)
     {
      if(ObjectFind(0,Pcode+"RD2")<0)
         ObjectCreate(0,Pcode+"RD2", OBJ_HLINE, 0, Time5[0], rD2);
      else
         ObjectMove(0,Pcode+"RD2",0,Time5[0],rD2);

      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_HIDDEN, true);
     }

   if(sD2!=0)
     {
      if(ObjectFind(0,Pcode+"SD2")<0)
         ObjectCreate(0,Pcode+"SD2", OBJ_HLINE, 0, Time5[0], sD2);
      else
         ObjectMove(0,Pcode+"SD2",0,Time5[0],sD2);

      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_HIDDEN, true);
     }

   if(rD1!=0)
     {
      if(ObjectFind(0,Pcode+"RD1")<0)
         ObjectCreate(0,Pcode+"RD1", OBJ_HLINE, 0, Time5[0], rD1);
      else
         ObjectMove(0,Pcode+"RD1",0,Time5[0],rD1);

      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_HIDDEN, true);
     }
   if(sD1!=0)
     {
      if(ObjectFind(0,Pcode+"SD1")<0)
         ObjectCreate(0,Pcode+"SD1", OBJ_HLINE, 0, Time5[0], sD1);
      else
         ObjectMove(0,Pcode+"SD1",0,Time5[0],sD1);

      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_HIDDEN, true);
     }



   if(vendiSotto!=0)
     {
      if(ObjectFind(0,Pcode+"Vendi Sotto")<0)
         ObjectCreate(0,Pcode+"Vendi Sotto", OBJ_HLINE, 0, Time5[0], vendiSotto);
      else
         ObjectMove(0,Pcode+"Vendi Sotto",0,Time5[0],vendiSotto);

      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_COLOR, clrLawnGreen);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }                                                        /////////////////////////////////////////////////


   if(S1Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S1")<0)
         ObjectCreate(0,Pcode+"S1", OBJ_HLINE, 0, Time5[0], S1Pricee);
      else
         ObjectMove(0,Pcode+"S1",0,Time5[0],S1Pricee);

      ObjectSetInteger(0,Pcode+"S1", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_HIDDEN, true);
     }

   if(S2Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S2")<0)
         ObjectCreate(0,Pcode+"S2", OBJ_HLINE, 0, Time5[0], S2Pricee);
      else
         ObjectMove(0,Pcode+"S2",0,Time5[0],S2Pricee);

      ObjectSetInteger(0,Pcode+"S2", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_HIDDEN, true);
     }

   if(S3Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S3")<0)
         ObjectCreate(0,Pcode+"S3", OBJ_HLINE, 0, Time5[0], S3Pricee);
      else
         ObjectMove(0,Pcode+"S3",0,Time5[0],S3Pricee);

      ObjectSetInteger(0,Pcode+"S3", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_HIDDEN, true);
     }

   if(S4Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S4")<0)
         ObjectCreate(0,Pcode+"S4", OBJ_HLINE, 0, Time5[0], S4Pricee);
      else
         ObjectMove(0,Pcode+"S4",0,Time5[0],S4Pricee);

      ObjectSetInteger(0,Pcode+"S4", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_HIDDEN, true);
     }

   if(S5Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S5")<0)
         ObjectCreate(0,Pcode+"S5", OBJ_HLINE, 0, Time5[0], S5Pricee);
      else
         ObjectMove(0,Pcode+"S5",0,Time5[0],S5Pricee);

      ObjectSetInteger(0,Pcode+"S5", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_HIDDEN, true);
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawRectangleLine()
  {
   datetime time1,time2,Time5[1];

   Time5[0]=0;
   CopyTime(Symbol(),PERIOD_CURRENT,0,1,Time5);
   time1 = Time5[0]-(PeriodSeconds(Period())*50);

   CopyTime(Symbol(),Period(),0,1,Time5);
   time2 = Time5[0]+(PeriodSeconds(Period())*50);

   if(R5Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R5")<0)
         ObjectCreate(0,Pcode+"R5", OBJ_RECTANGLE, 0, time1, R5Pricee, time2, R5Pricee);
      else
        {
         ObjectMove(0,Pcode+"R5",0,time1,R5Pricee);
         ObjectMove(0,Pcode+"R5",1,time2,R5Pricee);
        }

      ObjectSetInteger(0,Pcode+"R5", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R5", OBJPROP_HIDDEN, true);
     }

   if(R4Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R4")<0)
        {
         ObjectCreate(0,Pcode+"R4", OBJ_RECTANGLE,0,time1,R4Pricee,time2,R4Pricee);

        }
      else
        {
         ObjectMove(0,Pcode+"R4",0,time1,R4Pricee);
         ObjectMove(0,Pcode+"R4",1,time2,R4Pricee);
        }

      ObjectSetInteger(0,Pcode+"R4", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R4", OBJPROP_HIDDEN, true);

     }

   if(R3Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R3")<0)
         ObjectCreate(0,Pcode+"R3", OBJ_RECTANGLE,0,time1,R3Pricee,time2,R3Pricee);
      else
        {
         ObjectMove(0,Pcode+"R3",0,time1,R3Pricee);
         ObjectMove(0,Pcode+"R3",1,time2,R3Pricee);
        }
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R3", OBJPROP_HIDDEN, true);

     }

   if(R2Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R2")<0)
         ObjectCreate(0,Pcode+"R2", OBJ_RECTANGLE,0,time1,R2Pricee,time2,R2Pricee);
      else
        {
         ObjectMove(0,Pcode+"R2",0,time1,R2Pricee);
         ObjectMove(0,Pcode+"R2",1,time2,R2Pricee);
        }

      ObjectSetInteger(0,Pcode+"R2", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R2", OBJPROP_HIDDEN, true);

     }

   if(R1Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"R1")<0)
         ObjectCreate(0,Pcode+"R1", OBJ_RECTANGLE,0,time1,R1Pricee,time2,R1Pricee);
      else
        {
         ObjectMove(0,Pcode+"R1",0,time1,R1Pricee);
         ObjectMove(0,Pcode+"R1",1,time2,R1Pricee);
        }

      ObjectSetInteger(0,Pcode+"R1", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_COLOR, resistanceColor);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"R1", OBJPROP_HIDDEN, true);
     }

   if(compraSopra!=0)
     {
      if(ObjectFind(0,Pcode+"Compra Sopra")<0)
         ObjectCreate(0,Pcode+"Compra Sopra", OBJ_RECTANGLE,0,time1,compraSopra,time2,compraSopra);
      else
        {
         ObjectMove(0,Pcode+"Compra Sopra",0,time1,compraSopra);
         ObjectMove(0,Pcode+"Compra Sopra",1,time2,compraSopra);
        }

      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_COLOR, clrGold);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"Compra Sopra", OBJPROP_HIDDEN, true);
     }

   if(PRiceIn!=0)
     {
      if(ObjectFind(0,Pcode+"Pivot Line")<0)
         ObjectCreate(0,Pcode+"Pivot Line", OBJ_RECTANGLE,0,time1,PRiceIn,time2,PRiceIn);
      else
        {
         ObjectMove(0,Pcode+"Pivot Line",0,time1,PRiceIn);
         ObjectMove(0,Pcode+"Pivot Line",1,time2,PRiceIn);
        }

      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_COLOR, clrTurquoise);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"Pivot Line", OBJPROP_HIDDEN, true);
     }


   if(priceW!=0)
     {
      if(ObjectFind(0,Pcode+"PivotW")<0)
         ObjectCreate(0,Pcode+"PivotW", OBJ_RECTANGLE,0,time1,priceW,time2,priceW);
      else
        {
         ObjectMove(0,Pcode+"PivotW",0,time1,priceW);
         ObjectMove(0,Pcode+"PivotW",1,time2,priceW);
        }

      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"PivotW", OBJPROP_HIDDEN, true);
     }

   if(PivDay!=0)
     {
      if(ObjectFind(0,Pcode+"PivDay")<0)
         ObjectCreate(0,Pcode+"PivDay", OBJ_RECTANGLE,0,time1,PivDay,time2,PivDay);
      else
        {
         ObjectMove(0,Pcode+"PivDay",0,time1,PivDay);
         ObjectMove(0,Pcode+"PivDay",1,time2,PivDay);
        }

      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_COLOR, clrPink);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"PivDay", OBJPROP_HIDDEN, true);
     }


   if(rD3!=0)
     {
      if(ObjectFind(0,Pcode+"RD3")<0)
         ObjectCreate(0,Pcode+"RD3", OBJ_RECTANGLE,0,time1,rD3,time2,rD3);
      else
        {
         ObjectMove(0,Pcode+"RD3",0,time1,rD3);
         ObjectMove(0,Pcode+"RD3",1,time2,rD3);
        }

      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"RD3", OBJPROP_HIDDEN, true);
     }

   if(sD3!=0)
     {
      if(ObjectFind(0,Pcode+"SD3")<0)
         ObjectCreate(0,Pcode+"SD3", OBJ_RECTANGLE,0,time1,sD3,time2,sD3);
      else
        {
         ObjectMove(0,Pcode+"SD3",0,time1,sD3);
         ObjectMove(0,Pcode+"SD3",1,time2,sD3);
        }

      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"SD3", OBJPROP_HIDDEN, true);
     }


   if(rD2!=0)
     {
      if(ObjectFind(0,Pcode+"RD2")<0)
         ObjectCreate(0,Pcode+"RD2", OBJ_RECTANGLE,0,time1,rD2,time2,rD2);
      else
        {
         ObjectMove(0,Pcode+"RD2",0,time1,rD2);
         ObjectMove(0,Pcode+"RD2",1,time2,rD2);
        }

      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"RD2", OBJPROP_HIDDEN, true);
     }

   if(sD2!=0)
     {
      if(ObjectFind(0,Pcode+"SD2")<0)
         ObjectCreate(0,Pcode+"SD2", OBJ_RECTANGLE,0,time1,sD2,time2,sD2);
      else
        {
         ObjectMove(0,Pcode+"SD2",0,time1,sD2);
         ObjectMove(0,Pcode+"SD2",1,time2,sD2);
        }

      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"SD2", OBJPROP_HIDDEN, true);
     }

   if(sD1!=0)
     {
      if(ObjectFind(0,Pcode+"SD1")<0)
         ObjectCreate(0,Pcode+"SD1", OBJ_RECTANGLE,0,time1,sD1,time2,sD1);
      else
        {
         ObjectMove(0,Pcode+"SD1",0,time1,sD1);
         ObjectMove(0,Pcode+"SD1",1,time2,sD1);
        }

      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"SD1", OBJPROP_HIDDEN, true);
     }

   if(rD1!=0)
     {
      if(ObjectFind(0,Pcode+"RD1")<0)
         ObjectCreate(0,Pcode+"RD1", OBJ_RECTANGLE,0,time1,rD1,time2,rD1);
      else
        {
         ObjectMove(0,Pcode+"RD1",0,time1,rD1);
         ObjectMove(0,Pcode+"RD1",1,time2,rD1);
        }

      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_WIDTH, resistanceWidth);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_COLOR, clrCyan);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_STYLE, resistanceType);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"RD1", OBJPROP_HIDDEN, true);
     }

   if(vendiSotto!=0)
     {
      if(ObjectFind(0,Pcode+"Vendi Sotto")<0)
         ObjectCreate(0,Pcode+"Vendi Sotto", OBJ_RECTANGLE,0,time1,vendiSotto,time2,vendiSotto);
      else
        {
         ObjectMove(0,Pcode+"Vendi Sotto",0,time1,vendiSotto);
         ObjectMove(0,Pcode+"Vendi Sotto",1,time2,vendiSotto);
        }

      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_COLOR, clrLawnGreen);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }


   if(S1Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S1")<0)
         ObjectCreate(0,Pcode+"S1", OBJ_RECTANGLE,0,time1,S1Pricee,time2,S1Pricee);
      else
        {
         ObjectMove(0,Pcode+"S1",0,time1,S1Pricee);
         ObjectMove(0,Pcode+"S1",1,time2,S1Pricee);
        }
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S1", OBJPROP_HIDDEN, true);
     }

   if(S2Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S2")<0)
         ObjectCreate(0,Pcode+"S2", OBJ_RECTANGLE,0,time1,S2Pricee,time2,S2Pricee);
      else
        {
         ObjectMove(0,Pcode+"S2",0,time1,S2Pricee);
         ObjectMove(0,Pcode+"S2",1,time2,S2Pricee);
        }

      ObjectSetInteger(0,Pcode+"S2", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S2", OBJPROP_HIDDEN, true);

     }

   if(S3Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S3")<0)
         ObjectCreate(0,Pcode+"S3", OBJ_RECTANGLE,0,time1,S3Pricee,time2,S3Pricee);
      else
        {
         ObjectMove(0,Pcode+"S3",0,time1,S3Pricee);
         ObjectMove(0,Pcode+"S3",1,time2,S3Pricee);
        }

      ObjectSetInteger(0,Pcode+"S3", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S3", OBJPROP_HIDDEN, true);


     }

   if(S4Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S4")<0)
         ObjectCreate(0,Pcode+"S4", OBJ_RECTANGLE,0,time1,S4Pricee,time2,S4Pricee);
      else
        {
         ObjectMove(0,Pcode+"S4",0,time1,S4Pricee);
         ObjectMove(0,Pcode+"S4",1,time2,S4Pricee);
        }

      ObjectSetInteger(0,Pcode+"S4", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S4", OBJPROP_HIDDEN, true);


     }

   if(S5Pricee!=0)
     {
      if(ObjectFind(0,Pcode+"S5")<0)
        {
         ObjectCreate(0,Pcode+"S5", OBJ_RECTANGLE,0,time1,S5Pricee,time2,S5Pricee);
        }
      else
        {
         ObjectMove(0,Pcode+"S5",0,time1,S5Pricee);
         ObjectMove(0,Pcode+"S5",1,time2,S5Pricee);
        }

      ObjectSetInteger(0,Pcode+"S5", OBJPROP_WIDTH, supportWidth);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_COLOR, supportColor);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_STYLE, supportType);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_BACK, drawBackground);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_SELECTABLE, !disableSelection);
      ObjectSetInteger(0,Pcode+"S5", OBJPROP_HIDDEN, true);

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteLineName()
  {

   datetime time2,Time5[1];

   Time5[0]=0;

   CopyTime(Symbol(),Period(),0,1,Time5);

   if(!MQLInfoInteger(MQL_TESTER))
     {
      if(!ChartGetInteger(0,CHART_SHIFT,0))
        {
         time2 = Time5[0]-(PeriodSeconds(Period())*8);
        }
      else
        {
         time2 = Time5[0]+(PeriodSeconds(Period())*8);
        }
     }
   else
     {
      if(!ChartGetInteger(0,CHART_SHIFT,0))
        {
         time2 = Time5[0]-(PeriodSeconds(Period())*8);
        }
      else
        {
         time2 = Time5[0]+(PeriodSeconds(Period()));
        }
     }



   if(showLineName)
     {

      if(R5Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"R5T")<0)
           {
            ObjectCreate(0,Pcode+"R5T", OBJ_TEXT,0,time2,R5Pricee);
            ObjectSetString(0,Pcode+"R5T",OBJPROP_TEXT,Pcode+"R5 "+DoubleToString(NormalizeDouble(R5Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"R5T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"R5T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"R5T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"R5T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"R5T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"R5T",0,time2,R5Pricee);
            ObjectSetString(0,Pcode+"R5T",OBJPROP_TEXT,Pcode+"R5 "+DoubleToString(NormalizeDouble(R5Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"R5T",OBJPROP_COLOR,resistanceColor);
        }

      if(R4Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"R4T")<0)
           {
            ObjectCreate(0,Pcode+"R4T", OBJ_TEXT,0,time2,R4Pricee);
            ObjectSetString(0,Pcode+"R4T",OBJPROP_TEXT,Pcode+"R4 "+DoubleToString(NormalizeDouble(R4Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"R4T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"R4T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"R4T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"R4T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"R4T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"R4T",0,time2,R4Pricee);
            ObjectSetString(0,Pcode+"R4T",OBJPROP_TEXT,Pcode+"R4 "+DoubleToString(NormalizeDouble(R4Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"R4T",OBJPROP_COLOR,resistanceColor);
        }

      if(R3Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"R3T")<0)
           {
            ObjectCreate(0,Pcode+"R3T", OBJ_TEXT,0,time2,R3Pricee);
            ObjectSetString(0,Pcode+"R3T",OBJPROP_TEXT,Pcode+"R3 "+DoubleToString(NormalizeDouble(R3Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"R3T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"R3T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"R3T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"R3T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"R3T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"R3T",0,time2,R3Pricee);
            ObjectSetString(0,Pcode+"R3T",OBJPROP_TEXT,Pcode+"R3 "+DoubleToString(NormalizeDouble(R3Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"R3T",OBJPROP_COLOR,resistanceColor);
        }

      if(R2Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"R2T")<0)
           {
            ObjectCreate(0,Pcode+"R2T", OBJ_TEXT,0,time2,R2Pricee);
            ObjectSetString(0,Pcode+"R2T",OBJPROP_TEXT,Pcode+"R2 "+DoubleToString(NormalizeDouble(R2Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"R2T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"R2T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"R2T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"R2T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"R2T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"R2T",0,time2,R2Pricee);
            ObjectSetString(0,Pcode+"R2T",OBJPROP_TEXT,Pcode+"R2 "+DoubleToString(NormalizeDouble(R2Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"R2T",OBJPROP_COLOR,resistanceColor);
        }

      if(R1Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"R1T")<0)
           {
            ObjectCreate(0,Pcode+"R1T", OBJ_TEXT,0,time2,R1Pricee);
            ObjectSetString(0,Pcode+"R1T",OBJPROP_TEXT,Pcode+"R1 "+DoubleToString(NormalizeDouble(R1Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"R1T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"R1T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"R1T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"R1T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"R1T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"R1T",0,time2,R1Pricee);
            ObjectSetString(0,Pcode+"R1T",OBJPROP_TEXT,Pcode+"R1 "+DoubleToString(NormalizeDouble(R1Pricee,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"R1T",OBJPROP_COLOR,resistanceColor);
        }



      if(compraSopra!=0)
        {Comment("Buy Above "+(string)compraSopra);
         if(ObjectFind(0,Pcode+"Buy_Above")<0)
           {
            ObjectCreate(0,Pcode+"Buy_Above", OBJ_TEXT,0,time2,compraSopra);
            ObjectSetString(0,Pcode+"Buy_Above",OBJPROP_TEXT,Pcode+"Buy_Above"+DoubleToString(NormalizeDouble(compraSopra,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Buy_Above",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Buy_Above",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Buy_Above",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"Buy_Above",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"Buy_Above",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Buy_Above",0,time2,compraSopra);
            ObjectSetString(0,Pcode+"Buy_Above",OBJPROP_TEXT,Pcode+"Buy_Above  "+DoubleToString(NormalizeDouble(compraSopra,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"Buy_Above",OBJPROP_COLOR,Gold);
        }


      if(PRiceIn!=0)
        {
         if(ObjectFind(0,Pcode+"Pivot")<0)
           {
            ObjectCreate(0,Pcode+"Pivot", OBJ_TEXT,0,time2,PRiceIn);
            ObjectSetString(0,Pcode+"Pivot",OBJPROP_TEXT,Pcode+"Pivot"+DoubleToString(NormalizeDouble(PRiceIn,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Pivot",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Pivot",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Pivot",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"Pivot",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"Pivot",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Pivot",0,time2,PRiceIn);
            ObjectSetString(0,Pcode+"Pivot",OBJPROP_TEXT,Pcode+"Pivot  "+DoubleToString(NormalizeDouble(PRiceIn,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"Pivot",OBJPROP_COLOR,clrTurquoise);
        }


      if(priceW!=0)
        {
         if(ObjectFind(0,Pcode+"PivotWeek")<0)
           {
            ObjectCreate(0,Pcode+"PivotWeek", OBJ_TEXT,0,time2,priceW);
            ObjectSetString(0,Pcode+"PivotWeek",OBJPROP_TEXT,Pcode+"PivotWeek"+DoubleToString(NormalizeDouble(priceW,Digits()),Digits()));
            ObjectSetString(0,Pcode+"PivotWeek",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"PivotWeek",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"PivotWeek",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"PivotWeek",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"PivotWeek",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"PivotWeek",0,time2,priceW);
            ObjectSetString(0,Pcode+"PivotWeek",OBJPROP_TEXT,Pcode+"PivotWeek "+DoubleToString(NormalizeDouble(priceW,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"PivotWeek",OBJPROP_COLOR,clrYellow);
        }

      if(PivDay!=0)
        {
         if(ObjectFind(0,Pcode+"PivotD")<0)
           {
            ObjectCreate(0,Pcode+"PivotD", OBJ_TEXT,0,time2,PivDay);
            ObjectSetString(0,Pcode+"PivotD",OBJPROP_TEXT,Pcode+"PivotD"+DoubleToString(NormalizeDouble(PivDay,Digits()),Digits()));
            ObjectSetString(0,Pcode+"PivotD",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"PivotD",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"PivotD",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"PivotD",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"PivotD",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"PivotD",0,time2,PivDay);
            ObjectSetString(0,Pcode+"PivotD",OBJPROP_TEXT,Pcode+"PivDay "+DoubleToString(NormalizeDouble(PivDay,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"PivotD",OBJPROP_COLOR,clrPink);
        }


      if(rD3!=0)
        {
         if(ObjectFind(0,Pcode+"rD3")<0)
           {
            ObjectCreate(0,Pcode+"rD3", OBJ_TEXT,0,time2,rD3);
            ObjectSetString(0,Pcode+"rD3",OBJPROP_TEXT,Pcode+"rD3"+DoubleToString(NormalizeDouble(rD3,Digits()),Digits()));
            ObjectSetString(0,Pcode+"rD3",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"rD3",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"rD3",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"rD3",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"rD3",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"rD3",0,time2,rD3);
            ObjectSetString(0,Pcode+"rD3",OBJPROP_TEXT,Pcode+"rD3 "+DoubleToString(NormalizeDouble(rD3,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"rD3",OBJPROP_COLOR,clrCyan);
        }
      if(sD3!=0)
        {
         if(ObjectFind(0,Pcode+"sD3")<0)
           {
            ObjectCreate(0,Pcode+"sD3", OBJ_TEXT,0,time2,sD3);
            ObjectSetString(0,Pcode+"sD3",OBJPROP_TEXT,Pcode+"sD3"+DoubleToString(NormalizeDouble(sD3,Digits()),Digits()));
            ObjectSetString(0,Pcode+"sD3",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"sD3",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"sD3",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"sD3",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"sD3",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"sD3",0,time2,sD3);
            ObjectSetString(0,Pcode+"sD3",OBJPROP_TEXT,Pcode+"sD3 "+DoubleToString(NormalizeDouble(sD3,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"sD3",OBJPROP_COLOR,clrCyan);
        }


      if(rD2!=0)
        {
         if(ObjectFind(0,Pcode+"rD2")<0)
           {
            ObjectCreate(0,Pcode+"rD2", OBJ_TEXT,0,time2,rD2);
            ObjectSetString(0,Pcode+"rD2",OBJPROP_TEXT,Pcode+"rD2"+DoubleToString(NormalizeDouble(rD2,Digits()),Digits()));
            ObjectSetString(0,Pcode+"rD2",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"rD2",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"rD2",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"rD2",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"rD2",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"rD2",0,time2,rD2);
            ObjectSetString(0,Pcode+"rD2",OBJPROP_TEXT,Pcode+"rD2 "+DoubleToString(NormalizeDouble(rD2,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"rD2",OBJPROP_COLOR,clrCyan);
        }

      if(sD2!=0)
        {
         if(ObjectFind(0,Pcode+"sD2")<0)
           {
            ObjectCreate(0,Pcode+"sD2", OBJ_TEXT,0,time2,sD2);
            ObjectSetString(0,Pcode+"sD2",OBJPROP_TEXT,Pcode+"sD2"+DoubleToString(NormalizeDouble(sD2,Digits()),Digits()));
            ObjectSetString(0,Pcode+"sD2",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"sD2",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"sD2",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"sD2",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"sD2",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"sD2",0,time2,sD2);
            ObjectSetString(0,Pcode+"sD2",OBJPROP_TEXT,Pcode+"sD2 "+DoubleToString(NormalizeDouble(sD2,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"sD2",OBJPROP_COLOR,clrCyan);
        }

      if(sD1!=0)
        {
         if(ObjectFind(0,Pcode+"sD1")<0)
           {
            ObjectCreate(0,Pcode+"sD1", OBJ_TEXT,0,time2,sD1);
            ObjectSetString(0,Pcode+"sD1",OBJPROP_TEXT,Pcode+"sD1"+DoubleToString(NormalizeDouble(sD1,Digits()),Digits()));
            ObjectSetString(0,Pcode+"sD1",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"sD1",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"sD1",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"sD1",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"sD1",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"sD1",0,time2,sD1);
            ObjectSetString(0,Pcode+"sD1",OBJPROP_TEXT,Pcode+"sD1 "+DoubleToString(NormalizeDouble(sD1,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"sD1",OBJPROP_COLOR,clrCyan);
        }

      if(rD1!=0)
        {
         if(ObjectFind(0,Pcode+"rD1")<0)
           {
            ObjectCreate(0,Pcode+"rD1", OBJ_TEXT,0,time2,rD1);
            ObjectSetString(0,Pcode+"rD1",OBJPROP_TEXT,Pcode+"rD1"+DoubleToString(NormalizeDouble(rD1,Digits()),Digits()));
            ObjectSetString(0,Pcode+"rD1",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"rD1",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"rD1",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"rD1",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"rD1",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"rD1",0,time2,rD1);
            ObjectSetString(0,Pcode+"rD1",OBJPROP_TEXT,Pcode+"rD1 "+DoubleToString(NormalizeDouble(rD1,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"rD1",OBJPROP_COLOR,clrCyan);
        }


      if(vendiSotto!=0)
        {
         if(ObjectFind(0,Pcode+"Sell_Below")<0)
           {
            ObjectCreate(0,Pcode+"Sell_Below", OBJ_TEXT,0,time2,vendiSotto);
            ObjectSetString(0,Pcode+"Sell_Below",OBJPROP_TEXT,Pcode+"Sell_Below"+DoubleToString(NormalizeDouble(vendiSotto,Digits()),Digits()));
            ObjectSetString(0,Pcode+"Sell_Below",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"Sell_Below",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"Sell_Below",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"Sell_Below",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"Sell_Below",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"Sell_Below",0,time2,vendiSotto);
            ObjectSetString(0,Pcode+"Sell_Below",OBJPROP_TEXT,Pcode+"Sell_Below  "+DoubleToString(NormalizeDouble(vendiSotto,Digits()),Digits()));
           }

         ObjectSetInteger(0,Pcode+"Sell_Below",OBJPROP_COLOR,clrLawnGreen);
        }



      if(S1Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"S1T")<0)
           {
            ObjectCreate(0,Pcode+"S1T", OBJ_TEXT,0,time2,S1Pricee);
            ObjectSetString(0,Pcode+"S1T",OBJPROP_TEXT,Pcode+"S1 "+DoubleToString(NormalizeDouble(S1Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"S1T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"S1T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"S1T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"S1T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"S1T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"S1T",0,time2,S1Pricee);
            ObjectSetString(0,Pcode+"S1T",OBJPROP_TEXT,Pcode+"S1 "+DoubleToString(NormalizeDouble(S1Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"S1T",OBJPROP_COLOR,supportColor);
        }

      if(S2Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"S2T")<0)
           {
            ObjectCreate(0,Pcode+"S2T", OBJ_TEXT,0,time2,S2Pricee);
            ObjectSetString(0,Pcode+"S2T",OBJPROP_TEXT,Pcode+"S2 "+DoubleToString(NormalizeDouble(S2Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"S2T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"S2T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"S2T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"S2T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"S2T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"S2T",0,time2,S2Pricee);
            ObjectSetString(0,Pcode+"S2T",OBJPROP_TEXT,Pcode+"S2 "+DoubleToString(NormalizeDouble(S2Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"S2T",OBJPROP_COLOR,supportColor);
        }

      if(S3Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"S3T")<0)
           {
            ObjectCreate(0,Pcode+"S3T", OBJ_TEXT,0,time2,S3Pricee);
            ObjectSetString(0,Pcode+"S3T",OBJPROP_TEXT,Pcode+"S3 "+DoubleToString(NormalizeDouble(S3Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"S3T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"S3T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"S3T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"S3T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"S3T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"S3T",0,time2,S3Pricee);
            ObjectSetString(0,Pcode+"S3T",OBJPROP_TEXT,Pcode+"S3 "+DoubleToString(NormalizeDouble(S3Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"S3T",OBJPROP_COLOR,supportColor);
        }

      if(S4Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"S4T")<0)
           {
            ObjectCreate(0,Pcode+"S4T", OBJ_TEXT,0,time2,S4Pricee);
            ObjectSetString(0,Pcode+"S4T",OBJPROP_TEXT,Pcode+"S4 "+DoubleToString(NormalizeDouble(S4Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"S4T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"S4T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"S4T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"S4T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"S4T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"S4T",0,time2,S4Pricee);
            ObjectSetString(0,Pcode+"S4T",OBJPROP_TEXT,Pcode+"S4 "+DoubleToString(NormalizeDouble(S4Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"S4T",OBJPROP_COLOR,supportColor);
        }

      if(S5Pricee!=0)
        {
         if(ObjectFind(0,Pcode+"S5T")<0)
           {
            ObjectCreate(0,Pcode+"S5T", OBJ_TEXT,0,time2,S5Pricee);
            ObjectSetString(0,Pcode+"S5T",OBJPROP_TEXT,Pcode+"S5 "+DoubleToString(NormalizeDouble(S5Pricee,Digits()),Digits()));
            ObjectSetString(0,Pcode+"S5T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,Pcode+"S5T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,Pcode+"S5T",OBJPROP_BACK,drawBackground);
            ObjectSetInteger(0,Pcode+"S5T",OBJPROP_SELECTABLE,!disableSelection);
            ObjectSetInteger(0,Pcode+"S5T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,Pcode+"S5T",0,time2,S5Pricee);
            ObjectSetString(0,Pcode+"S5T",OBJPROP_TEXT,Pcode+"S5 "+DoubleToString(NormalizeDouble(S5Pricee,Digits()),Digits()));
           }
         ObjectSetInteger(0,Pcode+"S5T",OBJPROP_COLOR,supportColor);
        }

     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetAlertMessage(double alertID, double price)
  {
   string point = "";
   if(alertID==0)
      point = "R5";
   if(alertID==1)
      point = "R4";
   if(alertID==2)
      point = "R3";
   if(alertID==3)
      point = "R2";
   if(alertID==4)
      point = "R1";
   if(alertID==5)
      point = "S1";
   if(alertID==6)
      point = "S2";
   if(alertID==7)
      point = "S3";
   if(alertID==8)
      point = "S4";
   if(alertID==9)
      point = "S5";

   if(alertID==10)
      point = "Compra Sopra";
   if(alertID==11)
      point = "Vendi Sotto";

   if(alertID==11)
      point = "PivotWeek";


   string message=Symbol()+" ("+DoubleToString(price)+"), the price arrived at "+Pcode+point;

   return message;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetAlertID(string alertName)
  {
   int _return=-1;

   if(alertName=="R5")
      _return = 0;
   if(alertName=="R4")
      _return = 1;
   if(alertName=="R3")
      _return = 2;
   if(alertName=="R2")
      _return = 3;
   if(alertName=="R1")
      _return = 4;
   if(alertName=="S1")
      _return = 5;
   if(alertName=="S2")
      _return = 6;
   if(alertName=="S3")
      _return = 7;
   if(alertName=="S4")
      _return = 8;
   if(alertName=="S5")
      _return = 9;

   if(alertName=="Compra Sopra")
      _return = 10;
   if(alertName=="Vendi Sotto")
      _return = 11;

   return _return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClearObj()
  {
   if(ObjectFind(0,Pcode+"R5")>=0)
      ObjectDelete(0,Pcode+"R5");
   if(ObjectFind(0,Pcode+"R4")>=0)
      ObjectDelete(0,Pcode+"R4");
   if(ObjectFind(0,Pcode+"R3")>=0)
      ObjectDelete(0,Pcode+"R3");
   if(ObjectFind(0,Pcode+"R2")>=0)
      ObjectDelete(0,Pcode+"R2");
   if(ObjectFind(0,Pcode+"R1")>=0)
      ObjectDelete(0,Pcode+"R1");



   if(ObjectFind(0,Pcode+"RD3")>=0)
      ObjectDelete(0,Pcode+"RD3");
   if(ObjectFind(0,Pcode+"RD2")>=0)
      ObjectDelete(0,Pcode+"RD2");
   if(ObjectFind(0,Pcode+"RD1")>=0)
      ObjectDelete(0,Pcode+"RD1");
   if(ObjectFind(0,Pcode+"rD3")>=0)
      ObjectDelete(0,Pcode+"rD3");
   if(ObjectFind(0,Pcode+"rD2")>=0)
      ObjectDelete(0,Pcode+"rD2");
   if(ObjectFind(0,Pcode+"rD1")>=0)
      ObjectDelete(0,Pcode+"rD1");

   if(ObjectFind(0,Pcode+"S1")>=0)
      ObjectDelete(0,Pcode+"S1");
   if(ObjectFind(0,Pcode+"S2")>=0)
      ObjectDelete(0,Pcode+"S2");
   if(ObjectFind(0,Pcode+"S3")>=0)
      ObjectDelete(0,Pcode+"S3");
   if(ObjectFind(0,Pcode+"S4")>=0)
      ObjectDelete(0,Pcode+"S4");
   if(ObjectFind(0,Pcode+"S5")>=0)
      ObjectDelete(0,Pcode+"S5");

   if(ObjectFind(0,Pcode+"R5T")>=0)
      ObjectDelete(0,Pcode+"R5T");
   if(ObjectFind(0,Pcode+"R4T")>=0)
      ObjectDelete(0,Pcode+"R4T");
   if(ObjectFind(0,Pcode+"R3T")>=0)
      ObjectDelete(0,Pcode+"R3T");
   if(ObjectFind(0,Pcode+"R2T")>=0)
      ObjectDelete(0,Pcode+"R2T");
   if(ObjectFind(0,Pcode+"R1T")>=0)
      ObjectDelete(0,Pcode+"R1T");

   if(ObjectFind(0,Pcode+"Buy_Above")>=0)
      ObjectDelete(0,Pcode+"Buy_Above");


   if(ObjectFind(0,Pcode+"Compra Sopra")>=0)
      ObjectDelete(0,Pcode+"Compra Sopra");


   if(ObjectFind(0,Pcode+"Pivot Line")>=0)
      ObjectDelete(0,Pcode+"Pivot Line");

   if(ObjectFind(0,Pcode+"PivotW")>=0)
      ObjectDelete(0,Pcode+"PivotW");

   if(ObjectFind(0,Pcode+"PivotWeek")>=0)
      ObjectDelete(0,Pcode+"PivotWeek");

   if(ObjectFind(0,Pcode+"PivDay")>=0)
      ObjectDelete(0,Pcode+"PivDay");

   if(ObjectFind(0,Pcode+"PivotD")>=0)
      ObjectDelete(0,Pcode+"PivotD");

   if(ObjectFind(0,Pcode+"Vendi Sotto")>=0)
      ObjectDelete(0,Pcode+"Vendi Sotto");
   if(ObjectFind(0,Pcode+"Pivot")>=0)
      ObjectDelete(0,Pcode+"Pivot");
   if(ObjectFind(0,Pcode+"Sell_Below")>=0)
      ObjectDelete(0,Pcode+"Sell_Below");


   if(ObjectFind(0,Pcode+"PPT")>=0)
      ObjectDelete(0,Pcode+"PPT");
   if(ObjectFind(0,Pcode+"S1T")>=0)
      ObjectDelete(0,Pcode+"S1T");
   if(ObjectFind(0,Pcode+"S2T")>=0)
      ObjectDelete(0,Pcode+"S2T");
   if(ObjectFind(0,Pcode+"S3T")>=0)
      ObjectDelete(0,Pcode+"S3T");
   if(ObjectFind(0,Pcode+"S4T")>=0)
      ObjectDelete(0,Pcode+"S4T");
   if(ObjectFind(0,Pcode+"S5T")>=0)
      ObjectDelete(0,Pcode+"S5T");

   if(ObjectFind(0,Pcode+"SD3")>=0)
      ObjectDelete(0,Pcode+"SD3");
   if(ObjectFind(0,Pcode+"SD2")>=0)
      ObjectDelete(0,Pcode+"SD2");
   if(ObjectFind(0,Pcode+"SD1")>=0)
      ObjectDelete(0,Pcode+"SD1");

   if(ObjectFind(0,Pcode+"sD3")>=0)
      ObjectDelete(0,Pcode+"sD3");
   if(ObjectFind(0,Pcode+"sD2")>=0)
      ObjectDelete(0,Pcode+"sD2");
   if(ObjectFind(0,Pcode+"sD1")>=0)
      ObjectDelete(0,Pcode+"sD1");

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void clearObj()
  {
   if(ObjectFind(0,pcode+"R5")>=0)
      ObjectDelete(0,pcode+"R5");
   if(ObjectFind(0,pcode+"R4")>=0)
      ObjectDelete(0,pcode+"R4");
   if(ObjectFind(0,pcode+"R3")>=0)
      ObjectDelete(0,pcode+"R3");
   if(ObjectFind(0,pcode+"R2")>=0)
      ObjectDelete(0,pcode+"R2");
   if(ObjectFind(0,pcode+"R1")>=0)
      ObjectDelete(0,pcode+"R1");

   if(ObjectFind(0,pcode+"S1")>=0)
      ObjectDelete(0,pcode+"S1");
   if(ObjectFind(0,pcode+"S2")>=0)
      ObjectDelete(0,pcode+"S2");
   if(ObjectFind(0,pcode+"S3")>=0)
      ObjectDelete(0,pcode+"S3");
   if(ObjectFind(0,pcode+"S4")>=0)
      ObjectDelete(0,pcode+"S4");
   if(ObjectFind(0,pcode+"S5")>=0)
      ObjectDelete(0,pcode+"S5");

   if(ObjectFind(0,pcode+"R5T")>=0)
      ObjectDelete(0,pcode+"R5T");
   if(ObjectFind(0,pcode+"R4T")>=0)
      ObjectDelete(0,pcode+"R4T");
   if(ObjectFind(0,pcode+"R3T")>=0)
      ObjectDelete(0,pcode+"R3T");
   if(ObjectFind(0,pcode+"R2T")>=0)
      ObjectDelete(0,pcode+"R2T");
   if(ObjectFind(0,pcode+"R1T")>=0)
      ObjectDelete(0,pcode+"R1T");
   if(ObjectFind(0,pcode+"PPT")>=0)
      ObjectDelete(0,pcode+"PPT");
   if(ObjectFind(0,pcode+"S1T")>=0)
      ObjectDelete(0,pcode+"S1T");
   if(ObjectFind(0,pcode+"S2T")>=0)
      ObjectDelete(0,pcode+"S2T");
   if(ObjectFind(0,pcode+"S3T")>=0)
      ObjectDelete(0,pcode+"S3T");
   if(ObjectFind(0,pcode+"S4T")>=0)
      ObjectDelete(0,pcode+"S4T");
   if(ObjectFind(0,pcode+"S5T")>=0)
      ObjectDelete(0,pcode+"S5T");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class gannObj
  {
private:
   int               inputDigit,outputDigit;
   double            currentPrice;

   double            B6,C6,D6,E6,F6,G6,H6;
   double            B7,C7,D7,E7,F7,G7,H7;
   double            B8,C8,D8,E8,F8,G8,H8;
   double            B9,C9,D9,E9,F9,G9,H9;
   double            B10,C10,D10,E10,F10,G10,H10;
   double            B11,C11,D11,E11,F11,G11,H11;
   double            B12,C12,D12,E12,F12,G12,H12;

   double            B4,C4,D4,E4,F4,G4;
   double            J1,J2,J3,J4,J5,J6,J7,J8;

   double            buyAbove,buyTarget1,buyTarget2,buyTarget3,buyTarget4,buyTarget5;
   double            sellBelow,sellTarget1,sellTarget2,sellTarget3,sellTarget4,sellTarget5;

   double            resistance1,resistance2,resistance3,resistance4,resistance5,resistanceStopLoss;
   double            support1,support2,support3,support4,support5,supportStopLoss;

public:
                     gannObj(double _inputPrice, int _inputDigit, double _currentPrice,  int _outputDigit);
   double            convertPrice(double _outputPrice);

   double            getBuyAbove()
     {
      return convertPrice(buyAbove);
     }
   double            getbuyTarget1()
     {
      return convertPrice(buyTarget1);
     }
   double            getbuyTarget2()
     {
      return convertPrice(buyTarget2);
     }
   double            getbuyTarget3()
     {
      return convertPrice(buyTarget3);
     }
   double            getbuyTarget4()
     {
      return convertPrice(buyTarget4);
     }
   double            getbuyTarget5()
     {
      return convertPrice(buyTarget5);
     }



   double            getsellBelow()
     {
      return convertPrice(sellBelow);
     }
   double            getsellTarget1()
     {
      return convertPrice(sellTarget1);
     }
   double            getsellTarget2()
     {
      return convertPrice(sellTarget2);
     }
   double            getsellTarget3()
     {
      return convertPrice(sellTarget3);
     }
   double            getsellTarget4()
     {
      return convertPrice(sellTarget4);
     }
   double            getsellTarget5()
     {
      return convertPrice(sellTarget5);
     }

   double            getresistance1()
     {
      return convertPrice(resistance1);
     }
   double            getresistance2()
     {
      return convertPrice(resistance2);
     }
   double            getresistance3()
     {
      return convertPrice(resistance3);
     }
   double            getresistance4()
     {
      return convertPrice(resistance4);
     }
   double            getresistance5()
     {
      return convertPrice(resistance5);
     }
   double            getresistanceStopLoss()
     {
      return convertPrice(resistanceStopLoss);
     }

   double            getsupport1()
     {
      return convertPrice(support1);
     }
   double            getsupport2()
     {
      return convertPrice(support2);
     }
   double            getsupport3()
     {
      return convertPrice(support3);
     }
   double            getsupport4()
     {
      return convertPrice(support4);
     }
   double            getsupport5()
     {
      return convertPrice(support5);
     }
   double            getsupportStopLoss()
     {
      return convertPrice(supportStopLoss);
     }

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double gannObj::convertPrice(double _outputPrice)
  {
   string result[];
   string strPrice=DoubleToString(currentPrice,outputDigit);
   ushort u_sep=StringGetCharacter(".",0);
   int k=StringSplit(strPrice,u_sep,result);

   double price=_outputPrice;
   if(k==1)
     {
      price = NormalizeDouble(price,Digits());
     }
   else
     {
      int first  = StringLen(result[0]);
      int second = StringLen(result[1]);
      strPrice=DoubleToString(price);
      StringReplace(strPrice,".","");
      strPrice=StringSubstr(strPrice,0,first)+"."+StringSubstr(strPrice,first,second);
      price = StringToDouble(strPrice);
      price = NormalizeDouble(price,Digits());
     }


   return price;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void gannObj::gannObj(double _inputPrice, int _inputDigit, double _currentPrice,  int _outputDigit)
  {
   J1=0.125;
   J2=0.25;
   J3=0.375;
   J4=0.5;
   J5=0.625;
   J6=0.75;
   J7=0.875;
   J8=1;

   inputDigit = _inputDigit;

   outputDigit = _outputDigit;
   currentPrice = _currentPrice;

   string strPrice = DoubleToString(_inputPrice);
   _inputPrice = (_inputPrice<0) ? 1 : _inputPrice;
   StringReplace(strPrice,".","");
   inputDigit = (inputDigit>StringLen(strPrice)) ? StringLen(strPrice) : (inputDigit<1) ? 1 : inputDigit;
   strPrice = StringSubstr(strPrice,0,inputDigit);
   double inputPrice = StringToDouble(strPrice);


   D4=inputPrice;

   E4=MathSqrt(D4);

   if((int)E4 == E4)
     {
      F4 = E4+1;
     }
   else
     {
      F4 = MathCeil(E4);
     }

   G4=F4+1;
   C4=MathFloor(E4);

   B4=C4-1;

   B6=MathPow((F4+J2),2);
   E6=MathPow((F4+J3),2);
   H6=MathPow((F4+J4),2);

   C7=MathPow((C4+J2),2);
   E7=MathPow((C4+J3),2);
   G7=MathPow((C4+J4),2);

   D8=MathPow((B4+J2),2);
   E8=MathPow((B4+J3),2);
   F8=MathPow((B4+J4),2);

   B9=MathPow((F4+J1),2);
   C9=MathPow((C4+J1),2);
   D9=MathPow((B4+J1),2);
   E9=MathPow(B4,2);
   F9=MathPow((B4+J5),2);
   G9=MathPow((C4+J5),2);
   H9=MathPow((F4+J5),2);

   D10=MathPow((B4+J8),2);
   E10=MathPow((B4+J7),2);
   F10=MathPow((B4+J6),2);

   C11=MathPow((C4+J8),2);
   E11=MathPow((C4+J7),2);
   G11=MathPow((C4+J6),2);

   B12=MathPow((F4+J8),2);
   E12=MathPow((F4+J7),2);
   H12=MathPow((F4+J6),2);

   G6=0;
   D6=0;
   B7=0;
   H8=0;
   B10=0;
   H11=0;
   C12=0;
   F12=0;

   C6=(D4>=B6 && D4<E6) ? D4 : 0;
   F6=(D4>=E6 && D4<H6) ? D4 : 0;

   D7=(D4>=C7 && D4<E7) ? D4 : 0;
   F7=(D4>=E7 && D4<G7) ? D4 : 0;
   H7=(D4>=H6 && D4<H9) ? D4 : 0;

   B8=(D4>=B9 && D4<B6) ? D4 : 0;
   C8=(D4>=C9 && D4<C7) ? D4 : 0;
   G8=(D4>G7 && D4<G9) ? D4 : 0;

   C10=(D4>=D10 && D4<C9) ? D4 : 0;
   G10=(D4>=G9 && D4<G11) ? D4 : 0;
   H10=(D4>=H9 && D4<H12) ? D4 : 0;

   B11=(D4>=C11 && D4<B9) ? D4 : 0;
   D11=(D4>=E11 && D4<C11) ? D4 : 0;
   F11=(D4>=G11 && D4<E11) ? D4 : 0;

   D12=(D4>=E12 && D4<B12) ? D4 : 0;
   G12=(D4>=H12 && D4<E12) ? D4 : 0;

   resistance1 = (C10!=0) ? C7 : (C8!=0) ? E7 : (D7!=0) ? G7 : (F7!=0) ? G9 : (G8!=0) ? G11 : (G10!=0) ? E11 : (F11!=0) ? C11 : (D11!=0) ? B9 : (B11!=0) ? B6 : (B8!=0) ? E6 : (C6!=0) ? H6 : (F6!=0) ? H9 : (H7!=0) ? H12 : (H10!=0) ? E12 : (G12!=0) ? B12 : (D12!=0) ? B12 : 0;
   resistance2 = (C10!=0) ? E7 : (C8!=0) ? G7 : (D7!=0) ? G9 : (F7!=0) ? G11 : (G8!=0) ? E11 : (G10!=0) ? C11 : (F11!=0) ? B9 : (D11!=0) ? B6 : (B11!=0) ? E6 : (B8!=0) ? H6 : (C6!=0) ? H9 : (F6!=0) ? H12 : (H7!=0) ? E12 : (H10!=0) ? B12 : (G12!=0) ? B12 : (D12!=0) ? B12 : 0;
   resistance3 = (C10!=0) ? G7 : (C8!=0) ? G9 : (D7!=0) ? G11 : (F7!=0) ? E11 : (G8!=0) ? C11 : (G10!=0) ? B9 : (F11!=0) ? B6 : (D11!=0) ? E6 : (B11!=0) ? H6 : (B8!=0) ? H9 : (C6!=0) ? H12 : (F6!=0) ? E12 : (H7!=0) ? B12 : (H10!=0) ? B12 : (G12!=0) ? B12 : (D12!=0) ? B12 : 0;
   resistance4 = (C10!=0) ? G9 : (C8!=0) ? G11 : (D7!=0) ? E11 : (F7!=0) ? C11 : (G8!=0) ? B9 : (G10!=0) ? B6 : (F11!=0) ? E6 : (D11!=0) ? H6 : (B11!=0) ? H9 : (B8!=0) ? H12 : (C6!=0) ? E12 : (F6!=0) ? B12 : (H7!=0) ? B12 : (H10!=0) ? B12 : (G12!=0) ? B12 : (D12!=0) ? B12 : 0;
   resistance5 = (C10!=0) ? G11 : (C8!=0) ? E11 : (D7!=0) ? C11 : (F7!=0) ? B9 : (G8!=0) ? B6 : (G10!=0) ? E6 : (F11!=0) ? H6 : (D11!=0) ? H9 : (B11!=0) ? H12 : (B8!=0) ? E12 : (C6!=0) ? B12 : (F6!=0) ? B12 : (H7!=0) ? B12 : (H10!=0) ? B12 : (G12!=0) ? B12 : (D12!=0) ? B12 : 0;
   resistanceStopLoss = (C10!=0) ? D10 : (C8!=0) ? C9 : (D7!=0) ? C7 : (F7!=0) ? E7 : (G8!=0) ? G7 : (G10!=0) ? G9 : (F11!=0) ? G11 : (D11!=0) ? E11 : (B11!=0) ? C11 : (B8!=0) ? B9 : (C6!=0) ? B6 : (F6!=0) ? E6 : (H7!=0) ? H6 : (H10!=0) ? H9 : (G12!=0) ? H12 : (D12!=0) ? E12 : 0;

   support1 = (C10!=0) ? E10 : (C8!=0) ? D10 : (D7!=0) ? C9 : (F7!=0) ? C7 : (G8!=0) ? E7 : (G10!=0) ? G7 : (F11!=0) ? G9 : (D11!=0) ? G11 : (B11!=0) ? E11 : (B8!=0) ? C11 : (C6!=0) ? B9 : (F6!=0) ? B6 : (H7!=0) ? E6 : (H10!=0) ? H6 : (G12!=0) ? H9 : (D12!=0) ? H12 : 0;
   support2 = (C10!=0) ? F10 : (C8!=0) ? E10 : (D7!=0) ? D10 : (F7!=0) ? C9 : (G8!=0) ? C7 : (G10!=0) ? E7 : (F11!=0) ? G7 : (D11!=0) ? G9 : (B11!=0) ? G11 : (B8!=0) ? E11 : (C6!=0) ? C11 : (F6!=0) ? B9 : (H7!=0) ? B6 : (H10!=0) ? E6 : (G12!=0) ? H6 : (D12!=0) ? H9 : 0;
   support3 = (C10!=0) ? F9 : (C8!=0) ? F10 : (D7!=0) ? E10 : (F7!=0) ? D10 : (G8!=0) ? C9 : (G10!=0) ? C7 : (F11!=0) ? E7 : (D11!=0) ? G7 : (B11!=0) ? G9 : (B8!=0) ? G11 : (C6!=0) ? E11 : (F6!=0) ? C11 : (H7!=0) ? B9 : (H10!=0) ? B6 : (G12!=0) ? E6 : (D12!=0) ? H6 : 0;
   support4 = (C10!=0) ? F8 : (C8!=0) ? F9 : (D7!=0) ? F10 : (F7!=0) ? E10 : (G8!=0) ? D10 : (G10!=0) ? C9 : (F11!=0) ? C7 : (D11!=0) ? E7 : (B11!=0) ? G7 : (B8!=0) ? G9 : (C6!=0) ? G11 : (F6!=0) ? E11 : (H7!=0) ? C11 : (H10!=0) ? B9 : (G12!=0) ? B6 : (D12!=0) ? E6 : 0;
   support5 = (C10!=0) ? E8 : (C8!=0) ? F8 : (D7!=0) ? F9 : (F7!=0) ? F10 : (G8!=0) ? E10 : (G10!=0) ? D10 : (F11!=0) ? C9 : (D11!=0) ? C7 : (B11!=0) ? E7 : (B8!=0) ? G7 : (C6!=0) ? G9 : (F6!=0) ? G11 : (H7!=0) ? E11 : (H10!=0) ? C11 : (G12!=0) ? B9 : (D12!=0) ? B6 : 0;
   supportStopLoss = (C10!=0) ? C9 : (C8!=0) ? C7 : (D7!=0) ? E7 : (F7!=0) ? G7 : (G8!=0) ? G9 : (G10!=0) ? G11 : (F11!=0) ? E11 : (D11!=0) ? C11 : (B11!=0) ? B9 : (B8!=0) ? B6 : (C6!=0) ? E6 : (F6!=0) ? H6 : (H7!=0) ? H9 : (H10!=0) ? H12 : (G12!=0) ? E12 : (D12!=0) ? B12 : 0;
   double divMolt=Div_(DIVIS);
   buyAbove = (C10!=0) ? C9 : (C8!=0) ? C7 : (D7!=0) ? E7 : (F7!=0) ? G7 : (G8!=0) ? G9 : (G10!=0) ? G11 : (F11!=0) ? E11 : (D11!=0) ? C11 : (B11!=0) ? B9 : (B8!=0) ? B6 : (C6!=0) ? E6 : (F6!=0) ? H6 : (H7!=0) ? H9 : (H10!=0) ? H12 : (G12!=0) ? E12 : (D12!=0) ? B12 : 0;
   buyAbove = buyAbove/divMolt;          //////////////
   sellBelow = (C10!=0) ? D10 : (C8!=0) ? C9 : (D7!=0) ? C7 : (F7!=0) ? E7 : (G8!=0) ? G7 : (G10!=0) ? G9 : (F11!=0) ? G11 : (D11!=0) ? E11 : (B11!=0) ? C11 : (B8!=0) ? B9 : (C6!=0) ? B6 : (F6!=0) ? E6 : (H7!=0) ? H6 : (H10!=0) ? H9 : (G12!=0) ? H12 : (D12!=0) ? E12 : 0;
   sellBelow = sellBelow/divMolt;         ////////////
   
   if(PivotDaily==2)
     {
      rD1=resistance1/divMolt;
      sD1=support1/divMolt;
      rD2=resistance2/divMolt;
      sD2=support2/divMolt;
      rD3=resistance3/divMolt;
      sD3=support3/divMolt;
     }
     
   if(PeriodoPrecRuota_==0)
     {
      HiLoPrecRoute=HighD1-LowD1;
     }
   if(PeriodoPrecRuota_==1)
     {
      HiLoPrecRoute=HighW1-LowW1;
     }
   if(PeriodoPrecRuota_==2)
     {
      HiLoPrecRoute=HighM1-LowM1;
     }
   if(PeriodoPrecRuota_==3)
     {
      HiLoPrecRoute=HighM1-LowM1;
     }

   if(input_ruota== 0)
     {
      coeff_ruota=HiLoPrecRoute/6*gradi_cicli();
     }

   if(input_ruota== 1)
     {
      buyTarget1 = resistance1 * 0.9995/divMolt;
      buyTarget2 = resistance2 * 0.9995/divMolt;
      buyTarget3 = resistance3 * 0.9995/divMolt;
      buyTarget4 = resistance4 * 0.9995/divMolt;
      buyTarget5 = resistance5 * 0.9995/divMolt;

      sellTarget1 = support1 * 1.0005/divMolt;
      sellTarget2 = support2 * 1.0005/divMolt;
      sellTarget3 = support3 * 1.0005/divMolt;
      sellTarget4 = support4 * 1.0005/divMolt;
      sellTarget5 = support5 * 1.0005/divMolt;
     }

   if(input_ruota== 0)

     {
      buyAbove   = prezzoPivot+coeff_ruota;
      buyTarget1 = buyAbove+coeff_ruota;
      buyTarget2 = buyTarget1+coeff_ruota;
      buyTarget3 = buyTarget2+coeff_ruota;
      buyTarget4 = buyTarget3+coeff_ruota;
      buyTarget5 = buyTarget4+coeff_ruota;

      sellBelow   = prezzoPivot-coeff_ruota;
      sellTarget1 = sellBelow  -coeff_ruota;
      sellTarget2 = sellTarget1-coeff_ruota;
      sellTarget3 = sellTarget2-coeff_ruota;
      sellTarget4 = sellTarget3-coeff_ruota;
      sellTarget5 = sellTarget4-coeff_ruota;
     }

   compraSopra   = buyAbove;
   primoLevBuy   = buyTarget1;
   secondoLevBuy = buyTarget2;
   terzoLevBuy   = buyTarget3;
   quartoLevBuy  = buyTarget4;
   quintoLevBuy  = buyTarget5;

   vendiSotto     = sellBelow;
   primoLevSell   = sellTarget1;
   secondoLevSell = sellTarget2;
   terzoLevSell   = sellTarget3;
   quartoLevSell  = sellTarget4;
   quintoLevSell  = sellTarget5;

   arrPric[0] = PRiceIn; //PRiceIn a SQ9
   arrPric[1] = primoLevBuy;
   arrPric[2] = secondoLevBuy;
   arrPric[3] = terzoLevBuy;
   arrPric[4] = quartoLevBuy;
   arrPric[5] = quintoLevBuy;

   arrPric[6] = primoLevSell;
   arrPric[7] = secondoLevSell;
   arrPric[8] = terzoLevSell;
   arrPric[9] = quartoLevSell;
   arrPric[10]= quintoLevSell;
   arrPric[11]= compraSopra;
   arrPric[12]= vendiSotto;
   arrPric[13]= PivDay;
   arrPric[14]= priceW;
   arrPric[15]= ThresholdUp_;//Per visualizzazione grafica
   arrPric[16]= ThresholdDw_;//Per visualizzazione grafica

   valoriArr [0]  = priceW;
   valoriArr [1]  = prezzoPivot;
   valoriArr [2]  = compraSopra;
   valoriArr [3]  = primoLevBuy;
   valoriArr [4]  = secondoLevBuy;
   valoriArr [5]  = terzoLevBuy;
   valoriArr [6]  = quartoLevBuy;
   valoriArr [7]  = quintoLevBuy;
   valoriArr [8]  = vendiSotto;
   valoriArr [9]  = primoLevSell;
   valoriArr [10] = secondoLevSell;
   valoriArr [11] = terzoLevSell;
   valoriArr [12] = quartoLevSell;
   valoriArr [13] = quintoLevSell;

   sniperString [0]   = "priceW";
   sniperString [1]   = "prezzoPivot";
   sniperString [2]   = "compraSopra";
   sniperString [3]   = "primoLevBuy";
   sniperString [4]   = "secondoLevBuy";
   sniperString [5]   = "terzoLevBuy";
   sniperString [6]   = "quartoLevBuy";
   sniperString [7]   = "quintoLevBuy";
   sniperString [8]   = "vendiSotto";
   sniperString [9]   = "primoLevSell";
   sniperString [10]  = "secondoLevSell";
   sniperString [11]  = "terzoLevSell";
   sniperString [12]  = "quartoLevSell";
   sniperString [13]  = "quintoLevSell";
   sniperString [14]  = "valorePercLevByLev";
   sniperString [15]  = " "; // Segno Buy o Sell per richiesta ticket primo ordine
  }
//+------------------------------------------------------------------+
//|                          OnChartEvent                            |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK && sparam==buttonID_)
     {

      ClearObj();
      if(ObjectGetInteger(0,buttonID_,OBJPROP_BGCOLOR)==clrRed)
        {
         ObjectSetInteger(0,buttonID_,OBJPROP_BGCOLOR,clrGreen);
         showGann_=0;
        }
      else
        {
         ObjectSetInteger(0,buttonID_,OBJPROP_BGCOLOR,clrRed);
         showGann_=1;
        }
      GlobalVariableSet(chartiD_+"-"+"showGann_",showGann_);
      ObjectSetInteger(0,buttonID_,OBJPROP_STATE,0);
      ChartRedraw();
     }
  }


/*
//*------------------- NumCandPerPeriodo () ------------------------------*
int NumCandPerPeriodo()
  {

   int numCandele=0;
   if(periodoRicNumCand==0)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'19.01.2023');
   if(periodoRicNumCand==1)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'24.01.2023');
   if(periodoRicNumCand==2)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'17.02.2023');
   if(periodoRicNumCand==3)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'17.07.2023');
   if(periodoRicNumCand==4)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'17.01.2024');
   return numCandele;
  }
  */

   
//+------------------------------------------------------------------+
//|                   Gradi di ciclo x Ruota 24                      |
//+------------------------------------------------------------------+
double gradi_cicli()
  {
   switch(gradi_Ciclo)
     {
      case -1 : gra_clcl= 2;      break;
      case 0 :  gra_clcl= 1;      break;
      case 1 :  gra_clcl= 0.75;   break;
      case 2 :  gra_clcl= 0.5;    break;
      case 3 :  gra_clcl= 0.25;   break;
      case 4 :  gra_clcl= 0.125;  break;
      case 5 :  gra_clcl= 0.3333; break;
      default:  Alert("Gradi Ciclo selezione ERRATA!");
     }
   return gra_clcl;
  }
//+------------------------------------------------------------------+
//|                         CheckAlarmPrice                          |
//+------------------------------------------------------------------+

void CheckAlarmPrice()
  {

   double ClosePrice[1];
   CopyClose(Symbol(),0,0,1,ClosePrice);

   string message="";
   NewAlert_=LastAlert_;

   if(ClosePrice[0]>=R5Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=R5Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("R5");
   if(ClosePrice[0]>=R4Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=R4Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("R4");
   if(ClosePrice[0]>=R3Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=R3Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("R3");
   if(ClosePrice[0]>=R2Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=R2Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("R2");
   if(ClosePrice[0]>=R1Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=R1Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("R1");
   if(ClosePrice[0]>=compraSopra-(Point()*pipDeviation)   && ClosePrice[0]<=compraSopra+(Point()*pipDeviation))
      NewAlert_=GetAlertID("Compra Sopra");
   if(ClosePrice[0]>=vendiSotto-(Point()*pipDeviation)    && ClosePrice[0]<=vendiSotto+(Point()*pipDeviation))
      NewAlert_=GetAlertID("Vendi Sotto");
   if(ClosePrice[0]>=S1Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=S1Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("S1");
   if(ClosePrice[0]>=S2Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=S2Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("S2");
   if(ClosePrice[0]>=S3Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=S3Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("S3");
   if(ClosePrice[0]>=S4Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=S4Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("S4");
   if(ClosePrice[0]>=S5Pricee-(Point()*pipDeviation)       && ClosePrice[0]<=S5Pricee+(Point()*pipDeviation))
      NewAlert_=GetAlertID("S5");

   if(NewAlert_!=LastAlert_)
     {
      message = GetAlertMessage(NewAlert_,ClosePrice[0]);

   if(alert1 == 1) PlaySound("Alert");
   if(alert1 == 2) Alert(message);
   if(alert1 == 3) SendNotification(message);
   if(alert1 == 4) SendMail("Level Sq 9 - ",message);

   if(alert1 != alert2)
        {
   if(alert2 == 1) PlaySound("Alert");
   if(alert2 == 2) Alert(message);
   if(alert2 == 3) SendNotification(message);
   if(alert2 == 4) SendMail("Level Sq 9 - ",message);
        }
      GlobalVariableSet(chartiD_+"-"+"LastAlert_",NewAlert_);
      LastAlert_=NewAlert_;
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
  
  
 
 