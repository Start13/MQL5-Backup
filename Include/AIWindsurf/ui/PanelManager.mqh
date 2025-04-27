//+------------------------------------------------------------------+
//|                                            PanelManager.mqh |
//|        Gestore principale del pannello per OmniEA            |
//|        AlgoWi Implementation                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

// Includi le definizioni degli eventi di chart
#include <ChartObjects\ChartObject.mqh>

// Definizione degli eventi di chart mancanti
#ifndef CHARTEVENT_DRAG_PROCESS
#define CHARTEVENT_DRAG_PROCESS 1024
#endif

#ifndef CHARTEVENT_OBJECT_DRAG_END
#define CHARTEVENT_OBJECT_DRAG_END 1025
#endif

#include "PanelEvents.mqh"
#include "..\omniea\SlotManager.mqh"
#include "..\omniea\PresetManager.mqh"
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
   void SetSlotManager(CSlotManager *slotMgr)
   {
      m_slotManager = slotMgr;
      CPanelEvents::SetSlotManager(slotMgr);
   }
   
   // Imposta il gestore dei preset
   void SetPresetManager(CPresetManager *presetMgr)
   {
      m_presetManager = presetMgr;
      CPanelEvents::SetPresetManager(presetMgr);
   }
   
   // Imposta il generatore di report
   void SetReportGenerator(CReportGenerator *reportGen)
   {
      m_reportGenerator = reportGen;
      CPanelEvents::SetReportGenerator(reportGen);
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
   
   // Elabora gli eventi del pannello e restituisce true se l'evento è stato gestito
   bool ProcessEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      if(!m_isInitialized) return false;
      
      // Gestione degli eventi di selezione indicatore
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         // Verifica se l'oggetto cliccato è un pulsante indicatore
         if(StringFind(sparam, "btn_indicator_") >= 0)
         {
            // Estrai l'indice dello slot e il tipo
            string parts[];
            StringSplit(sparam, '_', parts);
            if(ArraySize(parts) >= 3)
            {
               int slotIndex = (int)StringToInteger(parts[2]);
               ENUM_SLOT_TYPE slotType = SLOT_BUY;
               
               if(StringFind(sparam, "buy") >= 0)
                  slotType = SLOT_BUY;
               else if(StringFind(sparam, "sell") >= 0)
                  slotType = SLOT_SELL;
               else if(StringFind(sparam, "filter") >= 0)
                  slotType = SLOT_FILTER;
               
               // Ottieni il nome dell'indicatore selezionato
               string indicatorName = "";
               
               // Verifica quale indicatore è stato selezionato
               if(m_slotManager != NULL)
               {
                  if(slotType == SLOT_BUY && slotIndex < m_slotManager.GetMaxSlots(SLOT_BUY))
                  {
                     // Qui dovremmo ottenere il nome dell'indicatore dallo slot
                     // Per ora usiamo un evento generico
                     EventChartCustom(0, CHARTEVENT_CUSTOM + 1, slotIndex, 0, "Indicator_" + IntegerToString(slotIndex));
                     return true;
                  }
                  else if(slotType == SLOT_SELL && slotIndex < m_slotManager.GetMaxSlots(SLOT_SELL))
                  {
                     EventChartCustom(0, CHARTEVENT_CUSTOM + 1, slotIndex + 100, 0, "Indicator_" + IntegerToString(slotIndex));
                     return true;
                  }
                  else if(slotType == SLOT_FILTER && slotIndex < m_slotManager.GetMaxSlots(SLOT_FILTER))
                  {
                     EventChartCustom(0, CHARTEVENT_CUSTOM + 1, slotIndex + 200, 0, "Indicator_" + IntegerToString(slotIndex));
                     return true;
                  }
               }
            }
         }
      }
      
      // Gestione degli eventi di drag & drop
      if(id == CHARTEVENT_DRAG_PROCESS || id == CHARTEVENT_OBJECT_DRAG_END)
      {
         if(StringFind(sparam, "indicator_") >= 0)
         {
            // Qui gestiamo il drag & drop degli indicatori
            // Generiamo un evento personalizzato quando un indicatore viene trascinato
            EventChartCustom(0, CHARTEVENT_CUSTOM + 2, 0, 0, sparam);
            return true;
         }
      }
      
      return false;
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
