//+------------------------------------------------------------------+
//|                                 Zigulì + Sq 9 v1.2(togliere).mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+


#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.2"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor is...."
string versione = "v1.2";

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
   PreviousDayOpen  = 0,        //Pivot on previous session opening
   PreviousDayLow   = 1,        //Pivot on previous session low
   PreviousDayHigh  = 2,        //Pivot on previous session high
   PreviousDayClose = 3,        //Pivot on previous session close
   PivotDailyHL     = 4,        //Pivot Daily
   PivotWeek        = 5,        //Pivot Weekly
   Custom           = 6,        //Custom
 //  HighPrevDay      = 7,        //High of the previous day
 //  LowPrevDay       = 8,        //Minimum of the previous day
   HiLoZigZag       = 9,        //Last Top/Bottom of Zig Zag indicator
   HigLowZigZag     =10,        //Last High/Low of Zig Zag indicator
   LastHLDayPrima   =11,        //Last High or Low day previous
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

enum LineGType           //Type of lines   
  {
   Solid      = 0,
   Dash       = 1,
   Dot        = 2,
   DashDot    = 3,
   DashDotDot = 4
  };

enum LineGWidth          //Lines SQ 0
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
   ZZPrec           = 2,           //Stop Loss all'ultimo ZigZag "Ampio"
   ZZultimo         = 3,           //Stop Loss all'ultimo Zig Zag Minimo
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
enum TypeCandle
  {
   Stesso                    = 0,  //Trailing Stop sul min/max della candela "index"
   Una                       = 1,  //Trailing Stop sul min/max del corpo della candela "index"
   Due                       = 2,  //Trailing Stop sul max/min del corpo della candela "index"
   Tre                       = 3,  //Trailing Stop sul max/min della candela "index"
  };
     
enum Tp
  {
   No_Tp                     = 0,  //No Tp
   TpPoints                  = 1,  //Tp in Points
   TpMA                      = 2,  //Tp alla Media Mobile
   TPSogliaOoopsta           = 3,  //Tp alla Soglia opposta
  };

enum ordlivellisuperati
  {
   No                        = 0,  //Ordini consentiti senza filtro livello precedente
   open                      = 1,  //Ordini consentiti se oltre il liv Open prec e tipo uguale
   openclose                 = 2   //Ordini consentiti se oltre il liv Open/Close prec e tipo uguale
  }; 
  
enum pendMAcongrua
  {
   No                        = 0,  //No
   tutte                     = 1,  //Congruità pend MA/ordini: Su tutte le candele 
   primaultima               = 2   //Congruità pend MA/ordini: Su prima/ultima candele
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
  
input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput              gannInputDigit                  = 4;         //Number of price digits used: Calibration
input Divisione              DIVIS                           = 0;         //Multiplication / Division of digits: Calibration

input PriceType              gannInputType                   = 9;         //Type of Input in Calculation
input string                 gannCustomPrice                 = "1.00000";
input PivD_SR_Sqnine         PivotDaily                      = 0;         //On the chart: Pivot Daily or Resistances/Supports Sq 9
//int  PivotDaily                                              = 0;       //On the chart: Pivot Daily or Resistances/Supports Sq 9
input PriceTypeW             TypePivW                        = 2;         //Pivot Weekly Type (for Filter)
input PriceTypeD             PriceTypeD_                     = 3;         //Pivot Daily Type (for Filter)
input input_ruota_           input_ruota                     = 1;         //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_               = 1;         //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;         //Advanced Formula Angles: 360°/270°/180°/90°  

input bool VisibiliInChart             = true;
//bool VisibiliInChart             = true;
input bool         shortLines          = true;
input bool         showLineName        = true;
//input AlertType    alert1              = 0;
AlertType    alert1              = 0;
//input AlertType    alert2              = 0;
AlertType    alert2              = 0;
input int          pipDeviation        = 0;                        //Sensibility for alert
input string       CommentStyle        = "--- Style Settings ---";
input bool         drawBackground      = true;
input bool         disableSelection    = true;
input color        resistanceColor     = clrRed;
input LineType     resistanceType      = 2;
input LineWidth    resistanceWidth     = 1;
input color        supportColor        = clrLime;
input LineType     supportType         = 2;
input LineWidth    supportWidth        = 1;
input string       ButtonStyle         = "--- Toggle Style Settings ---";
input bool         buttonEnable        = false;
//bool buttonEnable        = false;
//input int          xDistance_           = 250;
int          xDistance_           = 250;
//input int          yDistance_           = 5;
int          yDistance_           = 5;
//input int          width               = 100;
int          width               = 100;
//input int          hight               = 30;
int          hight               = 30;
input string       label               = " ";
*/ 

    /*
   GannInputDigit  = arrInt[0];  arrInt[0] = GannInputDigit;
   Divis           = arrInt[1];  arrInt[1] = Divis;
   PipDeviation    = arrInt[2];  arrInt[2] = PipDeviation;
   ResistanceType  = arrInt[3];  arrInt[3] = ResistanceType;
   ResistanceWidth = arrInt[4];  arrInt[4] = ResistanceWidth;
   SupportType     = arrInt[5];  arrInt[5] = SupportType;
   SupportWidth    = arrInt[6];  arrInt[6] = SupportWidth;
   Alert1          = arrInt[7];  arrInt[7] = Alert1;
   Alert2          = arrInt[8];  arrInt[8] = Alert2;
   XDistance       = arrInt[9];  arrInt[9] = XDistance;
   YDistance       = arrInt[10]; arrInt[10] = YDistance;
   Width           = arrInt[11]; arrInt[11] = Width;
   Hight           = arrInt[12]; arrInt[12] = Hight;

   visualChart     = arrBool[0]; arrBool[0] = visualChart;
   ShortLines      = arrBool[1]; arrBool[1] = ShortLines;
   ShowLineName    = arrBool[2]; arrBool[2] = ShowLineName;
   DrawBackground  = arrBool[3]; arrBool[3] = DrawBackground;
   DisableSelection= arrBool[4]; arrBool[4] = DisableSelection;
   ButtonEnable    = arrBool[5]; arrBool[5] = ButtonEnable;
   GannInputType   = arrBool[6]; arrBool[6] = GannInputType;
   visualThresUp   = arrBool[7]; arrBool[7] = visualThresUp;
   visualThresDw   = arrBool[8]; arrBool[8] = visualThresDw;

   GannCustomPrice = arrString[0];  arrString[0] = GannCustomPrice;
   Label           = arrString[1];  arrString[1] = Label;
   pcode           = arrString[2];  arrString[2] = pcode;
   buttonID        = arrString[3];  arrString[3] = buttonID;

   ResistanceColor = arrColo[0]; arrColo[0] = ResistanceColor;
   SupportColor    = arrColo[1]; arrColo[1] = SupportColor;
   BuyAboveColor   = arrColo[2]; arrColo[2] = BuyAboveColor;
   SellBelowColor  = arrColo[3]; arrColo[3] = SellBelowColor;
   ThresholdColor  = arrColo[4]; arrColo[4] = ThresholdColor;
*/


input string   comment_OS     =        "--- SETTINGS GENERALI ---";   // --- SETTINGS GENERALI ---
input int CloseOrdDopoNumCandDalPrimoOrdine_ =   0;         //Chiude l'Ordine se in profitto dopo n° candele. (0 = Disable)
input Type_Orders Type_Orders_               =   0;         //Tipo di Ordini
input nMaxPos     N_Max_pos                  =   1;         //Massimo numero di Ordini contemporaneamente
input ulong       magic_number               = 4444;        //Magic Number
input string      Commen                     = "Zigulì v1.2";       //Comment
input int         Deviazione                 =   0;         //Slippage  

input string   comment_Square9   =       "--- Filtro Square of 9 Gann ---";   // --- Filtro Square of 9 Gann ---
input bool        FilterSq9                  =   false;     //Filtro Square of 9 Gann

input string   comment_Strat   =       "--- ORDINI AD IMPULSO/LIVELLO ---";   // --- ORDINI AD IMPULSO/LIVELLO ---
//input bool     SwingChart                  = false;       //Swing Chart
input levImp   levelImpuls                   =     0;       //Impulso / Livello

input string   commentpattcand =       "--- ORDINI PATTERN CANDELE CONGRUE/BODY//SHADOW ---";   // --- ORDINI PATTERN CANDELE CONGRUE/BODY//SHADOW ---
input direzCand  direzCand_                  =     1;       //Permette Ordine Cand a favore: No/N°Cand/N°Cand+Body/N°Cand+Shadow
input int      numCandDirez                  =     1;       //Numero Candele a favore. Minimo 1.
input ENUM_TIMEFRAMES timeFrCand =   PERIOD_CURRENT;        //Time Frame Candele

input string   comment_Dist     =       "--- DISTANZA MINIMA SOGLIE ---";   // --- DISTANZA MINIMA SOGLIE ---
input int      distminsoglie                     = 2000;        //Distanza minima delle soglie in points

input string   comment_ORD     =       "--- ORDINI OLTRE INCLINAZIONE ---";   // --- ORDINI OLTRE INCLINAZIONE ---
input double   inclinazmin                   =   100;       //Ordini consentiti dall'inclinazione ZigZag

input string   comment_LIV     =  "---- ORDINI A % LIVELLI e OLTRE LIVELLI ORDINI PRECEDENTI ----";   // ---- ORDINI A % LIVELLI e OLTRE LIVELLI ORDINI PRECEDENTI ----
input int      perclevlev                    =    65;       //Ordini consentiti fino alla % tra soglie   
input ordlivellisuperati ordlivellisuperati_ =     0;       //Nuovi Ordini a livelli oltre Open/Close  

input string   comment_Me      =       "--- FILTRO PENDENZA MEDIE MOB CONGRUA ---";   // --- FILTRO PENDENZA MEDIE MOB CONGRUA ---
input pendMAcongrua pendmacongrua       =   0;              //Pend congrua MA/Ord: NO/Tutte le cand/Solo prima/ultima (Min 2)
input int      numcandMacongrue         =   2;              //Numero di candele MA per determinare la pendenza 

input string   commentCandSwing=       "--- IMP CANDELA DI SWING ---";   // --- IMP CANDELA DI SWING ---
input bodyShSw bodyShadowSw                  =     0;       //Superamento Body / Shadow Swing Chart
input ENUM_TIMEFRAMES timeFrPicco  = PERIOD_CURRENT;        // Time frame candela di Picco Zig Zag

input string   comment_ZZ      =       "--- ZIG ZAG SETTING ---";// --- ZIG ZAG SETTING ---                               
input int      InpDepth                 = 12;               // ZigZag: Depth
input int      InpDeviation             =  5;               // ZigZag: Deviation
input int      InpBackstep              =  3;               // ZigZag: Backstep
input int    InpCandlesCheck            =200;               // ZigZag: numero candele analizzate
input int      MinCandZZ                =  0;               // Minimo di candele per approvare il valore dell'ultimo ZigZag
input ENUM_TIMEFRAMES periodZigzag=PERIOD_CURRENT;          // Timeframe ZigZag

input string   comment_MA =        "--- MA SETTING ---";    // --- MA SETTING ---
input int                  periodMAFast  = 30;              //Periodo MA 
input int                  shiftMAFast   =  0;              //Shift MA 
input ENUM_MA_METHOD       methodMAFast=MODE_EMA;           //Metodo MA 
input ENUM_APPLIED_PRICE   applied_priceMAFast=PRICE_CLOSE; //Tipo di  prezzo MA 
input color                coloreMAFast = clrAzure;         //Colore MA 

input string     comment_SQ9         = "-- CALIBRATION SQUARE of 9 --";   //  -- CALIBRATION SQUARE of 9 -- 
input PriceType  GannInputType       = 9;         //Type of Input in Calculation
input string     GannCustomPrice     = "1.00000";
input GannInput  GannInputDigit      = 4;         //Number of price digits used: Calibration
input Divisione  Divis               = 0;         //Multiplication / Division of digits: Calibration
input bool       ShortLines          = true;
input bool       ShowLineName        = true;
input int        Alert1              = 0;
input int        Alert2              = 0;
input int        PipDeviation        = 0;  

input PriceTypeW             TypePivW                        = 2;         //Pivot Weekly Type (for Filter)
input PriceTypeD             PriceTypeD_                     = 3;         //Pivot Daily Type (for Filter)
input input_ruota_           input_ruota                     = 1;         //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_               = 1;         //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;         //Advanced Formula Angles: 360°/270°/180°/90°

input string     CommentStyle        = "--- Style Settings SQ 9 ---";
input bool       DrawBackground      = true;
input bool       DisableSelection    = true;
input color      ResistanceColor     = clrRed;
input color      BuyAboveColor       = clrRed;
input LineType   ResistanceType      = 2;
input LineGWidth ResistanceWidth     = 1;
input color      SupportColor        = clrLime;
input color      SellBelowColor      = clrLime;
input color      ThresholdColor      = clrWhite;
input LineType   SupportType         = 2;
input LineGWidth SupportWidth        = 1;
input string     ButtonStyle         = "--- Toggle Style Settings ---";

 int        XDistance           = 250;
 int        YDistance           = 5;
 int        Width               = 100;
 int        Hight               = 30;
 string     Label               = " ";
 bool       ButtonEnable        = false;
input bool       visualChart         =  true;
 bool       visualThresUp       = false;
 bool       visualThresDw       = false; 

input string   comment_SL =           "--- STOP LOSS ---";  // --- STOP LOSS ---
input TypeSl   TypeSl_                  =     1;            //Stop Loss: No / Sl Points / Picco ZigZag Precedente
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

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    1;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit: No/Points/MA/Body cand opposta/Shad cand opp
input int      TpPoints                 = 1000;              //Take Profit Points

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

input string   comment_MM          = "--- MONEY MANAGEMENT ---";// --- MONEY MANAGEMENT ---
input bool     EnableAllocazione   =   false;                   //Abilita/disabilita l'allocazione di capitale
input double   capitalToAllocateEA =  		 0;					    //Capitale da allocare per l'EA (0 = intero capitale)
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
input color      coloresell             = clrGold;  //Colore Soglie
input color      colorebuy              = clrLime;  //Colore Max Buy/Min Sell
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

static double piccoalto = 0, piccobasso = 0;

static int contaUno = 0;

double sogliabuycons = 0, sogliasellcons = 0;
double inclinometr = 0;


/// Sq 9

double R1Price,R2Price,R3Price,R4Price,R5Price,buyAbove,BuyAbove,PivotDay,PivotWeek,priceIn;
double S1Price,S2Price,S3Price,S4Price,S5Price,sellBelow,SellBelow,ThresholdUp,ThresholdDw;

string pcode="";
double LastAlert=-1;
double NewAlert=0;
string broker_name;

string chartiD = "";
string buttonID="ButtonGann";
double showGann;
double div;

int    arrInter [50];
bool   arrBol   [50];
double arrPric  [50];
string arrStrin [30];
color  arrCol   [20];




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
      
arrInter[0] = GannInputDigit;
arrInter[1] = Divis;
arrInter[2] = PipDeviation;
arrInter[3] = ResistanceType;
arrInter[4] = ResistanceWidth;
arrInter[5] = SupportType;
arrInter[6] = SupportWidth;
arrInter[7] = Alert1;
arrInter[8] = Alert2;
arrInter[9] = XDistance;
arrInter[10] = YDistance;
arrInter[11] = Width;
arrInter[12] = Hight;

arrBol[0] = visualChart;
arrBol[1] = ShortLines;
arrBol[2] = ShowLineName;
arrBol[3] = DrawBackground;
arrBol[4] = DisableSelection;
arrBol[5] = ButtonEnable;
arrBol[6] = GannInputType;
arrBol[7] = visualThresUp;
arrBol[8] = visualThresDw;

arrStrin[0] = GannCustomPrice;
arrStrin[1] = Label;
arrStrin[2] = pcode;
arrStrin[3] = buttonID;

arrCol[0] = ResistanceColor;
arrCol[1] = SupportColor;
arrCol[2] = BuyAboveColor;
arrCol[3] = SellBelowColor;
arrCol[4] = ThresholdColor;      
      
      
      
	Allocazione_Init();  
	ClearObj();
   handle_iCustomMAFast   = iCustom(symbol_,0,"Examples\\Custom Moving Average Input Color",periodMAFast,shiftMAFast,methodMAFast,coloreMAFast);  

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
enableTrading = IsMarketTradeOpen(symbol_) && !IsMarketQuoteClosed(symbol_);     

ASK=Ask(symbol_);
BID=Bid(symbol_);
static datetime timesogliasup = 0;
static datetime timesogliainf = 0;

string inclinazenable = "";
string distanzaminimasoglie = "";
if(!Distanzasloglie()) distanzaminimasoglie="\n\nDistanza tra le Soglie NON CONSENTE Nuovi Ordini";

//if(inclinazmin>inclinometr) inclinazenable = "L'Inclinazione NON CONSENTE Nuovi Ordini";
Commento = spreadComment() + "\nBarre nel grafico " + (string)numBarreInChart() + "\n\nInclinazione Minima consentita "
           +(string)inclinazmin+"\nInclinazione Reale "+(string)inclinometr+"\n"+inclinazenable
           +distanzaminimasoglie;
           
   //Print("Distanza soglie ",Distanzasloglie());        

semCand = semaforoCandela(0); 

Indicators();

CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magicNumber);   
closeOrdineMA(MAFast(0),magic_number,Commen);
gestioneBreakEven();
gestioneTrailStop();
if(semCand || !contaUno) {gestioneOrdini(timesogliasup,timesogliainf);contaUno++;}

if(shortLines)DRawRectangleLine(timesogliasup,timesogliainf);
else DRawHorizontalLevel();
WRiteLineName();
//Histogram();
Comment(Commento);
//Print("Soglia% Buy ",((sogliaSup-sogliaInf)/100*perclevlev)+sogliaInf);Print("Soglia% Sell ",sogliaSup-((sogliaSup-sogliaInf)/100*perclevlev));
//if(semCand)Print(" ultimopicco BUY ",ultimopicco("Buy")," ultimopicco SELL ",ultimopicco("Sell"));
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

bool impulsoLivBuy = true,impulsoLivSell = true;
   impulsoLivello(impulsoLivBuy,impulsoLivSell);
double ValZZ[100];
int IndexZZ[100]; 
zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,MinCandZZ,periodZigzag,ValZZ,IndexZZ);
double arrprez[100];




arrprez[0] = ValZZ[0];
//arrprez[0] = PivotDaily(PriceTypeD_);

if(FilterSq9)SqNine(arrprez,arrStrin,arrInter,arrBol,arrCol); 

//sogliaBuySell("Buy",StLossZzPrecedBuy,timesogliasup,timesogliainf);sogliaBuySell("Sell",StLossZzPrecedBuy,timesogliasup,timesogliainf);   
//bool pendcongruabuy = true,pendcongruasell = true;   
   
//Print(" Inclinometro ",inclinometr);
//Print("pendcongruamaBuy: ",pendcongruamaBuy());

   inclinometro(inclinometr);

if(
      sogliaBuySell("Buy",StLossZzPrecedBuy,timesogliasup,timesogliainf)
   && ordini_Tipo_NumMax( "Buy",Type_Orders_,N_Max_pos,magicNumber,Commen)
   && numCandeleCongrue(direzCand_,"Buy",numCandDirez,timeFrCand)
   && impulsoLivBuy
   && pendcongruamaBuy()
   && inclinometro(inclinometr)
   && filtroSq9("Buy",arrprez)
   && GestioneATR()
   && Distanzasloglie()
   )
   {
   SendTradeBuyInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss("Buy"),calcoloTakeProf("Buy"),Commen,magic_number);
   }                    

//Print("pendcongruaSell: ",pendcongruamaSell());
if(
      sogliaBuySell("Sell",StLossZzPrecedSell,timesogliasup,timesogliainf) 
   && ordini_Tipo_NumMax("Sell",Type_Orders_,N_Max_pos,magicNumber,Commen)
   && numCandeleCongrue(direzCand_,"Sell",numCandDirez,timeFrCand)
   && impulsoLivSell
   && pendcongruamaSell()
   && inclinometro(inclinometr)
   && filtroSq9("Sell",arrprez)
   && GestioneATR()
   && Distanzasloglie()
   )
   {
   SendTradeSellInPoint(symbol_,lotsEA,Deviazione,calcoloStopLoss("Sell"),calcoloTakeProf("Sell"),Commen,magic_number);
   }
}

bool Distanzasloglie()
{
return sogliaSup >= (sogliaInf + distminsoglie*Point());
}

bool filtroSq9(string BuySell,double &arrPrezzSq[])
{
bool a = false;
if(!FilterSq9){a=true;return a;}
if(BuySell=="Buy"  && ASK >= arrPrezzSq[11]) a = true;
if(BuySell=="Sell" && BID <= arrPrezzSq[12]) a = true;
return a;
}

//+------------------------------------------------------------------+
//|                           SqNine()                               |
//+------------------------------------------------------------------+
void SqNine(double &arrPrice[], const string &arrString[], const int &arrInt[], const bool &arrBool[], const color &arrColo[])
  // {
  {

   /*
   GannInputDigit  = arrInt[0];
   Divis           = arrInt[1];
   PipDeviation    = arrInt[2];
   ResistanceType  = arrInt[3];
   ResistanceWidth = arrInt[4];
   SupportType     = arrInt[5];
   SupportWidth    = arrInt[6];
   Alert1          = arrInt[7];
   Alert2          = arrInt[8];
   XDistance       = arrInt[9];
   YDistance       = arrInt[10];
   Width           = arrInt[11];
   Hight           = arrInt[12];

   visualChart     = arrBool[0];
   ShortLines      = arrBool[1];
   ShowLineName    = arrBool[2];
   DrawBackground  = arrBool[3];
   DisableSelection= arrBool[4];
   ButtonEnable    = arrBool[5];
   GannInputType   = arrBool[6];
   visualThresUp   = arrBool[7];
   visualThresDw   = arrBool[8];

   GannCustomPrice = arrString[0];
   Label           = arrString[1];
   pcode           = arrString[2];
   buttonID        = arrString[3];

   ResistanceColor = arrColo[0];
   SupportColor    = arrColo[1];
   BuyAboveColor   = arrColo[2];
   SellBelowColor  = arrColo[3];
   ThresholdColor  = arrColo[4];
*/
   clearObj();

   priceIn = NormalizeDouble(arrPrice[0],Digits());

   GannObj gann(priceIn,GannInputDigit,iClose(Symbol(),PERIOD_CURRENT,1),Digits());


   arrPrice[1] = R1Price;
   arrPrice[2] = R2Price;
   arrPrice[3] = R3Price;
   arrPrice[4] = R4Price;
   arrPrice[5] = R5Price;

   arrPrice[6] = S1Price;
   arrPrice[7] = S2Price;
   arrPrice[8] = S3Price;
   arrPrice[9] = S4Price;
   arrPrice[10]= S5Price;
   arrPrice[11]= BuyAbove;
   arrPrice[12]= SellBelow;

   PivotDay    = arrPrice[13];
   PivotWeek   = arrPrice[14];

  // ThresholdUp = NormalizeDouble( arrPrice[15],Digits());
  // ThresholdDw = NormalizeDouble( arrPrice[16],Digits());
//Print(" BuyAbove ",BuyAbove," R1Price ",R1Price," R2Price ",R2Price," R3Price ",R3Price," R4Price ",R4Price," R5Price ",R5Price);
//Print(" SellBelow ",SellBelow," S1Price ",S1Price," S2Price ",S2Price," S3Price ",S3Price," S4Price ",S4Price," S5Price ",S5Price);

   if(ShortLines)
      drawRectangleLine();
   else
      drawHorizontalLine();
   writeLineName();
   checkAlarmPrice();

   EventKillTimer();

   ObjectDelete(0,buttonID);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkAlarmPrice()
  {
   double ClosePrice[1];
   CopyClose(Symbol(),0,0,1,ClosePrice);

   string message="";
   NewAlert=LastAlert;

   if(ClosePrice[0]>=R5Price-(Point()*PipDeviation)    && ClosePrice[0]<=R5Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R5");
   if(ClosePrice[0]>=R4Price-(Point()*PipDeviation)    && ClosePrice[0]<=R4Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R4");
   if(ClosePrice[0]>=R3Price-(Point()*PipDeviation)    && ClosePrice[0]<=R3Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R3");
   if(ClosePrice[0]>=R2Price-(Point()*PipDeviation)    && ClosePrice[0]<=R2Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R2");
   if(ClosePrice[0]>=R1Price-(Point()*PipDeviation)    && ClosePrice[0]<=R1Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R1");
   if(ClosePrice[0]>=S1Price-(Point()*PipDeviation)    && ClosePrice[0]<=S1Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S1");
   if(ClosePrice[0]>=S2Price-(Point()*PipDeviation)    && ClosePrice[0]<=S2Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S2");
   if(ClosePrice[0]>=S3Price-(Point()*PipDeviation)    && ClosePrice[0]<=S3Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S3");
   if(ClosePrice[0]>=S4Price-(Point()*PipDeviation)    && ClosePrice[0]<=S4Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S4");
   if(ClosePrice[0]>=S5Price-(Point()*PipDeviation)    && ClosePrice[0]<=S5Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S5");


   if(NewAlert!=LastAlert)
     {
      message = getAlertMessage(NewAlert,ClosePrice[0]);

      if(Alert1 == 1)PlaySound("Alert");
      if(Alert1 == 2)Alert(message);
      if(Alert1 == 3)SendNotification(message);
      if(Alert1 == 4)SendMail("All in One Pivot Point - ",message);

      if(Alert1 != Alert2)
        {
         if(Alert2 == 1)PlaySound("Alert");
         if(Alert2 == 2)Alert(message);
         if(Alert2 == 3)SendNotification(message);
         if(Alert2 == 4)SendMail("All in One Pivot Point - ",message);
        }

      GlobalVariableSet(chartiD+"-"+"LastAlert",NewAlert);
      LastAlert=NewAlert;
     }
  }
//+------------------------------------------------------------------+
//|                    drawHorizontalLine()                          |
//+------------------------------------------------------------------+
void drawHorizontalLine()
  {
   datetime Time5[1];
   CopyTime(Symbol(),PERIOD_D1,0,1,Time5);

//Print(" R5Price ",R5Price);
   if(R5Price!=0)
     {
      if(ObjectFind(0,pcode+"R5")<0)
         ObjectCreate(0,pcode+"R5", OBJ_HLINE, 0, Time5[0], R5Price);
      else
         ObjectMove(0,pcode+"R5",0,Time5[0],R5Price);

      ObjectSetInteger(0,pcode+"R5", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_HIDDEN, true);
     }

   if(R4Price!=0)
     {
      if(ObjectFind(0,pcode+"R4")<0)
         ObjectCreate(0,pcode+"R4", OBJ_HLINE, 0, Time5[0], R4Price);
      else
         ObjectMove(0,pcode+"R4",0,Time5[0],R4Price);

      ObjectSetInteger(0,pcode+"R4", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_HIDDEN, true);
     }

   if(R3Price!=0)
     {
      if(ObjectFind(0,pcode+"R3")<0)
         ObjectCreate(0,pcode+"R3", OBJ_HLINE, 0, Time5[0], R3Price);
      else
         ObjectMove(0,pcode+"R3",0,Time5[0],R3Price);

      ObjectSetInteger(0,pcode+"R3", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_HIDDEN, true);
     }

   if(R2Price!=0)
     {
      if(ObjectFind(0,pcode+"R2")<0)
         ObjectCreate(0,pcode+"R2", OBJ_HLINE, 0, Time5[0], R2Price);
      else
         ObjectMove(0,pcode+"R2",0,Time5[0],R2Price);

      ObjectSetInteger(0,pcode+"R2", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_HIDDEN, true);
     }

   if(R1Price!=0)
     {
      if(ObjectFind(0,pcode+"R1")<0)
         ObjectCreate(0,pcode+"R1", OBJ_HLINE, 0, Time5[0], R1Price);
      else
         ObjectMove(0,pcode+"R1",0,Time5[0],R1Price);

      ObjectSetInteger(0,pcode+"R1", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_HIDDEN, true);
     }

   if(BuyAbove!=0)
     {
      if(ObjectFind(0,pcode+"Compra Sopra")<0)
         ObjectCreate(0,pcode+"Compra Sopra", OBJ_HLINE, 0, Time5[0], BuyAbove);
      else
         ObjectMove(0,pcode+"Compra Sopra",0,Time5[0],BuyAbove);

      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_COLOR, BuyAboveColor);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_HIDDEN, true);
     }


   if(priceIn!=0)
     {
      if(ObjectFind(0,pcode+"Pivot Line")<0)
         ObjectCreate(0,pcode+"Pivot Line", OBJ_HLINE, 0, Time5[0], priceIn);
      else
         ObjectMove(0,pcode+"Pivot Line",0,Time5[0],priceIn);

      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_COLOR, clrTurquoise);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_HIDDEN, true);
     }

   if(PivotWeek!=0)
     {
      if(ObjectFind(0,pcode+"PivotW")<0)
         ObjectCreate(0,pcode+"PivotW", OBJ_HLINE, 0, Time5[0], PivotWeek);
      else
         ObjectMove(0,pcode+"PivotW",0,Time5[0],PivotWeek);

      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_HIDDEN, true);
     }

   if(PivotDay!=0)
     {
      if(ObjectFind(0,pcode+"PivotDay")<0)
         ObjectCreate(0,pcode+"PivotDay", OBJ_HLINE, 0, Time5[0], PivotDay);
      else
         ObjectMove(0,pcode+"PivotDay",0,Time5[0],PivotDay);

      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_COLOR, clrPink);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_HIDDEN, true);
     }


   if(SellBelow!=0)
     {
      if(ObjectFind(0,pcode+"Vendi Sotto")<0)
         ObjectCreate(0,pcode+"Vendi Sotto", OBJ_HLINE, 0, Time5[0], SellBelow);
      else
         ObjectMove(0,pcode+"Vendi Sotto",0,Time5[0],SellBelow);

      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_COLOR, SellBelowColor);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }                                                      

   if(ThresholdUp!=0&&visualThresUp)
     {
      if(ObjectFind(0,pcode+"Soglia Up")<0)
         ObjectCreate(0,pcode+"Soglia Up", OBJ_HLINE, 0, Time5[0], ThresholdUp);
      else
         ObjectMove(0,pcode+"Soglia Up",0,Time5[0],ThresholdUp);

      ObjectSetInteger(0,pcode+"Soglia Up", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Soglia Up", OBJPROP_COLOR, ThresholdColor);
      ObjectSetInteger(0,pcode+"Soglia Up", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Soglia Up", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Soglia Up", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Soglia Up", OBJPROP_HIDDEN, true);
     }


   if(ThresholdDw!=0&&visualThresDw)
     {
      if(ObjectFind(0,pcode+"Soglia Dw")<0)
         ObjectCreate(0,pcode+"Soglia Dw", OBJ_HLINE, 0, Time5[0], ThresholdDw);
      else
         ObjectMove(0,pcode+"Soglia Dw",0,Time5[0],ThresholdDw);

      ObjectSetInteger(0,pcode+"Soglia Dw", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"Soglia Dw", OBJPROP_COLOR, ThresholdColor);
      ObjectSetInteger(0,pcode+"Soglia Dw", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"Soglia Dw", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Soglia Dw", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Soglia Dw", OBJPROP_HIDDEN, true);
     }


   if(S1Price!=0)
     {
      if(ObjectFind(0,pcode+"S1")<0)
         ObjectCreate(0,pcode+"S1", OBJ_HLINE, 0, Time5[0], S1Price);
      else
         ObjectMove(0,pcode+"S1",0,Time5[0],S1Price);

      ObjectSetInteger(0,pcode+"S1", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_HIDDEN, true);
     }

   if(S2Price!=0)
     {
      if(ObjectFind(0,pcode+"S2")<0)
         ObjectCreate(0,pcode+"S2", OBJ_HLINE, 0, Time5[0], S2Price);
      else
         ObjectMove(0,pcode+"S2",0,Time5[0],S2Price);

      ObjectSetInteger(0,pcode+"S2", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_HIDDEN, true);
     }

   if(S3Price!=0)
     {
      if(ObjectFind(0,pcode+"S3")<0)
         ObjectCreate(0,pcode+"S3", OBJ_HLINE, 0, Time5[0], S3Price);
      else
         ObjectMove(0,pcode+"S3",0,Time5[0],S3Price);

      ObjectSetInteger(0,pcode+"S3", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_HIDDEN, true);
     }

   if(S4Price!=0)
     {
      if(ObjectFind(0,pcode+"S4")<0)
         ObjectCreate(0,pcode+"S4", OBJ_HLINE, 0, Time5[0], S4Price);
      else
         ObjectMove(0,pcode+"S4",0,Time5[0],S4Price);

      ObjectSetInteger(0,pcode+"S4", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_HIDDEN, true);
     }

   if(S5Price!=0)
     {
      if(ObjectFind(0,pcode+"S5")<0)
         ObjectCreate(0,pcode+"S5", OBJ_HLINE, 0, Time5[0], S5Price);
      else
         ObjectMove(0,pcode+"S5",0,Time5[0],S5Price);

      ObjectSetInteger(0,pcode+"S5", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_HIDDEN, true);
     }
  }
//+------------------------------------------------------------------+
//|                      drawRectangleLine                           |
//+------------------------------------------------------------------+
void drawRectangleLine()
  {
   datetime time1,time2,Time5[1];

   Time5[0]=0;
   CopyTime(Symbol(),PERIOD_CURRENT,0,1,Time5);
   time1 = Time5[0]-(PeriodSeconds(Period())*50);

   CopyTime(Symbol(),Period(),0,1,Time5);
   time2 = Time5[0]+(PeriodSeconds(Period())*50);
//if(symbol_== "XAUUSD")Print(" sogliaSup ",sogliaSup," sogliaInf ",sogliaInf," time1 ",time1," time2 ",time2);
   if(R5Price!=0)
     {
      if(ObjectFind(0,pcode+"R5")<0)
         {ObjectCreate(0,pcode+"R5", OBJ_TREND, 0, time1, R5Price, time2, R5Price);}
      else
        {
         ObjectMove(0,pcode+"R5",0,time1,R5Price);
         ObjectMove(0,pcode+"R5",1,time2,R5Price);
        }

      ObjectSetInteger(0,pcode+"R5", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R5", OBJPROP_HIDDEN, true);
     }

   if(R4Price!=0)
     {
      if(ObjectFind(0,pcode+"R4")<0)
        {
         ObjectCreate(0,pcode+"R4", OBJ_TREND,0,time1,R4Price,time2,R4Price);

        }
      else
        {
         ObjectMove(0,pcode+"R4",0,time1,R4Price);
         ObjectMove(0,pcode+"R4",1,time2,R4Price);
        }

      ObjectSetInteger(0,pcode+"R4", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R4", OBJPROP_HIDDEN, true);

     }

   if(R3Price!=0)
     {
      if(ObjectFind(0,pcode+"R3")<0)
         ObjectCreate(0,pcode+"R3", OBJ_TREND,0,time1,R3Price,time2,R3Price);
      else
        {
         ObjectMove(0,pcode+"R3",0,time1,R3Price);
         ObjectMove(0,pcode+"R3",1,time2,R3Price);
        }
      ObjectSetInteger(0,pcode+"R3", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R3", OBJPROP_HIDDEN, true);

     }

   if(R2Price!=0)
     {
      if(ObjectFind(0,pcode+"R2")<0)
         ObjectCreate(0,pcode+"R2", OBJ_TREND,0,time1,R2Price,time2,R2Price);
      else
        {
         ObjectMove(0,pcode+"R2",0,time1,R2Price);
         ObjectMove(0,pcode+"R2",1,time2,R2Price);
        }

      ObjectSetInteger(0,pcode+"R2", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R2", OBJPROP_HIDDEN, true);

     }

   if(R1Price!=0)
     {
      if(ObjectFind(0,pcode+"R1")<0)
         ObjectCreate(0,pcode+"R1", OBJ_TREND,0,time1,R1Price,time2,R1Price);
      else
        {
         ObjectMove(0,pcode+"R1",0,time1,R1Price);
         ObjectMove(0,pcode+"R1",1,time2,R1Price);
        }

      ObjectSetInteger(0,pcode+"R1", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_COLOR, ResistanceColor);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"R1", OBJPROP_HIDDEN, true);
     }

   if(BuyAbove!=0)
     {
      if(ObjectFind(0,pcode+"Compra Sopra")<0)
         ObjectCreate(0,pcode+"Compra Sopra", OBJ_TREND,0,time1,BuyAbove,time2,BuyAbove);
      else
        {
         ObjectMove(0,pcode+"Compra Sopra",0,time1,BuyAbove);
         ObjectMove(0,pcode+"Compra Sopra",1,time2,BuyAbove);
        }

      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_COLOR, BuyAboveColor);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_HIDDEN, true);
     }

   if(priceIn!=0)
     {
      if(ObjectFind(0,pcode+"Pivot Line")<0)
         ObjectCreate(0,pcode+"Pivot Line", OBJ_TREND,0,time1,priceIn,time2,priceIn);
      else
        {
         ObjectMove(0,pcode+"Pivot Line",0,time1,priceIn);
         ObjectMove(0,pcode+"Pivot Line",1,time2,priceIn);
        }

      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_COLOR, clrTurquoise);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Pivot Line", OBJPROP_HIDDEN, true);
     }


   if(PivotWeek!=0)
     {
      if(ObjectFind(0,pcode+"PivotW")<0)
         ObjectCreate(0,pcode+"PivotW", OBJ_TREND,0,time1,PivotWeek,time2,PivotWeek);
      else
        {
         ObjectMove(0,pcode+"PivotW",0,time1,PivotWeek);
         ObjectMove(0,pcode+"PivotW",1,time2,PivotWeek);
        }

      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"PivotW", OBJPROP_HIDDEN, true);
     }

   if(PivotDay!=0)
     {
      if(ObjectFind(0,pcode+"PivotDay")<0)
         ObjectCreate(0,pcode+"PivotDay", OBJ_TREND,0,time1,PivotDay,time2,PivotDay);
      else
        {
         ObjectMove(0,pcode+"PivotDay",0,time1,PivotDay);
         ObjectMove(0,pcode+"PivotDay",1,time2,PivotDay);
        }

      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_COLOR, clrPink);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"PivotDay", OBJPROP_HIDDEN, true);
     }

   if(SellBelow!=0)
     {
      if(ObjectFind(0,pcode+"Vendi Sotto")<0)
         ObjectCreate(0,pcode+"Vendi Sotto", OBJ_TREND,0,time1,SellBelow,time2,SellBelow);
      else
        {
         ObjectMove(0,pcode+"Vendi Sotto",0,time1,SellBelow);
         ObjectMove(0,pcode+"Vendi Sotto",1,time2,SellBelow);
        }

      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_COLOR, SellBelowColor);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }


   if(ThresholdUp!=0&&visualThresUp)
     {
      if(ObjectFind(0,pcode+"Threshold_Up")<0)
         ObjectCreate(0,pcode+"Threshold_Up", OBJ_TREND,0,time1,ThresholdUp,time2,ThresholdUp);
      else
        {
         ObjectMove(0,pcode+"Threshold_Up",0,time1,ThresholdUp);
         ObjectMove(0,pcode+"Threshold_Up",1,time2,ThresholdUp);
        }

      ObjectSetInteger(0,pcode+"Threshold_Up", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Threshold_Up", OBJPROP_COLOR, ThresholdColor);
      ObjectSetInteger(0,pcode+"Threshold_Up", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Threshold_Up", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Threshold_Up", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Threshold_Up", OBJPROP_HIDDEN, true);
     }

   if(ThresholdDw!=0&&visualThresDw)
     {
      if(ObjectFind(0,pcode+"Threshold_Dw")<0)
         ObjectCreate(0,pcode+"Threshold_Dw", OBJ_TREND,0,time1,ThresholdDw,time2,ThresholdDw);
      else
        {
         ObjectMove(0,pcode+"Threshold_Dw",0,time1,ThresholdDw);
         ObjectMove(0,pcode+"Threshold_Dw",1,time2,ThresholdDw);
        }

      ObjectSetInteger(0,pcode+"Threshold_Dw", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"Threshold_Dw", OBJPROP_COLOR, ThresholdColor);
      ObjectSetInteger(0,pcode+"Threshold_Dw", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"Threshold_Dw", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Threshold_Dw", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Threshold_Dw", OBJPROP_HIDDEN, true);
     }


   if(S1Price!=0)
     {
      if(ObjectFind(0,pcode+"S1")<0)
         ObjectCreate(0,pcode+"S1", OBJ_TREND,0,time1,S1Price,time2,S1Price);
      else
        {
         ObjectMove(0,pcode+"S1",0,time1,S1Price);
         ObjectMove(0,pcode+"S1",1,time2,S1Price);
        }
      ObjectSetInteger(0,pcode+"S1", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S1", OBJPROP_HIDDEN, true);
     }

   if(S2Price!=0)
     {
      if(ObjectFind(0,pcode+"S2")<0)
         ObjectCreate(0,pcode+"S2", OBJ_TREND,0,time1,S2Price,time2,S2Price);
      else
        {
         ObjectMove(0,pcode+"S2",0,time1,S2Price);
         ObjectMove(0,pcode+"S2",1,time2,S2Price);
        }

      ObjectSetInteger(0,pcode+"S2", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S2", OBJPROP_HIDDEN, true);

     }

   if(S3Price!=0)
     {
      if(ObjectFind(0,pcode+"S3")<0)
         ObjectCreate(0,pcode+"S3", OBJ_TREND,0,time1,S3Price,time2,S3Price);
      else
        {
         ObjectMove(0,pcode+"S3",0,time1,S3Price);
         ObjectMove(0,pcode+"S3",1,time2,S3Price);
        }

      ObjectSetInteger(0,pcode+"S3", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S3", OBJPROP_HIDDEN, true);


     }

   if(S4Price!=0)
     {
      if(ObjectFind(0,pcode+"S4")<0)
         ObjectCreate(0,pcode+"S4", OBJ_TREND,0,time1,S4Price,time2,S4Price);
      else
        {
         ObjectMove(0,pcode+"S4",0,time1,S4Price);
         ObjectMove(0,pcode+"S4",1,time2,S4Price);
        }

      ObjectSetInteger(0,pcode+"S4", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S4", OBJPROP_HIDDEN, true);


     }

   if(S5Price!=0)
     {
      if(ObjectFind(0,pcode+"S5")<0)
        {
         ObjectCreate(0,pcode+"S5", OBJ_TREND,0,time1,S5Price,time2,S5Price);
        }
      else
        {
         ObjectMove(0,pcode+"S5",0,time1,S5Price);
         ObjectMove(0,pcode+"S5",1,time2,S5Price);
        }

      ObjectSetInteger(0,pcode+"S5", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_COLOR, SupportColor);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"S5", OBJPROP_HIDDEN, true);

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void writeLineName()
  {

   datetime time2,Time5[1];

   Time5[0]=0;

   CopyTime(Symbol(),Period(),0,1,Time5);

   if(!MQLInfoInteger(MQL_TESTER))
     {
      if(!ChartGetInteger(0,CHART_SHIFT,0)){time2 = Time5[0]-(PeriodSeconds(Period())*8);}
      else{time2 = Time5[0]+(PeriodSeconds(Period())*8);}
     }
   else
     {
      if(!ChartGetInteger(0,CHART_SHIFT,0)){time2 = Time5[0]-(PeriodSeconds(Period())*8);}
      else{time2 = Time5[0]+(PeriodSeconds(Period()));}
     }

   if(ShowLineName)
     {
      if(R5Price!=0)
        {
         if(ObjectFind(0,pcode+"R5T")<0)
           {
            ObjectCreate(0,pcode+"R5T", OBJ_TEXT,0,time2,R5Price);
            ObjectSetString(0,pcode+"R5T",OBJPROP_TEXT,pcode+"R5 "+DoubleToString(NormalizeDouble(R5Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"R5T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"R5T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"R5T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"R5T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"R5T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"R5T",0,time2,R5Price);
            ObjectSetString(0,pcode+"R5T",OBJPROP_TEXT,pcode+"R5 "+DoubleToString(NormalizeDouble(R5Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"R5T",OBJPROP_COLOR,ResistanceColor);
        }

      if(R4Price!=0)
        {
         if(ObjectFind(0,pcode+"R4T")<0)
           {
            ObjectCreate(0,pcode+"R4T", OBJ_TEXT,0,time2,R4Price);
            ObjectSetString(0,pcode+"R4T",OBJPROP_TEXT,pcode+"R4 "+DoubleToString(NormalizeDouble(R4Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"R4T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"R4T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"R4T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"R4T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"R4T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"R4T",0,time2,R4Price);
            ObjectSetString(0,pcode+"R4T",OBJPROP_TEXT,pcode+"R4 "+DoubleToString(NormalizeDouble(R4Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"R4T",OBJPROP_COLOR,ResistanceColor);
        }

      if(R3Price!=0)
        {
         if(ObjectFind(0,pcode+"R3T")<0)
           {
            ObjectCreate(0,pcode+"R3T", OBJ_TEXT,0,time2,R3Price);
            ObjectSetString(0,pcode+"R3T",OBJPROP_TEXT,pcode+"R3 "+DoubleToString(NormalizeDouble(R3Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"R3T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"R3T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"R3T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"R3T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"R3T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"R3T",0,time2,R3Price);
            ObjectSetString(0,pcode+"R3T",OBJPROP_TEXT,pcode+"R3 "+DoubleToString(NormalizeDouble(R3Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"R3T",OBJPROP_COLOR,ResistanceColor);
        }

      if(R2Price!=0)
        {
         if(ObjectFind(0,pcode+"R2T")<0)
           {
            ObjectCreate(0,pcode+"R2T", OBJ_TEXT,0,time2,R2Price);
            ObjectSetString(0,pcode+"R2T",OBJPROP_TEXT,pcode+"R2 "+DoubleToString(NormalizeDouble(R2Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"R2T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"R2T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"R2T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"R2T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"R2T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"R2T",0,time2,R2Price);
            ObjectSetString(0,pcode+"R2T",OBJPROP_TEXT,pcode+"R2 "+DoubleToString(NormalizeDouble(R2Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"R2T",OBJPROP_COLOR,ResistanceColor);
        }

      if(R1Price!=0)
        {
         if(ObjectFind(0,pcode+"R1T")<0)
           {
            ObjectCreate(0,pcode+"R1T", OBJ_TEXT,0,time2,R1Price);
            ObjectSetString(0,pcode+"R1T",OBJPROP_TEXT,pcode+"R1 "+DoubleToString(NormalizeDouble(R1Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"R1T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"R1T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"R1T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"R1T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"R1T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"R1T",0,time2,R1Price);
            ObjectSetString(0,pcode+"R1T",OBJPROP_TEXT,pcode+"R1 "+DoubleToString(NormalizeDouble(R1Price,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"R1T",OBJPROP_COLOR,ResistanceColor);
        }
      if(BuyAbove!=0)
        {
         if(ObjectFind(0,pcode+"Buy_Above")<0)
           {
            ObjectCreate(0,pcode+"Buy_Above", OBJ_TEXT,0,time2,BuyAbove);
            ObjectSetString(0,pcode+"Buy_Above",OBJPROP_TEXT,pcode+"Buy_Above"+DoubleToString(NormalizeDouble(BuyAbove,Digits()),Digits()));
            ObjectSetString(0,pcode+"Buy_Above",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Buy_Above",0,time2,BuyAbove);
            ObjectSetString(0,pcode+"Buy_Above",OBJPROP_TEXT,pcode+"Buy_Above  "+DoubleToString(NormalizeDouble(BuyAbove,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_COLOR,BuyAboveColor);
        }
      if(priceIn!=0)
        {
         if(ObjectFind(0,pcode+"Pivot")<0)
           {
            ObjectCreate(0,pcode+"Pivot", OBJ_TEXT,0,time2,priceIn);
            ObjectSetString(0,pcode+"Pivot",OBJPROP_TEXT,pcode+"Pivot"+DoubleToString(NormalizeDouble(priceIn,Digits()),Digits()));
            ObjectSetString(0,pcode+"Pivot",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Pivot",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Pivot",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Pivot",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Pivot",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Pivot",0,time2,priceIn);
            ObjectSetString(0,pcode+"Pivot",OBJPROP_TEXT,pcode+"Pivot  "+DoubleToString(NormalizeDouble(priceIn,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"Pivot",OBJPROP_COLOR,clrTurquoise);
        }
      if(PivotWeek!=0)
        {
         if(ObjectFind(0,pcode+"PivotWeek")<0)
           {
            ObjectCreate(0,pcode+"PivotWeek", OBJ_TEXT,0,time2,PivotWeek);
            ObjectSetString(0,pcode+"PivotWeek",OBJPROP_TEXT,pcode+"PivotWeek"+DoubleToString(NormalizeDouble(PivotWeek,Digits()),Digits()));
            ObjectSetString(0,pcode+"PivotWeek",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"PivotWeek",0,time2,PivotWeek);
            ObjectSetString(0,pcode+"PivotWeek",OBJPROP_TEXT,pcode+"PivotWeek "+DoubleToString(NormalizeDouble(PivotWeek,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_COLOR,clrYellow);
        }

      if(PivotDay!=0)
        {
         if(ObjectFind(0,pcode+"PivotD")<0)
           {
            ObjectCreate(0,pcode+"PivotD", OBJ_TEXT,0,time2,PivotDay);
            ObjectSetString(0,pcode+"PivotD",OBJPROP_TEXT,pcode+"PivotD"+DoubleToString(NormalizeDouble(PivotDay,Digits()),Digits()));
            ObjectSetString(0,pcode+"PivotD",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"PivotD",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"PivotD",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"PivotD",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"PivotD",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"PivotD",0,time2,PivotDay);
            ObjectSetString(0,pcode+"PivotD",OBJPROP_TEXT,pcode+"PivotDay "+DoubleToString(NormalizeDouble(PivotDay,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"PivotD",OBJPROP_COLOR,clrPink);
        }
      if(SellBelow!=0)
        {
         if(ObjectFind(0,pcode+"Sell_Below")<0)
           {
            ObjectCreate(0,pcode+"Sell_Below", OBJ_TEXT,0,time2,SellBelow);
            ObjectSetString(0,pcode+"Sell_Below",OBJPROP_TEXT,pcode+"Sell_Below"+DoubleToString(NormalizeDouble(SellBelow,Digits()),Digits()));
            ObjectSetString(0,pcode+"Sell_Below",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Sell_Below",0,time2,SellBelow);
            ObjectSetString(0,pcode+"Sell_Below",OBJPROP_TEXT,pcode+"Sell_Below  "+DoubleToString(NormalizeDouble(SellBelow,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_COLOR,SellBelowColor);
        }
      if(ThresholdUp!=0&&visualThresUp)
        {
         if(ObjectFind(0,pcode+"Threshold_Up ")<0)
           {
            ObjectCreate(0,pcode+"Threshold_Up ", OBJ_TEXT,0,time2,ThresholdUp);
            ObjectSetString(0,pcode+"Threshold_Up ",OBJPROP_TEXT,pcode+"Threshold_Up  "+DoubleToString(NormalizeDouble(ThresholdUp,Digits()),Digits()));
            ObjectSetString(0,pcode+"Threshold_Up ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Threshold_Up ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Threshold_Up ",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Threshold_Up ",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Threshold_Up ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Threshold_Up ",0,time2,ThresholdUp);
            ObjectSetString(0,pcode+"Threshold_Up ",OBJPROP_TEXT,pcode+"Threshold_Up  "+DoubleToString(NormalizeDouble(ThresholdUp,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"Threshold_Up ",OBJPROP_COLOR,ThresholdColor);
        }
      if(ThresholdDw!=0&&visualThresDw)
        {
         if(ObjectFind(0,pcode+"Threshold_Dw ")<0)
           {
            ObjectCreate(0,pcode+"Threshold_Dw ", OBJ_TEXT,0,time2,ThresholdDw);
            ObjectSetString(0,pcode+"Threshold_Dw ",OBJPROP_TEXT,pcode+"Threshold_Dw  "+DoubleToString(NormalizeDouble(ThresholdDw,Digits()),Digits()));
            ObjectSetString(0,pcode+"Threshold_Dw ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Threshold_Dw ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Threshold_Dw ",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Threshold_Dw ",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Threshold_Dw ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Threshold_Dw ",0,time2,ThresholdDw);
            ObjectSetString(0,pcode+"Threshold_Dw ",OBJPROP_TEXT,pcode+"Threshold_Dw  "+DoubleToString(NormalizeDouble(ThresholdDw,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"Threshold_Dw ",OBJPROP_COLOR,ThresholdColor);
        }
      if(S1Price!=0)
        {
         if(ObjectFind(0,pcode+"S1T")<0)
           {
            ObjectCreate(0,pcode+"S1T", OBJ_TEXT,0,time2,S1Price);
            ObjectSetString(0,pcode+"S1T",OBJPROP_TEXT,pcode+"S1 "+DoubleToString(NormalizeDouble(S1Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"S1T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"S1T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"S1T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"S1T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"S1T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"S1T",0,time2,S1Price);
            ObjectSetString(0,pcode+"S1T",OBJPROP_TEXT,pcode+"S1 "+DoubleToString(NormalizeDouble(S1Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"S1T",OBJPROP_COLOR,SupportColor);
        }
      if(S2Price!=0)
        {
         if(ObjectFind(0,pcode+"S2T")<0)
           {
            ObjectCreate(0,pcode+"S2T", OBJ_TEXT,0,time2,S2Price);
            ObjectSetString(0,pcode+"S2T",OBJPROP_TEXT,pcode+"S2 "+DoubleToString(NormalizeDouble(S2Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"S2T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"S2T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"S2T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"S2T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"S2T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"S2T",0,time2,S2Price);
            ObjectSetString(0,pcode+"S2T",OBJPROP_TEXT,pcode+"S2 "+DoubleToString(NormalizeDouble(S2Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"S2T",OBJPROP_COLOR,SupportColor);
        }
      if(S3Price!=0)
        {
         if(ObjectFind(0,pcode+"S3T")<0)
           {
            ObjectCreate(0,pcode+"S3T", OBJ_TEXT,0,time2,S3Price);
            ObjectSetString(0,pcode+"S3T",OBJPROP_TEXT,pcode+"S3 "+DoubleToString(NormalizeDouble(S3Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"S3T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"S3T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"S3T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"S3T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"S3T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"S3T",0,time2,S3Price);
            ObjectSetString(0,pcode+"S3T",OBJPROP_TEXT,pcode+"S3 "+DoubleToString(NormalizeDouble(S3Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"S3T",OBJPROP_COLOR,SupportColor);
        }
      if(S4Price!=0)
        {
         if(ObjectFind(0,pcode+"S4T")<0)
           {
            ObjectCreate(0,pcode+"S4T", OBJ_TEXT,0,time2,S4Price);
            ObjectSetString(0,pcode+"S4T",OBJPROP_TEXT,pcode+"S4 "+DoubleToString(NormalizeDouble(S4Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"S4T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"S4T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"S4T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"S4T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"S4T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"S4T",0,time2,S4Price);
            ObjectSetString(0,pcode+"S4T",OBJPROP_TEXT,pcode+"S4 "+DoubleToString(NormalizeDouble(S4Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"S4T",OBJPROP_COLOR,SupportColor);
        }
      if(S5Price!=0)
        {
         if(ObjectFind(0,pcode+"S5T")<0)
           {
            ObjectCreate(0,pcode+"S5T", OBJ_TEXT,0,time2,S5Price);
            ObjectSetString(0,pcode+"S5T",OBJPROP_TEXT,pcode+"S5 "+DoubleToString(NormalizeDouble(S5Price,Digits()),Digits()));
            ObjectSetString(0,pcode+"S5T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"S5T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"S5T",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"S5T",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"S5T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"S5T",0,time2,S5Price);
            ObjectSetString(0,pcode+"S5T",OBJPROP_TEXT,pcode+"S5 "+DoubleToString(NormalizeDouble(S5Price,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode+"S5T",OBJPROP_COLOR,SupportColor);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string getAlertMessage(double alertID, double price)
  {
   string point = "";
   if(alertID==0)point = "R5";
   if(alertID==1)point = "R4";
   if(alertID==2)point = "R3";
   if(alertID==3)point = "R2";
   if(alertID==4)point = "R1";
   if(alertID==5)point = "S1";
   if(alertID==6)point = "S2";
   if(alertID==7)point = "S3";
   if(alertID==8)point = "S4";
   if(alertID==9)point = "S5";
   string message=Symbol()+" ("+DoubleToString(price)+"), the price arrived at "+pcode+point;
   return message;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getAlertID(string alertName)
  {
   int _return=-1;

   if(alertName=="R5")_return = 0;
   if(alertName=="R4")_return = 1;
   if(alertName=="R3")_return = 2;
   if(alertName=="R2")_return = 3;
   if(alertName=="R1")_return = 4;
   if(alertName=="S1")_return = 5;
   if(alertName=="S2")_return = 6;
   if(alertName=="S3")_return = 7;
   if(alertName=="S4")_return = 8;
   if(alertName=="S5")_return = 9;
   return _return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void clearObj()
  {
   if(ObjectFind(0,pcode+"R5")>=0)ObjectDelete(0,pcode+"R5");
   if(ObjectFind(0,pcode+"R4")>=0)ObjectDelete(0,pcode+"R4");
   if(ObjectFind(0,pcode+"R3")>=0)ObjectDelete(0,pcode+"R3");
   if(ObjectFind(0,pcode+"R2")>=0)ObjectDelete(0,pcode+"R2");
   if(ObjectFind(0,pcode+"R1")>=0)ObjectDelete(0,pcode+"R1");
   if(ObjectFind(0,pcode+"RD3")>=0)ObjectDelete(0,pcode+"RD3");
   if(ObjectFind(0,pcode+"RD2")>=0)ObjectDelete(0,pcode+"RD2");
   if(ObjectFind(0,pcode+"RD1")>=0)ObjectDelete(0,pcode+"RD1");
   if(ObjectFind(0,pcode+"rD3")>=0)ObjectDelete(0,pcode+"rD3");
   if(ObjectFind(0,pcode+"rD2")>=0)ObjectDelete(0,pcode+"rD2");
   if(ObjectFind(0,pcode+"rD1")>=0)ObjectDelete(0,pcode+"rD1");
   if(ObjectFind(0,pcode+"S1")>=0)ObjectDelete(0,pcode+"S1");
   if(ObjectFind(0,pcode+"S2")>=0)ObjectDelete(0,pcode+"S2");
   if(ObjectFind(0,pcode+"S3")>=0)ObjectDelete(0,pcode+"S3");
   if(ObjectFind(0,pcode+"S4")>=0)ObjectDelete(0,pcode+"S4");
   if(ObjectFind(0,pcode+"S5")>=0)ObjectDelete(0,pcode+"S5");
   if(ObjectFind(0,pcode+"R5T")>=0)ObjectDelete(0,pcode+"R5T");
   if(ObjectFind(0,pcode+"R4T")>=0)ObjectDelete(0,pcode+"R4T");
   if(ObjectFind(0,pcode+"R3T")>=0)ObjectDelete(0,pcode+"R3T");
   if(ObjectFind(0,pcode+"R2T")>=0)ObjectDelete(0,pcode+"R2T");
   if(ObjectFind(0,pcode+"R1T")>=0)ObjectDelete(0,pcode+"R1T");
   if(ObjectFind(0,pcode+"Buy_Above")>=0)ObjectDelete(0,pcode+"Buy_Above");

//   if(ObjectFind(0,pcode+"BuyT")>=0)
//      ObjectDelete(0,pcode+"BuyT");

   if(ObjectFind(0,pcode+"Compra Sopra")>=0)ObjectDelete(0,pcode+"Compra Sopra");
   if(ObjectFind(0,pcode+"Pivot Line")>=0)ObjectDelete(0,pcode+"Pivot Line");
   if(ObjectFind(0,pcode+"PivotW")>=0)ObjectDelete(0,pcode+"PivotW");
   if(ObjectFind(0,pcode+"PivotWeek")>=0)ObjectDelete(0,pcode+"PivotWeek");
   if(ObjectFind(0,pcode+"PivotDay")>=0)ObjectDelete(0,pcode+"PivotDay");
   if(ObjectFind(0,pcode+"PivotD")>=0)ObjectDelete(0,pcode+"PivotD");
   if(ObjectFind(0,pcode+"Vendi Sotto")>=0)ObjectDelete(0,pcode+"Vendi Sotto");
   if(ObjectFind(0,pcode+"Pivot")>=0)ObjectDelete(0,pcode+"Pivot");
   if(ObjectFind(0,pcode+"Sell_Below")>=0)ObjectDelete(0,pcode+"Sell_Below");
   if(ObjectFind(0,pcode+"Threshold_Dw")>=0)ObjectDelete(0,pcode+"Threshold_Dw");  
   if(ObjectFind(0,pcode+"Threshold_Dw  ")>=0)ObjectDelete(0,pcode+"Threshold_Dw  ");     
   if(ObjectFind(0,pcode+"Threshold_Dw ")>=0)ObjectDelete(0,pcode+"Threshold_Dw ");  
   if(ObjectFind(0,pcode+"Soglia Dw")>=0)ObjectDelete(0,pcode+"Soglia Dw");
   if(ObjectFind(0,pcode+"Soglia Up")>=0)ObjectDelete(0,pcode+"Soglia Up");

   if(ObjectFind(0,pcode+"Threshold_Up")>=0)ObjectDelete(0,pcode+"Threshold_Up");  
   if(ObjectFind(0,pcode+"Threshold_Up  ")>=0)ObjectDelete(0,pcode+"Threshold_Up  ");            
   if(ObjectFind(0,pcode+"Threshold_Up ")>=0)ObjectDelete(0,pcode+"Threshold_Up ");  
   if(ObjectFind(0,pcode+"PPT")>=0)ObjectDelete(0,pcode+"PPT");
   if(ObjectFind(0,pcode+"S1T")>=0)ObjectDelete(0,pcode+"S1T");
   if(ObjectFind(0,pcode+"S2T")>=0)ObjectDelete(0,pcode+"S2T");
   if(ObjectFind(0,pcode+"S3T")>=0)ObjectDelete(0,pcode+"S3T");
   if(ObjectFind(0,pcode+"S4T")>=0)ObjectDelete(0,pcode+"S4T");
   if(ObjectFind(0,pcode+"S5T")>=0)ObjectDelete(0,pcode+"S5T");
   if(ObjectFind(0,pcode+"SD3")>=0)ObjectDelete(0,pcode+"SD3");
   if(ObjectFind(0,pcode+"SD2")>=0)ObjectDelete(0,pcode+"SD2");
   if(ObjectFind(0,pcode+"SD1")>=0)ObjectDelete(0,pcode+"SD1");
   if(ObjectFind(0,pcode+"sD3")>=0)ObjectDelete(0,pcode+"sD3");
   if(ObjectFind(0,pcode+"sD2")>=0)ObjectDelete(0,pcode+"sD2");
   if(ObjectFind(0,pcode+"sD1")>=0)ObjectDelete(0,pcode+"sD1");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GannObj
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
                     GannObj(double _inputPrice, int _inputDigit, double _currentPrice,  int _outputDigit);
   double            convertPrice(double _outputPrice);
   double            getBuyAbove() {return convertPrice(buyAbove);}
   double            getbuyTarget1() {return convertPrice(buyTarget1);}
   double            getbuyTarget2() {return convertPrice(buyTarget2);}
   double            getbuyTarget3() {return convertPrice(buyTarget3);}
   double            getbuyTarget4() {return convertPrice(buyTarget4);}
   double            getbuyTarget5() {return convertPrice(buyTarget5);}

   double            getsellBelow() {return convertPrice(sellBelow);}
   double            getsellTarget1() {return convertPrice(sellTarget1);}
   double            getsellTarget2() {return convertPrice(sellTarget2);}
   double            getsellTarget3() {return convertPrice(sellTarget3);}
   double            getsellTarget4() {return convertPrice(sellTarget4);}
   double            getsellTarget5() {return convertPrice(sellTarget5);}

   double            getresistance1() {return convertPrice(resistance1);}
   double            getresistance2() {return convertPrice(resistance2);}
   double            getresistance3() {return convertPrice(resistance3);}
   double            getresistance4() {return convertPrice(resistance4);}
   double            getresistance5() {return convertPrice(resistance5);}
   double            getresistanceStopLoss() {return convertPrice(resistanceStopLoss);}

   double            getsupport1() {return convertPrice(support1);}
   double            getsupport2() {return convertPrice(support2);}
   double            getsupport3() {return convertPrice(support3);}
   double            getsupport4() {return convertPrice(support4);}
   double            getsupport5() {return convertPrice(support5);}
   double            getsupportStopLoss() {return convertPrice(supportStopLoss);}
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GannObj::convertPrice(double _outputPrice)
  {
   string result[];
   string strPrice=DoubleToString(currentPrice,outputDigit);
   ushort u_sep=StringGetCharacter(".",0);
   int k=StringSplit(strPrice,u_sep,result);
   double price=_outputPrice;
   
   if(k==1){price = NormalizeDouble(price,Digits());}
   else
     {
      int first  = StringLen(result[0]);
      int second = StringLen(result[1]);
      strPrice=DoubleToString(price);
      StringReplace(strPrice,".","");
      strPrice=StringSubstr(strPrice,0,first)+"."+StringSubstr(strPrice,first,second);
      price = StringToDouble(strPrice);
      price = NormalizeDouble(priceIn,Digits());
     }
   return priceIn;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GannObj::GannObj(double _inputPrice, int _inputDigit, double _currentPrice,  int _outputDigit)
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

   if((int)E4 == E4){F4 = E4+1;}
   else{F4 = MathCeil(E4);}

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

   buyAbove = (C10!=0) ? C9 : (C8!=0) ? C7 : (D7!=0) ? E7 : (F7!=0) ? G7 : (G8!=0) ? G9 : (G10!=0) ? G11 : (F11!=0) ? E11 : (D11!=0) ? C11 : (B11!=0) ? B9 : (B8!=0) ? B6 : (C6!=0) ? E6 : (F6!=0) ? H6 : (H7!=0) ? H9 : (H10!=0) ? H12 : (G12!=0) ? E12 : (D12!=0) ? B12 : 0;
   BuyAbove = buyAbove / DIv_(Divis);
   sellBelow = (C10!=0) ? D10 : (C8!=0) ? C9 : (D7!=0) ? C7 : (F7!=0) ? E7 : (G8!=0) ? G7 : (G10!=0) ? G9 : (F11!=0) ? G11 : (D11!=0) ? E11 : (B11!=0) ? C11 : (B8!=0) ? B9 : (C6!=0) ? B6 : (F6!=0) ? E6 : (H7!=0) ? H6 : (H10!=0) ? H9 : (G12!=0) ? H12 : (D12!=0) ? E12 : 0;
   SellBelow = sellBelow / DIv_(Divis);

   R1Price=buyTarget1 = resistance1 * 0.9995 / DIv_(Divis);
   R2Price=buyTarget2 = resistance2 * 0.9995 / DIv_(Divis);
   R3Price=buyTarget3 = resistance3 * 0.9995 / DIv_(Divis);
   R4Price=buyTarget4 = resistance4 * 0.9995 / DIv_(Divis);
   R5Price=buyTarget5 = resistance5 * 0.9995 / DIv_(Divis);

   S1Price=sellTarget1 = support1 * 1.0005 / DIv_(Divis);
   S2Price=sellTarget2 = support2 * 1.0005 / DIv_(Divis);
   S3Price=sellTarget3 = support3 * 1.0005 / DIv_(Divis);
   S4Price=sellTarget4 = support4 * 1.0005 / DIv_(Divis);
   S5Price=sellTarget5 = support5 * 1.0005 / DIv_(Divis);

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+Sposta la virgola a sx con Divis_ negativo del numero corrispondente (Divisione)
//|                     Divisione / Moltiplicazione                  |                e a dx con Divis_ positivo (moltiplicazione)
//+------------------------------------------------------------------+Restituisce "1" con Divis_ a Zero             
double DIv_(int divMolt)
  {
   double a = 0.0;
   switch(divMolt)
     {
      case -4 :a = 0.0001;break;
      case -3 :a =  0.001;break;
      case -2 :a =   0.01;break;
      case -1 :a =    0.1;break;
      case  0 :a =      1;break;
      case  1 :a =     10;break;
      case  2 :a =    100;break;
      case  3 :a =   1000;break;
      case  4 :a =  10000;break;
      case  5 :a = 100000;break;
      default :
         Alert("Divisione Input Gann ERRATA!");
     }
   return a;
  }  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK && sparam==buttonID)
     {
      clearObj();
      if(ObjectGetInteger(0,buttonID,OBJPROP_BGCOLOR)==clrRed)
        {
         ObjectSetInteger(0,buttonID,OBJPROP_BGCOLOR,clrGreen);
         showGann=0;
        }
      else
        {
         ObjectSetInteger(0,buttonID,OBJPROP_BGCOLOR,clrRed);
         showGann=1;
        }
      GlobalVariableSet(chartiD+"-"+"showGann",showGann);
      ObjectSetInteger(0,buttonID,OBJPROP_STATE,0);
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------+
    
//+------------------------------------------------------------------+
//|                        sogliaBuySell()                           |
//+------------------------------------------------------------------+ 
bool sogliaBuySell(string BuySell,double &SlZZPrecedente, datetime &timePiccoAlto, datetime &timePiccoBasso)
{
bool a = false;

double C1 = 0,H1 = 0,L1 = 0; 
//if(semCand)                     ////////////////////////////////////////
{C1 = iClose(symbol_,PERIOD_CURRENT,1);H1 = iHigh(symbol_,PERIOD_CURRENT,1);L1 = iLow(symbol_,PERIOD_CURRENT,1);}

int IndexZZ[100];ArrayInitialize(IndexZZ,0);
double ValZZ[100];ArrayInitialize(ValZZ,0);

static  int indexSogliaSup=0; static int indexSogliaInf=0;

int IndexZZZ[100];ArrayInitialize(IndexZZZ,0);
double ValZZZ[100];ArrayInitialize(ValZZZ,0);


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
//Print(" sogliaSup ",sogliaSup," sogliaInf ",sogliaInf);

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

if(sogliaSup && sogliaInf) datiSoglie = true; //else(Print("No dati soglie"));
}

if(datiSoglie && (H1>piccoalto || L1<piccobasso)) {datiSoglie=false;
sogliaSup=0;sogliaInf=0;indexSogliaInf=indexSogliaSup=0;piccoalto=piccobasso=0;a=0;
return a;}//////////////////////////////////////////////////////////

if(sogliaSup < sogliaInf){Commento=Commento+"\n\n Soglia Superiore inferiore alla Soglia Inferiore: No Open Order";
                           Print("Soglia Superiore inferiore alla Soglia Inferiore: No Open Order"); a = false;return a;}

bool percSogliaSogliaBuy  = percsogliasoglia("Buy");
bool percSogliaSogliaSell = percsogliasoglia("Sell");

if(
         //inclinometro(inclinometr) && 
         passasogliaprima("Buy") && BuySell=="Buy"  && percSogliaSogliaBuy && C1>sogliaInf 
      && C1<sogliaSup && numCandeleCongrue(direzCand_,"Buy", numCandDirez,timeFrCand)) 
      {a = true;
      //Print(" Congrue BUY ");
       return a;}

if(
         //inclinometro(inclinometr) && 
         passasogliaprima("Sell") && BuySell=="Sell" && percSogliaSogliaSell && C1<sogliaSup 
      && C1>sogliaInf && numCandeleCongrue(direzCand_,"Sell",numCandDirez,timeFrCand)) 
      {a = true;
      //Print(" Congrue SELL ");
       return a;}

return a;
}
//----------------------------------- pendcongruamaBuy() ---------------------------------------------
bool pendcongruamaBuy()
{
bool a = true;

if(numcandMacongrue<2){Alert("Impostazione \"numero candele x pendenza congrua\" ERRATA. Minimo \"2\"!");return a;}
if(pendmacongrua==0)return a;

double LabelBuffer1[];

ArrayInitialize(LabelBuffer1,0);ArraySetAsSeries(LabelBuffer1,true);
int copy1=CopyBuffer(handle_iCustomMAFast,0,1,numcandMacongrue,LabelBuffer1);if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");
/*
for(int i=0;i<ArraySize(LabelBuffer1);i++)
{
Print(i," ",LabelBuffer1[i]);}
*/
if(pendmacongrua==1)
{
for(int i=0;i<numcandMacongrue-1;i++)
{
//Print(" LabelBuffer1 BUY ",i ," ",LabelBuffer1[i]," LabelBuffer1 BUY ",i+1," ", LabelBuffer1[i+1]);
if(LabelBuffer1[i]>LabelBuffer1[i+1] && i>=numcandMacongrue-2) {a = true;return a;}
if(LabelBuffer1[i]<LabelBuffer1[i+1]) {a = false;return a;}
}
}
if(pendmacongrua==2)
{
//if(LabelBuffer1[0]>LabelBuffer1[numcandMacongrue-1]) {a = true;return a;}
if(LabelBuffer1[0]<LabelBuffer1[numcandMacongrue-1]) {a = false;return a;}
}
return a;
}
//----------------------------------- pendcongruamaSell() ---------------------------------------------
bool pendcongruamaSell()
{
bool a = true;
if(numcandMacongrue<2){Alert("Impostazione \"numero candele x pendenza congrua\" ERRATA. Minimo \"2\"!");return a;}
if(pendmacongrua==0)return a;

double LabelBuffer1[];

ArrayInitialize(LabelBuffer1,1);ArraySetAsSeries(LabelBuffer1,true);
int copy1=CopyBuffer(handle_iCustomMAFast,0,1,numcandMacongrue,LabelBuffer1);if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");

if(pendmacongrua==1)
{
for(int i=0;i<numcandMacongrue-1;i++)
{
//Print(" LabelBuffer1 SELL ",i ," ",LabelBuffer1[i]," LabelBuffer1 SELL ",i+1," ",LabelBuffer1[i+1]);
if(LabelBuffer1[i]<LabelBuffer1[i+1] && i>=numcandMacongrue-2) {a = true;return a;}
if(LabelBuffer1[i]>LabelBuffer1[i+1]) {a = false;return a;}
}
}
if(pendmacongrua==2)
{
//if(LabelBuffer1[0]<LabelBuffer1[numcandMacongrue-1]) {a = true;return a;}
if(LabelBuffer1[0]>LabelBuffer1[numcandMacongrue-1]) {a = false;return a;}
}
return a;
}
//----------------------------------- impulsoLivello() --------------------------------------------- 
void impulsoLivello(bool &ImpLivBuy,bool &ImpLivSell)
{

if(levelImpuls==1){ImpLivBuy=true;ImpLivSell=true;}

if(levelImpuls==0)
{
//if(sogliaSup==0 || sogliaInf==0) {a = false;return a;}
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
static string tipoultimoOrdine = "Flat";

static double oldsogliasup = 0, oldsogliainf = 0;
int   ordbuy  = NumOrdBuy(magicNumber,Commen);
int   ordsell = NumOrdSell(magicNumber,Commen);


if(!ordbuy && !ordsell && tipoultimoOrdine == "Flat")
{
if(doubleCompreso(C1,sogliaInf,sogliabuycons)){ImpLivBuy = true;}

if(doubleCompreso(C1,sogliaSup,sogliasellcons)){ImpLivSell = true;}
}


if(ordbuy)
{
if(ImpLivBuy && tipoultimoOrdine != "Buy"){ImpLivBuy = false; tipoultimoOrdine="Buy";oldsogliasup = sogliaSup; oldsogliainf = sogliaInf;}

if(tipoultimoOrdine == "Buy") {ImpLivBuy = false;}

if(tipoultimoOrdine == "Buy" && C1 < sogliaInf) {ImpLivBuy = true;}

if(tipoultimoOrdine == "Buy" && (sogliaSup != oldsogliasup || sogliaInf != oldsogliainf)) {tipoultimoOrdine="Flat";ImpLivBuy = true;}
}

if(!ordbuy)
{
if(tipoultimoOrdine == "Buy" && C1 < sogliaInf) {tipoultimoOrdine = "Flat";ImpLivBuy = true;}

if(tipoultimoOrdine == "Buy" && (sogliaSup != oldsogliasup || sogliaInf != oldsogliainf)) {tipoultimoOrdine = "Flat";ImpLivBuy = true;}

if(tipoultimoOrdine == "Buy" && sogliaSup == oldsogliasup && sogliaInf == oldsogliainf) {ImpLivBuy = false;}

if(tipoultimoOrdine != "Buy" && (sogliaSup != oldsogliasup || sogliaInf != oldsogliainf)) {ImpLivBuy = true;}
}
//Print("tipo Ord: ",tipoultimoOrdine," sogliasup ",sogliaSup," sogliainf ",sogliaInf," ImpLivBuy ",ImpLivBuy);


if(ordsell)
{
if(ImpLivSell && tipoultimoOrdine != "Sell"){ImpLivSell = false; tipoultimoOrdine="Sell";oldsogliasup = sogliaSup; oldsogliainf = sogliaInf;}

if(tipoultimoOrdine == "Sell" && sogliaSup == oldsogliasup && sogliaInf == oldsogliainf && ImpLivSell) {ImpLivSell = false;}

if(tipoultimoOrdine == "Sell" && C1 > sogliaSup) {tipoultimoOrdine="Flat";ImpLivSell = true;}

if(tipoultimoOrdine == "Sell" && (sogliaSup != oldsogliasup || sogliaInf != oldsogliainf)) {tipoultimoOrdine="Flat";ImpLivSell = true;}
}

if(!ordsell)
{
if(tipoultimoOrdine == "Sell" && C1 > sogliaSup) {tipoultimoOrdine = "Flat";ImpLivSell = true;}

if(tipoultimoOrdine == "Sell" && (sogliaSup != oldsogliasup || sogliaInf != oldsogliainf)) {tipoultimoOrdine = "Flat";ImpLivSell = true;}

if(tipoultimoOrdine == "Sell" && sogliaSup == oldsogliasup && sogliaInf == oldsogliainf) {ImpLivSell = false;}

if(tipoultimoOrdine != "Sell" && (sogliaSup != oldsogliasup || sogliaInf != oldsogliainf)) {ImpLivSell = true;}
}
//Print("tipo Ord: ",tipoultimoOrdine," sogliasup ",sogliaSup," sogliainf ",sogliaInf," ImpLivSell ",ImpLivSell);
}
}

//PendenzaCandele()
//------------------------------------- Ordlivsuperati() ----------------------------------------------- 
bool Ordlivsuperati(string BuySell)
{
bool a = true;
if(!ordlivellisuperati_) return a;
ulong tikbuy=TicketPrimoOrdineBuy(magic_number, Commen),tiksell=TicketPrimoOrdineSell(magic_number, Commen);
if(!tikbuy && !tiksell) return a;
static double openbuy = 0,opensell = 0;
static ulong TikBuy = 0,TikSell = 0;
double C1 = iClose(symbol_,PERIOD_CURRENT,1);

if(ordlivellisuperati_==1)
{
if(BuySell=="Buy")
{
if(tikbuy && !openbuy){opensell=0;openbuy=PositionOpenPrice(tikbuy);TikBuy=tikbuy;}
if(TikBuy!=tikbuy && PositionOpenPrice(tikbuy)<=openbuy){a=false;return a;}
}
if(BuySell=="Sell")
{
if(tiksell && !opensell){openbuy=0;opensell=PositionOpenPrice(tiksell);TikSell=tiksell;}
if(TikSell!=tiksell && PositionOpenPrice(tiksell)<=opensell){a=false;return a;}
}
}

if(ordlivellisuperati_==2)
{
static double highbuy = 0,lowsell = 0;
if(BuySell=="Buy"){
if(tikbuy && !openbuy){opensell=0;openbuy=PositionOpenPrice(tikbuy);TikBuy=tikbuy;}
if(TikBuy!=tikbuy && C1<valoreSuperiore(openbuy,HistoryDealPriceClose(TikBuy))){a=false;return a;}
}
if(BuySell=="Sell"){
if(tiksell && !opensell){openbuy=0;opensell=PositionOpenPrice(tiksell);TikSell=tiksell;}
if(TikSell!=tiksell && C1>valoreInferiore(opensell,HistoryDealPriceClose(TikSell))){a=false;return a;}
}
}
//HistoryDealPriceClose()
return a;
}
//------------------------------------- ultimopicco() ----------------------------------------------- 
double ultimopicco(string ordBuySell)
{
double a = 0;

int IndexZZZ[100];ArrayInitialize(IndexZZZ,0);
double ValZZZ[100];ArrayInitialize(ValZZZ,0);
zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,0,periodZigzag,ValZZZ,IndexZZZ);
int barra = 0;
for(int i=0;i<ArraySize(ValZZZ);i++)
{if(ordBuySell=="Buy"  && ValZZZ[i] != 0 && IndexZZZ[i] != 0 && tipopiccozigzag(ValZZZ[i],IndexZZZ[i],periodZigzag)=="Dw") {a = ValZZZ[i];barra = IndexZZZ[i];return a;}
 if(ordBuySell=="Sell" && ValZZZ[i] != 0 && IndexZZZ[i] != 0 && tipopiccozigzag(ValZZZ[i],IndexZZZ[i],periodZigzag)=="Up") {a = ValZZZ[i];barra = IndexZZZ[i];return a;}
}
return a;
}

//------------------------------------- inclinometro() ----------------------------------------------- 
bool inclinometro(double &inclinometro)
{
bool a = false;
if(inclinometro==0){a=true;return a;}
int IndexZZZ[100];ArrayInitialize(IndexZZZ,0);
double ValZZZ[100];ArrayInitialize(ValZZZ,0);
zigzagPicchi(InpDepth,InpDeviation,InpBackstep,InpCandlesCheck,0,periodZigzag,ValZZZ,IndexZZZ);

if(ValZZZ[0] > ValZZZ[1]) {inclinometro = (ValZZZ[0] - ValZZZ[1])/(IndexZZZ[1] - IndexZZZ[0])*1000;}
if(ValZZZ[0] < ValZZZ[1]) {inclinometro = (ValZZZ[1] - ValZZZ[0])/(IndexZZZ[1] - IndexZZZ[0])*1000;}

if(inclinazmin < inclinometro && ValZZZ[0]>0 && ValZZZ[1]>0) a = true;

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
double piccozigzagampio(string BuySell)
{
double a = 0;
if(BuySell=="Buy") a = valoreInferiore(piccoalto,piccobasso);
if(BuySell=="Sell") a = valoreSuperiore(piccoalto,piccobasso);
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
int calcoloStopLoss(string BuySell)
{
int a=0;
if(TypeSl_==0){a=0;return a;}
if(TypeSl_==1){a=SlPoints;return a;}
if(TypeSl_==2)
{
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
if(BuySell=="Buy") {a=(int)((C1-piccozigzagampio("Buy"))/Point());return a;}
if(BuySell=="Sell") {a=(int)((piccozigzagampio("Sell")-C1)/Point());return a;}
}
if(TypeSl_==3)
{
double C1 = iClose(symbol_,PERIOD_CURRENT,1);
if(BuySell=="Buy") {a=(int)((C1-ultimopicco(BuySell))/Point());return a;}
if(BuySell=="Sell") {a=(int)((ultimopicco(BuySell)-C1)/Point());return a;}
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
if(BreakEven==2)BePerc(BePercStart,BePercStep,magic_number,Commen);
return BreakEv;
}

//------------------------------ gestioneTrailStop()--------------------------------------------- 
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magic_number, Commen);
if(TrailingStop==2)PositionsTrailingStopInStep(TsStart,TsStep,Symbol(),magic_number,0);///PositionTrailingStopInStep
//if(TrailingStop==2){PositionTrailingStopInStep(TicketPrimoOrdineBuy(magic_number),TsStart,TsStep);PositionTrailingStopInStep(TicketPrimoOrdineSell(magic_number),TsStart,TsStep);}
if(TrailingStop==3)TrailStopCandle_();
if(TrailingStop==4)TrailStopPerc(TsPercStart,TsPercStep,magic_number,Commen);
return TS;
}

//+------------------------------------------------------------------+
//|                        closeOrdineMA()                           |
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
         ObjectSetInteger(0,Pcode+"Soglia Sup ",OBJPROP_COLOR,coloresell);
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
         ObjectSetInteger(0,Pcode+"Soglia Inf ",OBJPROP_COLOR,colorebuy);
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
         ObjectSetInteger(0,Pcode+"Max Buy ",OBJPROP_COLOR,colorebuy);
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
         ObjectSetInteger(0,Pcode+"Min Sell ",OBJPROP_COLOR,coloresell);
        } 
        
}}  
//+------------------------------------------------------------------+
//|                    drawHorizontalLine()                          |
//+------------------------------------------------------------------+
void DRawHorizontalLevel()
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
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_COLOR, coloresell);
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
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_COLOR, colorebuy);
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
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_COLOR, colorebuy);
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
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_COLOR, coloresell);
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
//if(symbol_=="XAUUSD")Print(" sogliaSup ",sogliaSup);
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
      ObjectSetInteger(0,Pcode+"Soglia Sup", OBJPROP_COLOR, coloresell);
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
      ObjectSetInteger(0,Pcode+"Soglia Inf", OBJPROP_COLOR, colorebuy);
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
      ObjectSetInteger(0,Pcode+"Max Buy", OBJPROP_COLOR, colorebuy);
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
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_COLOR, coloresell);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_STYLE, tipodilinea);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_BACK, DRawBackground);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_SELECTABLE, !DIsableSelection);
      ObjectSetInteger(0,Pcode+"Min Sell", OBJPROP_HIDDEN, true);
     }  
     
     }  


  
  
  
  
  