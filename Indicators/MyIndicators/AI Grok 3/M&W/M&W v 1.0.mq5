#property copyright "xAI - Grok 3"
#property link      "https://xai.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//+------------------------------------------------------------------+
//| Input                                                            |
//+------------------------------------------------------------------+
input int Depth = 12;               // Profondità per rilevare swing
input int Deviation = 5;            // Deviazione in punti (non usato direttamente, mantenuto per compatibilità)
input int Backstep = 3;             // Passo indietro per confermare swing
input color M_Color = clrRed;       // Colore per pattern M
input color W_Color = clrLime;      // Colore per pattern W
input color ZigZag_Color = clrGray; // Colore per le diagonali dello ZigZag
input double MaxPercentP3 = 2.0;    // % massima per il punto 3 e per la semilinea su p1-p2
input int CandlesClosed = 2;        // Numero di candele chiuse per confermare Buy/Sell

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
      if (prev_calculated == 0) ObjectsDeleteAll(0, "MW_");

      DetectSwings(rates_total, high, low, time);
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
void DetectSwings(int rates_total, const double &high[], const double &low[], const datetime &time[]) {
   swingCount = 0;
   int lastHigh = -1, lastLow = -1;

   for (int i = Depth; i < rates_total - Backstep; i++) {
      bool isHigh = true, isLow = true;

      for (int j = 1; j <= Depth; j++) {
         if (i - j < 0 || i + j >= rates_total) continue;
         if (high[i] <= high[i - j] || high[i] <= high[i + j]) {
            isHigh = false;
            break;
         }
      }

      for (int j = 1; j <= Depth; j++) {
         if (i - j < 0 || i + j >= rates_total) continue;
         if (low[i] >= low[i - j] || low[i] >= low[i + j]) {
            isLow = false;
            break;
         }
      }

      if (isHigh && (lastHigh == -1 || i - lastHigh >= Backstep)) {
         swings[swingCount].price = high[i];
         swings[swingCount].time = time[i];
         swings[swingCount].type = "High";
         swingCount++;
         lastHigh = i;
      } else if (isLow && (lastLow == -1 || i - lastLow >= Backstep)) {
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
            CheckBuySignal(rates_total, time, close, low, p[1], p[2], p[4].time);
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
            CheckSellSignal(rates_total, time, close, high, p[1], p[2], p[4].time);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Verifica Segnale Buy                                             |
//+------------------------------------------------------------------+
void CheckBuySignal(int rates_total, const datetime &time[], const double &close[], const double &low[], 
                    SwingPoint &p2, SwingPoint &p3, datetime patternTime) {
   int closedCandles = 0;
   bool valid = true;
   string objName = "MW_Buy_" + TimeToString(patternTime);
   if (ObjectFind(0, objName) >= 0) return; // Se il segnale esiste già, esci

   for (int i = rates_total - 1; i >= 0; i--) {
      if (time[i] <= p3.time) break; // Non contare candele prima di p3
      if (low[i] < p2.price) { // Se il prezzo scende sotto p2, il pattern non è più valido
         valid = false;
         break;
      }
      if (close[i] > p3.price) closedCandles++;
      else closedCandles = 0; // Reset se la candela non chiude sopra p3
      if (closedCandles >= CandlesClosed && valid) {
         ObjectCreate(0, objName, OBJ_TEXT, 0, time[i], p3.price + 20 * Point());
         ObjectSetString(0, objName, OBJPROP_TEXT, "Buy");
         ObjectSetInteger(0, objName, OBJPROP_COLOR, W_Color);
         ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);
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
   if (ObjectFind(0, objName) >= 0) return; // Se il segnale esiste già, esci

   for (int i = rates_total - 1; i >= 0; i--) {
      if (time[i] <= p3.time) break; // Non contare candele prima di p3
      if (high[i] > p2.price) { // Se il prezzo sale sopra p2, il pattern non è più valido
         valid = false;
         break;
      }
      if (close[i] < p3.price) closedCandles++;
      else closedCandles = 0; // Reset se la candela non chiude sotto p3
      if (closedCandles >= CandlesClosed && valid) {
         ObjectCreate(0, objName, OBJ_TEXT, 0, time[i], p3.price - 20 * Point());
         ObjectSetString(0, objName, OBJPROP_TEXT, "Sell");
         ObjectSetInteger(0, objName, OBJPROP_COLOR, M_Color);
         ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12);
         ObjectSetInteger(0, objName, OBJPROP_BACK, true);
         break;
      }
   }
}

//+------------------------------------------------------------------+
//| Disegna Pattern sul Grafico                                      |
//+------------------------------------------------------------------+
void DrawPattern(SwingPoint &p[], string patternName, datetime patternTime, color patternColor) {
   string objName;

   // Linee tratteggiate tra i punti del pattern
   for (int i = 0; i < 4; i++) {
      objName = "MW_Line_" + IntegerToString(i) + "_" + TimeToString(patternTime);
      ObjectCreate(0, objName, OBJ_TREND, 0, p[i].time, p[i].price, p[i+1].time, p[i+1].price);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DASH);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, objName, OBJPROP_BACK, true);
   }

   // Etichette con solo numero per i punti 1-5
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

   // Semilinea orizzontale sul punto 3 (24 candele)
   objName = "MW_P3_Line_" + TimeToString(patternTime);
   datetime endTimeP3 = p[2].time + PeriodSeconds(_Period) * 24;
   ObjectCreate(0, objName, OBJ_TREND, 0, p[2].time, p[2].price, endTimeP3, p[2].price);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);

   // Semilinea orizzontale sulla diagonale p1-p2 al livello % impostato (interseca la diagonale)
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

   // Nome del pattern
   objName = "MW_Pattern_" + TimeToString(patternTime);
   string patternText = "Pattern " + patternName + " [" + PeriodToString(_Period) + "]";
   ObjectCreate(0, objName, OBJ_TEXT, 0, p[2].time, p[2].price + (patternName == "M" ? -30 * Point() : 30 * Point()));
   ObjectSetString(0, objName, OBJPROP_TEXT, patternText);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, patternColor);
   ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, objName, OBJPROP_BACK, true);
}

//+------------------------------------------------------------------+
//| Calcola il tempo di intersezione della diagonale p1-p2           |
//+------------------------------------------------------------------+
datetime CalculateIntersectionTime(SwingPoint &p1, SwingPoint &p2, double priceLevel) {
   double priceDiff = p2.price - p1.price;
   datetime timeDiff = p2.time - p1.time;
   if (timeDiff == 0) return p1.time; // Evita divisione per zero
   double slope = priceDiff / (double)timeDiff; // Pendenza della diagonale
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