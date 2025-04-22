//+------------------------------------------------------------------+
//|                                              SlotManager.mqh |
//|        Sistema avanzato di gestione slot per OmniEA          |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <Arrays\ArrayObj.mqh>
#include <Indicators\Indicator.mqh>
#include "..\..\common\Localization.mqh"
#include "..\..\common\BufferLabeling.mqh"

// Enumerazioni per le condizioni
enum ENUM_SLOT_CONDITION
{
   CONDITION_GREATER,       // Maggiore di
   CONDITION_LESS,          // Minore di
   CONDITION_EQUAL,         // Uguale a
   CONDITION_CROSS_ABOVE,   // Incrocia sopra
   CONDITION_CROSS_BELOW,   // Incrocia sotto
   CONDITION_BETWEEN        // Compreso tra
};

// Enumerazioni per gli operatori logici
enum ENUM_LOGIC_OPERATOR
{
   LOGIC_AND,               // AND (E)
   LOGIC_OR,                // OR (O)
   LOGIC_NOT                // NOT (NON)
};

// Enumerazioni per il tipo di slot
enum ENUM_SLOT_TYPE
{
   SLOT_BUY,                // Slot per segnali di acquisto
   SLOT_SELL,               // Slot per segnali di vendita
   SLOT_FILTER              // Slot per filtri
};

//+------------------------------------------------------------------+
//| Struttura per gestire uno slot di indicatore                     |
//+------------------------------------------------------------------+
struct IndicatorSlot
{
   // Informazioni di base
   string            name;              // Nome dell'indicatore
   int               handle;            // Handle dell'indicatore
   int               bufferIndex;       // Indice del buffer selezionato
   string            bufferLabel;       // Etichetta del buffer
   bool              isActive;          // Stato di attivazione
   
   // Parametri di configurazione
   ENUM_TIMEFRAMES   timeframe;         // Timeframe dell'indicatore
   double            compareValue;      // Valore di confronto
   double            compareValue2;     // Secondo valore di confronto (per CONDITION_BETWEEN)
   ENUM_SLOT_CONDITION condition;       // Condizione (maggiore, minore, ecc.)
   ENUM_LOGIC_OPERATOR logicOp;         // Operatore logico (AND, OR, NOT)
   
   // Valori precedenti per il rilevamento degli incroci
   double            prevValue;         // Valore precedente
   double            prevCompareValue;  // Valore di confronto precedente
   
   // Dati visivi
   color             slotColor;         // Colore dello slot
   string            objectName;        // Nome dell'oggetto grafico
   
   // Costruttore
   IndicatorSlot()
   {
      name = "";
      handle = INVALID_HANDLE;
      bufferIndex = 0;
      bufferLabel = "Buff00";
      isActive = false;
      timeframe = PERIOD_CURRENT;
      compareValue = 0.0;
      compareValue2 = 0.0;
      condition = CONDITION_GREATER;
      logicOp = LOGIC_AND;
      prevValue = 0.0;
      prevCompareValue = 0.0;
      slotColor = clrGray;
      objectName = "";
   }
   
   // Verifica se lo slot è valido
   bool IsValid() const
   {
      return (handle != INVALID_HANDLE && isActive);
   }
   
   // Ottiene il valore corrente del buffer
   double GetValue(int shift = 0)
   {
      if(!IsValid()) return 0.0;
      
      double buffer[];
      if(CopyBuffer(handle, bufferIndex, shift, 1, buffer) <= 0)
         return 0.0;
         
      return buffer[0];
   }
   
   // Verifica la condizione dell'indicatore
   bool CheckCondition(int shift = 0)
   {
      if(!IsValid()) return false;
      
      double value = GetValue(shift);
      double prevVal = GetValue(shift + 1);
      
      // Aggiorna i valori precedenti
      prevValue = value;
      
      switch(condition)
      {
         case CONDITION_GREATER:
            return value > compareValue;
            
         case CONDITION_LESS:
            return value < compareValue;
            
         case CONDITION_EQUAL:
            // Usiamo una piccola tolleranza per i valori float
            return MathAbs(value - compareValue) < 0.000001;
            
         case CONDITION_CROSS_ABOVE:
            return (prevVal <= compareValue && value > compareValue);
            
         case CONDITION_CROSS_BELOW:
            return (prevVal >= compareValue && value < compareValue);
            
         case CONDITION_BETWEEN:
            return (value >= compareValue && value <= compareValue2);
            
         default:
            return false;
      }
   }
   
   // Imposta i parametri dello slot
   void SetParameters(string slotName, int slotHandle, int buffIndex, ENUM_TIMEFRAMES tf, 
                     double compValue, ENUM_SLOT_CONDITION slotCondition, ENUM_LOGIC_OPERATOR logicOperator = LOGIC_AND)
   {
      this.name = slotName;
      this.handle = slotHandle;
      this.bufferIndex = buffIndex;
      this.timeframe = tf;
      this.compareValue = compValue;
      this.condition = slotCondition;
      this.logicOp = logicOperator;
      this.isActive = true;
      this.bufferLabel = GetBufferLabel(buffIndex, slotName);
   }
   
   // Imposta il secondo valore di confronto (per CONDITION_BETWEEN)
   void SetSecondCompareValue(double value)
   {
      this.compareValue2 = value;
   }
   
   // Ottiene una descrizione testuale della condizione
   string GetConditionDescription()
   {
      string desc = name + " [" + bufferLabel + "] ";
      
      switch(condition)
      {
         case CONDITION_GREATER:
            desc += Translate("CONDITION_GREATER") + " " + DoubleToString(compareValue, 5);
            break;
            
         case CONDITION_LESS:
            desc += Translate("CONDITION_LESS") + " " + DoubleToString(compareValue, 5);
            break;
            
         case CONDITION_EQUAL:
            desc += Translate("CONDITION_EQUAL") + " " + DoubleToString(compareValue, 5);
            break;
            
         case CONDITION_CROSS_ABOVE:
            desc += Translate("CONDITION_CROSS_ABOVE") + " " + DoubleToString(compareValue, 5);
            break;
            
         case CONDITION_CROSS_BELOW:
            desc += Translate("CONDITION_CROSS_BELOW") + " " + DoubleToString(compareValue, 5);
            break;
            
         case CONDITION_BETWEEN:
            desc += Translate("CONDITION_BETWEEN") + " " + DoubleToString(compareValue, 5) + 
                   " " + Translate("LOGIC_AND") + " " + DoubleToString(compareValue2, 5);
            break;
      }
      
      return desc;
   }
};

//+------------------------------------------------------------------+
//| Classe per gestire gli slot degli indicatori                     |
//+------------------------------------------------------------------+
class CSlotManager
{
private:
   IndicatorSlot     m_buySlots[];        // Slot per segnali di acquisto
   IndicatorSlot     m_sellSlots[];       // Slot per segnali di vendita
   IndicatorSlot     m_filterSlots[];     // Slot per filtri
   int               m_maxBuySlots;       // Numero massimo di slot di acquisto
   int               m_maxSellSlots;      // Numero massimo di slot di vendita
   int               m_maxFilterSlots;    // Numero massimo di slot di filtro
   
   // Parametri di rischio
   double            m_riskPercent;       // Percentuale di rischio
   double            m_stopLoss;          // Stop Loss in punti
   double            m_takeProfit;        // Take Profit in punti
   bool              m_useBreakEven;      // Usa Break Even
   double            m_breakEvenLevel;    // Livello Break Even in punti
   bool              m_useTrailingStop;   // Usa Trailing Stop
   double            m_trailingStop;      // Trailing Stop in punti
   
   // Stato di trading
   bool              m_isTradingEnabled;  // Trading abilitato
   
public:
   // Costruttore
   CSlotManager(int buySlots = 3, int sellSlots = 3, int filterSlots = 2)
   {
      m_maxBuySlots = buySlots;
      m_maxSellSlots = sellSlots;
      m_maxFilterSlots = filterSlots;
      
      ArrayResize(m_buySlots, m_maxBuySlots);
      ArrayResize(m_sellSlots, m_maxSellSlots);
      ArrayResize(m_filterSlots, m_maxFilterSlots);
      
      m_riskPercent = 1.0;
      m_stopLoss = 50.0;
      m_takeProfit = 100.0;
      m_useBreakEven = true;
      m_breakEvenLevel = 30.0;
      m_useTrailingStop = true;
      m_trailingStop = 20.0;
      
      m_isTradingEnabled = false;
   }
   
   // Inizializzazione
   bool Initialize()
   {
      // Inizializzazione degli slot
      for(int i = 0; i < m_maxBuySlots; i++)
      {
         m_buySlots[i].objectName = "BuySlot_" + IntegerToString(i);
      }
      
      for(int i = 0; i < m_maxSellSlots; i++)
      {
         m_sellSlots[i].objectName = "SellSlot_" + IntegerToString(i);
      }
      
      for(int i = 0; i < m_maxFilterSlots; i++)
      {
         m_filterSlots[i].objectName = "FilterSlot_" + IntegerToString(i);
      }
      
      return true;
   }
   
   // Imposta i parametri di rischio
   void SetRiskParameters(double riskPercent, double stopLoss, double takeProfit, 
                         bool useBreakEven, double breakEvenLevel, 
                         bool useTrailingStop, double trailingStop)
   {
      m_riskPercent = riskPercent;
      m_stopLoss = stopLoss;
      m_takeProfit = takeProfit;
      m_useBreakEven = useBreakEven;
      m_breakEvenLevel = breakEvenLevel;
      m_useTrailingStop = useTrailingStop;
      m_trailingStop = trailingStop;
   }
   
   // Abilita/disabilita il trading
   void EnableTrading(bool enable)
   {
      m_isTradingEnabled = enable;
   }
   
   // Assegna un indicatore a uno slot di acquisto
   bool SetBuySlot(int slotIndex, string name, int handle, int bufferIndex, ENUM_TIMEFRAMES timeframe,
                  double compareValue, ENUM_SLOT_CONDITION condition, ENUM_LOGIC_OPERATOR logicOp = LOGIC_AND)
   {
      if(slotIndex < 0 || slotIndex >= m_maxBuySlots) return false;
      
      m_buySlots[slotIndex].SetParameters(name, handle, bufferIndex, timeframe, compareValue, condition, logicOp);
      return true;
   }
   
   // Assegna un indicatore a uno slot di vendita
   bool SetSellSlot(int slotIndex, string name, int handle, int bufferIndex, ENUM_TIMEFRAMES timeframe,
                   double compareValue, ENUM_SLOT_CONDITION condition, ENUM_LOGIC_OPERATOR logicOp = LOGIC_AND)
   {
      if(slotIndex < 0 || slotIndex >= m_maxSellSlots) return false;
      
      m_sellSlots[slotIndex].SetParameters(name, handle, bufferIndex, timeframe, compareValue, condition, logicOp);
      return true;
   }
   
   // Assegna un indicatore a uno slot di filtro
   bool SetFilterSlot(int slotIndex, string name, int handle, int bufferIndex, ENUM_TIMEFRAMES timeframe,
                     double compareValue, ENUM_SLOT_CONDITION condition, ENUM_LOGIC_OPERATOR logicOp = LOGIC_AND)
   {
      if(slotIndex < 0 || slotIndex >= m_maxFilterSlots) return false;
      
      m_filterSlots[slotIndex].SetParameters(name, handle, bufferIndex, timeframe, compareValue, condition, logicOp);
      return true;
   }
   
   // Imposta il secondo valore di confronto per uno slot (per CONDITION_BETWEEN)
   bool SetSecondCompareValue(ENUM_SLOT_TYPE slotType, int slotIndex, double value)
   {
      switch(slotType)
      {
         case SLOT_BUY:
            if(slotIndex < 0 || slotIndex >= m_maxBuySlots) return false;
            m_buySlots[slotIndex].SetSecondCompareValue(value);
            break;
            
         case SLOT_SELL:
            if(slotIndex < 0 || slotIndex >= m_maxSellSlots) return false;
            m_sellSlots[slotIndex].SetSecondCompareValue(value);
            break;
            
         case SLOT_FILTER:
            if(slotIndex < 0 || slotIndex >= m_maxFilterSlots) return false;
            m_filterSlots[slotIndex].SetSecondCompareValue(value);
            break;
            
         default:
            return false;
      }
      
      return true;
   }
   
   // Verifica le condizioni di acquisto
   bool CheckBuySignal(int shift = 0)
   {
      if(!m_isTradingEnabled) return false;
      
      bool result = false;
      bool hasValidSlot = false;
      
      for(int i = 0; i < m_maxBuySlots; i++)
      {
         if(!m_buySlots[i].IsValid()) continue;
         
         hasValidSlot = true;
         bool slotResult = m_buySlots[i].CheckCondition(shift);
         
         if(i == 0)
         {
            result = slotResult;
         }
         else
         {
            // Applica l'operatore logico
            switch(m_buySlots[i].logicOp)
            {
               case LOGIC_AND:
                  result = result && slotResult;
                  break;
                  
               case LOGIC_OR:
                  result = result || slotResult;
                  break;
                  
               case LOGIC_NOT:
                  result = result && !slotResult;
                  break;
            }
         }
      }
      
      // Se non ci sono slot validi, non generare segnali
      if(!hasValidSlot) return false;
      
      // Applica i filtri
      if(!CheckFilters(shift)) return false;
      
      return result;
   }
   
   // Verifica le condizioni di vendita
   bool CheckSellSignal(int shift = 0)
   {
      if(!m_isTradingEnabled) return false;
      
      bool result = false;
      bool hasValidSlot = false;
      
      for(int i = 0; i < m_maxSellSlots; i++)
      {
         if(!m_sellSlots[i].IsValid()) continue;
         
         hasValidSlot = true;
         bool slotResult = m_sellSlots[i].CheckCondition(shift);
         
         if(i == 0)
         {
            result = slotResult;
         }
         else
         {
            // Applica l'operatore logico
            switch(m_sellSlots[i].logicOp)
            {
               case LOGIC_AND:
                  result = result && slotResult;
                  break;
                  
               case LOGIC_OR:
                  result = result || slotResult;
                  break;
                  
               case LOGIC_NOT:
                  result = result && !slotResult;
                  break;
            }
         }
      }
      
      // Se non ci sono slot validi, non generare segnali
      if(!hasValidSlot) return false;
      
      // Applica i filtri
      if(!CheckFilters(shift)) return false;
      
      return result;
   }
   
   // Verifica i filtri
   bool CheckFilters(int shift = 0)
   {
      for(int i = 0; i < m_maxFilterSlots; i++)
      {
         if(!m_filterSlots[i].IsValid()) continue;
         
         if(!m_filterSlots[i].CheckCondition(shift))
            return false;
      }
      
      return true;
   }
   
   // Ottiene il valore corrente di uno slot
   double GetSlotValue(ENUM_SLOT_TYPE slotType, int slotIndex, int shift = 0)
   {
      switch(slotType)
      {
         case SLOT_BUY:
            if(slotIndex < 0 || slotIndex >= m_maxBuySlots) return 0.0;
            return m_buySlots[slotIndex].GetValue(shift);
            
         case SLOT_SELL:
            if(slotIndex < 0 || slotIndex >= m_maxSellSlots) return 0.0;
            return m_sellSlots[slotIndex].GetValue(shift);
            
         case SLOT_FILTER:
            if(slotIndex < 0 || slotIndex >= m_maxFilterSlots) return 0.0;
            return m_filterSlots[slotIndex].GetValue(shift);
            
         default:
            return 0.0;
      }
   }
   
   // Ottiene la descrizione di uno slot
   string GetSlotDescription(ENUM_SLOT_TYPE slotType, int slotIndex)
   {
      switch(slotType)
      {
         case SLOT_BUY:
            if(slotIndex < 0 || slotIndex >= m_maxBuySlots) return "";
            return m_buySlots[slotIndex].GetConditionDescription();
            
         case SLOT_SELL:
            if(slotIndex < 0 || slotIndex >= m_maxSellSlots) return "";
            return m_sellSlots[slotIndex].GetConditionDescription();
            
         case SLOT_FILTER:
            if(slotIndex < 0 || slotIndex >= m_maxFilterSlots) return "";
            return m_filterSlots[slotIndex].GetConditionDescription();
            
         default:
            return "";
      }
   }
   
   // Gestisce l'evento di drag & drop
   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      // Implementazione della gestione del drag & drop
      // ...
   }
   
   // Ottiene il numero massimo di slot per tipo
   int GetMaxSlots(ENUM_SLOT_TYPE slotType)
   {
      switch(slotType)
      {
         case SLOT_BUY:    return m_maxBuySlots;
         case SLOT_SELL:   return m_maxSellSlots;
         case SLOT_FILTER: return m_maxFilterSlots;
         default:          return 0;
      }
   }
   
   // Ottiene lo stato di un slot
   bool IsSlotActive(ENUM_SLOT_TYPE slotType, int slotIndex)
   {
      switch(slotType)
      {
         case SLOT_BUY:
            if(slotIndex < 0 || slotIndex >= m_maxBuySlots) return false;
            return m_buySlots[slotIndex].isActive;
            
         case SLOT_SELL:
            if(slotIndex < 0 || slotIndex >= m_maxSellSlots) return false;
            return m_sellSlots[slotIndex].isActive;
            
         case SLOT_FILTER:
            if(slotIndex < 0 || slotIndex >= m_maxFilterSlots) return false;
            return m_filterSlots[slotIndex].isActive;
            
         default:
            return false;
      }
   }
   
   // Disattiva uno slot
   bool DeactivateSlot(ENUM_SLOT_TYPE slotType, int slotIndex)
   {
      switch(slotType)
      {
         case SLOT_BUY:
            if(slotIndex < 0 || slotIndex >= m_maxBuySlots) return false;
            m_buySlots[slotIndex].isActive = false;
            break;
            
         case SLOT_SELL:
            if(slotIndex < 0 || slotIndex >= m_maxSellSlots) return false;
            m_sellSlots[slotIndex].isActive = false;
            break;
            
         case SLOT_FILTER:
            if(slotIndex < 0 || slotIndex >= m_maxFilterSlots) return false;
            m_filterSlots[slotIndex].isActive = false;
            break;
            
         default:
            return false;
      }
      
      return true;
   }
   
   // Ottiene i parametri di rischio
   double GetRiskPercent() { return m_riskPercent; }
   double GetStopLoss() { return m_stopLoss; }
   double GetTakeProfit() { return m_takeProfit; }
   bool GetUseBreakEven() { return m_useBreakEven; }
   double GetBreakEvenLevel() { return m_breakEvenLevel; }
   bool GetUseTrailingStop() { return m_useTrailingStop; }
   double GetTrailingStop() { return m_trailingStop; }
};
