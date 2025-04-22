//+------------------------------------------------------------------+
//|                                            PanelManager.mqh |
//|        Gestore principale del pannello per OmniEA            |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include "PanelEvents.mqh"
#include "..\omniea\SlotManager.mqh"
#include "..\common\PresetManager.mqh"
#include "..\common\ReportGenerator.mqh"

//+------------------------------------------------------------------+
//| Classe principale per la gestione del pannello di OmniEA          |
//+------------------------------------------------------------------+
class CPanelManager : public CPanelEvents
{
private:
   CSlotManager     *m_slotManager;     // Gestore degli slot
   CPresetManager   *m_presetManager;   // Gestore dei preset
   CReportGenerator *m_reportGenerator; // Generatore di report
   
   // Stato del pannello
   bool              m_isInitialized;   // Flag di inizializzazione
   
public:
   // Costruttore
   CPanelManager() : CPanelEvents()
   {
      m_slotManager = NULL;
      m_presetManager = NULL;
      m_reportGenerator = NULL;
      m_isInitialized = false;
   }
   
   // Distruttore
   ~CPanelManager()
   {
      Cleanup();
   }
   
   // Inizializzazione del pannello
   bool Initialize(string name = "OmniEA", int version = 0)
   {
      if(m_isInitialized) return true;
      
      // Inizializza il pannello base
      if(!CPanelEvents::Initialize(name, version))
      {
         Print("❌ Errore inizializzazione pannello base");
         return false;
      }
      
      m_isInitialized = true;
      return true;
   }
   
   // Imposta il gestore degli slot
   void SetSlotManager(CSlotManager *slotManager)
   {
      m_slotManager = slotManager;
      CPanelEvents::SetSlotManager(slotManager);
   }
   
   // Imposta il gestore dei preset
   void SetPresetManager(CPresetManager *presetManager)
   {
      m_presetManager = presetManager;
      CPanelEvents::SetPresetManager(presetManager);
   }
   
   // Imposta il generatore di report
   void SetReportGenerator(CReportGenerator *reportGenerator)
   {
      m_reportGenerator = reportGenerator;
      CPanelEvents::SetReportGenerator(reportGenerator);
   }
   
   // Aggiornamento del pannello
   void Update()
   {
      if(!m_isInitialized) return;
      
      // Aggiorna i dati di mercato
      UpdateMarketData();
      
      // Aggiorna il pannello base
      CPanelEvents::Update();
   }
   
   // Pulizia del pannello
   void Cleanup()
   {
      if(!m_isInitialized) return;
      
      CPanelEvents::Cleanup();
      m_isInitialized = false;
   }
   
   // Gestione degli eventi del grafico
   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      if(!m_isInitialized) return;
      
      CPanelEvents::OnChartEvent(id, lparam, dparam, sparam);
   }
   
private:
   // Aggiorna i dati di mercato
   void UpdateMarketData()
   {
      string symbol = _Symbol;
      string broker = AccountInfoString(ACCOUNT_COMPANY);
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double equity = AccountInfoDouble(ACCOUNT_EQUITY);
      double spread = SymbolInfoInteger(symbol, SYMBOL_SPREAD) * SymbolInfoDouble(symbol, SYMBOL_POINT);
      
      // Determina lo stato del mercato
      string marketStatus = "Aperto";
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
      {
         marketStatus = "Chiuso";
      }
      else if(SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED)
      {
         marketStatus = "Disabilitato";
      }
      else if(SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_CLOSEONLY)
      {
         marketStatus = "Solo chiusura";
      }
      
      CPanelUI::UpdateMarketData(symbol, broker, balance, equity, spread, marketStatus);
   }
};
