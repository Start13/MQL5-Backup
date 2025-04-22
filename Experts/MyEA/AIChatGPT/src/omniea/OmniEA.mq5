//+------------------------------------------------------------------+
//|                                                      OmniEA.mq5 |
//|        OmniEA Lite v1.0 - by BlueTrendTeam                      |
//+------------------------------------------------------------------+
#property copyright   "BlueTrendTeam"
#property version     "1.00"
#property strict

#include <TradeExecutor.mqh>

input string Language = "it";  // "en" o "it"

int OnInit()
  {
   g_lang = Language;
   Print("[OmniEA] Inizializzazione completata");
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   Print("[OmniEA] EA terminato. Codice: ", reason);
  }

void OnTick()
  {
   DrawNotification("Benvenuto in OmniEA", clrAqua);
  }



void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   // In futuro: gestire eventi click UI qui
  }
