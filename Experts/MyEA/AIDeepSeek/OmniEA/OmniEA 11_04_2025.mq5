#property strict
#property version "1.30"

#include <AIDeepSeek\BlueTrendTeam\BTTPanels_11_04_2025.mqh>

// Input parametri
input group "Panel Settings"
input color PanelColor = clrRoyalBlue;
input int PanelWidth = 300;
input int PanelHeight = 500;

input group "Debug"
input bool TestMode = true;
input string TestSymbol = "EURUSD";

// Variabili globali
CBTTPanel mainPanel;

int OnInit() {
   // Inizializzazione pannello
   if(!mainPanel.Create(PanelColor, PanelWidth, PanelHeight)) {
      Alert("Errore creazione pannello!");
      return INIT_FAILED;
   }

   if(TestMode) RunTests();
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
   mainPanel.Destroy();
}

void OnTick() {
   static datetime lastTick = 0;
   if(TimeCurrent() > lastTick) {
      lastTick = TimeCurrent();
      mainPanel.Update();
   }
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   mainPanel.HandleEvent(id, lparam, dparam, sparam);
}

// Funzione di test
void RunTests() {
   Print("=== INIZIO TEST AUTOMATICO ===");
   
   // Test ridimensionamento
   TestResize();
   
   // Test assegnazione indicatori
   TestIndicatorAssignment();
   
   Print("=== TEST COMPLETATO ===");
}

void TestResize() {
   Print("Test ridimensionamento in corso...");
   mainPanel.Resize(250, 400);
   Sleep(500);
   mainPanel.Resize(300, 500);
   Print("Test ridimensionamento completato");
}

void TestIndicatorAssignment() {
   Print("Test assegnazione indicatori in corso...");
   // Simula drag&drop di un RSI
   mainPanel.AssignIndicator(0, "Examples\\RSI");
   // Simula drag&drop di un MACD
   mainPanel.AssignIndicator(1, "Examples\\MACD");
   Print("Test assegnazione completato");
}