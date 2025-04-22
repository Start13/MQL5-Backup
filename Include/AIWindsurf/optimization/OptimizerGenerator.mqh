//+------------------------------------------------------------------+
//|                                       OptimizerGenerator.mqh |
//|        Sistema di generazione configurazioni ottimizzazione    |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <Files\FileTxt.mqh>
#include <AIWindsurf\common\PresetManager.mqh>

//+------------------------------------------------------------------+
//| Struttura per un parametro di ottimizzazione                     |
//+------------------------------------------------------------------+
struct OptimizationParameter
{
   string            name;              // Nome del parametro
   double            start;             // Valore iniziale
   double            end;               // Valore finale
   double            step;              // Passo di incremento
   bool              enabled;           // Parametro abilitato per l'ottimizzazione
};

//+------------------------------------------------------------------+
//| Classe per la generazione di configurazioni di ottimizzazione    |
//+------------------------------------------------------------------+
class COptimizerGenerator
{
private:
   string            m_setDirectory;    // Directory dei file .set
   OptimizationParameter m_parameters[]; // Parametri di ottimizzazione
   
public:
   // Costruttore
   COptimizerGenerator()
   {
      m_setDirectory = "Data\\OmniEA\\Optimization\\";
      
      // Inizializza i parametri di ottimizzazione predefiniti
      InitDefaultParameters();
   }
   
   // Inizializzazione
   bool Initialize()
   {
      // Crea la directory dei file .set se non esiste
      string terminalPath = TerminalInfoString(TERMINAL_DATA_PATH);
      string fullPath = terminalPath + "\\" + m_setDirectory;
      
      if(!FileIsExist(fullPath, FILE_COMMON))
      {
         FolderCreate(fullPath, FILE_COMMON);
      }
      
      return true;
   }
   
   // Inizializza i parametri di ottimizzazione predefiniti
   void InitDefaultParameters()
   {
      // Parametri di rischio
      AddParameter("RiskPercent", 0.5, 3.0, 0.5);
      AddParameter("StopLoss", 20.0, 100.0, 10.0);
      AddParameter("TakeProfit", 40.0, 200.0, 20.0);
      AddParameter("BreakEvenLevel", 20.0, 60.0, 10.0);
      AddParameter("TrailingStop", 15.0, 50.0, 5.0);
      
      // Parametri degli indicatori
      // RSI
      AddParameter("RSI_Period", 7.0, 21.0, 2.0);
      AddParameter("RSI_UpperLevel", 65.0, 80.0, 5.0);
      AddParameter("RSI_LowerLevel", 20.0, 35.0, 5.0);
      
      // Moving Average
      AddParameter("MA_Period", 10.0, 50.0, 5.0);
      AddParameter("MA_Shift", 0.0, 5.0, 1.0);
      
      // MACD
      AddParameter("MACD_FastEMA", 8.0, 24.0, 4.0);
      AddParameter("MACD_SlowEMA", 16.0, 52.0, 4.0);
      AddParameter("MACD_SignalPeriod", 5.0, 15.0, 2.0);
      
      // Bollinger Bands
      AddParameter("BB_Period", 10.0, 30.0, 5.0);
      AddParameter("BB_Deviation", 1.5, 3.0, 0.5);
      
      // Stochastic
      AddParameter("Stoch_KPeriod", 5.0, 15.0, 2.0);
      AddParameter("Stoch_DPeriod", 3.0, 9.0, 2.0);
      AddParameter("Stoch_Slowing", 3.0, 9.0, 2.0);
      AddParameter("Stoch_UpperLevel", 70.0, 85.0, 5.0);
      AddParameter("Stoch_LowerLevel", 15.0, 30.0, 5.0);
   }
   
   // Aggiungi un parametro di ottimizzazione
   void AddParameter(string name, double start, double end, double step, bool enabled = true)
   {
      int count = ArraySize(m_parameters);
      ArrayResize(m_parameters, count + 1);
      
      m_parameters[count].name = name;
      m_parameters[count].start = start;
      m_parameters[count].end = end;
      m_parameters[count].step = step;
      m_parameters[count].enabled = enabled;
   }
   
   // Imposta un parametro di ottimizzazione
   bool SetParameter(string name, double start, double end, double step, bool enabled = true)
   {
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         if(m_parameters[i].name == name)
         {
            m_parameters[i].start = start;
            m_parameters[i].end = end;
            m_parameters[i].step = step;
            m_parameters[i].enabled = enabled;
            return true;
         }
      }
      
      // Se il parametro non esiste, aggiungilo
      AddParameter(name, start, end, step, enabled);
      return true;
   }
   
   // Abilita/disabilita un parametro di ottimizzazione
   bool EnableParameter(string name, bool enabled)
   {
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         if(m_parameters[i].name == name)
         {
            m_parameters[i].enabled = enabled;
            return true;
         }
      }
      
      return false;
   }
   
   // Genera un file .set per l'ottimizzazione
   bool GenerateSetFile(string fileName, string basePreset = "")
   {
      // Crea il percorso completo del file
      string terminalPath = TerminalInfoString(TERMINAL_DATA_PATH);
      string fullPath = terminalPath + "\\" + m_setDirectory + fileName + ".set";
      
      // Crea il file .set
      int handle = FileOpen(fullPath, FILE_WRITE | FILE_TXT | FILE_ANSI);
      if(handle == INVALID_HANDLE)
      {
         Print("❌ Errore apertura file: ", fullPath);
         return false;
      }
      
      // Se è specificato un preset di base, caricalo prima
      if(basePreset != "")
      {
         CPresetManager presetManager;
         if(!presetManager.Initialize())
         {
            Print("❌ Errore inizializzazione PresetManager");
            FileClose(handle);
            return false;
         }
         
         if(!presetManager.LoadPreset(basePreset))
         {
            Print("❌ Errore caricamento preset: ", basePreset);
            FileClose(handle);
            return false;
         }
         
         // Esporta il preset in un file temporaneo
         string tempFile = "temp_" + IntegerToString(GetTickCount()) + ".set";
         if(!presetManager.ExportToSetFile(basePreset, tempFile))
         {
            Print("❌ Errore esportazione preset: ", basePreset);
            FileClose(handle);
            return false;
         }
         
         // Apri il file temporaneo
         int tempHandle = FileOpen(tempFile, FILE_READ | FILE_TXT | FILE_ANSI);
         if(tempHandle == INVALID_HANDLE)
         {
            Print("❌ Errore apertura file temporaneo: ", tempFile);
            FileClose(handle);
            return false;
         }
         
         // Copia i parametri dal file temporaneo al file .set
         while(!FileIsEnding(tempHandle))
         {
            string line = FileReadString(tempHandle);
            int pos = StringFind(line, "=");
            
            if(pos > 0)
            {
               string paramName = StringSubstr(line, 0, pos);
               string paramValue = StringSubstr(line, pos + 1);
               
               // Verifica se il parametro è da ottimizzare
               bool isOptParam = false;
               for(int i = 0; i < ArraySize(m_parameters); i++)
               {
                  if(m_parameters[i].name == paramName && m_parameters[i].enabled)
                  {
                     isOptParam = true;
                     break;
                  }
               }
               
               // Se non è un parametro da ottimizzare, copialo così com'è
               if(!isOptParam)
               {
                  FileWrite(handle, line);
               }
            }
         }
         
         FileClose(tempHandle);
         FileDelete(tempFile);
      }
      
      // Scrivi i parametri di ottimizzazione
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         if(m_parameters[i].enabled)
         {
            string paramLine = m_parameters[i].name + "=" + DoubleToString(m_parameters[i].start, 2);
            paramLine += "||" + DoubleToString(m_parameters[i].end, 2);
            paramLine += "||" + DoubleToString(m_parameters[i].step, 2);
            paramLine += "||Y"; // Y indica che il parametro è abilitato per l'ottimizzazione
            
            FileWrite(handle, paramLine);
         }
      }
      
      FileClose(handle);
      
      Print("✅ File .set generato: ", fileName);
      return true;
   }
   
   // Genera un file .set per l'ottimizzazione di una strategia specifica
   bool GenerateStrategySetFile(string fileName, string strategy)
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Abilita i parametri in base alla strategia
      if(strategy == "RSI")
      {
         EnableParameter("RSI_Period", true);
         EnableParameter("RSI_UpperLevel", true);
         EnableParameter("RSI_LowerLevel", true);
         EnableParameter("StopLoss", true);
         EnableParameter("TakeProfit", true);
      }
      else if(strategy == "MovingAverage")
      {
         EnableParameter("MA_Period", true);
         EnableParameter("MA_Shift", true);
         EnableParameter("StopLoss", true);
         EnableParameter("TakeProfit", true);
      }
      else if(strategy == "MACD")
      {
         EnableParameter("MACD_FastEMA", true);
         EnableParameter("MACD_SlowEMA", true);
         EnableParameter("MACD_SignalPeriod", true);
         EnableParameter("StopLoss", true);
         EnableParameter("TakeProfit", true);
      }
      else if(strategy == "BollingerBands")
      {
         EnableParameter("BB_Period", true);
         EnableParameter("BB_Deviation", true);
         EnableParameter("StopLoss", true);
         EnableParameter("TakeProfit", true);
      }
      else if(strategy == "Stochastic")
      {
         EnableParameter("Stoch_KPeriod", true);
         EnableParameter("Stoch_DPeriod", true);
         EnableParameter("Stoch_Slowing", true);
         EnableParameter("Stoch_UpperLevel", true);
         EnableParameter("Stoch_LowerLevel", true);
         EnableParameter("StopLoss", true);
         EnableParameter("TakeProfit", true);
      }
      else if(strategy == "RiskManagement")
      {
         EnableParameter("RiskPercent", true);
         EnableParameter("StopLoss", true);
         EnableParameter("TakeProfit", true);
         EnableParameter("BreakEvenLevel", true);
         EnableParameter("TrailingStop", true);
      }
      else
      {
         Print("❌ Strategia non riconosciuta: ", strategy);
         return false;
      }
      
      // Genera il file .set
      return GenerateSetFile(fileName);
   }
   
   // Genera un file .set per l'ottimizzazione su più timeframe
   bool GenerateMultiTimeframeSetFile(string fileName, string basePreset = "")
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per i timeframe
      AddParameter("UseM1", 0.0, 1.0, 1.0, true);
      AddParameter("UseM5", 0.0, 1.0, 1.0, true);
      AddParameter("UseM15", 0.0, 1.0, 1.0, true);
      AddParameter("UseM30", 0.0, 1.0, 1.0, true);
      AddParameter("UseH1", 0.0, 1.0, 1.0, true);
      AddParameter("UseH4", 0.0, 1.0, 1.0, true);
      AddParameter("UseD1", 0.0, 1.0, 1.0, true);
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName, basePreset);
   }
   
   // Genera un file .set per l'ottimizzazione su più coppie di valute
   bool GenerateMultiSymbolSetFile(string fileName, string symbols[], string basePreset = "")
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per i simboli
      for(int i = 0; i < ArraySize(symbols); i++)
      {
         AddParameter("Use" + symbols[i], 0.0, 1.0, 1.0, true);
      }
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName, basePreset);
   }
   
   // Genera un file .set per l'ottimizzazione walk-forward
   bool GenerateWalkForwardSetFile(string fileName, string basePreset = "")
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per il walk-forward
      AddParameter("WalkForwardMode", 0.0, 2.0, 1.0, true); // 0=Disabled, 1=Sequential, 2=Anchored
      AddParameter("WalkForwardSteps", 1.0, 10.0, 1.0, true);
      AddParameter("WalkForwardStepSize", 1.0, 12.0, 1.0, true); // In mesi
      
      // Abilita i parametri di ottimizzazione principali
      EnableParameter("RSI_Period", true);
      EnableParameter("MA_Period", true);
      EnableParameter("MACD_FastEMA", true);
      EnableParameter("MACD_SlowEMA", true);
      EnableParameter("BB_Period", true);
      EnableParameter("Stoch_KPeriod", true);
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName, basePreset);
   }
   
   // Genera un file .set per l'ottimizzazione genetica
   bool GenerateGeneticSetFile(string fileName, string basePreset = "")
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per l'ottimizzazione genetica
      AddParameter("GeneticPopulation", 50.0, 200.0, 50.0, true);
      AddParameter("GeneticGenerations", 10.0, 50.0, 10.0, true);
      AddParameter("GeneticElitism", 5.0, 20.0, 5.0, true);
      
      // Abilita tutti i parametri principali
      EnableParameter("RSI_Period", true);
      EnableParameter("RSI_UpperLevel", true);
      EnableParameter("RSI_LowerLevel", true);
      EnableParameter("MA_Period", true);
      EnableParameter("MA_Shift", true);
      EnableParameter("MACD_FastEMA", true);
      EnableParameter("MACD_SlowEMA", true);
      EnableParameter("MACD_SignalPeriod", true);
      EnableParameter("BB_Period", true);
      EnableParameter("BB_Deviation", true);
      EnableParameter("Stoch_KPeriod", true);
      EnableParameter("Stoch_DPeriod", true);
      EnableParameter("Stoch_Slowing", true);
      EnableParameter("Stoch_UpperLevel", true);
      EnableParameter("Stoch_LowerLevel", true);
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      EnableParameter("BreakEvenLevel", true);
      EnableParameter("TrailingStop", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName, basePreset);
   }
   
   // Genera un file .set per l'auto-ottimizzazione settimanale
   bool GenerateWeeklyAutoOptimizationSetFile(string fileName, string basePreset = "")
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per l'auto-ottimizzazione
      AddParameter("AutoOptimizationEnabled", 0.0, 1.0, 1.0, true);
      AddParameter("AutoOptimizationDay", 0.0, 6.0, 1.0, true); // 0=Domenica, 6=Sabato
      AddParameter("AutoOptimizationHour", 0.0, 23.0, 1.0, true);
      AddParameter("OptimizationPeriod", 1.0, 12.0, 1.0, true); // In mesi
      
      // Abilita i parametri di ottimizzazione principali
      EnableParameter("RSI_Period", true);
      EnableParameter("MA_Period", true);
      EnableParameter("MACD_FastEMA", true);
      EnableParameter("MACD_SlowEMA", true);
      EnableParameter("BB_Period", true);
      EnableParameter("Stoch_KPeriod", true);
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName, basePreset);
   }
   
   // Genera un file .set per l'ottimizzazione di Argonaut (gap detection)
   bool GenerateArgonautGapDetectionSetFile(string fileName)
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per il rilevamento dei gap
      AddParameter("GapMinSize", 5.0, 50.0, 5.0, true);
      AddParameter("GapMaxSize", 50.0, 200.0, 10.0, true);
      AddParameter("GapEntryDelay", 0.0, 10.0, 1.0, true);
      AddParameter("GapClosurePercent", 30.0, 90.0, 10.0, true);
      AddParameter("UseWeekendGaps", 0.0, 1.0, 1.0, true);
      AddParameter("UseDailyGaps", 0.0, 1.0, 1.0, true);
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName);
   }
   
   // Genera un file .set per l'ottimizzazione dei parametri adattivi di Argonaut
   bool GenerateArgonautAdaptiveParametersSetFile(string fileName)
   {
      // Disabilita tutti i parametri
      for(int i = 0; i < ArraySize(m_parameters); i++)
      {
         m_parameters[i].enabled = false;
      }
      
      // Aggiungi parametri specifici per i parametri adattivi
      AddParameter("UseAdaptiveParameters", 0.0, 1.0, 1.0, true);
      AddParameter("AdaptationPeriod", 10.0, 100.0, 10.0, true);
      AddParameter("MarketVolatilityFactor", 0.5, 2.0, 0.1, true);
      AddParameter("TrendStrengthFactor", 0.5, 2.0, 0.1, true);
      
      // Abilita i parametri di rischio
      EnableParameter("RiskPercent", true);
      EnableParameter("StopLoss", true);
      EnableParameter("TakeProfit", true);
      
      // Genera il file .set
      return GenerateSetFile(fileName);
   }
};
