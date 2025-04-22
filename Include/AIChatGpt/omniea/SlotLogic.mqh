// SlotLogic.mqh
// Gestione degli slot per indicatori in OmniEA
// Copyright 2025, BlueTrendTeam
#pragma once

#include <Arrays\ArrayObj.mqh>
#include <Indicators\Indicator.mqh>
#include "..\common\UIUtils.mqh"

//+------------------------------------------------------------------+
//| Struttura per gestire uno slot di indicatore                     |
//+------------------------------------------------------------------+
struct IndicatorSlot
{
   string            name;              // Nome dell'indicatore
   int               handle;            // Handle dell'indicatore
   int               bufferIndex;       // Indice del buffer selezionato
   bool              isActive;          // Stato di attivazione
   ENUM_TIMEFRAMES   timeframe;         // Timeframe dell'indicatore
   double            compareValue;      // Valore di confronto
   int               condition;         // Condizione (maggiore, minore, ecc.)
   int               logicOp;           // Operatore logico (AND, OR)
   
   // Costruttore
   IndicatorSlot()
   {
      name = "";
      handle = INVALID_HANDLE;
      bufferIndex = 0;
      isActive = false;
      timeframe = PERIOD_CURRENT;
      compareValue = 0.0;
      condition = 0;
      logicOp = 0;
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
      
      switch(condition)
      {
         case 0: return value > compareValue;  // Maggiore di
         case 1: return value < compareValue;  // Minore di
         case 2: return value == compareValue; // Uguale a
         case 3: return value >= compareValue; // Maggiore o uguale a
         case 4: return value <= compareValue; // Minore o uguale a
         case 5: return value != compareValue; // Diverso da
         default: return false;
      }
   }
};

//+------------------------------------------------------------------+
//| Classe per gestire gli slot degli indicatori                     |
//+------------------------------------------------------------------+
class CSlotManager
{
private:
   IndicatorSlot     buySlots[];        // Slot per segnali di acquisto
   IndicatorSlot     sellSlots[];       // Slot per segnali di vendita
   IndicatorSlot     filterSlots[];     // Slot per filtri
   int               maxBuySlots;       // Numero massimo di slot di acquisto
   int               maxSellSlots;      // Numero massimo di slot di vendita
   int               maxFilterSlots;    // Numero massimo di slot di filtro
   
public:
   // Costruttore
   CSlotManager(int buySlots = 3, int sellSlots = 3, int filterSlots = 2)
   {
      maxBuySlots = buySlots;
      maxSellSlots = sellSlots;
      maxFilterSlots = filterSlots;
      
      ArrayResize(this.buySlots, maxBuySlots);
      ArrayResize(this.sellSlots, maxSellSlots);
      ArrayResize(this.filterSlots, maxFilterSlots);
   }
   
   // Assegna un indicatore a uno slot di acquisto
   bool SetBuySlot(int slotIndex, string name, int handle, int bufferIndex, double compareValue, int condition, int logicOp = 0)
   {
      if(slotIndex < 0 || slotIndex >= maxBuySlots) return false;
      
      buySlots[slotIndex].name = name;
      buySlots[slotIndex].handle = handle;
      buySlots[slotIndex].bufferIndex = bufferIndex;
      buySlots[slotIndex].isActive = true;
      buySlots[slotIndex].compareValue = compareValue;
      buySlots[slotIndex].condition = condition;
      buySlots[slotIndex].logicOp = logicOp;
      
      return true;
   }
   
   // Assegna un indicatore a uno slot di vendita
   bool SetSellSlot(int slotIndex, string name, int handle, int bufferIndex, double compareValue, int condition, int logicOp = 0)
   {
      if(slotIndex < 0 || slotIndex >= maxSellSlots) return false;
      
      sellSlots[slotIndex].name = name;
      sellSlots[slotIndex].handle = handle;
      sellSlots[slotIndex].bufferIndex = bufferIndex;
      sellSlots[slotIndex].isActive = true;
      sellSlots[slotIndex].compareValue = compareValue;
      sellSlots[slotIndex].condition = condition;
      sellSlots[slotIndex].logicOp = logicOp;
      
      return true;
   }
   
   // Assegna un indicatore a uno slot di filtro
   bool SetFilterSlot(int slotIndex, string name, int handle, int bufferIndex, double compareValue, int condition, int logicOp = 0)
   {
      if(slotIndex < 0 || slotIndex >= maxFilterSlots) return false;
      
      filterSlots[slotIndex].name = name;
      filterSlots[slotIndex].handle = handle;
      filterSlots[slotIndex].bufferIndex = bufferIndex;
      filterSlots[slotIndex].isActive = true;
      filterSlots[slotIndex].compareValue = compareValue;
      filterSlots[slotIndex].condition = condition;
      filterSlots[slotIndex].logicOp = logicOp;
      
      return true;
   }
   
   // Verifica le condizioni di acquisto
   bool CheckBuyConditions(int shift = 0)
   {
      bool result = false;
      
      for(int i = 0; i < maxBuySlots; i++)
      {
         if(!buySlots[i].IsValid()) continue;
         
         bool slotResult = buySlots[i].CheckCondition(shift);
         
         if(i == 0)
         {
            result = slotResult;
         }
         else
         {
            // Applica l'operatore logico
            if(buySlots[i-1].logicOp == 0) // AND
               result = result && slotResult;
            else // OR
               result = result || slotResult;
         }
      }
      
      // Applica i filtri
      if(!CheckFilters(shift)) return false;
      
      return result;
   }
   
   // Verifica le condizioni di vendita
   bool CheckSellConditions(int shift = 0)
   {
      bool result = false;
      
      for(int i = 0; i < maxSellSlots; i++)
      {
         if(!sellSlots[i].IsValid()) continue;
         
         bool slotResult = sellSlots[i].CheckCondition(shift);
         
         if(i == 0)
         {
            result = slotResult;
         }
         else
         {
            // Applica l'operatore logico
            if(sellSlots[i-1].logicOp == 0) // AND
               result = result && slotResult;
            else // OR
               result = result || slotResult;
         }
      }
      
      // Applica i filtri
      if(!CheckFilters(shift)) return false;
      
      return result;
   }
   
   // Verifica i filtri
   bool CheckFilters(int shift = 0)
   {
      for(int i = 0; i < maxFilterSlots; i++)
      {
         if(!filterSlots[i].IsValid()) continue;
         
         if(!filterSlots[i].CheckCondition(shift))
            return false;
      }
      
      return true;
   }
   
   // Gestisce l'evento di drag & drop
   void OnDragEnd()
   {
      // Implementazione della gestione del drag & drop
      // ...
   }
};
