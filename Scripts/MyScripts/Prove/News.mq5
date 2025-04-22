

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh> 

 ENUM_TIMEFRAMES                   startime_  = PERIOD_H1  ;
 ENUM_TIMEFRAMES                   endtime_   = PERIOD_W1  ;
 ENUM_TIMEFRAMES                   rangetime_ = PERIOD_MN1  ;
 ENUM_CALENDAR_EVENT_IMPORTANCE    levelImpact= CALENDAR_IMPORTANCE_HIGH ;
 
input bool     FilterNews   =           false;                            //Filter News
input ENUM_TIMEFRAMES                   StopBefore ;                      //Stop Before
input ENUM_TIMEFRAMES                   StopAfter  ;                      //Stop After 
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
Print(isNewsEvent());
   
  }


bool isNewsEvent(){
   bool isNews = false;
   int totalNews = 0;
   
   MqlCalendarValue values[];
   datetime startTime = TimeTradeServer()-PeriodSeconds(startime_);
   datetime endTime = TimeTradeServer()+PeriodSeconds(endtime_);
   int valuesTotal = CalendarValueHistory(values,startTime,endTime);
   
   //Print(">>> TOTAL VALUES = ",valuesTotal," || ArraySize = ",ArraySize(values));
   
   if (valuesTotal >= 0){
      //Print("TIME CURRENT = ",TimeTradeServer());
      //ArrayPrint(values);
   }
   
   datetime timeRange = PeriodSeconds(rangetime_);
   datetime timeBefore = TimeTradeServer() - timeRange;
   datetime timeAfter = TimeTradeServer() + timeRange;
      
   //Print("FURTHEST TIME LOOK BACK = ",timeBefore," >>> CURRENT = ",TimeTradeServer());
   //Print("FURTHEST TIME LOOK FORE = ",timeAfter," >>> CURRENT = ",TimeTradeServer());

   for (int i=0; i < valuesTotal; i++)
   {
      MqlCalendarEvent event;
      CalendarEventById(values[i].event_id,event);
      
      MqlCalendarCountry country;
      CalendarCountryById(event.country_id,country);
      
      //Print("NAME = ",event.name,", COUNTRY = ",country.name);
      
      if (StringFind(_Symbol,country.currency) >= 0)
      {
         if (event.importance == levelImpact)
         {
            if (values[i].time <= TimeTradeServer() && values[i].time >= timeBefore)
            {
               Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
                     values[i].time," (ALREADY RELEASED)");
               totalNews++;
            }
            if (values[i].time >= TimeTradeServer() && values[i].time <= timeAfter)
            {
               Print(event.name," > ",country.currency," > ",EnumToString(event.importance),", TIME = ",
                     values[i].time," (NOT YET RELEASED)");
               totalNews++;
            }
            if (FilterNews && values[i].time >= TimeTradeServer() - StopBefore && values[i].time<= TimeTradeServer() - StopAfter && totalNews==0)
               isNews = true;
         }
      }
   }
   if (totalNews > 0){
      //isNews = true;
      Print(" >>>>>>>> (FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
   }
   else if (totalNews <= 0){
      //isNews = false;
      Print(" >>>>>>>> (NOT FOUND NEWS) TOTAL NEWS = ",totalNews,"/",ArraySize(values));
   }
   return (isNews);
}