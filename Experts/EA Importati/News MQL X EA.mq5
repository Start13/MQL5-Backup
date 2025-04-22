//+------------------------------------------------------------------+
//|                                               NEWS FILTER EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <MyLibrary\MyLibrary.mqh>

//datetime startime;
input ENUM_TIMEFRAMES                   startime_  = PERIOD_D1  ;
input ENUM_TIMEFRAMES                   endtime_   = PERIOD_W1  ;
input ENUM_TIMEFRAMES                   rangetime_ = PERIOD_W1  ;
input ENUM_CALENDAR_EVENT_IMPORTANCE    levelImpact= CALENDAR_IMPORTANCE_HIGH ;

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

input string   comment_NEW  =          "--- FILTER NEWS ---";             // --- FILTER NEWS ---
input bool     FilterNews   =           true;                             //Filter News
input StopBefore_                       StopBefore = 30;                  //Stop Before
input StopAfter_                        StopAfter  = 30;                  //Stop After

datetime OraNews=0;// Serve ai commenti. Se non utilizzi nei commenti cancella OraNews nella funzione

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

// if (semaforoOra()&&isNewsEvent())
     {
      // Print("_______   ALERT: WE HAVE NEWS EVENT   _________");
     }

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//Print("semaforoOra(): ",semaforoOra());
   if(semaforominuto()&&isNewsEvent())
     {
      Print("_______   ALERT: WE HAVE NEWS EVENT   _________");
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewsEvent()
  {
   bool isNews = false;
   int totalNews = 0;
   datetime OraOldNews=0;
   datetime OraNews_=0;
   datetime x = (datetime)0;
   datetime y = D'3000.01.01 00:00:00';

   MqlCalendarValue values[];
   datetime startTime = TimeTradeServer()-PeriodSeconds(startime_);
   datetime endTime = TimeTradeServer()+PeriodSeconds(endtime_);
   int valuesTotal = CalendarValueHistory(values,startTime,endTime);

//Print(">>> TOTAL VALUES = ",valuesTotal," || ArraySize = ",ArraySize(values));

   if(valuesTotal >= 0)
     {
      //Print("TIME CURRENT = ",TimeTradeServer());
      //ArrayPrint(values);
     }

   datetime timeRange = PeriodSeconds(rangetime_);
   datetime timeBefore = TimeTradeServer() - timeRange;
   datetime timeAfter = TimeTradeServer() + timeRange;

//Print("FURTHEST TIME LOOK BACK = ",timeBefore," >>> CURRENT = ",TimeTradeServer());
//Print("FURTHEST TIME LOOK FORE = ",timeAfter," >>> CURRENT = ",TimeTradeServer());

   for(int i=0; i < valuesTotal; i++)
     {
      MqlCalendarEvent event;
      CalendarEventById(values[i].event_id,event);

      MqlCalendarCountry country;
      CalendarCountryById(event.country_id,country);

      //Print("NAME = ",event.name,", COUNTRY = ",country.name);

      if(StringFind(_Symbol,country.currency) >= 0)
        {
         if(event.importance == levelImpact)
           {
            if(values[i].time <= TimeTradeServer() && values[i].time >= timeBefore)
              {
               //Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
               //     values[i].time," (ALREADY RELEASED)");

               if(values[i].time > x)
                 {
                  x = OraOldNews = values[i].time;
                 }
               totalNews++;
              }
            if(values[i].time >= TimeTradeServer() && values[i].time <= timeAfter)
              {
               //Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
               //      values[i].time," (NOT YET RELEASED)");

               if(values[i].time < y && values[i].time > (datetime) 0)
                 {
                  y = OraNews_ = values[i].time;
                 }
               //Print("totalNews: ",totalNews);
               totalNews++;
              }
           }
        }
     }
   OraNews=OraNews_;
   Print(" OraNews: ",OraNews);
   Print(" OraOldNews: ",OraOldNews);

//Print(" totalNews: ",totalNews,
//      " OraNews - (datetime)StopBefore*60: ",OraNews - (datetime)StopBefore*60," <= "," TimeTradeServer(): ",TimeTradeServer()," || ");
//Print(" OraOldNews + (datetime)StopAfter*60: ",OraOldNews + (datetime)StopAfter*60," >= "," TimeTradeServer(): ",TimeTradeServer());


   if(FilterNews && (OraNews - (datetime)StopBefore*60 <= TimeTradeServer() || OraOldNews + (datetime)StopAfter*60 >= TimeTradeServer()) && totalNews>0)
     {isNews = true;}
   if(totalNews > 0)
     {
      //Print(" >>>>>>>> (FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
     }
   else
      if(totalNews <= 0)
        {
         isNews = false;
         //Print(" >>>>>>>> (NOT FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
        }
   Print("isNews: ",isNews);
   return (isNews);
  }
//+------------------------------------------------------------------+
