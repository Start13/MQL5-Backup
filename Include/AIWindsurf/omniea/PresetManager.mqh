//+------------------------------------------------------------------+
//|                                             PresetManager.mqh |
//|        Sistema di gestione preset per OmniEA                  |
//|        AlgoWi Implementation                         |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Files\FileTxt.mqh>
#include <Files\FileJson.mqh>
#include "..\common\Localization.mqh"

// Dichiarazioni anticipate
class CSlotManager;
class CPanelManager;

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
   
   // Riferimenti ad altri gestori
   CSlotManager *m_slotManager;     // Riferimento al gestore degli slot
   CPanelManager *m_panelManager;   // Riferimento al gestore del pannello
   
   // Funzione di logging
   void LogError(string message, int errorCode = 0)
   {
      Print(" ERRORE ", errorCode, ": ", message, " | GetLastError(): ", GetLastError());
   }

public:
   CPresetManager();
   ~CPresetManager();
   
   bool Init();
   bool SavePreset(string name);
   bool LoadPreset(string name);
   bool DeletePreset(string name);
   bool SaveCurrentSettings();
   
   // Metodi per ottenere i preset disponibili
   int GetPresetCount();
   string GetPresetName(int index);
   
   // Metodi per ottenere i valori del preset
   string GetPresetName() { return m_preset.name; }
   string GetPresetDescription() { return m_preset.description; }
   string GetPresetAuthor() { return m_preset.author; }
   string GetPresetVersion() { return m_preset.version; }
   datetime GetPresetCreated() { return m_preset.created; }
   datetime GetPresetModified() { return m_preset.modified; }
   string GetPresetSymbol() { return m_preset.symbol; }
   
   double GetPresetRiskPercent() { return m_preset.riskPercent; }
   double GetPresetStopLoss() { return m_preset.stopLoss; }
   double GetPresetTakeProfit() { return m_preset.takeProfit; }
   bool GetPresetUseBreakEven() { return m_preset.useBreakEven; }
   double GetPresetBreakEvenLevel() { return m_preset.breakEvenLevel; }
   bool GetPresetUseTrailingStop() { return m_preset.useTrailingStop; }
   double GetPresetTrailingStop() { return m_preset.trailingStop; }
   
   // Metodi per impostare i valori del preset
   void SetPresetName(string name) { m_preset.name = name; }
   void SetPresetDescription(string description) { m_preset.description = description; }
   void SetPresetAuthor(string author) { m_preset.author = author; }
   void SetPresetVersion(string version) { m_preset.version = version; }
   void SetPresetCreated(datetime created) { m_preset.created = created; }
   void SetPresetModified(datetime modified) { m_preset.modified = modified; }
   void SetPresetSymbol(string symbol) { m_preset.symbol = symbol; }
   
   void SetPresetRiskPercent(double riskPercent) { m_preset.riskPercent = riskPercent; }
   void SetPresetStopLoss(double stopLoss) { m_preset.stopLoss = stopLoss; }
   void SetPresetTakeProfit(double takeProfit) { m_preset.takeProfit = takeProfit; }
   void SetPresetUseBreakEven(bool useBreakEven) { m_preset.useBreakEven = useBreakEven; }
   void SetPresetBreakEvenLevel(double breakEvenLevel) { m_preset.breakEvenLevel = breakEvenLevel; }
   void SetPresetUseTrailingStop(bool useTrailingStop) { m_preset.useTrailingStop = useTrailingStop; }
   void SetPresetTrailingStop(double trailingStop) { m_preset.trailingStop = trailingStop; }
   
   // Metodi di utilità
   Preset GetCurrentPreset() { return m_preset; }
   void SetCurrentPreset(Preset &preset) { m_preset = preset; }
   string GetCurrentPresetName() { return m_preset.name; }
   string GetCurrentPresetDescription() { return m_preset.description; }
   bool SavePresetAs(string name) { m_preset.name = name; return SavePreset(name); }
   
   // Metodi per collegare altri gestori
   void SetSlotManager(CSlotManager *slotMgr);
   void SetPanelManager(CPanelManager *panelMgr);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CPresetManager::CPresetManager()
{
   // Inizializzazione con sistema di fallback
   string basePaths[] = {
      "OmniEA\\Presets",
      "OmniEA",
      ""
   };
   
   bool success = false;
   for(int i = 0; i < ArraySize(basePaths); i++)
   {
      m_presetDirectory = basePaths[i];
      if(Init())
      {
         success = true;
         break;
      }
   }
   
   if(!success)
   {
      LogError("Impossibile inizializzare il PresetManager con nessun percorso");
   }
   
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
   
   // Inizializza i riferimenti ad altri gestori
   m_slotManager = NULL;
   m_panelManager = NULL;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CPresetManager::~CPresetManager()
{
}

//+------------------------------------------------------------------+
//| Inizializza il PresetManager                                     |
//+------------------------------------------------------------------+
bool CPresetManager::Init()
{
   // Crea la directory se non esiste
   if(m_presetDirectory != "")
   {
      if(!FolderCreate(m_presetDirectory))
      {
         LogError("Errore nella creazione della directory: " + m_presetDirectory);
         return false;
      }
   }
   
   // Salva un preset predefinito se non esiste già
   string defaultPresetPath = (m_presetDirectory != "") ? 
                           m_presetDirectory + "\\Default.txt" : 
                           "Default.txt";
                           
   if(!FileIsExist(defaultPresetPath))
   {
      SavePreset("Default");
      Print(" Preset predefinito creato: ", defaultPresetPath);
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Salva un preset                                                  |
//+------------------------------------------------------------------+
bool CPresetManager::SavePreset(string name)
{
   string path = (m_presetDirectory != "") ? 
               m_presetDirectory + "\\" + name + ".txt" : 
               name + ".txt";
   
   int handle = FileOpen(path, FILE_WRITE | FILE_TXT);
   if(handle == INVALID_HANDLE)
   {
      LogError("Errore nell'apertura del file: " + path);
      return false;
   }
   
   FileWriteString(handle, "name=" + m_preset.name + "\n");
   FileWriteString(handle, "description=" + m_preset.description + "\n");
   FileWriteString(handle, "author=" + m_preset.author + "\n");
   FileWriteString(handle, "version=" + m_preset.version + "\n");
   FileWriteString(handle, "created=" + IntegerToString(m_preset.created) + "\n");
   FileWriteString(handle, "modified=" + IntegerToString(m_preset.modified) + "\n");
   FileWriteString(handle, "symbol=" + m_preset.symbol + "\n");
   
   FileWriteString(handle, "riskPercent=" + DoubleToString(m_preset.riskPercent, 2) + "\n");
   FileWriteString(handle, "stopLoss=" + DoubleToString(m_preset.stopLoss, 2) + "\n");
   FileWriteString(handle, "takeProfit=" + DoubleToString(m_preset.takeProfit, 2) + "\n");
   FileWriteString(handle, "useBreakEven=" + (m_preset.useBreakEven ? "true" : "false") + "\n");
   FileWriteString(handle, "breakEvenLevel=" + DoubleToString(m_preset.breakEvenLevel, 2) + "\n");
   FileWriteString(handle, "useTrailingStop=" + (m_preset.useTrailingStop ? "true" : "false") + "\n");
   FileWriteString(handle, "trailingStop=" + DoubleToString(m_preset.trailingStop, 2) + "\n");
   
   // Salva gli slot di acquisto
   FileWriteString(handle, "buySlotCount=" + IntegerToString(ArraySize(m_preset.buySlots)) + "\n");
   for(int i = 0; i < ArraySize(m_preset.buySlots); i++)
   {
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_indicatorName=" + m_preset.buySlots[i].indicatorName + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_bufferIndex=" + IntegerToString(m_preset.buySlots[i].bufferIndex) + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_bufferLabel=" + m_preset.buySlots[i].bufferLabel + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_timeframe=" + IntegerToString(m_preset.buySlots[i].timeframe) + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_compareValue=" + DoubleToString(m_preset.buySlots[i].compareValue, 5) + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_compareValue2=" + DoubleToString(m_preset.buySlots[i].compareValue2, 5) + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_condition=" + IntegerToString(m_preset.buySlots[i].condition) + "\n");
      FileWriteString(handle, "buySlot_" + IntegerToString(i) + "_logicOp=" + IntegerToString(m_preset.buySlots[i].logicOp) + "\n");
   }
   
   // Salva gli slot di vendita
   FileWriteString(handle, "sellSlotCount=" + IntegerToString(ArraySize(m_preset.sellSlots)) + "\n");
   for(int i = 0; i < ArraySize(m_preset.sellSlots); i++)
   {
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_indicatorName=" + m_preset.sellSlots[i].indicatorName + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_bufferIndex=" + IntegerToString(m_preset.sellSlots[i].bufferIndex) + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_bufferLabel=" + m_preset.sellSlots[i].bufferLabel + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_timeframe=" + IntegerToString(m_preset.sellSlots[i].timeframe) + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_compareValue=" + DoubleToString(m_preset.sellSlots[i].compareValue, 5) + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_compareValue2=" + DoubleToString(m_preset.sellSlots[i].compareValue2, 5) + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_condition=" + IntegerToString(m_preset.sellSlots[i].condition) + "\n");
      FileWriteString(handle, "sellSlot_" + IntegerToString(i) + "_logicOp=" + IntegerToString(m_preset.sellSlots[i].logicOp) + "\n");
   }
   
   // Salva gli slot di filtro
   FileWriteString(handle, "filterSlotCount=" + IntegerToString(ArraySize(m_preset.filterSlots)) + "\n");
   for(int i = 0; i < ArraySize(m_preset.filterSlots); i++)
   {
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_indicatorName=" + m_preset.filterSlots[i].indicatorName + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_bufferIndex=" + IntegerToString(m_preset.filterSlots[i].bufferIndex) + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_bufferLabel=" + m_preset.filterSlots[i].bufferLabel + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_timeframe=" + IntegerToString(m_preset.filterSlots[i].timeframe) + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_compareValue=" + DoubleToString(m_preset.filterSlots[i].compareValue, 5) + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_compareValue2=" + DoubleToString(m_preset.filterSlots[i].compareValue2, 5) + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_condition=" + IntegerToString(m_preset.filterSlots[i].condition) + "\n");
      FileWriteString(handle, "filterSlot_" + IntegerToString(i) + "_logicOp=" + IntegerToString(m_preset.filterSlots[i].logicOp) + "\n");
   }
   
   // Salva i parametri aggiuntivi
   FileWriteString(handle, "parameterCount=" + IntegerToString(ArraySize(m_preset.parameters)) + "\n");
   for(int i = 0; i < ArraySize(m_preset.parameters); i++)
   {
      FileWriteString(handle, "parameter_" + IntegerToString(i) + "_name=" + m_preset.parameters[i].name + "\n");
      FileWriteString(handle, "parameter_" + IntegerToString(i) + "_value=" + m_preset.parameters[i].value + "\n");
   }
   
   FileClose(handle);
   Print(" Preset salvato: ", path);
   return true;
}

//+------------------------------------------------------------------+
//| Salva le impostazioni correnti                                   |
//+------------------------------------------------------------------+
bool CPresetManager::SaveCurrentSettings()
{
   // Aggiorna la data di modifica
   m_preset.modified = TimeCurrent();
   
   // Salva il preset con il nome corrente
   return SavePreset(m_preset.name);
}

//+------------------------------------------------------------------+
//| Carica un preset                                                 |
//+------------------------------------------------------------------+
bool CPresetManager::LoadPreset(string name)
{
   string path = (m_presetDirectory != "") ? 
               m_presetDirectory + "\\" + name + ".txt" : 
               name + ".txt";
   
   if(!FileIsExist(path))
   {
      LogError("Il file del preset non esiste: " + path);
      return false;
   }
   
   int handle = FileOpen(path, FILE_READ | FILE_TXT);
   if(handle == INVALID_HANDLE)
   {
      LogError("Errore nell'apertura del file: " + path);
      return false;
   }
   
   // Imposta i valori predefiniti
   m_preset.name = name;
   m_preset.description = "Preset caricato";
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
   
   // Leggi il file riga per riga
   while(!FileIsEnding(handle))
   {
      string line = FileReadString(handle);
      int equalPos = StringFind(line, "=");
      
      if(equalPos > 0)
      {
         string key = StringSubstr(line, 0, equalPos);
         string value = StringSubstr(line, equalPos + 1);
         
         // Proprietà di base
         if(key == "name") m_preset.name = value;
         else if(key == "description") m_preset.description = value;
         else if(key == "author") m_preset.author = value;
         else if(key == "version") m_preset.version = value;
         else if(key == "created") m_preset.created = (datetime)StringToInteger(value);
         else if(key == "modified") m_preset.modified = (datetime)StringToInteger(value);
         else if(key == "symbol") m_preset.symbol = value;
         
         // Parametri di rischio
         else if(key == "riskPercent") m_preset.riskPercent = StringToDouble(value);
         else if(key == "stopLoss") m_preset.stopLoss = StringToDouble(value);
         else if(key == "takeProfit") m_preset.takeProfit = StringToDouble(value);
         else if(key == "useBreakEven") m_preset.useBreakEven = (value == "true");
         else if(key == "breakEvenLevel") m_preset.breakEvenLevel = StringToDouble(value);
         else if(key == "useTrailingStop") m_preset.useTrailingStop = (value == "true");
         else if(key == "trailingStop") m_preset.trailingStop = StringToDouble(value);
         
         // Conteggio degli slot
         else if(key == "buySlotCount") ArrayResize(m_preset.buySlots, (int)StringToInteger(value));
         else if(key == "sellSlotCount") ArrayResize(m_preset.sellSlots, (int)StringToInteger(value));
         else if(key == "filterSlotCount") ArrayResize(m_preset.filterSlots, (int)StringToInteger(value));
         else if(key == "parameterCount") ArrayResize(m_preset.parameters, (int)StringToInteger(value));
         
         // Slot di acquisto
         else if(StringFind(key, "buySlot_") == 0)
         {
            string parts[];
            StringSplit(key, '_', parts);
            if(ArraySize(parts) >= 3)
            {
               int index = (int)StringToInteger(parts[1]);
               string property = parts[2];
               
               if(property == "indicatorName") m_preset.buySlots[index].indicatorName = value;
               else if(property == "bufferIndex") m_preset.buySlots[index].bufferIndex = (int)StringToInteger(value);
               else if(property == "bufferLabel") m_preset.buySlots[index].bufferLabel = value;
               else if(property == "timeframe") m_preset.buySlots[index].timeframe = (int)StringToInteger(value);
               else if(property == "compareValue") m_preset.buySlots[index].compareValue = StringToDouble(value);
               else if(property == "compareValue2") m_preset.buySlots[index].compareValue2 = StringToDouble(value);
               else if(property == "condition") m_preset.buySlots[index].condition = (int)StringToInteger(value);
               else if(property == "logicOp") m_preset.buySlots[index].logicOp = (int)StringToInteger(value);
            }
         }
         
         // Slot di vendita
         else if(StringFind(key, "sellSlot_") == 0)
         {
            string parts[];
            StringSplit(key, '_', parts);
            if(ArraySize(parts) >= 3)
            {
               int index = (int)StringToInteger(parts[1]);
               string property = parts[2];
               
               if(property == "indicatorName") m_preset.sellSlots[index].indicatorName = value;
               else if(property == "bufferIndex") m_preset.sellSlots[index].bufferIndex = (int)StringToInteger(value);
               else if(property == "bufferLabel") m_preset.sellSlots[index].bufferLabel = value;
               else if(property == "timeframe") m_preset.sellSlots[index].timeframe = (int)StringToInteger(value);
               else if(property == "compareValue") m_preset.sellSlots[index].compareValue = StringToDouble(value);
               else if(property == "compareValue2") m_preset.sellSlots[index].compareValue2 = StringToDouble(value);
               else if(property == "condition") m_preset.sellSlots[index].condition = (int)StringToInteger(value);
               else if(property == "logicOp") m_preset.sellSlots[index].logicOp = (int)StringToInteger(value);
            }
         }
         
         // Slot di filtro
         else if(StringFind(key, "filterSlot_") == 0)
         {
            string parts[];
            StringSplit(key, '_', parts);
            if(ArraySize(parts) >= 3)
            {
               int index = (int)StringToInteger(parts[1]);
               string property = parts[2];
               
               if(property == "indicatorName") m_preset.filterSlots[index].indicatorName = value;
               else if(property == "bufferIndex") m_preset.filterSlots[index].bufferIndex = (int)StringToInteger(value);
               else if(property == "bufferLabel") m_preset.filterSlots[index].bufferLabel = value;
               else if(property == "timeframe") m_preset.filterSlots[index].timeframe = (int)StringToInteger(value);
               else if(property == "compareValue") m_preset.filterSlots[index].compareValue = StringToDouble(value);
               else if(property == "compareValue2") m_preset.filterSlots[index].compareValue2 = StringToDouble(value);
               else if(property == "condition") m_preset.filterSlots[index].condition = (int)StringToInteger(value);
               else if(property == "logicOp") m_preset.filterSlots[index].logicOp = (int)StringToInteger(value);
            }
         }
         
         // Parametri aggiuntivi
         else if(StringFind(key, "parameter_") == 0)
         {
            string parts[];
            StringSplit(key, '_', parts);
            if(ArraySize(parts) >= 3)
            {
               int index = (int)StringToInteger(parts[1]);
               string property = parts[2];
               
               if(property == "name") m_preset.parameters[index].name = value;
               else if(property == "value") m_preset.parameters[index].value = value;
            }
         }
      }
   }
   
   FileClose(handle);
   Print(" Preset caricato: ", path);
   return true;
}

//+------------------------------------------------------------------+
//| Elimina un preset                                                |
//+------------------------------------------------------------------+
bool CPresetManager::DeletePreset(string name)
{
   string path = (m_presetDirectory != "") ? 
               m_presetDirectory + "\\" + name + ".txt" : 
               name + ".txt";
   
   if(!FileIsExist(path))
   {
      LogError("Il file del preset non esiste: " + path);
      return false;
   }
   
   if(!FileDelete(path))
   {
      LogError("Errore nell'eliminazione del file: " + path);
      return false;
   }
   
   Print(" Preset eliminato: ", path);
   return true;
}

//+------------------------------------------------------------------+
//| Ottiene il numero di preset disponibili                          |
//+------------------------------------------------------------------+
int CPresetManager::GetPresetCount()
{
   string path = (m_presetDirectory != "") ? 
               m_presetDirectory + "\\*.txt" : 
               "*.txt";
   
   int count = 0;
   string fileName;
   long handle = FileFindFirst(path, fileName);
   
   if(handle != INVALID_HANDLE)
   {
      count++;
      while(FileFindNext(handle, fileName))
         count++;
      
      FileFindClose(handle);
   }
   
   return count;
}

//+------------------------------------------------------------------+
//| Ottiene il nome di un preset per indice                          |
//+------------------------------------------------------------------+
string CPresetManager::GetPresetName(int index)
{
   string path = (m_presetDirectory != "") ? 
               m_presetDirectory + "\\*.txt" : 
               "*.txt";
   
   int currentIndex = 0;
   string fileName;
   long handle = FileFindFirst(path, fileName);
   
   if(handle != INVALID_HANDLE)
   {
      if(currentIndex == index)
      {
         FileFindClose(handle);
         return StringSubstr(fileName, 0, StringLen(fileName) - 4); // Rimuovi l'estensione .txt
      }
      
      currentIndex++;
      
      while(FileFindNext(handle, fileName))
      {
         if(currentIndex == index)
         {
            FileFindClose(handle);
            return StringSubstr(fileName, 0, StringLen(fileName) - 4); // Rimuovi l'estensione .txt
         }
         
         currentIndex++;
      }
      
      FileFindClose(handle);
   }
   
   return "";
}

//+------------------------------------------------------------------+
//| Metodi per collegare altri gestori                               |
//+------------------------------------------------------------------+
void CPresetManager::SetSlotManager(CSlotManager *slotMgr)
{
   m_slotManager = slotMgr;
}

void CPresetManager::SetPanelManager(CPanelManager *panelMgr)
{
   m_panelManager = panelMgr;
}
