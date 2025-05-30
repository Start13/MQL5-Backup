//+------------------------------------------------------------------+
//|                               Gann Pivots da incollare in EA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
void OnStart()
{}
/*

////////////////////// CODICI PRESI DA Zigulì + Sq 9v1.3.mq5 /////////////////////////

/////////////////// Incollare in enum //////////////////////
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
  
//////////////////// Incollare negl'Input ///////////////////////
input string   comment_Square9   =   "--- Filtro Square of 9 Gann ---";   // --- Filtro Square of 9 Gann ---
input bool     FilterSq9         =   false;     //Filtro Square of 9 Gann  

input string     comment_SQ9         = "-- CALIBRATION SQUARE of 9 --";   //  -- CALIBRATION SQUARE of 9 -- 
input PriceType  GannInputType       = 9;         //Type di Input Square of 9
input string     GannCustomPrice     = "1.00000"; //Prezzo Custom
input GannInput  GannInputDigit      = 4;         //Number of price digits used: Calibration
input Divisione  Divis               = 0;         //Multiplication / Division of digits: Calibration
  
input PriceTypeD             PriceTypeD_                     = 3;         //Pivot Daily Type /2 o /3
input PriceTypeW             TypePivW                        = 2;         //Pivot Weekly Type /2 o /3

input input_ruota_           input_ruota                     = 1;         //Advanced Formula Levels / Levels Square of 9
input PeriodoPrecRuota       PeriodoPrecRuota_               = 1;         //Period after for Route 24
input gradi_ciclo            gradi_Ciclo                     = 0;         //Advanced Formula Angles: 360°/270°/180°/90°

input string     CommentStyle        = "--- Style Settings SQ 9 ---";
input bool       ShortLines          = true;
input bool       ShowLineName        = true;
input int        Alert1              = 0;
input int        Alert2              = 0;
input int        PipDeviation        = 0;
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
 
//////////////////// Incollare nelle Variabili Globali /////////////////
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

double ValZZ[100];
int IndexZZ[100];

/////////////////// Incollare in OnInit() ////////////////////////
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
   
///////////////// Incollare in OnTick() ///////////////////
if(shortLines)DRawRectangleLine(timesogliasup,timesogliainf);
else DRawHorizontalLevel();
WRiteLineName();

//////////////// Incollare in OnTick o nella funzione desiderata //////////////////////
if(GannInputType==0)  arrPric[0] = iOpen(Symbol(),PERIOD_D1,1);
if(GannInputType==1)  arrPric[0] = iLow(Symbol(),PERIOD_D1,1);
if(GannInputType==2)  arrPric[0] = iHigh(Symbol(),PERIOD_D1,1);
if(GannInputType==3)  arrPric[0] = iClose(Symbol(),PERIOD_D1,1);

if(GannInputType==4)  arrPric[0] = PivotDaily(PriceTypeD_);
if(GannInputType==5)  arrPric[0] = PivotWeekly(TypePivW);
if(GannInputType==6)  arrPric[0] = StringToDouble(GannCustomPrice);

if(GannInputType==7)  arrPric[0] = ValZZ[0];
if(GannInputType==8)
{
if(tipopiccozigzag(ValZZ[0],IndexZZ[0],timeFrCand)=="Up" && tipoDiCandelaN(IndexZZ[0])=="Buy")  arrPric[0]=iClose(Symbol(),timeFrCand,IndexZZ[0]);
if(tipopiccozigzag(ValZZ[0],IndexZZ[0],timeFrCand)=="Up" && tipoDiCandelaN(IndexZZ[0])=="Sell") arrPric[0]=iOpen(Symbol(),timeFrCand,IndexZZ[0]);

if(tipopiccozigzag(ValZZ[0],IndexZZ[0],timeFrCand)=="Dw" && tipoDiCandelaN(IndexZZ[0])=="Buy")  arrPric[0]=iOpen(Symbol(),timeFrCand,IndexZZ[0]);
if(tipopiccozigzag(ValZZ[0],IndexZZ[0],timeFrCand)=="Dw" && tipoDiCandelaN(IndexZZ[0])=="Sell") arrPric[0]=iClose(Symbol(),timeFrCand,IndexZZ[0]);
}
if(GannInputType==9) arrPric[0] = ultimoshadow_bodygiornoprecedente(0);
if(GannInputType==10) arrPric[0] = ultimoshadow_bodygiornoprecedente(1);


if(FilterSq9)SqNine(arrPric,arrStrin,arrInter,arrBol,arrCol); 


// Filtro enable Ordini //
   && filtroSq9("Buy",arrPric)
   && filtroSq9("Sell",arrPric)   

/////////////////////// Incollare nelle Funzioni ///////////////////////
//+------------------------------------------------------------------+
//|                        filtroSq9()                               |
//+------------------------------------------------------------------+
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
*//*
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
//|                          checkAlarmPrice()                       |
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

Print(" R5Price ",R5Price);
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







































*/