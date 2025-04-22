//+------------------------------------------------------------------+
//|                                           OmniEA_Lite_Demo.mq5 |
//|                                       Copyright 2025, BlueTrendTeam |
//|                                       https://github.com/Start13/OmniEA-Lite-DeepSeek |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://github.com/Start13/OmniEA-Lite-DeepSeek"
#property version   "1.00"

// Include necessari
#include <Trade\Trade.mqh>
#include <AIDeepSeek\BuffXXLabels.mqh>
#include <AIDeepSeek\ReportGenerator.mqh>

// Parametri di input
input int      BB_Period = 20;            // Periodo delle Bollinger Bands
input double   BB_Deviation = 2.0;        // Deviazione delle Bollinger Bands
input double   Lot_Size = 0.1;            // Volume di trading
input int      Report_Interval = 60;      // Intervallo per la generazione del report (minuti)

// Variabili globali
CTrade         trade;                      // Oggetto per le operazioni di trading
CBuffXXLabels  buffer_labels;              // Oggetto per le etichette dei buffer
CReportGenerator report_generator;         // Oggetto per la generazione di report
int            bb_handle;                  // Handle dell'indicatore Bollinger Bands
double         bb_upper_buffer[];          // Buffer superiore delle Bollinger Bands
double         bb_middle_buffer[];         // Buffer medio delle Bollinger Bands
double         bb_lower_buffer[];          // Buffer inferiore delle Bollinger Bands
datetime       last_report_time;           // Orario dell'ultimo report generato

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializzazione dell'indicatore Bollinger Bands
   bb_handle = iBands(_Symbol, PERIOD_CURRENT, BB_Period, 0, BB_Deviation, PRICE_CLOSE);
   if(bb_handle == INVALID_HANDLE)
   {
      Print("Errore nella creazione dell'indicatore Bollinger Bands: ", GetLastError());
      return(INIT_FAILED);
   }
   
   // Inizializzazione dei buffer
   ArraySetAsSeries(bb_upper_buffer, true);
   ArraySetAsSeries(bb_middle_buffer, true);
   ArraySetAsSeries(bb_lower_buffer, true);
   
   // Inizializzazione delle etichette dei buffer
   buffer_labels.Init("BuffXX_", CORNER_RIGHT_UPPER, 10, 20, 20, 10, "Arial", clrWhite);
   buffer_labels.SetBufferName(0, "BB Upper");
   buffer_labels.SetBufferName(1, "BB Middle");
   buffer_labels.SetBufferName(2, "BB Lower");
   buffer_labels.SetBufferColor(0, clrRed);
   buffer_labels.SetBufferColor(1, clrBlue);
   buffer_labels.SetBufferColor(2, clrGreen);
   
   // Inizializzazione del generatore di report
   report_generator.Init("OmniEA_Reports", "OmniEA_Lite_DeepSeek_", ",");
   
   // Memorizzazione dell'orario corrente per il report
   last_report_time = TimeCurrent();
   
   // Impostazione del commento del grafico
   Comment("OmniEA Lite Demo (DeepSeek) - Inizializzato");
   
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
   if(bb_handle != INVALID_HANDLE)
      IndicatorRelease(bb_handle);
      
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
   if(CopyBuffer(bb_handle, 0, 0, 3, bb_upper_buffer) <= 0)
   {
      Print("Errore nella copia del buffer BB Upper: ", GetLastError());
      return false;
   }
   
   if(CopyBuffer(bb_handle, 1, 0, 3, bb_middle_buffer) <= 0)
   {
      Print("Errore nella copia del buffer BB Middle: ", GetLastError());
      return false;
   }
   
   if(CopyBuffer(bb_handle, 2, 0, 3, bb_lower_buffer) <= 0)
   {
      Print("Errore nella copia del buffer BB Lower: ", GetLastError());
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
   buffer_labels.UpdateLabel(0, bb_upper_buffer[0]);
   buffer_labels.UpdateLabel(1, bb_middle_buffer[0]);
   buffer_labels.UpdateLabel(2, bb_lower_buffer[0]);
   
   // Aggiungiamo anche il prezzo corrente
   double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   buffer_labels.UpdateLabel(3, current_price, "Price");
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
   // Segnale di acquisto: il prezzo attraversa la banda inferiore dal basso verso l'alto
   double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double prev_price = iClose(_Symbol, PERIOD_CURRENT, 1);
   
   return (prev_price < bb_lower_buffer[1] && current_price > bb_lower_buffer[0]);
}

//+------------------------------------------------------------------+
//| Verifica se c'è un segnale di vendita                            |
//+------------------------------------------------------------------+
bool IsSignalToSell()
{
   // Segnale di vendita: il prezzo attraversa la banda superiore dall'alto verso il basso
   double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double prev_price = iClose(_Symbol, PERIOD_CURRENT, 1);
   
   return (prev_price > bb_upper_buffer[1] && current_price < bb_upper_buffer[0]);
}

//+------------------------------------------------------------------+
//| Apre una posizione di acquisto                                   |
//+------------------------------------------------------------------+
void OpenBuyPosition()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double sl = ask - 100 * _Point;
   double tp = ask + 200 * _Point;
   
   if(trade.Buy(Lot_Size, _Symbol, ask, sl, tp, "OmniEA Lite DeepSeek - Buy"))
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
         "BB Lower Bounce"     // Commento
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
   
   if(trade.Sell(Lot_Size, _Symbol, bid, sl, tp, "OmniEA Lite DeepSeek - Sell"))
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
         "BB Upper Reversal"   // Commento
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
      report_generator.AddIndicatorValue("BB Upper", 0, bb_upper_buffer[0]);
      report_generator.AddIndicatorValue("BB Middle", 1, bb_middle_buffer[0]);
      report_generator.AddIndicatorValue("BB Lower", 2, bb_lower_buffer[0]);
      
      // Generazione del report
      string filename = "OmniEA_Lite_DeepSeek_" + TimeToString(current_time, TIME_DATE) + "_" + TimeToString(current_time, TIME_MINUTES) + ".html";
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
   report_generator.AddIndicatorValue("BB Upper", 0, bb_upper_buffer[0]);
   report_generator.AddIndicatorValue("BB Middle", 1, bb_middle_buffer[0]);
   report_generator.AddIndicatorValue("BB Lower", 2, bb_lower_buffer[0]);
   
   // Generazione dei report in diversi formati
   datetime current_time = TimeCurrent();
   string base_filename = "OmniEA_Lite_DeepSeek_Final_" + TimeToString(current_time, TIME_DATE);
   
   report_generator.GenerateCSVReport(base_filename + ".csv");
   report_generator.GenerateTXTReport(base_filename + ".txt");
   report_generator.GenerateHTMLReport(base_filename + ".html");
   
   Print("Report finali generati con successo");
}
