#include <Trade\Trade.mqh> // Libreria per gestire gli ordini
CTrade trade;

// Input dell'utente
input double lotSize = 0.1;          // Dimensione del lotto
input double maxDD = 10.0;           // Drawdown massimo accettabile (%)
input int optimizationInterval = 3600; // Intervallo di ottimizzazione (secondi)
input int zigzagDepth = 12;          // Profondità ZigZag
input int zigzagDeviation = 5;       // Deviazione ZigZag
input int zigzagBackstep = 3;        // Backstep ZigZag
input int confirmCandlesInitial = 2; // Numero iniziale di candele di conferma

// Variabili globali
int zigzagHandle;                    // Handle dell'indicatore ZigZag
int confirmCandles;                  // Numero corrente di candele di conferma
datetime lastOptimization = 0;       // Timestamp ultima ottimizzazione
double mem1 = 0, mem2 = 0, mem3 = 0, mem4 = 0; // Valori memorizzati
int mem1Bar = 0, mem2Bar = 0, mem3Bar = 0, mem4Bar = 0; // Posizioni dei punti
bool waitingForConfirmation = false; // Stato di attesa per il superamento

// Struttura per l'autoapprendimento
struct ParamEffect {
   double paramValue; // Valore del parametro modificato (confirmCandles)
   double profit;     // Profitto risultante
   double dd;         // Drawdown risultante
};
ParamEffect paramHistory[]; // Array per salvare la cronologia degli effetti

// Inizializzazione
void OnInit() {
   confirmCandles = confirmCandlesInitial; // Imposta il valore iniziale
   zigzagHandle = iCustom(NULL, 0, "ZigZag", zigzagDepth, zigzagDeviation, zigzagBackstep);
   if(zigzagHandle == INVALID_HANDLE) {
      Print("Errore caricamento indicatore ZigZag");
      return;
   }
   LoadBacktestData();
   DrawPoints(); // Inizializza i punti sul grafico
}

// Esecuzione a ogni tick
void OnTick() {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   // Leggi i dati ZigZag
   double zigzag[];
   if(CopyBuffer(zigzagHandle, 0, 0, 100, zigzag) < 0) {
      Print("Errore lettura ZigZag");
      return;
   }

   // Trova i punti chiave
   double peaks[5];
   int peakBars[5];
   int peakCount = 0;

   for(int i = ArraySize(zigzag) - 1; i >= 0 && peakCount < 5; i--) {
      if(zigzag[i] > 0) {
         peaks[peakCount] = zigzag[i];
         peakBars[peakCount] = i;
         peakCount++;
      }
   }

   if(peakCount >= 5 && !waitingForConfirmation) {
      // Punto 1: massimo iniziale (trend ribassista)
      mem1 = peaks[4];
      mem1Bar = peakBars[4];

      // Punto 2: minimo successivo (trend ribassista)
      mem2 = peaks[3];
      mem2Bar = peakBars[3];
      if(mem2 < mem1) {
         // Punto 3: massimo successivo (trend rialzista)
         mem3 = peaks[2];
         mem3Bar = peakBars[2];
         if(mem3 > mem2) {
            // Punto 4: minimo successivo (trend ribassista, non inferiore a mem2)
            mem4 = peaks[1];
            mem4Bar = peakBars[1];
            if(mem4 < mem3 && mem4 >= mem2) {
               // Verifica il trend rialzista successivo
               double lastPeak = peaks[0];
               if(lastPeak > mem4) {
                  waitingForConfirmation = true;
                  Print("Condizioni M&W soddisfatte. In attesa di conferma sopra mem3: ", mem3);
               }
            }
         }
      }
   }

   // Verifica il superamento di mem3 con candele di conferma
   if(waitingForConfirmation && !PositionSelect(_Symbol)) {
      double close[];
      if(CopyClose(_Symbol, PERIOD_CURRENT, 0, confirmCandles + 1, close) < 0) return;

      int confirmCount = 0;
      for(int i = 0; i < confirmCandles; i++) {
         if(close[i] > mem3) confirmCount++;
      }
      if(confirmCount == confirmCandles && close[confirmCandles] > mem3) {
         trade.Buy(lotSize, _Symbol, ask, 0, 0, "Buy M&W");
         waitingForConfirmation = false;
         Print("Buy aperto: superamento di mem3 confermato");
      }
   }

   // Aggiorna la visualizzazione dei punti
   DrawPoints();

   // Ottimizza i parametri
   OptimizeParameters();
}

// Deinizializzazione
void OnDeinit(const int reason) {
   ArrayFree(paramHistory);
   IndicatorRelease(zigzagHandle);
   ObjectsDeleteAll(0, "MW_"); // Rimuove tutti gli oggetti dal grafico
}

// Visualizzazione dei punti sul grafico
void DrawPoints() {
   // Disegna la linea ZigZag
   double zigzag[];
   if(CopyBuffer(zigzagHandle, 0, 0, 100, zigzag) < 0) return;
   for(int i = 0; i < ArraySize(zigzag) - 1; i++) {
      if(zigzag[i] > 0 && zigzag[i + 1] > 0) {
         ObjectCreate(0, "MW_ZigZag_" + IntegerToString(i), OBJ_TREND, 0, 
                      iTime(_Symbol, PERIOD_CURRENT, i), zigzag[i], 
                      iTime(_Symbol, PERIOD_CURRENT, i + 1), zigzag[i + 1]);
         ObjectSetInteger(0, "MW_ZigZag_" + IntegerToString(i), OBJPROP_COLOR, clrYellow);
         ObjectSetInteger(0, "MW_ZigZag_" + IntegerToString(i), OBJPROP_WIDTH, 1);
      }
   }

   // Disegna i punti 1, 2, 3, 4
   if(mem1 > 0) {
      ObjectCreate(0, "MW_Point1", OBJ_TEXT, 0, iTime(_Symbol, PERIOD_CURRENT, mem1Bar), mem1);
      ObjectSetString(0, "MW_Point1", OBJPROP_TEXT, "1");
      ObjectSetInteger(0, "MW_Point1", OBJPROP_COLOR, clrRed);
   }
   if(mem2 > 0) {
      ObjectCreate(0, "MW_Point2", OBJ_TEXT, 0, iTime(_Symbol, PERIOD_CURRENT, mem2Bar), mem2);
      ObjectSetString(0, "MW_Point2", OBJPROP_TEXT, "2");
      ObjectSetInteger(0, "MW_Point2", OBJPROP_COLOR, clrGreen);
   }
   if(mem3 > 0) {
      ObjectCreate(0, "MW_Point3", OBJ_TEXT, 0, iTime(_Symbol, PERIOD_CURRENT, mem3Bar), mem3);
      ObjectSetString(0, "MW_Point3", OBJPROP_TEXT, "3");
      ObjectSetInteger(0, "MW_Point3", OBJPROP_COLOR, clrBlue);
   }
   if(mem4 > 0) {
      ObjectCreate(0, "MW_Point4", OBJ_TEXT, 0, iTime(_Symbol, PERIOD_CURRENT, mem4Bar), mem4);
      ObjectSetString(0, "MW_Point4", OBJPROP_TEXT, "4");
      ObjectSetInteger(0, "MW_Point4", OBJPROP_COLOR, clrOrange);
   }
}

// Ottimizzazione dei parametri
void OptimizeParameters() {
   if(TimeCurrent() - lastOptimization < optimizationInterval) return;

   double currentProfit = AccountProfit(); // Profitto corrente
   double currentDD = CalculateDrawdown(); // Drawdown corrente

   ParamEffect newEffect;
   newEffect.paramValue = confirmCandles;
   newEffect.profit = currentProfit;
   newEffect.dd = currentDD;
   ArrayResize(paramHistory, ArraySize(paramHistory) + 1);
   paramHistory[ArraySize(paramHistory) - 1] = newEffect;

   if(currentDD > maxDD || currentProfit < 0) {
      confirmCandles += (currentProfit < 0) ? 1 : -1;
      confirmCandles = MathMax(1, MathMin(confirmCandles, 5));
      Print("Nuovo numero di candele di conferma: ", confirmCandles);
   }

   if(ArraySize(paramHistory) > 1000) {
      ArrayRemove(paramHistory, 0, 500);
      Print("Pulizia memoria: rimossi 500 elementi da paramHistory");
   }

   lastOptimization = TimeCurrent();
}

// Calcolo del drawdown
double CalculateDrawdown() {
   double equity = AccountEquity();    // Patrimonio corrente
   double balance = AccountBalance();  // Saldo del conto
   if(balance == 0) return 0;
   return (balance - equity) / balance * 100; // DD in %
}

// Caricamento dati dai backtest
void LoadBacktestData() {
   int fileHandle = FileOpen("backtest_results.csv", FILE_READ | FILE_CSV, ";");
   if(fileHandle != INVALID_HANDLE) {
      while(!FileIsEnding(fileHandle)) {
         ParamEffect effect;
         effect.paramValue = StringToDouble(FileReadString(fileHandle));
         effect.profit = StringToDouble(FileReadString(fileHandle));
         effect.dd = StringToDouble(FileReadString(fileHandle));
         ArrayResize(paramHistory, ArraySize(paramHistory) + 1);
         paramHistory[ArraySize(paramHistory) - 1] = effect;
      }
      FileClose(fileHandle);
      Print("Caricati ", ArraySize(paramHistory), " risultati dai backtest");
   }
}