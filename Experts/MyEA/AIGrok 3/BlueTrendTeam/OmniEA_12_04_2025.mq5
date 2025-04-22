#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property version   "1.00"

#include <AIGrok\BTT_Panels_12_04_2025.mqh>

int OnInit() {
   InitializeSlots();
   DrawBigPanel();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, -1, -1);
}

void OnTick() {
   UpdatePanel();
   CheckForRemovedIndicators();
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   HandlePanelChartEvent(id, lparam, dparam, sparam);
}