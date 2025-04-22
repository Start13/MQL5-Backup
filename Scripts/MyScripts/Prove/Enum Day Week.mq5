ENUM_DAY_OF_WEEK day_of_week;
//+------------------------------------------------------------------+
//| Script                                                           |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print("Trade Session Open: ", trade_session());
  }
//+------------------------------------------------------------------+
//| Function: Check if trade session is open and excl. Sat and Sun   |
//+------------------------------------------------------------------+
bool trade_session()
  {
   datetime time_now = TimeTradeServer();
   MqlDateTime time;
   TimeToStruct(time_now, time);
   uint week_day_now = time.day_of_week;
   uint seconds_now = (time.hour * 3600) + (time.min * 60) + time.sec;
   if(week_day_now == 0)
      day_of_week = SUNDAY;
   if(week_day_now == 1)
      day_of_week = MONDAY;
   if(week_day_now == 2)
      day_of_week = TUESDAY;
   if(week_day_now == 3)
      day_of_week = WEDNESDAY;
   if(week_day_now == 4)
      day_of_week = THURSDAY;
   if(week_day_now == 5)
      day_of_week = FRIDAY;
   if(week_day_now == 6)
      day_of_week = SATURDAY;
   datetime from, to;
   uint session = 0;
   while(SymbolInfoSessionTrade(_Symbol, day_of_week, session, from, to))
     {
      session++;
     }
   uint trade_session_open_seconds = uint(from);
   uint trade_session_close_seconds = uint(to);
   if(trade_session_open_seconds < seconds_now && trade_session_close_seconds > seconds_now && week_day_now >= 1 && week_day_now <= 5)
      return(true);
   return(false);
  }
  
 