//+------------------------------------------------------------------+
//|                                                 GannPivots 2.mq5 |Restituisce in array i livelli dello Square of 9
//|                                  Copyright 2022, Ali Gökay Duman |
//|                                   https://aligokay-duman.web.app |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Ali Gökay Duman"
#property link      "https://aligokay-duman.web.app"
#property version   "1.1"
#property description "This Indicator is based on Gann Pyramid Pivots indicator."
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   2



enum AlertType
  {
   NoAlert           = 0,
   PlaySoundAlert    = 1,
   ShowAlertMessage  = 2,
   SendMobileMessage = 3,
   SendEmail         = 4
  };

enum LineType
  {
   Solid      = 0,
   Dash       = 1,
   Dot        = 2,
   DashDot    = 3,
   DashDotDot = 4
  };

enum LineWidth
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
  };

enum PriceType
  {
   PreviousDayOpen  = 0,
   PreviousDayLow   = 1,
   PreviousDayHigh  = 2,
   PreviousDayClose = 3,
   PivotPoint       = 4,
   Custom           = 5,
  };
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

int    lastBar=0;
double lastAlarmPrice=0;
bool   timeToCalc=false;
double R1Price,R2Price,R3Price,R4Price,R5Price;
double S1Price,S2Price,S3Price,S4Price,S5Price;
string pcode="GannPivots_";
double LastAlert=-1;
double NewAlert=0;
string broker_name;

string chartID = "";
string buttonID="ButtonGann";
double showGann;

double ResSuppGann[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   chartID = IntegerToString(ChartID())+"-1973456"; //chartID+UniqueID
   EventSetTimer(10);
   clearObj();
   lastBar=0;
   broker_name = StringSubstr(AccountInfoString(ACCOUNT_COMPANY),0,5);

   
   ArraySetAsSeries(ResSuppGann,true);
   SetIndexBuffer(1, ResSuppGann);

    
   if(ButtonEnable)
     {
      if(GlobalVariableCheck(chartID+"-"+"showGann"))
         showGann = GlobalVariableGet(chartID+"-"+"showGann");
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
      GlobalVariableSet(chartID+"-"+"showGann",showGann);
     }

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   clearObj();
   ObjectDelete(0,buttonID);
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

   double price = 0;

   double Low[1];
   CopyLow(Symbol(),PERIOD_D1,1,1,Low);

   double High[1];
   CopyHigh(Symbol(),PERIOD_D1,1,1,High);

   double Close[1];
   CopyClose(Symbol(),PERIOD_D1,1,1,Close);

   double Open[1];
   CopyOpen(Symbol(),PERIOD_D1,1,1,Open);

   if(GannInputType==PreviousDayOpen)
      price = Open[0];
   if(GannInputType==PreviousDayLow)
      price = Low[0];
   if(GannInputType==PreviousDayHigh)
      price = High[0];
   if(GannInputType==PreviousDayClose)
      price = Close[0];
   if(GannInputType==PivotPoint)
      price = (Low[0]+High[0]+Close[0])/3;
   if(GannInputType==Custom)
      price = StringToDouble(GannCustomPrice);
Print("Prezzo ",price," GannCustomPrice ",StringToDouble(GannCustomPrice));
   price = NormalizeDouble(price,Digits());

//Print("Gann Input Type="+EnumToString(GannInputType)+" | Input Price="+DoubleToString(price,Digits()));

   GannObj gann(price,GannInputDigit,close[0],Digits());

   ResSuppGann[4] = R1Price=gann.getresistance1()* 0.9995;
   ResSuppGann[3] = R2Price=gann.getresistance2()* 0.9995;
   ResSuppGann[2] = R3Price=gann.getresistance3()* 0.9995;
   ResSuppGann[1] = R4Price=gann.getresistance4()* 0.9995;
   ResSuppGann[0] = R5Price=gann.getresistance5()* 0.9995;

   ResSuppGann[5] = S1Price=gann.getsupport1()* 1.0005;
   ResSuppGann[6] = S2Price=gann.getsupport2()* 1.0005;
   ResSuppGann[7] = S3Price=gann.getsupport3()* 1.0005;
   ResSuppGann[8] = S4Price=gann.getsupport4()* 1.0005;
   ResSuppGann[9] = S5Price=gann.getsupport5()* 1.0005;
 
 /*  
for(int i=0;i<10;i++)
{Print("Indicator ",i," ",ResSuppGann[i]);}
*/
   if(showGann)
     {
      if(ShortLines)
         drawRectangleLine();
      else
         drawHorizontalLine();
      writeLineName();
      checkAlarmPrice();
     }

   return(rates_total);
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

      if(Alert1 == 1)
         PlaySound("Alert");
      if(Alert1 == 2)
         Alert(message);
      if(Alert1 == 3)
         SendNotification(message);
      if(Alert1 == 4)
         SendMail("All in One Pivot Point - ",message);

      if(Alert1 != Alert2)
        {
         if(Alert2 == 1)
            PlaySound("Alert");
         if(Alert2 == 2)
            Alert(message);
         if(Alert2 == 3)
            SendNotification(message);
         if(Alert2 == 4)
            SendMail("All in One Pivot Point - ",message);
        }

      GlobalVariableSet(chartID+"-"+"LastAlert",NewAlert);
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
   sellBelow = (C10!=0) ? D10 : (C8!=0) ? C9 : (D7!=0) ? C7 : (F7!=0) ? E7 : (G8!=0) ? G7 : (G10!=0) ? G9 : (F11!=0) ? G11 : (D11!=0) ? E11 : (B11!=0) ? C11 : (B8!=0) ? B9 : (C6!=0) ? B6 : (F6!=0) ? E6 : (H7!=0) ? H6 : (H10!=0) ? H9 : (G12!=0) ? H12 : (D12!=0) ? E12 : 0;

   buyTarget1 = resistance1 * 0.9995;
   buyTarget2 = resistance2 * 0.9995;
   buyTarget3 = resistance3 * 0.9995;
   buyTarget4 = resistance4 * 0.9995;
   buyTarget5 = resistance5 * 0.9995;

   sellTarget1 = support1 * 1.0005;
   sellTarget2 = support2 * 1.0005;
   sellTarget3 = support3 * 1.0005;
   sellTarget4 = support4 * 1.0005;
   sellTarget5 = support5 * 1.0005;

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

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
      GlobalVariableSet(chartID+"-"+"showGann",showGann);
      ObjectSetInteger(0,buttonID,OBJPROP_STATE,0);
      ChartRedraw();
     }

  }
//+------------------------------------------------------------------+
