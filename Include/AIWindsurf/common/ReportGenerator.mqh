//+------------------------------------------------------------------+
//|                                          ReportGenerator.mqh |
//|        Sistema di generazione report per OmniEA              |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <Arrays\ArrayObj.mqh>
#include <Files\FileTxt.mqh>
#include <Files\FileCSV.mqh>
#include "Localization.mqh"

// Enumerazioni per il tipo di report
enum ENUM_REPORT_TYPE
{
   REPORT_DAILY,            // Report giornaliero
   REPORT_WEEKLY,           // Report settimanale
   REPORT_MONTHLY,          // Report mensile
   REPORT_CUSTOM            // Report personalizzato
};

// Enumerazioni per il formato di esportazione
enum ENUM_EXPORT_FORMAT
{
   EXPORT_HTML,             // Formato HTML
   EXPORT_CSV,              // Formato CSV
   EXPORT_JSON,             // Formato JSON
   EXPORT_TXT               // Formato testo semplice
};

// Struttura per i dati di trading
class TradeData : public CObject
{
public:
   datetime          openTime;          // Orario di apertura
   datetime          closeTime;         // Orario di chiusura
   string            symbol;            // Simbolo
   int               type;              // Tipo (0=buy, 1=sell)
   double            volume;            // Volume
   double            openPrice;         // Prezzo di apertura
   double            closePrice;        // Prezzo di chiusura
   double            sl;                // Stop Loss
   double            tp;                // Take Profit
   double            profit;            // Profitto
   double            swap;              // Swap
   double            commission;        // Commissione
   string            comment;           // Commento
   ulong             ticket;            // Ticket
   
   // Costruttore
   TradeData()
   {
      openTime = 0;
      closeTime = 0;
      symbol = "";
      type = 0;
      volume = 0.0;
      openPrice = 0.0;
      closePrice = 0.0;
      sl = 0.0;
      tp = 0.0;
      profit = 0.0;
      swap = 0.0;
      commission = 0.0;
      comment = "";
      ticket = 0;
   }
};

// Struttura per le statistiche di trading
struct TradeStats
{
   int               totalTrades;       // Numero totale di operazioni
   int               winTrades;         // Operazioni vincenti
   int               lossTrades;        // Operazioni perdenti
   double            grossProfit;       // Profitto lordo
   double            grossLoss;         // Perdita lorda
   double            netProfit;         // Profitto netto
   double            maxDrawdown;       // Drawdown massimo
   double            profitFactor;      // Fattore di profitto
   double            expectancy;        // Aspettativa
   double            avgWin;            // Media vincite
   double            avgLoss;           // Media perdite
   double            avgTrade;          // Media operazioni
   double            winRate;           // Percentuale di vincita
   
   // Costruttore
   TradeStats()
   {
      totalTrades = 0;
      winTrades = 0;
      lossTrades = 0;
      grossProfit = 0.0;
      grossLoss = 0.0;
      netProfit = 0.0;
      maxDrawdown = 0.0;
      profitFactor = 0.0;
      expectancy = 0.0;
      avgWin = 0.0;
      avgLoss = 0.0;
      avgTrade = 0.0;
      winRate = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Classe per la generazione di report di trading                    |
//+------------------------------------------------------------------+
class CReportGenerator
{
private:
   CArrayObj         m_trades;          // Array di operazioni
   TradeStats        m_stats;           // Statistiche di trading
   string            m_reportPath;      // Percorso dei report
   string            m_eaName;          // Nome dell'EA
   
   // Metodi privati
   void              CalculateStats();  // Calcola le statistiche
   string            GenerateHtmlReport(); // Genera report HTML
   string            GenerateCsvReport(); // Genera report CSV
   string            GenerateJsonReport(); // Genera report JSON
   string            GenerateTxtReport(); // Genera report TXT
   
public:
   // Costruttore
   CReportGenerator();
   
   // Distruttore
   ~CReportGenerator();
   
   // Inizializzazione
   bool              Initialize(string eaName);
   
   // Aggiunge un'operazione di trading
   void              AddTrade(const TradeData &trade);
   
   // Carica le operazioni dalla cronologia
   bool              LoadHistoryTrades(datetime startDate, datetime endDate);
   
   // Genera un report
   bool              GenerateReport(ENUM_REPORT_TYPE type, ENUM_EXPORT_FORMAT format);
   
   // Esporta il report in un file
   bool              ExportReport(string fileName, ENUM_EXPORT_FORMAT format);
   
   // Ottiene le statistiche di trading
   TradeStats        GetStats() const { return m_stats; }
};

//+------------------------------------------------------------------+
//| Costruttore                                                       |
//+------------------------------------------------------------------+
CReportGenerator::CReportGenerator()
{
   m_reportPath = "Reports";
   m_eaName = "OmniEA";
}

//+------------------------------------------------------------------+
//| Distruttore                                                       |
//+------------------------------------------------------------------+
CReportGenerator::~CReportGenerator()
{
   m_trades.Clear();
}

//+------------------------------------------------------------------+
//| Inizializzazione                                                  |
//+------------------------------------------------------------------+
bool CReportGenerator::Initialize(string eaName)
{
   m_eaName = eaName;
   
   // Crea la cartella dei report se non esiste
   string terminalPath = TerminalInfoString(TERMINAL_DATA_PATH);
   string reportPath = terminalPath + "\\MQL5\\Files\\" + m_reportPath;
   
   if(!FileIsExist(reportPath, FILE_COMMON))
   {
      FolderCreate(reportPath, FILE_COMMON);
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Aggiunge un'operazione di trading                                 |
//+------------------------------------------------------------------+
void CReportGenerator::AddTrade(const TradeData &trade)
{
   TradeData *newTrade = new TradeData();
   *newTrade = trade;
   m_trades.Add(newTrade);
}

//+------------------------------------------------------------------+
//| Carica le operazioni dalla cronologia                             |
//+------------------------------------------------------------------+
bool CReportGenerator::LoadHistoryTrades(datetime startDate, datetime endDate)
{
   // Pulisci l'array delle operazioni
   m_trades.Clear();
   
   // Seleziona la cronologia per il periodo specificato
   HistorySelect(startDate, endDate);
   
   // Ottieni il numero totale di operazioni nella cronologia
   int totalDeals = HistoryDealsTotal();
   
   // Elabora tutte le operazioni nella cronologia
   for(int i = 0; i < totalDeals; i++)
   {
      // Ottieni il ticket dell'operazione
      ulong dealTicket = HistoryDealGetTicket(i);
      if(dealTicket <= 0) continue;
      
      // Ottieni il ticket dell'ordine
      ulong orderTicket = HistoryDealGetInteger(dealTicket, DEAL_ORDER);
      
      // Ottieni il simbolo
      string dealSymbol = HistoryDealGetString(dealTicket, DEAL_SYMBOL);
      if(dealSymbol == "") continue;
      
      // Ottieni il tipo di operazione
      int dealType = (int)HistoryDealGetInteger(dealTicket, DEAL_TYPE);
      if(dealType != DEAL_TYPE_BUY && dealType != DEAL_TYPE_SELL) continue;
      
      // Converti il tipo in formato semplificato (0=buy, 1=sell)
      dealType = (dealType == DEAL_TYPE_BUY) ? 0 : 1;
      
      // Ottieni il volume
      double dealVolume = HistoryDealGetDouble(dealTicket, DEAL_VOLUME);
      
      // Ottieni il prezzo
      double dealPrice = HistoryDealGetDouble(dealTicket, DEAL_PRICE);
      
      // Ottieni il profitto
      double dealProfit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
      
      // Ottieni il commento
      string dealComment = HistoryDealGetString(dealTicket, DEAL_COMMENT);
      
      // Ottieni l'orario
      datetime dealTime = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);
      
      // Crea l'operazione
      TradeData *trade = new TradeData();
      trade.openTime = dealTime;
      trade.closeTime = dealTime;
      trade.symbol = dealSymbol;
      trade.type = dealType;
      trade.volume = dealVolume;
      trade.openPrice = dealPrice;
      trade.closePrice = dealPrice;
      trade.profit = dealProfit;
      trade.comment = dealComment;
      trade.ticket = dealTicket;
      
      m_trades.Add(trade);
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Calcola le statistiche                                            |
//+------------------------------------------------------------------+
void CReportGenerator::CalculateStats()
{
   // Resetta le statistiche
   m_stats = TradeStats();
   
   int total = m_trades.Total();
   if(total <= 0) return;
   
   // Calcola le statistiche di base
   m_stats.totalTrades = total;
   
   double equity = 0.0;
   double maxEquity = 0.0;
   double drawdown = 0.0;
   double maxDrawdown = 0.0;
   
   for(int i = 0; i < total; i++)
   {
      TradeData *trade = m_trades.At(i);
      if(trade == NULL) continue;
      
      // Aggiorna profitto/perdita
      if(trade.profit > 0)
      {
         m_stats.winTrades++;
         m_stats.grossProfit += trade.profit;
      }
      else if(trade.profit < 0)
      {
         m_stats.lossTrades++;
         m_stats.grossLoss += MathAbs(trade.profit);
      }
      
      // Aggiorna equity e drawdown
      equity += trade.profit;
      if(equity > maxEquity)
      {
         maxEquity = equity;
         drawdown = 0;
      }
      else
      {
         drawdown = maxEquity - equity;
         if(drawdown > maxDrawdown)
            maxDrawdown = drawdown;
      }
   }
   
   // Calcola le statistiche derivate
   m_stats.netProfit = m_stats.grossProfit - m_stats.grossLoss;
   m_stats.maxDrawdown = maxDrawdown;
   
   if(m_stats.grossLoss > 0)
      m_stats.profitFactor = m_stats.grossProfit / m_stats.grossLoss;
   
   if(m_stats.winTrades > 0)
      m_stats.avgWin = m_stats.grossProfit / m_stats.winTrades;
   
   if(m_stats.lossTrades > 0)
      m_stats.avgLoss = m_stats.grossLoss / m_stats.lossTrades;
   
   if(total > 0)
   {
      m_stats.avgTrade = m_stats.netProfit / total;
      m_stats.winRate = (double)m_stats.winTrades / total * 100.0;
   }
   
   // Calcola l'aspettativa
   m_stats.expectancy = (m_stats.avgWin * m_stats.winRate / 100.0) + 
                        (m_stats.avgLoss * (100.0 - m_stats.winRate) / 100.0);
}

//+------------------------------------------------------------------+
//| Genera report HTML                                                |
//+------------------------------------------------------------------+
string CReportGenerator::GenerateHtmlReport()
{
   string html = "<!DOCTYPE html>\n";
   html += "<html>\n<head>\n";
   html += "<title>OmniEA Trading Report</title>\n";
   html += "<style>\n";
   html += "body { font-family: Arial, sans-serif; margin: 20px; }\n";
   html += "h1, h2 { color: #336699; }\n";
   html += "table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }\n";
   html += "th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }\n";
   html += "th { background-color: #f2f2f2; }\n";
   html += "tr:nth-child(even) { background-color: #f9f9f9; }\n";
   html += ".profit { color: green; }\n";
   html += ".loss { color: red; }\n";
   html += ".summary { background-color: #eef6ff; padding: 15px; border-radius: 5px; }\n";
   html += "</style>\n";
   html += "</head>\n<body>\n";
   
   // Intestazione
   html += "<h1>OmniEA Trading Report</h1>\n";
   html += "<p>Generated on: " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "</p>\n";
   
   // Sommario statistiche
   html += "<div class='summary'>\n";
   html += "<h2>Trading Statistics</h2>\n";
   html += "<p>Total Trades: " + IntegerToString(m_stats.totalTrades) + "</p>\n";
   html += "<p>Win Rate: " + DoubleToString(m_stats.winRate, 2) + "%</p>\n";
   html += "<p>Net Profit: " + DoubleToString(m_stats.netProfit, 2) + "</p>\n";
   html += "<p>Profit Factor: " + DoubleToString(m_stats.profitFactor, 2) + "</p>\n";
   html += "<p>Max Drawdown: " + DoubleToString(m_stats.maxDrawdown, 2) + "</p>\n";
   html += "</div>\n";
   
   // Tabella delle operazioni
   html += "<h2>Trade History</h2>\n";
   html += "<table>\n";
   html += "<tr><th>Ticket</th><th>Open Time</th><th>Close Time</th><th>Symbol</th><th>Type</th><th>Volume</th><th>Open Price</th><th>Close Price</th><th>Profit</th></tr>\n";
   
   int total = m_trades.Total();
   for(int i = 0; i < total; i++)
   {
      TradeData *trade = m_trades.At(i);
      if(trade == NULL) continue;
      
      string tradeType = (trade.type == 0) ? "Buy" : "Sell";
      string profitClass = (trade.profit >= 0) ? "profit" : "loss";
      
      html += "<tr>";
      html += "<td>" + IntegerToString(trade.ticket) + "</td>";
      html += "<td>" + TimeToString(trade.openTime, TIME_DATE|TIME_MINUTES) + "</td>";
      html += "<td>" + TimeToString(trade.closeTime, TIME_DATE|TIME_MINUTES) + "</td>";
      html += "<td>" + trade.symbol + "</td>";
      html += "<td>" + tradeType + "</td>";
      html += "<td>" + DoubleToString(trade.volume, 2) + "</td>";
      html += "<td>" + DoubleToString(trade.openPrice, 5) + "</td>";
      html += "<td>" + DoubleToString(trade.closePrice, 5) + "</td>";
      html += "<td class='" + profitClass + "'>" + DoubleToString(trade.profit, 2) + "</td>";
      html += "</tr>\n";
   }
   
   html += "</table>\n";
   html += "<p>Report generated by " + m_eaName + " - BlueTrendTeam</p>\n";
   html += "</body>\n</html>";
   
   return html;
}

//+------------------------------------------------------------------+
//| Genera report CSV                                                |
//+------------------------------------------------------------------+
string CReportGenerator::GenerateCsvReport()
{
   string csv = "Ticket,Open Time,Close Time,Symbol,Type,Volume,Open Price,Close Price,Profit\n";
   
   int total = m_trades.Total();
   for(int i = 0; i < total; i++)
   {
      TradeData *trade = m_trades.At(i);
      if(trade == NULL) continue;
      
      string tradeType = (trade.type == 0) ? "Buy" : "Sell";
      
      csv += IntegerToString(trade.ticket) + ",";
      csv += TimeToString(trade.openTime, TIME_DATE|TIME_MINUTES) + ",";
      csv += TimeToString(trade.closeTime, TIME_DATE|TIME_MINUTES) + ",";
      csv += trade.symbol + ",";
      csv += tradeType + ",";
      csv += DoubleToString(trade.volume, 2) + ",";
      csv += DoubleToString(trade.openPrice, 5) + ",";
      csv += DoubleToString(trade.closePrice, 5) + ",";
      csv += DoubleToString(trade.profit, 2) + "\n";
   }
   
   return csv;
}

//+------------------------------------------------------------------+
//| Genera report JSON                                               |
//+------------------------------------------------------------------+
string CReportGenerator::GenerateJsonReport()
{
   string json = "{\n";
   json += "  \"report_date\": \"" + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\",\n";
   json += "  \"ea_name\": \"" + m_eaName + "\",\n";
   json += "  \"statistics\": {\n";
   json += "    \"total_trades\": " + IntegerToString(m_stats.totalTrades) + ",\n";
   json += "    \"win_trades\": " + IntegerToString(m_stats.winTrades) + ",\n";
   json += "    \"loss_trades\": " + IntegerToString(m_stats.lossTrades) + ",\n";
   json += "    \"win_rate\": " + DoubleToString(m_stats.winRate, 2) + ",\n";
   json += "    \"net_profit\": " + DoubleToString(m_stats.netProfit, 2) + ",\n";
   json += "    \"gross_profit\": " + DoubleToString(m_stats.grossProfit, 2) + ",\n";
   json += "    \"gross_loss\": " + DoubleToString(m_stats.grossLoss, 2) + ",\n";
   json += "    \"profit_factor\": " + DoubleToString(m_stats.profitFactor, 2) + ",\n";
   json += "    \"max_drawdown\": " + DoubleToString(m_stats.maxDrawdown, 2) + "\n";
   json += "  },\n";
   json += "  \"trades\": [\n";
   
   int total = m_trades.Total();
   for(int i = 0; i < total; i++)
   {
      TradeData *trade = m_trades.At(i);
      if(trade == NULL) continue;
      
      string tradeType = (trade.type == 0) ? "Buy" : "Sell";
      
      json += "    {\n";
      json += "      \"ticket\": " + IntegerToString(trade.ticket) + ",\n";
      json += "      \"open_time\": \"" + TimeToString(trade.openTime, TIME_DATE|TIME_MINUTES) + "\",\n";
      json += "      \"close_time\": \"" + TimeToString(trade.closeTime, TIME_DATE|TIME_MINUTES) + "\",\n";
      json += "      \"symbol\": \"" + trade.symbol + "\",\n";
      json += "      \"type\": \"" + tradeType + "\",\n";
      json += "      \"volume\": " + DoubleToString(trade.volume, 2) + ",\n";
      json += "      \"open_price\": " + DoubleToString(trade.openPrice, 5) + ",\n";
      json += "      \"close_price\": " + DoubleToString(trade.closePrice, 5) + ",\n";
      json += "      \"profit\": " + DoubleToString(trade.profit, 2) + "\n";
      json += "    }";
      
      if(i < total - 1) json += ",";
      json += "\n";
   }
   
   json += "  ]\n";
   json += "}";
   
   return json;
}

//+------------------------------------------------------------------+
//| Genera report TXT                                                |
//+------------------------------------------------------------------+
string CReportGenerator::GenerateTxtReport()
{
   string txt = "OmniEA Trading Report\n";
   txt += "Generated on: " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\n\n";
   
   txt += "Trading Statistics:\n";
   txt += "Total Trades: " + IntegerToString(m_stats.totalTrades) + "\n";
   txt += "Win Trades: " + IntegerToString(m_stats.winTrades) + "\n";
   txt += "Loss Trades: " + IntegerToString(m_stats.lossTrades) + "\n";
   txt += "Win Rate: " + DoubleToString(m_stats.winRate, 2) + "%\n";
   txt += "Net Profit: " + DoubleToString(m_stats.netProfit, 2) + "\n";
   txt += "Profit Factor: " + DoubleToString(m_stats.profitFactor, 2) + "\n";
   txt += "Max Drawdown: " + DoubleToString(m_stats.maxDrawdown, 2) + "\n\n";
   
   txt += "Trade History:\n";
   txt += "-----------------------------------------------------------------------------------------\n";
   txt += "Ticket | Open Time       | Close Time      | Symbol | Type | Volume | Open    | Close   | Profit\n";
   txt += "-----------------------------------------------------------------------------------------\n";
   
   int total = m_trades.Total();
   for(int i = 0; i < total; i++)
   {
      TradeData *trade = m_trades.At(i);
      if(trade == NULL) continue;
      
      string tradeType = (trade.type == 0) ? "Buy" : "Sell";
      
      txt += StringFormat("%6d | %s | %s | %s | %s | %.2f | %.5f | %.5f | %.2f\n",
                          trade.ticket,
                          TimeToString(trade.openTime, TIME_DATE|TIME_MINUTES),
                          TimeToString(trade.closeTime, TIME_DATE|TIME_MINUTES),
                          trade.symbol,
                          tradeType,
                          trade.volume,
                          trade.openPrice,
                          trade.closePrice,
                          trade.profit);
   }
   
   txt += "\nReport generato da " + m_eaName + " - BlueTrendTeam";
   
   return txt;
}

//+------------------------------------------------------------------+
//| Genera un report                                                  |
//+------------------------------------------------------------------+
bool CReportGenerator::GenerateReport(ENUM_REPORT_TYPE type, ENUM_EXPORT_FORMAT format)
{
   // Calcola le statistiche
   CalculateStats();
   
   // Genera il report nel formato richiesto
   string report = "";
   
   switch(format)
   {
      case EXPORT_HTML:
         report = GenerateHtmlReport();
         break;
         
      case EXPORT_CSV:
         report = GenerateCsvReport();
         break;
         
      case EXPORT_JSON:
         report = GenerateJsonReport();
         break;
         
      case EXPORT_TXT:
         report = GenerateTxtReport();
         break;
         
      default:
         return false;
   }
   
   // Esporta il report
   string fileName = m_eaName + "_Report_";
   
   switch(type)
   {
      case REPORT_DAILY:
         fileName += "Daily_" + TimeToString(TimeCurrent(), TIME_DATE);
         break;
         
      case REPORT_WEEKLY:
         fileName += "Weekly_" + TimeToString(TimeCurrent(), TIME_DATE);
         break;
         
      case REPORT_MONTHLY:
         fileName += "Monthly_" + TimeToString(TimeCurrent(), TIME_DATE);
         break;
         
      case REPORT_CUSTOM:
         fileName += "Custom_" + TimeToString(TimeCurrent(), TIME_DATE);
         break;
         
      default:
         return false;
   }
   
   return ExportReport(fileName, format);
}

//+------------------------------------------------------------------+
//| Esporta il report in un file                                      |
//+------------------------------------------------------------------+
bool CReportGenerator::ExportReport(string fileName, ENUM_EXPORT_FORMAT format)
{
   // Genera il report nel formato richiesto
   string report = "";
   string extension = "";
   
   switch(format)
   {
      case EXPORT_HTML:
         report = GenerateHtmlReport();
         extension = ".html";
         break;
         
      case EXPORT_CSV:
         report = GenerateCsvReport();
         extension = ".csv";
         break;
         
      case EXPORT_JSON:
         report = GenerateJsonReport();
         extension = ".json";
         break;
         
      case EXPORT_TXT:
         report = GenerateTxtReport();
         extension = ".txt";
         break;
         
      default:
         return false;
   }
   
   // Crea il percorso completo del file
   string terminalPath = TerminalInfoString(TERMINAL_DATA_PATH);
   string filePath = terminalPath + "\\MQL5\\Files\\" + m_reportPath + "\\" + fileName + extension;
   
   // Apri il file per la scrittura
   int fileHandle = FileOpen(filePath, FILE_WRITE|FILE_TXT);
   if(fileHandle == INVALID_HANDLE)
   {
      Print("Errore nell'apertura del file: ", GetLastError());
      return false;
   }
   
   // Scrivi il report nel file
   FileWriteString(fileHandle, report);
   
   // Chiudi il file
   FileClose(fileHandle);
   
   Print("Report esportato con successo in: ", filePath);
   return true;
}
