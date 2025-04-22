//+------------------------------------------------------------------+
//|                                            ReportGenerator.mqh |
//|                                       Copyright 2025, BlueTrendTeam |
//|                                       https://github.com/Start13/OmniEA-Lite-Gemini |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://github.com/Start13/OmniEA-Lite-Gemini"
#property version   "1.00"

#include <Arrays\ArrayObj.mqh>

//+------------------------------------------------------------------+
//| Struttura per memorizzare i dati di un trade                     |
//+------------------------------------------------------------------+
struct STrade
{
   datetime          open_time;          // Orario di apertura
   datetime          close_time;         // Orario di chiusura
   double            open_price;         // Prezzo di apertura
   double            close_price;        // Prezzo di chiusura
   double            profit;             // Profitto
   double            volume;             // Volume
   int               type;               // Tipo (0 = buy, 1 = sell)
   string            symbol;             // Simbolo
   string            comment;            // Commento
};

//+------------------------------------------------------------------+
//| Struttura per memorizzare i dati degli indicatori                |
//+------------------------------------------------------------------+
struct SIndicatorValue
{
   string            name;               // Nome dell'indicatore
   int               buffer_index;       // Indice del buffer
   double            value;              // Valore del buffer
};

//+------------------------------------------------------------------+
//| Classe per la generazione di report                              |
//+------------------------------------------------------------------+
class CReportGenerator
{
private:
   string            m_report_folder;    // Cartella per i report
   string            m_report_prefix;    // Prefisso per i nomi dei file di report
   string            m_csv_separator;    // Separatore per i file CSV
   
   // Array di trade
   CArrayObj         m_trades;
   
   // Array di valori degli indicatori
   CArrayObj         m_indicator_values;
   
   // Statistiche di trading
   double            m_total_profit;     // Profitto totale
   int               m_total_trades;     // Numero totale di trade
   int               m_winning_trades;   // Numero di trade vincenti
   int               m_losing_trades;    // Numero di trade perdenti
   double            m_max_drawdown;     // Drawdown massimo
   double            m_win_rate;         // Percentuale di vincita
   double            m_profit_factor;    // Fattore di profitto
   
   // Funzioni interne
   void              CalculateStatistics();
   bool              CreateReportFolder();
   
public:
                     CReportGenerator();
                    ~CReportGenerator();
   
   // Inizializzazione
   void              Init(string report_folder="Reports", string report_prefix="OmniEA_Report_", string csv_separator=",");
   
   // Aggiunta di dati
   void              AddTrade(datetime open_time, datetime close_time, double open_price, double close_price, 
                            double profit, double volume, int type, string symbol, string comment="");
   void              AddIndicatorValue(string name, int buffer_index, double value);
   
   // Generazione di report
   bool              GenerateCSVReport(string filename="");
   bool              GenerateTXTReport(string filename="");
   bool              GenerateHTMLReport(string filename="");
   
   // Accesso alle statistiche
   double            GetTotalProfit() const { return m_total_profit; }
   int               GetTotalTrades() const { return m_total_trades; }
   int               GetWinningTrades() const { return m_winning_trades; }
   int               GetLosingTrades() const { return m_losing_trades; }
   double            GetMaxDrawdown() const { return m_max_drawdown; }
   double            GetWinRate() const { return m_win_rate; }
   double            GetProfitFactor() const { return m_profit_factor; }
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CReportGenerator::CReportGenerator()
{
   m_total_profit = 0.0;
   m_total_trades = 0;
   m_winning_trades = 0;
   m_losing_trades = 0;
   m_max_drawdown = 0.0;
   m_win_rate = 0.0;
   m_profit_factor = 0.0;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CReportGenerator::~CReportGenerator()
{
   m_trades.Clear();
   m_indicator_values.Clear();
}

//+------------------------------------------------------------------+
//| Inizializzazione della classe                                    |
//+------------------------------------------------------------------+
void CReportGenerator::Init(string report_folder="Reports", string report_prefix="OmniEA_Report_", string csv_separator=",")
{
   m_report_folder = report_folder;
   m_report_prefix = report_prefix;
   m_csv_separator = csv_separator;
   
   CreateReportFolder();
}

//+------------------------------------------------------------------+
//| Crea la cartella per i report se non esiste                      |
//+------------------------------------------------------------------+
bool CReportGenerator::CreateReportFolder()
{
   string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
   string folder_path = terminal_data_path + "\\MQL5\\Files\\" + m_report_folder;
   
   if(!FileIsExist(folder_path, FILE_COMMON))
   {
      return FolderCreate(folder_path, FILE_COMMON);
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Aggiunge un trade al report                                      |
//+------------------------------------------------------------------+
void CReportGenerator::AddTrade(datetime open_time, datetime close_time, double open_price, double close_price, 
                              double profit, double volume, int type, string symbol, string comment="")
{
   STrade* trade = new STrade;
   if(trade != NULL)
   {
      trade.open_time = open_time;
      trade.close_time = close_time;
      trade.open_price = open_price;
      trade.close_price = close_price;
      trade.profit = profit;
      trade.volume = volume;
      trade.type = type;
      trade.symbol = symbol;
      trade.comment = comment;
      
      m_trades.Add(trade);
   }
}

//+------------------------------------------------------------------+
//| Aggiunge un valore di indicatore al report                       |
//+------------------------------------------------------------------+
void CReportGenerator::AddIndicatorValue(string name, int buffer_index, double value)
{
   SIndicatorValue* ind_value = new SIndicatorValue;
   if(ind_value != NULL)
   {
      ind_value.name = name;
      ind_value.buffer_index = buffer_index;
      ind_value.value = value;
      
      m_indicator_values.Add(ind_value);
   }
}

//+------------------------------------------------------------------+
//| Calcola le statistiche di trading                                |
//+------------------------------------------------------------------+
void CReportGenerator::CalculateStatistics()
{
   m_total_profit = 0.0;
   m_total_trades = m_trades.Total();
   m_winning_trades = 0;
   m_losing_trades = 0;
   
   double winning_sum = 0.0;
   double losing_sum = 0.0;
   double balance = 0.0;
   double max_balance = 0.0;
   
   for(int i=0; i<m_total_trades; i++)
   {
      STrade* trade = m_trades.At(i);
      if(trade != NULL)
      {
         m_total_profit += trade.profit;
         balance += trade.profit;
         
         if(balance > max_balance)
            max_balance = balance;
            
         if(trade.profit > 0)
         {
            m_winning_trades++;
            winning_sum += trade.profit;
         }
         else if(trade.profit < 0)
         {
            m_losing_trades++;
            losing_sum += MathAbs(trade.profit);
         }
         
         double drawdown = max_balance - balance;
         if(drawdown > m_max_drawdown)
            m_max_drawdown = drawdown;
      }
   }
   
   if(m_total_trades > 0)
      m_win_rate = (double)m_winning_trades / m_total_trades * 100.0;
      
   if(losing_sum > 0)
      m_profit_factor = winning_sum / losing_sum;
}

//+------------------------------------------------------------------+
//| Genera un report in formato CSV                                  |
//+------------------------------------------------------------------+
bool CReportGenerator::GenerateCSVReport(string filename="")
{
   CalculateStatistics();
   
   if(filename == "")
      filename = m_report_prefix + TimeToString(TimeCurrent(), TIME_DATE) + ".csv";
      
   string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
   string file_path = terminal_data_path + "\\MQL5\\Files\\" + m_report_folder + "\\" + filename;
   
   int file_handle = FileOpen(file_path, FILE_WRITE|FILE_CSV|FILE_ANSI, m_csv_separator);
   if(file_handle == INVALID_HANDLE)
   {
      Print("Errore nell'apertura del file: ", GetLastError());
      return false;
   }
   
   // Intestazione delle statistiche
   FileWrite(file_handle, "Statistiche di Trading");
   FileWrite(file_handle, "Data", "Valore");
   FileWrite(file_handle, "Data Report", TimeToString(TimeCurrent()));
   FileWrite(file_handle, "Profitto Totale", DoubleToString(m_total_profit, 2));
   FileWrite(file_handle, "Numero Trade", IntegerToString(m_total_trades));
   FileWrite(file_handle, "Trade Vincenti", IntegerToString(m_winning_trades));
   FileWrite(file_handle, "Trade Perdenti", IntegerToString(m_losing_trades));
   FileWrite(file_handle, "Percentuale Vincita", DoubleToString(m_win_rate, 2) + "%");
   FileWrite(file_handle, "Fattore di Profitto", DoubleToString(m_profit_factor, 2));
   FileWrite(file_handle, "Drawdown Massimo", DoubleToString(m_max_drawdown, 2));
   FileWrite(file_handle, "");
   
   // Intestazione dei trade
   FileWrite(file_handle, "Elenco Trade");
   FileWrite(file_handle, "N.", "Apertura", "Chiusura", "Simbolo", "Tipo", "Volume", "Prezzo Apertura", "Prezzo Chiusura", "Profitto", "Commento");
   
   // Dati dei trade
   for(int i=0; i<m_total_trades; i++)
   {
      STrade* trade = m_trades.At(i);
      if(trade != NULL)
      {
         string type_str = (trade.type == 0) ? "Buy" : "Sell";
         FileWrite(file_handle, 
            IntegerToString(i+1),
            TimeToString(trade.open_time),
            TimeToString(trade.close_time),
            trade.symbol,
            type_str,
            DoubleToString(trade.volume, 2),
            DoubleToString(trade.open_price, 5),
            DoubleToString(trade.close_price, 5),
            DoubleToString(trade.profit, 2),
            trade.comment
         );
      }
   }
   
   FileWrite(file_handle, "");
   
   // Intestazione dei valori degli indicatori
   FileWrite(file_handle, "Valori degli Indicatori");
   FileWrite(file_handle, "Nome", "Buffer", "Valore");
   
   // Dati degli indicatori
   int ind_total = m_indicator_values.Total();
   for(int i=0; i<ind_total; i++)
   {
      SIndicatorValue* ind_value = m_indicator_values.At(i);
      if(ind_value != NULL)
      {
         FileWrite(file_handle, 
            ind_value.name,
            IntegerToString(ind_value.buffer_index),
            DoubleToString(ind_value.value, 5)
         );
      }
   }
   
   FileClose(file_handle);
   
   Print("Report CSV generato: ", file_path);
   return true;
}

//+------------------------------------------------------------------+
//| Genera un report in formato TXT                                  |
//+------------------------------------------------------------------+
bool CReportGenerator::GenerateTXTReport(string filename="")
{
   CalculateStatistics();
   
   if(filename == "")
      filename = m_report_prefix + TimeToString(TimeCurrent(), TIME_DATE) + ".txt";
      
   string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
   string file_path = terminal_data_path + "\\MQL5\\Files\\" + m_report_folder + "\\" + filename;
   
   int file_handle = FileOpen(file_path, FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(file_handle == INVALID_HANDLE)
   {
      Print("Errore nell'apertura del file: ", GetLastError());
      return false;
   }
   
   // Intestazione
   FileWrite(file_handle, "=== OmniEA - Report di Trading ===");
   FileWrite(file_handle, "Data: " + TimeToString(TimeCurrent()));
   FileWrite(file_handle, "");
   
   // Statistiche
   FileWrite(file_handle, "--- Statistiche di Trading ---");
   FileWrite(file_handle, "Profitto Totale: " + DoubleToString(m_total_profit, 2));
   FileWrite(file_handle, "Numero Trade: " + IntegerToString(m_total_trades));
   FileWrite(file_handle, "Trade Vincenti: " + IntegerToString(m_winning_trades));
   FileWrite(file_handle, "Trade Perdenti: " + IntegerToString(m_losing_trades));
   FileWrite(file_handle, "Percentuale Vincita: " + DoubleToString(m_win_rate, 2) + "%");
   FileWrite(file_handle, "Fattore di Profitto: " + DoubleToString(m_profit_factor, 2));
   FileWrite(file_handle, "Drawdown Massimo: " + DoubleToString(m_max_drawdown, 2));
   FileWrite(file_handle, "");
   
   // Trade
   FileWrite(file_handle, "--- Elenco Trade ---");
   for(int i=0; i<m_total_trades; i++)
   {
      STrade* trade = m_trades.At(i);
      if(trade != NULL)
      {
         string type_str = (trade.type == 0) ? "Buy" : "Sell";
         FileWrite(file_handle, 
            "Trade #" + IntegerToString(i+1) + ": " +
            type_str + " " + trade.symbol + " " +
            "Volume: " + DoubleToString(trade.volume, 2) + " " +
            "Apertura: " + TimeToString(trade.open_time) + " @ " + DoubleToString(trade.open_price, 5) + " " +
            "Chiusura: " + TimeToString(trade.close_time) + " @ " + DoubleToString(trade.close_price, 5) + " " +
            "Profitto: " + DoubleToString(trade.profit, 2) +
            (trade.comment != "" ? " Commento: " + trade.comment : "")
         );
      }
   }
   FileWrite(file_handle, "");
   
   // Indicatori
   FileWrite(file_handle, "--- Valori degli Indicatori ---");
   int ind_total = m_indicator_values.Total();
   for(int i=0; i<ind_total; i++)
   {
      SIndicatorValue* ind_value = m_indicator_values.At(i);
      if(ind_value != NULL)
      {
         FileWrite(file_handle, 
            ind_value.name + " [Buffer " + IntegerToString(ind_value.buffer_index) + "]: " +
            DoubleToString(ind_value.value, 5)
         );
      }
   }
   
   FileClose(file_handle);
   
   Print("Report TXT generato: ", file_path);
   return true;
}

//+------------------------------------------------------------------+
//| Genera un report in formato HTML                                 |
//+------------------------------------------------------------------+
bool CReportGenerator::GenerateHTMLReport(string filename="")
{
   CalculateStatistics();
   
   if(filename == "")
      filename = m_report_prefix + TimeToString(TimeCurrent(), TIME_DATE) + ".html";
      
   string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
   string file_path = terminal_data_path + "\\MQL5\\Files\\" + m_report_folder + "\\" + filename;
   
   int file_handle = FileOpen(file_path, FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(file_handle == INVALID_HANDLE)
   {
      Print("Errore nell'apertura del file: ", GetLastError());
      return false;
   }
   
   // Intestazione HTML
   FileWrite(file_handle, "<!DOCTYPE html>");
   FileWrite(file_handle, "<html>");
   FileWrite(file_handle, "<head>");
   FileWrite(file_handle, "  <title>OmniEA - Report di Trading</title>");
   FileWrite(file_handle, "  <style>");
   FileWrite(file_handle, "    body { font-family: Arial, sans-serif; margin: 20px; }");
   FileWrite(file_handle, "    h1, h2 { color: #0066cc; }");
   FileWrite(file_handle, "    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }");
   FileWrite(file_handle, "    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
   FileWrite(file_handle, "    th { background-color: #f2f2f2; }");
   FileWrite(file_handle, "    tr:nth-child(even) { background-color: #f9f9f9; }");
   FileWrite(file_handle, "    .positive { color: green; }");
   FileWrite(file_handle, "    .negative { color: red; }");
   FileWrite(file_handle, "  </style>");
   FileWrite(file_handle, "</head>");
   FileWrite(file_handle, "<body>");
   
   // Titolo
   FileWrite(file_handle, "  <h1>OmniEA - Report di Trading</h1>");
   FileWrite(file_handle, "  <p>Data: " + TimeToString(TimeCurrent()) + "</p>");
   
   // Statistiche
   FileWrite(file_handle, "  <h2>Statistiche di Trading</h2>");
   FileWrite(file_handle, "  <table>");
   FileWrite(file_handle, "    <tr><th>Metrica</th><th>Valore</th></tr>");
   FileWrite(file_handle, "    <tr><td>Profitto Totale</td><td class='" + (m_total_profit >= 0 ? "positive" : "negative") + "'>" + DoubleToString(m_total_profit, 2) + "</td></tr>");
   FileWrite(file_handle, "    <tr><td>Numero Trade</td><td>" + IntegerToString(m_total_trades) + "</td></tr>");
   FileWrite(file_handle, "    <tr><td>Trade Vincenti</td><td>" + IntegerToString(m_winning_trades) + "</td></tr>");
   FileWrite(file_handle, "    <tr><td>Trade Perdenti</td><td>" + IntegerToString(m_losing_trades) + "</td></tr>");
   FileWrite(file_handle, "    <tr><td>Percentuale Vincita</td><td>" + DoubleToString(m_win_rate, 2) + "%</td></tr>");
   FileWrite(file_handle, "    <tr><td>Fattore di Profitto</td><td>" + DoubleToString(m_profit_factor, 2) + "</td></tr>");
   FileWrite(file_handle, "    <tr><td>Drawdown Massimo</td><td>" + DoubleToString(m_max_drawdown, 2) + "</td></tr>");
   FileWrite(file_handle, "  </table>");
   
   // Trade
   FileWrite(file_handle, "  <h2>Elenco Trade</h2>");
   FileWrite(file_handle, "  <table>");
   FileWrite(file_handle, "    <tr><th>N.</th><th>Apertura</th><th>Chiusura</th><th>Simbolo</th><th>Tipo</th><th>Volume</th><th>Prezzo Apertura</th><th>Prezzo Chiusura</th><th>Profitto</th><th>Commento</th></tr>");
   
   for(int i=0; i<m_total_trades; i++)
   {
      STrade* trade = m_trades.At(i);
      if(trade != NULL)
      {
         string type_str = (trade.type == 0) ? "Buy" : "Sell";
         string profit_class = (trade.profit >= 0) ? "positive" : "negative";
         
         FileWrite(file_handle, "    <tr>");
         FileWrite(file_handle, "      <td>" + IntegerToString(i+1) + "</td>");
         FileWrite(file_handle, "      <td>" + TimeToString(trade.open_time) + "</td>");
         FileWrite(file_handle, "      <td>" + TimeToString(trade.close_time) + "</td>");
         FileWrite(file_handle, "      <td>" + trade.symbol + "</td>");
         FileWrite(file_handle, "      <td>" + type_str + "</td>");
         FileWrite(file_handle, "      <td>" + DoubleToString(trade.volume, 2) + "</td>");
         FileWrite(file_handle, "      <td>" + DoubleToString(trade.open_price, 5) + "</td>");
         FileWrite(file_handle, "      <td>" + DoubleToString(trade.close_price, 5) + "</td>");
         FileWrite(file_handle, "      <td class='" + profit_class + "'>" + DoubleToString(trade.profit, 2) + "</td>");
         FileWrite(file_handle, "      <td>" + trade.comment + "</td>");
         FileWrite(file_handle, "    </tr>");
      }
   }
   
   FileWrite(file_handle, "  </table>");
   
   // Indicatori
   FileWrite(file_handle, "  <h2>Valori degli Indicatori</h2>");
   FileWrite(file_handle, "  <table>");
   FileWrite(file_handle, "    <tr><th>Nome</th><th>Buffer</th><th>Valore</th></tr>");
   
   int ind_total = m_indicator_values.Total();
   for(int i=0; i<ind_total; i++)
   {
      SIndicatorValue* ind_value = m_indicator_values.At(i);
      if(ind_value != NULL)
      {
         FileWrite(file_handle, "    <tr>");
         FileWrite(file_handle, "      <td>" + ind_value.name + "</td>");
         FileWrite(file_handle, "      <td>" + IntegerToString(ind_value.buffer_index) + "</td>");
         FileWrite(file_handle, "      <td>" + DoubleToString(ind_value.value, 5) + "</td>");
         FileWrite(file_handle, "    </tr>");
      }
   }
   
   FileWrite(file_handle, "  </table>");
   
   // Footer
   FileWrite(file_handle, "  <p><em>Report generato da OmniEA - Copyright 2025, BlueTrendTeam</em></p>");
   FileWrite(file_handle, "</body>");
   FileWrite(file_handle, "</html>");
   
   FileClose(file_handle);
   
   Print("Report HTML generato: ", file_path);
   return true;
}
