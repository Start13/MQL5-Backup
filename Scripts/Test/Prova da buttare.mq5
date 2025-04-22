//+------------------------------------------------------------------+
//|                                                TestBigPanel.mq5  |
//|                             Copyright 2025, BlueTrendTeam         |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <AIGrok/BlueTrendTeam/Core/BTT_Panels.mqh>

CBigPanel panel;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   panel.Create();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   panel.Destroy();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   panel.Update();
}

//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   panel.OnChartEvent(id, lparam, dparam, sparam);
}