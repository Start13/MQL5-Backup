//+------------------------------------------------------------------+
//|                                                  Square of 9.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

//#include <MyLibrary\MyLibrary.mqh>  

/*                                                       Incollare negli enum
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
   PivotWeek_        = 5,        //Pivot Weekly
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

enum LineGWidth          //Lines
  {
   VeryThin   = 1,
   Thin       = 2,
   Normal     = 3,
   Thick      = 4,
   VeryThick  = 5
  };   
//////////////////////////////////////////////////////////////////////////////////////  Incollare negli Input

input string   comment_CS9 =            "-- CALIBRATION LEVELS Sq 9--";   //  -- CALIBRATION LEVELS Sq 9 --
input GannInput              gannInputDigit                  = 4;         //Number of price digits used: Calibration
input Divisione              DIVIS                           = 0;         //Multiplication / Division of digits: Calibration

input PriceType              gannInputType                   = 9;         //Type of Input in Calculation
input string                 gannCustomPrice                 = "1.00000";
input PivD_SR_Sqnine         PivotDaily                      = 0;         //On the chart: Pivot Daily or Resistances/Supports Sq 9
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
input bool         DrawBackground_      = true;
input bool         DisableSelection_    = true;
input color        ResistanceColor_     = clrRed;
input LineType     ResistanceType_      = 2;
input LineWidth    ResistanceWidth_     = 1;
input color        SupportColor_        = clrLime;
input LineType     SupportType_         = 2;
input LineWidth    SupportWidth_        = 1;
input color        BuyAboveColor_       = clrRed;
input color        SellBelowColor_      = clrLime;
input color        ThresholdColor_      = clrWhite;
input string       ButtonStyle         = "--- Toggle Style Settings ---";
input bool         buttonEnable        = false;

//input int          xDistance_           = 250;
int          xDistance_           = 250;
//input int          yDistance_           = 5;
int          yDistance_           = 5;
//input int          width__               = 100;
int          width__               = 100;
//input int          hight__               = 30;
int          hight__               = 30;
input string       label               = " ";
 
input string     comment_SQ9         = "-- CALIBRATION SQUARE of 9 --";   //  -- CALIBRATION SQUARE of 9 -- 
input PriceType  GannInputType       = 9;         //Type of Input in Calculation
input string     GannCustomPrice     = "1.00000";
input GannInput  GannInputDigit      = 4;         //Number of price digits used: Calibration
input Divisione  Divis_               = 0;         //Multiplication / Division of digits: Calibration
input bool       ShortLines          = true;
input bool       ShowLineName        = true;
input int        Alert1              = 0;
input int        Alert2              = 0;
input int        PipDeviation        = 0;  
input int        XDistance           = 250;
input int        YDistance           = 5;
input int        Width               = 100;
input int        Hight               = 30;
input string     Label               = " ";
input bool       ButtonEnable        = false;
input bool       visualChart         =  true;
input bool       visualThresUp_       = false;
input bool       visualThresDw_       = false; 
//////////////////////////////////////////////////////////////////////////////
//////////////////////////  Di scorta per rifare l'include  /////////////////////


   double R1Price_ = 0;
   double R2Price_ = 0; 
   double R3Price_ = 0;
   double R4Price_ = 0;
   double R5Price_ = 0;
   double S1Price_ = 0;
   double S2Price_ = 0; 
   double S3Price_ = 0;
   double S4Price_ = 0;
   double S5Price_ = 0;
   double BuyAbove_    = 0;
   double SellBelow_   = 0;
   double ThresholdUp_ = 0;//NormalizeDouble( arrPrice[15],Digits());
   double ThresholdDw_ = 0;//NormalizeDouble( arrPrice[16],Digits());
   double PivotDay_    = arrPrice[13]; 
   double PivotWeek_   = arrPrice[14];


   int GannInputDigit_  = arrInt[0];
   int Divis_           = arrInt[1];
   int PipDeviation_    = arrInt[2];
   int ResistanceType_  = arrInt[3];
   int ResistanceWidth_ = arrInt[4];
   int SupportType_     = arrInt[5];
   int SupportWidth_    = arrInt[6];
   int Alert1_          = arrInt[7];
   int Alert2_          = arrInt[8];
   int XDistance_       = arrInt[9];
   int YDistance_       = arrInt[10];
   int Width_           = arrInt[11];
   int Hight_           = arrInt[12];
  
   bool visualChart_     = arrBool[0];
   bool ShortLines_      = arrBool[1];
   bool ShowLineName_    = arrBool[2];
   bool DrawBackground_  = arrBool[3];
   bool DisableSelection_= arrBool[4];
   bool ButtonEnable_    = arrBool[5];
   bool GannInputType_   = arrBool[6];
   bool visualThresUp_   = arrBool[10];
   bool visualThresDw_   = arrBool[11];   

   color ResistanceColor_ = arrColo[0];
   color SupportColor_    = arrColo[1];
   color BuyAboveColor_   = arrColo[2];
   color SellBelowColor_  = arrColo[3];
   color ThresholdColor_  = arrColo[4];



 
   string buttonID_        = arrString[3];


   string pcode_           = arrString[2];
   clearObj(pcode_);

   double priceIn_ = NormalizeDouble(arrPrice[0],Digits());

   GannObj gann(S5Price_, S4Price_, S3Price_, S2Price_, S1Price_, 
      R5Price_, R4Price_, R3Price_, R2Price_, R1Price_, 
      BuyAbove_, SellBelow_, Divis_,priceIn_,GannInputDigit_,iClose(Symbol(),PERIOD_CURRENT,1),Digits());

   arrPrice[1] = R1Price_;
   arrPrice[2] = R2Price_;
   arrPrice[3] = R3Price_;
   arrPrice[4] = R4Price_;
   arrPrice[5] = R5Price_;
   arrPrice[6] = S1Price_;
   arrPrice[7] = S2Price_;
   arrPrice[8] = S3Price_;
   arrPrice[9] = S4Price_;
   arrPrice[10] = S5Price_;
   arrPrice[11] = BuyAbove_;
   arrPrice[12] = SellBelow_;


  // ThresholdUp_ = NormalizeDouble( arrPrice[15],Digits());
  // ThresholdDw_ = NormalizeDouble( arrPrice[16],Digits());                                                          
  
//////////////////////////////////////////////////////////////////
////////////////////////////  codici del e nel bot  //////////////////////
arrInter[0] = GannInputDigit;
arrInter[1] = Divis_;
arrInter[2] = PipDeviation;
arrInter[3] = ResistanceType_;
arrInter[4] = ResistanceWidth_;
arrInter[5] = SupportType_;
arrInter[6] = SupportWidth_;
arrInter[7] = Alert1;
arrInter[8] = Alert2;
arrInter[9] = XDistance;
arrInter[10] = YDistance;
arrInter[11] = Width;
arrInter[12] = Hight;

arrBol[0] = visualChart;
arrBol[1] = ShortLines;
arrBol[2] = ShowLineName;
arrBol[3] = DrawBackground_;
arrBol[4] = DisableSelection_;
arrBol[5] = ButtonEnable;
arrBol[6] = GannInputType;
arrBol[7] = visualThresUp_;
arrBol[8] = visualThresDw_;

arrStrin[0] = GannCustomPrice;
arrStrin[1] = Label;
arrStrin[2] = pcode_;
arrStrin[3] = buttonID_;

arrCol[0] = ResistanceColor_;
arrCol[1] = SupportColor_;
arrCol[2] = BuyAboveColor_;
arrCol[3] = SellBelowColor_;
arrCol[4] = ThresholdColor_;        
  
  */






// SqNine(arrprez,arrStrin,arrInter,arrBol,arrCol);       Chiamata funzione

//+------------------------------------------------------------------+
//|                           SqNine()                               |
//+------------------------------------------------------------------+
void SqNineProva(double &arrPrice[], const string &arrString[], const int &arrInt[], const bool &arrBool[], const color &arrColo[])
  {

   /*
   double R1Price_ = 0;
   double R2Price_ = 0; 
   double R3Price_ = 0;
   double R4Price_ = 0;
   double R5Price_ = 0;
   double S1Price_ = 0;
   double S2Price_ = 0; 
   double S3Price_ = 0;
   double S4Price_ = 0;
   double S5Price_ = 0;
   double BuyAbove_    = 0;
   double SellBelow_   = 0;
   double ThresholdUp_ = 0;//NormalizeDouble( arrPrice[15],Digits());
   double ThresholdDw_ = 0;//NormalizeDouble( arrPrice[16],Digits());
   double PivotDay_    = arrPrice[13]; 
   double PivotWeek_   = arrPrice[14];
   

   //arrPrice[13] = double PivotDay_;
   //arrPrice[14] = double PivotWeek_;

   int GannInputDigit_  = arrInt[0];
   int Divis_           = arrInt[1];
   int PipDeviation_    = arrInt[2];
   int ResistanceType_  = arrInt[3];
   int ResistanceWidth_ = arrInt[4];
   int SupportType_     = arrInt[5];
   int SupportWidth_    = arrInt[6];
   int Alert1_          = arrInt[7];
   int Alert2_          = arrInt[8];
   int XDistance_       = arrInt[9];
   int YDistance_       = arrInt[10];
   int Width_           = arrInt[11];
   int Hight_           = arrInt[12];
  
   bool visualChart_     = arrBool[0];
   bool ShortLines_      = arrBool[1];
   bool ShowLineName_    = arrBool[2];
   bool DrawBackground_  = arrBool[3];
   bool DisableSelection_= arrBool[4];
   bool ButtonEnable_    = arrBool[5];
   //bool GannInputType_   = arrBool[6];
   bool visualThresUp_   = arrBool[10];
   bool visualThresDw_   = arrBool[11];   

   color ResistanceColor_ = arrColo[0];
   color SupportColor_    = arrColo[1];
   color BuyAboveColor_   = arrColo[2];
   color SellBelowColor_  = arrColo[3];
   color ThresholdColor_  = arrColo[4];

   string pcode_           = arrString[2]; 
   string buttonID_        = arrString[3];
   
------------------------------------------------- 

   clearObj(pcode_);

   double priceIn_ = NormalizeDouble(arrPrice[0],Digits());

   GannObj gann(S5Price_, S4Price_, S3Price_, S2Price_, S1Price_, 
      R5Price_, R4Price_, R3Price_, R2Price_, R1Price_, 
      BuyAbove_, SellBelow_, Divis_,priceIn_,GannInputDigit_,iClose(Symbol(),PERIOD_CURRENT,1),Digits());

   arrPrice[1] = R1Price_;
   arrPrice[2] = R2Price_;
   arrPrice[3] = R3Price_;
   arrPrice[4] = R4Price_;
   arrPrice[5] = R5Price_;
   arrPrice[6] = S1Price_;
   arrPrice[7] = S2Price_;
   arrPrice[8] = S3Price_;
   arrPrice[9] = S4Price_;
   arrPrice[10] = S5Price_;
   arrPrice[11] = BuyAbove_;
   arrPrice[12] = SellBelow_;
   
   
   
*/

   int GannInputDigit_  = arrInt[0];
   int Divis_           = arrInt[1];
   int PipDeviation_    = arrInt[2];
   int ResistanceType_  = arrInt[3];
   int ResistanceWidth_ = arrInt[4];
   int SupportType_     = arrInt[5];
   int SupportWidth_    = arrInt[6];
   int Alert1_          = arrInt[7];
   int Alert2_          = arrInt[8];
   int XDistance_       = arrInt[9];
   int YDistance_       = arrInt[10];
   int Width_           = arrInt[11];
   int Hight_           = arrInt[12];
  
   bool visualChart_     = arrBool[0];
   bool ShortLines_      = arrBool[1];
   bool ShowLineName_    = arrBool[2];
   bool DrawBackground_  = arrBool[3];
   bool DisableSelection_= arrBool[4];
   bool ButtonEnable_    = arrBool[5];
   //bool GannInputType_   = arrBool[6];
   bool visualThresUp_   = arrBool[10];
   bool visualThresDw_   = arrBool[11];   

   color ResistanceColor_ = arrColo[0];
   color SupportColor_    = arrColo[1];
   color BuyAboveColor_   = arrColo[2];
   color SellBelowColor_  = arrColo[3];
   color ThresholdColor_  = arrColo[4];

   string pcode_           = arrString[2]; 
   string buttonID_        = arrString[3];

   double R1Price_ = 0;
   double R2Price_ = 0; 
   double R3Price_ = 0;
   double R4Price_ = 0;
   double R5Price_ = 0;
   double S1Price_ = 0;
   double S2Price_ = 0; 
   double S3Price_ = 0;
   double S4Price_ = 0;
   double S5Price_ = 0;
   double BuyAbove_    = 0;
   double SellBelow_   = 0;
   double ThresholdUp_ = 0;//NormalizeDouble( arrPrice[15],Digits());
   double ThresholdDw_ = 0;//NormalizeDouble( arrPrice[16],Digits());
   double PivotDay_    = arrPrice[13]; 
   double PivotWeek_   = arrPrice[14];
   double priceIn_ = NormalizeDouble(arrPrice[0],Digits());


  clearObj( S5Price_,  S4Price_,  S3Price_,  S2Price_,  S1Price_, 
       R5Price_,  R4Price_,  R3Price_,  R2Price_,  R1Price_, 
       BuyAbove_,  SellBelow_, pcode_, ResistanceWidth_, ResistanceColor_, ResistanceType_, DrawBackground_, DisableSelection_,
       BuyAboveColor_, priceIn_, PivotWeek_, PivotDay_, SupportWidth_, SellBelowColor_, SupportType_, ThresholdUp_, ThresholdDw_,
       visualThresUp_, visualThresDw_, ThresholdColor_, SupportColor_);

   GannObj gann(S5Price_,  S4Price_,  S3Price_,  S2Price_,  S1Price_, 
       R5Price_,  R4Price_,  R3Price_,  R2Price_,  R1Price_,
       BuyAbove_,  SellBelow_, Divis_,priceIn_,GannInputDigit_,iClose(Symbol(),PERIOD_CURRENT,1),Digits());
/*

      double _inputPrice, int _inputDigit, double _currentPrice,  int _outputDigit*/

   arrPrice[1] = R1Price_;
   arrPrice[2] = R2Price_;
   arrPrice[3] = R3Price_;
   arrPrice[4] = R4Price_;
   arrPrice[5] = R5Price_;

   arrPrice[6] = S1Price_;
   arrPrice[7] = S2Price_;
   arrPrice[8] = S3Price_;
   arrPrice[9] = S4Price_;
   arrPrice[10]= S5Price_;
   arrPrice[11]= BuyAbove_;
   arrPrice[12]= SellBelow_;

   PivotDay_    = arrPrice[13];
   PivotWeek_   = arrPrice[14];

  // ThresholdUp_ = NormalizeDouble( arrPrice[15],Digits());
  // ThresholdDw_ = NormalizeDouble( arrPrice[16],Digits());
//Print(" BuyAbove_ ",BuyAbove_," R1Price_ ",R1Price_," R2Price_ ",R2Price_," R3Price_ ",R3Price_," R4Price_ ",R4Price_," S5Price_ ",S5Price_);
//Print(" SellBelow_ ",SellBelow_," S1Price_ ",S1Price_," S2Price_ ",S2Price_," S3Price_ ",S3Price_," S4Price_ ",S4Price_," S5Price_ ",S5Price_);

   if(ShortLines_)
      drawRectangleLine(S5Price_,  S4Price_,  S3Price_,  S2Price_,  S1Price_, 
       R5Price_,  R4Price_,  R3Price_,  R2Price_,  R1Price_, 
       BuyAbove_,  SellBelow_, pcode_, ResistanceWidth_, ResistanceColor_, ResistanceType_, DrawBackground_, DisableSelection_,
       BuyAboveColor_, priceIn_, PivotWeek_, PivotDay_, SupportWidth_, SellBelowColor_, SupportType_, ThresholdUp_, ThresholdDw_,
       visualThresUp_, visualThresDw_, ThresholdColor_, SupportColor_);
   else
      drawHorizontalLine( S5Price_,  S4Price_,  S3Price_,  S2Price_,  S1Price_, 
       R5Price_,  R4Price_,  R3Price_,  R2Price_,  R1Price_, 
       BuyAbove_,  SellBelow_, pcode_, ResistanceWidth_, ResistanceColor_, ResistanceType_, DrawBackground_, DisableSelection_,
       BuyAboveColor_, priceIn_, PivotWeek_, PivotDay_, SupportWidth_, SellBelowColor_, SupportType_, ThresholdUp_, ThresholdDw_,
       visualThresUp_, visualThresDw_, ThresholdColor_, SupportColor_);
   
   writeLineName(ShowLineName_,S5Price_,  S4Price_,  S3Price_,  S2Price_,  S1Price_, 
       R5Price_,  R4Price_,  R3Price_,  R2Price_,  R1Price_, 
       BuyAbove_,  SellBelow_, pcode_, ResistanceWidth_, ResistanceColor_, ResistanceType_, DrawBackground_, DisableSelection_,
       BuyAboveColor_, priceIn_, PivotWeek_, PivotDay_, SupportWidth_, SellBelowColor_, SupportType_, ThresholdUp_, ThresholdDw_,
       visualThresUp_, visualThresDw_, ThresholdColor_, SupportColor_);
   //checkAlarmPrice();

   EventKillTimer();

   ObjectDelete(0,buttonID_);

  }
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkAlarmPrice()
  {
   double ClosePrice[1];
   CopyClose(Symbol(),0,0,1,ClosePrice);

   string message="";
   NewAlert=LastAlert;

   if(ClosePrice[0]>=S5Price_-(Point()*PipDeviation)    && ClosePrice[0]<=S5Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("R5");
   if(ClosePrice[0]>=R4Price_-(Point()*PipDeviation)    && ClosePrice[0]<=R4Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("R4");
   if(ClosePrice[0]>=R3Price_-(Point()*PipDeviation)    && ClosePrice[0]<=R3Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("R3");
   if(ClosePrice[0]>=R2Price_-(Point()*PipDeviation)    && ClosePrice[0]<=R2Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("R2");
   if(ClosePrice[0]>=R1Price_-(Point()*PipDeviation)    && ClosePrice[0]<=R1Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("R1");
   if(ClosePrice[0]>=S1Price_-(Point()*PipDeviation)    && ClosePrice[0]<=S1Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("S1");
   if(ClosePrice[0]>=S2Price_-(Point()*PipDeviation)    && ClosePrice[0]<=S2Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("S2");
   if(ClosePrice[0]>=S3Price_-(Point()*PipDeviation)    && ClosePrice[0]<=S3Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("S3");
   if(ClosePrice[0]>=S4Price_-(Point()*PipDeviation)    && ClosePrice[0]<=S4Price_+(Point()*PipDeviation))
      NewAlert=getAlertID("S4");
   if(ClosePrice[0]>=S5Price_-(Point()*PipDeviation)    && ClosePrice[0]<=S5Price_+(Point()*PipDeviation))
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
  }*/
//+------------------------------------------------------------------+
//|                    drawHorizontalLine()                          |
//+------------------------------------------------------------------+
void drawHorizontalLine(double S5Price_, double S4Price_, double S3Price_, double S2Price_, double S1Price_, 
      double R5Price_, double R4Price_, double R3Price_, double R2Price_, double R1Price_, 
      double BuyAbove_, double SellBelow_,string pcode_,int ResistanceWidth_,color ResistanceColor_,int ResistanceType_,bool DrawBackground_,bool DisableSelection_,
      color BuyAboveColor_,double priceIn_,double PivotWeek_,double PivotDay_,int SupportWidth_,color SellBelowColor_,int SupportType_,bool ThresholdUp_,bool ThresholdDw_,
      bool visualThresUp_,bool visualThresDw_,color ThresholdColor_,color SupportColor_)
  {
   datetime Time5[1];
   CopyTime(Symbol(),PERIOD_D1,0,1,Time5);

Print(" S5Price_ ",S5Price_);
   if(S5Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R5")<0)
         ObjectCreate(0,pcode_+"R5", OBJ_HLINE, 0, Time5[0], S5Price_);
      else
         ObjectMove(0,pcode_+"R5",0,Time5[0],S5Price_);

      ObjectSetInteger(0,pcode_+"R5", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_HIDDEN, true);
     }

   if(R4Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R4")<0)
         ObjectCreate(0,pcode_+"R4", OBJ_HLINE, 0, Time5[0], R4Price_);
      else
         ObjectMove(0,pcode_+"R4",0,Time5[0],R4Price_);

      ObjectSetInteger(0,pcode_+"R4", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_HIDDEN, true);
     }

   if(R3Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R3")<0)
         ObjectCreate(0,pcode_+"R3", OBJ_HLINE, 0, Time5[0], R3Price_);
      else
         ObjectMove(0,pcode_+"R3",0,Time5[0],R3Price_);

      ObjectSetInteger(0,pcode_+"R3", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_HIDDEN, true);
     }

   if(R2Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R2")<0)
         ObjectCreate(0,pcode_+"R2", OBJ_HLINE, 0, Time5[0], R2Price_);
      else
         ObjectMove(0,pcode_+"R2",0,Time5[0],R2Price_);

      ObjectSetInteger(0,pcode_+"R2", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_HIDDEN, true);
     }

   if(R1Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R1")<0)
         ObjectCreate(0,pcode_+"R1", OBJ_HLINE, 0, Time5[0], R1Price_);
      else
         ObjectMove(0,pcode_+"R1",0,Time5[0],R1Price_);

      ObjectSetInteger(0,pcode_+"R1", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_HIDDEN, true);
     }

   if(BuyAbove_!=0)
     {
      if(ObjectFind(0,pcode_+"Compra Sopra")<0)
         ObjectCreate(0,pcode_+"Compra Sopra", OBJ_HLINE, 0, Time5[0], BuyAbove_);
      else
         ObjectMove(0,pcode_+"Compra Sopra",0,Time5[0],BuyAbove_);

      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_COLOR, BuyAboveColor_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_HIDDEN, true);
     }


   if(priceIn_!=0)
     {
      if(ObjectFind(0,pcode_+"Pivot Line")<0)
         ObjectCreate(0,pcode_+"Pivot Line", OBJ_HLINE, 0, Time5[0], priceIn_);
      else
         ObjectMove(0,pcode_+"Pivot Line",0,Time5[0],priceIn_);

      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_COLOR, clrTurquoise);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_HIDDEN, true);
     }

   if(PivotWeek_!=0)
     {
      if(ObjectFind(0,pcode_+"PivotW")<0)
         ObjectCreate(0,pcode_+"PivotW", OBJ_HLINE, 0, Time5[0], PivotWeek_);
      else
         ObjectMove(0,pcode_+"PivotW",0,Time5[0],PivotWeek_);

      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_HIDDEN, true);
     }

   if(PivotDay_!=0)
     {
      if(ObjectFind(0,pcode_+"PivotDay_")<0)
         ObjectCreate(0,pcode_+"PivotDay_", OBJ_HLINE, 0, Time5[0], PivotDay_);
      else
         ObjectMove(0,pcode_+"PivotDay_",0,Time5[0],PivotDay_);

      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_COLOR, clrPink);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_HIDDEN, true);
     }


   if(SellBelow_!=0)
     {
      if(ObjectFind(0,pcode_+"Vendi Sotto")<0)
         ObjectCreate(0,pcode_+"Vendi Sotto", OBJ_HLINE, 0, Time5[0], SellBelow_);
      else
         ObjectMove(0,pcode_+"Vendi Sotto",0,Time5[0],SellBelow_);

      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_COLOR, SellBelowColor_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }                                                      

   if(ThresholdUp_!=0&&visualThresUp_)
     {
      if(ObjectFind(0,pcode_+"Soglia Up")<0)
         ObjectCreate(0,pcode_+"Soglia Up", OBJ_HLINE, 0, Time5[0], ThresholdUp_);
      else
         ObjectMove(0,pcode_+"Soglia Up",0,Time5[0],ThresholdUp_);

      ObjectSetInteger(0,pcode_+"Soglia Up", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"Soglia Up", OBJPROP_COLOR, ThresholdColor_);
      ObjectSetInteger(0,pcode_+"Soglia Up", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"Soglia Up", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Soglia Up", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Soglia Up", OBJPROP_HIDDEN, true);
     }


   if(ThresholdDw_!=0&&visualThresDw_)
     {
      if(ObjectFind(0,pcode_+"Soglia Dw")<0)
         ObjectCreate(0,pcode_+"Soglia Dw", OBJ_HLINE, 0, Time5[0], ThresholdDw_);
      else
         ObjectMove(0,pcode_+"Soglia Dw",0,Time5[0],ThresholdDw_);

      ObjectSetInteger(0,pcode_+"Soglia Dw", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"Soglia Dw", OBJPROP_COLOR, ThresholdColor_);
      ObjectSetInteger(0,pcode_+"Soglia Dw", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"Soglia Dw", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Soglia Dw", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Soglia Dw", OBJPROP_HIDDEN, true);
     }


   if(S1Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S1")<0)
         ObjectCreate(0,pcode_+"S1", OBJ_HLINE, 0, Time5[0], S1Price_);
      else
         ObjectMove(0,pcode_+"S1",0,Time5[0],S1Price_);

      ObjectSetInteger(0,pcode_+"S1", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_HIDDEN, true);
     }

   if(S2Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S2")<0)
         ObjectCreate(0,pcode_+"S2", OBJ_HLINE, 0, Time5[0], S2Price_);
      else
         ObjectMove(0,pcode_+"S2",0,Time5[0],S2Price_);

      ObjectSetInteger(0,pcode_+"S2", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_HIDDEN, true);
     }

   if(S3Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S3")<0)
         ObjectCreate(0,pcode_+"S3", OBJ_HLINE, 0, Time5[0], S3Price_);
      else
         ObjectMove(0,pcode_+"S3",0,Time5[0],S3Price_);

      ObjectSetInteger(0,pcode_+"S3", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_HIDDEN, true);
     }

   if(S4Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S4")<0)
         ObjectCreate(0,pcode_+"S4", OBJ_HLINE, 0, Time5[0], S4Price_);
      else
         ObjectMove(0,pcode_+"S4",0,Time5[0],S4Price_);

      ObjectSetInteger(0,pcode_+"S4", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_HIDDEN, true);
     }

   if(S5Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S5")<0)
         ObjectCreate(0,pcode_+"S5", OBJ_HLINE, 0, Time5[0], S5Price_);
      else
         ObjectMove(0,pcode_+"S5",0,Time5[0],S5Price_);

      ObjectSetInteger(0,pcode_+"S5", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_HIDDEN, true);
     }
  }
//+------------------------------------------------------------------+
//|                      drawRectangleLine                           |
//+------------------------------------------------------------------+
void drawRectangleLine(double S5Price_, double S4Price_, double S3Price_, double S2Price_, double S1Price_, 
      double R5Price_, double R4Price_, double R3Price_, double R2Price_, double R1Price_, 
      double BuyAbove_, double SellBelow_,string pcode_,int ResistanceWidth_,color ResistanceColor_,int ResistanceType_,bool DrawBackground_,bool DisableSelection_,
      color BuyAboveColor_,double priceIn_,double PivotWeek_,double PivotDay_,int SupportWidth_,color SellBelowColor_,int SupportType_,bool ThresholdUp_,bool ThresholdDw_,
      bool visualThresUp_,bool visualThresDw_,color ThresholdColor_,color SupportColor_)
  {
   datetime time1,time2,Time5[1];

   Time5[0]=0;
   CopyTime(Symbol(),PERIOD_CURRENT,0,1,Time5);
   time1 = Time5[0]-(PeriodSeconds(Period())*50);

   CopyTime(Symbol(),Period(),0,1,Time5);
   time2 = Time5[0]+(PeriodSeconds(Period())*50);

   if(S5Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R5")<0)
         {ObjectCreate(0,pcode_+"R5", OBJ_TREND, 0, time1, S5Price_, time2, S5Price_);}
      else
        {
         ObjectMove(0,pcode_+"R5",0,time1,S5Price_);
         ObjectMove(0,pcode_+"R5",1,time2,S5Price_);
        }

      ObjectSetInteger(0,pcode_+"R5", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R5", OBJPROP_HIDDEN, true);
     }

   if(R4Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R4")<0)
        {
         ObjectCreate(0,pcode_+"R4", OBJ_TREND,0,time1,R4Price_,time2,R4Price_);

        }
      else
        {
         ObjectMove(0,pcode_+"R4",0,time1,R4Price_);
         ObjectMove(0,pcode_+"R4",1,time2,R4Price_);
        }

      ObjectSetInteger(0,pcode_+"R4", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R4", OBJPROP_HIDDEN, true);

     }

   if(R3Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R3")<0)
         ObjectCreate(0,pcode_+"R3", OBJ_TREND,0,time1,R3Price_,time2,R3Price_);
      else
        {
         ObjectMove(0,pcode_+"R3",0,time1,R3Price_);
         ObjectMove(0,pcode_+"R3",1,time2,R3Price_);
        }
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R3", OBJPROP_HIDDEN, true);

     }

   if(R2Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R2")<0)
         ObjectCreate(0,pcode_+"R2", OBJ_TREND,0,time1,R2Price_,time2,R2Price_);
      else
        {
         ObjectMove(0,pcode_+"R2",0,time1,R2Price_);
         ObjectMove(0,pcode_+"R2",1,time2,R2Price_);
        }

      ObjectSetInteger(0,pcode_+"R2", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R2", OBJPROP_HIDDEN, true);

     }

   if(R1Price_!=0)
     {
      if(ObjectFind(0,pcode_+"R1")<0)
         ObjectCreate(0,pcode_+"R1", OBJ_TREND,0,time1,R1Price_,time2,R1Price_);
      else
        {
         ObjectMove(0,pcode_+"R1",0,time1,R1Price_);
         ObjectMove(0,pcode_+"R1",1,time2,R1Price_);
        }

      ObjectSetInteger(0,pcode_+"R1", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_COLOR, ResistanceColor_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"R1", OBJPROP_HIDDEN, true);
     }

   if(BuyAbove_!=0)
     {
      if(ObjectFind(0,pcode_+"Compra Sopra")<0)
         ObjectCreate(0,pcode_+"Compra Sopra", OBJ_TREND,0,time1,BuyAbove_,time2,BuyAbove_);
      else
        {
         ObjectMove(0,pcode_+"Compra Sopra",0,time1,BuyAbove_);
         ObjectMove(0,pcode_+"Compra Sopra",1,time2,BuyAbove_);
        }

      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_COLOR, BuyAboveColor_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Compra Sopra", OBJPROP_HIDDEN, true);
     }

   if(priceIn_!=0)
     {
      if(ObjectFind(0,pcode_+"Pivot Line")<0)
         ObjectCreate(0,pcode_+"Pivot Line", OBJ_TREND,0,time1,priceIn_,time2,priceIn_);
      else
        {
         ObjectMove(0,pcode_+"Pivot Line",0,time1,priceIn_);
         ObjectMove(0,pcode_+"Pivot Line",1,time2,priceIn_);
        }

      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_COLOR, clrTurquoise);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Pivot Line", OBJPROP_HIDDEN, true);
     }


   if(PivotWeek_!=0)
     {
      if(ObjectFind(0,pcode_+"PivotW")<0)
         ObjectCreate(0,pcode_+"PivotW", OBJ_TREND,0,time1,PivotWeek_,time2,PivotWeek_);
      else
        {
         ObjectMove(0,pcode_+"PivotW",0,time1,PivotWeek_);
         ObjectMove(0,pcode_+"PivotW",1,time2,PivotWeek_);
        }

      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"PivotW", OBJPROP_HIDDEN, true);
     }

   if(PivotDay_!=0)
     {
      if(ObjectFind(0,pcode_+"PivotDay_")<0)
         ObjectCreate(0,pcode_+"PivotDay_", OBJ_TREND,0,time1,PivotDay_,time2,PivotDay_);
      else
        {
         ObjectMove(0,pcode_+"PivotDay_",0,time1,PivotDay_);
         ObjectMove(0,pcode_+"PivotDay_",1,time2,PivotDay_);
        }

      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_COLOR, clrPink);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"PivotDay_", OBJPROP_HIDDEN, true);
     }

   if(SellBelow_!=0)
     {
      if(ObjectFind(0,pcode_+"Vendi Sotto")<0)
         ObjectCreate(0,pcode_+"Vendi Sotto", OBJ_TREND,0,time1,SellBelow_,time2,SellBelow_);
      else
        {
         ObjectMove(0,pcode_+"Vendi Sotto",0,time1,SellBelow_);
         ObjectMove(0,pcode_+"Vendi Sotto",1,time2,SellBelow_);
        }

      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_COLOR, SellBelowColor_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Vendi Sotto", OBJPROP_HIDDEN, true);
     }


   if(ThresholdUp_!=0&&visualThresUp_)
     {
      if(ObjectFind(0,pcode_+"Threshold_Up")<0)
         ObjectCreate(0,pcode_+"Threshold_Up", OBJ_TREND,0,time1,ThresholdUp_,time2,ThresholdUp_);
      else
        {
         ObjectMove(0,pcode_+"Threshold_Up",0,time1,ThresholdUp_);
         ObjectMove(0,pcode_+"Threshold_Up",1,time2,ThresholdUp_);
        }

      ObjectSetInteger(0,pcode_+"Threshold_Up", OBJPROP_WIDTH, ResistanceWidth_);
      ObjectSetInteger(0,pcode_+"Threshold_Up", OBJPROP_COLOR, ThresholdColor_);
      ObjectSetInteger(0,pcode_+"Threshold_Up", OBJPROP_STYLE, ResistanceType_);
      ObjectSetInteger(0,pcode_+"Threshold_Up", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Threshold_Up", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Threshold_Up", OBJPROP_HIDDEN, true);
     }

   if(ThresholdDw_!=0&&visualThresDw_)
     {
      if(ObjectFind(0,pcode_+"Threshold_Dw")<0)
         ObjectCreate(0,pcode_+"Threshold_Dw", OBJ_TREND,0,time1,ThresholdDw_,time2,ThresholdDw_);
      else
        {
         ObjectMove(0,pcode_+"Threshold_Dw",0,time1,ThresholdDw_);
         ObjectMove(0,pcode_+"Threshold_Dw",1,time2,ThresholdDw_);
        }

      ObjectSetInteger(0,pcode_+"Threshold_Dw", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"Threshold_Dw", OBJPROP_COLOR, ThresholdColor_);
      ObjectSetInteger(0,pcode_+"Threshold_Dw", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"Threshold_Dw", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"Threshold_Dw", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"Threshold_Dw", OBJPROP_HIDDEN, true);
     }


   if(S1Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S1")<0)
         ObjectCreate(0,pcode_+"S1", OBJ_TREND,0,time1,S1Price_,time2,S1Price_);
      else
        {
         ObjectMove(0,pcode_+"S1",0,time1,S1Price_);
         ObjectMove(0,pcode_+"S1",1,time2,S1Price_);
        }
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S1", OBJPROP_HIDDEN, true);
     }

   if(S2Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S2")<0)
         ObjectCreate(0,pcode_+"S2", OBJ_TREND,0,time1,S2Price_,time2,S2Price_);
      else
        {
         ObjectMove(0,pcode_+"S2",0,time1,S2Price_);
         ObjectMove(0,pcode_+"S2",1,time2,S2Price_);
        }

      ObjectSetInteger(0,pcode_+"S2", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S2", OBJPROP_HIDDEN, true);

     }

   if(S3Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S3")<0)
         ObjectCreate(0,pcode_+"S3", OBJ_TREND,0,time1,S3Price_,time2,S3Price_);
      else
        {
         ObjectMove(0,pcode_+"S3",0,time1,S3Price_);
         ObjectMove(0,pcode_+"S3",1,time2,S3Price_);
        }

      ObjectSetInteger(0,pcode_+"S3", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S3", OBJPROP_HIDDEN, true);


     }

   if(S4Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S4")<0)
         ObjectCreate(0,pcode_+"S4", OBJ_TREND,0,time1,S4Price_,time2,S4Price_);
      else
        {
         ObjectMove(0,pcode_+"S4",0,time1,S4Price_);
         ObjectMove(0,pcode_+"S4",1,time2,S4Price_);
        }

      ObjectSetInteger(0,pcode_+"S4", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S4", OBJPROP_HIDDEN, true);


     }

   if(S5Price_!=0)
     {
      if(ObjectFind(0,pcode_+"S5")<0)
        {
         ObjectCreate(0,pcode_+"S5", OBJ_TREND,0,time1,S5Price_,time2,S5Price_);
        }
      else
        {
         ObjectMove(0,pcode_+"S5",0,time1,S5Price_);
         ObjectMove(0,pcode_+"S5",1,time2,S5Price_);
        }

      ObjectSetInteger(0,pcode_+"S5", OBJPROP_WIDTH, SupportWidth_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_COLOR, SupportColor_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_STYLE, SupportType_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_BACK, DrawBackground_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_SELECTABLE, !DisableSelection_);
      ObjectSetInteger(0,pcode_+"S5", OBJPROP_HIDDEN, true);

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void writeLineName(bool ShowLineName_,double S5Price_, double S4Price_, double S3Price_, double S2Price_, double S1Price_, 
      double R5Price_, double R4Price_, double R3Price_, double R2Price_, double R1Price_, 
      double BuyAbove_, double SellBelow_,string pcode_,int ResistanceWidth_,color ResistanceColor_,int ResistanceType_,bool DrawBackground_,bool DisableSelection_,
      color BuyAboveColor_,double priceIn_,double PivotWeek_,double PivotDay_,int SupportWidth_,color SellBelowColor_,int SupportType_,bool ThresholdUp_,bool ThresholdDw_,
      bool visualThresUp_,bool visualThresDw_,color ThresholdColor_,color SupportColor_)
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

   if(ShowLineName_)
     {
      if(S5Price_!=0)
        {
         if(ObjectFind(0,pcode_+"R5T")<0)
           {
            ObjectCreate(0,pcode_+"R5T", OBJ_TEXT,0,time2,S5Price_);
            ObjectSetString(0,pcode_+"R5T",OBJPROP_TEXT,pcode_+"R5 "+DoubleToString(NormalizeDouble(S5Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"R5T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"R5T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"R5T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"R5T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"R5T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"R5T",0,time2,S5Price_);
            ObjectSetString(0,pcode_+"R5T",OBJPROP_TEXT,pcode_+"R5 "+DoubleToString(NormalizeDouble(S5Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"R5T",OBJPROP_COLOR,ResistanceColor_);
        }

      if(R4Price_!=0)
        {
         if(ObjectFind(0,pcode_+"R4T")<0)
           {
            ObjectCreate(0,pcode_+"R4T", OBJ_TEXT,0,time2,R4Price_);
            ObjectSetString(0,pcode_+"R4T",OBJPROP_TEXT,pcode_+"R4 "+DoubleToString(NormalizeDouble(R4Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"R4T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"R4T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"R4T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"R4T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"R4T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"R4T",0,time2,R4Price_);
            ObjectSetString(0,pcode_+"R4T",OBJPROP_TEXT,pcode_+"R4 "+DoubleToString(NormalizeDouble(R4Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"R4T",OBJPROP_COLOR,ResistanceColor_);
        }

      if(R3Price_!=0)
        {
         if(ObjectFind(0,pcode_+"R3T")<0)
           {
            ObjectCreate(0,pcode_+"R3T", OBJ_TEXT,0,time2,R3Price_);
            ObjectSetString(0,pcode_+"R3T",OBJPROP_TEXT,pcode_+"R3 "+DoubleToString(NormalizeDouble(R3Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"R3T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"R3T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"R3T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"R3T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"R3T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"R3T",0,time2,R3Price_);
            ObjectSetString(0,pcode_+"R3T",OBJPROP_TEXT,pcode_+"R3 "+DoubleToString(NormalizeDouble(R3Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"R3T",OBJPROP_COLOR,ResistanceColor_);
        }

      if(R2Price_!=0)
        {
         if(ObjectFind(0,pcode_+"R2T")<0)
           {
            ObjectCreate(0,pcode_+"R2T", OBJ_TEXT,0,time2,R2Price_);
            ObjectSetString(0,pcode_+"R2T",OBJPROP_TEXT,pcode_+"R2 "+DoubleToString(NormalizeDouble(R2Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"R2T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"R2T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"R2T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"R2T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"R2T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"R2T",0,time2,R2Price_);
            ObjectSetString(0,pcode_+"R2T",OBJPROP_TEXT,pcode_+"R2 "+DoubleToString(NormalizeDouble(R2Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"R2T",OBJPROP_COLOR,ResistanceColor_);
        }

      if(R1Price_!=0)
        {
         if(ObjectFind(0,pcode_+"R1T")<0)
           {
            ObjectCreate(0,pcode_+"R1T", OBJ_TEXT,0,time2,R1Price_);
            ObjectSetString(0,pcode_+"R1T",OBJPROP_TEXT,pcode_+"R1 "+DoubleToString(NormalizeDouble(R1Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"R1T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"R1T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"R1T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"R1T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"R1T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"R1T",0,time2,R1Price_);
            ObjectSetString(0,pcode_+"R1T",OBJPROP_TEXT,pcode_+"R1 "+DoubleToString(NormalizeDouble(R1Price_,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode_+"R1T",OBJPROP_COLOR,ResistanceColor_);
        }
      if(BuyAbove_!=0)
        {
         if(ObjectFind(0,pcode_+"Buy_Above")<0)
           {
            ObjectCreate(0,pcode_+"Buy_Above", OBJ_TEXT,0,time2,BuyAbove_);
            ObjectSetString(0,pcode_+"Buy_Above",OBJPROP_TEXT,pcode_+"Buy_Above"+DoubleToString(NormalizeDouble(BuyAbove_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"Buy_Above",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"Buy_Above",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"Buy_Above",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"Buy_Above",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"Buy_Above",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"Buy_Above",0,time2,BuyAbove_);
            ObjectSetString(0,pcode_+"Buy_Above",OBJPROP_TEXT,pcode_+"Buy_Above  "+DoubleToString(NormalizeDouble(BuyAbove_,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode_+"Buy_Above",OBJPROP_COLOR,BuyAboveColor_);
        }
      if(priceIn_!=0)
        {
         if(ObjectFind(0,pcode_+"Pivot")<0)
           {
            ObjectCreate(0,pcode_+"Pivot", OBJ_TEXT,0,time2,priceIn_);
            ObjectSetString(0,pcode_+"Pivot",OBJPROP_TEXT,pcode_+"Pivot"+DoubleToString(NormalizeDouble(priceIn_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"Pivot",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"Pivot",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"Pivot",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"Pivot",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"Pivot",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"Pivot",0,time2,priceIn_);
            ObjectSetString(0,pcode_+"Pivot",OBJPROP_TEXT,pcode_+"Pivot  "+DoubleToString(NormalizeDouble(priceIn_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"Pivot",OBJPROP_COLOR,clrTurquoise);
        }
      if(PivotWeek_!=0)
        {
         if(ObjectFind(0,pcode_+"PivotWeek_")<0)
           {
            ObjectCreate(0,pcode_+"PivotWeek_", OBJ_TEXT,0,time2,PivotWeek_);
            ObjectSetString(0,pcode_+"PivotWeek_",OBJPROP_TEXT,pcode_+"PivotWeek_"+DoubleToString(NormalizeDouble(PivotWeek_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"PivotWeek_",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"PivotWeek_",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"PivotWeek_",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"PivotWeek_",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"PivotWeek_",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"PivotWeek_",0,time2,PivotWeek_);
            ObjectSetString(0,pcode_+"PivotWeek_",OBJPROP_TEXT,pcode_+"PivotWeek_ "+DoubleToString(NormalizeDouble(PivotWeek_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"PivotWeek_",OBJPROP_COLOR,clrYellow);
        }

      if(PivotDay_!=0)
        {
         if(ObjectFind(0,pcode_+"PivotD")<0)
           {
            ObjectCreate(0,pcode_+"PivotD", OBJ_TEXT,0,time2,PivotDay_);
            ObjectSetString(0,pcode_+"PivotD",OBJPROP_TEXT,pcode_+"PivotD"+DoubleToString(NormalizeDouble(PivotDay_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"PivotD",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"PivotD",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"PivotD",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"PivotD",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"PivotD",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"PivotD",0,time2,PivotDay_);
            ObjectSetString(0,pcode_+"PivotD",OBJPROP_TEXT,pcode_+"PivotDay_ "+DoubleToString(NormalizeDouble(PivotDay_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"PivotD",OBJPROP_COLOR,clrPink);
        }
      if(SellBelow_!=0)
        {
         if(ObjectFind(0,pcode_+"Sell_Below")<0)
           {
            ObjectCreate(0,pcode_+"Sell_Below", OBJ_TEXT,0,time2,SellBelow_);
            ObjectSetString(0,pcode_+"Sell_Below",OBJPROP_TEXT,pcode_+"Sell_Below"+DoubleToString(NormalizeDouble(SellBelow_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"Sell_Below",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"Sell_Below",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"Sell_Below",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"Sell_Below",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"Sell_Below",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"Sell_Below",0,time2,SellBelow_);
            ObjectSetString(0,pcode_+"Sell_Below",OBJPROP_TEXT,pcode_+"Sell_Below  "+DoubleToString(NormalizeDouble(SellBelow_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"Sell_Below",OBJPROP_COLOR,SellBelowColor_);
        }
      if(ThresholdUp_!=0&&visualThresUp_)
        {
         if(ObjectFind(0,pcode_+"Threshold_Up ")<0)
           {
            ObjectCreate(0,pcode_+"Threshold_Up ", OBJ_TEXT,0,time2,ThresholdUp_);
            ObjectSetString(0,pcode_+"Threshold_Up ",OBJPROP_TEXT,pcode_+"Threshold_Up  "+DoubleToString(NormalizeDouble(ThresholdUp_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"Threshold_Up ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"Threshold_Up ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"Threshold_Up ",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"Threshold_Up ",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"Threshold_Up ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"Threshold_Up ",0,time2,ThresholdUp_);
            ObjectSetString(0,pcode_+"Threshold_Up ",OBJPROP_TEXT,pcode_+"Threshold_Up  "+DoubleToString(NormalizeDouble(ThresholdUp_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"Threshold_Up ",OBJPROP_COLOR,ThresholdColor_);
        }
      if(ThresholdDw_!=0&&visualThresDw_)
        {
         if(ObjectFind(0,pcode_+"Threshold_Dw ")<0)
           {
            ObjectCreate(0,pcode_+"Threshold_Dw ", OBJ_TEXT,0,time2,ThresholdDw_);
            ObjectSetString(0,pcode_+"Threshold_Dw ",OBJPROP_TEXT,pcode_+"Threshold_Dw  "+DoubleToString(NormalizeDouble(ThresholdDw_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"Threshold_Dw ",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"Threshold_Dw ",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"Threshold_Dw ",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"Threshold_Dw ",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"Threshold_Dw ",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"Threshold_Dw ",0,time2,ThresholdDw_);
            ObjectSetString(0,pcode_+"Threshold_Dw ",OBJPROP_TEXT,pcode_+"Threshold_Dw  "+DoubleToString(NormalizeDouble(ThresholdDw_,Digits()),Digits()));
           }

         ObjectSetInteger(0,pcode_+"Threshold_Dw ",OBJPROP_COLOR,ThresholdColor_);
        }
      if(S1Price_!=0)
        {
         if(ObjectFind(0,pcode_+"S1T")<0)
           {
            ObjectCreate(0,pcode_+"S1T", OBJ_TEXT,0,time2,S1Price_);
            ObjectSetString(0,pcode_+"S1T",OBJPROP_TEXT,pcode_+"S1 "+DoubleToString(NormalizeDouble(S1Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"S1T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"S1T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"S1T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"S1T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"S1T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"S1T",0,time2,S1Price_);
            ObjectSetString(0,pcode_+"S1T",OBJPROP_TEXT,pcode_+"S1 "+DoubleToString(NormalizeDouble(S1Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"S1T",OBJPROP_COLOR,SupportColor_);
        }
      if(S2Price_!=0)
        {
         if(ObjectFind(0,pcode_+"S2T")<0)
           {
            ObjectCreate(0,pcode_+"S2T", OBJ_TEXT,0,time2,S2Price_);
            ObjectSetString(0,pcode_+"S2T",OBJPROP_TEXT,pcode_+"S2 "+DoubleToString(NormalizeDouble(S2Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"S2T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"S2T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"S2T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"S2T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"S2T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"S2T",0,time2,S2Price_);
            ObjectSetString(0,pcode_+"S2T",OBJPROP_TEXT,pcode_+"S2 "+DoubleToString(NormalizeDouble(S2Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"S2T",OBJPROP_COLOR,SupportColor_);
        }
      if(S3Price_!=0)
        {
         if(ObjectFind(0,pcode_+"S3T")<0)
           {
            ObjectCreate(0,pcode_+"S3T", OBJ_TEXT,0,time2,S3Price_);
            ObjectSetString(0,pcode_+"S3T",OBJPROP_TEXT,pcode_+"S3 "+DoubleToString(NormalizeDouble(S3Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"S3T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"S3T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"S3T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"S3T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"S3T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"S3T",0,time2,S3Price_);
            ObjectSetString(0,pcode_+"S3T",OBJPROP_TEXT,pcode_+"S3 "+DoubleToString(NormalizeDouble(S3Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"S3T",OBJPROP_COLOR,SupportColor_);
        }
      if(S4Price_!=0)
        {
         if(ObjectFind(0,pcode_+"S4T")<0)
           {
            ObjectCreate(0,pcode_+"S4T", OBJ_TEXT,0,time2,S4Price_);
            ObjectSetString(0,pcode_+"S4T",OBJPROP_TEXT,pcode_+"S4 "+DoubleToString(NormalizeDouble(S4Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"S4T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"S4T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"S4T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"S4T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"S4T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"S4T",0,time2,S4Price_);
            ObjectSetString(0,pcode_+"S4T",OBJPROP_TEXT,pcode_+"S4 "+DoubleToString(NormalizeDouble(S4Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"S4T",OBJPROP_COLOR,SupportColor_);
        }
      if(S5Price_!=0)
        {
         if(ObjectFind(0,pcode_+"S5T")<0)
           {
            ObjectCreate(0,pcode_+"S5T", OBJ_TEXT,0,time2,S5Price_);
            ObjectSetString(0,pcode_+"S5T",OBJPROP_TEXT,pcode_+"S5 "+DoubleToString(NormalizeDouble(S5Price_,Digits()),Digits()));
            ObjectSetString(0,pcode_+"S5T",OBJPROP_FONT,"Arial");
            ObjectSetInteger(0,pcode_+"S5T",OBJPROP_FONTSIZE,8);
            ObjectSetInteger(0,pcode_+"S5T",OBJPROP_BACK,DrawBackground_);
            ObjectSetInteger(0,pcode_+"S5T",OBJPROP_SELECTABLE,!DisableSelection_);
            ObjectSetInteger(0,pcode_+"S5T",OBJPROP_HIDDEN,true);
           }
         else
           {
            ObjectMove(0,pcode_+"S5T",0,time2,S5Price_);
            ObjectSetString(0,pcode_+"S5T",OBJPROP_TEXT,pcode_+"S5 "+DoubleToString(NormalizeDouble(S5Price_,Digits()),Digits()));
           }
         ObjectSetInteger(0,pcode_+"S5T",OBJPROP_COLOR,SupportColor_);
        }
     }
  }
/*
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
   string message=Symbol()+" ("+DoubleToString(price)+"), the price arrived at "+pcode_+point;
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
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void clearObj(double S5Price_, double S4Price_, double S3Price_, double S2Price_, double S1Price_, 
      double R5Price_, double R4Price_, double R3Price_, double R2Price_, double R1Price_, 
      double BuyAbove_, double SellBelow_,string pcode_,int ResistanceWidth_,color ResistanceColor_,int ResistanceType_,bool DrawBackground_,bool DisableSelection_,
      color BuyAboveColor_,double priceIn_,double PivotWeek_,double PivotDay_,int SupportWidth_,color SellBelowColor_,int SupportType_,bool ThresholdUp_,bool ThresholdDw_,
      bool visualThresUp_,bool visualThresDw_,color ThresholdColor_,color SupportColor_)
  {
   if(ObjectFind(0,pcode_+"R5")>=0)ObjectDelete(0,pcode_+"R5");
   if(ObjectFind(0,pcode_+"R4")>=0)ObjectDelete(0,pcode_+"R4");
   if(ObjectFind(0,pcode_+"R3")>=0)ObjectDelete(0,pcode_+"R3");
   if(ObjectFind(0,pcode_+"R2")>=0)ObjectDelete(0,pcode_+"R2");
   if(ObjectFind(0,pcode_+"R1")>=0)ObjectDelete(0,pcode_+"R1");
   if(ObjectFind(0,pcode_+"RD3")>=0)ObjectDelete(0,pcode_+"RD3");
   if(ObjectFind(0,pcode_+"RD2")>=0)ObjectDelete(0,pcode_+"RD2");
   if(ObjectFind(0,pcode_+"RD1")>=0)ObjectDelete(0,pcode_+"RD1");
   if(ObjectFind(0,pcode_+"rD3")>=0)ObjectDelete(0,pcode_+"rD3");
   if(ObjectFind(0,pcode_+"rD2")>=0)ObjectDelete(0,pcode_+"rD2");
   if(ObjectFind(0,pcode_+"rD1")>=0)ObjectDelete(0,pcode_+"rD1");
   if(ObjectFind(0,pcode_+"S1")>=0)ObjectDelete(0,pcode_+"S1");
   if(ObjectFind(0,pcode_+"S2")>=0)ObjectDelete(0,pcode_+"S2");
   if(ObjectFind(0,pcode_+"S3")>=0)ObjectDelete(0,pcode_+"S3");
   if(ObjectFind(0,pcode_+"S4")>=0)ObjectDelete(0,pcode_+"S4");
   if(ObjectFind(0,pcode_+"S5")>=0)ObjectDelete(0,pcode_+"S5");
   if(ObjectFind(0,pcode_+"R5T")>=0)ObjectDelete(0,pcode_+"R5T");
   if(ObjectFind(0,pcode_+"R4T")>=0)ObjectDelete(0,pcode_+"R4T");
   if(ObjectFind(0,pcode_+"R3T")>=0)ObjectDelete(0,pcode_+"R3T");
   if(ObjectFind(0,pcode_+"R2T")>=0)ObjectDelete(0,pcode_+"R2T");
   if(ObjectFind(0,pcode_+"R1T")>=0)ObjectDelete(0,pcode_+"R1T");
   if(ObjectFind(0,pcode_+"Buy_Above")>=0)ObjectDelete(0,pcode_+"Buy_Above");

//   if(ObjectFind(0,pcode_+"BuyT")>=0)
//      ObjectDelete(0,pcode_+"BuyT");

   if(ObjectFind(0,pcode_+"Compra Sopra")>=0)ObjectDelete(0,pcode_+"Compra Sopra");
   if(ObjectFind(0,pcode_+"Pivot Line")>=0)ObjectDelete(0,pcode_+"Pivot Line");
   if(ObjectFind(0,pcode_+"PivotW")>=0)ObjectDelete(0,pcode_+"PivotW");
   if(ObjectFind(0,pcode_+"PivotWeek_")>=0)ObjectDelete(0,pcode_+"PivotWeek_");
   if(ObjectFind(0,pcode_+"PivotDay_")>=0)ObjectDelete(0,pcode_+"PivotDay_");
   if(ObjectFind(0,pcode_+"PivotD")>=0)ObjectDelete(0,pcode_+"PivotD");
   if(ObjectFind(0,pcode_+"Vendi Sotto")>=0)ObjectDelete(0,pcode_+"Vendi Sotto");
   if(ObjectFind(0,pcode_+"Pivot")>=0)ObjectDelete(0,pcode_+"Pivot");
   if(ObjectFind(0,pcode_+"Sell_Below")>=0)ObjectDelete(0,pcode_+"Sell_Below");
   if(ObjectFind(0,pcode_+"Threshold_Dw")>=0)ObjectDelete(0,pcode_+"Threshold_Dw");  
   if(ObjectFind(0,pcode_+"Threshold_Dw  ")>=0)ObjectDelete(0,pcode_+"Threshold_Dw  ");     
   if(ObjectFind(0,pcode_+"Threshold_Dw ")>=0)ObjectDelete(0,pcode_+"Threshold_Dw ");  
   if(ObjectFind(0,pcode_+"Soglia Dw")>=0)ObjectDelete(0,pcode_+"Soglia Dw");
   if(ObjectFind(0,pcode_+"Soglia Up")>=0)ObjectDelete(0,pcode_+"Soglia Up");

   if(ObjectFind(0,pcode_+"Threshold_Up")>=0)ObjectDelete(0,pcode_+"Threshold_Up");  
   if(ObjectFind(0,pcode_+"Threshold_Up  ")>=0)ObjectDelete(0,pcode_+"Threshold_Up  ");            
   if(ObjectFind(0,pcode_+"Threshold_Up ")>=0)ObjectDelete(0,pcode_+"Threshold_Up ");  
   if(ObjectFind(0,pcode_+"PPT")>=0)ObjectDelete(0,pcode_+"PPT");
   if(ObjectFind(0,pcode_+"S1T")>=0)ObjectDelete(0,pcode_+"S1T");
   if(ObjectFind(0,pcode_+"S2T")>=0)ObjectDelete(0,pcode_+"S2T");
   if(ObjectFind(0,pcode_+"S3T")>=0)ObjectDelete(0,pcode_+"S3T");
   if(ObjectFind(0,pcode_+"S4T")>=0)ObjectDelete(0,pcode_+"S4T");
   if(ObjectFind(0,pcode_+"S5T")>=0)ObjectDelete(0,pcode_+"S5T");
   if(ObjectFind(0,pcode_+"SD3")>=0)ObjectDelete(0,pcode_+"SD3");
   if(ObjectFind(0,pcode_+"SD2")>=0)ObjectDelete(0,pcode_+"SD2");
   if(ObjectFind(0,pcode_+"SD1")>=0)ObjectDelete(0,pcode_+"SD1");
   if(ObjectFind(0,pcode_+"sD3")>=0)ObjectDelete(0,pcode_+"sD3");
   if(ObjectFind(0,pcode_+"sD2")>=0)ObjectDelete(0,pcode_+"sD2");
   if(ObjectFind(0,pcode_+"sD1")>=0)ObjectDelete(0,pcode_+"sD1");
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
      price = NormalizeDouble(priceIn_,Digits());
     }
   return priceIn_;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GannObj::GannObj(double S5Price_, double S4Price_, double S3Price_, double S2Price_, double S1Price_, 
      double R5Price_, double R4Price_, double R3Price_, double R2Price_, double R1Price_, 
      double BuyAbove_, double SellBelow_,int Divis_,
      double _inputPrice, int _inputDigit, double _currentPrice,  int _outputDigit)
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
   BuyAbove_ = buyAbove / DIv_(Divis_);
   sellBelow = (C10!=0) ? D10 : (C8!=0) ? C9 : (D7!=0) ? C7 : (F7!=0) ? E7 : (G8!=0) ? G7 : (G10!=0) ? G9 : (F11!=0) ? G11 : (D11!=0) ? E11 : (B11!=0) ? C11 : (B8!=0) ? B9 : (C6!=0) ? B6 : (F6!=0) ? E6 : (H7!=0) ? H6 : (H10!=0) ? H9 : (G12!=0) ? H12 : (D12!=0) ? E12 : 0;
   SellBelow_ = sellBelow / DIv_(Divis_);

   R1Price_=buyTarget1 = resistance1 * 0.9995 / DIv_(Divis_);
   R2Price_=buyTarget2 = resistance2 * 0.9995 / DIv_(Divis_);
   R3Price_=buyTarget3 = resistance3 * 0.9995 / DIv_(Divis_);
   R4Price_=buyTarget4 = resistance4 * 0.9995 / DIv_(Divis_);
   S5Price_=buyTarget5 = resistance5 * 0.9995 / DIv_(Divis_);

   S1Price_=sellTarget1 = support1 * 1.0005 / DIv_(Divis_);
   S2Price_=sellTarget2 = support2 * 1.0005 / DIv_(Divis_);
   S3Price_=sellTarget3 = support3 * 1.0005 / DIv_(Divis_);
   S4Price_=sellTarget4 = support4 * 1.0005 / DIv_(Divis_);
   S5Price_=sellTarget5 = support5 * 1.0005 / DIv_(Divis_);

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
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK && sparam==buttonID_)
     {
      clearObj();
      if(ObjectGetInteger(0,buttonID_,OBJPROP_BGCOLOR)==clrRed)
        {
         ObjectSetInteger(0,buttonID_,OBJPROP_BGCOLOR,clrGreen);
         showGann=0;
        }
      else
        {
         ObjectSetInteger(0,buttonID_,OBJPROP_BGCOLOR,clrRed);
         showGann=1;
        }
      GlobalVariableSet(chartiD+"-"+"showGann",showGann);
      ObjectSetInteger(0,buttonID_,OBJPROP_STATE,0);
      ChartRedraw();
     }
  }
*/    