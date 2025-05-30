//+------------------------------------------------------------------+
//|                                         M&W v 2.15.mq5           |
//|                                  Corrado Bruni Copyright @2023  |
//|                                   https://www.cbalgotrade.com   |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "2.15"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//+------------------------------------------------------------------+
//| Input                                                            |
//+------------------------------------------------------------------+
input int Depth = 18;               // Profondità per rilevare swing (ZigZag MT5)
input int Deviation = 8;            // Deviazione in punti (ZigZag MT5)
input int Backstep = 3;             // Passo indietro per confermare swing (ZigZag MT5)
input color M_Color = clrRed;       // Colore per pattern M
input color W_Color = clrLime;      // Colore per pattern W
input double MaxPercentP3 = 75.0;   // % massima per il punto 3 e per la semilinea su p1-p2
input int CandlesClosed = 2;        // Numero di candele consecutive chiuse per confermare Buy/Sell
input color ZigZag_MT5_Color = clrBlue; // Colore per lo ZigZag MT5

//+------------------------------------------------------------------+
//| Strutture                                                        |
//+------------------------------------------------------------------+
struct SwingPoint {
   double price;
   datetime time;
   string type; // "High" o "Low"
};

//+------------------------------------------------------------------+
//| Variabili globali                                                |
//+------------------------------------------------------------------+
SwingPoint swings[];
int swingCount = 0;
datetime lastProcessedTime = 0;

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit() {
   ArrayResize(swings, 1000); // Dimensione iniziale array
   swingCount = 0;
   lastProcessedTime = 0;
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Deinizializzazione                                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, "MW_");
   ObjectsDeleteAll(0, "ZigZag_MT5_");
}

//+------------------------------------------------------------------+
//| Calcolo Indicatore                                               |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
   if (rates_total < Depth + Backstep) return(0);

   if (prev_calculated == 0 || time[rates_total-1] > lastProcessedTime) {
      if (prev_calculated == 0) {
         ObjectsDeleteAll(0, "MW_");
         ObjectsDeleteAll(0, "ZigZag_MT5_");
      }

      // Calcola lo ZigZag MT5 e popola swings[]
      double zigzag[];
      ArrayResize(zigzag, rates_total);
      ArrayInitialize(zigzag, 0.0);
      CalculateZigZagMT5(rates_total, high, low, zigzag, Depth, Deviation, Backstep);
      PopulateSwingsFromZigZag(rates_total, high, low, time, zigzag);
      DrawZigZagMT5(rates_total, high, low, time);

      if (swingCount >= 5) {
         IdentifyMWPattern(rates_total, time, close, low, high);
      }

      lastProcessedTime = time[rates_total-1];
   }

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Funzioni di Supporto                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Popola l'array swings[] dallo ZigZag MT5                         |
//+------------------------------------------------------------------+
void PopulateSwingsFromZigZag(int rates_total, const double &high[], const double &low[], const datetime &time[], const double &zigzag[]) {
   swingCount = 0;
   for (int i = 0; i < rates_total; i++) {
      if (zigzag[i] != 0.0) {
         if (zigzag[i] == high[i]) {
            swings[swingCount].price = high[i];
            swings[swingCount].time = time[i];
            swings[swingCount].type = "High";
         } else if (zigzag[i] == low[i]) {
            swings[swingCount].price = low[i];
            swings[swingCount].time = time[i];
            swings[swingCount].type = "Low";
         }
         swingCount++;
         if (swingCount >= ArraySize(swings)) {
            ArrayResize(swings, swingCount + 1000);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Disegna lo ZigZag MT5                                            |
//+------------------------------------------------------------------+
void DrawZigZagMT5(int rates_total, const double &high[], const double &low[], const datetime &time[]) {
   double zigzag[];
   ArrayResize(zigzag, rates_total);
   ArrayInitialize(zigzag, 0.0);

   CalculateZigZagMT5(rates_total, high, low, zigzag, Depth, Deviation, Backstep);

   int lastIndex = -1;
   for (int i = 0; i < rates_total; i++) {
      if (zigzag[i] != 0.0) {
         if (lastIndex != -1) {
            string objName = "ZigZag_MT5_" + IntegerToString(i) + "_" + TimeToString(time[i]);
            ObjectCreate(0, objName, OBJ_TREND, 0, time[lastIndex], zigzag[lastIndex], time[i], zigzag[i]);
            ObjectSetInteger(0, objName, OBJPROP_COLOR, ZigZag_MT5_Color);
            ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
            ObjectSetInteger(0, objName, OBJPROP_BACK, true);
         }
         lastIndex = i;
      }
   }
}

//+------------------------------------------------------------------+
//| Calcola lo ZigZag MT5                                            |
//+------------------------------------------------------------------+
void CalculateZigZagMT5(int rates_total, const double &high[], const double &low[], double &zigzag[], 
                        int depth, int deviation, int backstep) {
   int lastHigh = -1, lastLow = -1;
   double lastHighPrice = 0.0, lastLowPrice = 0.0;

   for (int i = depth; i < rates_total - backstep; i++) {
      bool isHigh = true, isLow = true;

      for (int j = 1; j <= depth; j++) {
         if (i - j < 0 || i + j >= rates_total) continue;
         if (high[i] <= high[i - j] || high[i] <= high[i + j]) {
            isHigh = false;
            break;
         }
      }

      for (int j = 1; j <= depth; j++) {
         if (i - j < 0 || i + j >= rates_total) continue;
         if (low[i] >= low[i - j] || low[i] >= low[i + j]) {
            isLow = false;
            break;
         }
      }

      if (isHigh && (lastHigh == -1 || i - lastHigh >= backstep) && 
          (lastHighPrice == 0.0 || MathAbs(high[i] - lastHighPrice) >= deviation * Point())) {
         zigzag[i] = high[i];
         lastHigh = i;
         lastHighPrice = high[i];
      } else if (isLow && (lastLow == -1 || i - lastLow >= backstep) && 
                 (lastLowPrice == 0.0 || MathAbs(low[i] - lastLowPrice) >= deviation * Point())) {
         zigzag[i] = low[i];
         lastLow = i;
         lastLowPrice = low[i];
      }
   }
}

//+------------------------------------------------------------------+
//| Identifica Pattern MW                                            |
//+------------------------------------------------------------------+
void IdentifyMWPattern(int rates_total, const datetime &time[], const double &close[], const double &low[], const double &high[]) {
   if (swingCount < 5) return;

   for (int start = 0; start <= swingCount - 5; start++) {
      SwingPoint p[5];
      for (int i = 0; i < 5; i++) {
         p[i] = swings[start + i];
      }

      // Pattern "W" (rialzista): High(1)-Low(2)-High(3)-Low(4)-High(5)
      if (p[0].type == "High" && p[1].type == "Low" && p[2].type == "High" && 
          p[3].type == "Low" && p[4].type == "High") {
         double range = p[0].price - p[1].price;
         double p3Distance = p[2].price - p[1].price;
         double percentP3 = (p3Distance / range) * 100.0;
         if (p[2].price > p[1].price && p[2].price < p[0].price && 
             percentP3 <= MaxPercentP3 && 
             p[3].price >= p[1].price) {
            DrawPattern(p, "W", p[4].time, W_Color);
            CheckBuySignal(rates_total, time, close, low, p[1], p[2], p[4].time, p);
         }
      }
      // Pattern "M" (ribassista): Low(1)-High(2)-Low(3)-High(4)-Low(5)
      else if (p[0].type == "Low" && p[1].type == "High" && p[2].type == "Low" && 
               p[3].type == "High" && p[4].type == "Low") {
         double range = p[1].price - p[0].price;
         double p3Distance = p[1].price - p[2].price;
         double percentP3 = (p3Distance / range) * 100.0;
         if (p[2].price < p[1].price && p[2].price > p[0].price && 
             percentP3 <= MaxPercentP3 && 
             p[3].price <= p[1].price) {
            DrawPattern(p, "M", p[4].time, M_Color);
            CheckSellSignal(rates_total, time, close, high, p[1], p[2], p[4].time, p);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Verifica Segnale Buy e Disegna Fibonacci                         |
//+------------------------------------------------------------------+
void CheckBuySignal(int rates_total, const datetime &time[], const double &close[], const double &low[], 
                    SwingPoint &p2, SwingPoint &p3, datetime patternTime, SwingPoint &p[]) {
   int closedCandles = 0;
   bool valid = true;
   string objName = "MW_Buy_" + TimeToString(patternTime);
   string arrowName = "MW_Buy_Arrow_" + TimeToString(patternTime);
   if (ObjectFind(0, objName) >= 0) return;

   // Calcola il livello p1-p2
   double range = p[0].price - p[1].price;
   double offset = range * (MaxPercentP3 / 100.0);
   double p12Price = p[1].price + offset; // Livello p1-p2 per "W"

   // Verifica se p5 ha già superato p1-p2
   if (p[4].price >= p12Price) return; // Non disegnare Buy se p5 ha recuperato p1-p2

   for (int i = rates_total - 1; i >= 0; i--) {
      if (time[i] <= p3.time) break;
      if (low[i] < p2.price) {
         valid = false;
         break;
      }
      if (close[i] > p3.price) closedCandles++;
      else closedCandles = 0;
      if (closedCandles >= CandlesClosed && valid) {
         ObjectCreate(0, objName, OBJ_TEXT, 0, time[i], p3.price + 20 * Point());
         ObjectSetString(0, objName, OBJPROP_TEXT, "Buy");
         ObjectSetInteger(0, objName, OBJPROP_COLOR, W_Color);
         ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 8);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);

         ObjectCreate(0, arrowName, OBJ_ARROW_UP, 0, time[i], close[i]);
         ObjectSetInteger(0, arrowName, OBJPROP_COLOR, clrGreen);
         ObjectSetInteger(0, arrowName, OBJPROP_WIDTH, 3);
         ObjectSetInteger(0, arrowName, OBJPROP_BACK, true);

         // Estensioni Fibonacci basate su p2-p3
         double fibRange = MathAbs(p[2].price - p[3].price);
         double fibLevels[] = {1.5, 1.618, 2.618, 3.618};
         datetime fibEndTime = p[4].time + PeriodSeconds(_Period) * 24;
         for (int j = 0; j < ArraySize(fibLevels); j++) {
            double fibPrice = p[3].price + fibRange * fibLevels[j]; // "W" va verso l'alto
            string fibObjName = "MW_Fib_" + DoubleToString(fibLevels[j], 3) + "_" + TimeToString(patternTime);
            ObjectCreate(0, fibObjName, OBJ_TREND, 0, p[4].time, fibPrice, fibEndTime, fibPrice);
            ObjectSetInteger(0, fibObjName, OBJPROP_COLOR, W_Color);
            ObjectSetInteger(0, fibObjName, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, fibObjName, OBJPROP_WIDTH, 1);
            ObjectSetInteger(0, fibObjName, OBJPROP_BACK, true);

            string fibLabel = "MW_FibLabel_" + DoubleToString(fibLevels[j], 3) + "_" + TimeToString(patternTime);
            ObjectCreate(0, fibLabel, OBJ_TEXT, 0, p[4].time, fibPrice);
            ObjectSetString(0, fibLabel, OBJPROP_TEXT, DoubleToString(fibLevels[j], 3));
            ObjectSetInteger(0, fibLabel, OBJPROP_COLOR, W_Color);
            ObjectSetInteger(0, fibLabel, OBJPROP_FONTSIZE, 8);
            ObjectSetInteger(0, fibLabel, OBJPROP_BACK, true);
         }
         break;
      }
   }
}

//+------------------------------------------------------------------+
//| Verifica Segnale Sell e Disegna Fibonacci                        |
//+------------------------------------------------------------------+
void CheckSellSignal(int rates_total, const datetime &time[], const double &close[], const double &high[], 
                     SwingPoint &p2, SwingPoint &p3, datetime patternTime, SwingPoint &p[]) {
   int closedCandles = 0;
   bool valid = true;
   string objName = "MW_Sell_" + TimeToString(patternTime);
   string arrowName = "MW_Sell_Arrow_" + TimeToString(patternTime);
   if (ObjectFind(0, objName) >= 0) return;

   // Calcola il livello p1-p2
   double range = p[1].price - p[0].price;
   double offset = range * (MaxPercentP3 / 100.0);
   double p12Price = p[1].price - offset; // Livello p1-p2 per "M"

   // Verifica se p5 ha già superato p1-p2
   if (p[4].price <= p12Price) return; // Non disegnare Sell se p5 ha recuperato p1-p2

   for (int i = rates_total - 1; i >= 0; i--) {
      if (time[i] <= p3.time) break;
      if (high[i] > p2.price) {
         valid = false;
         break;
      }
      if (close[i] < p3.price) closedCandles++;
      else closedCandles = 0;
      if (closedCandles >= CandlesClosed && valid) {
         ObjectCreate(0, objName, OBJ_TEXT, 0, time[i], p3.price - 20 * Point());
         ObjectSetString(0, objName, OBJPROP_TEXT, "Sell");
         ObjectSetInteger(0, objName, OBJPROP_COLOR, M_Color);
         ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 8);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);

         ObjectCreate(0, arrowName, OBJ_ARROW_DOWN, 0, time[i], close[i]);
         ObjectSetInteger(0, arrowName, OBJPROP_COLOR, clrRed);
         ObjectSetInteger(0, arrowName, OBJPROP_WIDTH, 3);
         ObjectSetInteger(0, arrowName, OBJPROP_BACK, true);

         // Estensioni Fibonacci basate su p2-p3
         double fibRange = MathAbs(p[2].price - p[3].price);
         double fibLevels[] = {1.5, 1.618, 2.618, 3.618};
         datetime fibEndTime = p[4].time + PeriodSeconds(_Period) * 24;
         for (int j = 0; j < ArraySize(fibLevels); j++) {
            double fibPrice = p[3].price - fibRange * fibLevels[j]; // "M" va verso il basso
            string fibObjName = "MW_Fib_" + DoubleToString(fibLevels[j], 3) + "_" + TimeToString(patternTime);
            ObjectCreate(0, fibObjName, OBJ_TREND, 0, p[4].time, fibPrice, fibEndTime, fibPrice);
            ObjectSetInteger(0, fibObjName, OBJPROP_COLOR, M_Color);
            ObjectSetInteger(0, fibObjName, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, fibObjName, OBJPROP_WIDTH, 1);
            ObjectSetInteger(0, fibObjName, OBJPROP_BACK, true);

            string fibLabel = "MW_FibLabel_" + DoubleToString(fibLevels[j], 3) + "_" + TimeToString(patternTime);
            ObjectCreate(0, fibLabel, OBJ_TEXT, 0, p[4].time, fibPrice);
            ObjectSetString(0, fibLabel, OBJPROP_TEXT, DoubleToString(fibLevels[j], 3));
            ObjectSetInteger(0, fibLabel, OBJPROP_COLOR, M_Color);
            ObjectSetInteger(0, fibLabel, OBJPROP_FONTSIZE, 8);
            ObjectSetInteger(0, fibLabel, OBJPROP_BACK, true);
         }
         break;
      }
   }
}

//+------------------------------------------------------------------+
//| Disegna Pattern sul Grafico                                      |
//+------------------------------------------------------------------+
void DrawPattern(SwingPoint &p[], string patternName, datetime patternTime, color patternColor) {
   string objName;

   // Solo la diagonale tra p4 e p5
   objName = "MW_Line_4_" + TimeToString(patternTime);
   ObjectCreate(0, objName, OBJ_TREND, 0, p[3].time, p[3].price, p[4].time, p[4].price);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);

   // Etichette con solo numero per i punti 1-5
   for (int i = 0; i < 5; i++) {
      objName = "MW_Label_" + IntegerToString(i) + "_" + TimeToString(patternTime);
      string labelText = IntegerToString(i+1);
      ObjectCreate(0, objName, OBJ_TEXT, 0, p[i].time, p[i].price + (p[i].type == "High" ? 10 * Point() : -10 * Point()));
      ObjectSetString(0, objName, OBJPROP_TEXT, labelText);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
      ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, objName, OBJPROP_ANCHOR, p[i].type == "High" ? ANCHOR_BOTTOM : ANCHOR_TOP);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);
   }

   // Semilinea orizzontale sul punto 3 (24 candele)
   objName = "MW_P3_Line_" + TimeToString(patternTime);
   datetime endTimeP3 = p[2].time + PeriodSeconds(_Period) * 24;
   ObjectCreate(0, objName, OBJ_TREND, 0, p[2].time, p[2].price, endTimeP3, p[2].price);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);

   // Semilinea orizzontale sulla diagonale p1-p2 al livello % impostato
   double range = (patternName == "W") ? (p[0].price - p[1].price) : (p[1].price - p[0].price);
   double offset = range * (MaxPercentP3 / 100.0);
   double p12Price = (patternName == "W") ? (p[1].price + offset) : (p[1].price - offset);
   datetime intersectTime = CalculateIntersectionTime(p[0], p[1], p12Price);
   objName = "MW_P12_Line_" + TimeToString(patternTime);
   datetime endTimeP12 = intersectTime + PeriodSeconds(_Period) * 24;
   ObjectCreate(0, objName, OBJ_TREND, 0, intersectTime, p12Price, endTimeP12, p12Price);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);

   // Etichetta con la % accanto alla semilinea p1-p2
   string percentLabel = "MW_P12_Percent_" + TimeToString(patternTime);
   ObjectCreate(0, percentLabel, OBJ_TEXT, 0, intersectTime, p12Price + (patternName == "W" ? 10 * Point() : -10 * Point()));
   ObjectSetString(0, percentLabel, OBJPROP_TEXT, DoubleToString(MaxPercentP3, 1) + "%");
   ObjectSetInteger(0, percentLabel, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, percentLabel, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, percentLabel, OBJPROP_BACK, true);

   // Nome del pattern con solo numero di candele
   objName = "MW_Pattern_" + TimeToString(patternTime);
   string patternText = "Pattern " + patternName + " " + IntegerToString(CandlesClosed);
   ObjectCreate(0, objName, OBJ_TEXT, 0, p[2].time, p[2].price + (patternName == "M" ? -30 * Point() : 30 * Point()));
   ObjectSetString(0, objName, OBJPROP_TEXT, patternText);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);
}

//+------------------------------------------------------------------+
//| Calcola il tempo di intersezione della diagonale p1-p2           |
//+------------------------------------------------------------------+
datetime CalculateIntersectionTime(SwingPoint &p1, SwingPoint &p2, double priceLevel) {
   double priceDiff = p2.price - p1.price;
   datetime timeDiff = p2.time - p1.time;
   if (timeDiff == 0) return p1.time;
   double slope = priceDiff / (double)timeDiff;
   double timeToIntersect = (priceLevel - p1.price) / slope;
   return p1.time + (datetime)timeToIntersect;
}

//+------------------------------------------------------------------+
//| Funzione per Convertire Periodo in Stringa                       |
//+------------------------------------------------------------------+
string PeriodToString(int period) {
   switch(period) {
      case PERIOD_M1: return "M1";
      case PERIOD_M5: return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_H1: return "H1";
      case PERIOD_D1: return "D1";
      default: return "Unknown";
   }
}