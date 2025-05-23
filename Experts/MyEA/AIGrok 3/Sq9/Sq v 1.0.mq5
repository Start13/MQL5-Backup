//+------------------------------------------------------------------+
//|                                     GannSquareAndFans.mq5        |
//|                                    Creato da Grok 3, xAI        |
//|                                      Data: 17 Marzo 2025        |
//+------------------------------------------------------------------+
#property copyright "Creato da Grok 3, xAI"
#property link      "https://www.xai.com"
#property version   "1.50"
#property strict

#include <Canvas\Charts\ChartCanvas.mqh>

// Enumerazioni per le dimensioni del lato
enum SideLength {
   Candles_32  = 32,  // 32 candele
   Candles_36  = 36,  // 36 candele
   Candles_45  = 45,  // 45 candele
   Candles_60  = 60,  // 60 candele
   Candles_72  = 72,  // 72 candele
   Candles_90  = 90,  // 90 candele
   Candles_120 = 120, // 120 candele
   Candles_180 = 180  // 180 candele
};

// Input utente
input SideLength sideLength    = Candles_45;       // Dimensione lato in candele (Square of 9)
input int zigZagDepth          = 12;               // ZigZag Depth
input int zigZagDeviation      = 5;                // ZigZag Deviation
input int zigZagBackstep       = 3;                // ZigZag Backstep
input ENUM_TIMEFRAMES tf       = PERIOD_CURRENT;   // Timeframe ZigZag
input color sq9Color           = clrRed;           // Colore Square of 9
input color fanMinColor        = clrBlue;          // Colore ventaglio minimo (ascendente)
input color fanMaxColor        = clrGreen;         // Colore ventaglio massimo (discendente)
input int lineWidth            = 1;                // Spessore delle linee
input bool shortLines          = true;             // Linee corte (true) o orizzontali (false) per Sq9
input bool showLabels          = true;             // Mostra etichette sui livelli

// Variabili globali
int handleZigZag = INVALID_HANDLE;
string prefix = "Gann_";
double sq9Levels[9]; // Livelli Square of 9
double fanAngles[] = {0.25, 0.5, 1.0, 2.0, 4.0}; // Rapporti Gann: 1x4, 1x2, 1x1 (centrale), 2x1, 4x1

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   handleZigZag = iCustom(Symbol(), tf, "Examples\\ZigZag", zigZagDepth, zigZagDeviation, zigZagBackstep);
   if (handleZigZag == INVALID_HANDLE) {
      Print("Errore nella creazione dell'indicatore ZigZag: ", GetLastError());
      return INIT_FAILED;
   }

   ClearObjects();
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ClearObjects();
   if (handleZigZag != INVALID_HANDLE) IndicatorRelease(handleZigZag);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   double zigZagValues[];
   ArraySetAsSeries(zigZagValues, true);
   int copied = CopyBuffer(handleZigZag, 0, 0, 100, zigZagValues);
   if (copied <= 0) {
      Print("Errore nel recuperare i dati ZigZag: ", GetLastError());
      return;
   }

   // Trova l'ultimo minimo e massimo relativo
   double minPrice = DBL_MAX, maxPrice = 0;
   datetime minTime = 0, maxTime = 0;
   int lastLowIdx = -1, lastHighIdx = -1;

   for (int i = 0; i < copied; i++) {
      if (zigZagValues[i] > 0) {
         if (zigZagValues[i] < minPrice) {
            minPrice = zigZagValues[i];
            minTime = iTime(Symbol(), tf, i);
            lastLowIdx = i;
         }
         if (zigZagValues[i] > maxPrice) {
            maxPrice = zigZagValues[i];
            maxTime = iTime(Symbol(), tf, i);
            lastHighIdx = i;
         }
      }
   }

   if (lastLowIdx == -1 || lastHighIdx == -1 || minPrice == maxPrice) return;

   // Calcola Square of 9 dal minimo
   CalculateGannLevels(minPrice);
   DrawSquareOf9(minTime);

   // Disegna ventagli di Gann
   DrawGannFan(minPrice, minTime, fanMinColor, "Min", true);  // Ascendente dal minimo
   DrawGannFan(maxPrice, maxTime, fanMaxColor, "Max", false); // Discendente dal massimo
}

//+------------------------------------------------------------------+
//| Calcolo dei livelli dello Square of 9                            |
//+------------------------------------------------------------------+
void CalculateGannLevels(double basePrice) {
   double sqrtPrice = MathSqrt(basePrice / Point());
   int baseLevel = (int)MathFloor(sqrtPrice);
   double step = Point();

   for (int i = 0; i < 9; i++) {
      double level = MathPow(baseLevel + (i * 0.25), 2) * step; // Incrementi di 45°
      sq9Levels[i] = NormalizeDouble(level, Digits());
   }
}

//+------------------------------------------------------------------+
//| Disegno dello Square of 9                                        |
//+------------------------------------------------------------------+
void DrawSquareOf9(datetime startTime) {
   datetime endTime = startTime + (sideLength * PeriodSeconds(tf));

   for (int i = 0; i < 9; i++) {
      string objName = prefix + "Sq9_Level_" + IntegerToString(i);
      if (ObjectFind(0, objName) < 0) {
         if (shortLines) {
            ObjectCreate(0, objName, OBJ_RECTANGLE, 0, startTime, sq9Levels[i], endTime, sq9Levels[i]);
         } else {
            ObjectCreate(0, objName, OBJ_HLINE, 0, startTime, sq9Levels[i]);
         }
      } else {
         if (shortLines) {
            ObjectMove(0, objName, 0, startTime, sq9Levels[i]);
            ObjectMove(0, objName, 1, endTime, sq9Levels[i]);
         } else {
            ObjectMove(0, objName, 0, startTime, sq9Levels[i]);
         }
      }

      ObjectSetInteger(0, objName, OBJPROP_COLOR, sq9Color);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, lineWidth);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
      if (showLabels) {
         ObjectSetString(0, objName, OBJPROP_TEXT, "Sq9 " + DoubleToString(sq9Levels[i], Digits()));
      }
   }
}

//+------------------------------------------------------------------+
//| Disegno del ventaglio di Gann                                    |
//+------------------------------------------------------------------+
void DrawGannFan(double basePrice, datetime baseTime, color fanColor, string type, bool ascending) {
   datetime endTime = TimeCurrent(); // Fino all'ultima candela
   long timeDiff = endTime - baseTime; // Differenza in secondi
   double timeSpan = (double)timeDiff / PeriodSeconds(tf); // Differenza in candele
   // Calcolo della pendenza per 1x1 = 45°
   double priceRange = ChartGetDouble(0, CHART_PRICE_MAX) - ChartGetDouble(0, CHART_PRICE_MIN); // Range verticale
   double timeRange = (double)ChartGetInteger(0, CHART_WIDTH_IN_BARS); // Range orizzontale in barre (cast a double)
   double pricePerTime = (priceRange / timeRange); // Rapporto 1:1 per 45°

   for (int i = 0; i < ArraySize(fanAngles); i++) {
      string objName = prefix + "Fan_" + type + "_" + IntegerToString(i);
      double slope = fanAngles[i] * pricePerTime; // Pendenza relativa alla 1x1
      double endPrice;

      if (ascending) {
         endPrice = basePrice + (slope * timeSpan); // Ventaglio ascendente
      } else {
         endPrice = basePrice - (slope * timeSpan); // Ventaglio discendente
      }

      if (ObjectFind(0, objName) < 0) {
         ObjectCreate(0, objName, OBJ_TREND, 0, baseTime, basePrice, endTime, endPrice);
      } else {
         ObjectMove(0, objName, 0, baseTime, basePrice);
         ObjectMove(0, objName, 1, endTime, endPrice);
      }

      ObjectSetInteger(0, objName, OBJPROP_COLOR, fanColor);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, i == 2 ? lineWidth + 1 : lineWidth); // 1x1 più spessa
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
      if (showLabels) {
         ObjectSetString(0, objName, OBJPROP_TEXT, type + " Fan " + DoubleToString(fanAngles[i], 2));
      }
   }
}

//+------------------------------------------------------------------+
//| Pulizia degli oggetti grafici                                    |
//+------------------------------------------------------------------+
void ClearObjects() {
   for (int i = 0; i < 9; i++) {
      string sq9Name = prefix + "Sq9_Level_" + IntegerToString(i);
      if (ObjectFind(0, sq9Name) >= 0) ObjectDelete(0, sq9Name);
   }
   for (int i = 0; i < ArraySize(fanAngles); i++) {
      string fanMinName = prefix + "Fan_Min_" + IntegerToString(i);
      string fanMaxName = prefix + "Fan_Max_" + IntegerToString(i);
      if (ObjectFind(0, fanMinName) >= 0) ObjectDelete(0, fanMinName);
      if (ObjectFind(0, fanMaxName) >= 0) ObjectDelete(0, fanMaxName);
   }
}