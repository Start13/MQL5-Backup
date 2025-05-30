//+------------------------------------------------------------------+
//|                                   EA Libra.mq5                   |
//|                                   Corrado Bruni Copyright @2024  |
//|                                   "https://www.cbalgotrade.com"  |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property description "Libra Gold operates with multiple confirmations for opening orders. The main function is on the Square of 9 (Gann) levels. Set only the opening time of the American market!"
#property icon        "Libra.ico"

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>
#include <MyInclude\PosizioniTicket.mqh>
//#include <MyInclude\newsFromForexFactory.mqh>

//------------ Controllo Numero Licenze e tempo Trial, Corrado ----------------------
datetime TimeLicens = D'3000.01.01 00:00:00';
int NumeroAccount0 = 37114023;
int NumeroAccount1 = 68152694;
int NumeroAccount2 = 67107668;
int NumeroAccount3 = 27081543;
int NumeroAccount4 = 7015565;
int NumeroAccount5 = 7008209;
int NumeroAccount6 = 37140961;
int NumeroAccount7 = 67113373;
char NumeroAccountMax = 1;
long NumeroAccountOk [10];
//------------Controllo Numero Licenze e tempo Trial, Roberto-------------------------------------------------------------------
string versione = "v1.00";

string EAname0 =                       "EA Libra";
string EAname =                        EAname0+" "+versione;
string nameText =                      EAname+" ";
string nameTextCopy;

int ClientsAccountNumber[10000] =
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
datetime dateOnlyBacktest =            D'2024.12.30 00:00:00';///////

bool License =                         false;                  //////
datetime dateLicense =                 D'2224.12.30 00:00:00';//////
bool Trial =                           false;                ///////
datetime dateTrial =                   D'2224.12.30 00:00:00';/////
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
   PivotHL_2        = 4,        //Pivot D HL:2
   PivotHLC_3       = 5,        //Pivot D HLC:3
   Custom           = 6,        //Custom
   HighPrevDay      = 7,        //High of the previous day
   LowPrevDay       = 8,        //Minimum of the previous day
   HiLoZigZag       = 9,        //Last Top/Bottom of Zig Zag indicator
   HigLowZigZag     =10,        //Last High/Low of Zig Zag indicator

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
// Pivot                            = 1,         //Level Pivot
   Compra_Vendi                     = 2,         //Buy Above / Sell Below
   Primo_Livello                    = 3,         //R1/S1
   Secondo_Livello                  = 4,         //R2/S2
   Terzo_Livello                    = 5,         //R3/S3
   Quarto_Livello                   = 6,         //R4/S4
   Quinto_Livello                   = 7          //R5/S5
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


enum N_max_orders_
  {
   Uno                   = 1,          //Max One Orders day
   Due                   = 2,          //Max Two Positions day
   Tre                   = 3,          //Max Three Orders day
   Quattro               = 4,          //Max Four Orders day
   Cinque                = 5,          //Max Five Orders day
   Sei                   = 6,          //Max Six Orders day
   Sette                 = 7,          //Max Seven Orders day
   Otto                  = 8,          //Max Eight Orders day
   Nove                  = 9,          //Max Nine Orders day
   Dieci                 = 10,          //Max Ten Orders day
   Venti                 = 20,         //Max 20 Orders day
   Cinquanta             = 50,         //Max 50 Orders day
   Cento                 =100,         //Max 100 Orders day
  };

enum nMaxPos
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
   SL_Pips                          = 0,         //Stop loss Points
   SL_N_Livelli_Prima               = 1,         //Stop loss previous level setting

  };

enum SlLivPrec
  {
   Stesso     = 0,                 //Stop Loss at the same order level
   Una        = 1,                 //Stop Loss at previous level
   Due        = 2,                 //Stop Loss at the second previous level
   Tre        = 3,                 //Stop Loss at the third previous level
   Quattro    = 4                  //Stop Loss at previous quarter level
  };

enum TStop
  {
   No_TS                          = 0,  //No Trailing Stop
   PipsTStop                      = 1,  //Trailing Stop in Points
   PercLevelbylevelTStop          = 2,  //Trailing Stop Level by Level
   TSPointTradiz                  = 3,  //Trailing Stop in Points Traditional
// TsTopBotCandle                 = 4,  //Trailing Stop Top/Bottom Candle
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
   noFilter                        = 0, //Buy and Sell
   OnlyBuy                         = 1, //Only Buy
   OnlySell                        = 2, //Only Sell
   DisableOrders                   = 3, //No Buy / No Sell
  };
enum aboveLevel2
  {
   noFilter                        = 0, //Buy and Sell
   OnlyBuy                         = 1, //Only Buy
   OnlySell                        = 2, //Only Sell
   DisableOrders                   = 3, //No Buy / No Sell
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


//input ENUM_ORDER_PROPERTY_STRING Parametro;

input string   comment_IS =            "--- SQUARE of 9 LEVELS SETTINGS ---";   // --- SQUARE of 9 LEVELS SETTINGS ---

input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput              GannInputDigit                  = 4;              //Number of price digits used: Calibration
input Divisione              Divis                           = 0;              //Multiplication / Division of digits: Calibration

input PriceType              GannInputType                   = 9;              //Type of Input in Calculation
input string                 GannCustomPrice                 = "1.00000";
//input PivD_SR_Sqnine  PivotDaily                           = 0;              //On the chart: Pivot Daily or Resistances/Supports Sq 9
int  PivotDaily                                              = 0;              //On the chart: Pivot Daily or Resistances/Supports Sq 9
input PriceTypeW             TypePivW                        = 2;              //Pivot Weekly type
input PriceTypeD             PriceTypeD_                     = 3;              //Pivot Daily Type (for Filter)
input input_ruota_           input_ruota                     = 1;              //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_               = 1;              //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;              //Advanced Formula Angles: 360°/270°/180°/90°

input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input bool                   StopNewsOrders                  = false;     //Auto Stop News Orders When All Orders Closed
input Type_Orders            Type_Orders_                    =   0;       //Type of order opening
input char                   maxDDPerc                       =   0;       //Max DD% (0 Disable)
input int                    MaxSpread                       =   0;       //Max Spread (0 = Disable)
input bool                   Filtro_Pivot_Weekly             = false;     //Filter Pivot Weekly (Above: Buy only. Below: Sell only)
input bool                   FiltroPivotDaily                = false;     //Filter Pivot Daily  (Above: Buy only. Below: Sell only)

input bool                   OrdiniSuStessaCandela           = false;     //Orders in same CANDLE

input bool                   PosizAperLiv                    = false;     //If set n° orders >1: enable orders on the same LEVEL
input bool                   Repet_orders_stesso_level       = true;      //Repeat orders on the same level, on the same day
input N_CandleConsecutive_   N_CandleConsecutive             = 1;         //Number of consecutive candles to activate the orders
input Ap_Ord_Dal_Liv_Buy     ApriOrdineDalLiv                = 2;         //Open Orders from Level:
input Non_Ap_Ord_Dal_Liv_Buy ApreNuoviOrdiniFinoAlLivello    = 5;         //Open Orders up to Level:

input char                   PercLivPerOpenPos               = 0;         //Above this percentage level opens order
input int                    AbovePercNoOrder                = 0;         //Above this percetage dont open order (0=disable)

input N_max_orders_          N_max_orders                    =20;         //Maximum number of opening new orders in the day
input nMaxPos                N_Max_pos                       = 2;         //Maximum number of orders together

input int CloseOrdDopoNumCandDalPrimoOrdine_                 = 18;         //Close Single Order after n° candles lateral (0 = Disable)

input ulong                  magic_number                    = 7777;      //Magic Number
input string                 Commen                          = "EA LIBRA";//Comment
input int                    Deviazione                      = 3;         //Slippage

input string   comment_MM =            "--- MONEY MANAGEMENT ---";        // --- MONEY MANAGEMENT ---
input bool     compounding =           true;                              //Compounding
input capitBasePerCompoundingg capitBasePerCompounding1 = 0;              //Reference capital for Compounding
input double   lotsEA =                0;                                 //Lots
input double   riskEA =                1;                                 //Risk in % [0-100]
input double   riskDenaroEA =          0;                                 //Risk in money
input double   commissioni =           4;                                 //Commissions per lot

input string   comment_ZZ =            "--- ZIG ZAG ---"; // --- ZIG ZAG ---
input int      InpDepth       = 12;     // ZigZag: Depth
input int      InpDeviation   =  5;     // ZigZag: Deviation
input int      InptBackstep   =  3;     // ZigZag: Backstep
input int    InpCandlesCheck  = 50;     // ZigZag: how many candles to check back
input char     disMinCandZZ   =  3;     //Min candle distance
input ENUM_TIMEFRAMES      periodZigzag=PERIOD_CURRENT;      //Timeframe
input periodoRicercaCand   PEriodoRicNumCand = 0;            //Picchi zigzag nel periodo prima di 1 giorno/1 settimana/1 mese/6 mesi/1 anno
input ENUM_TIMEFRAMES      TFPeridoRicCand   ;

input string   comment_GRHE =           "--- GRID/HEDGING ---"; // --- GRID/HEDGING ---

input Grid_Hedge GridHedge    =    1;        //Enable Grid/Hedging
input bool     HedgPend       = true;        //Hedging Orders Pendulum
input int      StartGrid      = 2500;        //Start Grid/Hedging (Points)
input int      StepGrid       = 3600;        //Step Grid/Hedging (Points)
input char     NumMaxGrid     =   30;        //Numaro max di Grid/Hedging
input double   profitGrid      =   5;        //Profit in Grid/Hedging
//input int      ProfGridPoints  = 100;        //Profit Grid/Hedging Points
input char     MoltipliNumGrid =   1;        //After n° Grid/Hedging
input TipoMultipliGriglia TypeGrid = 1;      //Type Multipl Grid/Hedging: Fix/Progressive
input double   MoltiplLotStep  = 1.3;        //Multipl Lots Fix/Progressive
//input int CloseOrdDopoNumCandDalPrimoOrdine = 18;    //Close Single Order after n° candles lateral (0 = Disable)
int CloseOrdDopoNumCandDalPrimoOrdine = 0;    //Close Single Order after n° candles lateral (0 = Disable)
input bool     TpSeDueOrdini                = true; //With 2 orders on Grid: Disable TP

input string   comment_SL =            "--- STOP LOSS ---"; // --- STOP LOSS ---
input SL       Stop_Loss                =   1;              //Stop loss Points / Previous Levels
input int      Sl_n_pips                = 1000;             //Stop loss Points
input SlLivPrec     Sl_n_livelli_prima  =   1;              //Stop loss: previous level setting
input int      Sl_Perc_Al_Livello_Prima = 110;              //Stop loss, at what % of the previous level

input string   comment_BE =            "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_pips            = 2500;              //Be Start in Points
input int      Be_Step_pips             =  200;              //Be Step in Points
input bool     BEPointConGridOHedgeActive = true;            //Be Points enable with Orders Grid/Hedge opposite activated
input int      BE_PercLevelbylevel      =   85;              //Be LevelByLevel. If the order open beyond this %: BE Points set

input string   comment_TS =            "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points da Profit/Level/Points Traditional
input int      TS_pips                  = 3000;              //Ts Start in Points
input int      Ts_Step_pips             =  700;              //Ts Step in Points
input TsLevPrec TsLevPrec_              =    1;              //TS Level By Level Number of Previous Levels
//input int       indexCandle_            =    1;              //Index Candle Previous
//input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

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
input bool VisibiliInChart             = true;
//bool VisibiliInChart             = true;
input bool         ShortLines          = true;
input bool         ShowLineName        = true;
//input AlertType    Alert1              = 0;
AlertType    Alert1              = 0;
//input AlertType    Alert2              = 0;
AlertType    Alert2              = 0;
input int          PipDeviation        = 0;                        //Sensibility for alert
input string       CommentStyle        = "--- Style Settings ---";
input bool         DrawBackground      = true;
input bool         DisableSelection    = true;
input color        ResistanceColor     = clrRed;
input LineType     ResistanceType      = 2;
input LineWidth    ResistanceWidth     = 1;
input color        SupportColor        = clrLime;
input LineType     SupportType         = 2;
input LineWidth    SupportWidth        = 1;
input string       ButtonStyle         = "--- Toggle Style Settings ---";
//input bool         ButtonEnable        = false;
bool ButtonEnable        = false;
//input int          XDistance           = 250;
int          XDistance           = 250;
//input int          YDistance           = 5;
int          YDistance           = 5;
//input int          Width               = 100;
int          Width               = 100;
//input int          Hight               = 30;
int          Hight               = 30;
input string       Label               = " ";

char superamento_Livello_Buy;
char superamento_Livello_Sell;
char old_superamento_livello_Buy =0;
char old_superamento_livello_Sell=0;

double o1;
double c1;
double h1;
double l1;

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

double sogliaTp;

int    lastBar=0;
double lastAlarmPrice=0;
bool   timeToCalc=false;
double R1Price,R2Price,R3Price,R4Price,R5Price;
double S1Price,S2Price,S3Price,S4Price,S5Price;
string pcode="Square 9 ";
double LastAlert=-1;
double NewAlert=0;
//string broker_name;
double div;

string chartiD = "";
string buttonID="ButtonGann";
double showGann;

double High[1];
double Low[1];
double Open[1];
double Close[1];
double HighW[1];
double LowW[1];
double OpenW[1];
double CloseW[1];
double HighM[2];
double LowM[2];

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
double priceIn = 0;
int Divis_ = 0;

double LowP[1];
double HighP[1];
double valoriArr [30];
double arrParamInd [50];

string sniperString [30];

char Orders_LivellieNumero [15];
double Orders_Prezzi_Ordini [15];

int    arrInput [50];
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
double PivotDay;

static bool order_ok = false;
char lev_start;
int start__;
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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//ChartSetSymbolPeriod((ulong)chartiD,"XAUUSD",PERIOD_M15);
   NumCandPerPeriodo();
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
   arrInput [2] = Sl_n_livelli_prima;

   arrInput [4] = TsLevPrec_;
   arrInput [5] = Type_Orders_;
   arrInput [6] = BreakEven;                             //Modalità Be: No/Pips/Livello successivo
   arrInput [7] = Be_Start_pips;                         //Be in pips
   arrInput [8] = Be_Step_pips;                          //Be step in pips
   arrInput [9] = BE_PercLevelbylevel;                   //Se l'ordine apre sopra questa % al livello successivo...
//  arrInput [10]= Be_start_lev;                      //A questa % LelByLev interviene il Be
   arrInput [11]= PosizAperLiv;                          //Consente l'apertura di altre posizioni sullo stesso livello
   arrInput [12]= PercLivPerOpenPos;
   arrInput [13]= Filter_Moving_Average;                 //Abilita/Disabilita Moving Average
   arrInput [14]= Filter_ATR;
   arrInput [15]= Filter_RSI;
   arrInput [16]= Filter_RSIstok;
   arrInput [17]= FilterMACD;
   arrInput [18]= Filter_TEMA;
   arrInput [19]= TpSlInProfit;

   arrInput [22]= OrdiniSuStessaCandela;
//   arrInput [26]= indexCandle_;              //Index Candle Previous
// arrInput [27]= TFCandle;
   arrInput [30]= BEPointConGridOHedgeActive;

//semaforoImpostazioni=true;

   if(TimeLicens < TimeCurrent())
     {
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Print("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      ExpertRemove();
     }

   /*
    if(!InitialLicenseControl())
      {
       return INIT_FAILED;
      }
   */
   controlAccounts();
// Importante: questa istruzione tiene in memoria il bilancio di base su cui fare i calcoli del compounding
// capitaleBasePerCompounding = AccountEquity(); // La scelta del Bilancio piuttosto che l'Equity è una scelta del programmatore/trader   AccountBalance()
   chartiD = IntegerToString(ChartID())+"-1973456"; //chartiD+UniqueID
   EventSetTimer(10);
   clearObj();
   lastBar=0;
   commento = (AccountInfoString(ACCOUNT_COMPANY));
   StringAdd(commento,"\nPending ticks... ");
   if(VisibiliInChart)
     {
      Comment(commento, "\n");
     }
   if(VisibiliInChart)
     {
      Indicators();
     }
   Div_(); /////////////// inserito quando ho tolto OnCalculate
//*-----------------------------------------------------------------------------+

   if(ButtonEnable)
     {
      if(GlobalVariableCheck(chartiD+"-"+"showGann"))
         showGann = GlobalVariableGet(chartiD+"-"+"showGann");
      else
         showGann = -1;

      ObjectCreate(0,buttonID,OBJ_BUTTON,0,iTime(Symbol(),PERIOD_CURRENT,0),iHigh(Symbol(),PERIOD_CURRENT,0));
      ObjectSetInteger(0,buttonID,OBJPROP_XDISTANCE,XDistance);
      ObjectSetInteger(0,buttonID,OBJPROP_YDISTANCE,YDistance);
      ObjectSetInteger(0,buttonID,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,buttonID,OBJPROP_XSIZE,Width);
      ObjectSetInteger(0,buttonID,OBJPROP_YSIZE,Hight);
      ObjectSetInteger(0,buttonID,OBJPROP_STATE,false);
      ObjectSetInteger(0,buttonID,OBJPROP_BORDER_COLOR,clrGray);
      ObjectSetString(0,buttonID,OBJPROP_TEXT,Label);
      ObjectSetInteger(0,buttonID,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,buttonID,OBJPROP_HIDDEN,true);

      if(showGann==1 || showGann==-1)
        {
         ObjectSetInteger(0,buttonID,OBJPROP_BGCOLOR,clrRed);
        }
      else
        {
         ObjectSetInteger(0,buttonID,OBJPROP_BGCOLOR,clrGreen);
        }
      ObjectSetInteger(0,buttonID,OBJPROP_FONTSIZE,12);
      ObjectSetInteger(0,buttonID,OBJPROP_COLOR,clrWhite);
     }
   else
     {
      showGann = 1;
      GlobalVariableSet(chartiD+"-"+"showGann",showGann);
     }

   return(INIT_SUCCEEDED);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   resetIndicators();
   clearObj();
   ObjectDelete(0,buttonID);
   Comment("");
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   /*
   if(!IsMarketTradeOpen(Symbol()))
     {
      StringAdd(commento,"  MARKET CLOSED... ");
      Comment(commento, "\n");
      return;
     }*/
//Print("NEWS: ",checkNewsFromWeb("Crude Oil Inventories"));

   if(TimeLicens < TimeCurrent())
     {
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Print("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      ExpertRemove();
     }

   if(ultraLock)
     {
      if(!Trial || (TimeCurrent() < dateTrial))
        {
         if(!copyRight || !License || (TimeCurrent() < dateLicense))
           {
            if(!copyRight || !onlyBacktest || (TimeCurrent() < dateOnlyBacktest))
              {
               if(checkTime())
                  checkTimeRimozione();


               // esecuzione strategia e gestione

               if(capitBasePerCompounding1 == 0)
                  capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_EQUITY);
               if(capitBasePerCompounding1 == 1)
                  capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
               if(capitBasePerCompounding1 == 2)
                  capitaleBasePerCompounding = AccountInfoDouble(ACCOUNT_BALANCE);
               /*
                              if(NumOrdBuy(magic_number)>1)
                                 GridBuyActive=true;
                              if(NumOrdSell(magic_number)>1)
                                 GridSellActive=true;

                              arrInput [0] = TS_pips;
                              arrInput [1] = Ts_Step_pips;
                              arrInput [2] = Sl_n_livelli_prima;

                              arrInput [4] = TsLevPrec_;
                              arrInput [5] = Type_Orders_;
                              arrInput [6] = BreakEven;                             //Modalità Be: No/Pips/Livello successivo
                              arrInput [7] = Be_Start_pips;                         //Be in pips
                              arrInput [8] = Be_Step_pips;                          //Be step in pips
                              arrInput [9] = BE_PercLevelbylevel;                   //Se l'ordine apre sopra questa % al livello successivo...
                              //  arrInput [10]= Be_start_lev;                      //A questa % LelByLev interviene il Be
                              arrInput [11]= PosizAperLiv;                          //Consente l'apertura di altre posizioni sullo stesso livello
                              arrInput [12]= PercLivPerOpenPos;
                              arrInput [13]= Filter_Moving_Average;                 //Abilita/Disabilita Moving Average
                              arrInput [14]= Filter_ATR;
                              arrInput [15]= Filter_RSI;
                              arrInput [16]= Filter_RSIstok;
                              arrInput [17]= FilterMACD;
                              arrInput [18]= Filter_TEMA;
                              arrInput [19]= TpSlInProfit;

                              arrInput [22]= OrdiniSuStessaCandela;
               */
               arrInput [3] = (int) segno_ordine;
               arrInput [20]= GridBuyActive;
               arrInput [21]= GridSellActive;
               //arrInput [23]= PercLivNoOpenPos;
               arrInput [24]= NumOrdHedgeBuy(TicketHedgeBuy);
               arrInput [25]= NumOrdHedgeSell(TicketHedgeSell);
               //arrInput [30]= BEPointConGridOHedgeActive;

               static char qq;
               if(qq<1)
                  if(N_Max_pos>1&&GridHedge==2)
                    {
                     Alert("With Hedging Enabled: Set Maximum number of orders together ----> <Max One Position open on the Market>.");
                     Print("With Hedging Enabled: Set Maximum number of orders together ----> <Max One Position open on the Market>.");
                     qq++;
                     return;
                    }

               //+------------------------------------------------------------------+
               //|                  Valori Daily                                    |
               //+------------------------------------------------------------------+


               if(semaforominuto())
                 {
                  High[0]= iHigh(Symbol(),PERIOD_D1,1);

                  Low[0]=  iLow(Symbol(),PERIOD_D1,1);

                  Open[0]= iOpen(Symbol(),PERIOD_D1,1);

                  Close[0]= iClose(Symbol(),PERIOD_D1,1);
                 }
      
               PivotDay=PivotDay();
               //+------------------------------------------------------------------+
               //|        Valore d'ingresso del calcolatore dello Square of 9       |
               //+------------------------------------------------------------------+
               double price = 0;
               if(GannInputType==PreviousDayOpen)
                  price = Open[0];
               if(GannInputType==PreviousDayLow)
                  price = Low[0];
               if(GannInputType==PreviousDayHigh)
                  price = High[0];
               if(GannInputType==PreviousDayClose)
                  price = Close[0];
               if(GannInputType== PivotHL_2)
                  price = (Low[0]+High[0])/2;
               if(GannInputType==PivotHLC_3)
                  price = (Low[0]+High[0]+Close[0])/3;
               if(GannInputType==Custom)
                  price = StringToDouble(GannCustomPrice);
               if(GannInputType==HighPrevDay)
                  price = High[0];
               if(GannInputType==LowPrevDay)
                  price = Low[0];
               if(GannInputType==9)
                  price = ZIGZAG();
               if(GannInputType==10)
                  price = ZIGZAGHiLo();
               priceIn = price = NormalizeDouble(price,Digits());

               //+------------------------------------------------------------------+
               //|                  Pivot Daily                                     |
               //+------------------------------------------------------------------+
               if(PivotDaily==1)
                 {
                  double PuntoPivotDaily = (Low[0]+High[0]+Close[0])/3;
                  rD1 = 2 * PuntoPivotDaily - Low[0];
                  sD1 = 2 * PuntoPivotDaily - High[0];

                  rD3 = High[0] + 2 * (PuntoPivotDaily - Low[0]);
                  rD2 = PuntoPivotDaily + (rD1 - sD1);

                  sD2 = PuntoPivotDaily - (rD1 - sD1);
                  sD3 = Low[0] - 2 * (High[0] - PuntoPivotDaily);
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
               //|                  Segnale Nuova Sessione                          |
               //+------------------------------------------------------------------+

               nuovaSessione(Open[0],Close[0]);

               //+------------------------------------------------------------------+
               //|                   Pivot Weekly                                   |
               //+------------------------------------------------------------------+

               if(Minute())
                 {
                  HighM[0]= iHigh(Symbol(),PERIOD_MN1,1);

                  LowM[0]= iLow(Symbol(),PERIOD_MN1,1);

                  HighM[1]= iHigh(Symbol(),PERIOD_MN1,6);

                  LowM[1]= iLow(Symbol(),PERIOD_MN1,6);

                  HighW[0]= iHigh(Symbol(),PERIOD_W1,1);

                  LowW[0]=  iLow(Symbol(),PERIOD_W1,1);

                  OpenW[0]= iOpen(Symbol(),PERIOD_W1,1);

                  CloseW[0]= iClose(Symbol(),PERIOD_W1,1);

                  HighP[0]=iHigh(Symbol(),PERIOD_D1,1);

                  LowP[0]=iLow(Symbol(),PERIOD_D1,1);
                 }


               //+------------------------------------------------------------------+
               //|     Tipo Pivot Weekly:  1=/2, 2=/3 == TypePivW                   |
               //|          Valore Pivot W = priceW                                 |
               //+------------------------------------------------------------------+

               if(TypePivW == 1)
                  priceW = (LowW[0]+HighW[0])/2;
               if(TypePivW == 2)
                  priceW = (LowW[0]+HighW[0]+CloseW[0])/3;


               double PuntoPivotWeekly = (HighW[0] + CloseW[0] + LowW[0]) / 3;
               rW1 = 2 * PuntoPivotWeekly - LowW[0];
               sW1 = 2 * PuntoPivotWeekly - HighW[0];

               rW3 = HighW[0] + 2 * (PuntoPivotWeekly - LowW[0]);
               rW2 = PuntoPivotWeekly + (rW1 - sW1);

               sW2 = PuntoPivotWeekly - (rW1 - sW1);
               sW3 = LowW[0] - 2 * (HighW [0] -PuntoPivotWeekly);


               //+------------------------------------------------------------------+
               //|     Dati H: h1, L:l1, O:o1, C:c1, ultima candela chiusa          |
               //|                                                                  |
               //+------------------------------------------------------------------+

               c1 = iClose(Symbol(),PERIOD_CURRENT,1);         // prezzo Chiusura

               o1 = iOpen(Symbol(),PERIOD_CURRENT,1);          // prezzo Apertura

               h1 = iHigh(Symbol(),PERIOD_CURRENT,1);          // prezzo Top

               l1 = iLow(Symbol(),PERIOD_CURRENT,1);           // prezzo Bottom

               //-----------------------------------------------DDMax-------------------------------------------------+

               if(DDMax(maxDDPerc,magic_number))
                 {
                  brutalCloseTotal(Symbol(),magic_number);
                  return;
                  Print("DD Max raggiunto");
                  //Alert("DD Max raggiunto");
                 }

               //-----------------------------------------Fascia di Prezzo-------------------------------------------+
               prezzoPivot = priceIn;

               levelByLevel = fasciaDiPrezzo(iClose(Symbol(),PERIOD_CURRENT,1), false);

               CloseOrderDopoNumCand(CloseOrdDopoNumCandDalPrimoOrdine_);

               //+--------------------------------- Controllo Hedge/Griglia ------------------------------------------+
               GestioneHedge();

               GestioneGrid();

               //+----------------------------------- Controllo Trailing Stop ------------------------------------------+
               switcTs(TrailingStop, sniperString, arrInput, valoriArr, magic_number);

               //+----------------------------------- Controllo Break Even ---------------------------------------------+

               switchBeB(sniperString, arrInput, valoriArr, magic_number);

               //+------------------------- No Take Profit if Be o Ts in Profict ---------------------------------+

               NoTpIfBeTsProfit(sniperString,arrInput,valoriArr,magic_number);

               //+---------------------------------- Controllo BUY e SELL ----------------------------------------------+

               superamento_Livello();

               //--------------------------------------------------------------------------------------------------------+

               string FusoOrario="";
               datetime orario;
               if(Fuso == 0)
                 {
                  FusoOrario = "GMT";
                  orario=TimeGMT();
                 }
               if(Fuso == 1)
                 {
                  FusoOrario = "LOCAL";
                  orario=TimeLocal();
                 }
               if(Fuso == 2)
                 {
                  FusoOrario = "SERVER";
                  orario=TimeTradeServer();
                 }

               string TimeEnable;
               if(!InTradingTime(InpStartHour,InpStartMinute,InpEndHour,InpEndMinute,Fuso,FusoEnable)
                  && !InTradingTime(InpStartHour1,InpStartMinute1,InpEndHour1,InpEndMinute1,Fuso,FusoEnable))
                  TimeEnable="\n  * OUTSIDE OF TRADING TIME *  ";

               if(InTradingTime(InpStartHour,InpStartMinute,InpEndHour,InpEndMinute,Fuso,FusoEnable)
                  || InTradingTime(InpStartHour1,InpStartMinute1,InpEndHour1,InpEndMinute1,Fuso,FusoEnable))
                  TimeEnable="\n       WITHIN TRADING TIME";

               string MarketOpCl="";
               if(IsMarketTradeOpen()&&TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
                  MarketOpCl="OPEN";
               if(!IsMarketTradeOpen()||!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
                  MarketOpCl="* CLOSED *";

               string GridString="";
               if(GridHedge==0)
                  GridString="No";
               if(GridHedge==1)
                  GridString="Grid";
               if(GridHedge==2)
                  GridString="Hedging";

               string Periodzigzag="";
               if(periodZigzag==0)
                  Periodzigzag="Curent Period";
               else
                  Periodzigzag=(string)periodZigzag;

               string StopSpread;
               if((Spread(Symbol())>MaxSpread)&&MaxSpread!=0)
                 {
                  StopSpread="* STOP NEWS ORDERS *";
                 }

               double Ask,Bid;
               int Spread;
               Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
               Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
               Spread=(int)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
               percAggiunta=NormalizeDouble((((secondoLevBuy - primoLevBuy) * 0.01 * PercLivPerOpenPos)),Digits());

               if(VisibiliInChart)
                 {
                  StringConcatenate(commento,StringFormat("--------------------* EA LIBRA *-------------------"+"\n\nMarket Broker "+(AccountInfoString(ACCOUNT_COMPANY))+" "+MarketOpCl+
                                                          "\nASK:         %G\nBID:          %G\nSPREAD:         %d \n",
                                                          Ask,Bid,Spread)+"MAX SPREAD: ",(string)MaxSpread+"   "+StopSpread+"\n\nPIVOT DAILY/INPUT:    ",prezzoPivot,
                                    "\nPIVOT WEEKLY:            ",NormalizeDouble(priceW,Digits()),"\n------------------------------------------------------------","\nVALUE \"Buy_Above\":     "
                                    + (string) NormalizeDouble(compraSopra,Digits()),"\nN° DIGITS INPUT:        " +(string)GannInputDigit+"\nDIVISION DIGITS:       ", (string)div,
                                    "\nClose First Order After:   "+(string)CloseOrdDopoNumCandDalPrimoOrdine_+
                                    "\n------------------------------------------------------------",

                                    "\n---------------------- ZIG ZAG -----------------------",
                                    "\nTime frame Zig Zag:       ",Periodzigzag,"\nDepth:                         ",
                                    InpDepth,"\nDeviation:                      ",
                                    InpDeviation,
                                    "\nBackstep:                       ",InptBackstep,"\nCandles to check back:   ",NumCandPerPeriodo(),
                                    "\nMin candle distance:         ",disMinCandZZ,"\nPicchi precedenti periodo:  ",PEriodoRicNumCand,"\nPicchi Time frame:           ",TFPeridoRicCand,

                                    "\n------------------ HEDGE/GRID --------------------"
                                    + "\nMax DD:                    "+ (string)maxDDPerc+
                                    "\nHedge/Grid:            ",GridString+"\nPendulum:              "+(string)HedgPend,"\nStart Hedge/Grid:    ",StartGrid,"\nStep Hedge/Grid:     ",
                                    (string)StepGrid+"\nNumero Max Hedge/Grid:   "+ (string)NumMaxGrid+"\nClose First Order After: "+(string)CloseOrdDopoNumCandDalPrimoOrdine+

                                    "\n------------------------------------------------------------"+
                                    "\n\nAUTO STOP NEWS ORDERS:   "+(string)StopNewsOrders+ "\nPIVOT WEEKLY FILTER:           ",Filtro_Pivot_Weekly,"\nN° CANDLES FOR ORDER:       ",
                                    N_CandleConsecutive,"\nREPEATS ORDERS ON LEVEL:  ",Repet_orders_stesso_level,"\n------------------------------------------------------------",
                                    "\n\nORDERS FROM THE LEVEL:    ",LevelToString__(ApriOrdineDalLiv),"\nLAST LEVEL FOR ORDERS:      ",LevelToString__(ApreNuoviOrdiniFinoAlLivello),
                                    "\nAbove this % level opens order: ",PercLivPerOpenPos," %","\n=  +/- ",percAggiunta,"\n\nMAX N° OF ORDERS IN THE DAY: ",
                                    N_max_orders,"\nMAX ORDERS AT THE SAME TIME: ",N_Max_pos,
                                    "\n------------------------------------------------------------",
                                    "\n\nTIME ",FusoOrario,"   ", orario,TimeEnable,
                                    "\n\nMAGIC NUMBER:                       ",magic_number,
                                    "\nCOMMENT:                        ",Commen,"\n------------------------------------------------------------");

                  Comment((string)commento);
                 }


               if(!VisibiliInChart)
                 {
                  StringConcatenate(commento,StringFormat("-------------------* EA LIBRA *-------------------"+"\n\nMarket Broker "+(AccountInfoString(ACCOUNT_COMPANY))+" "+MarketOpCl+
                                                          "\nASK:         %G\nBID:          %G\nSPREAD:      %d \n", Ask,Bid,Spread), "\nMax DD:                "+
                                    (string)maxDDPerc+"\n\nAUTO STOP NEWS ORDERS:   "+(string)StopNewsOrders+ "\n\nTIME ",FusoOrario,"   ", orario,TimeEnable,
                                    "\n\nMAGIC NUMBER: ",magic_number, "\nCOMMENT:                        ",Commen);

                  Comment((string)commento);
                 }



               GannInputDigit_ = GannInputDigit;
               Divis_ = Divis;

               GannObj gann(price,GannInputDigit,iClose(Symbol(),PERIOD_CURRENT,1),Digits());

               R1Price=gann.getresistance1();
               R2Price=gann.getresistance2();
               R3Price=gann.getresistance3();
               R4Price=gann.getresistance4();
               R5Price=gann.getresistance5();

               S1Price=gann.getsupport1();
               S2Price=gann.getsupport2();
               S3Price=gann.getsupport3();
               S4Price=gann.getsupport4();
               S5Price=gann.getsupport5();


               R1Price=primoLevBuy ;
               R2Price=secondoLevBuy;
               R3Price=terzoLevBuy;
               R4Price=quartoLevBuy;
               R5Price=quintoLevBuy;

               S1Price=primoLevSell;
               S2Price=secondoLevSell;
               S3Price=terzoLevSell;
               S4Price=quartoLevSell;
               S5Price=quintoLevSell;


               if(showGann&&VisibiliInChart)
                 {
                  if(ShortLines)
                     drawRectangleLine();
                  else
                     drawHorizontalLine();
                  writeLineName();
                  checkAlarmPrice();
                 }
              }
           }
         else
           {
            if(commentLicenseExpired)
              {
               Print("License expired, contact cbalgotrade@gmail.com for info. Thanks!");
               commentLicenseExpired = false;
               //ExpertRemove();
              }
           }
        }
      else
        {
         if(commentTrialExpired)
           {
            Print("Trial expired, contact cbalgotrade@gmail.com for info. Thanks!");
            commentTrialExpired = false;
            //ExpertRemove();
           }
        }
     }

   if(TimeLicens < TimeCurrent())
     {
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Print("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      ExpertRemove();
     }
  }




//+-------------------------checkAlarmPrice---------------------------------+
void checkAlarmPrice()
  {

   double ClosePrice[1];
   CopyClose(Symbol(),0,0,1,ClosePrice);

   string message="";
   NewAlert=LastAlert;

   if(ClosePrice[0]>=R5Price-(Point()*PipDeviation)       && ClosePrice[0]<=R5Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R5");
   if(ClosePrice[0]>=R4Price-(Point()*PipDeviation)       && ClosePrice[0]<=R4Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R4");
   if(ClosePrice[0]>=R3Price-(Point()*PipDeviation)       && ClosePrice[0]<=R3Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R3");
   if(ClosePrice[0]>=R2Price-(Point()*PipDeviation)       && ClosePrice[0]<=R2Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R2");
   if(ClosePrice[0]>=R1Price-(Point()*PipDeviation)       && ClosePrice[0]<=R1Price+(Point()*PipDeviation))
      NewAlert=getAlertID("R1");
   if(ClosePrice[0]>=compraSopra-(Point()*PipDeviation)   && ClosePrice[0]<=compraSopra+(Point()*PipDeviation))
      NewAlert=getAlertID("Compra Sopra");
   if(ClosePrice[0]>=vendiSotto-(Point()*PipDeviation)    && ClosePrice[0]<=vendiSotto+(Point()*PipDeviation))
      NewAlert=getAlertID("Vendi Sotto");
   if(ClosePrice[0]>=S1Price-(Point()*PipDeviation)       && ClosePrice[0]<=S1Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S1");
   if(ClosePrice[0]>=S2Price-(Point()*PipDeviation)       && ClosePrice[0]<=S2Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S2");
   if(ClosePrice[0]>=S3Price-(Point()*PipDeviation)       && ClosePrice[0]<=S3Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S3");
   if(ClosePrice[0]>=S4Price-(Point()*PipDeviation)       && ClosePrice[0]<=S4Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S4");
   if(ClosePrice[0]>=S5Price-(Point()*PipDeviation)       && ClosePrice[0]<=S5Price+(Point()*PipDeviation))
      NewAlert=getAlertID("S5");


   if(NewAlert!=LastAlert)
     {
      message = getAlertMessage(NewAlert,ClosePrice[0]);

      if(Alert1 == 1)
         PlaySound("Alert");
      if(Alert1 == 2)
         Alert(message);
      if(Alert1 == 3)
         SendNotification(message);
      if(Alert1 == 4)
         SendMail("Level Sq 9 - ",message);

      if(Alert1 != Alert2)
        {
         if(Alert2 == 1)
            PlaySound("Alert");
         if(Alert2 == 2)
            Alert(message);
         if(Alert2 == 3)
            SendNotification(message);
         if(Alert2 == 4)
            SendMail("Level Sq 9 - ",message);
        }

      GlobalVariableSet(chartiD+"-"+"LastAlert",NewAlert);
      LastAlert=NewAlert;
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawHorizontalLine()
  {

   datetime Time5[1];
   CopyTime(Symbol(),PERIOD_D1,0,1,Time5);


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

   if(compraSopra!=0)
     {
      if(ObjectFind(0,pcode+"Compra Sopra")<0)
         ObjectCreate(0,pcode+"Compra Sopra", OBJ_HLINE, 0, Time5[0], compraSopra);
      else
         ObjectMove(0,pcode+"Compra Sopra",0,Time5[0],compraSopra);

      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_COLOR, clrGold);
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

   if(priceW!=0)
     {
      if(ObjectFind(0,pcode+"PivotW")<0)
         ObjectCreate(0,pcode+"PivotW", OBJ_HLINE, 0, Time5[0], priceW);
      else
         ObjectMove(0,pcode+"PivotW",0,Time5[0],priceW);

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

   if(rD3!=0)
     {
      if(ObjectFind(0,pcode+"RD3")<0)
         ObjectCreate(0,pcode+"RD3", OBJ_HLINE, 0, Time5[0], rD3);
      else
         ObjectMove(0,pcode+"RD3",0,Time5[0],rD3);

      ObjectSetInteger(0,pcode+"RD3", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_HIDDEN, true);
     }
   if(sD3!=0)
     {
      if(ObjectFind(0,pcode+"SD3")<0)
         ObjectCreate(0,pcode+"SD3", OBJ_HLINE, 0, Time5[0], sD3);
      else
         ObjectMove(0,pcode+"SD3",0,Time5[0],sD3);

      ObjectSetInteger(0,pcode+"SD3", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_HIDDEN, true);
     }

   if(rD2!=0)
     {
      if(ObjectFind(0,pcode+"RD2")<0)
         ObjectCreate(0,pcode+"RD2", OBJ_HLINE, 0, Time5[0], rD2);
      else
         ObjectMove(0,pcode+"RD2",0,Time5[0],rD2);

      ObjectSetInteger(0,pcode+"RD2", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_HIDDEN, true);
     }

   if(sD2!=0)
     {
      if(ObjectFind(0,pcode+"SD2")<0)
         ObjectCreate(0,pcode+"SD2", OBJ_HLINE, 0, Time5[0], sD2);
      else
         ObjectMove(0,pcode+"SD2",0,Time5[0],sD2);

      ObjectSetInteger(0,pcode+"SD2", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_HIDDEN, true);
     }

   if(rD1!=0)
     {
      if(ObjectFind(0,pcode+"RD1")<0)
         ObjectCreate(0,pcode+"RD1", OBJ_HLINE, 0, Time5[0], rD1);
      else
         ObjectMove(0,pcode+"RD1",0,Time5[0],rD1);

      ObjectSetInteger(0,pcode+"RD1", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_HIDDEN, true);
     }
   if(sD1!=0)
     {
      if(ObjectFind(0,pcode+"SD1")<0)
         ObjectCreate(0,pcode+"SD1", OBJ_HLINE, 0, Time5[0], sD1);
      else
         ObjectMove(0,pcode+"SD1",0,Time5[0],sD1);

      ObjectSetInteger(0,pcode+"SD1", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_HIDDEN, true);
     }



   if(vendiSotto!=0)
     {
      if(ObjectFind(0,pcode+"Vendi Sotto")<0)
         ObjectCreate(0,pcode+"Vendi Sotto", OBJ_HLINE, 0, Time5[0], vendiSotto);
      else
         ObjectMove(0,pcode+"Vendi Sotto",0,Time5[0],vendiSotto);

      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_COLOR, clrLawnGreen);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }                                                        /////////////////////////////////////////////////


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
//|                                                                  |
//+------------------------------------------------------------------+
void drawRectangleLine()
  {
   datetime time1,time2,Time5[1];

   Time5[0]=0;
   CopyTime(Symbol(),PERIOD_CURRENT,0,1,Time5);
   time1 = Time5[0]-(PeriodSeconds(Period())*50);

   CopyTime(Symbol(),Period(),0,1,Time5);
   time2 = Time5[0]+(PeriodSeconds(Period())*50);

   if(R5Price!=0)
     {
      if(ObjectFind(0,pcode+"R5")<0)
         ObjectCreate(0,pcode+"R5", OBJ_RECTANGLE, 0, time1, R5Price, time2, R5Price);
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
         ObjectCreate(0,pcode+"R4", OBJ_RECTANGLE,0,time1,R4Price,time2,R4Price);

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
         ObjectCreate(0,pcode+"R3", OBJ_RECTANGLE,0,time1,R3Price,time2,R3Price);
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
         ObjectCreate(0,pcode+"R2", OBJ_RECTANGLE,0,time1,R2Price,time2,R2Price);
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
         ObjectCreate(0,pcode+"R1", OBJ_RECTANGLE,0,time1,R1Price,time2,R1Price);
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

   if(compraSopra!=0)
     {
      if(ObjectFind(0,pcode+"Compra Sopra")<0)
         ObjectCreate(0,pcode+"Compra Sopra", OBJ_RECTANGLE,0,time1,compraSopra,time2,compraSopra);
      else
        {
         ObjectMove(0,pcode+"Compra Sopra",0,time1,compraSopra);
         ObjectMove(0,pcode+"Compra Sopra",1,time2,compraSopra);
        }

      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_COLOR, clrGold);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Compra Sopra", OBJPROP_HIDDEN, true);
     }

   if(priceIn!=0)
     {
      if(ObjectFind(0,pcode+"Pivot Line")<0)
         ObjectCreate(0,pcode+"Pivot Line", OBJ_RECTANGLE,0,time1,priceIn,time2,priceIn);
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


   if(priceW!=0)
     {
      if(ObjectFind(0,pcode+"PivotW")<0)
         ObjectCreate(0,pcode+"PivotW", OBJ_RECTANGLE,0,time1,priceW,time2,priceW);
      else
        {
         ObjectMove(0,pcode+"PivotW",0,time1,priceW);
         ObjectMove(0,pcode+"PivotW",1,time2,priceW);
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
         ObjectCreate(0,pcode+"PivotDay", OBJ_RECTANGLE,0,time1,PivotDay,time2,PivotDay);
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


   if(rD3!=0)
     {
      if(ObjectFind(0,pcode+"RD3")<0)
         ObjectCreate(0,pcode+"RD3", OBJ_RECTANGLE,0,time1,rD3,time2,rD3);
      else
        {
         ObjectMove(0,pcode+"RD3",0,time1,rD3);
         ObjectMove(0,pcode+"RD3",1,time2,rD3);
        }

      ObjectSetInteger(0,pcode+"RD3", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"RD3", OBJPROP_HIDDEN, true);
     }

   if(sD3!=0)
     {
      if(ObjectFind(0,pcode+"SD3")<0)
         ObjectCreate(0,pcode+"SD3", OBJ_RECTANGLE,0,time1,sD3,time2,sD3);
      else
        {
         ObjectMove(0,pcode+"SD3",0,time1,sD3);
         ObjectMove(0,pcode+"SD3",1,time2,sD3);
        }

      ObjectSetInteger(0,pcode+"SD3", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"SD3", OBJPROP_HIDDEN, true);
     }


   if(rD2!=0)
     {
      if(ObjectFind(0,pcode+"RD2")<0)
         ObjectCreate(0,pcode+"RD2", OBJ_RECTANGLE,0,time1,rD2,time2,rD2);
      else
        {
         ObjectMove(0,pcode+"RD2",0,time1,rD2);
         ObjectMove(0,pcode+"RD2",1,time2,rD2);
        }

      ObjectSetInteger(0,pcode+"RD2", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"RD2", OBJPROP_HIDDEN, true);
     }

   if(sD2!=0)
     {
      if(ObjectFind(0,pcode+"SD2")<0)
         ObjectCreate(0,pcode+"SD2", OBJ_RECTANGLE,0,time1,sD2,time2,sD2);
      else
        {
         ObjectMove(0,pcode+"SD2",0,time1,sD2);
         ObjectMove(0,pcode+"SD2",1,time2,sD2);
        }

      ObjectSetInteger(0,pcode+"SD2", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"SD2", OBJPROP_HIDDEN, true);
     }

   if(sD1!=0)
     {
      if(ObjectFind(0,pcode+"SD1")<0)
         ObjectCreate(0,pcode+"SD1", OBJ_RECTANGLE,0,time1,sD1,time2,sD1);
      else
        {
         ObjectMove(0,pcode+"SD1",0,time1,sD1);
         ObjectMove(0,pcode+"SD1",1,time2,sD1);
        }

      ObjectSetInteger(0,pcode+"SD1", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"SD1", OBJPROP_HIDDEN, true);
     }

   if(rD1!=0)
     {
      if(ObjectFind(0,pcode+"RD1")<0)
         ObjectCreate(0,pcode+"RD1", OBJ_RECTANGLE,0,time1,rD1,time2,rD1);
      else
        {
         ObjectMove(0,pcode+"RD1",0,time1,rD1);
         ObjectMove(0,pcode+"RD1",1,time2,rD1);
        }

      ObjectSetInteger(0,pcode+"RD1", OBJPROP_WIDTH, ResistanceWidth);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_STYLE, ResistanceType);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"RD1", OBJPROP_HIDDEN, true);
     }

   if(vendiSotto!=0)
     {
      if(ObjectFind(0,pcode+"Vendi Sotto")<0)
         ObjectCreate(0,pcode+"Vendi Sotto", OBJ_RECTANGLE,0,time1,vendiSotto,time2,vendiSotto);
      else
        {
         ObjectMove(0,pcode+"Vendi Sotto",0,time1,vendiSotto);
         ObjectMove(0,pcode+"Vendi Sotto",1,time2,vendiSotto);
        }

      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_WIDTH, SupportWidth);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_COLOR, clrLawnGreen);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_STYLE, SupportType);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_BACK, DrawBackground);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_SELECTABLE, !DisableSelection);
      ObjectSetInteger(0,pcode+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }


   if(S1Price!=0)
     {
      if(ObjectFind(0,pcode+"S1")<0)
         ObjectCreate(0,pcode+"S1", OBJ_RECTANGLE,0,time1,S1Price,time2,S1Price);
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
         ObjectCreate(0,pcode+"S2", OBJ_RECTANGLE,0,time1,S2Price,time2,S2Price);
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
         ObjectCreate(0,pcode+"S3", OBJ_RECTANGLE,0,time1,S3Price,time2,S3Price);
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
         ObjectCreate(0,pcode+"S4", OBJ_RECTANGLE,0,time1,S4Price,time2,S4Price);
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
         ObjectCreate(0,pcode+"S5", OBJ_RECTANGLE,0,time1,S5Price,time2,S5Price);
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



      if(compraSopra!=0)
        {
         if(ObjectFind(0,pcode+"Buy_Above")<0)
           {
            ObjectCreate(0,pcode+"Buy_Above", OBJ_TEXT,0,time2,compraSopra);
            ObjectSetString(0,pcode+"Buy_Above",OBJPROP_TEXT,pcode+"Buy_Above"+DoubleToString(NormalizeDouble(compraSopra,Digits()),Digits()));
            ObjectSetString(0,pcode+"Buy_Above",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Buy_Above",0,time2,compraSopra);
            ObjectSetString(0,pcode+"Buy_Above",OBJPROP_TEXT,pcode+"Buy_Above  "+DoubleToString(NormalizeDouble(compraSopra,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"Buy_Above",OBJPROP_COLOR,Gold);
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


      if(priceW!=0)
        {
         if(ObjectFind(0,pcode+"PivotWeek")<0)
           {
            ObjectCreate(0,pcode+"PivotWeek", OBJ_TEXT,0,time2,priceW);
            ObjectSetString(0,pcode+"PivotWeek",OBJPROP_TEXT,pcode+"PivotWeek"+DoubleToString(NormalizeDouble(priceW,Digits()),Digits()));
            ObjectSetString(0,pcode+"PivotWeek",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"PivotWeek",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"PivotWeek",0,time2,priceW);
            ObjectSetString(0,pcode+"PivotWeek",OBJPROP_TEXT,pcode+"PivotWeek "+DoubleToString(NormalizeDouble(priceW,Digits()),Digits()));
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


      if(rD3!=0)
        {
         if(ObjectFind(0,pcode+"rD3")<0)
           {
            ObjectCreate(0,pcode+"rD3", OBJ_TEXT,0,time2,rD3);
            ObjectSetString(0,pcode+"rD3",OBJPROP_TEXT,pcode+"rD3"+DoubleToString(NormalizeDouble(rD3,Digits()),Digits()));
            ObjectSetString(0,pcode+"rD3",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"rD3",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"rD3",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"rD3",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"rD3",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"rD3",0,time2,rD3);
            ObjectSetString(0,pcode+"rD3",OBJPROP_TEXT,pcode+"rD3 "+DoubleToString(NormalizeDouble(rD3,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"rD3",OBJPROP_COLOR,clrBlue);
        }
      if(sD3!=0)
        {
         if(ObjectFind(0,pcode+"sD3")<0)
           {
            ObjectCreate(0,pcode+"sD3", OBJ_TEXT,0,time2,sD3);
            ObjectSetString(0,pcode+"sD3",OBJPROP_TEXT,pcode+"sD3"+DoubleToString(NormalizeDouble(sD3,Digits()),Digits()));
            ObjectSetString(0,pcode+"sD3",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"sD3",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"sD3",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"sD3",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"sD3",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"sD3",0,time2,sD3);
            ObjectSetString(0,pcode+"sD3",OBJPROP_TEXT,pcode+"sD3 "+DoubleToString(NormalizeDouble(sD3,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"sD3",OBJPROP_COLOR,clrBlue);
        }


      if(rD2!=0)
        {
         if(ObjectFind(0,pcode+"rD2")<0)
           {
            ObjectCreate(0,pcode+"rD2", OBJ_TEXT,0,time2,rD2);
            ObjectSetString(0,pcode+"rD2",OBJPROP_TEXT,pcode+"rD2"+DoubleToString(NormalizeDouble(rD2,Digits()),Digits()));
            ObjectSetString(0,pcode+"rD2",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"rD2",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"rD2",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"rD2",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"rD2",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"rD2",0,time2,rD2);
            ObjectSetString(0,pcode+"rD2",OBJPROP_TEXT,pcode+"rD2 "+DoubleToString(NormalizeDouble(rD2,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"rD2",OBJPROP_COLOR,clrBlue);
        }

      if(sD2!=0)
        {
         if(ObjectFind(0,pcode+"sD2")<0)
           {
            ObjectCreate(0,pcode+"sD2", OBJ_TEXT,0,time2,sD2);
            ObjectSetString(0,pcode+"sD2",OBJPROP_TEXT,pcode+"sD2"+DoubleToString(NormalizeDouble(sD2,Digits()),Digits()));
            ObjectSetString(0,pcode+"sD2",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"sD2",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"sD2",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"sD2",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"sD2",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"sD2",0,time2,sD2);
            ObjectSetString(0,pcode+"sD2",OBJPROP_TEXT,pcode+"sD2 "+DoubleToString(NormalizeDouble(sD2,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"sD2",OBJPROP_COLOR,clrBlue);
        }

      if(sD1!=0)
        {
         if(ObjectFind(0,pcode+"sD1")<0)
           {
            ObjectCreate(0,pcode+"sD1", OBJ_TEXT,0,time2,sD1);
            ObjectSetString(0,pcode+"sD1",OBJPROP_TEXT,pcode+"sD1"+DoubleToString(NormalizeDouble(sD1,Digits()),Digits()));
            ObjectSetString(0,pcode+"sD1",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"sD1",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"sD1",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"sD1",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"sD1",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"sD1",0,time2,sD1);
            ObjectSetString(0,pcode+"sD1",OBJPROP_TEXT,pcode+"sD1 "+DoubleToString(NormalizeDouble(sD1,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"sD1",OBJPROP_COLOR,clrBlue);
        }

      if(rD1!=0)
        {
         if(ObjectFind(0,pcode+"rD1")<0)
           {
            ObjectCreate(0,pcode+"rD1", OBJ_TEXT,0,time2,rD1);
            ObjectSetString(0,pcode+"rD1",OBJPROP_TEXT,pcode+"rD1"+DoubleToString(NormalizeDouble(rD1,Digits()),Digits()));
            ObjectSetString(0,pcode+"rD1",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"rD1",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"rD1",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"rD1",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"rD1",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"rD1",0,time2,rD1);
            ObjectSetString(0,pcode+"rD1",OBJPROP_TEXT,pcode+"rD1 "+DoubleToString(NormalizeDouble(rD1,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"rD1",OBJPROP_COLOR,clrBlue);
        }


      if(vendiSotto!=0)
        {
         if(ObjectFind(0,pcode+"Sell_Below")<0)
           {
            ObjectCreate(0,pcode+"Sell_Below", OBJ_TEXT,0,time2,vendiSotto);
            ObjectSetString(0,pcode+"Sell_Below",OBJPROP_TEXT,pcode+"Sell_Below"+DoubleToString(NormalizeDouble(vendiSotto,Digits()),Digits()));
            ObjectSetString(0,pcode+"Sell_Below",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_BACK,DrawBackground);
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_SELECTABLE,!DisableSelection);
            ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode+"Sell_Below",0,time2,vendiSotto);
            ObjectSetString(0,pcode+"Sell_Below",OBJPROP_TEXT,pcode+"Sell_Below  "+DoubleToString(NormalizeDouble(vendiSotto,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode+"Sell_Below",OBJPROP_COLOR,clrLawnGreen);
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


   string message=Symbol()+" ("+DoubleToString(price)+"), the price arrived at "+pcode+point;

   return message;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getAlertID(string alertName)
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



   if(ObjectFind(0,pcode+"RD3")>=0)
      ObjectDelete(0,pcode+"RD3");
   if(ObjectFind(0,pcode+"RD2")>=0)
      ObjectDelete(0,pcode+"RD2");
   if(ObjectFind(0,pcode+"RD1")>=0)
      ObjectDelete(0,pcode+"RD1");
   if(ObjectFind(0,pcode+"rD3")>=0)
      ObjectDelete(0,pcode+"rD3");
   if(ObjectFind(0,pcode+"rD2")>=0)
      ObjectDelete(0,pcode+"rD2");
   if(ObjectFind(0,pcode+"rD1")>=0)
      ObjectDelete(0,pcode+"rD1");

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

   if(ObjectFind(0,pcode+"Buy_Above")>=0)
      ObjectDelete(0,pcode+"Buy_Above");


   if(ObjectFind(0,pcode+"Compra Sopra")>=0)
      ObjectDelete(0,pcode+"Compra Sopra");


   if(ObjectFind(0,pcode+"Pivot Line")>=0)
      ObjectDelete(0,pcode+"Pivot Line");
      
   if(ObjectFind(0,pcode+"PivotW")>=0)
      ObjectDelete(0,pcode+"PivotW");
      
   if(ObjectFind(0,pcode+"PivotWeek")>=0)
      ObjectDelete(0,pcode+"PivotWeek");
      
    if(ObjectFind(0,pcode+"PivotDay")>=0)
      ObjectDelete(0,pcode+"PivotDay");  

   if(ObjectFind(0,pcode+"Vendi Sotto")>=0)
      ObjectDelete(0,pcode+"Vendi Sotto");
   if(ObjectFind(0,pcode+"Pivot")>=0)
      ObjectDelete(0,pcode+"Pivot");
   if(ObjectFind(0,pcode+"Sell_Below")>=0)
      ObjectDelete(0,pcode+"Sell_Below");


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

   if(ObjectFind(0,pcode+"SD3")>=0)
      ObjectDelete(0,pcode+"SD3");
   if(ObjectFind(0,pcode+"SD2")>=0)
      ObjectDelete(0,pcode+"SD2");
   if(ObjectFind(0,pcode+"SD1")>=0)
      ObjectDelete(0,pcode+"SD1");

   if(ObjectFind(0,pcode+"sD3")>=0)
      ObjectDelete(0,pcode+"sD3");
   if(ObjectFind(0,pcode+"sD2")>=0)
      ObjectDelete(0,pcode+"sD2");
   if(ObjectFind(0,pcode+"sD1")>=0)
      ObjectDelete(0,pcode+"sD1");

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
double GannObj::convertPrice(double _outputPrice)
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

   buyAbove = (C10!=0) ? C9 : (C8!=0) ? C7 : (D7!=0) ? E7 : (F7!=0) ? G7 : (G8!=0) ? G9 : (G10!=0) ? G11 : (F11!=0) ? E11 : (D11!=0) ? C11 : (B11!=0) ? B9 : (B8!=0) ? B6 : (C6!=0) ? E6 : (F6!=0) ? H6 : (H7!=0) ? H9 : (H10!=0) ? H12 : (G12!=0) ? E12 : (D12!=0) ? B12 : 0;
   buyAbove = buyAbove/div;          //////////////
   sellBelow = (C10!=0) ? D10 : (C8!=0) ? C9 : (D7!=0) ? C7 : (F7!=0) ? E7 : (G8!=0) ? G7 : (G10!=0) ? G9 : (F11!=0) ? G11 : (D11!=0) ? E11 : (B11!=0) ? C11 : (B8!=0) ? B9 : (C6!=0) ? B6 : (F6!=0) ? E6 : (H7!=0) ? H6 : (H10!=0) ? H9 : (G12!=0) ? H12 : (D12!=0) ? E12 : 0;
   sellBelow = sellBelow/div;         ////////////

   if(PeriodoPrecRuota_==0)
     {
      HiLoPrecRoute=High[0]-Low[0];
     }
   if(PeriodoPrecRuota_==1)
     {
      HiLoPrecRoute=HighW[0]-LowW[0];
     }
   if(PeriodoPrecRuota_==2)
     {
      HiLoPrecRoute=HighM[0]-LowM[0];
     }
   if(PeriodoPrecRuota_==3)
     {
      HiLoPrecRoute=HighM[1]-LowM[1];
     }

   if(input_ruota== 0)
     {
      coeff_ruota=HiLoPrecRoute/6*gradi_cicli();
     }

   if(input_ruota== 1)
     {
      buyTarget1 = resistance1 * 0.9995/div;
      buyTarget2 = resistance2 * 0.9995/div;
      buyTarget3 = resistance3 * 0.9995/div;
      buyTarget4 = resistance4 * 0.9995/div;
      buyTarget5 = resistance5 * 0.9995/div;

      sellTarget1 = support1 * 1.0005/div;
      sellTarget2 = support2 * 1.0005/div;
      sellTarget3 = support3 * 1.0005/div;
      sellTarget4 = support4 * 1.0005/div;
      sellTarget5 = support5 * 1.0005/div;
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

   if(PivotDaily==2)

     {
      rD1=resistance1;
      sD1=support1;
      rD2=resistance2;
      sD2=support2;
      rD3=resistance3;
      sD3=support3;
     }

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
//|                    superamento_Livello                           |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                         Controllo Buy                            |
//+------------------------------------------------------------------+

void superamento_Livello()

  {
   if(IsMarketTradeOpen() && SpreadMax() && !ManualStopNewsOrders())
     {
      enableTrading=true;
     }
   else
     {
      enableTrading=false;
     }
//enableTrading=IsMarketTradeOpen() && (Spread(Symbol())<MaxSpread);//TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

   if((!OrdiniSuStessaCandela && !OrdiniSuStessaCandela(sniperString, arrInput, valoriArr)))
     {
      enableNewsOrdes = false;
      return;
     }
   if((GridHedge!=0 && PositionsTotalBuy(Symbol(),magic_number)<1) || GridHedge==0)
     {
      double calcTP = 0;

        {

         timeTrading=InTradingTime(InpStartHour,InpStartMinute,InpEndHour,InpEndMinute,Fuso,FusoEnable) || InTradingTime(InpStartHour1,InpStartMinute1,InpEndHour1,InpEndMinute1,Fuso,FusoEnable);
         if(NumPosiz(sniperString, arrInput, valoriArr) <  N_Max_pos)
           {
            enableNewsOrdes = true;
           }
         if(NumPosiz(sniperString, arrInput, valoriArr) <  N_Max_pos || GridHedge!=0)
            enableNewsOrdes = true;
         if((GridHedge==0 && NumPosiz(sniperString, arrInput, valoriArr) >= N_Max_pos) || !timeTrading || !EnableOrdersByGrid("Buy",magic_number) || (bool)TicketPrimoOrdineBuy(magic_number))

           {
            enableNewsOrdes = false;
            //order_ok = false;
            //preordine_sell = false;
            //preordine = false;
            return;
           }

         if((Type_Orders_== 0 || Type_Orders_ == 1) && enableNewsOrdes && timeTrading && enableTrading == true && TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && nuovoGiorno == false && ApriOrdineDalLiv <= levelByLevel &&
            ApreNuoviOrdiniFinoAlLivello >= levelByLevel && Numero_Ordini_aperti < N_max_orders && !GridBuyActive  && GestioneMABuy() && GestioneTEMABuy() && GestioneATR() && FiltroPivotDay("Buy"))
           {
            if(((priceW <= c1) && Filtro_Pivot_Weekly == true) || (Filtro_Pivot_Weekly == false))
              {
               if(N_CandleConsecutive > 1 && preordine_buy == true)
                 {
                  cand_consecutive("Buy");  //return; dopo cand_consecutive
                 }

               if(preordine_buy == false)
                 {
                  superamento_Livello_Buy =(char) sup_liv_buy(prezzoPivot, o1, c1, compraSopra, primoLevBuy, secondoLevBuy, terzoLevBuy, quartoLevBuy, quintoLevBuy, false, PercLivPerOpenPos);
                 }
               if(superamento_Livello_Buy != 0)
                 {
                  if((Repet_orders_stesso_level == false) && (Orders_LivellieNumero [superamento_Livello_Buy] > 0))
                    {
                     preordine_buy = false;   /// confronto livello ordine per ripetere o no ordini sullo stesso livello
                     preordine = false;
                     return;
                    }

                  if((N_CandleConsecutive > 1 && order_ok == false) && preordine_buy == false)
                    {
                     ////////////////********** filtro apri ordini tra.....
                     if(fasciaDiPrezzo(c1, false) < ApriOrdineDalLiv || fasciaDiPrezzo(c1, false) > ApreNuoviOrdiniFinoAlLivello)
                       {
                        order_ok = false;
                        preordine = false;
                        preordine_buy = false;
                        return;
                       }
                     lev_start = fasciaDiPrezzo(iClose(Symbol(),PERIOD_CURRENT,1), true);
                     preordine_buy = true;
                     start__ = Bars(Symbol(),PERIOD_CURRENT);
                     return;
                    }

                  if(N_CandleConsecutive == 1 || (N_CandleConsecutive > 1 && order_ok) == true)
                    {
                     if(!filtroRSI(arrParamInd, "Buy"))
                       {
                        enableNewsOrdes = false;
                        order_ok = false;
                        preordine_buy = false;
                        preordine = false;
                        return;
                       }

                     if(!EnablePosSuStessiLiv(sniperString, arrInput, valoriArr) || !AbovePercNoOrder("Buy")) //  ||(Ask(Symbol()) < valorePercLevByLev_(Ask(Symbol()), true, sniperString, arrInput, valoriArr))

                       {
                        enableNewsOrdes = false;
                        order_ok = false;
                        preordine_buy = false;
                        preordine = false;
                        return;
                       }

                       {
                        if(valorePercLevByLev_(Ask(Symbol()), true, sniperString, arrInput, valoriArr)> 0)

                           old_superamento_livello_Buy = superamento_Livello_Buy;

                        segno_ordine = "Buy";
                        int Spread=(int)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);

                        if(calcoloTakeProfit() == 0)
                          {
                           calcTP = 0;
                          }
                        if(calcoloTakeProfit() > 0)
                          {
                           calcTP = calcoloTakeProfit() - Point()*Spread;
                          }
                        //distanzaSL = NormalizeDouble((calcolatore_SL()-Bid(Symbol()))/Point(),Digits());
                        distanzaSL = NormalizeDouble((Ask(Symbol())-calcolatore_SL())/Point(),Digits());
                        double TakeProfBuy=calcTP;

                        if(GridHedge!=0)
                          {
                           StopLossBuy=0.0;
                          }
                        if(GridHedge==0)
                          {
                           StopLossBuy=calcolatore_SL()-Point()*Spread;
                          }
                        ulong ticket = TicketHedgeBuy[0] = SendPosition(Symbol(),ORDER_TYPE_BUY, myLotSize(),0,Deviazione, StopLossBuy,TakeProfBuy,Commen,magic_number);//////////////   Inserimento ordine buy
                        //TicketHedgeBuy[0]= ticket;
                        order_ok = false;
                        preordine_buy = false;
                        preordine = false;
                        segno_ordine = "";

                        if(ticket > 0)
                          {
                           Numero_Ordini_aperti = Numero_Ordini_aperti+1;
                           Orders_LivellieNumero[superamento_Livello_Buy] = Orders_LivellieNumero[superamento_Livello_Buy]+1;
                           Orders_LivellieNumero[0]=Orders_LivellieNumero[0]+1;

                           string now= (string)TimeCurrent();
                           Orders_Prezzi_Ordini[superamento_Livello_Buy]= c1;
                           segno_ordine = "Buy";
                          }
                        order_ok = false;
                        preordine_buy = false;
                        preordine = false;
                        segno_ordine = "";
                       }
                    }
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                         Controllo Sell                           |
//+------------------------------------------------------------------+

   timeTrading=InTradingTime(InpStartHour,InpStartMinute,InpEndHour,InpEndMinute,Fuso,FusoEnable) || InTradingTime(InpStartHour1,InpStartMinute1,InpEndHour1,InpEndMinute1,Fuso,FusoEnable);

   if(NumPosiz(sniperString, arrInput, valoriArr) <  N_Max_pos || GridHedge!=0)
     {
      enableNewsOrdes = true;
     }

   if((GridHedge==0 && NumPosiz(sniperString, arrInput, valoriArr) >= N_Max_pos) || !timeTrading || !EnableOrdersByGrid("Sell",magic_number) || (bool)TicketPrimoOrdineSell(magic_number))
     {
      enableNewsOrdes = false;
      //order_ok = false;
      //preordine_sell = false;
      //preordine = false;
      return;
     }
   if((GridHedge!=0 && PositionsTotalSell(Symbol(),magic_number)<1) || GridHedge==0)
     {
      if((Type_Orders_== 0 || Type_Orders_ == 2) && enableNewsOrdes && timeTrading && enableTrading == true && TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && nuovoGiorno == false && ApriOrdineDalLiv <= levelByLevel &&
         ApreNuoviOrdiniFinoAlLivello >= levelByLevel && Numero_Ordini_aperti < N_max_orders && !GridSellActive && GestioneMASell() && GestioneTEMASell() && GestioneATR() && FiltroPivotDay("Sell"))
        {
         if((priceW >= c1 && Filtro_Pivot_Weekly == true) || (Filtro_Pivot_Weekly == false))
           {
            if(N_CandleConsecutive > 1 && preordine_sell == true)
              {
               cand_consecutive("Sell");
              }
            if(preordine_sell == false)
              {
               superamento_Livello_Sell = (char)sup_liv_sell(prezzoPivot, o1, c1, vendiSotto, primoLevSell, secondoLevSell, terzoLevSell,quartoLevSell, quintoLevSell, false, PercLivPerOpenPos);
              }
            if(superamento_Livello_Sell != 0)
              {
               if(Repet_orders_stesso_level == false && (Orders_LivellieNumero [superamento_Livello_Sell+7] > 0))
                 {
                  preordine_sell = false;   /// confronto livello ordine per ripetere o no ordini sullo stesso livello
                  preordine = false;
                  return;
                 }
               if(fasciaDiPrezzo(c1, false) < ApriOrdineDalLiv || fasciaDiPrezzo(c1, false) > ApreNuoviOrdiniFinoAlLivello)
                 {
                  order_ok = false;
                  preordine = false;
                  preordine_sell = false;
                  return;
                 }

               if((N_CandleConsecutive > 1 && order_ok == false) && preordine_sell == false)
                 {
                  lev_start = fasciaDiPrezzo(iClose(Symbol(),PERIOD_CURRENT,1), true);
                  preordine_sell = true;
                  start__ = Bars(Symbol(),PERIOD_CURRENT);
                  return;
                 }
               if(N_CandleConsecutive == 1 || (N_CandleConsecutive > 1 && order_ok) == true)
                 {

                  if((!filtroRSI(arrParamInd, "Sell")))
                    {
                     enableNewsOrdes = false;
                     order_ok = false;
                     preordine_sell = false;
                     preordine = false;
                     return;
                    }

                  if(!EnablePosSuStessiLiv(sniperString, arrInput, valoriArr) || !AbovePercNoOrder("Sell"))

                    {
                     enableNewsOrdes = false;
                     order_ok = false;
                     preordine_buy = false;
                     preordine = false;
                     return;
                    }

                    {
                     if(valorePercLevByLev_(Bid(Symbol()), true, sniperString, arrInput, valoriArr)> 0)

                        old_superamento_livello_Sell = superamento_Livello_Sell;

                     segno_ordine = "Sell";

                     int Spread=(int)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);

                     double calcTP = 0;
                     if(calcoloTakeProfit() == 0)
                       {
                        calcTP = 0;
                       }
                     if(calcoloTakeProfit() > 0)
                       {
                        calcTP = calcoloTakeProfit() + Point()*Spread;
                       }

                     distanzaSL = NormalizeDouble((calcolatore_SL()-Bid(Symbol()))/Point(),Digits());

                     double TakeProfSell=calcTP;

                     if(GridHedge!=0)
                       {
                        StopLossSell=0.0;
                       }
                     if(GridHedge==0)
                       {
                        StopLossSell=calcolatore_SL()+Point()*Spread;
                       }
                     ulong ticket = TicketHedgeSell[0] = SendPosition(Symbol(),ORDER_TYPE_SELL,myLotSize(),0,Deviazione, StopLossSell, TakeProfSell,Commen,magic_number);////// Inserimento ordine sell
                     //TicketHedgeSell[0]=ticket;
                     order_ok = false;
                     preordine_sell = false;
                     preordine = false;
                     segno_ordine = "";

                     if(ticket>0)
                       {
                        Numero_Ordini_aperti = Numero_Ordini_aperti+1;
                        Orders_LivellieNumero[superamento_Livello_Sell+7]=Orders_LivellieNumero[superamento_Livello_Sell+7]+1;
                        Orders_LivellieNumero[0]=Orders_LivellieNumero[0]+1;
                        Orders_Prezzi_Ordini[superamento_Livello_Sell]= c1;
                       }
                     order_ok = false;
                     preordine_sell = false;
                     preordine = false;
                     segno_ordine = "";

                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                       Input e variabili export                   |
//+------------------------------------------------------------------+
void inputVar(char Ts_Be,char n)
  {
   char Ts_Be_=Ts_Be;
  }

//+------------------------------------------------------------------+
//|                         Take Profit da calcolare                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calcoloTakeProfit()
  {
//if(TpSlInProfit==1 && Stop_Loss in profitto)return 0.0;
   if(TakeProfit == 0)
      return 0.0; //No Take profit
   if(TakeProfit == 1)
      return TakeProfPips();  //Tahe profit Points
   if(TakeProfit == 2)
      return Tp_Soglia(); //TakeNLivSucc (true, 0);

   else
     {
      Alert("Impostazione Modalità Take Profit Errata!");
      return 0;
     };
  }

//+------------------------------------------------------------------+
//|                       TakeProfPips()                             |
//+------------------------------------------------------------------+
double TakeProfPips()
  {
   char a = 0;
   if(segno_ordine == "Buy")
      a = 1;
   if(segno_ordine == "Sell")
      a = -1;
//Print((c1 + (a * Point()*TpPips)));
   return ((c1 + (a * Point()*TpPips)));
  }

//+------------------------------------------------------------------+
//|                          Tp_Soglia()                             |
//+------------------------------------------------------------------+
double Tp_Soglia()
  {
   double a = 0;
   if(TpSoglia_ == 0)
      a = TakeNLivSucc(true, Tp_Next);
   if(TpSoglia_ == 1)
      a = TpAzioneSoglia_();
   return a;
  }

//+------------------------------------------------------------------+
//|                      TpAzioneSoglia_()                           |
//+------------------------------------------------------------------+
double TpAzioneSoglia_()
  {

   char   a = (fasciaDiPrezzo(c1, true));// "a" fascia di prezzo della candela chiusa
   double b = 0;
   double c = (secondoLevBuy - primoLevBuy) * 0.01 * SogliaPercLivello;  // soglia percentuale fra livelli
   double d = 0;
   switch(a)
     {
      case   2:
         b= c + compraSopra;
         break;    //uguale distanza
      case   3:
         b= c + primoLevBuy;
         break;    //uguale distanza
      case   4:
         b= c + secondoLevBuy;
         break;    //uguale distanza
      case   5:
         b= c + terzoLevBuy;
         break;    //uguale distanza
      case   6:
         b= c + quartoLevBuy;
         break;    //uguale distanza
      case   7:
         b= c + quintoLevBuy;
         break;    //uguale distanza
      case  -2:
         b= vendiSotto - c;
         break;    //uguale distanza
      case  -3:
         b= primoLevSell - c;
         break;    //uguale distanza
      case  -4:
         b= secondoLevSell - c;
         break;    //uguale distanza
      case  -5:
         b= terzoLevSell - c;
         break;    //uguale distanza
      case  -6:
         b= quartoLevSell - c ;
         break;    //uguale distanza
      case  -7:
         b= quintoLevSell - c;
         break;    //uguale distanza
      default:
         Alert("Calcolo TpAzioneSoglia Errato");
     }

   if((segno_ordine == "Buy" && c1 > b) || (segno_ordine == "Sell" && c1 < b))
     {
      if(TPAzioneSoglia == 0)
         d = 0;//TakeNLivSucc(true, Tp_Next);
      if(TPAzioneSoglia == 1)
         d = TakeNLivSucc(true, 1);
      if(TPAzioneSoglia == 2)
         d = TakeNLivSucc(true, 2);
      if(TPAzioneSoglia == 3)
         d = TakeNLivSucc(true, 3);
     }
   if((segno_ordine == "Buy" && c1 < b) || (segno_ordine == "Sell" && c1 > b))
     {
      d = TakeNLivSucc(true, Tp_Next);
     }
   return d;
  }
/*
enum TpAzioneSoglia                    //With Tp Threshold enabled, choose the action. Priority on "Take Profit to the Next Level".
{
NoTp                           = 0, //Does not enter the Take Profit
TpDueLivSopra                  = 1, //Take Profit to the Next Level
TpTreLivSopra                  = 2, //Take Profit to the next second level
TpQuattroLivSopra              = 3, //Take Profit to the next third level
};
*/
//------------------------- TakePrLivSucc () -------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TakeNLivSucc(bool d, char e)
  {
   if(d == false)
      return 0.0;
   char a = 0;
   int h = 0;
   if(e == 0)
     {
      return 0.0;
     }
//h = Tp_Next;
   if(e > 0)
      h = e;

   if(d == true)
      if(segno_ordine == "Buy")
         a = 1;
   if(segno_ordine == "Sell")
      a = -1;

   int b = (fasciaDiPrezzo(c1, true) + (h * a));
   double c = 0;
   double g = (quintoLevBuy - quartoLevBuy) * 0.01 * (100 - TpPercAlLivello);

   switch(b)
     {
      case  3:
         c= primoLevBuy   - g;
         break;
      case  4:
         c= secondoLevBuy - g;
         break;
      case  5:
         c= terzoLevBuy   - g;
         break;
      case  6:
         c= quartoLevBuy  - g;
         break;
      case  7:
         c= quintoLevBuy  - g;
         break;
      case  8:
         c= quintoLevBuy  - g  + (quintoLevBuy - quartoLevBuy);
         break;
      case  9:
         c= quintoLevBuy  - g  + ((quintoLevBuy - quartoLevBuy)*2);
         break;
      case  11:
         c= quintoLevBuy -  g  + ((quintoLevBuy - quartoLevBuy)*3);
         break;
      case  12:
         c= quintoLevBuy -  g  + ((quintoLevBuy - quartoLevBuy)*4);
         break;
      case  13:
         c= quintoLevBuy -  g  + ((quintoLevBuy - quartoLevBuy)*5);
         break;
      case  14:
         c= quintoLevBuy -  g  + ((quintoLevBuy - quartoLevBuy)*6);
         break;


      case -3:
         c= primoLevSell  + g ;
         break;
      case -4:
         c= secondoLevSell+ g ;
         break;
      case -5:
         c= terzoLevSell  + g ;
         break;
      case -6:
         c= quartoLevSell + g ;
         break;
      case -7:
         c= quintoLevSell + g ;
         break;
      case -8:
         c= quintoLevSell + g  - (quartoLevSell - quintoLevSell);
         break;
      case -9:
         c= quintoLevSell + g  - ((quartoLevSell - quintoLevSell)*2);
         break;
      case -10:
         c= quintoLevSell + g  - ((quartoLevSell - quintoLevSell)*3);
         break;
      case -11:
         c= quintoLevSell + g  - ((quartoLevSell - quintoLevSell)*4);
         break;
      case -12:
         c= quintoLevSell + g  - ((quartoLevSell - quintoLevSell)*5);
         break;
      case -13:
         c= quintoLevSell + g  - ((quartoLevSell - quintoLevSell)*6);
         break;
      case -14:
         c= quintoLevSell + g  - ((quartoLevSell - quintoLevSell)*7);
         break;

         //default: Alert ("Calcolo Take Profit a Livello successivo Errato");
     }
   return (NormalizeDouble(c,Digits()));
  }

//+------------------------------------------------------------------+
//|                     profitHedging()                              |
//+------------------------------------------------------------------+
double profitHedging()
  {
   if(GridHedge!=0)

      return 0.0;
   else
      return 0.0;

  }



//+------------------------------------------------------------------+
//|                 Controllo candele consecutive                    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void cand_consecutive(string a)   // buy o sell , n° candela di start__ , livello candela di start__
  {
   char level_signal;
   static char level_signal_old;
   level_signal_old = lev_start;
   int c = Bars(Symbol(),PERIOD_CURRENT);    // Numero candele grafico in tempo reale
   order_ok = false;

   if((N_CandleConsecutive > 1) && (c > start__))
     {

      int b = c - start__;

      for(int i = 0; i < b; i++)
        {
         level_signal = fasciaDiPrezzo(iClose(Symbol(),PERIOD_CURRENT,i + 1), true);

         if(level_signal_old != level_signal)
           {
            preordine = false;
            preordine_buy = false;
            preordine_sell = false;
            a = "False";
            return;
           }
         if(level_signal_old == level_signal)

           {
            if(a == "Buy")
              {
               preordine_buy = true;
              }
            if(a == "Sell")
              {
               preordine_sell = true;  ////////////////////////// controllare grafa chiusa
              }
            if(((preordine_buy || preordine_sell) == true) && i + 1>= N_CandleConsecutive - 1)
              {
               if(a == "Buy")
                 {
                  order_ok = true;

                 }
               if(a == "Sell")
                 {
                  order_ok = true;

                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                       reset_array                                |
//+------------------------------------------------------------------+
void reset_array()
  {
   preordine = 0;
   preordine_buy = 0;
   preordine_sell = 0;
   Numero_Ordini_aperti = 0;
   for(int a=0; a<ArraySize(Orders_LivellieNumero); a++)
     {

      Orders_LivellieNumero[a] = 0;
     }
  }

//+------------------------------------------------------------------+
//|                    reset_Orders_Prezzi_Ordini                    |
//+------------------------------------------------------------------+
void reset_Orders_Prezzi_Ordini()                                    //////////// Reset array conta ordini
  {
   for(int a=0; a<ArraySize(Orders_Prezzi_Ordini); a++)
     {

      Orders_Prezzi_Ordini[a] = 0;
     }
  }
//+------------------------------------------------------------------+
//|                         nuovaSessione                            |Day()
//+------------------------------------------------------------------+
void nuovaSessione(double aper,double chius)
  {
   if(aper != openIeri || chius != closeIeri)
     {
      nuovoGiorno=true;
      openIeri= aper;
      closeIeri= chius;
      reset_array();
      reset_Orders_Prezzi_Ordini();
      Div_();

     }
   else
      nuovoGiorno=false;
  }

//+------------------------------------------------------------------+
//|                        leggoArray                                |
//+------------------------------------------------------------------+
bool leggoArray(char a)
  {

   for(int i=0; i<ArraySize(Orders_LivellieNumero); i++)
     {
      if(Orders_LivellieNumero [i] == a)
         return true;
      Print("Orders_LivellieNumero [",i,"]: ",Orders_LivellieNumero[i]);
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                       leggoArrayPrezzi                           |
//+------------------------------------------------------------------+
void leggoArrayPrezzi()
  {

   for(int i=0; i<ArraySize(Orders_Prezzi_Ordini); i++)
      if(Orders_Prezzi_Ordini [i] != 0)
         Print("Orders_Prezzi_Ordini [",i,"]: ",Orders_Prezzi_Ordini[i]);
  }

//+------------------------------------------------------------------+
//|                     Divisione Input Gann                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Div_()
  {
   switch(Divis)
     {
      case -4 :
         div=0.0001;
         break;
      case -3 :
         div= 0.001;
         break;
      case -2 :
         div=  0.01;
         break;
      case -1 :
         div=   0.1;
         break;
      case  0 :
         div=     1;
         break;
      case  1 :
         div=    10;
         break;
      case  2 :
         div=   100;
         break;
      case  3 :
         div=  1000;
         break;
      case  4 :
         div= 10000;
         break;
      case  5 :
         div=100000;
         break;
      default :
         Alert("Divisione Input Gann ERRATA!");
     }
  }

//+------------------------------------------------------------------+
//|                      Fascia di prezzo                            |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
char fasciaDiPrezzo(double c, bool algebrico)
  {
   char l_by_l;
   char z = 1;
   if(algebrico == false)
      (z = 1);
   if(algebrico == true)
      (z = -1);
   if(c>quintoLevBuy)
     {
      return l_by_l = 7;
     }
   if(c>R4Price && c< quintoLevBuy)
     {
      return l_by_l = 6;
     }
   if(c>R3Price && c< quartoLevBuy)
     {
      return l_by_l = 5;
     }
   if(c>R2Price && c< terzoLevBuy)
     {
      return l_by_l = 4;
     }
   if(c>R1Price && c< secondoLevBuy)
     {
      return l_by_l = 3;
     }
   if(c>=compraSopra && c< primoLevBuy)
     {
      return l_by_l = 2;
     }
   if(c>=prezzoPivot && c< compraSopra)
     {
      return l_by_l = 1;
     }

   if(c<quintoLevSell)
     {
      return l_by_l = 7 * z;
     }
   if(c<S4Price && c> quintoLevSell)
     {
      return l_by_l = 6 * z;
     }
   if(c<S3Price && c> quartoLevSell)
     {
      return l_by_l = 5 * z;
     }
   if(c<S2Price && c> terzoLevSell)
     {
      return l_by_l = 4 * z;
     }
   if(c<S1Price && c> secondoLevSell)
     {
      return l_by_l = 3 * z;
     }
   if(c<vendiSotto && c> primoLevSell)
     {
      return l_by_l = 2 * z;
     }
   if(c<prezzoPivot && c> vendiSotto)
     {
      return l_by_l = 1 * z;
     }
   else
     {
      return l_by_l = 0;
     }
   return l_by_l;

  }
//+------------------------------------------------------------------+
//|                   Gradi di ciclo x Ruota 24                      |
//+------------------------------------------------------------------+
double gradi_cicli()
  {
   switch(gradi_Ciclo)
     {
      case 0 :
         gra_clcl= 1     ;
         break;
      case 1 :
         gra_clcl= 0.75  ;
         break;
      case 2 :
         gra_clcl= 0.5   ;
         break;
      case 3 :
         gra_clcl= 0.25  ;
         break;
      case 4 :
         gra_clcl= 0.125 ;
         break;
      case 5 :
         gra_clcl= 0.3333;
         break;
      default:
         Alert("Gradi Ciclo selezione ERRATA!");

     }
   return gra_clcl;
  }

//+------------------------------------------------------------------+
//|                         Stop Loss da calcolare                   |
//+------------------------------------------------------------------+
double calcolatore_SL()
  {
     {
      return switchStopLoss();  //return NormalizeDouble(switchStopLoss(),Digits());


     }
  }
//------------------------ switch enum Stop Loss --------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double switchStopLoss()
  {
   double switchStopLoss_ = 0;
   switch(Stop_Loss)
     {
      case 0:
         switchStopLoss_=calcoloSL_Pips()                 ;
         break;
      case 1:
         switchStopLoss_=calcoloSl_Perc_Al_Livello_Prima();
         break;


      default:
         Alert("Selezione Stop_Loss errata");
     }
   return NormalizeDouble(switchStopLoss_,Digits());   //return switchStopLoss_;
  }


//------------------------ SL Pips -----------------------------
double calcoloSL_Pips()                // Sl_n_pips     Prezzo_Stop_Loss;
  {
   char a = 0;
   double b = 0;
   if(Sl_n_pips != 0)
     {
      if(segno_ordine == "Buy")
        {
         a = -1;
         b = PositionAsk();

        }
      if(segno_ordine == "Sell")
        {
         a = 1;
         b = PositionBid();

        }

      SL_Pips_calcolato = b + ((Point()*Sl_n_pips)*a);

     }
   else
     {
      Print("selezione Stop Loss in Pips errato: impostato a Zero");
     }

   return NormalizeDouble(SL_Pips_calcolato,Digits());     //   SL_Pips_calcolato;
  }


//------------------- calcolo SL_N_Livello_Prima -------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calcoloSL_N_Livello_Prima(char shift)
  {
   double Sl_N_Livelli_Prima_calcolato_ = 0;
   if(Sl_n_livelli_prima >=0 || Sl_n_livelli_prima <5)
     {
      char a = 0;
      double b = 0;
      if(segno_ordine == "Buy")
        {
         a = -1;
         b = PositionAsk();
         shift = shift * -1;
        }
      if(segno_ordine == "Sell")
        {
         a = 1;
         b = PositionBid();
         shift = shift * 1;
        }
      char livello_sl = (fasciaDiPrezzo(c1, true) + ((char)Sl_n_livelli_prima + shift) * a);  // sostituire c1 con il prezzo di apertura posizione

      if(segno_ordine == "Buy")
        {
         switch(livello_sl)
           {
            case  0:
               Sl_N_Livelli_Prima_calcolato_= primoLevSell;
               break;
            case  1:
               Sl_N_Livelli_Prima_calcolato_= vendiSotto;
               break;
            case  2:
               Sl_N_Livelli_Prima_calcolato_= compraSopra;
               break;
            case  3:
               Sl_N_Livelli_Prima_calcolato_= primoLevBuy;
               break;
            case  4:
               Sl_N_Livelli_Prima_calcolato_= secondoLevBuy;
               break;
            case  5:
               Sl_N_Livelli_Prima_calcolato_= terzoLevBuy;
               break;
            case  6:
               Sl_N_Livelli_Prima_calcolato_= quartoLevBuy;
               break;
            case  7:
               Sl_N_Livelli_Prima_calcolato_= quintoLevBuy;
               break;
            case -1:
               Sl_N_Livelli_Prima_calcolato_= secondoLevSell;
               break;
            case -2:
               Sl_N_Livelli_Prima_calcolato_= terzoLevSell;
               break;
               //default: Alert ("Selezione Sl_n_livelli_prima errata");
           }
        }
      if(segno_ordine == "Sell")
        {
         switch(livello_sl)
           {
            case  0:
               Sl_N_Livelli_Prima_calcolato_= primoLevBuy;
               break;
            case -1:
               Sl_N_Livelli_Prima_calcolato_= compraSopra;
               break;
            case -2:
               Sl_N_Livelli_Prima_calcolato_= vendiSotto;
               break;
            case -3:
               Sl_N_Livelli_Prima_calcolato_= primoLevSell;
               break;
            case -4:
               Sl_N_Livelli_Prima_calcolato_= secondoLevSell;
               break;
            case -5:
               Sl_N_Livelli_Prima_calcolato_= terzoLevSell;
               break;
            case -6:
               Sl_N_Livelli_Prima_calcolato_= quartoLevSell;
               break;
            case -7:
               Sl_N_Livelli_Prima_calcolato_= quintoLevSell;
               break;
            case  1:
               Sl_N_Livelli_Prima_calcolato_= secondoLevBuy;
               break;
            case  2:
               Sl_N_Livelli_Prima_calcolato_= terzoLevBuy;
               break;
               //default: Alert ("Selezione Sl_n_livelli_prima errata");
           }
        }
     }
   return NormalizeDouble(Sl_N_Livelli_Prima_calcolato_,Digits());  //Sl_N_Livelli_Prima_calcolato_;    //
  }

//--------------------- calcolo Sl_Perc_Al_Livello_Prima ---------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calcoloSl_Perc_Al_Livello_Prima()
  {
   char a = 0;
   char b = 0;
   double Sl_Perc_Al_Livello_Prima_calcolato_ = 0 ;
   if(segno_ordine == "Buy")
     {
      a = -1;
      b = 1;
     }
   if(segno_ordine == "Sell")
     {
      a = 1;
      b = -1;
     }

   if(segno_ordine == "Buy")
      Sl_Perc_Al_Livello_Prima_calcolato_ = (((calcoloSL_N_Livello_Prima(1) - (calcoloSL_N_Livello_Prima(0)))*0.01) * (100 - Sl_Perc_Al_Livello_Prima)) + (calcoloSL_N_Livello_Prima(0)) ;

   if(segno_ordine == "Sell")
      Sl_Perc_Al_Livello_Prima_calcolato_ = (((calcoloSL_N_Livello_Prima(0) - calcoloSL_N_Livello_Prima(-1))*0.01)* (Sl_Perc_Al_Livello_Prima)) + (calcoloSL_N_Livello_Prima(-1)) ;

   return NormalizeDouble(Sl_Perc_Al_Livello_Prima_calcolato_,Digits());  //Sl_Perc_Al_Livello_Prima_calcolato_;
  }


//---------------------------------------------------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int datiInput(int &arrInput_[], char num)
  {
   return arrInput_ [num];
  }



//+------------------------------------------------------------------+
void algoritmoPreciso()
  {
   Print("\n");

   Print("SymbolTickValue: "+  DoubleString(SymbolTickValue(),10));

   Print("SymbolInfoString(SYMBOL_CURRENCY_MARGIN): "+ SymbolCurrencyMargin());
   Print("SymbolInfoString(SYMBOL_CURRENCY_PROFIT): "+ SymbolCurrencyProfit());
   Print("SymbolInfoString(SYMBOL_CURRENCY_BASE): "+    SymbolCurrencyBase());

//---
   Print("SymbolInfoInteger(SYMBOL_TRADE_CALC_MODE): "+ IntegerToString(SymbolTradeCalcMode())+" ("+EnumToString(SymbolTradeCalcMode())+")");

   Print("SymbolTickValueReal: "+DoubleString(SymbolTickValueReal(),10));

//printSymbolsList();

   double lotsToUse = myLotSize();
   Print("I miei lotti da usare al prossimo trade sono: "+DoubleString(lotsToUse));

   Print("Rischio per trade di "+DoubleString(lotsToUse)+" lotti: "+DoubleString(calcoloRischio(lotsToUse,(int)calcolatore_SL(),commissioni,Symbol()))+" "+currencySymbolAccount());
   Print("Lotti su un rischio di "+DoubleString(riskDenaroEA)+" "+currencySymbolAccount()+": "+DoubleString(calcoloLottiDaRischio(riskDenaroEA,(int)calcolatore_SL(),commissioni,Symbol())));
  }


//+------------------------------------------------------------------+
//| Funzioni per il calcolo dei lotti da applicare nelle strategie   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double myLotSize()
  {
   return myLotSize(compounding,AccountEquity(),capitaleBasePerCompounding,lotsEA,riskEA,riskDenaroEA,(int)distanzaSL,commissioni);
  }

// #### License Management ####

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool InitialLicenseControl()
  {

   if(checkTime())
     {
      checkTimeRimozione();
      return false;
     }

   commentTrialExpired = true;
   commentLicenseExpired = true;

   controlloAggiornamenti = controlloLicenza = TimeCurrent();
   controlloLicenzaDay = DayOfWeek()+1;
   if(DayOfWeek() == 5 || DayOfWeek() == 6 || DayOfWeek() == 0)
      controlloLicenzaDay = 1;

   if(IsTesting())
     {
      onlyBacktest = true;
      StringAdd(nameText,"\nTesting mode!");
     }
   else
     {
      if(onlyBacktest)
        {
         StringAdd(nameText," \nOnly Backtest mode! EA "+EAname+" removed.");
         nameTextCopy = nameText;
         Print(nameText);
         ExpertRemove();
         return false;
        }
     }

   infoAccount();
   if(onlyBacktest)
      ultraLock = true;

   if(!ultraLock)
     {
      StringAdd(nameText," \nContact cbalgotrade@gmail.com for info. Thanks!");
      nameTextCopy = nameText;
      Print(nameText);
      ExpertRemove();
      return false;
     }
   else
     {
      if(copyRight && !onlyBacktest && Trial)
         StringAdd(nameText,"\nTrial mode! Expiration: "+TimeToString(dateTrial));
      if(copyRight && !onlyBacktest && License)
        {
         if(dateLicense >= D'3000.01.01 00:00:00')
            StringAdd(nameText,"\nLIFETIME License activated!");
         else
           {
            if(TimeCurrent() > dateLicense)
              {
               StringAdd(nameText,"\nLicense expired on "+TimeToString(dateLicense)+". \nContact cbalgotrade@gmail.com for info. Thanks!");
              }
            else
               StringAdd(nameText,"\nLicense activated! Expiration: "+TimeToString(dateLicense));
           }
        }
      if(onlyBacktest)
         StringAdd(nameText,"\nBacktest mode!");
      if(!copyRight)
         StringAdd(nameText,"\nCopyRight released!");
     }

   if(!IsTesting() && checkVersion())
     {
      StringAdd(nameText," \nNew Version!\nDownload it from "+cbalgotrade_url+"profilo/");
     }

   nameTextCopy = nameText;
   Print(nameText,false);

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void infoAccount()
  {

   if(!copyRight)
     {
      ultraLock = true;
      return;
     }

   for(int Ccount=0; Ccount<1000; Ccount++)
     {
      if(StringCompare(ClientsAccountName[Ccount],AccountName(),false) == 0)
        {
         StringAdd(nameText,"\nAccount by name locked! OK! ");
         ultraLock = true;
         dateOnlyBacktest = dateLicense = D'3000.01.01 00:00:00';
         return;
        }
     }

   for(int Ccount=0; Ccount<10000; Ccount++)
     {
      if(ClientsAccountNumber[Ccount] == AccountNumber())
        {
         StringAdd(nameText,"\nAccount by number locked! OK! ");
         ultraLock = true;
         dateOnlyBacktest = dateLicense = D'3000.01.01 00:00:00';
         return;
        }
     }

   if(!IsConnected())
     {
      StringAdd(nameText,"\nNo connection, impossible to check license! ");
      ultraLock = false;
      return;
     }

   if(licenseResearch())
     {
      StringAdd(nameText,"\nAccount by license locked! OK! ");
      ultraLock = true;
      dateOnlyBacktest = dateLicense;
     }
   else
     {
      StringAdd(nameText,"\nLicense not found! ");
      ultraLock = false;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkTimeRimozione()
  {
   StringAdd(nameText," \nFatal Error in Time. Contact cbalgotrade@gmail.com for info. Thanks!");
   nameTextCopy = nameText;
   Print(nameText,false);
   ExpertRemove();////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkTime()
  {

   datetime scartoTempo = MathAbs(TimeCurrent() - TimeGMT());
   if(scartoTempo > 172800)
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkVersion()
  {

   ResetLastError();

   char post[],result[];
   string headers;
   string requestVersion_url = cbalgotrade_url+version_url;

   int res = WebRequest("GET",requestVersion_url,NULL,NULL,timeoutConnection,post,0,result,headers);
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      Print("Add the address '"+cbalgotrade_url+"' in the list of allowed URLs on tab 'Expert Advisors' in 'Options'");
      return false;
     }
   else
     {
      //string newVersion = "";
      string newVersion = "v1.00";                                                 // da eliminare
      for(int a1=0; a1<ArraySize(result); a1++)
        {
         StringAdd(newVersion,CharToString(result[a1]));
         if(result[a1] == '\n')
            break;
        }
      if(StringCompare(newVersion,versione,false) != 0)
        {
         // Print("New Version ("+newVersion+")!\nDownload it from "+cbalgotrade_url+"profilo/");
         //Alert("New Version! EA "+EAname0+" "+newVersion+"\nDownload it from "+cbalgotrade_url+"profilo/");
         return true;
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool licenseResearch()
  {

   Print("Connection for license activation...");
   ResetLastError();

   char post[],result[];
   string headers;
   string requestLicense_url = cbalgotrade_url+license_url;

   int res = WebRequest("GET",requestLicense_url,NULL,NULL,timeoutConnection,post,0,result,headers);
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      MessageBox("Add the address '"+cbalgotrade_url+"' in the list of allowed URLs on tab 'Expert Advisors' in 'Options'","Error",MB_ICONINFORMATION);
      ExpertRemove();
      return false;
     }
   else
     {
      Print("Connected! Search for user license...");
      string usersLicenses[10000] = {};
      int d=0;
      for(int a1=0; a1<ArraySize(result); a1++)
        {
         StringAdd(usersLicenses[d],CharToString(result[a1]));
         if(result[a1] == '\n')
            d++;
        }

      for(int n=0; n<d+1; n++)
        {
         if(estrapolazioneStringa(usersLicenses[n]))
           {
            if(numeroAccountLicense == AccountNumber())
              {
               if(TimeLicense >= D'3000.01.01 00:00:00')
                  Print("User license found! License FOREVER!");
               else
                  Print("User license found! Expiration license: "+TimeToString(TimeLicense));
               dateLicense = TimeLicense;
               return true;
              }
           }
        }
      return false;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool estrapolazioneStringa(string estrapolazione)
  {
   string result[];
   ushort u_sep = StringGetCharacter(",",0);
   int k=StringSplit(estrapolazione,u_sep,result);

   if(k >= 3)
     {
      TimeLicense = StringToTime(result[0]);
      numeroAccountLicense = (int)StringToInteger(result[1]);
      nomeAccount = result[2];
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
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
         int    indicator_handleMA=iMA(Symbol(),periodMoving,Moving_period,Moving_shift,Moving_method,Moving_applied_price);
         ChartIndicatorAdd(0,0,indicator_handleMA);
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

//------------------------------- LevelToString__ ()--------------------------------------------
string LevelToString__(char level)
  {
   string nomeLivello;
   if(level == 1)
     {
      nomeLivello="Pivot";
      return nomeLivello;
     }
   if(level == 2)
     {
      nomeLivello="Buy/Sell";
      return nomeLivello;
     }
   if(level == 3)
     {
      nomeLivello="R1/S1";
      return nomeLivello;
     }
   if(level == 4)
     {
      nomeLivello="R2/S2";
      return nomeLivello;
     }
   if(level == 5)
     {
      nomeLivello="R3/S3";
      return nomeLivello;
     }
   if(level == 6)
     {
      nomeLivello="R4/S4";
      return nomeLivello;
     }
   if(level == 7)
     {
      nomeLivello="No Limits";
      return nomeLivello;
     }
   if(level < 1 || level > 7)
     {
      nomeLivello="Error Level";
      return nomeLivello;
     }
   return nomeLivello;
  }

//+------------------------------------------------------------------+
//|                        SogliaPercOrd ()                          |PercLivNoOpenPos
//+------------------------------------------------------------------+
double SogliaPercOrd()
  {
   if(PercLivPerOpenPos == 0)
     {
      return 0;
     }
   double SogliaPerc=NormalizeDouble(((R2-R1)*0.01*PercLivPerOpenPos),Digits());
   if(PercLivPerOpenPos != 0)
      switch(levelByLevel)
        {
         case 0    :
            return 0;
         case 1    :
            return 0;
         case -1   :
            return 0;
         case 2    :
            SogliaPerc = SogliaPerc + compraSopra;
            break;
         case 3    :
            SogliaPerc = SogliaPerc + R1;
            break;
         case 4    :
            SogliaPerc = SogliaPerc + R2;
            break;
         case 5    :
            SogliaPerc = SogliaPerc + R3;
            break;
         case 6    :
            SogliaPerc = SogliaPerc + R4;
            break;
         case 7    :
            SogliaPerc = SogliaPerc + R5;
            break;
         case -2   :
            SogliaPerc = vendiSotto - SogliaPerc;
            break;
         case -3   :
            SogliaPerc = S1 - SogliaPerc;
            break;
         case -4   :
            SogliaPerc = S2 - SogliaPerc;
            break;
         case -5   :
            SogliaPerc = S3 - SogliaPerc;
            break;
         case -6   :
            SogliaPerc = S4 - SogliaPerc;
            break;
         case -7   :
            SogliaPerc = S5 - SogliaPerc;
            break;
        }
   return SogliaPerc;
  }

//------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool controlAccounts()
  {
   if(!IsConnected())
     {
      Print("No connection");
      return true;
     }
   bool a = false;
   if(AccountNumber() == NumeroAccount0 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount1 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount2 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount3 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount4 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount5 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount6 && TimeLicens > TimeCurrent())
      a = true;
   if(AccountNumber() == NumeroAccount7 && TimeLicens > TimeCurrent())//67113373
      a = true;
   if(a == true)
      Print("EA Libra: Account Ok!");
   else
     {
      (Print("EA Libra: trial license expired or Account without permission"));
      ExpertRemove();
     }
   return a;
  }

//+------------------------------------------------------------------+
//|                  Controlli RSI sui 2 livelli                     |
//+------------------------------------------------------------------+
bool filtroRSI(const double &arrParamInd_[],string BuySell_)
  {

   bool RSIenable=true;
   if(arrParamInd_[37])
     {
      double rsi_ = RSI_();
      if(BuySell_ == "Buy")
        {
         if((arrParamInd_[42] != 0) && (arrParamInd_[42] == 2 || arrParamInd_[42] == 3) &&  rsi_ > arrParamInd_[39])
           {
            RSIenable = false;  //sopra liv 2,
           }
         if((arrParamInd_[41] != 0) && (arrParamInd_[41] == 2 || arrParamInd_[41] == 3) && (rsi_ > arrParamInd_[38] || rsi_ < arrParamInd_ [39]))
           {
            RSIenable = false;  //medio , solo sell e block
           }
         if((arrParamInd_[40] != 0) && (arrParamInd_[40] == 2 || arrParamInd_[40] == 3) &&  rsi_ < arrParamInd_[38])
           {
            RSIenable = false;  //sotto liv 1 - solo sell e block
           }
        }
      if(BuySell_ == "Sell")
        {
         if((arrParamInd_[42] != 0) && (arrParamInd_[42] == 1 || arrParamInd_[42] == 3) &&  rsi_ > arrParamInd_[39])
           {
            RSIenable = false;
           }
         if((arrParamInd_[41] != 0) && (arrParamInd_[41] == 1 || arrParamInd_[41] == 3) && (rsi_ > arrParamInd_[38] || rsi_ < arrParamInd_ [39]))
           {
            RSIenable = false;
           }
         if((arrParamInd_[40] != 0) && (arrParamInd_[40] == 1 || arrParamInd_[40] == 3) &&  rsi_ < arrParamInd_[38])
           {
            RSIenable = false;  //sotto liv 1 - solo buy e block
           }
        }
     }
   return RSIenable;
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

//*------------------- NumCandPerPeriodo () ------------------------------*
int NumCandPerPeriodo()
  {

   int numCandele=0;
   if(PEriodoRicNumCand==0)
      numCandele=iBarShift(Symbol(),TFPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TFPeridoRicCand,D'19.01.2023');
   if(PEriodoRicNumCand==1)
      numCandele=iBarShift(Symbol(),TFPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TFPeridoRicCand,D'24.01.2023');
   if(PEriodoRicNumCand==2)
      numCandele=iBarShift(Symbol(),TFPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TFPeridoRicCand,D'17.02.2023');
   if(PEriodoRicNumCand==3)
      numCandele=iBarShift(Symbol(),TFPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TFPeridoRicCand,D'17.07.2023');
   if(PEriodoRicNumCand==4)
      numCandele=iBarShift(Symbol(),TFPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TFPeridoRicCand,D'17.01.2024');
   return numCandele;
  }

//+------------------------------------------------------------------+
//|                        GestioneGrid()                            |
//+------------------------------------------------------------------+
void GestioneGrid()
  {
   if(GridHedge==1)
     {
      PositionSelectByIndex(0);
      double Ask,Bid;
      Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
      Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      static double arrayGridLossBuy[50];
      static double arraysGridLossSell[50];

      static char  NumOrdBuyGrid=0;
      static char  NumOrdSellGrid=0;
      double LotGridBuy=0;
      double LotGridSell=0;

      static int indexBuy ;
      static int indexSell;

      /////////////////////////////////
      if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
        {
         PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
        }
      if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
        {
         PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
        }

      /////////////////////////////////////


      if(!NumOrdBuy(magic_number) && !NumOrdSell(magic_number))
        {
         return;
        }

      if(NumOrdBuy(magic_number)>1&&NumOrdSell(magic_number)==1&&PositionTakeProfit(TicketPrimoOrdineSell(magic_number))!=0.0)
        {
         PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
        }
      if(NumOrdSell(magic_number)>1&&NumOrdBuy(magic_number)==1&&PositionTakeProfit(TicketPrimoOrdineBuy(magic_number)!=0.0))
        {
         PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
        }

      if(GridBuyActive && PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_BUY)>= profitGrid)
        {
         brutalCloseBuyPositions(Symbol(),magic_number);
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;
        }

      if(GridSellActive && PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_SELL)>= profitGrid)
        {
         brutalCloseSellPositions(Symbol(),magic_number);
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;
        }

      if(((GridBuyActive || GridSellActive) && (PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_BUY)
            +PositionsTotalProfitFullRunning(Symbol(),magic_number,POSITION_TYPE_SELL))>= profitGrid) || DDMax(maxDDPerc,magic_number) || NumCandPrimoOrdine(CloseOrdDopoNumCandDalPrimoOrdine))
        {
         brutalCloseTotal(Symbol(),magic_number);
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;
         return;
        }
        
      if(GridHedge!=0 && !NumOrdBuy(magic_number))
        {
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;

         //------------------azzera array arrayGridLossBuy -----------
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
           {
            arrayGridLossBuy[aa] = 0.0;
           }
        }

      if(GridHedge!=0 && !NumOrdSell(magic_number))
        {
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;

         if(!BEPointConGridOHedgeActive && (GridBuyActive || GridSellActive))
           {
            if(PositionStopLoss(TicketPrimoOrdineBuy(magic_number)))
              {
               PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
              }
            if(PositionStopLoss(TicketPrimoOrdineSell(magic_number)))
              {
               PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
              }
           }

         //------------------azzera array arraysGridLossSell -----------
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
           {
            arraysGridLossSell[aa] = 0.0;
           }
        }

      if((NumOrdBuy(magic_number)||NumOrdSell(magic_number)) && GridHedge!=0)
        {
         if(!NumOrdBuy(magic_number))
           {
            indexBuy=0;
            GridBuyActive=false;
            NumOrdBuyGrid=0;
           }

         if(NumOrdBuy(magic_number) && Bid<OpenPricePrimoOrdineBuy(magic_number))
           {
            if(NumOrdBuy(magic_number))
              {
               for(int i=0; i<=NumMaxGrid; i++)
                 {
                  if(i==0)
                    {
                     arrayGridLossBuy[i]=OpenPricePrimoOrdineBuy(magic_number)-((StartGrid)*Point());
                    }
                  if(i>0)
                    {
                     arrayGridLossBuy[i]=OpenPricePrimoOrdineBuy(magic_number)-((i)*StepGrid+(StartGrid))*Point();
                    }
                 }

               for(int i=indexBuy; i<NumMaxGrid; i++)

                 {
                  if(MoltipliNumGrid<=(NumOrdBuy(magic_number)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0)
                       {
                        LotGridBuy=LotsPrimoOrdineBuy(magic_number)*MoltiplLotStep;
                       }
                     if(TypeGrid == 1)
                       {
                        LotGridBuy=NormalizeDoubleLots(LotsUltimoOrdineBuy(magic_number)*MoltiplLotStep);
                       }
                    }
                  if(MoltipliNumGrid> (NumOrdBuy(magic_number)-1) && MoltipliNumGrid >= 0)
                    {
                     LotGridBuy=LotsPrimoOrdineBuy(magic_number);
                    }

                  if(SymbolInfoDouble(Symbol(),SYMBOL_ASK)<=arrayGridLossBuy[indexBuy])

                    {
                     SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);
                     indexBuy=i+1;
                     GridBuyActive=true;
                     NumOrdBuyGrid++;
                     if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0)
                       {
                        PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
                       }
                     if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0&&TpSeDueOrdini)
                       {
                        PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
                       }
                    }
                 }
              }
           }

         if(!PositionsTotalSell(Symbol(),magic_number))
           {
            indexSell=0;
            GridSellActive=false;
            NumOrdSellGrid=0;
           }

         if(PositionsTotalSell(Symbol(),magic_number) && Ask>OpenPricePrimoOrdineSell(magic_number))
           {
            if(NumOrdSell(magic_number))
              {

               for(int i=0; i<=NumMaxGrid; i++)
                 {
                  if(i==0)
                    {
                     arraysGridLossSell[i]=OpenPricePrimoOrdineSell(magic_number)+(StartGrid)*Point();
                    }
                  if(i>0)
                    {
                     arraysGridLossSell[i]=OpenPricePrimoOrdineSell(magic_number)+((i)*StepGrid+(StartGrid))*Point();
                    }

                 }
              }
            for(int i=indexSell; i<NumMaxGrid; i++)

              {
               if(MoltipliNumGrid<=(NumOrdSell(magic_number)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0)
                    {
                     LotGridSell=LotsPrimoOrdineSell(magic_number)*MoltiplLotStep;
                    }
                  if(TypeGrid == 1)
                    {
                     LotGridSell=NormalizeDoubleLots(LotsUltimoOrdineSell(magic_number)*MoltiplLotStep);
                    }
                 }
               if(MoltipliNumGrid> (NumOrdSell(magic_number)-1) && MoltipliNumGrid >= 0)
                 {
                  LotGridSell=LotsPrimoOrdineSell(magic_number);
                 }

               if(SymbolInfoDouble(Symbol(),SYMBOL_BID)>=arraysGridLossSell[indexSell])

                 {
                  SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);
                  indexSell=i+1;
                  GridSellActive=true;
                  NumOrdSellGrid++;
                  if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0)
                    {
                     PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
                    }
                  if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0&&TpSeDueOrdini)
                    {
                     PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
                    }

                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|              Numero Posizioni con indice                         |restituisce il numero di ordini aperti Buy e Sell con "aa" o il ticket con "bb"
//+------------------------------------------------------------------+
long NumTicket(const string &sniperStri[], const int &arrInput__[], const double &valoriA[])   //Gestisce posizioni Buy/Sell, magic, e fornisce i dati alle due funzioni TsPips e TsLevByLev
  {
   long bb = 0;
   int x = PositionsTotal();
   string arr [100];
   long arrMagic [100];
//------------------------azzera array ------------------
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }

//------------------azzera array Magic ------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      //arr [i] =(string) Symbol((string)PositionSelectByPos(i));
      PositionSelectByPos(i);

      arr [i] = PositionSymbol() ;
      arrMagic[i] = PositionMagicNumber();

     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)Symbol())) && (arrMagic[i] == magic_number))
        {
         aa++;
         bb = PositionTicket();

        }
     }
   return bb;
  }


//+------------------------------------------------------------------+ Da inserire il controllo con il numero magico//////////////////////////////
//|                       EnableBuyOrdersByGrid                      |restituisce "true" quando Numero max e enable Grid sono favorevoli.
//+------------------------------------------------------------------+Passare la variabile "Buy" sul controllo Buy e "Sell" sul controllo Sell
bool EnableOrdersByGrid(string contrBuySell, ulong MagicNumber_)
  {
   bool enable=true;
   if(GridHedge!=0)
     {
      if(N_Max_pos==1 && (TicketPrimoOrdineBuy(MagicNumber_)||TicketPrimoOrdineSell(MagicNumber_)))
        {
         enable = false;
        }
      if(N_Max_pos>1  && (TicketPrimoOrdine(contrBuySell,MagicNumber_)))
        {
         enable = false;
        }
     }
   return enable;
  }

//+------------------------------------------------------------------+
//|                         GestioneHedge()                          |
//+------------------------------------------------------------------+
void GestioneHedge()
  {
   if(GridHedge!=2)
     {
      return;
     }
   if(NumCandPrimoOrdine(CloseOrdDopoNumCandDalPrimoOrdine))
     {
      brutalCloseTotal(Symbol(),magic_number);
     }
   if(TicketHedgeBuy[0]==0.0 && TicketHedgeSell[0]==0.0)
     {
      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
        {
         TicketHedgeBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
        {
         TicketHedgeSell[aa] = 0;
        }

      ;
      return;
     }

   if(!BEPointConGridOHedgeActive && (GridBuyActive || GridSellActive))
     {
      if(PositionStopLoss(TicketPrimoOrdineBuy(magic_number)))
        {
         PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
        }
      if(PositionStopLoss(TicketPrimoOrdineSell(magic_number)))
        {
         PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
        }
     }
   if(PositionTakeProfit(TicketPrimoOrdineBuy(magic_number))>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
     {
      PositionModify(TicketPrimoOrdineBuy(magic_number),0,0,true);
     }
   if(PositionTakeProfit(TicketPrimoOrdineSell(magic_number))>0.0&&TpSeDueOrdini&&(GridBuyActive||GridSellActive))
     {
      PositionModify(TicketPrimoOrdineSell(magic_number),0,0,true);
     }

   PositionSelectByIndex(0);
   double Ask,Bid;
   Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);

   static ulong OldTicketPrimoOrdineBuy;   //x Semaforo creazione griglia Buy
   static ulong OldTicketPrimoOrdineSell;  //x Semaforo creazione griglia Sell

   static double arrayGridProfitBuy[50];   //Griglia profit Buy
   static double arrayGridLossBuy[50];     //Grilia Loss Buy

   static double arraysGridProfitSell[50]; //Griglia profit Sell
   static double arraysGridLossSell[50];   //Griglia Loss Sell

   double LotGridBuy=0;
   double LotGridSell=0;

   static int indexBuy ;
   static int indexSell;
   static int indexBuyProfit ;
   static int indexSellProfit;

   if(TicketPresente(TicketHedgeBuy[0]) && TicketHedgeBuy[0]!=0.0)  //if(TicketPresente(TicketHedgeBuy[0],magic_number) && TicketHedgeBuy[0]!=0.0)
     {
      if(OldTicketPrimoOrdineBuy!=TicketHedgeBuy[0])
        {
         //a=1;
         OldTicketPrimoOrdineBuy=TicketHedgeBuy[0];
         indexBuy=0;
         indexBuyProfit=0;
         GridBuyActive=false;

         for(int aa=1; aa<ArraySize(TicketHedgeBuy); aa++)
           {
            TicketHedgeBuy[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++)
           {
            arrayGridProfitBuy[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
           {
            arrayGridLossBuy[aa] = 0;
           }
        }

      //Crea grid profit e loss BUY

      for(int i=0; i<=NumMaxGrid; i++)
        {
         if(i==0)
           {
            arrayGridProfitBuy[i]=PositionOpenPrice(TicketHedgeBuy[0])+((StepGrid)*Point());
           }
         if(i>0)
           {
            arrayGridProfitBuy[i]=PositionOpenPrice(TicketHedgeBuy[0])+((i)*StepGrid+(StepGrid))*Point();
           }
        }
     }
   for(int i=0; i<=NumMaxGrid; i++)
     {
      if(i==0)
        {
         arrayGridLossBuy[i]=PositionOpenPrice(TicketHedgeBuy[0])-((StartGrid)*Point());
        }
      if(i>0)
        {
         arrayGridLossBuy[i]=PositionOpenPrice(TicketHedgeBuy[0])-((i)*StepGrid+(StartGrid))*Point();
        }
     }

   if(TicketPresente(TicketHedgeSell[0])&&TicketHedgeSell[0]!=0.0)  //if(TicketPresente(TicketHedgeSell[0],magic_number)&&TicketHedgeSell[0]!=0.0)
     {
      if(OldTicketPrimoOrdineSell!=TicketHedgeSell[0])
        {
         //a=1;
         OldTicketPrimoOrdineSell=TicketHedgeSell[0];
         indexSell=0;
         indexSellProfit=0;
         GridSellActive=false;

         for(int aa=1; aa<ArraySize(TicketHedgeSell); aa++)
           {
            TicketHedgeSell[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++)
           {
            arraysGridProfitSell[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
           {
            arraysGridLossSell[aa] = 0;
           }
        }

      //Crea grid profit e loss SELL

      for(int i=0; i<=NumMaxGrid; i++)
        {
         if(i==0)
           {
            arraysGridProfitSell[i]=PositionOpenPrice(TicketHedgeSell[0])-((StepGrid)*Point());
           }
         if(i>0)
           {
            arraysGridProfitSell[i]=PositionOpenPrice(TicketHedgeSell[0])-((i)*StepGrid+(StepGrid))*Point();
           }
        }

      for(int i=0; i<=NumMaxGrid; i++)
        {
         if(i==0)
           {
            arraysGridLossSell[i]=PositionOpenPrice(TicketHedgeSell[0])+(StartGrid)*Point();
           }
         if(i>0)
           {

            arraysGridLossSell[i]=PositionOpenPrice(TicketHedgeSell[0])+((i)*StepGrid+(StartGrid))*Point();
           }
        }
     }

   if(NumOrdHedgeBuy(TicketHedgeBuy)>1 && ProfitHedgeBuy(TicketHedgeBuy)>= profitGrid)   ////////////////////////////
     {
      ClosePositionsHedgeBUY(TicketHedgeBuy);
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
        {
         TicketHedgeBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++)
        {
         arrayGridProfitBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
        {
         arrayGridLossBuy[aa] = 0;
        }
     }

   if(NumOrdHedgeSell(TicketHedgeSell)>1 && ProfitHedgeSell(TicketHedgeSell)>= profitGrid)   ////////////////////////////
     {
      ClosePositionsHedgeSell(TicketHedgeSell);
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
        {
         TicketHedgeSell[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++)
        {
         arraysGridProfitSell[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
        {
         arraysGridLossSell[aa] = 0;
        }
     }

   if(((NumOrdHedgeBuy(TicketHedgeBuy)>1 || NumOrdHedgeSell(TicketHedgeSell)>1) && (ProfitHedgeBuy(TicketHedgeBuy)
         +ProfitHedgeSell(TicketHedgeSell))>= profitGrid) || DDMax(maxDDPerc,magic_number))
     {
      ClosePositionsHedgeBUY(TicketHedgeBuy);
      ClosePositionsHedgeSell(TicketHedgeSell);
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
        {
         TicketHedgeBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++)
        {
         arrayGridProfitBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
        {
         arrayGridLossBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
        {
         TicketHedgeSell[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++)
        {
         arraysGridProfitSell[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
        {
         arraysGridLossSell[aa] = 0;
        }
      return;
     }

   if(!NumOrdHedgeBuy(TicketHedgeBuy))
     {
      indexBuy=0;
      indexBuyProfit=0;
      GridBuyActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
        {
         TicketHedgeBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++)
        {
         arrayGridProfitBuy[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
        {
         arrayGridLossBuy[aa] = 0;
        }
     }

   if(!NumOrdHedgeSell(TicketHedgeSell))
     {
      indexSell=0;
      indexSellProfit=0;
      GridSellActive=false;

      for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
        {
         TicketHedgeSell[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++)
        {
         arraysGridProfitSell[aa] = 0;
        }
      for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
        {
         arraysGridLossSell[aa] = 0;
        }
     }

   if((NumOrdHedgeBuy(TicketHedgeBuy)>0||NumOrdHedgeSell(TicketHedgeSell)>0))
     {
      if(!NumOrdHedgeBuy(TicketHedgeBuy))
        {
         indexBuy=0;
         indexBuyProfit=0;
         GridBuyActive=false;

         for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
           {
            TicketHedgeBuy[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arrayGridProfitBuy); aa++)
           {
            arrayGridProfitBuy[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
           {
            arrayGridLossBuy[aa] = 0;
           }
        }

      if(NumOrdHedgeBuy(TicketHedgeBuy)>1 && Ask>PositionOpenPrice(TicketHedgeBuy[0]))   //Ask o Bid?
        {
         if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))
           {
            for(int i=indexBuyProfit; i<NumMaxGrid; i++)
              {
               if(MoltipliNumGrid<=(NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0)
                    {
                     LotGridBuy=UltimoLotHedge(magic_number)*MoltiplLotStep;
                    }
                  if(TypeGrid == 1)
                    {
                     LotGridBuy=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);
                    }
                 }
               if(MoltipliNumGrid> (NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                 {
                  LotGridBuy=UltimoLotHedge(magic_number);
                 }
               if(SymbolInfoDouble(Symbol(),SYMBOL_ASK)>=arrayGridProfitBuy[indexBuyProfit])
                  if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))
                    {
                     TicketHedgeBuy[i+50]=SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);///////////////BUY Profit
                     indexBuyProfit=i+1;
                     GridBuyActive=true;

                     if(PositionTakeProfit(TicketHedgeBuy[0])>0.0)
                       {
                        PositionModify(TicketHedgeBuy[0],0,0,true);
                       }
                    }
              }
           }
        }

      if(NumOrdHedgeBuy(TicketHedgeBuy)>0 && Bid<PositionOpenPrice(TicketHedgeBuy[0]))
        {
         if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))
           {
            if(NumOrdHedgeBuy(TicketHedgeBuy))
              {

               for(int i=indexBuy; i<NumMaxGrid; i++)
                 {
                  if(MoltipliNumGrid<=(NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0)
                       {
                        LotGridBuy=UltimoLotHedge(magic_number)*MoltiplLotStep;
                       }
                     if(TypeGrid == 1)
                       {
                        LotGridBuy=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);
                       }
                    }
                  if(MoltipliNumGrid> (NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                    {
                     LotGridBuy=UltimoLotHedge(magic_number);
                    }
                  if(SymbolInfoDouble(Symbol(),SYMBOL_BID)<=arrayGridLossBuy[indexBuy])
                     if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))

                       {
                        TicketHedgeBuy[i+1]=SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);//////////BUY Loss
                        indexBuy=i+1;
                        GridBuyActive=true;

                        if(PositionTakeProfit(TicketHedgeBuy[0])>0.0)
                          {
                           PositionModify(TicketHedgeBuy[0],0,0,true);
                          }
                       }
                 }
              }
           }
        }

      if(TicketHedgeSell[0]==0.0)
        {
         indexSell=0;
         indexSellProfit=0;
         GridSellActive=false;
         for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
           {
            TicketHedgeSell[aa] = 0;
           }
         for(int aa=0; aa<ArraySize(arraysGridProfitSell); aa++)
           {
            arraysGridProfitSell[aa] = 0.0;
           }
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
           {
            arraysGridLossSell[aa] = 0.0;
           }
        }

      //Inserire gridProfitHedgeSell

      if(NumOrdHedgeSell(TicketHedgeSell)>1 && Bid<PositionOpenPrice(TicketHedgeSell[0]))
        {
         if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))
           {
            for(int i=indexSellProfit; i<NumMaxGrid; i++)
              {
               if(MoltipliNumGrid<=(NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0)
                    {
                     LotGridSell=UltimoLotHedge(magic_number)*MoltiplLotStep;
                    }
                  if(TypeGrid == 1)
                    {
                     LotGridSell=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);
                    }
                 }
               if(MoltipliNumGrid> (NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                 {
                  LotGridSell=UltimoLotHedge(magic_number);
                 }
               if(SymbolInfoDouble(Symbol(),SYMBOL_BID)<=arraysGridProfitSell[indexSellProfit])
                  if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Buy") || (HedgPend && NumPosizioni(magic_number)<3))
                    {
                     TicketHedgeSell[i+50]=SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);////////////////////Sell Profit
                     indexSellProfit=i+1;
                     GridSellActive=true;
                     if(PositionTakeProfit(TicketHedgeSell[0])>0.0)
                       {
                        PositionModify(TicketHedgeSell[0],0,0,true);
                       }
                    }
              }
           }
        }

      if(NumOrdHedgeSell(TicketHedgeSell)>0 && Ask>PositionOpenPrice(TicketHedgeSell[0]))
        {
         if(NumOrdHedgeSell(TicketHedgeSell)>0)
           {
            if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))
              {

               for(int i=indexSell; i<NumMaxGrid; i++)

                 {
                  if(MoltipliNumGrid<=(NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0)
                       {
                        LotGridSell=UltimoLotHedge(magic_number)*MoltiplLotStep;
                       }
                     if(TypeGrid == 1)
                       {
                        LotGridSell=NormalizeDoubleLots(UltimoLotHedge(magic_number)*MoltiplLotStep);
                       }
                    }
                  if(MoltipliNumGrid> (NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                    {
                     LotGridSell=UltimoLotHedge(magic_number);
                    }

                  if(Ask>=arraysGridLossSell[indexSell]&&NumOrdHedgeSell(TicketHedgeSell)>0)
                     if(!HedgPend || (HedgPend && TypeUltimoOrdine(magic_number)=="Sell") || (HedgPend && NumPosizioni(magic_number)<3))

                       {
                        TicketHedgeSell[i+1]=SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);    ////////////////////////Sell Loss
                        indexSell=i+1;
                        GridSellActive=true;
                        if(PositionTakeProfit(TicketHedgeSell[0])>0.0)
                          {
                           PositionModify(TicketHedgeSell[0],0,0,true);
                          }
                       }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+

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

//+------------------------------------------------------------------+Da costruire
bool PrimiOrdiniSuStessaCandela()
  {
   bool a=false;

   return a;
  }



//+------------------------------------------------------------------+
//|                      NumCandPrimoOrdine                          |
//+------------------------------------------------------------------+
bool NumCandPrimoOrdine(int CloseOrdDopoNumCandDalPrimoOrdine__)
  {
   bool a=false;
   if(!CloseOrdDopoNumCandDalPrimoOrdine__)
     {
      return a;
     }
   static ulong Ticket=0;
   static int barsOpenFirstOrder=0;

   if(NumPosizioni(magic_number)==0||NumPosizioni(magic_number)>1)
     {
      barsOpenFirstOrder=0;
      return false;
     }

   if(NumPosizioni(magic_number)==1&&barsOpenFirstOrder==0)
     {
      barsOpenFirstOrder=iBars(Symbol(),PERIOD_CURRENT);
      Ticket=TicketPrimoOrdine(TypeUltimoOrdine(magic_number),magic_number);
     }

   if(iBars(Symbol(),PERIOD_CURRENT)-barsOpenFirstOrder>=CloseOrdDopoNumCandDalPrimoOrdine__
      && PositionProfitFull(Ticket)>0.0 && PositionStopLoss(Ticket)==0.0)
     {
      a=true;
      barsOpenFirstOrder=0;
      Ticket=0;
     }
   return a;
  }

//+------------------------------------------------------------------+
//|                      CloseOrderDopoNumCand                       |
//+------------------------------------------------------------------+
void CloseOrderDopoNumCand(int CloseOrdDopoNumCandDalPrimoOrdine__)
  {
   bool a=false;
   if(!CloseOrdDopoNumCandDalPrimoOrdine__)
     {
      return;
     }
   static ulong Ticket=0;
   static int barsOpenFirstOrder=0;
   bool StopLossIsPorofit=false;

   if(NumPosizioni(magic_number)==0||NumPosizioni(magic_number)>1)
     {
      barsOpenFirstOrder=0;
      Ticket=0;
      barsOpenFirstOrder=0;
      return;
     }

   if(NumPosizioni(magic_number)==1&&barsOpenFirstOrder==0)
     {
      barsOpenFirstOrder=iBars(Symbol(),PERIOD_CURRENT);
      if(TicketPrimoOrdineBuy(magic_number))
      {
         Ticket=TicketPrimoOrdineBuy(magic_number);
         if(PositionStopLoss(Ticket)>OpenPricePrimoOrdineBuy(magic_number))
         {StopLossIsPorofit=true;}
      }
      
      if(TicketPrimoOrdineSell(magic_number))
      {
         Ticket=TicketPrimoOrdineSell(magic_number);
         if(PositionStopLoss(Ticket)<OpenPricePrimoOrdineSell(magic_number))
         {StopLossIsPorofit=true;}
      }   
     }

   if(iBars(Symbol(),PERIOD_CURRENT)-barsOpenFirstOrder>=CloseOrdDopoNumCandDalPrimoOrdine__
      && !StopLossIsPorofit && PositionProfitFull(Ticket)>0.0)
     {
      brutalCloseTotal(Symbol(),magic_number);
      a=true;
      barsOpenFirstOrder=0;
      Ticket=0;
     }
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
   if(StopNewsOrders&&NumPosizioni(magic_number)==0&&xxx==0)
     {
      Print("Auto Stop News Orders EA ",Symbol());
      Comment("Auto Stop News Orders EA ",Symbol());
      Alert("Auto Stop News Orders EA ",Symbol());
      xxx++;
     }
    if(StopNewsOrders&&NumPosizioni(magic_number)==0)a = true; 
   return a;
  }
//+------------------------------------------------------------------+
//|                         GestioneMABuy()                          |
//+------------------------------------------------------------------+
bool GestioneMABuy()
  {
   bool a=true;
   if(Filter_Moving_Average&&DistanceMA!=0)
     {
      if(Bid(Symbol(),1)>=Moving()&&Bid(Symbol(),1)<=Moving()+(DistanceMA*Point()))
        {
         a=false;
        }
      if(Ask(Symbol(),1)<=Moving()&&Ask(Symbol(),1)>=Moving()-(DistanceMA*Point()))
        {
         a=false;
        }
      if(Bid(Symbol(),1)>=Moving()&&Bid(Symbol(),1)>Moving()+(DistanceMA*Point()))
        {
         a=true;
        }
      if(Ask(Symbol(),1)<=Moving()&&Ask(Symbol(),1)<Moving()-(DistanceMA*Point()))
        {
         a=true;
        }
     }
   if(AboveBeloweMA)
     {
      if(Bid(Symbol(),1)<Moving())
        {
         a=false;
        }
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                         GestioneMASell()                         |
//+------------------------------------------------------------------+
bool GestioneMASell()
  {
   bool a=true;
   if(Filter_Moving_Average&&DistanceMA!=0)
     {
      if(Bid(Symbol(),1)>=Moving()&&Bid(Symbol(),1)<=Moving()+(DistanceMA*Point()))
        {
         a=false;
        }
      if(Ask(Symbol(),1)<=Moving()&&Ask(Symbol(),1)>=Moving()-(DistanceMA*Point()))
        {
         a=false;
        }
      if(Bid(Symbol(),1)>=Moving()&&Bid(Symbol(),1)>Moving()+(DistanceMA*Point()))
        {
         a=true;
        }
      if(Ask(Symbol(),1)<=Moving()&&Ask(Symbol(),1)<Moving()-(DistanceMA*Point()))
        {
         a=true;
        }
     }
   if(AboveBeloweMA)
     {
      if(Ask(Symbol(),1)<Moving())
        {
         a=false;
        }
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                         GestioneTEMABuy()                        |
//+------------------------------------------------------------------+
bool GestioneTEMABuy()
  {
   bool a=true;
   if(!Filter_TEMA||DistanceTEMA==0)
     {
      if(Bid(Symbol(),1)>=TEMA()&&Bid(Symbol(),1)<=TEMA()+(DistanceTEMA*Point()))
        {
         a=false;
        }
      if(Ask(Symbol(),1)<=TEMA()&&Ask(Symbol(),1)>=TEMA()-(DistanceTEMA*Point()))
        {
         a=false;
        }
      if(Bid(Symbol(),1)>=TEMA()&&Bid(Symbol(),1)>TEMA()+(DistanceTEMA*Point()))
        {
         a=true;
        }
      if(Ask(Symbol(),1)<=TEMA()&&Ask(Symbol(),1)<TEMA()-(DistanceTEMA*Point()))
        {
         a=true;
        }
     }
   if(AboveBeloweTEMA)
     {
      if(Bid(Symbol(),1)<TEMA())
        {
         a=false;
        }
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                         GestioneTEMASell()                       |
//+------------------------------------------------------------------+
bool GestioneTEMASell()
  {
   bool a=true;
   if(!Filter_TEMA||DistanceTEMA==0)
     {
      if(Bid(Symbol(),1)>=TEMA()&&Bid(Symbol(),1)<=TEMA()+(DistanceTEMA*Point()))
        {
         a=false;
        }
      if(Ask(Symbol(),1)<=TEMA()&&Ask(Symbol(),1)>=TEMA()-(DistanceTEMA*Point()))
        {
         a=false;
        }
      if(Bid(Symbol(),1)>=TEMA()&&Bid(Symbol(),1)>TEMA()+(DistanceTEMA*Point()))
        {
         a=true;
        }
      if(Ask(Symbol(),1)<=TEMA()&&Ask(Symbol(),1)<TEMA()-(DistanceTEMA*Point()))
        {
         a=true;
        }
     }
   if(AboveBeloweTEMA)
     {
      if(Ask(Symbol(),1)>TEMA())
        {
         a=false;
        }
     }
   return a;
  }

//+------------------------------------------------------------------+
//|                            GestioneATR()                         |
//+------------------------------------------------------------------+
bool GestioneATR()
  {
   bool a=true;
   if(!Filter_ATR)
     {
      return a;
     }
   if(Filter_ATR && iATR(Symbol(),periodATR,ATR_period,0) < thesholdATR)
     {
      a=false;
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                            PivotDay()                            |
//+------------------------------------------------------------------+

double PivotDay()
   {
                  return  (Low[0]+High[0]+Close[0])/3;
   }
//+------------------------------------------------------------------+
//|                      FiltroPivotDay()                            |
//+------------------------------------------------------------------+

bool FiltroPivotDay(string BuySell)
                 {
   if(!FiltroPivotDaily)return true;
   bool a=true;
   if(BuySell=="Buy" && Ask(Symbol())<PivotDay()) {a=false;;return a;}                
   if(BuySell=="Sell" && Bid(Symbol())>PivotDay()){a=false;;return a;} 
   return a;
   } 
   
//+------------------------------------------------------------------+
//|                      AbovePercNoOrder()                          |
//+------------------------------------------------------------------+       

bool AbovePercNoOrder(string segnoOrd)
{
if (!AbovePercNoOrder)return true; 
  {
   double x=0.0;
   if(segnoOrd=="Buy") x=Ask(Symbol());
   if(segnoOrd=="Sell")x=Bid(Symbol());
   char   a = (fasciaDiPrezzo(x, true));                                // "a" fascia di prezzo del prezzo
   double b = 0;
   double c = (secondoLevBuy - primoLevBuy) * 0.01 * AbovePercNoOrder;  // soglia percentuale fra livelli
   bool d = true;
   switch(a)
     {
      case   2:
         b= c + compraSopra;
         break;    //uguale distanza
      case   3:
         b= c + primoLevBuy;
         break;    //uguale distanza
      case   4:
         b= c + secondoLevBuy;
         break;    //uguale distanza
      case   5:
         b= c + terzoLevBuy;
         break;    //uguale distanza
      case   6:
         b= c + quartoLevBuy;
         break;    //uguale distanza
      case   7:
         b= c + quintoLevBuy;
         break;    //uguale distanza
      case  -2:
         b= vendiSotto - c;
         break;    //uguale distanza
      case  -3:
         b= primoLevSell - c;
         break;    //uguale distanza
      case  -4:
         b= secondoLevSell - c;
         break;    //uguale distanza
      case  -5:
         b= terzoLevSell - c;
         break;    //uguale distanza
      case  -6:
         b= quartoLevSell - c ;
         break;    //uguale distanza
      case  -7:
         b= quintoLevSell - c;
         break;    //uguale distanza
      default:
         Alert("Calcolo AbovePercNoOrder Errato");
     }
   if((segnoOrd == "Buy" && x > b) || (segnoOrd == "Sell" && x < b))
     {
      d = false;
     }
   if((segnoOrd == "Buy" && x < b) || (segnoOrd == "Sell" && x > b))
     {
      d = true;
     }
   return d;
}
}                              