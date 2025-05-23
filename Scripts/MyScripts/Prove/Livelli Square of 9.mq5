//+------------------------------------------------------------------+
//|                                          Livelli Square of 9.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

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
   LowPrevDay       = 8,         //Minimum of the previous day
   HiLoZigZag       = 9,        //Last High/Low of Zig Zag indicator 
};




string pcode="Square 9 ";
double priceW;
int GannInputDigit_=0;
double priceIn = 0.0;
double R1Price,R2Price,R3Price,R4Price,R5Price;
double S1Price,S2Price,S3Price,S4Price,S5Price;

double sD1;
double rD1;
double sD2;
double rD2;
double sD3;
double rD3;



input bool         ShortLines          = true;
input bool         ShowLineName        = true;
input AlertType    Alert1              = 0;
 //AlertType    Alert1              = 0;
input AlertType    Alert2              = 0;
 //AlertType    Alert2              = 0;
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
input bool         ButtonEnable        = false;
input int          XDistance           = 250;
input int          YDistance           = 5;
input int          Width               = 100;
input int          Hight               = 30;
input string       Label               = " ";

input string   comment_IS =            "--- SQUARE of 9 LEVELS SETTINGS ---";   // --- SQUARE of 9 LEVELS SETTINGS ---

input string   comment_CS9 =            "-- CALIBRATION LEVELS --";   //  -- CALIBRATION LEVELS --
input GannInput    GannInputDigit      = 4;              //Number of price digits used: Calibration
input Divisione    Divis               = 0;              //Multiplication / Division of digits: Calibration

input PriceType    GannInputType       = 5;              //Type of Input in Calculation
input string       GannCustomPrice     = "1.00000";
//input PivD_SR_Sqnine  PivotDaily       = 0;              //On the chart: Pivot Daily or Resistances/Supports Sq 9
int  PivotDaily       = 0;              //On the chart: Pivot Daily or Resistances/Supports Sq 9
input PriceTypeW   TypePivW            = 2;              //Pivot Weekly type
input input_ruota_   input_ruota       = 1;              //Advanced Formula Levels / Levels Square of 9
input virgola_increm virg_increm       = 0;              //Multiply/Divisor for Advanced Formula
input virgola_asset_ virgola_asset     = 1;              //Decimal figure considered for Advanced Formula Calculation
input gradi_ciclo  gradi_Ciclo         = 0;              //Advanced Formula Angles: 360°/270°/180°/90°


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
  }
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

   gradi_cicli();

// virgola_coeff();

   double LowP[1];
   CopyLow(Symbol(),PERIOD_D1,1,1,LowP);

   double HighP[1];
   CopyHigh(Symbol(),PERIOD_D1,1,1,HighP);

   int f=Digits();

   double vent = (int)(prezzoPivot * rende_intero(f-virgola_asset) / 24) * 24 / rende_intero(f-virgola_asset)  ;

   double incremento_ruota = 24 / virgola_increm_(virg_increm) * gradi_cicli();

   if(input_ruota== 0)
      {coeff_ruota=24*gra_clcl*virgola_coeff();} //input ruota "24": 24 * gradi * virgola asset

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

   else

     {
      buyAbove   = vent+incremento_ruota;
      buyTarget1 = buyAbove+incremento_ruota;
      buyTarget2 = buyTarget1+incremento_ruota;
      buyTarget3 = buyTarget2+incremento_ruota;
      buyTarget4 = buyTarget3+incremento_ruota;
      buyTarget5 = buyTarget4+incremento_ruota;

      sellBelow   = vent;
      sellTarget1 = sellBelow  -incremento_ruota;
      sellTarget2 = sellTarget1-incremento_ruota;
      sellTarget3 = sellTarget2-incremento_ruota;
      sellTarget4 = sellTarget3-incremento_ruota;
      sellTarget5 = sellTarget4-incremento_ruota;
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
}     }