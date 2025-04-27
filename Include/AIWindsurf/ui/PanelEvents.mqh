//+------------------------------------------------------------------+
//|                                             PanelEvents.mqh |
//|        Gestione degli eventi per il pannello di OmniEA        |
//|        AlgoWi Implementation                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <AIWindsurf\ui\PanelUI.mqh>
#include <AIWindsurf\omniea\PresetManager.mqh>
#include <AIWindsurf\common\ReportGenerator.mqh>
#include <AIWindsurf\ui\DragDropManager.mqh>

// Dichiarazione anticipata
class CSlotManager;
class CReportGenerator;

//+------------------------------------------------------------------+
//| Classe per la gestione degli eventi del pannello di OmniEA        |
//+------------------------------------------------------------------+
class CPanelEvents : public CPanelUI
{
private:
   CSlotManager     *m_slotManager;     // Puntatore al gestore degli slot
   CPresetManager   *m_presetManager;   // Puntatore al gestore dei preset
   CReportGenerator *m_reportGenerator; // Puntatore al generatore di report
   CDragDropManager  m_dragDropManager; // Gestore del drag & drop
   
   // Stato del drag & drop
   bool              m_isDragging;      // Flag di trascinamento in corso
   string            m_draggedObject;   // Nome dell'oggetto trascinato
   int               m_dragStartX;      // Posizione X di inizio trascinamento
   int               m_dragStartY;      // Posizione Y di inizio trascinamento
   
   // Stato dei pulsanti
   bool              m_configOpen;      // Flag di apertura configurazione
   
public:
   // Costruttore
   CPanelEvents() : CPanelUI()
   {
      m_slotManager = NULL;
      m_presetManager = NULL;
      m_reportGenerator = NULL;
      
      m_dragDropManager = CDragDropManager(m_prefix);
      
      m_isDragging = false;
      m_draggedObject = "";
      m_dragStartX = 0;
      m_dragStartY = 0;
      
      m_configOpen = false;
   }
   
   // Imposta il gestore degli slot
   void SetSlotManager(CSlotManager *slotMgr)
   {
      m_slotManager = slotMgr;
      m_dragDropManager.SetSlotManager(slotMgr);
   }
   
   // Imposta il gestore dei preset
   void SetPresetManager(CPresetManager *presetMgr)
   {
      m_presetManager = presetMgr;
   }
   
   // Imposta il generatore di report
   void SetReportGenerator(CReportGenerator *reportGen)
   {
      m_reportGenerator = reportGen;
   }
   
   // Gestione degli eventi del grafico
   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      if(!m_isVisible) return;
      
      // Gestione dei clic sui pulsanti
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         if(StringSubstr(sparam, 0, StringLen(m_prefix)) == m_prefix)
         {
            HandleButtonClick(sparam);
         }
      }
      
      // Gestione del drag & drop tramite il gestore dedicato
      m_dragDropManager.OnChartEvent(id, lparam, dparam, sparam);
      
      // Gestione dei clic sugli slot
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         if(StringFind(sparam, "Slot") >= 0 && StringSubstr(sparam, 0, StringLen(m_prefix)) == m_prefix)
         {
            HandleSlotClick(sparam);
         }
      }
      
      // Gestione dei cambiamenti nei campi di testo
      if(id == CHARTEVENT_OBJECT_ENDEDIT)
      {
         if(StringFind(sparam, "RiskValue") >= 0 && StringSubstr(sparam, 0, StringLen(m_prefix)) == m_prefix)
         {
            HandleRiskValueChange(sparam);
         }
      }
   }
   
private:
   // Gestisce i clic sui pulsanti
   void HandleButtonClick(string buttonName)
   {
      // Pulsante Avvia/Arresta
      if(buttonName == m_prefix + "StartStopButton")
      {
         bool newState = !m_isTradingEnabled;
         SetTradingEnabled(newState);
         
         if(m_slotManager != NULL)
         {
            m_slotManager.EnableTrading(newState);
         }
         
         string message = newState ? "Trading avviato" : "Trading arrestato";
         ShowNotification(message, newState ? clrLime : clrOrange);
      }
      
      // Pulsante Reset
      else if(buttonName == m_prefix + "ResetButton")
      {
         // Resetta tutti gli slot
         if(m_slotManager != NULL)
         {
            // Implementazione del reset degli slot
            // ...
         }
         
         ShowNotification("Configurazione resettata", clrYellow);
      }
      
      // Pulsante Configurazione
      else if(buttonName == m_prefix + "ConfigButton")
      {
         m_configOpen = !m_configOpen;
         
         if(m_configOpen)
         {
            // Mostra gli indicatori disponibili
            m_dragDropManager.CreateIndicatorObjects(m_x + m_width + 10, m_y, 200, 200);
         }
         else
         {
            // Nascondi gli indicatori disponibili
            m_dragDropManager.DeleteIndicatorObjects();
         }
         
         string message = m_configOpen ? "Configurazione aperta" : "Configurazione chiusa";
         ShowNotification(message, clrSkyBlue);
      }
      
      // Pulsante Salva
      else if(buttonName == m_prefix + "SaveButton")
      {
         if(m_presetManager != NULL)
         {
            // Salva il preset corrente
            string presetName = "Preset_" + TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES);
            bool result = m_presetManager.SavePreset(presetName);
            
            string message = result ? "Preset salvato: " + presetName : "Errore nel salvataggio del preset";
            ShowNotification(message, result ? clrLime : clrRed);
         }
      }
      
      // Pulsante Carica
      else if(buttonName == m_prefix + "LoadButton")
      {
         if(m_presetManager != NULL)
         {
            // Mostra la finestra di selezione preset
            // ...
            
            ShowNotification("Seleziona un preset da caricare", clrSkyBlue);
         }
      }
      
      // Pulsante Ottimizza
      else if(buttonName == m_prefix + "OptimizeButton")
      {
         // Avvia il processo di ottimizzazione
         // ...
         
         ShowNotification("Ottimizzazione avviata", clrMagenta);
      }
      
      // Pulsante Report
      else if(buttonName == m_prefix + "ReportButton")
      {
         // Genera un report
         if(m_reportGenerator != NULL)
         {
            // Imposta il periodo di tempo per il report (ultimi 30 giorni)
            datetime endDate = TimeCurrent();
            datetime startDate = endDate - 30 * 24 * 60 * 60; // 30 giorni fa
            
            // Carica le operazioni dalla cronologia
            if(m_reportGenerator.LoadHistoryTrades(startDate, endDate))
            {
               // Versione Lite: genera solo report HTML e TXT
               if(m_reportGenerator.GenerateReport(REPORT_MONTHLY, EXPORT_HTML))
               {
                  ShowNotification("Report HTML generato con successo", clrLime);
                  
                  // Genera anche un report in formato testo per la versione Lite
                  if(m_reportGenerator.GenerateReport(REPORT_MONTHLY, EXPORT_TXT))
                  {
                     ShowNotification("Report TXT generato con successo", clrLime);
                  }
                  
                  // Mostra il percorso dove sono stati salvati i report
                  string terminalPath = TerminalInfoString(TERMINAL_DATA_PATH);
                  string reportPath = terminalPath + "\\MQL5\\Files\\Reports\\";
                  
                  Print("I report sono stati salvati in: ", reportPath);
                  MessageBox("I report sono stati generati con successo.\nPercorso: " + reportPath, "OmniEA Lite - Report", MB_OK|MB_ICONINFORMATION);
               }
               else
               {
                  ShowNotification("Errore nella generazione del report", clrRed);
               }
            }
            else
            {
               ShowNotification("Nessuna operazione trovata nel periodo selezionato", clrOrange);
            }
         }
         else
         {
            ShowNotification("Generatore di report non inizializzato", clrRed);
         }
      }
      
      // Pulsanti di rimozione slot
      else if(StringFind(buttonName, "SlotRemove") >= 0)
      {
         HandleSlotRemove(buttonName);
      }
   }
   
   // Gestisce la rimozione di uno slot
   void HandleSlotRemove(string buttonName)
   {
      if(m_slotManager == NULL) return;
      
      // Estrai il tipo di slot e l'indice
      ENUM_SLOT_TYPE slotType = SLOT_BUY; // Valore predefinito
      int slotIndex = -1;
      
      if(StringFind(buttonName, "BuySlotRemove") >= 0)
      {
         slotType = SLOT_BUY;
         slotIndex = (int)StringToInteger(StringSubstr(buttonName, StringLen(m_prefix + "BuySlotRemove")));
      }
      else if(StringFind(buttonName, "SellSlotRemove") >= 0)
      {
         slotType = SLOT_SELL;
         slotIndex = (int)StringToInteger(StringSubstr(buttonName, StringLen(m_prefix + "SellSlotRemove")));
      }
      else if(StringFind(buttonName, "FilterSlotRemove") >= 0)
      {
         slotType = SLOT_FILTER;
         slotIndex = (int)StringToInteger(StringSubstr(buttonName, StringLen(m_prefix + "FilterSlotRemove")));
      }
      
      if(slotIndex >= 0)
      {
         // Disattiva lo slot
         bool result = m_slotManager.DeactivateSlot(slotType, slotIndex);
         
         if(result)
         {
            // Aggiorna la visualizzazione dello slot
            string slotPrefix;
            switch(slotType)
            {
               case SLOT_BUY:    slotPrefix = "BuySlot"; break;
               case SLOT_SELL:   slotPrefix = "SellSlot"; break;
               case SLOT_FILTER: slotPrefix = "FilterSlot"; break;
            }
            
            string slotName = m_prefix + slotPrefix + IntegerToString(slotIndex);
            string slotTextName = m_prefix + slotPrefix + "Text" + IntegerToString(slotIndex);
            
            // Reimposta lo slot allo stato iniziale
            ObjectSetInteger(0, slotName, OBJPROP_BGCOLOR, clrGray);
            ObjectSetString(0, slotTextName, OBJPROP_TEXT, Translate("UI_DRAG_HERE"));
            
            ShowNotification("Slot rimosso", clrOrange);
         }
      }
   }
   
   // Gestisce l'inizio del trascinamento di un oggetto
   void HandleObjectDrag(string objectName)
   {
      if(!m_isDragging)
      {
         m_isDragging = true;
         m_draggedObject = objectName;
         
         // Memorizza la posizione iniziale
         m_dragStartX = (int)ObjectGetInteger(0, objectName, OBJPROP_XDISTANCE);
         m_dragStartY = (int)ObjectGetInteger(0, objectName, OBJPROP_YDISTANCE);
      }
   }
   
   // Gestisce la fine del trascinamento di un oggetto
   void HandleObjectDragEnd()
   {
      if(!m_isDragging) return;
      
      m_isDragging = false;
      
      // Verifica se l'oggetto è stato trascinato su uno slot
      if(StringFind(m_draggedObject, "Indicator_") >= 0)
      {
         // Ottieni la posizione finale
         int finalX = (int)ObjectGetInteger(0, m_draggedObject, OBJPROP_XDISTANCE);
         int finalY = (int)ObjectGetInteger(0, m_draggedObject, OBJPROP_YDISTANCE);
         
         // Verifica se la posizione finale è all'interno di uno slot
         ENUM_SLOT_TYPE slotType;
         int slotIndex;
         
         if(IsPositionOverSlot(finalX, finalY, slotType, slotIndex))
         {
            // Assegna l'indicatore allo slot
            AssignIndicatorToSlot(m_draggedObject, slotType, slotIndex);
         }
         
         // Riporta l'oggetto alla posizione iniziale
         ObjectSetInteger(0, m_draggedObject, OBJPROP_XDISTANCE, m_dragStartX);
         ObjectSetInteger(0, m_draggedObject, OBJPROP_YDISTANCE, m_dragStartY);
      }
      
      m_draggedObject = "";
   }
   
   // Verifica se una posizione è sopra uno slot
   bool IsPositionOverSlot(int x, int y, ENUM_SLOT_TYPE &slotType, int &slotIndex)
   {
      // Verifica gli slot di acquisto
      for(int i = 0; i < m_maxBuySlots; i++)
      {
         string slotName = m_prefix + "BuySlot" + IntegerToString(i);
         if(IsPositionOverObject(x, y, slotName))
         {
            slotType = SLOT_BUY;
            slotIndex = i;
            return true;
         }
      }
      
      // Verifica gli slot di vendita
      for(int i = 0; i < m_maxSellSlots; i++)
      {
         string slotName = m_prefix + "SellSlot" + IntegerToString(i);
         if(IsPositionOverObject(x, y, slotName))
         {
            slotType = SLOT_SELL;
            slotIndex = i;
            return true;
         }
      }
      
      // Verifica gli slot di filtro
      for(int i = 0; i < m_maxFilterSlots; i++)
      {
         string slotName = m_prefix + "FilterSlot" + IntegerToString(i);
         if(IsPositionOverObject(x, y, slotName))
         {
            slotType = SLOT_FILTER;
            slotIndex = i;
            return true;
         }
      }
      
      return false;
   }
   
   // Verifica se una posizione è sopra un oggetto
   bool IsPositionOverObject(int x, int y, string objectName)
   {
      if(ObjectFind(0, objectName) < 0) return false;
      
      int objX = (int)ObjectGetInteger(0, objectName, OBJPROP_XDISTANCE);
      int objY = (int)ObjectGetInteger(0, objectName, OBJPROP_YDISTANCE);
      int objWidth = (int)ObjectGetInteger(0, objectName, OBJPROP_XSIZE);
      int objHeight = (int)ObjectGetInteger(0, objectName, OBJPROP_YSIZE);
      
      return (x >= objX && x <= objX + objWidth && y >= objY && y <= objY + objHeight);
   }
   
   // Assegna un indicatore a uno slot
   void AssignIndicatorToSlot(string indicatorObject, ENUM_SLOT_TYPE slotType, int slotIndex)
   {
      if(m_slotManager == NULL) return;
      
      // Estrai le informazioni dell'indicatore dall'oggetto
      string indicatorName = StringSubstr(indicatorObject, StringLen("Indicator_"));
      
      // Qui dovresti implementare la logica per ottenere l'handle dell'indicatore,
      // il buffer, il timeframe, ecc. in base al nome dell'indicatore
      
      // Per ora, utilizziamo valori di esempio
      int handle = iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE);
      int bufferIndex = 0;
      ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT;
      double compareValue = 70.0;
      ENUM_SLOT_CONDITION condition = CONDITION_GREATER;
      
      // Assegna l'indicatore allo slot appropriato
      bool result = false;
      
      switch(slotType)
      {
         case SLOT_BUY:
            result = m_slotManager.SetBuySlot(slotIndex, indicatorName, handle, bufferIndex, timeframe, compareValue, condition);
            break;
            
         case SLOT_SELL:
            result = m_slotManager.SetSellSlot(slotIndex, indicatorName, handle, bufferIndex, timeframe, compareValue, condition);
            break;
            
         case SLOT_FILTER:
            result = m_slotManager.SetFilterSlot(slotIndex, indicatorName, handle, bufferIndex, timeframe, compareValue, condition);
            break;
      }
      
      if(result)
      {
         // Aggiorna la visualizzazione dello slot
         string slotPrefix;
         switch(slotType)
         {
            case SLOT_BUY:    slotPrefix = "BuySlot"; break;
            case SLOT_SELL:   slotPrefix = "SellSlot"; break;
            case SLOT_FILTER: slotPrefix = "FilterSlot"; break;
         }
         
         string slotName = m_prefix + slotPrefix + IntegerToString(slotIndex);
         string slotTextName = m_prefix + slotPrefix + "Text" + IntegerToString(slotIndex);
         
         ObjectSetInteger(0, slotName, OBJPROP_BGCOLOR, m_assignedColor);
         ObjectSetString(0, slotTextName, OBJPROP_TEXT, indicatorName + " [Buff00]");
         
         ShowNotification("Indicatore assegnato allo slot", clrLime);
      }
   }
   
   // Gestisce i clic sugli slot
   void HandleSlotClick(string slotName)
   {
      // Implementazione della gestione dei clic sugli slot
      // ...
   }
   
   // Gestisce i cambiamenti nei valori di rischio
   void HandleRiskValueChange(string editName)
   {
      if(m_slotManager == NULL) return;
      
      // Estrai l'indice del campo
      int index = (int)StringToInteger(StringSubstr(editName, StringLen(m_prefix + "RiskValue")));
      
      // Ottieni il nuovo valore
      string value = ObjectGetString(0, editName, OBJPROP_TEXT);
      
      // Aggiorna il parametro appropriato
      switch(index)
      {
         case 0: // Risk%
            // Aggiorna il rischio percentuale
            break;
            
         case 1: // SL
            // Aggiorna lo stop loss
            break;
            
         case 2: // TP
            // Aggiorna il take profit
            break;
            
         case 3: // BE
            // Aggiorna il break even
            break;
            
         case 4: // TS
            // Aggiorna il trailing stop
            break;
            
         case 5: // Magic
            // Aggiorna il numero magico
            break;
            
         case 6: // Comment
            // Aggiorna il commento
            break;
      }
   }
};
