//+------------------------------------------------------------------+
//|                                           OmniEA_Lite_Demo.mq5 |
//|                                       Copyright 2025, BlueTrendTeam |
//|                                       https://github.com/Start13/OmniEA-Lite-Gemini |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://github.com/Start13/OmniEA-Lite-Gemini"
#property version   "1.00"

// Include necessari
#include <Trade\Trade.mqh>
#include <AIGemini\BuffXXLabels.mqh>
#include <AIGemini\ReportGenerator.mqh>

// Parametri di input
input int      Stoch_KPeriod = 5;         // Periodo %K dello Stocastico
input int      Stoch_DPeriod = 3;         // Periodo %D dello Stocastico
input int      Stoch_Slowing = 3;         // Periodo di rallentamento dello Stocastico
input int      Stoch_UpperLevel = 80;     // Livello superiore dello Stocastico
input int      Stoch_LowerLevel = 20;     // Livello inferiore dello Stocastico
input double   Lot_Size = 0.1;            // Volume di trading
input int      Report_Interval = 60;      // Intervallo per la generazione del report (minuti)

// Variabili globali
CTrade         trade;                      // Oggetto per le operazioni di trading
CBuffXXLabels  buffer_labels;              // Oggetto per le etichette dei buffer
CReportGenerator report_generator;         // Oggetto per la generazione di report
int            stoch_handle;               // Handle dell'indicatore Stocastico
double         stoch_main_buffer[];        // Buffer principale dello Stocastico (%K)
double         stoch_signal_buffer[];      // Buffer del segnale dello Stocastico (%D)
datetime       last_report_time;           // Orario dell'ultimo report generato

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializzazione dell'indicatore Stocastico
   stoch_handle = iStochastic(_Symbol, PERIOD_CURRENT, Stoch_KPeriod, Stoch_DPeriod, Stoch_Slowing, MODE_SMA, STO_LOWHIGH);
   if(stoch_handle == INVALID_HANDLE)
   {
      Print("Errore nella creazione dell'indicatore Stocastico: ", GetLastError());
      return(INIT_FAILED);
   }
   
   // Inizializzazione dei buffer
   ArraySetAsSeries(stoch_main_buffer, true);
   ArraySetAsSeries(stoch_signal_buffer, true);
   
   // Inizializzazione delle etichette dei buffer
   buffer_labels.Init("BuffXX_", CORNER_RIGHT_UPPER, 10, 20, 20, 10, "Arial", clrWhite);
   buffer_labels.SetBufferName(0, "Stoch %K");
   buffer_labels.SetBufferName(1, "Stoch %D");
   buffer_labels.SetBufferColor(0, clrBlue);
   buffer_labels.SetBufferColor(1, clrRed);
   
   // Inizializzazione del generatore di report
   report_generator.Init("OmniEA_Reports", "OmniEA_Lite_Gemini_", ",");
   
   // Memorizzazione dell'orario corrente per il report
   last_report_time = TimeCurrent();
   
   // Impostazione del commento del grafico
   Comment("OmniEA Lite Demo (Gemini) - Inizializzato");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Rimozione delle etichette dei buffer
   buffer_labels.RemoveAllLabels();
   
   // Generazione del report finale
   GenerateFinalReport();
   
   // Rilascio dell'handle dell'indicatore
   if(stoch_handle != INVALID_HANDLE)
      IndicatorRelease(stoch_handle);
      
   // Rimozione del commento del grafico
   Comment("");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Aggiornamento dei buffer dell'indicatore
   if(!UpdateIndicatorBuffers())
      return;
      
   // Aggiornamento delle etichette dei buffer
   UpdateBufferLabels();
   
   // Verifica se è il momento di generare un report
   CheckReportTime();
   
   // Logica di trading (esempio semplificato)
   if(CanOpenPosition())
   {
      if(IsSignalToBuy())
         OpenBuyPosition();
      else if(IsSignalToSell())
         OpenSellPosition();
   }
   
   // Gestione delle posizioni aperte
   ManageOpenPositions();
}

//+------------------------------------------------------------------+
//| Aggiorna i buffer dell'indicatore                                |
//+------------------------------------------------------------------+
bool UpdateIndicatorBuffers()
{
   // Copia i dati dei buffer dell'indicatore
   if(CopyBuffer(stoch_handle, 0, 0, 3, stoch_main_buffer) <= 0)
   {
      Print("Errore nella copia del buffer Stoch Main: ", GetLastError());
      return false;
   }
   
   if(CopyBuffer(stoch_handle, 1, 0, 3, stoch_signal_buffer) <= 0)
   {
      Print("Errore nella copia del buffer Stoch Signal: ", GetLastError());
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Aggiorna le etichette dei buffer                                 |
//+------------------------------------------------------------------+
void UpdateBufferLabels()
{
   // Aggiornamento delle etichette con i valori correnti dei buffer
   buffer_labels.UpdateLabel(0, stoch_main_buffer[0]);
   buffer_labels.UpdateLabel(1, stoch_signal_buffer[0]);
   
   // Aggiungiamo anche i livelli dello Stocastico
   buffer_labels.UpdateLabel(2, Stoch_UpperLevel, "UpperLevel");
   buffer_labels.UpdateLabel(3, Stoch_LowerLevel, "LowerLevel");
}

//+------------------------------------------------------------------+
//| Verifica se è possibile aprire una posizione                     |
//+------------------------------------------------------------------+
bool CanOpenPosition()
{
   // Verifica se ci sono già posizioni aperte
   int total = PositionsTotal();
   for(int i=0; i<total; i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol)
            return false; // C'è già una posizione aperta su questo simbolo
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Verifica se c'è un segnale di acquisto                           |
//+------------------------------------------------------------------+
bool IsSignalToBuy()
{
   // Segnale di acquisto: lo Stocastico attraversa il livello inferiore dal basso verso l'alto
   return (stoch_main_buffer[1] < Stoch_LowerLevel && stoch_main_buffer[0] > Stoch_LowerLevel &&
           stoch_main_buffer[0] > stoch_signal_buffer[0]);
}

//+------------------------------------------------------------------+
//| Verifica se c'è un segnale di vendita                            |
//+------------------------------------------------------------------+
bool IsSignalToSell()
{
   // Segnale di vendita: lo Stocastico attraversa il livello superiore dall'alto verso il basso
   return (stoch_main_buffer[1] > Stoch_UpperLevel && stoch_main_buffer[0] < Stoch_UpperLevel &&
           stoch_main_buffer[0] < stoch_signal_buffer[0]);
}

//+------------------------------------------------------------------+
//| Apre una posizione di acquisto                                   |
//+------------------------------------------------------------------+
void OpenBuyPosition()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl = ask - 100 * _Point;
   double tp = ask + 200 * _Point;
   
   if(trade.Buy(Lot_Size, _Symbol, ask, sl, tp, "OmniEA Lite Gemini - Buy"))
   {
      Print("Posizione di acquisto aperta: ", trade.ResultDeal());
      
      // Aggiungi il trade al report
      report_generator.AddTrade(
         TimeCurrent(),        // Orario di apertura (temporaneo)
         TimeCurrent(),        // Orario di chiusura (temporaneo)
         ask,                  // Prezzo di apertura
         0,                    // Prezzo di chiusura (temporaneo)
         0,                    // Profitto (temporaneo)
         Lot_Size,             // Volume
         0,                    // Tipo (0 = buy)
         _Symbol,              // Simbolo
         "Stoch Oversold"      // Commento
      );
   }
   else
   {
      Print("Errore nell'apertura della posizione di acquisto: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| Apre una posizione di vendita                                    |
//+------------------------------------------------------------------+
void OpenSellPosition()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = bid + 100 * _Point;
   double tp = bid - 200 * _Point;
   
   if(trade.Sell(Lot_Size, _Symbol, bid, sl, tp, "OmniEA Lite Gemini - Sell"))
   {
      Print("Posizione di vendita aperta: ", trade.ResultDeal());
      
      // Aggiungi il trade al report
      report_generator.AddTrade(
         TimeCurrent(),        // Orario di apertura (temporaneo)
         TimeCurrent(),        // Orario di chiusura (temporaneo)
         bid,                  // Prezzo di apertura
         0,                    // Prezzo di chiusura (temporaneo)
         0,                    // Profitto (temporaneo)
         Lot_Size,             // Volume
         1,                    // Tipo (1 = sell)
         _Symbol,              // Simbolo
         "Stoch Overbought"    // Commento
      );
   }
   else
   {
      Print("Errore nell'apertura della posizione di vendita: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| Gestisce le posizioni aperte                                     |
//+------------------------------------------------------------------+
void ManageOpenPositions()
{
   // Questo è solo un esempio semplificato
   // In un EA reale, qui si implementerebbe la logica per la gestione delle posizioni
   // come trailing stop, parziale chiusura, ecc.
}

//+------------------------------------------------------------------+
//| Verifica se è il momento di generare un report                   |
//+------------------------------------------------------------------+
void CheckReportTime()
{
   datetime current_time = TimeCurrent();
   
   // Verifica se è passato l'intervallo specificato dall'ultimo report
   if(current_time - last_report_time >= Report_Interval * 60)
   {
      // Aggiunta dei valori degli indicatori al report
      report_generator.AddIndicatorValue("Stoch %K", 0, stoch_main_buffer[0]);
      report_generator.AddIndicatorValue("Stoch %D", 1, stoch_signal_buffer[0]);
      
      // Generazione del report
      string filename = "OmniEA_Lite_Gemini_" + TimeToString(current_time, TIME_DATE) + "_" + TimeToString(current_time, TIME_MINUTES) + ".html";
      if(report_generator.GenerateHTMLReport(filename))
         Print("Report generato con successo: ", filename);
      
      // Aggiornamento dell'orario dell'ultimo report
      last_report_time = current_time;
   }
}

//+------------------------------------------------------------------+
//| Genera il report finale alla chiusura dell'EA                    |
//+------------------------------------------------------------------+
void GenerateFinalReport()
{
   // Aggiunta dei valori degli indicatori al report
   report_generator.AddIndicatorValue("Stoch %K", 0, stoch_main_buffer[0]);
   report_generator.AddIndicatorValue("Stoch %D", 1, stoch_signal_buffer[0]);
   
   // Generazione dei report in diversi formati
   datetime current_time = TimeCurrent();
   string base_filename = "OmniEA_Lite_Gemini_Final_" + TimeToString(current_time, TIME_DATE);
   
   report_generator.GenerateCSVReport(base_filename + ".csv");
   report_generator.GenerateTXTReport(base_filename + ".txt");
   report_generator.GenerateHTMLReport(base_filename + ".html");
   
   Print("Report finali generati con successo");
}
