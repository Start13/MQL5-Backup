

#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property version   "1.00"
#property strict

#include <AIGrok\BTT_Panels_10_04_2025.mqh>

int OnInit() {
   InitializeSlots();
   EventSetMillisecondTimer(200);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
   for (int i = 0; i < 3; i++) {
      if (signal_buy_slots[i].handle != INVALID_HANDLE) IndicatorRelease(signal_buy_slots[i].handle);
      if (signal_sell_slots[i].handle != INVALID_HANDLE) IndicatorRelease(signal_sell_slots[i].handle);
   }
   for (int i = 0; i < 2; i++) {
      if (filter_slots[i].handle != INVALID_HANDLE) IndicatorRelease(filter_slots[i].handle);
   }
   EventKillTimer();
}

void OnTick() {
   // Logica di trading da implementare
}

void OnTimer() {
   UpdatePanel();
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   HandlePanelChartEvent(id, lparam, dparam, sparam);
}