#property copyright "xAI - Grok 3"
#property link      "https://xai.com"
#property version   "1.10"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//+------------------------------------------------------------------+
//| Input                                                            |
//+------------------------------------------------------------------+
input int Depth = 12;               // Profondità per rilevare swing
input int Deviation = 5;            // Deviazione minima in punti per considerare uno swing
input int Backstep = 3;             // Passo indietro per confermare swing
input double SwingStrength = 1.0;   // Moltiplicatore per la forza degli swing (1.0 = standard)
input color M_Color = clrRed;       // Colore per pattern M
input color W_Color = clrLime;      // Colore per pattern W
input color ZigZag_Color = clrGray; // Colore per le diagonali dello ZigZag
input color P3LineColor = clrYellow;// Colore per la semilinea del punto 3
input double MaxPercentP3 = 2.0;    // % massima per il punto 3 e per la semilinea su p1-p2
input double MaxPercentP4 = 10.0;   // % massima di deviazione del punto 4 rispetto al punto 2
input int CandlesClosed = 2;        // Numero di candele chiuse per confermare Buy/Sell
input int SignalWindow = 5;         // Finestra temporale per contare le candele di conferma
input int MinCandleDistance = 5;    // Distanza minima tra punti in candele
input int MaxPatterns = 10;         // Numero massimo di pattern da visualizzare
input bool ShowStopLoss = true;     // Mostra la linea di stop loss al livello di p2
input bool EnableDebug = false;     // Abilita log di debug

//+------------------------------------------------------------------+
//| Variabili globali                                                |
//+------------------------------------------------------------------+
struct SwingPoint {
   double price;
   datetime time;
   string type; // "High" o "Low"
};

SwingPoint swings[];
int swingCount = 0;
datetime lastProcessedTime = 0;
string patternTimes[];

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit() {
   ArrayResize(swings, (int)MathMax(1000, ChartGetInteger(0, CHART_VISIBLE_BARS) / 10));
   ArrayResize(patternTimes, MaxPatterns);
   swingCount = 0;
   lastProcessedTime = 0;
   return(INIT_SUCCEEDED);
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

   // Aggiornamento completo o incrementale
   int startPos = prev_calculated == 0 ? Depth : MathMax(rates_total - Depth - Backstep - 1, 0);
   if (prev_calculated == 0 || time[rates_total-1] > lastProcessedTime) {
      if (prev_calculated == 0) ObjectsDeleteAll(0, "MW_");

      DetectSwings(rates_total, startPos, high, low, time);
      DrawZigZag(time[rates_total-1]);

      if (swingCount >= 5) {
         IdentifyMWPattern(rates_total, time, close, low, high);
      }

      lastProcessedTime = time[rates_total-1];
   }

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Rileva Swing Points                                              |
//+------------------------------------------------------------------+
void DetectSwings(int rates_total, int startPos, const double &high[], const double &low[], const datetime &time[]) {
   if (startPos == Depth) swingCount = 0; // Reset solo la prima volta
   int lastHigh = -1, lastLow = -1;

   for (int i = startPos; i < rates_total - Backstep; i++) {
      bool isHigh = true, isLow = true;

      for (int j = 1; j <= Depth; j++) {
         if (i - j < 0 || i + j >= rates_total) continue;
         if (high[i] * SwingStrength <= high[i - j] || high[i] * SwingStrength <= high[i + j]) {
            isHigh = false;
            break;
         }
      }

      for (int j = 1; j <= Depth; j++) {
         if (i - j < 0 || i + j >= rates_total) continue;
         if (low[i] >= low[i - j] * SwingStrength || low[i] >= low[i + j] * SwingStrength) {
            isLow = false;
            break;
         }
      }

      if (isHigh && (lastHigh == -1 || i - lastHigh >= Backstep) && MathAbs(high[i] - low[i]) >= Deviation * Point()) {
         swings[swingCount].price = high[i];
         swings[swingCount].time = time[i];
         swings[swingCount].type = "High";
         swingCount++;
         lastHigh = i;
      } else if (isLow && (lastLow == -1 || i - lastLow >= Backstep) && MathAbs(high[i] - low[i]) >= Deviation * Point()) {
         swings[swingCount].price = low[i];
         swings[swingCount].time = time[i];
         swings[swingCount].type = "Low";
         swingCount++;
         lastLow = i;
      }

      if (swingCount >= ArraySize(swings)) {
         ArrayResize(swings, swingCount + 1000);
      }
   }
   if (EnableDebug) Print("Swing rilevati: ", swingCount);
}

//+------------------------------------------------------------------+
//| Disegna le Diagonali dello ZigZag                                |
//+------------------------------------------------------------------+
void DrawZigZag(datetime currentTime) {
   if (swingCount < 2) return;

   for (int i = 0; i < swingCount - 1; i++) {
      string objName = "MW_ZigZag_" + IntegerToString(i) + "_" + TimeToString(swings[i].time);
      ObjectCreate(0, objName, OBJ_TREND, 0, swings[i].time, swings[i].price, swings[i+1].time, swings[i+1].price);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, ZigZag_Color);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);
   }
}

//+------------------------------------------------------------------+
//| Identifica Pattern MW                                            |
//+------------------------------------------------------------------+
void IdentifyMWPattern(int rates_total, const datetime &time[], const double &close[], const double &low[], const double &high[]) {
   if (swingCount < 5) return;

   int patternCount = 0;
   for (int start = 0; start <= swingCount - 5 && patternCount < MaxPatterns; start++) {
      SwingPoint p[5];
      for (int i = 0; i < 5; i++) {
         p[i] = swings[start + i];
      }

      // Pattern "W" (rialzista)
      if (p[0].type == "High" && p[1].type == "Low" && p[2].type == "High" && 
          p[3].type == "Low" && p[4].type == "High") {
         double range = p[0].price - p[1].price;
         double p3Distance = p[2].price - p[1].price;
         double p4Distance = MathAbs(p[3].price - p[1].price);
         double percentP3 = (p3Distance / range) * 100.0;
         double percentP4 = (p4Distance / range) * 100.0;
         if (p[2].price > p[1].price && p[2].price < p[0].price && 
             percentP3 <= MaxPercentP3 && 
             p[3].price >= p[1].price && percentP4 <= MaxPercentP4 && 
             (p[2].time - p[1].time) >= MinCandleDistance * PeriodSeconds(_Period)) {
            DrawPattern(p, "W", p[4].time, W_Color);
            CheckBuySignal(rates_total, time, close, low, p[1], p[2], p[4].time);
            patternTimes[patternCount] = TimeToString(p[4].time);
            patternCount++;
            if (EnableDebug) Print("Pattern W at ", TimeToString(p[4].time));
         }
      }
      // Pattern "M" (ribassista)
      else if (p[0].type == "Low" && p[1].type == "High" && p[2].type == "Low" && 
               p[3].type == "High" && p[4].type == "Low") {
         double range = p[1].price - p[0].price;
         double p3Distance = p[1].price - p[2].price;
         double p4Distance = MathAbs(p[3].price - p[1].price);
         double percentP3 = (p3Distance / range) * 100.0;
         double percentP4 = (p4Distance / range) * 100.0;
         if (p[2].price < p[1].price && p[2].price > p[0].price && 
             percentP3 <= MaxPercentP3 && 
             p[3].price <= p[1].price && percentP4 <= MaxPercentP4 && 
             (p[2].time - p[1].time) >= MinCandleDistance * PeriodSeconds(_Period)) {
            DrawPattern(p, "M", p[4].time, M_Color);
            CheckSellSignal(rates_total, time, close, high, p[1], p[2], p[4].time);
            patternTimes[patternCount] = TimeToString(p[4].time);
            patternCount++;
            if (EnableDebug) Print("Pattern M at ", TimeToString(p[4].time));
         }
      }
   }
   if (EnableDebug) Print("Pattern trovati: ", patternCount);
}

//+------------------------------------------------------------------+
//| Verifica Segnale Buy                                             |
//+------------------------------------------------------------------+
void CheckBuySignal(int rates_total, const datetime &time[], const double &close[], const double &low[], 
                    SwingPoint &p2, SwingPoint &p3, datetime patternTime) {
   int closedCandles = 0;
   bool valid = true;
   string objName = "MW_Buy_" + TimeToString(patternTime);
   string arrowName = "MW_Buy_Arrow_" + TimeToString(patternTime);
   if (ObjectFind(0, objName) >= 0) return;

   for (int i = rates_total - 1; i >= 0 && (rates_total - i) <= SignalWindow; i--) {
      if (time[i] <= p3.time) break;
      if (low[i] < p2.price) {
         valid = false;
         break;
      }
      if (close[i] > p3.price) closedCandles++;
      if (closedCandles >= CandlesClosed && valid) {
         ObjectCreate(0, objName, OBJ_TEXT, 0, time[i], p3.price + 20 * Point());
         ObjectSetString(0, objName, OBJPROP_TEXT, "Buy");
         ObjectSetInteger(0, objName, OBJPROP_COLOR, W_Color);
         ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);

         ObjectCreate(0, arrowName, OBJ_ARROW_UP, 0, time[i], close[i]);
         ObjectSetInteger(0, arrowName, OBJPROP_COLOR, clrGreen);
         ObjectSetInteger(0, arrowName, OBJPROP_WIDTH, 1);
         ObjectSetInteger(0, arrowName, OBJPROP_BACK, true);
         break;
      }
   }
}

//+------------------------------------------------------------------+
//| Verifica Segnale Sell                                            |
//+------------------------------------------------------------------+
void CheckSellSignal(int rates_total, const datetime &time[], const double &close[], const double &high[], 
                     SwingPoint &p2, SwingPoint &p3, datetime patternTime) {
   int closedCandles = 0;
   bool valid = true;
   string objName = "MW_Sell_" + TimeToString(patternTime);
   string arrowName = "MW_Sell_Arrow_" + TimeToString(patternTime);
   if (ObjectFind(0, objName) >= 0) return;

   for (int i = rates_total - 1; i >= 0 && (rates_total - i) <= SignalWindow; i--) {
      if (time[i] <= p3.time) break;
      if (high[i] > p2.price) {
         valid = false;
         break;
      }
      if (close[i] < p3.price) closedCandles++;
      if (closedCandles >= CandlesClosed && valid) {
         ObjectCreate(0, objName, OBJ_TEXT, 0, time[i], p3.price - 20 * Point());
         ObjectSetString(0, objName, OBJPROP_TEXT, "Sell");
         ObjectSetInteger(0, objName, OBJPROP_COLOR, M_Color);
         ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);

         ObjectCreate(0, arrowName, OBJ_ARROW_DOWN, 0, time[i], close[i]);
         ObjectSetInteger(0, arrowName, OBJPROP_COLOR, clrRed);
         ObjectSetInteger(0, arrowName, OBJPROP_WIDTH, 1);
         ObjectSetInteger(0, arrowName, OBJPROP_BACK, true);
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

   // Etichette per i punti 1-5
   for (int i = 0; i < 5; i++) {
      objName = "MW_Label_" + IntegerToString(i) + "_" + TimeToString(patternTime);
      string labelText = IntegerToString(i+1);
      ObjectCreate(0, objName, OBJ_TEXT, 0, p[i].time, p[i].price + (p[i].type == "High" ? 10 * Point() : -10 * Point()));
      ObjectSetString(0, objName, OBJPROP_TEXT, labelText);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
      ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 10);
      ObjectSetInteger(0, objName, OBJPROP_ANCHOR, p[i].type == "High" ? ANCHOR_BOTTOM : ANCHOR_TOP);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);
   }

   // Semilinea sul punto 3
   objName = "MW_P3_Line_" + TimeToString(patternTime);
   datetime endTimeP3 = p[2].time + PeriodSeconds(_Period) * 24;
   ObjectCreate(0, objName, OBJ_TREND, 0, p[2].time, p[2].price, endTimeP3, p[2].price);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, P3LineColor);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);

   // Semilinea sulla diagonale p1-p2
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

   // Linea di Stop Loss
   if (ShowStopLoss) {
      objName = "MW_SL_Line_" + TimeToString(patternTime);
      datetime endTimeSL = p[4].time + PeriodSeconds(_Period) * 24;
      ObjectCreate(0, objName, OBJ_TREND, 0, p[4].time, p[1].price, endTimeSL, p[1].price);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clrGray);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);
   }

   // Nome del pattern con font piccolo e candele
   objName = "MW_Pattern_" + TimeToString(patternTime);
   string patternText = "Pattern " + patternName + " [" + PeriodToString(_Period) + "] " + IntegerToString(CandlesClosed);
   ObjectCreate(0, objName, OBJ_TEXT, 0, p[2].time, p[2].price + (patternName == "M" ? -30 * Point() : 30 * Point()));
   ObjectSetString(0, objName, OBJPROP_TEXT, patternText);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 6);
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

//+------------------------------------------------------------------+
//| Deinizializzazione                                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, "MW_");
}