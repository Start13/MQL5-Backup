//+------------------------------------------------------------------+
//| Script: ExportOptimizerScript.mq5                                |
//| Descrizione: Esempio di script per generare un file .set         |
//+------------------------------------------------------------------+
#include <AIChatGpt/OptimizerGenerator.mqh>  // Assicurati che il percorso sia corretto

void OnStart()
{
   Print("🚀 Inizio generazione file ottimizzazione...");

   OptimizerGenerator gen;

   // 🔧 Parametri da esportare per ottimizzazione (aggiungi i tuoi)
   gen.Add("Lots",     0.1, 0.1, 1.0);        // es: da 0.1 a 1.0 con step 0.1
   gen.Add("TakeProfit", 10, 10, 100);        // es: da 10 a 100 con step 10
   gen.Add("StopLoss",  10, 10, 100);         // es: da 10 a 100 con step 10
   gen.Add("TrailingStop", 0, 10, 50);        // es: trailing da 0 a 50

   // 📁 Percorso file .set (relativo a /MQL5/Files/)
   string filename = "OptFiles\\export_ottimizzazione.set";

   gen.SaveToFile(filename);

   Print("✅ Esportazione completata. File creato: ", filename);
}
