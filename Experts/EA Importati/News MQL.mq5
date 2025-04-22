//+------------------------------------------------------------------+
//|                                               NEWS FILTER EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(isNewsEvent())
     {
      Print("_______   ALERT: WE HAVE NEWS EVENT   _________");
     }
//---
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
//---

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewsEvent()
  {
   bool isNews = false;
   int totalNews = 0;

   MqlCalendarValue values[];
   datetime startTime = TimeTradeServer()-PeriodSeconds(PERIOD_D1);
   datetime endTime = TimeTradeServer()+PeriodSeconds(PERIOD_D1);
   int valuesTotal = CalendarValueHistory(values,startTime,endTime);

//Print(">>> TOTAL VALUES = ",valuesTotal," || ArraySize = ",ArraySize(values));

   if(valuesTotal >= 0)
     {
      //Print("TIME CURRENT = ",TimeTradeServer());
      //ArrayPrint(values);
     }

   datetime timeRange = PeriodSeconds(PERIOD_W1);
   datetime timeBefore = TimeTradeServer() - timeRange;
   datetime timeAfter = TimeTradeServer() + timeRange;

   Print("FURTHEST TIME LOOK BACK = ",timeBefore," >>> CURRENT = ",TimeTradeServer());
   Print("FURTHEST TIME LOOK FORE = ",timeAfter," >>> CURRENT = ",TimeTradeServer());

   for(int i=0; i < valuesTotal; i++)
     {
      MqlCalendarEvent event;
      CalendarEventById(values[i].event_id,event);

      MqlCalendarCountry country;
      CalendarCountryById(event.country_id,country);

      //Print("NAME = ",event.name,", COUNTRY = ",country.name);

      if(StringFind(_Symbol,country.currency) >= 0)
        {
         if(event.importance == CALENDAR_IMPORTANCE_LOW)
           {
            if(values[i].time <= TimeTradeServer() && values[i].time >= timeBefore)
              {
               Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
                     values[i].time," (ALREADY RELEASED)");
               totalNews++;
              }
            if(values[i].time >= TimeTradeServer() && values[i].time <= timeAfter)
              {
               Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
                     values[i].time," (NOT YET RELEASED)");
               totalNews++;
              }
           }
        }
     }
   if(totalNews > 0)
     {
      isNews = true;
      Print(" >>>>>>>> (FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
     }
   else
      if(totalNews <= 0)
        {
         isNews = false;
         Print(" >>>>>>>> (NOT FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
        }
   return (isNews);
  }
//+------------------------------------------------------------------+
