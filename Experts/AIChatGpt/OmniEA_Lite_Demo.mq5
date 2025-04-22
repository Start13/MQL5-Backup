//+------------------------------------------------------------------+
//|                                           OmniEA_Lite_Demo.mq5 |
//|                                       Copyright 2025, BlueTrendTeam |
//|                                       https://github.com/Start13/OmniEA-Lite-ChatGPT |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://github.com/Start13/OmniEA-Lite-ChatGPT"
#property version   "1.00"

// Include necessari
#include <Trade\Trade.mqh>
#include <AIChatGpt\BuffXXLabels.mqh>
#include <AIChatGpt\ReportGenerator.mqh>

// Parametri di input
input int      FastMA_Period = 12;          // Periodo della media mobile veloce
input int      SlowMA_Period = 26;          // Periodo della media mobile lenta
input int      Signal_Period = 9;           // Periodo della linea di segnale
input double   Lot_Size = 0.1;              // Volume di trading
input int      Report_Interval = 60;        // Intervallo per la generazione del report (minuti)

// Variabili globali
CTrade         trade;                        // Oggetto per le operazioni di trading
CBuffXXLabels  buffer_labels;                // Oggetto per le etichette dei buffer
CReportGenerator report_generator;           // Oggetto per la generazione di report
int            macd_handle;                  // Handle dell'indicatore MACD
double         macd_buffer[];               // Buffer principale del MACD
double         signal_buffer[];             // Buffer della linea di segnale
double         hist_buffer[];               // Buffer dell'istogramma
datetime       last_report_time;            // Orario dell'ultimo report generato

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializzazione dell'indicatore MACD
   macd_handle = iMACD(_Symbol, PERIOD_CURRENT, FastMA_Period, SlowMA_Period, Signal_Period, PRICE_CLOSE);
   if(macd_handle == INVALID_HANDLE)
   {
      Print("Errore nella creazione dell'indicatore MACD: ", GetLastError());
      return(INIT_FAILED);
   }
   
   // Inizializzazione dei buffer
   ArraySetAsSeries(macd_buffer, true);
   ArraySetAsSeries(signal_buffer, true);
   ArraySetAsSeries(hist_buffer, true);
   
   // Inizializzazione delle etichette dei buffer
   buffer_labels.Init("BuffXX_", CORNER_RIGHT_UPPER, 10, 20, 20, 10, "Arial", clrWhite);
   buffer_labels.SetBufferName(0, "MACD");
   buffer_labels.SetBufferName(1, "Signal");
   buffer_labels.SetBufferName(2, "Hist");
   buffer_labels.SetBufferColor(0, clrBlue);
   buffer_labels.SetBufferColor(1, clrRed);
   buffer_labels.SetBufferColor(2, clrGreen);
   
   // Inizializzazione del generatore di report
   report_generator.Init("OmniEA_Reports", "OmniEA_Lite_Demo_", ",");
   
   // Memorizzazione dell'orario corrente per il report
   last_report_time = TimeCurrent();
   
   // Impostazione del commento del grafico
   Comment("OmniEA Lite Demo - Inizializzato");
   
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
   if(macd_handle != INVALID_HANDLE)
      IndicatorRelease(macd_handle);
      
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
   if(CopyBuffer(macd_handle, 0, 0, 3, macd_buffer) <= 0)
   {
      Print("Errore nella copia del buffer MACD: ", GetLastError());
      return false;
   }
   
   if(CopyBuffer(macd_handle, 1, 0, 3, signal_buffer) <= 0)
   {
      Print("Errore nella copia del buffer Signal: ", GetLastError());
      return false;
   }
   
   if(CopyBuffer(macd_handle, 2, 0, 3, hist_buffer) <= 0)
   {
      Print("Errore nella copia del buffer Hist: ", GetLastError());
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
   buffer_labels.UpdateLabel(0, macd_buffer[0]);
   buffer_labels.UpdateLabel(1, signal_buffer[0]);
   buffer_labels.UpdateLabel(2, hist_buffer[0]);
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
   // Segnale di acquisto: MACD attraversa la linea di segnale dal basso verso l'alto
   return (macd_buffer[1] < signal_buffer[1] && macd_buffer[0] > signal_buffer[0]);
}

//+------------------------------------------------------------------+
//| Verifica se c'è un segnale di vendita                            |
//+------------------------------------------------------------------+
bool IsSignalToSell()
{
   // Segnale di vendita: MACD attraversa la linea di segnale dall'alto verso il basso
   return (macd_buffer[1] > signal_buffer[1] && macd_buffer[0] < signal_buffer[0]);
}

//+------------------------------------------------------------------+
//| Apre una posizione di acquisto                                   |
//+------------------------------------------------------------------+
void OpenBuyPosition()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl = ask - 100 * _Point;
   double tp = ask + 200 * _Point;
   
   if(trade.Buy(Lot_Size, _Symbol, ask, sl, tp, "OmniEA Lite Demo - Buy"))
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
         "MACD Cross Up"       // Commento
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
   
   if(trade.Sell(Lot_Size, _Symbol, bid, sl, tp, "OmniEA Lite Demo - Sell"))
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
         "MACD Cross Down"     // Commento
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
      report_generator.AddIndicatorValue("MACD", 0, macd_buffer[0]);
      report_generator.AddIndicatorValue("Signal", 1, signal_buffer[0]);
      report_generator.AddIndicatorValue("Hist", 2, hist_buffer[0]);
      
      // Generazione del report
      string filename = "OmniEA_Lite_Demo_" + TimeToString(current_time, TIME_DATE) + "_" + TimeToString(current_time, TIME_MINUTES) + ".html";
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
   report_generator.AddIndicatorValue("MACD", 0, macd_buffer[0]);
   report_generator.AddIndicatorValue("Signal", 1, signal_buffer[0]);
   report_generator.AddIndicatorValue("Hist", 2, hist_buffer[0]);
   
   // Generazione dei report in diversi formati
   datetime current_time = TimeCurrent();
   string base_filename = "OmniEA_Lite_Demo_Final_" + TimeToString(current_time, TIME_DATE);
   
   report_generator.GenerateCSVReport(base_filename + ".csv");
   report_generator.GenerateTXTReport(base_filename + ".txt");
   report_generator.GenerateHTMLReport(base_filename + ".html");
   
   Print("Report finali generati con successo");
}
