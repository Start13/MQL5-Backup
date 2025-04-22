#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.mql5.com"
#property version   "1.00"

class CIndicators {
private:
   string indicatorNames[5]; // Max 5 indicators (3 for signals, 2 for filters)
   int indicatorCount;

public:
   CIndicators() : indicatorCount(0) {}

   void Init() {
      for (int i = 0; i < 5; i++) {
         indicatorNames[i] = ""; // Inizializzazione manuale
      }
   }

   bool AddIndicator(string name) {
      if (indicatorCount >= 5) return false;
      indicatorNames[indicatorCount] = name;
      indicatorCount++;
      return true;
   }

   string GetIndicator(int index) {
      if (index < 0 || index >= indicatorCount) return "";
      return indicatorNames[index];
   }
};