//+------------------------------------------------------------------+
//|                                   EA Libra GOLD MT5.mq5          |
//|                                   Corrado Bruni Copyright @2024  |
//|                                   "https://www.cbalgotrade.com"  |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property description "Libra Gold operates with multiple confirmations for opening orders. The main function is on the Square of 9 (Gann) levels. Set only the opening time of the American market!"
#property icon        "LibraGoldMT5.ico"


#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>
#include <MyInclude\PosizioniTicket.mqh>

struct sNews
  {
   datetime          dTime;
   string            time;
   string            currency;
   string            importance;
   string            news;
   string            Actual;
   string            forecast;
   string            previus;
  };


//------------ Controllo Numero Licenze e tempo Trial, Corrado ----------------------
datetime TimeLicens = D'3000.01.01 00:00:00';
long NumeroAccountOk [10];


//------------Controllo Numero Licenze e tempo Trial, Roberto-------------------------------------------------------------------
string versione = "v1.00";

string EAname0 =                       "EA Libra";
string EAname =                        EAname0+" "+versione;
string nameText =                      EAname+" ";
string nameTextCopy;

int ClientsAccountNumber[1000] =
  {
   27081543,
   8918163,
   0
  };
string ClientsAccountName[1000] =
  {
   "Corrado Bruni"
  };

string cbalgotrade_url = "http://www.cbalgotrade.com/";
string license_url = "wp-content/uploads/clientiEALibra.txt";
string version_url = "wp-content/uploads/versioneEALibra.txt";

datetime controlloAggiornamenti = 0;                           //////
datetime controlloLicenza = 0;                                 //////
int controlloLicenzaDay;                                       //////
bool commentTrialExpired = true;                               //////
bool commentLicenseExpired = true;                             //////

datetime TimeLicense = D'3000.01.01 00:00:00';                 //////
int numeroAccountLicense = 0;                                  //////
string nomeAccount = "Corrado Bruni";                          //////
int timeoutConnection = 50000;                                 //////

//bool onlyAccountMax =                  false;
bool ultraLock =                       true;                 //////
bool copyRight =                       false;                 //////
bool onlyBacktest =                    false;                 //////
datetime dateOnlyBacktest =            D'2024.05.30 00:00:00';///////

bool License =                         false;                  //////
datetime dateLicense =                 D'2224.05.30 00:00:00';//////
bool Trial =                           false;                ///////
datetime dateTrial =                   D'2224.05.30 00:00:00';/////
//------------------------------------------------------------------------------
//--- input parameters

enum input_ruota_
  {
   Ventiquattro      = 0,        //Advanced Formula Levels by Pivot Set
   Da_Square_of_NIne = 1,        //Levels Square of 9 by Pivot Set

  };

enum gradi_ciclo
  {
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
   SixMounthly       = 3,            //6 Mounths After
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
   PivotHL_2        = 4,        //Pivot Daily
   PivotHLC_3       = 5,        //Pivot Weekly
   Custom           = 6,        //Custom
   HiLoZigZag       = 7,        //Last High/Low Shadow of Zig Zag indicator
   HigLowZigZag     = 8,        //Last High/Low Body of Zig Zag indicator
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
enum Fuso_
  {
   GMT              = 0,
   Local            = 1,
   Server           = 2
  };
enum Type_Orders
  {
   Buy_Sell    = 0,                       //Orders Buy e Sell
   Buy         = 1,                       //Only Buy Orders
   Sell        = 2,                       //Only Sell Orders
   NoBuyNoSell = 3,                       //No Buy No Sell: Stop News Orders
  };

enum N_CandleConsecutive_
  {
   Una        = 1,                 //1 candle
   Due        = 2,                 //Two consecutive candles
   Tre        = 3,                 //Three consecutive candles
   Quattro    = 4                  //Four consecutive candles
  };

enum Ap_Ord_Dal_Liv_Buy
  {
   Compra_Vendi_                     = 2,         //Buy Above / Sell Below
   Primo_Livello_                    = 3,         //R1/S1
   Secondo_Livello_                  = 4,         //R2/S2
   Terzo_Livello_                    = 5,         //R3/S3
   Quarto_Livello_                   = 6,         //R4/S4
   Quinto_Livello_                   = 7          //R5/S5
  };

enum Non_Ap_Ord_Dal_Liv_Buy
  {
   Compra_Vendi                     = 2,         //Buy Above / Sell Below
   Primo_Livello                    = 3,         //R1/S1
   Secondo_Livello                  = 4,         //R2/S2
   Terzo_Livello                    = 5,         //R3/S3
   Quarto_Livello                   = 6,         //R4/S4
   Quinto_Livello                   = 7,         //Without limits
  };


enum N_max_orders_                      //Max Num Orders on same day
  {
   Uno_                   = 1,          //Max One Orders day
   Due_                   = 2,          //Max Two Positions day
   Tre_                   = 3,          //Max Three Orders day
   Quattro_               = 4,          //Max Four Orders day
   Cinque_                = 5,          //Max Five Orders day
   Sei_                   = 6,          //Max Six Orders day
   Sette_                 = 7,          //Max Seven Orders day
   Otto_                  = 8,          //Max Eight Orders day
   Nove_                  = 9,          //Max Nine Orders day
   Dieci_                 = 10,          //Max Ten Orders day
   Venti_                 = 20,         //Max 20 Orders day
   Cinquanta_             = 50,         //Max 50 Orders day
   Cento_                 =100,         //Max 100 Orders day
  };

enum nMaxPos                                    //Max orders open on the market
  {
   Una_posizione                   = 1,         //Max One position open on the market
   Due_posizioni                   = 2,         //Max Two Positions open at the same time
//Tre_posizioni                   = 3,         //Max Three Positions open at the same time
//Quattro_posizioni               = 4,         //Max Four Positions open at the same time
  };

enum capitBasePerCompoundingg
  {
   Equity                           = 0,
   Margine_libero                   = 1,//Free margin
   Balance                          = 2,
  };
enum SL
  {
   SL_Point                         = 0,         //Stop loss Points
   SL_N_Livelli_Prima               = 1,         //Stop loss previous level setting

  };

enum SlLivPrec
  {
   stesso      = 0,                 //Stop Loss at the same order level
   una_        = 1,                 //Stop Loss at previous level
   due_        = 2,                 //Stop Loss at the second previous level
   tre_        = 3,                 //Stop Loss at the third previous level
   quattro_    = 4                  //Stop Loss at previous quarter level
  };

enum TStop
  {
   No_TS                          = 0,  //No Trailing Stop
   PipsTStop                      = 1,  //Trailing Stop in Points
   PercLevelbylevelTStop          = 2,  //Trailing Stop Level by Level
   TSPointTradiz                  = 3,  //Trailing Stop in Points Traditional
   TsTopBotCandle                 = 4,  //Trailing Stop Previous Candle
  };

enum TypeCandle
  {
   stessa     = 0,                 //Trailing Stop sul min/max della candela "index"
   una        = 1,                 //Trailing Stop sul min/max del corpo della candela "index"
   due        = 2,                 //Trailing Stop sul max/min del corpo della candela "index"
   tre        = 3,                 //Trailing Stop sul max/min della candela "index"
  };

enum TsStepLevRag
  {
   primoLivRaggiunto              = 1,
   secondoLivRaggiunto            = 2,
   terzoLivRaggiunto              = 3,
   quartoLivRaggiunto             = 4,
   quintoLivRaggiunto             = 5
  };

enum SpecialTs
  {
   No_SpecialTs                   = 0,
   SpecialT_1                     = 1,
   SpecialT_2                     = 2
  };

enum TsLevPrec
  {
   stessoLiv                      = 0,         //Same level
   primoLivPrec                   = 1,         //First Level Previous
   secondoLivPrec                 = 2,         //Second Previous Level
   terzoLivPrec                   = 3          //Third Level Previous
  };

enum Tp
  {
   No_Tp                          = 0,    //No Tp
   TpPips                         = 1,    //Tp in Points
   Livello_Tp_successivo_order    = 2     //Tp to a next level
  };

enum Tp_Livello_Successivo
  {
   primoLev                      = 1,     //Next First Level
   secondoLev                    = 2,     //Second Next Level
   terzoLev                      = 3,     //Third Level Next
   quartoLev                     = 4,     //Fourth Next Level
   quintoLev                     = 5,     //Fifth Next Level
   sestoLev                      = 6,     //Next Level Six
   settimoLev                    = 7,     //Next Level Seven
   ottavoLev                     = 8,     //Eighth Next Level
   nonoLev                       = 9      //Next Level Ninth
  };

enum TpSoglia                        //"Choose next TP level" option. When the position would be opened plus a % to the next level...
  {
   NoSoglia                       = 0, //Tp Threshold % disabled
   SogliaPercLivello              = 1  //Tp Threshold % enabled
  };

enum TpAzioneSoglia                    //With Tp Threshold enabled, choose the action. Priority on "Take Profit to the Next Level".
  {
   NoTp                           = 0, //Does not enter the Take Profit
   TpDueLivSopra                  = 1, //Take Profit to the Next Level
   TpTreLivSopra                  = 2, //Take Profit to the next second level
   TpQuattroLivSopra              = 3, //Take Profit to the next third level
  };

enum BE
  {
   No_BE                          = 0, //No Breakeven
   BEPips                         = 1, //Breakeven Points
   BE_PercLevelbylevel            = 2  //Breakeven Level
  };
//-------- RSI ------------------
enum belowLevel1
  {
   noFilter                        = 0, //Buy and Sell
   OnlyBuy                         = 1, //Only Buy
   OnlySell                        = 2, //Only Sell
   DisableOrders                   = 3, //No Buy / No Sell
  };
enum DaLev1Alev2
  {
   noFilter_                        = 0, //Buy and Sell
   OnlyBuy_                         = 1, //Only Buy
   OnlySell_                        = 2, //Only Sell
   DisableOrders_                   = 3, //No Buy / No Sell
  };
enum aboveLevel2
  {
   noFilter__                        = 0, //Buy and Sell
   onlyBuy_                         = 1, //Only Buy
   onlySell_                        = 2, //Only Sell
   disableOrders_                   = 3, //No Buy / No Sell
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
enum Grid_Hedge
  {
   NoGrid_NoHedge        = 0, //No Hedging, No Grid
   Grid_                 = 1, //Grid
   Hedge                 = 2, //Hedging
  };
enum TipoMultipliGriglia
  {
   Fix                  = 0,
   Progressive          = 1,
  };
enum StopBefore_
  {
   cinqueMin            =  5, //5 Min
   dieciMin             = 10, //10 min
   quindMin             = 15, //15 min
   trentaMin            = 30, //30 min
   quarantacinMin       = 45, //45 min
   unOra                = 60, //1 Hour
   unOraeMezza          = 90, //1:30 Hour
   dueOre               =120, //2 Hours
   dueOreeMezza         =150, //2:30 Hours
   treOre               =180, //3 Hours
   quattroOre           =240, //4 Hours
  };
enum StopAfter_
  {
   cinqueMin_            =  5, //5 Min
   dieciMin_             = 10, //10 min
   quindMin_             = 15, //15 min
   trentaMin_            = 30, //30 min
   quarantacinMin_       = 45, //45 min
   unOra_                = 60, //1 Hour
   unOraeMezza_          = 90, //1:30 Hour
   dueOre_               =120, //2 Hours
   dueOreeMezza_         =150, //2:30 Hours
   treOre_               =180, //3 Hours
   quattroOre_           =240, //4 Hours
  };

//input ENUM_ORDER_PROPERTY_STRING Parametro;

input string   comment_IS =            "--- SQUARE of 9 LEVELS SETTINGS ---";   // --- SQUARE of 9 LEVELS SETTINGS ---

input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput              GannInputDigit_                 = 4;              //Number of price digits used: Calibration
input Divisione              Divis_                          = 0;              //Multiplication / Division of digits: Calibration

input PriceType              GannInputType_                  = 4;              //Type of Input in Calculation
input string                 GannCustomPrice_                = "1.00000";
//input PivD_SR_Sqnine  PivotDaily                           = 0;              //On the chart: Pivot Daily or Resistances/Supports Sq 9
int  PivotDaily                                              = 0;              //On the chart: Pivot Daily or Resistances/Supports Sq 9
input PriceTypeW             TypePivW                        = 2;              //Pivot Weekly type (for Filter)
input PriceTypeD             TypePivD                        = 3;              //Pivot Daily Type (for Filter)
input input_ruota_           input_ruota                     = 1;              //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_               = 1;              //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;              //Advanced Formula Angles: 360°/270°/180°/90°

input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input bool                   StopNewsOrders                  = false;     //Auto Stop News Orders When All Orders Closed
input Type_Orders            Type_Orders_                    =   0;       //Type of order opening
input int                    maxDDPerc                       =   0;       //Max DD% (0 Disable)
input int                    MaxSpread                       =   0;       //Max Spread (0 = Disable)
input bool                   Filtro_Pivot_Weekly             = false;     //Filter Pivot Weekly (Above: Buy only. Below: Sell only)
input bool                   FiltroPivotDaily                = false;     //Filter Pivot Daily  (Above: Buy only. Below: Sell only)

input bool                   OrdiniSuStessaCandela           = false;     //Enable Orders in same Candle

input bool                   RipetiLivelliPresentiOra        = true;      //Repeat orders on the same LEVEL the orders present now
input bool                   RipetiLivelliDelGiorno          = true;      //Repeat orders on the same level, on the same day
input bool                   versoCandelaPro                 = false;     //Opens Buy Order only if the candle is Long, Sell if it is Short

input N_CandleConsecutive_   N_CandleConsecutive             = 3;         //Number of consecutive candles to activate the orders
input int                    candeleSuccess                  = 0;         //Additional candles for Order activation

input Ap_Ord_Dal_Liv_Buy     ApriOrdineDalLiv                = 2;         //Open Orders from Level:
input Non_Ap_Ord_Dal_Liv_Buy ApreNuoviOrdiniFinoAlLivello    = 5;         //Open Orders up to Level:

input int                    PercLivPerOpenPos               = 0;         //Above this percentage level opens order
input int                    AbovePercNoOrder                = 0;         //Above this percetage dont open order (0=disable)

input int                    numCandLevSuccRaggiunto         = 0;         //N° of candles before "Tp %" reached: NO Open Order
input int                    percLevTpRaggiunto              = 100;       //The Tp %

input N_max_orders_          N_max_orders                    = 50;        //Maximum number of opening new orders in the day
input nMaxPos                N_Max_pos                       =  2;        //Maximum number of orders together
input int CloseOrdDopoNumCandDalPrimoOrdine_                 = 18;        //Close Single Order after n° candles lateral (0 = Disable)

input int                    magic_number                    = 7777;      //Magic Number
input string                 Commen                          = "LIBRA GOLD";//Comment
input int                    Deviazione                      = 3;         //Slippage
// NEWS
input string   comment_NEW  =          "--- FILTER NEWS ---";             // --- FILTER NEWS ---
input bool               NEWS_FILTER               =true;
input bool               NEWS_IMPORTANCE_LOW       =false;
input bool               NEWS_IMPORTANCE_MEDIUM    =false;
input bool               NEWS_IMPORTANCE_HIGH      =true;
input int                STOP_BEFORE_NEWS          =30;
input int                START_AFTER_NEWS          =30;
//input string             Currencies_Check          ="USD,GBP,EUR,CAD,AUD,NZD,GBP";
input string             Currencies_Check          ="USD";
//input bool               Check_Specific_News       =false;
bool                     Check_Specific_News       =false;
//input string             Specific_News_Text        ="employment";
string                   Specific_News_Text        ="employment";
input bool               DRAW_NEWS_CHART           = true;
input int                X                         = 100;//Chart X-Axis Position
input int                Y                         = 380;//Chart Y-Axis Position
input string             News_Font                 ="Arial";
input color              Font_Color                =clrRed;
input bool               DRAW_NEWS_LINES           =true;
input color              Line_Color                =clrRed;
input ENUM_LINE_STYLE    Line_Style                =STYLE_DOT;
input int                Line_Width                =1;

int Font_Size=8;
input string LANG="ita";
sNews NEWS_TABLE[],HEADS;
datetime date_;
int TIME_CORRECTION,NEWS_ON=0;
// NEWS

input string   comment_MM   =           "--- MONEY MANAGEMENT ---";       // --- MONEY MANAGEMENT ---
input bool     compounding  =           true;                             //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA       =            0.1;                             //Lots
input double   riskEA       =              0;                             //Risk in % [0-100]
input double   riskDenaroEA =              0;                             //Risk in money
input double   commissioni  =              4;                             //Commissions per lot
input bool     lotOrderInversoGrid =   false;                             //Lot Order Grid active == Lot Last Order inverse

input string   comment_ZZ =            "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  =200;     // ZigZag: how many candles to check back
input int     disMinCandZZ    =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag      =PERIOD_CURRENT;      //Timeframe


input string   comment_GRHE =           "--- GRID/HEDGING ---"; // --- GRID/HEDGING ---

input Grid_Hedge GridHedge    =    1;        //Enable Grid/Hedging
input bool     HedgPend       = true;        //Hedging Orders Pendulum
input int      StartGrid      = 3000;        //Start Grid/Hedging (Points)
input int      StepGrid       = 2000;        //Step Grid/Hedging (Points)
input char     NumMaxGrid     =   30;        //Numaro max di Grid/Hedging
input double   profitGrid      =   5;        //Profit in Grid/Hedging
//input int      ProfGridPoints  = 100;        //Profit Grid/Hedging Points
input char     MoltipliNumGrid =   1;        //After n° Grid/Hedging
input TipoMultipliGriglia TypeGrid = 1;      //Type Multipl Grid/Hedging: Fix/Progressive
input double   MoltiplLotStep  = 1.3;        //Multipl Lots Fix/Progressive
//input int CloseOrdDopoNumCandDalPrimoOrdine = 18;    //Close Single Order after n° candles lateral (0 = Disable)
int CloseOrdDopoNumCandDalPrimoOrdine =  0;    //Close Single Order after n° candles lateral (0 = Disable)
input bool     TpSeDueOrdini                = true; //With 2 orders on Grid: Disable TP

input string   comment_SL =            "--- STOP LOSS ---"; // --- STOP LOSS ---
input SL       Stop_Loss                =   1;              //Stop loss Points / Previous Levels
input int      SlNumPoint               = 1000;             //Stop loss Points
input SlLivPrec     Sl_n_livelli_prima  =   1;              //Stop loss: previous level setting
input int      Sl_Perc_Al_Livello_Prima = 110;              //Stop loss, at what % of the previous level

input string   comment_BE =            "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_points          = 2500;              //Be Start in Points
input int      Be_Step_points           =  200;              //Be Step in Points
input bool     BEGridActive = false;            //Be Points enable with Orders Grid/Hedge opposite activated
input int      BE_PercLevelbylevel      =   85;              //Be LevelByLevel. If the order open beyond this %: BE Points set

input string   comment_TS =            "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points da Profit/Level/Points Traditional/Candle
input int      TS_pips                  = 3000;              //Ts Start in Points
input int      Ts_Step_pips             =  700;              //Ts Step in Points
input TsLevPrec TsLevPrec_              =    1;              //TS Level By Level Number of Previous Levels

input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =            "--- TAKE PROFIT ---";   // --- TAKE PROFIT ---
input Tp       TakeProfit               =    2;              //Take Profit Type
input int      TpPips                   = 1000;              //Take Profit Points
input Tp_Livello_Successivo Tp_Next     =    1;              //Take Profit: N° Next Level
input char TpPercAlLivello              =  100;              //Take Profit: % to the next level
input bool     TpSlInProfit             = false;             //Take Profit: cancel if Ts/Be in profit
input TpSoglia TpSoglia_                =    0;              //Take Profit Threshold
input char SogliaPercLivello            =   80;              //Take Profit % Threshold: Above this % (level by level) of price order, active "TP Action"
input TpAzioneSoglia TPAzioneSoglia     =    1;              //TP Action (Priority on "Take Profit: N° Next Level")

input string   comment_TT =            "--- TRADING TIME SETTINGS ---";   // --- TRADING TIME SETTINGS ---
input string   comment_TT1 =            "--- TIME SETTINGS 1 ---";   // --- TRADING TIME SETTINGS 1 ---
input bool     FusoEnable = true;                       //Trading Time
input Fuso_    Fuso = 2;                                //Time Zone Settings
input int      InpStartHour   =  2;                     //Session1 Start Time
input int      InpStartMinute =  0;                     //Session1 Start Minute
input int      InpEndHour     = 15;                     //Hours1 End of Session
input int      InpEndMinute   = 15;                     //Minute1 End of Session
input string   comment_TT2 =            "--- TIME SETTINGS 2 ---";   // --- TRADING TIME SETTINGS 2 ---
input int      InpStartHour1   = 16;                     //Session2 Start Time
input int      InpStartMinute1 = 15;                     //Session2 Start Minute
input int      InpEndHour1     = 23;                     //Hours2 End of Session
input int      InpEndMinute1   = 00;                     //Minute2 End of Session

input string   comment_RSI =            "------- RSI SETTING -------";  // ------- RSI SETTING -------
input bool Filter_RSI                   = false;                //Filter RSI Enable
input bool                 OnChart_RSI  = false;                //On chart
input int                  RSI_period   =14;                    //Period RSI
input ENUM_APPLIED_PRICE   RSI_applied_price=PRICE_CLOSE;       //Type of price
input ENUM_TIMEFRAMES      periodRSI=PERIOD_CURRENT;            //Timeframe
input char livello2                     = 70;                   //RSI Level 2
input char livello1                     = 30;                   //RSI Level 1
input aboveLevel2 aboveLevel2_          = 0;                    //Above at Level 2: Type of filter allowed
input DaLev1Alev2 DaLev1Alev2_          = 0;                    //Between Level 1 and Level 2: Type of filter allowed
input belowLevel1 belowLevel1_          = 0;                    //Below Level 1: Type of filter allowed

input string   comment_MO =            "--- Moving Average SETTING ---";   // --- MOVING AVERAGE SETTING ---
input bool                 Filter_Moving_Average   = false;  //Filter Moving Average Enable
input bool                 OnChart_Moving_Average  = false;  //On chart
input int                  Moving_period=200;                //Period of MA
input int                  Moving_shift=0;                   //Shift
input ENUM_MA_METHOD       Moving_method=MODE_EMA;           //Type di smussamento
input ENUM_APPLIED_PRICE   Moving_applied_price=PRICE_CLOSE; //Type of price
input ENUM_TIMEFRAMES      periodMoving=PERIOD_CURRENT;      //Timeframe
input int DistanceMA                   = 100;                //Distance Points for enable trading (0: Disable)
input bool AboveBeloweMA               = false;              //MA Above Price: Only orders Buy, Belowe: Only Orders Sell

input string   comment_TEMA  =           "--- Triple Exponential Moving Average SETTING ---";   // --- Triple Exponential Moving Average SETTING ---
input bool Filter_TEMA                   = false;              //Filter Triple Exponential Moving Average Enable
input bool                 OnChart_TEMA  = false;              //On chart
input int                  TEMA_period   = 14;                 //MA Period
input int                  TEMAShift     = 0;                  //MA Shift
input ENUM_APPLIED_PRICE   TEMA_method=PRICE_CLOSE;            //TEMA_method
input ENUM_TIMEFRAMES      periodTEMA =PERIOD_CURRENT;         //Timeframe
input int DistanceTEMA                   = 100;                //Distance Points for enable trading
input bool AboveBeloweTEMA               = false;              //Price above TEMA: only Orders Buy. Price belowe TEMA: only Orders Sell.

input string   comment_RSIstok  =            "--- RSI Stochastik SETTING ---";   // --- RSI Stochastik SETTING ---
input bool                 Filter_RSIstok   = false;           //Filter RSI Stochastik Enable
input bool                 OnChart_RSIstok  = false;           //On chart
input int                  K_period = 5;                       //K Period
input int                  D_period = 3;                       //D Period
input int                  SlowDown = 3;                       //Slowing
input ENUM_MA_METHOD       RSIstok_method=MODE_SMA;            //RSIstok_method
input ENUM_TIMEFRAMES      periodRSIstok =PERIOD_CURRENT;      //Timeframe
input ENUM_STO_PRICE       Stochastic_calculation_method=STO_LOWHIGH;  //Stochastic_calculation_method

input string   comment_MACD  =           "--- MACD SETTING ---";// --- MACD SETTING ---
input bool                 FilterMACD    = false;               //Filter RSI Stochastik Enable
input bool                 OnChart_MACD  = false;               //On chart
input int                  EMA_Fast = 12;                       //EMA Fast
input int                  EMA_Slow = 26;                       //EMA Slow
input int                  MACD_SMA =  3;                       //MACD SMA
input ENUM_APPLIED_PRICE   MACD_method=PRICE_CLOSE;             //MACD_method
input ENUM_TIMEFRAMES      periodMACD =PERIOD_CURRENT;          //Timeframe

input string   comment_ATR =            "--- ATR SETTING ---";  // --- ATR SETTING ---
input bool                 Filter_ATR   = false;                //Filter ATR Enable
input bool                 OnChart_ATR  = false;                //On chart
input int                  ATR_period=14;                       //Period ATR
input ENUM_TIMEFRAMES      periodATR=PERIOD_CURRENT;            //Timeframe
input double               thesholdATR  = 1.755;                //Theshold ATR: ATR above the threshold enables trading

input string       comment_IC =        "--- SETTINGS CHART ---";   // --- SETTINGS CHART ---
input bool         VisibiliInChart_    = true;

int   handle_iCustom;                  // variable for storing the handle of the iCustom indicator Zig Zag
input bool         ShortLines_         = true;
input bool         ShowLineName_       = true;
input AlertType    Alert1_             = 0;
input AlertType    Alert2_             = 0;

input int          PipDeviation_       = 0;                        //Sensibility for alert
input string       CommentStyle_       = "--- Style Settings ---";
input bool         DrawBackground_     = true;
input bool         DisableSelection_   = true;
input color        ResistanceColor_    = clrRed;
input color        BuyAbove_Color_     = clrGold;
input LineType     ResistanceType_     = 2;
input LineWidth    ResistanceWidth_    = 1;
input color        SupportColor_       = clrLime;
input color        SellBelow_Color_    = clrGreenYellow;
input color        ThresholdColor_     = clrLightGray;
input LineType     SupportType_        = 2;
input LineWidth    SupportWidth_       = 1;
input string       ButtonStyle_        = "--- Toggle Style Settings ---";
input bool         ButtonEnable_       = false;

input int          XDistance_          = 250;
input int          YDistance_          = 5;
input int          Width_              = 100;
input int          Hight_              = 30;
input string       Label_              = " ";

string MarketOpCl="";

double priceDay=0.0;
double priceWeek=0.0;
//int    lastBar=0;
//double lastAlarmPrice=0;
//bool   timeToCalc=false;
double R1Price_,R2Price_,R3Price_,R4Price_,R5Price_,BuyAbove_,PivotDay_,priceW,priceIn_;
double S1Price_,S2Price_,S3Price_,S4Price_,S5Price_,SellBelow_;
input string pcode_="GannPivots_";

string buttonID_="ButtonGann";
double showGann_;
double arrPric [50];
string arrStrin[4];
int    arrIn   [100];
bool   arrBoo  [30];
color  arrCol  [10];
double arrParamInd [50];
int    arrInput [50];

double price_ = 0;
double low[1];
double high[1];
double close[1];
double open[1];

int LivelliPrimiOrdiniDay[100];

string typeOrders = "";

bool   visualThres_Up = true;
bool   visualThres_Dw = true;
double ThresholdUp_ = 0.0;
double ThresholdDw_ = 0.0;

bool   enablePrimoLiv = true;
bool GridBuyActive=false;//true quando la grid Buy o la grid Buy Hedge sono attive *Esclusi i primi ordini*
bool GridSellActive=false;//true quando la grid Sell o la grid Sell Hedge sono attive *Esclusi i primi ordini*

int TicketHedgeBuy [100];
int TicketHedgeSell[100];

string segnoOrdine;

char conta = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   TrialLicence(TimeLicens);
   NumeroAccountOk [0] = 31029077;
   NumeroAccountOk [1] = 61276136;
   NumeroAccountOk [2] = 67107668;
   NumeroAccountOk [3] = 27081543;
   NumeroAccountOk [4] = 7015565;
   NumeroAccountOk [5] = 7008209;
   NumeroAccountOk [6] = 8918163;
   NumeroAccountOk [7] = 68152694;

   if(controlAccounts(NumeroAccountOk, TimeLicens))
      Print("Account OK!");

   if(!MQLInfoInteger(MQL_TESTER) || !MQLInfoInteger(MQL_OPTIMIZATION))
     {
      if(NEWS_FILTER==true && READ_NEWS(NEWS_TABLE) && ArraySize(NEWS_TABLE)>0)
         DRAW_NEWS(NEWS_TABLE);
      //TIME_CORRECTION=((int(TimeCurrent() - TimeGMT()) + 1800) / 3600);
      TIME_CORRECTION=(-TimeGMTOffset());
     }
   EventSetTimer(1);


   low[0]   = iLow(Symbol(),PERIOD_D1,1);
   high[0]  = iHigh(Symbol(),PERIOD_D1,1);
   close[0] = iClose(Symbol(),PERIOD_D1,1);
   open[0]  = iOpen(Symbol(),PERIOD_D1,1);

   priceDay=pricePivotD(TypePivD);
   priceWeek=pricePivotW(TypePivW);




   if(GannInputType_==0)
      price_ = open[0];
   if(GannInputType_==1)
      price_ = low[0];
   if(GannInputType_==2)
      price_ = high[0];
   if(GannInputType_==3)
      price_ = close[0];
   if(GannInputType_== 4)
      price_ = priceDay;
   if(GannInputType_==5)
      price_ = priceWeek;
   if(GannInputType_==6)
      price_ = StringToDouble(GannCustomPrice_);

   arrParamInd[0]=OnChart_Moving_Average;
   arrParamInd[1]=Moving_period;
   arrParamInd[2]=Moving_shift;
   arrParamInd[3]=Moving_method;
   arrParamInd[4]=Moving_applied_price;
   arrParamInd[5]=periodMoving;
   arrParamInd[6]=OnChart_TEMA;
   arrParamInd[7]=TEMA_period;
   arrParamInd[8]=TEMAShift;
   arrParamInd[9]=periodTEMA;
   arrParamInd[10]=TEMA_method;
   arrParamInd[11]=OnChart_RSI;
   arrParamInd[12]=RSI_period;
   arrParamInd[13]=periodRSI;
   arrParamInd[14]=RSI_applied_price;
   arrParamInd[15]=0;
   arrParamInd[16]=OnChart_RSIstok;
   arrParamInd[17]=K_period;
   arrParamInd[18]=D_period;
   arrParamInd[19]=SlowDown;
   arrParamInd[20]=RSIstok_method;
   arrParamInd[21]=periodRSIstok;
   arrParamInd[22]=Stochastic_calculation_method;
   arrParamInd[23]=0;
   arrParamInd[24]=OnChart_MACD;
   arrParamInd[25]=EMA_Fast;
   arrParamInd[26]=EMA_Slow;
   arrParamInd[27]=MACD_SMA;
   arrParamInd[28]=MACD_method;
   arrParamInd[29]=periodMACD;
   arrParamInd[30]=0;
   arrParamInd[31]=OnChart_ATR;
   arrParamInd[32]=ATR_period;
   arrParamInd[33]=periodATR;

   arrParamInd[34]= 1;// Semaforo onInit
   arrParamInd[37]= Filter_RSI;
   arrParamInd[38]= livello1;       //Basso
   arrParamInd[39]= livello2;       //Alto
   arrParamInd[40]= belowLevel1_;   //No Filter/Only Buy/Only Sell/Disable Orders
   arrParamInd[41]= DaLev1Alev2_;   //No Filter/Only Buy/Only Sell/Disable Orders
   arrParamInd[42]= aboveLevel2_;   //No Filter/Only Buy/Only Sell/Disable Orders
   arrParamInd[43]= 0;
   arrParamInd[44]= 0;
   arrParamInd[45]= Filter_RSIstok;
   arrParamInd[46]= FilterMACD;
   arrParamInd[47]= 0;
   arrParamInd[48]= Filter_ATR;

   arrInput [0] = TS_pips;
   arrInput [1] = Ts_Step_pips;
   arrInput [2] = 0;
   arrInput [3] = 0;
   arrInput [4] = TsLevPrec_;
   arrInput [5] = Type_Orders_;
   arrInput [6] = BreakEven;                             //Modalità Be: No/Pips/Livello successivo
   arrInput [7] = Be_Start_points;                         //Be in pips
   arrInput [8] = Be_Step_points;                          //Be step in pips
   arrInput [9] = BE_PercLevelbylevel;                   //Se l'ordine apre sopra questa % al livello successivo...
//  arrInput [10]= Be_start_lev;                      //A questa % LelByLev interviene il Be
//   arrInput [11]= PosizAperLiv;                          //Consente l'apertura di altre posizioni sullo stesso livello
   arrInput [12]= PercLivPerOpenPos;
   arrInput [13]= Filter_Moving_Average;                 //Abilita/Disabilita Moving Average
   arrInput [14]= Filter_ATR;
   arrInput [15]= Filter_RSI;
   arrInput [16]= Filter_RSIstok;
   arrInput [17]= FilterMACD;
   arrInput [18]= Filter_TEMA;
   arrInput [19]= TpSlInProfit;

   arrInput [22]= OrdiniSuStessaCandela;
   arrInput [26]= indexCandle_;              //Index Candle Previous
   arrInput [27]= TFCandle;
   arrInput [30]= 0;
   arrInput [31]= TypeCandle_;

   arrIn[0]      = GannInputDigit_;
   arrIn[1]      = Divis_;
   arrIn[2]      = PipDeviation_;
   arrIn[3]      = ResistanceType_;
   arrIn[4]      = ResistanceWidth_;
   arrIn[5]      = SupportType_;
   arrIn[6]      = SupportWidth_;
   arrIn[7]      = Alert1_;
   arrIn[8]      = Alert2_;
   arrIn[9]      = XDistance_;
   arrIn[10]     = YDistance_;
   arrIn[11]     = Width_;
   arrIn[12]     = Hight_;
   arrIn[13]     = N_max_orders;             //Maximum number of orders together
   arrIn[14]     = magic_number;
   arrIn[15]     = 0;                        //Vuoto disponibile
   arrIn[16]     = N_Max_pos;                //Maximum number of orders together
   arrIn[17]     = Type_Orders_;             //BUY e Sell/Only Buy/Only Sell/No Buy No Sell
   arrIn[18]     = maxDDPerc;
   arrIn[19]     = MaxSpread;
   arrIn[20]     = ApriOrdineDalLiv;
   arrIn[21]     = ApreNuoviOrdiniFinoAlLivello;
   arrIn[22]     = PercLivPerOpenPos;
   arrIn[23]     = AbovePercNoOrder;
   arrIn[24]     = N_CandleConsecutive;
   arrIn[25]     = TypePivW;
   arrIn[26]     = TypePivD;
   arrIn[27]     = SlNumPoint;
   arrIn[28]     = Stop_Loss;
   arrIn[29]     = Sl_n_livelli_prima;
   arrIn[30]     = Sl_Perc_Al_Livello_Prima;
   arrIn[31]     = 0; // Libero
   arrIn[32]     = CloseOrdDopoNumCandDalPrimoOrdine_; 
   arrIn[33]     = BreakEven;
   arrIn[34]     = 0;// pronto per segnoOrdine eventualmente
//   arrIn[35]     = GridBuyActive;
//   arrIn[36]     = GridSellActive;
//   arrIn[37]     = PercLivNoOpenPos;
//   arrIn[38]     = NumOrdHedgeBuy(TicketHedgeBuy);
//   arrIn[39]     = NumOrdHedgeSell(TicketHedgeSell);
   arrIn[40]     = BEGridActive; 
   arrIn[41]     = TypeCandle_;
   arrIn[42]     = Be_Start_points;
   arrIn[43]     = Be_Step_points;
   arrIn[44]     = BE_PercLevelbylevel;
//   arrIn[45]     = Be_start_lev;     
   
   
/*
                              arrInput [7] = Be_Start_pips;                         //Be in pips
                              arrInput [8] = Be_Step_pips;                          //Be step in pips
                              arrInput [9] = BE_PercLevelbylevel;                   //Se l'ordine apre sopra questa % al livello successivo...
                              //  arrInput [10]= Be_start_lev;                      //A questa % LelByLev interviene il Be*/

/*
               arrInput [3] = (int) segno_ordine;
               arrInput [20]= GridBuyActive;
               arrInput [21]= GridSellActive;
               //arrInput [23]= PercLivNoOpenPos;
               arrInput [24]= NumOrdHedgeBuy(TicketHedgeBuy);
               arrInput [25]= NumOrdHedgeSell(TicketHedgeSell);
               //arrInput [30]= BEGridActive;
               //arrInput [31]= TypeCandle_; */  

   arrBoo[0]     = VisibiliInChart_;
   arrBoo[1]     = ShortLines_;
   arrBoo[2]     = ShowLineName_;
   arrBoo[3]     = DrawBackground_;
   arrBoo[4]     = DisableSelection_;
   arrBoo[5]     = ButtonEnable_;
   arrBoo[6]     = GannInputType_;
   arrBoo[7]     = Filtro_Pivot_Weekly;
   arrBoo[8]     = FiltroPivotDaily;
   arrBoo[9]     = OrdiniSuStessaCandela;
//arrBoo[10]    =  Usato per visualThres_Up in una funzione
//arrBoo[11]    =  Usato per visualThres_Dw in una funzione
   arrBoo[10]    = RipetiLivelliPresentiOra;                               //Repeat orders on the same LEVEL the orders present now
   arrBoo[11]    = RipetiLivelliDelGiorno;                                 //Repeat orders on the same level, on the same day
   arrBoo[12]    = false;                                                  //Vuoto disponibile
   arrBoo[13]    = false;                                                  //Vuoto disponibile
//arrBoo[14]    = Usato per enablePrimoLiv;
//arrBoo[15]    = Usato per enableSecLiv;
//arrBoo[16]    = Usato per enableBuy;
//arrBoo[17]    = Vuoto disponibile
//arrBoo[18]    = Usato per enableSell;
   arrBoo[19]    = BEGridActive;


   arrStrin[0]   = GannCustomPrice_;
   arrStrin[1]   = Label_;
   arrStrin[2]   = pcode_;
   arrStrin[3]   = buttonID_;

   arrCol[0]     = ResistanceColor_;
   arrCol[1]     = SupportColor_;
   arrCol[2]     = BuyAbove_Color_;
   arrCol[3]     = SellBelow_Color_;
   arrCol[4]     = ThresholdColor_;

   conta = 0;

   clearObj();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   DEINIT_PANEL();
   EventKillTimer();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//--------------------- enable Primo Livello ------------------------+

   if(controlAccounts(NumeroAccountOk,TimeLicens) && TrialLicence(TimeLicens) 
   && MarketIsOpen()
   )
     {arrBoo[14]=enablePrimoLiv = true;}
   else
     {arrBoo[14]=enablePrimoLiv = false;}

//+------------------------------------------------------------------+
//clearObj();
/*
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  =200;     // ZigZag: how many candles to check back
input int      disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag      =PERIOD_CURRENT;      //Timeframe*/
   if(GannInputType_==7)price_ = ZIGZAG();ZigZag(InpCandlesCheck,periodZigzag,PERIOD_CURRENT,InpDepth,InpDeviation,InptBackstep);
   if(GannInputType_==8)price_ = ZIGZAGHiLo();ZIGZAGHiLo_(InpCandlesCheck,periodZigzag,PERIOD_CURRENT,InpDepth,InpDeviation,InptBackstep);

   arrPric[0] = price_;
   R1Price_   = arrPric[1];
   R2Price_   = arrPric[2];
   R3Price_   = arrPric[3];
   R4Price_   = arrPric[4];
   R5Price_   = arrPric[5];

   S1Price_   = arrPric[6];
   S2Price_   = arrPric[7];
   S3Price_   = arrPric[8];
   S4Price_   = arrPric[9];
   S5Price_   = arrPric[10];
   BuyAbove_  = arrPric[11];
   SellBelow_ = arrPric[12];
   arrPric[13]= priceDay;
   arrPric[14]= priceWeek;
   arrPric[15]= ThresholdUp_;//Per visualizzazione grafica
   arrPric[16]= ThresholdDw_;//Per visualizzazione grafica
   arrPric[17]= 0;           //Non usato, disponibile
   arrPric[18]= 0;
   arrPric[19]= 0;


   arrIn[15]  = ContaPrimiOrdersDay(magic_number);         //variabile globale da incrementare ad ogni apertura ordine al giorno. Da resettare al nuovo giorno

   if(impulsoNuovoGiorno())
     {resetLivelliPrimiOrdiniDay();}

   visualThreshold();                                      //Funzione che abilita o meno la visualizzazione delle soglie up e down

   if(newPrice(price_) || conta < 2 || newCandle() || changevisualThreshold(arrPric))
     {
      SqNine(arrPric, arrStrin, arrIn, arrBoo, arrCol);
      if(conta<3)
         conta++;
     }   

   if(!MarketIsOpen()){Comment("Market Closed");return;}
   FasciaPrezzoOrdineAboveBelowPerc(arrPric, PercLivPerOpenPos, AbovePercNoOrder, ThresholdDw_, ThresholdUp_);  //Restituisce true quando il prezzo è entro la % consentita
//--------------------- enable Secondo Livello ---------------------------------------+
//---------------------- Filtri su Nuovi Ordini. Abilitati solo: chiusure  -----------+
//---------------------- ordini grid/hedge/modifiche Stop Loss/Take Profit -----------+
   bool enableSecLiv = arrBoo[15] =
                          FiltroOrdiniSuStessaCandela(OrdiniSuStessaCandela, magic_number) &&
                          FiltroTimeSet(InpStartHour,InpStartMinute,InpEndHour,InpEndMinute,Fuso,FusoEnable,
                                        InpStartHour1,InpStartMinute1,InpEndHour1,InpEndMinute1) &&
                          FiltroNumOrdiniAperti(N_Max_pos, magic_number) &&                                       //Numero Max Orders Open Together (Max 2)
                          FiltroNumOrdiniGiornata(N_max_orders, magic_number) &&                                  //Number Max Orders on same Day
                          FiltroFasciePrezzoConsentito(arrPric, ApriOrdineDalLiv, ApreNuoviOrdiniFinoAlLivello)&& //Restituisce true quando il prezzo rientra nelle fascie consentite
                          FiltroOrdiniSuStessaCandela(OrdiniSuStessaCandela, magic_number) &&
                          FiltroSpreadMax(MaxSpread) &&
                          FiltroNews()&&
                          FiltroLivelliPresentiOra(RipetiLivelliPresentiOra,arrPric,magic_number)&&               //Repeat Orders on Equal Levels of Orders Present Now
                          FiltroLivelliOrdiniDelGiorno(RipetiLivelliDelGiorno,arrPric,LivelliPrimiOrdiniDay,magic_number)  //Repeat Orders on Equal Levels of Today's Orders
                          ;

   bool enableBuy = arrBoo[16] =
                          enablePivotWeekly_Buy(Filtro_Pivot_Weekly, priceWeek)&&
                          enablePivotDaily_Buy(FiltroPivotDaily, priceDay)&&
                          enableOnlyBuyOnlySell_Buy(Type_Orders_)&&
                          enableDirezioneCandela_Buy(versoCandelaPro)&&
                          enableOrderOpposto_Buy()&&                                                 // Se presente ordine Buy
                          TpRaggiuntoCandPrima(numCandLevSuccRaggiunto, percLevTpRaggiunto, arrPric) // Per Buy prima del SendOrder
                          ;
   bool enableSell = arrBoo[18] =
                          enablePivotWeekly_Sell(Filtro_Pivot_Weekly, priceWeek)&&
                          enablePivotDaily_Sell(FiltroPivotDaily, priceDay)&&
                          enableOnlyBuyOnlySell_Sell(Type_Orders_)&&
                          enableDirezioneCandela_Sell(versoCandelaPro)&&
                          enableOrderOpposto_Sell()&&
                          TpRaggiuntoCandPrima(numCandLevSuccRaggiunto, percLevTpRaggiunto, arrPric)  // Per Sell prima del SendOrder
                          ;
//+-----------------------------------------------------------------------------------+
   CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_,magic_number);
   //Print("Buy: ",MarketIsOpen()&&enableSecLiv&&enableBuy," Sell: ",MarketIsOpen()&&enableSecLiv&&enableSell);
   //Print("MarketIsOpen(): ",MarketIsOpen()," enableSecLiv: ",enableSecLiv," enableBuy: ",enableBuy," enableSell: ",enableSell); 
   gestioneDDmax(maxDDPerc, magic_number);                                             //Chiude tutti gli ordini se viene raggiunto il DD Max
   GestioneOrdini(arrBoo, arrIn, arrPric, PercLivPerOpenPos, AbovePercNoOrder, N_CandleConsecutive, candeleSuccess);            //Ex NumeroCandeleConsecutive
   GestioneBe_Ts(arrPric,segnoOrdine);
   GestioneGrid();
   GestioneHedge();
   if(NumOrdini(magic_number)>= 5)
      PositionsCloseAllPartial(100,Symbol(),magic_number);

   LevelToString(3);                                                                   //(Level price)
   PrezzoPrecedenteDiFascia(fasciaDiPrezzo(arrPric,1),arrPric);                        //Da Fascia prezzo a Prezzo precedente (inferiore se sopra al pivot, super. se sotto il pivot)
   PrezzoSuccessivoDiFascia(fasciaDiPrezzo(arrPric,1),arrPric);                        //Da Fascia prezzo a Prezzo successivo (superiore se sopra al pivot, infer. se sotto il pivot)

   /*

   FiltriIndicatori();


   */
   controlAccounts(NumeroAccountOk, TimeLicens);
   TrialLicence(TimeLicens);
  }

//+------------------------------------------------------------------+
//|                           OnTimer()                              |
//+------------------------------------------------------------------+
void OnTimer()
  {
   OnTick();
   if(NEWS_FILTER==false)
      return;
   static int waiting=0;
   if(waiting<=0)
     {
      if(!MQLInfoInteger(MQL_TESTER) || !MQLInfoInteger(MQL_OPTIMIZATION))
        {
         if(READ_NEWS(NEWS_TABLE))
            waiting=100;
         if(ArraySize(NEWS_TABLE)<=0)
            return;
         DRAW_NEWS(NEWS_TABLE);
        }
     }
   else
      waiting--;
   if(ArraySize(NEWS_TABLE)<=0)
      return;

   datetime time=TimeCurrent();
//---
   for(int i=0; i<ArraySize(NEWS_TABLE); i++)
     {
      datetime news_time=NEWS_TABLE[i].dTime+TIME_CORRECTION;
      bool Importance_Check=false;
      if((!NEWS_IMPORTANCE_LOW && NEWS_TABLE[i].importance=="*") ||
         (!NEWS_IMPORTANCE_MEDIUM && NEWS_TABLE[i].importance=="**") ||
         (!NEWS_IMPORTANCE_HIGH && NEWS_TABLE[i].importance=="***"))
         Importance_Check=true;
      if(Importance_Check || StringFind(Currencies_Check,NEWS_TABLE[i].currency,0)==-1 || (Check_Specific_News  && (StringFind(NEWS_TABLE[i].news,Specific_News_Text)==-1)))
         continue;
      if((news_time<=time && (news_time+(datetime)(START_AFTER_NEWS*60))>=time) ||
         (news_time>=time && (news_time-(datetime)(STOP_BEFORE_NEWS*60))<=time))
        {
         NEWS_ON=1;
         //Comment("News Time...");
         break;
        }
      else
        {
         NEWS_ON=0;
         //Comment("No News");
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//|                           DEL_ROW                                |
//+------------------------------------------------------------------+
void DEL_ROW(sNews &l_a_news[],int row)
  {
   int size=ArraySize(l_a_news)-1;
   for(int i=row; i<size; i++)
     {
      l_a_news[i].Actual=l_a_news[i+1].Actual;
      l_a_news[i].currency=l_a_news[i+1].currency;
      l_a_news[i].dTime=l_a_news[i+1].dTime;
      l_a_news[i].forecast=l_a_news[i+1].forecast;
      l_a_news[i].importance=l_a_news[i+1].importance;
      l_a_news[i].news=l_a_news[i+1].news;
      l_a_news[i].previus=l_a_news[i+1].previus;
      l_a_news[i].time=l_a_news[i+1].time;
     }
   ArrayResize(l_a_news,size);
  }
//+------------------------------------------------------------------+
//|                          READ_NEWS                               |
//+------------------------------------------------------------------+
bool READ_NEWS(sNews &l_NewsTable[])
  {
   string cookie=NULL,referer=NULL,headers;
   char post[],result[];
   string tmpStr="";
   string st_date=TimeToString(TimeCurrent(),TIME_DATE),end_date=TimeToString((TimeCurrent()+(datetime)(7*24*60*60)),TIME_DATE);
   StringReplace(st_date,".","");
   StringReplace(end_date,".","");
   string url="http://calendar.fxstreet.com/EventDateWidget/GetMini?culture="+LANG+"&view=range&start="+st_date+"&end="+end_date+"&timezone=UTC"+"&columns=date%2Ctime%2Ccountry%2Ccountrycurrency%2Cevent%2Cconsensus%2Cprevious%2Cvolatility%2Cactual&showcountryname=false&showcurrencyname=true&isfree=true&_=1455009216444";
   ResetLastError();
   WebRequest("GET",url,cookie,referer,10000,post,sizeof(post),result,headers);
   if(ArraySize(result)<=0)
     {
      int er=GetLastError();
      ResetLastError();
      Print("ERROR_TXT IN WebRequest");
      if(er==4060)
         MessageBox("YOU MUST ADD THE ADDRESS '"+"http://calendar.fxstreet.com/"+"' IN THE LIST OF ALLOWED URL IN THE TAB 'ADVISERS'","ERROR_TXT",MB_ICONINFORMATION);
      return false;
     }

   tmpStr=CharArrayToString(result,0,WHOLE_ARRAY,CP_UTF8);
   int handl=FileOpen("News.txt",FILE_WRITE|FILE_TXT);
   FileWrite(handl,tmpStr);
   FileFlush(handl);
   FileClose(handl);
   StringReplace(tmpStr,"&#39;","'");
   StringReplace(tmpStr,"&#163;","");
   StringReplace(tmpStr,"&#165;","");
   StringReplace(tmpStr,"&amp;","&");

   int st=StringFind(tmpStr,"fxst-thevent",0);
   st=StringFind(tmpStr,">",st)+1;
   int end=StringFind(tmpStr,"</th>",st);
   HEADS.news=(st<end ? StringSubstr(tmpStr,st,end-st) :"");
   st=StringFind(tmpStr,"fxst-thvolatility",0);
   st=StringFind(tmpStr,">",st)+1;
   end=StringFind(tmpStr,"</th>",st);
   HEADS.importance=(st<end ? StringSubstr(tmpStr,st,fmin(end-st,8)) :"");
   st=StringFind(tmpStr,"fxst-thactual",0);
   st=StringFind(tmpStr,">",st)+1;
   end=StringFind(tmpStr,"</th>",st);
   HEADS.Actual=(st<end ? StringSubstr(tmpStr,st,fmin(end-st,8)) :"");
   st=StringFind(tmpStr,"fxst-thconsensus",0);
   st=StringFind(tmpStr,">",st)+1;
   end=StringFind(tmpStr,"</th>",st);
   HEADS.forecast=(st<end ? StringSubstr(tmpStr,st,fmin(end-st,8)) :"");
   st=StringFind(tmpStr,"fxst-thprevious",0);
   st=StringFind(tmpStr,">",st)+1;
   end=StringFind(tmpStr,"</th>",st);
   HEADS.previus=(st<end ? StringSubstr(tmpStr,st,end-st) :"");
   HEADS.currency="";
   HEADS.dTime=0;
   HEADS.time="";
   int startLoad=StringFind(tmpStr,"<tbody>",0)+7;
   int endLoad=StringFind(tmpStr,"</tbody>",startLoad);
   if(startLoad>=0 && endLoad>startLoad)
     {
      tmpStr=StringSubstr(tmpStr,startLoad,endLoad-startLoad);
      while(StringReplace(tmpStr,"  "," "));
     }
   else
      return false;
   int begin=-1;
   do
     {
      begin=StringFind(tmpStr,"<span",0);
      if(begin>=0)
        {
         end=StringFind(tmpStr,"</span>",begin)+7;
         tmpStr=StringSubstr(tmpStr,0,begin)+StringSubstr(tmpStr,end);
        }
     }
   while(begin>=0);
   StringReplace(tmpStr,"<strong>",NULL);
   StringReplace(tmpStr,"</strong>",NULL);
   int BackShift=0;
   string arNews[];
   for(uchar tr=1; tr<255; tr++)
     {
      if(StringFind(tmpStr,CharToString(tr),0)>0)
         continue;
      int K=StringReplace(tmpStr,"</tr>",CharToString(tr));
      //ArrayResize(arNews,StringReplace(tmpStr,"</tr>",CharToString(tr)));
      K=StringSplit(tmpStr,tr,arNews);
      ArrayResize(l_NewsTable,K);
      for(int td=0; td<ArraySize(arNews); td++)
        {
         st=StringFind(arNews[td],"fxst-td-date",0);
         if(st>0)
           {
            st=StringFind(arNews[td],">",st)+1;
            end=StringFind(arNews[td],"</td>",st)-1;
            int d=(int)StringToInteger(StringSubstr(arNews[td],end-4,end-st));
            MqlDateTime time;
            TimeCurrent(time);
            if(d<(time.day-5))
              {
               if(time.mon==12)
                 {
                  time.mon=1;
                  time.year++;
                 }
               else
                 {
                  time.mon++;
                 }
              }
            time.day=d;
            time.min=0;
            time.hour=0;
            time.sec=0;
            date_=StructToTime(time);
            BackShift++;
            continue;
           }
         st=StringFind(arNews[td],"fxst-evenRow",0);
         if(st<0)
           {
            BackShift++;
            continue;
           }
         int st1=StringFind(arNews[td],"fxst-td-time",st);
         st1=StringFind(arNews[td],">",st1)+1;
         end=StringFind(arNews[td],"</td>",st1);
         l_NewsTable[td-BackShift].time=StringSubstr(arNews[td],st1,end-st1);
         if(StringFind(l_NewsTable[td-BackShift].time,":")>0)
           {
            l_NewsTable[td-BackShift].dTime=StringToTime(TimeToString(date_,TIME_DATE)+" "+StringSubstr(arNews[td],st1,end-st1));
           }
         else
           {
            l_NewsTable[td-BackShift].dTime=date_;
           }
         st1=StringFind(arNews[td],"fxst-td-currency",st);
         st1=StringFind(arNews[td],">",st1)+1;
         end=StringFind(arNews[td],"</td>",st1);
         l_NewsTable[td-BackShift].currency=(st1<end ? StringSubstr(arNews[td],st1,end-st1) :"");
         st1=StringFind(arNews[td],"fxst-i-vol",st);
         st1=StringFind(arNews[td],">",st1)+1;
         end=StringFind(arNews[td],"</td>",st1);
         StringInit(l_NewsTable[td-BackShift].importance,(int)StringToInteger(StringSubstr(arNews[td],st1,end-st1)),'*');
         st1=StringFind(arNews[td],"fxst-td-event",st);
         int st2=StringFind(arNews[td],"fxst-eventurl",st1);
         st1=StringFind(arNews[td],">",fmax(st1,st2))+1;
         end=StringFind(arNews[td],"</td>",st1);
         int end1=StringFind(arNews[td],"</a>",st1);
         l_NewsTable[td-BackShift].news=StringSubstr(arNews[td],st1,(end1>0 ? fmin(end,end1):end)-st1);
         st1=StringFind(arNews[td],"fxst-td-act",st);
         st1=StringFind(arNews[td],">",st1)+1;
         end=StringFind(arNews[td],"</td>",st1);
         l_NewsTable[td-BackShift].Actual=(end>st1 ? StringSubstr(arNews[td],st1,end-st1) : "");
         st1=StringFind(arNews[td],"fxst-td-cons",st);
         st1=StringFind(arNews[td],">",st1)+1;
         end=StringFind(arNews[td],"</td>",st1);
         l_NewsTable[td-BackShift].forecast=(end>st1 ? StringSubstr(arNews[td],st1,end-st1) : "");
         st1=StringFind(arNews[td],"fxst-td-prev",st);
         st1=StringFind(arNews[td],">",st1)+1;
         end=StringFind(arNews[td],"</td>",st1);
         l_NewsTable[td-BackShift].previus=(end>st1 ? StringSubstr(arNews[td],st1,end-st1) : "");
        }
      break;
     }
   ArrayResize(l_NewsTable,(ArraySize(l_NewsTable)-BackShift));
   return(true);
  }
//+------------------------------------------------------------------+
//|                          DRAW_NEWS                               |
//+------------------------------------------------------------------+
void DRAW_NEWS(sNews &l_a_news[])
  {
   if(DRAW_NEWS_LINES || DRAW_NEWS_CHART)
     {
      if(NEWS_FILTER==false)
         return;
      for(int i=ArraySize(l_a_news)-1; i>=0; i--)
        {
         StringReplace(l_a_news[i].currency," ","");
         int Currency_check_counter=0;

      datetime t1=(l_a_news[i].dTime+(datetime)(START_AFTER_NEWS*60));
      datetime t2=((TimeCurrent()-(datetime)TIME_CORRECTION));
         
         if(StringFind(Currencies_Check,l_a_news[i].currency)==-1 || t1<t2 || (Check_Specific_News  && (StringFind(l_a_news[i].news,Specific_News_Text)==-1)))
           {
            DEL_ROW(l_a_news,i);
            continue;
           }

         if((!NEWS_IMPORTANCE_LOW && l_a_news[i].importance=="*") ||
            (!NEWS_IMPORTANCE_MEDIUM && l_a_news[i].importance=="**") ||
            (!NEWS_IMPORTANCE_HIGH && l_a_news[i].importance=="***"))
           {
            DEL_ROW(l_a_news,i);
            continue;
           }
         string NAME=(" "+l_a_news[i].currency+" "+l_a_news[i].importance+" "+l_a_news[i].news);
         if(DRAW_NEWS_LINES)
           {
            if(ObjectFind(0,NAME)<0)
              {
               ObjectCreate(0,NAME,OBJ_VLINE,0,l_a_news[i].dTime+TIME_CORRECTION,0);
               ObjectSetInteger(0,NAME,OBJPROP_SELECTABLE,false);
               ObjectSetInteger(0,NAME,OBJPROP_SELECTED,false);
               ObjectSetInteger(0,NAME,OBJPROP_HIDDEN,true);
               ObjectSetInteger(0,NAME,OBJPROP_BACK,false);
               ObjectSetInteger(0,NAME,OBJPROP_COLOR,Line_Color);
               ObjectSetInteger(0,NAME,OBJPROP_STYLE,Line_Style);
               ObjectSetInteger(0,NAME,OBJPROP_WIDTH,Line_Width);
              }
           }
        }
      string NAME;
      int K=0,Z=0;
      if(DRAW_NEWS_CHART)
        {
         for(int l=1; l<=9 && Z<ArraySize(l_a_news); l++)
           {
            for(K=Z; K<ArraySize(l_a_news); K++)
               if(l_a_news[K].currency!="")
                  break;
            Z=K+1;


           NAME="PANEL_NEWS_N"+(string)l;
            if(ObjectFind(0,NAME)<0)
               OBJECT_LABEL(0,NAME,0,X+110,Y-(int)(18*(l+5)),CORNER_LEFT_LOWER,((TimeToString(l_a_news[K].dTime+TIME_CORRECTION,TIME_DATE|TIME_MINUTES)+" "+l_a_news[K].currency+" "+l_a_news[K].importance+" "+l_a_news[K].news)),News_Font,Font_Size,Font_Color,0,ANCHOR_LEFT_UPPER,false,false,true,0);

           }
        }
      return;
     }
  }

//+------------------------------------------------------------------+
//|                         DEINIT_PANEL()                           |
//+------------------------------------------------------------------+
void DEINIT_PANEL()
  {
   ObjectsDeleteAll(0);
  }

//+------------------------------------------------------------------+
//|                       OBJECT_LABEL                               |
//+------------------------------------------------------------------+
bool OBJECT_LABEL(const long              CHART_ID=0,
                  const string            NAME        = "",
                  const int               SUB_WINDOW  = 0,
                  const int               X_Axis      = 0,
                  const int               Y_Axis      = 0,
                  const ENUM_BASE_CORNER  CORNER      = CORNER_LEFT_UPPER,
                  const string            TEXT        = "",
                  const string            FONT        = "",
                  const int               FONT_SIZE   = 10,
                  const color             CLR         = color("255,0,0"),
                  const double            ANGLE       = 0.0,
                  const ENUM_ANCHOR_POINT ANCHOR      = ANCHOR_LEFT_UPPER,
                  const bool              BACK        = false,
                  const bool              SELECTION   = false,
                  const bool              HIDDEN      = true,
                  const long              ZORDER      = 0,
                  string                  TOOLTIP     = "\n")
  {
   ResetLastError();
   if(ObjectFind(0,NAME)<0)
     {
      ObjectCreate(CHART_ID,NAME,OBJ_LABEL,SUB_WINDOW,0,0);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_XDISTANCE,X_Axis);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_YDISTANCE,Y_Axis);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_CORNER,CORNER);
      ObjectSetString(CHART_ID,NAME,OBJPROP_TEXT,TEXT);
      ObjectSetString(CHART_ID,NAME,OBJPROP_FONT,FONT);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_FONTSIZE,FONT_SIZE);
      ObjectSetDouble(CHART_ID,NAME,OBJPROP_ANGLE,ANGLE);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_ANCHOR,ANCHOR);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_COLOR,CLR);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_BACK,BACK);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_SELECTABLE,SELECTION);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_SELECTED,SELECTION);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_HIDDEN,HIDDEN);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_ZORDER,ZORDER);
      ObjectSetString(CHART_ID,NAME,OBJPROP_TOOLTIP,TOOLTIP);
     }
   else
     {
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_COLOR,CLR);
      ObjectSetString(CHART_ID,NAME,OBJPROP_TEXT,TEXT);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_XDISTANCE,X);
      ObjectSetInteger(CHART_ID,NAME,OBJPROP_YDISTANCE,Y);
     }
   return(true);
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//|                       FiltroNews()                               |
//+------------------------------------------------------------------+
bool FiltroNews()
   {
    return !NEWS_ON;   
   }

//+------------------------------------------------------------------+
//|                        handleZigZag()                            |
//+------------------------------------------------------------------+
int handleZigZag()
  {
//--- create handle of the indicator iCustom
   handle_iCustom=iCustom(Symbol(),periodZigzag,"Examples\\ZigZag",InpDepth,InpDeviation,InptBackstep);
//--- if the handle is not created
   if(handle_iCustom==INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iCustom indicator for the symbol %s/%s, error code %d",
                  Symbol(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
      return(INIT_FAILED);
     }
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Get value of buffers                                             |
//+------------------------------------------------------------------+
double iGetArray(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
  {
   bool result=true;
   if(!ArrayIsDynamic(arr_buffer))
     {
      Print("This a no dynamic array!");
      return(false);
     }
   ArrayFree(arr_buffer);
//--- reset error code
   ResetLastError();
//--- fill a part of the iBands array with values from the indicator buffer
   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count)
     {
      //--- if the copying fails, tell the error code
      PrintFormat("Pending to copy data from the indicator");//PrintFormat("Failed to copy data from the indicator, error code %d",GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return(false);
     }
   return(result);
  }
//+------------------------------------------------------------------+
double ZIGZAG()
  {
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++)
     {
      ZigzagBuffer[i]=0;
     }
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))
      return  valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
           {
            valoreZigZag=ZigzagBuffer[i];
            semaforo=false;
           }
        }
     }
//Print(text);
   return valoreZigZag;//
  }

//+-------------------------ZIGZAGHiLo()-----------------------------+
double ZIGZAGHiLo()
  {
   bool semaforo=true;
   static double valoreZigZag;
   static long counter=0;
   counter++;
   if(counter>=15)
      counter=0;
   else
      return  valoreZigZag;
//---
   handleZigZag();
   double ZigzagBuffer[];
   for(int i=0; i<ArraySize(ZigzagBuffer); i++)
     {
      ZigzagBuffer[i]=0;
     }
   ArraySetAsSeries(ZigzagBuffer,true);
   int start_pos=0,count=InpCandlesCheck+1;
   if(!iGetArray(handle_iCustom,0,start_pos,count,ZigzagBuffer))
      return  valoreZigZag;

   string text="";
   for(int i=0; i<count; i++)
     {
      if(ZigzagBuffer[i]!=PLOT_EMPTY_VALUE && ZigzagBuffer[i]!=0.0 && i > 0)
        {
         text=text+"\n"+IntegerToString(i)+": "+DoubleToString(ZigzagBuffer[i],Digits());
         if(semaforo && disMinCandZZ <= i)
           {
            if(ZigzagBuffer[i]>=iOpen(Symbol(),PERIOD_CURRENT,i)||ZigzagBuffer[i]>=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);
                 }
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);
                 }
              }
            if(ZigzagBuffer[i]<=iOpen(Symbol(),PERIOD_CURRENT,i)||ZigzagBuffer[i]<=iClose(Symbol(),PERIOD_CURRENT,i))
              {
               if(iOpen(Symbol(),PERIOD_CURRENT,i)>=iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iClose(Symbol(),PERIOD_CURRENT,i);
                 }
               if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i))
                 {
                  valoreZigZag=iOpen(Symbol(),PERIOD_CURRENT,i);
                 }
              }
            semaforo=false;
           }
        }
     }
   return valoreZigZag;
  }
//+------------------------------------------------------------------+
bool visualThreshold()
  {
   bool a =arrBoo[10] = visualThres_Up=arrBoo[11] = visualThres_Dw= false;
   if(!FiltroFasciePrezzoConsentito(arrPric, ApriOrdineDalLiv, ApreNuoviOrdiniFinoAlLivello))
     {visualThres_Up=visualThres_Dw=arrBoo[10]=arrBoo[11]= false; a=false; return a;}
//visualThres_Up = true;visualThres_Dw = true;
      double ASK = Ask(Symbol());
      double BID = Bid(Symbol());

   if(ASK >= BuyAbove_ || BID <= SellBelow_)//////////////////// controllare bid e ask
     {
      visualThres_Up = true;
      visualThres_Dw = true;
     }
   if(ASK <  BuyAbove_ && BID >  SellBelow_)//////////////////// controllare bid e ask
     {
      visualThres_Up = false;
      visualThres_Dw = false;
     }

   if(!AbovePercNoOrder)
      visualThres_Up = false;
   if(!PercLivPerOpenPos)
      visualThres_Dw = false;

   arrBoo[10] = visualThres_Up;//Print(" AbovePercNoOrder: ",AbovePercNoOrder," visualThres_Up: ",visualThres_Up);Print(" BuyAbove_: ",BuyAbove_);
   arrBoo[11] = visualThres_Dw;//Print(" PercLivPerOpenPos: ",PercLivPerOpenPos," visualThres_Dw: ",visualThres_Dw);Print(" SellBelow_: ",SellBelow_);
   if(visualThres_Up || visualThres_Dw)
      a=true;
   return a;
  }
//+------------------------------------------------------------------+
void resetLivelliPrimiOrdiniDay()
  {
   for(int i=0; i<ArraySize(LivelliPrimiOrdiniDay)-1; i++)
     {LivelliPrimiOrdiniDay[i]=0;}
  }
//+------------------------------------------------------------------+
bool changevisualThreshold(const double &arrPri[])
  {
   bool a=false;
   bool FFPC=FiltroFasciePrezzoConsentito(arrPric, ApriOrdineDalLiv, ApreNuoviOrdiniFinoAlLivello);
   static bool Change=true;
   if(Change!=FFPC||newFascia(arrPri))
     {
      a=true;
      Change=FFPC;
     }
 //  if(a)Print("ChangeVisulaThres: ",a);
   return a;
  }
//+------------------------------------------------------------------+
bool enableOrderOpposto_Buy()
  {return !NumOrdBuy_(magic_number);}
//+------------------------------------------------------------------+
bool enableOrderOpposto_Sell()
  {return !NumOrdSell(magic_number);}

//+------------------------------------------------------------------+
double Lotti()
  {return myLotSize(compounding,AccountEquity(), AccountEquity(),lotsEA, riskEA,riskDenaroEA,(int)1000,commissioni);}
//+------------------------------------------------------------------+
//|                       GestioneBe_Ts()                            |
//+------------------------------------------------------------------+  
void GestioneBe_Ts(const double &arrPrice[],const string &BuySell)
{
double Be_Ts=0;
ulong ticketPrimOrdBuy  = TicketPrimoOrdineBuy(magic_number);
ulong ticketPrimOrdSell = TicketPrimoOrdineSell(magic_number);
static ulong ticketBuy;
static ulong ticketSell;

if(ticketPrimOrdBuy != 0 && ticketPrimOrdBuy != ticketBuy){ticketBuy = ticketPrimOrdBuy;GestioneBe("Buy",ticketBuy);GestioneTS("Buy",ticketBuy);}
if(ticketPrimOrdSell != 0 && ticketPrimOrdSell != ticketSell){ticketSell = ticketPrimOrdSell;GestioneBe("Sell",ticketSell);GestioneTS("Sell",ticketSell);}
}
//+------------------------------------------------------------------+
//|                          GestioneBe()                            |
//+------------------------------------------------------------------+  
void GestioneBe(string BuySell,ulong ticket)
{
if(!BreakEven)return;
if(BreakEven==1)BePoints(BuySell,ticket,BEGridActive,GridBuyActive,GridSellActive,Be_Start_points,Be_Step_points);
//if(BreakEven==2)BeLevel(BuySell,ticket);
}
//+------------------------------------------------------------------+
//|                          GestioneTS()                            |
//+------------------------------------------------------------------+  
void GestioneTS(string BuySell,ulong ticket)
{}/*
if(!TrailingStop)return;
if(TrailingStop==1) {TsPoints(BuySell,ticket);return;} 
if(TrailingStop==2) {TsLevels(BuySell,ticket);return;}  
if(TrailingStop==3) {TsTradiz(BuySell,ticket);return;} 
if(TrailingStop==4) {TsCandle(BuySell,ticket);return;}  
}
/*
//+------------------------------------------------------------------+
//|                          Indicators()                            |
//+------------------------------------------------------------------+
void Indicators()
  {
   char index=0;
   bool delete_Indicators= false;
   static double OldarrParamInd [50];
   static int old_arr_Input [30];
   for(int arr = 0; arr <= 49; arr++)
     {
      if(OldarrParamInd[arr] != arrParamInd[arr])
        {
         OldarrParamInd[arr] = arrParamInd[arr];
         delete_Indicators = true;
        }
     }
   for(int arr = 13; arr <= 18; arr++)
     {
      if(old_arr_Input[arr] != arrInput[arr])
        {
         old_arr_Input[arr] = arrInput[arr];
         delete_Indicators = true;
        }
     }
   if(arrParamInd[34]==1)
     {
      delete_Indicators=true;  // Semaforo onInit
     }

   if(delete_Indicators==false)
     {
      return;
     }
   if(delete_Indicators==true)
     {
      resetIndicators();
     }
     {
      if(arrParamInd[0])
        {
         double    indicator_handleMA=iMA(Symbol(),periodMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price,Moving_shift);
         ChartIndicatorAdd(0,0,indicator_handleMA);//iMA(Symbol(),periodMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price);
        }

      if(arrParamInd[6])
        {
         int    indicator_handleTEMA=iTEMA(Symbol(),periodTEMA,TEMA_period,TEMAShift,TEMA_method);
         ChartIndicatorAdd(0,0,indicator_handleTEMA);
        }

      if(arrParamInd[11])
        {
         index ++;
         int    indicator_handleRSI=iRSI(Symbol(),periodRSI,RSI_period, RSI_applied_price);
         ChartIndicatorAdd(0,index,indicator_handleRSI);
        }

      if(arrParamInd[16])
        {
         index ++;
         int    indicator_handleRSIStok=iStochastic(Symbol(),periodRSIstok,K_period,D_period,SlowDown,RSIstok_method,Stochastic_calculation_method);
         ChartIndicatorAdd(0,index,indicator_handleRSIStok);
        }

      if(arrParamInd[24])
        {
         index ++;
         int    indicator_handleMACD=iMACD(Symbol(),periodMACD,EMA_Fast,EMA_Slow,MACD_SMA,MACD_method);
         ChartIndicatorAdd(0,index,indicator_handleMACD);
        }

      if(arrParamInd[31])
        {
         index ++;
         int    indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);
         ChartIndicatorAdd(0,index,indicator_handleATR);
        }

      arrParamInd[34]=0;  // Semaforo onInit

     }
  }

//-------------------------------------- iMA ()---------------------------------------------
double Moving()
  {
   return iMA(Symbol(),periodMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price,0);
  }

//-------------------------------------- iTEMA ()---------------------------------------------
double TEMA()
  {
   double a =0;
   int handleTEMA = iTEMA(Symbol(),periodTEMA,TEMA_period,TEMAShift,TEMA_method);
   if(handleTEMA>INVALID_HANDLE)
     {
      double valoriTEMA[];
      if(CopyBuffer(handleTEMA,0,0,1,valoriTEMA)>0)
        {
         a = valoriTEMA[0];
        }
     }
   return a;
  }

//-------------------------------------- iRSI () ---------------------------------------------------
double RSI()
  {
   return iRSI(Symbol(),periodRSI,RSI_period, RSI_applied_price);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RSI_()
  {
   char IndiceCandela=1;
   double a =0;
   int handleRSI = iRSI(Symbol(),periodRSI,RSI_period, RSI_applied_price);
   if(handleRSI>INVALID_HANDLE)
     {
      double valoriRSI[];
      if(CopyBuffer(handleRSI,0,IndiceCandela,1,valoriRSI)>0)
        {
         a = valoriRSI[0];
        }
     }
   return a;
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
  */