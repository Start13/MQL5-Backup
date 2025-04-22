//+------------------------------------------------------------------+
//|                                             PresetManager.mqh |
//|        Sistema di gestione preset per OmniEA                  |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <Files\FileTxt.mqh>
#include <Files\FileJson.mqh>
#include "Localization.mqh"

// Struttura per i parametri aggiuntivi
struct Parameter
{
   string            name;              // Nome del parametro
   string            value;             // Valore del parametro
};

// Struttura per gli slot
struct Slot
{
   string            indicatorName;     // Nome dell'indicatore
   int               bufferIndex;       // Indice del buffer
   string            bufferLabel;       // Etichetta del buffer
   int               timeframe;         // Timeframe
   double            compareValue;      // Valore di confronto
   double            compareValue2;     // Valore di confronto 2
   int               condition;         // Condizione
   int               logicOp;           // Operatore logico
};

// Struttura per i preset
struct Preset
{
   string            name;              // Nome del preset
   string            description;       // Descrizione
   string            author;            // Autore
   string            version;           // Versione
   datetime          created;           // Data di creazione
   datetime          modified;          // Data di modifica
   string            symbol;            // Simbolo
   
   double            riskPercent;       // Percentuale di rischio
   double            stopLoss;          // Stop loss
   double            takeProfit;        // Take profit
   bool              useBreakEven;      // Usa break even
   double            breakEvenLevel;    // Livello di break even
   bool              useTrailingStop;   // Usa trailing stop
   double            trailingStop;      // Trailing stop
   
   Slot              buySlots[];        // Slot di acquisto
   Slot              sellSlots[];       // Slot di vendita
   Slot              filterSlots[];     // Slot di filtro
   
   Parameter         parameters[];      // Parametri aggiuntivi
};

// Classe per la gestione dei preset
class CPresetManager
{
private:
   string            m_presetDirectory; // Directory dei preset
   Preset            m_preset;          // Preset corrente
   
public:
   // Costruttore
   CPresetManager()
   {
      m_presetDirectory = "Data\\OmniEA\\Presets";
      
      // Inizializza il preset corrente
      m_preset.name = "Default";
      m_preset.description = "Preset predefinito";
      m_preset.author = "BlueTrendTeam";
      m_preset.version = "1.0";
      m_preset.created = TimeCurrent();
      m_preset.modified = TimeCurrent();
      m_preset.symbol = _Symbol;
      
      m_preset.riskPercent = 1.0;
      m_preset.stopLoss = 50.0;
      m_preset.takeProfit = 100.0;
      m_preset.useBreakEven = true;
      m_preset.breakEvenLevel = 30.0;
      m_preset.useTrailingStop = true;
      m_preset.trailingStop = 20.0;
   }
   
   // Inizializzazione
   bool Init()
   {
      // Crea la directory dei preset se non esiste
      string path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\" + m_presetDirectory;
      
      // Verifica se la directory esiste
      string temp;
      long handle = FileFindFirst(path + "\\*.*", temp, FILE_COMMON);
      
      if(handle == INVALID_HANDLE)
      {
         // La directory non esiste, la creiamo
         if(!FolderCreate(path, FILE_COMMON))
         {
            Print("❌ Errore nella creazione della directory dei preset: ", path);
            return false;
         }
      }
      else
      {
         // La directory esiste, chiudiamo l'handle
         FileFindClose(handle);
      }
      
      return true;
   }
   
   // Salva le impostazioni correnti
   bool SaveCurrentSettings()
   {
      // Aggiorna la data di modifica
      m_preset.modified = TimeCurrent();
      
      // Salva il preset con il nome corrente
      return SavePreset(m_preset.name);
   }
   
   // Salva un preset con un nome specifico
   bool SavePreset(string name)
   {
      // Aggiorna il nome del preset
      m_preset.name = name;
      
      // Crea il percorso completo del file
      string path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\" + m_presetDirectory + "\\" + name + ".json";
      
      CJAVal json;
      
      // Informazioni di base
      json.Add("name", m_preset.name);
      json.Add("description", m_preset.description);
      json.Add("author", m_preset.author);
      json.Add("version", m_preset.version);
      json.Add("created", (long)m_preset.created);
      json.Add("modified", (long)m_preset.modified);
      json.Add("symbol", m_preset.symbol);
      
      // Parametri di rischio
      CJAVal *risk = json.Add("risk");
      risk.Add("riskPercent", m_preset.riskPercent);
      risk.Add("stopLoss", m_preset.stopLoss);
      risk.Add("takeProfit", m_preset.takeProfit);
      risk.Add("useBreakEven", m_preset.useBreakEven);
      risk.Add("breakEvenLevel", m_preset.breakEvenLevel);
      risk.Add("useTrailingStop", m_preset.useTrailingStop);
      risk.Add("trailingStop", m_preset.trailingStop);
      
      // Slot di acquisto
      CJAVal *buySlots = json.AddArray("buySlots");
      for(int i = 0; i < ArraySize(m_preset.buySlots); i++)
      {
         CJAVal *slot = buySlots.Add("");
         slot.Add("indicatorName", m_preset.buySlots[i].indicatorName);
         slot.Add("bufferIndex", (long)m_preset.buySlots[i].bufferIndex);
         slot.Add("bufferLabel", m_preset.buySlots[i].bufferLabel);
         slot.Add("timeframe", (long)m_preset.buySlots[i].timeframe);
         slot.Add("compareValue", m_preset.buySlots[i].compareValue);
         slot.Add("compareValue2", m_preset.buySlots[i].compareValue2);
         slot.Add("condition", (long)m_preset.buySlots[i].condition);
         slot.Add("logicOp", (long)m_preset.buySlots[i].logicOp);
      }
      
      // Slot di vendita
      CJAVal *sellSlots = json.AddArray("sellSlots");
      for(int i = 0; i < ArraySize(m_preset.sellSlots); i++)
      {
         CJAVal *slot = sellSlots.Add("");
         slot.Add("indicatorName", m_preset.sellSlots[i].indicatorName);
         slot.Add("bufferIndex", (long)m_preset.sellSlots[i].bufferIndex);
         slot.Add("bufferLabel", m_preset.sellSlots[i].bufferLabel);
         slot.Add("timeframe", (long)m_preset.sellSlots[i].timeframe);
         slot.Add("compareValue", m_preset.sellSlots[i].compareValue);
         slot.Add("compareValue2", m_preset.sellSlots[i].compareValue2);
         slot.Add("condition", (long)m_preset.sellSlots[i].condition);
         slot.Add("logicOp", (long)m_preset.sellSlots[i].logicOp);
      }
      
      // Slot di filtro
      CJAVal *filterSlots = json.AddArray("filterSlots");
      for(int i = 0; i < ArraySize(m_preset.filterSlots); i++)
      {
         CJAVal *slot = filterSlots.Add("");
         slot.Add("indicatorName", m_preset.filterSlots[i].indicatorName);
         slot.Add("bufferIndex", (long)m_preset.filterSlots[i].bufferIndex);
         slot.Add("bufferLabel", m_preset.filterSlots[i].bufferLabel);
         slot.Add("timeframe", (long)m_preset.filterSlots[i].timeframe);
         slot.Add("compareValue", m_preset.filterSlots[i].compareValue);
         slot.Add("compareValue2", m_preset.filterSlots[i].compareValue2);
         slot.Add("condition", (long)m_preset.filterSlots[i].condition);
         slot.Add("logicOp", (long)m_preset.filterSlots[i].logicOp);
      }
      
      // Parametri aggiuntivi
      CJAVal *params = json.AddArray("parameters");
      for(int i = 0; i < ArraySize(m_preset.parameters); i++)
      {
         CJAVal *param = params.Add("");
         param.Add("name", m_preset.parameters[i].name);
         param.Add("value", m_preset.parameters[i].value);
      }
      
      // Salva il file JSON
      if(!json.SaveToFile(path))
      {
         Print("❌ Errore nel salvataggio del preset: ", path);
         return false;
      }
      
      Print("✅ Preset salvato: ", name);
      return true;
   }
   
   // Carica un preset
   bool LoadPreset(string name)
   {
      // Crea il percorso completo del file
      string path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\" + m_presetDirectory + "\\" + name + ".json";
      
      CJAVal json;
      
      // Carica il file JSON
      if(!json.LoadFromFile(path))
      {
         Print("❌ Errore nel caricamento del preset: ", path);
         return false;
      }
      
      // Informazioni di base
      if(json["name"] != NULL) m_preset.name = json["name"].m_value;
      if(json["description"] != NULL) m_preset.description = json["description"].m_value;
      if(json["author"] != NULL) m_preset.author = json["author"].m_value;
      if(json["version"] != NULL) m_preset.version = json["version"].m_value;
      if(json["created"] != NULL) m_preset.created = (datetime)StringToInteger(json["created"].m_value);
      if(json["modified"] != NULL) m_preset.modified = (datetime)StringToInteger(json["modified"].m_value);
      if(json["symbol"] != NULL) m_preset.symbol = json["symbol"].m_value;
      
      // Parametri di rischio
      if(json["risk"] != NULL && json["risk"]["riskPercent"] != NULL) 
         m_preset.riskPercent = StringToDouble(json["risk"]["riskPercent"].m_value);
      if(json["risk"] != NULL && json["risk"]["stopLoss"] != NULL) 
         m_preset.stopLoss = StringToDouble(json["risk"]["stopLoss"].m_value);
      if(json["risk"] != NULL && json["risk"]["takeProfit"] != NULL) 
         m_preset.takeProfit = StringToDouble(json["risk"]["takeProfit"].m_value);
      if(json["risk"] != NULL && json["risk"]["useBreakEven"] != NULL) 
         m_preset.useBreakEven = (json["risk"]["useBreakEven"].m_value == "true");
      if(json["risk"] != NULL && json["risk"]["breakEvenLevel"] != NULL) 
         m_preset.breakEvenLevel = StringToDouble(json["risk"]["breakEvenLevel"].m_value);
      if(json["risk"] != NULL && json["risk"]["useTrailingStop"] != NULL) 
         m_preset.useTrailingStop = (json["risk"]["useTrailingStop"].m_value == "true");
      if(json["risk"] != NULL && json["risk"]["trailingStop"] != NULL) 
         m_preset.trailingStop = StringToDouble(json["risk"]["trailingStop"].m_value);
      
      // Leggi gli slot di acquisto
      int buySlotCount = 0;
      while(json["buySlots"] != NULL && json["buySlots"][buySlotCount] != NULL)
         buySlotCount++;
      
      ArrayResize(m_preset.buySlots, buySlotCount);
      for(int i = 0; i < buySlotCount; i++)
      {
         if(json["buySlots"][i]["indicatorName"] != NULL)
            m_preset.buySlots[i].indicatorName = json["buySlots"][i]["indicatorName"].m_value;
         if(json["buySlots"][i]["bufferIndex"] != NULL)
            m_preset.buySlots[i].bufferIndex = (int)StringToInteger(json["buySlots"][i]["bufferIndex"].m_value);
         if(json["buySlots"][i]["bufferLabel"] != NULL)
            m_preset.buySlots[i].bufferLabel = json["buySlots"][i]["bufferLabel"].m_value;
         if(json["buySlots"][i]["timeframe"] != NULL)
            m_preset.buySlots[i].timeframe = (int)StringToInteger(json["buySlots"][i]["timeframe"].m_value);
         if(json["buySlots"][i]["compareValue"] != NULL)
            m_preset.buySlots[i].compareValue = StringToDouble(json["buySlots"][i]["compareValue"].m_value);
         if(json["buySlots"][i]["compareValue2"] != NULL)
            m_preset.buySlots[i].compareValue2 = StringToDouble(json["buySlots"][i]["compareValue2"].m_value);
         if(json["buySlots"][i]["condition"] != NULL)
            m_preset.buySlots[i].condition = (int)StringToInteger(json["buySlots"][i]["condition"].m_value);
         if(json["buySlots"][i]["logicOp"] != NULL)
            m_preset.buySlots[i].logicOp = (int)StringToInteger(json["buySlots"][i]["logicOp"].m_value);
      }
      
      // Leggi gli slot di vendita
      int sellSlotCount = 0;
      while(json["sellSlots"] != NULL && json["sellSlots"][sellSlotCount] != NULL)
         sellSlotCount++;
      
      ArrayResize(m_preset.sellSlots, sellSlotCount);
      for(int i = 0; i < sellSlotCount; i++)
      {
         if(json["sellSlots"][i]["indicatorName"] != NULL)
            m_preset.sellSlots[i].indicatorName = json["sellSlots"][i]["indicatorName"].m_value;
         if(json["sellSlots"][i]["bufferIndex"] != NULL)
            m_preset.sellSlots[i].bufferIndex = (int)StringToInteger(json["sellSlots"][i]["bufferIndex"].m_value);
         if(json["sellSlots"][i]["bufferLabel"] != NULL)
            m_preset.sellSlots[i].bufferLabel = json["sellSlots"][i]["bufferLabel"].m_value;
         if(json["sellSlots"][i]["timeframe"] != NULL)
            m_preset.sellSlots[i].timeframe = (int)StringToInteger(json["sellSlots"][i]["timeframe"].m_value);
         if(json["sellSlots"][i]["compareValue"] != NULL)
            m_preset.sellSlots[i].compareValue = StringToDouble(json["sellSlots"][i]["compareValue"].m_value);
         if(json["sellSlots"][i]["compareValue2"] != NULL)
            m_preset.sellSlots[i].compareValue2 = StringToDouble(json["sellSlots"][i]["compareValue2"].m_value);
         if(json["sellSlots"][i]["condition"] != NULL)
            m_preset.sellSlots[i].condition = (int)StringToInteger(json["sellSlots"][i]["condition"].m_value);
         if(json["sellSlots"][i]["logicOp"] != NULL)
            m_preset.sellSlots[i].logicOp = (int)StringToInteger(json["sellSlots"][i]["logicOp"].m_value);
      }
      
      // Leggi gli slot di filtro
      int filterSlotCount = 0;
      while(json["filterSlots"] != NULL && json["filterSlots"][filterSlotCount] != NULL)
         filterSlotCount++;
      
      ArrayResize(m_preset.filterSlots, filterSlotCount);
      for(int i = 0; i < filterSlotCount; i++)
      {
         if(json["filterSlots"][i]["indicatorName"] != NULL)
            m_preset.filterSlots[i].indicatorName = json["filterSlots"][i]["indicatorName"].m_value;
         if(json["filterSlots"][i]["bufferIndex"] != NULL)
            m_preset.filterSlots[i].bufferIndex = (int)StringToInteger(json["filterSlots"][i]["bufferIndex"].m_value);
         if(json["filterSlots"][i]["bufferLabel"] != NULL)
            m_preset.filterSlots[i].bufferLabel = json["filterSlots"][i]["bufferLabel"].m_value;
         if(json["filterSlots"][i]["timeframe"] != NULL)
            m_preset.filterSlots[i].timeframe = (int)StringToInteger(json["filterSlots"][i]["timeframe"].m_value);
         if(json["filterSlots"][i]["compareValue"] != NULL)
            m_preset.filterSlots[i].compareValue = StringToDouble(json["filterSlots"][i]["compareValue"].m_value);
         if(json["filterSlots"][i]["compareValue2"] != NULL)
            m_preset.filterSlots[i].compareValue2 = StringToDouble(json["filterSlots"][i]["compareValue2"].m_value);
         if(json["filterSlots"][i]["condition"] != NULL)
            m_preset.filterSlots[i].condition = (int)StringToInteger(json["filterSlots"][i]["condition"].m_value);
         if(json["filterSlots"][i]["logicOp"] != NULL)
            m_preset.filterSlots[i].logicOp = (int)StringToInteger(json["filterSlots"][i]["logicOp"].m_value);
      }
      
      // Leggi i parametri aggiuntivi
      int paramCount = 0;
      while(json["parameters"] != NULL && json["parameters"][paramCount] != NULL)
         paramCount++;
      
      ArrayResize(m_preset.parameters, paramCount);
      for(int i = 0; i < paramCount; i++)
      {
         if(json["parameters"][i]["name"] != NULL)
            m_preset.parameters[i].name = json["parameters"][i]["name"].m_value;
         if(json["parameters"][i]["value"] != NULL)
            m_preset.parameters[i].value = json["parameters"][i]["value"].m_value;
      }
      
      Print("✅ Preset caricato: ", name);
      return true;
   }
   
   // Carica i preset predefiniti
   void LoadDefaultPresets()
   {
      // Implementazione semplificata per la versione Lite
   }
   
   // Ottieni la lista dei preset disponibili
   void GetPresetList(string &fileNames[])
   {
      // Azzera l'array
      ArrayResize(fileNames, 0);
      
      // Crea il percorso completo della directory
      string path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\" + m_presetDirectory;
      
      // Cerca tutti i file .json nella directory
      int count = 0;
      string fileName;
      long handle = FileFindFirst(path + "\\*.json", fileName, FILE_COMMON);
      
      if(handle != INVALID_HANDLE)
      {
         do
         {
            // Rimuovi l'estensione .json
            if(StringLen(fileName) > 5)
            {
               ArrayResize(fileNames, count + 1);
               fileNames[count] = StringSubstr(fileName, 0, StringLen(fileName) - 5);
               count++;
            }
         }
         while(FileFindNext(handle, fileName));
         
         FileFindClose(handle);
      }
      
      ArraySort(fileNames);
   }
   
   // Ottieni il preset corrente
   Preset GetCurrentPreset()
   {
      return m_preset;
   }
   
   // Imposta il preset corrente
   void SetCurrentPreset(Preset &preset)
   {
      m_preset = preset;
   }
   
   // Ottieni il nome del preset corrente
   string GetCurrentPresetName()
   {
      return m_preset.name;
   }
   
   // Ottieni la descrizione del preset corrente
   string GetCurrentPresetDescription()
   {
      return m_preset.description;
   }
   
   // Elimina un preset
   bool DeletePreset(string name)
   {
      // Crea il percorso completo del file
      string path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\" + m_presetDirectory + "\\" + name + ".json";
      
      // Elimina il file
      if(!FileDelete(path, FILE_COMMON))
      {
         Print("❌ Errore nell'eliminazione del preset: ", path);
         return false;
      }
      
      Print("✅ Preset eliminato: ", name);
      return true;
   }
   
   // Salva il preset corrente con un nuovo nome
   bool SavePresetAs(string name)
   {
      m_preset.name = name;
      return SavePreset(name);
   }
};
