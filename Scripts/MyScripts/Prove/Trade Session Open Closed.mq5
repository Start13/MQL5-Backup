//+------------------------------------------------------------------+
//|                                    Trade Session Open Closed.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
Print("Session Open: ",(string)IsInTradingSession());
 
Print("MarketOpenHours: ",MarketOpenHours(Symbol()));  
  }
//+------------------------------------------------------------------+
bool IsInTradingSession(){
MqlDateTime mqt;
if(TimeToStruct(TimeTradeServer(),mqt)){
  //flatten
    ENUM_DAY_OF_WEEK dow=(ENUM_DAY_OF_WEEK)mqt.day_of_week;
    mqt.hour=0;mqt.min=0;mqt.sec=0;
    datetime base=StructToTime(mqt),get_from=0,get_to=0;
  //now loop in all the trading sessions 
    uint session=0;
    while(SymbolInfoSessionTrade(_Symbol,dow,session,get_from,get_to)){
    //so if this succeeds a session exists and fills up get from and get to , but it just fills up with hour , minute + second
      //that means we have to project it on the base time we flattened above for today
        get_from=(datetime)(base+get_from);
        get_to=(datetime)(base+get_to);
        Print("Session [ "+IntegerToString(session)+" ] ("+TimeToString(get_from,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+")->("+TimeToString(get_to,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+")");
    //and we pump one session in 
      session++;
    //and we check , if we happen to be inside that range , we return true because we can trade
      if(TimeTradeServer()>=get_from&&TimeTradeServer()<=get_to){return(true);}
    }  
}
return(false);
}


//+------------------------------------------------------------------+
//| MarketOpenHours                                                  |
//+------------------------------------------------------------------+
bool MarketOpenHours(string sym) {
  bool isOpen = false;                                  // by default market is closed
  MqlDateTime mdtServerTime;                            // declare server time structure variable
  datetime dtServerDateTime = TimeTradeServer();        // store server time 
  if(!TimeToStruct(dtServerDateTime,                    // is servertime correctly converted to struct?
                   mdtServerTime)) {
    return(false);                                      // no, return market is closed
  }

  ENUM_DAY_OF_WEEK today = (ENUM_DAY_OF_WEEK)           // get actual day and cast to enum
                            mdtServerTime.day_of_week;

  if(today > 0 || today < 6) {                          // is today in monday to friday?
    datetime dtF;                                       // store trading session begin and end time
    datetime dtT;                                       // date component is 1970.01.01 (0)
    datetime dtServerTime = dtServerDateTime % 86400;   // set date to 1970.01.01 (0)
    if(!SymbolInfoSessionTrade(sym, today,              // do we have values for dtFrom and dtTo?
                               0, dtF, dtT)) {
      return(false);                                    // no, return market is closed
    }
    switch(today) {                                     // check for different trading sessions
      case 1:
        if(dtServerTime >= dtF && dtServerTime <= dtT)  // is server time in 00:05 (300) - 00:00 (86400)
          isOpen = true;                                // yes, set market is open
        break;
      case 5:
        if(dtServerTime >= dtF && dtServerTime <= dtT)  // is server time in 00:04 (240) - 23:55 (86100)
          isOpen = true;                                // yes, set market is open
        break;
      default:
        if(dtServerTime >= dtF && dtServerTime <= dtT)  // is server time in 00:04 (240) - 00:00 (86400)
          isOpen = true;                                // yes, set market is open
        break;
    }
  }
  return(isOpen);
}
