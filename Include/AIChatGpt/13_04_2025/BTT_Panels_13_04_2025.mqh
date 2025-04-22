// BTT_Panels_13_04_2025.mqh (entry principale)
#pragma once

#include <AIChatGpt/13_04_2025/BTT_UIUtils.mqh>
#include <AIChatGpt/13_04_2025/BTT_SlotLogic.mqh>
#include <AIChatGpt/13_04_2025/BTT_PanelDraw.mqh>

// Punto d'ingresso principale per inizializzare e gestire il pannello
void InitializeSlots() {
   InitializeSlotState();
   DetectExistingIndicators();
   LoadIndicatorSlots();
   DrawBigPanel();
}

void UpdatePanel() {
   UpdateSlotTimers();
}

void HandlePanelChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   HandlePanelEvents(id, sparam);
}
