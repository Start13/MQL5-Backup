
#property copyright "Copyright 2023, Corrado Bruni"
#property link      ""
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input int      InpStartHour = 0;
input int      InpStartMinute = 59;
input int      InpEndHour = 23;
input int      InpEndMinute = 58;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
  InTradingTime();
  }
//+------------------------------------------------------------------+

bool InTradingTime()
{
  datetime Now = TimeTradeServer();
  MqlDateTime NowStruct;
  TimeToStruct(Now,NowStruct);
  int StartTradingSeconds = (InpStartHour*3600) + (InpStartMinute*60);
  int EndTradingSeconds = (InpEndHour*3600) + (InpEndMinute*60);
  int runningseconds = (NowStruct.hour*3600) + (NowStruct.min*60);
  ZeroMemory(NowStruct);
  if ((runningseconds>StartTradingSeconds)&&(runningseconds<EndTradingSeconds))
  {
    Print("within trading time");
    return(true);
  }
  Print("outside of trading time");
  return(false);
}