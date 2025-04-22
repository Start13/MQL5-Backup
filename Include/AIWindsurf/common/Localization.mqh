//+------------------------------------------------------------------+
//|                                             Localization.mqh |
//|        Sistema di localizzazione per OmniEA                  |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <Arrays\ArrayString.mqh>

// Classe per gestire le traduzioni
class CLocalization
{
private:
   string            m_keys[];          // Array delle chiavi
   string            m_values[];        // Array dei valori
   int               m_count;           // Numero di traduzioni
   string            m_language;        // Lingua corrente
   
   // Trova l'indice di una chiave
   int FindKey(const string key)
   {
      for(int i = 0; i < m_count; i++)
      {
         if(m_keys[i] == key)
            return i;
      }
      return -1;
   }

public:
   // Costruttore
   CLocalization(const string language = "it")
   {
      m_count = 0;
      m_language = language;
      InitTranslations();
   }
   
   // Inizializzazione delle traduzioni
   void InitTranslations()
   {
      // Pulisci le traduzioni esistenti
      ArrayFree(m_keys);
      ArrayFree(m_values);
      m_count = 0;
      
      if(m_language == "it")
      {
         // Messaggi di sistema
         Add("INIT_COMPLETED", "Inizializzazione completata");
         Add("INIT_ERROR_SLOT_MANAGER", "❌ Errore inizializzazione SlotManager");
         Add("INIT_ERROR_PANEL_MANAGER", "❌ Errore inizializzazione PanelManager");
         Add("INIT_ERROR_PRESET_MANAGER", "❌ Errore inizializzazione PresetManager");
         Add("DEINIT_COMPLETED", "EA terminato");
         Add("REASON", "Motivo");
         
         // Messaggi di trading
         Add("TRADING_OUTSIDE_HOURS", "Trading non permesso fuori orario");
         Add("TRADING_NEWS_ACTIVE", "Trading sospeso per notizie imminenti");
         Add("SIGNAL_BUY_EXECUTED", "✅ Segnale di acquisto eseguito");
         Add("SIGNAL_SELL_EXECUTED", "✅ Segnale di vendita eseguito");
         Add("POSITION_CLOSED", "Posizione chiusa");
         Add("POSITION_MODIFIED", "Posizione modificata");
         
         // Interfaccia utente
         Add("UI_BUY_SIGNALS", "Segnali di Acquisto");
         Add("UI_SELL_SIGNALS", "Segnali di Vendita");
         Add("UI_FILTERS", "Filtri");
         Add("UI_RISK_MANAGEMENT", "Gestione Rischio");
         Add("UI_DRAG_HERE", "Trascina qui");
         Add("UI_START", "Avvia");
         Add("UI_STOP", "Ferma");
         Add("UI_RESET", "Reset");
         Add("UI_CONFIG", "Config");
         Add("UI_SAVE", "Salva");
         Add("UI_LOAD", "Carica");
         Add("UI_OPTIMIZE", "Ottimizza");
         Add("UI_REPORT", "Report");
         
         // Preset
         Add("PRESET_SAVED", "Preset salvato");
         Add("PRESET_LOADED", "Preset caricato");
         Add("PRESET_ERROR", "Errore nel preset");
         Add("PRESET_SELECT", "Seleziona preset");
         
         // Buffer e indicatori
         Add("BUFFER_SELECT", "Seleziona buffer");
         Add("INDICATOR_SELECT", "Seleziona indicatore");
         Add("CONDITION_SELECT", "Seleziona condizione");
         Add("TIMEFRAME_SELECT", "Seleziona timeframe");
         
         // Condizioni
         Add("CONDITION_GREATER", "Maggiore di");
         Add("CONDITION_LESS", "Minore di");
         Add("CONDITION_EQUAL", "Uguale a");
         Add("CONDITION_CROSS_ABOVE", "Incrocia sopra");
         Add("CONDITION_CROSS_BELOW", "Incrocia sotto");
         Add("CONDITION_BETWEEN", "Compreso tra");
         
         // Operatori logici
         Add("LOGIC_AND", "E");
         Add("LOGIC_OR", "O");
         Add("LOGIC_NOT", "NON");
      }
      else if(m_language == "en")
      {
         // System messages
         Add("INIT_COMPLETED", "Initialization completed");
         Add("INIT_ERROR_SLOT_MANAGER", "❌ Error initializing SlotManager");
         Add("INIT_ERROR_PANEL_MANAGER", "❌ Error initializing PanelManager");
         Add("INIT_ERROR_PRESET_MANAGER", "❌ Error initializing PresetManager");
         Add("DEINIT_COMPLETED", "EA terminated");
         Add("REASON", "Reason");
         
         // Trading messages
         Add("TRADING_OUTSIDE_HOURS", "Trading not allowed outside hours");
         Add("TRADING_NEWS_ACTIVE", "Trading suspended due to upcoming news");
         Add("SIGNAL_BUY_EXECUTED", "✅ Buy signal executed");
         Add("SIGNAL_SELL_EXECUTED", "✅ Sell signal executed");
         Add("POSITION_CLOSED", "Position closed");
         Add("POSITION_MODIFIED", "Position modified");
         
         // User interface
         Add("UI_BUY_SIGNALS", "Buy Signals");
         Add("UI_SELL_SIGNALS", "Sell Signals");
         Add("UI_FILTERS", "Filters");
         Add("UI_RISK_MANAGEMENT", "Risk Management");
         Add("UI_DRAG_HERE", "Drag here");
         Add("UI_START", "Start");
         Add("UI_STOP", "Stop");
         Add("UI_RESET", "Reset");
         Add("UI_CONFIG", "Config");
         Add("UI_SAVE", "Save");
         Add("UI_LOAD", "Load");
         Add("UI_OPTIMIZE", "Optimize");
         Add("UI_REPORT", "Report");
         
         // Presets
         Add("PRESET_SAVED", "Preset saved");
         Add("PRESET_LOADED", "Preset loaded");
         Add("PRESET_ERROR", "Preset error");
         Add("PRESET_SELECT", "Select preset");
         
         // Buffers and indicators
         Add("BUFFER_SELECT", "Select buffer");
         Add("INDICATOR_SELECT", "Select indicator");
         Add("CONDITION_SELECT", "Select condition");
         Add("TIMEFRAME_SELECT", "Select timeframe");
         
         // Conditions
         Add("CONDITION_GREATER", "Greater than");
         Add("CONDITION_LESS", "Less than");
         Add("CONDITION_EQUAL", "Equal to");
         Add("CONDITION_CROSS_ABOVE", "Crosses above");
         Add("CONDITION_CROSS_BELOW", "Crosses below");
         Add("CONDITION_BETWEEN", "Between");
         
         // Logical operators
         Add("LOGIC_AND", "AND");
         Add("LOGIC_OR", "OR");
         Add("LOGIC_NOT", "NOT");
      }
      else if(m_language == "es")
      {
         // Mensajes del sistema
         Add("INIT_COMPLETED", "Inicialización completada");
         Add("INIT_ERROR_SLOT_MANAGER", "❌ Error al inicializar SlotManager");
         Add("INIT_ERROR_PANEL_MANAGER", "❌ Error al inicializar PanelManager");
         Add("INIT_ERROR_PRESET_MANAGER", "❌ Error al inicializar PresetManager");
         Add("DEINIT_COMPLETED", "EA terminado");
         Add("REASON", "Razón");
         
         // Mensajes de trading
         Add("TRADING_OUTSIDE_HOURS", "Trading no permitido fuera de horario");
         Add("TRADING_NEWS_ACTIVE", "Trading suspendido por noticias próximas");
         Add("SIGNAL_BUY_EXECUTED", "✅ Señal de compra ejecutada");
         Add("SIGNAL_SELL_EXECUTED", "✅ Señal de venta ejecutada");
         Add("POSITION_CLOSED", "Posición cerrada");
         Add("POSITION_MODIFIED", "Posición modificada");
         
         // Interfaz de usuario
         Add("UI_BUY_SIGNALS", "Señales de Compra");
         Add("UI_SELL_SIGNALS", "Señales de Venta");
         Add("UI_FILTERS", "Filtros");
         Add("UI_RISK_MANAGEMENT", "Gestión de Riesgo");
         Add("UI_DRAG_HERE", "Arrastra aquí");
         Add("UI_START", "Iniciar");
         Add("UI_STOP", "Detener");
         Add("UI_RESET", "Reiniciar");
         Add("UI_CONFIG", "Config");
         Add("UI_SAVE", "Guardar");
         Add("UI_LOAD", "Cargar");
         Add("UI_OPTIMIZE", "Optimizar");
         Add("UI_REPORT", "Informe");
         
         // Preset
         Add("PRESET_SAVED", "Preset guardado");
         Add("PRESET_LOADED", "Preset cargado");
         Add("PRESET_ERROR", "Error en el preset");
         Add("PRESET_SELECT", "Seleccionar preset");
         
         // Buffer e indicatori
         Add("BUFFER_SELECT", "Seleccionar buffer");
         Add("INDICATOR_SELECT", "Seleccionar indicador");
         Add("CONDITION_SELECT", "Seleccionar condición");
         Add("TIMEFRAME_SELECT", "Seleccionar timeframe");
         
         // Condizioni
         Add("CONDITION_GREATER", "Mayor que");
         Add("CONDITION_LESS", "Menor que");
         Add("CONDITION_EQUAL", "Igual a");
         Add("CONDITION_CROSS_ABOVE", "Cruza por encima");
         Add("CONDITION_CROSS_BELOW", "Cruza por debajo");
         Add("CONDITION_BETWEEN", "Entre");
         
         // Operatori logici
         Add("LOGIC_AND", "Y");
         Add("LOGIC_OR", "O");
         Add("LOGIC_NOT", "NO");
      }
      else if(m_language == "ru")
      {
         // Системные сообщения
         Add("INIT_COMPLETED", "Инициализация завершена");
         Add("INIT_ERROR_SLOT_MANAGER", "❌ Ошибка инициализации SlotManager");
         Add("INIT_ERROR_PANEL_MANAGER", "❌ Ошибка инициализации PanelManager");
         Add("INIT_ERROR_PRESET_MANAGER", "❌ Ошибка инициализации PresetManager");
         Add("DEINIT_COMPLETED", "EA завершен");
         Add("REASON", "Причина");
         
         // Торговые сообщения
         Add("TRADING_OUTSIDE_HOURS", "Торговля запрещена вне часов");
         Add("TRADING_NEWS_ACTIVE", "Торговля приостановлена из-за предстоящих новостей");
         Add("SIGNAL_BUY_EXECUTED", "✅ Сигнал на покупку выполнен");
         Add("SIGNAL_SELL_EXECUTED", "✅ Сигнал на продажу выполнен");
         Add("POSITION_CLOSED", "Позиция закрыта");
         Add("POSITION_MODIFIED", "Позиция изменена");
         
         // Пользовательский интерфейс
         Add("UI_BUY_SIGNALS", "Сигналы Покупки");
         Add("UI_SELL_SIGNALS", "Сигналы Продажи");
         Add("UI_FILTERS", "Фильтры");
         Add("UI_RISK_MANAGEMENT", "Управление Риском");
         Add("UI_DRAG_HERE", "Перетащите сюда");
         Add("UI_START", "Старт");
         Add("UI_STOP", "Стоп");
         Add("UI_RESET", "Сброс");
         Add("UI_CONFIG", "Настройки");
         Add("UI_SAVE", "Сохранить");
         Add("UI_LOAD", "Загрузить");
         Add("UI_OPTIMIZE", "Оптимизировать");
         Add("UI_REPORT", "Отчет");
         
         // Пресеты
         Add("PRESET_SAVED", "Пресет сохранен");
         Add("PRESET_LOADED", "Пресет загружен");
         Add("PRESET_ERROR", "Ошибка пресета");
         Add("PRESET_SELECT", "Выбрать пресет");
         
         // Буферы и индикаторы
         Add("BUFFER_SELECT", "Выбрать буфер");
         Add("INDICATOR_SELECT", "Выбрать индикатор");
         Add("CONDITION_SELECT", "Выбрать условие");
         Add("TIMEFRAME_SELECT", "Выбрать таймфрейм");
         
         // Условия
         Add("CONDITION_GREATER", "Больше чем");
         Add("CONDITION_LESS", "Меньше чем");
         Add("CONDITION_EQUAL", "Равно");
         Add("CONDITION_CROSS_ABOVE", "Пересекает сверху");
         Add("CONDITION_CROSS_BELOW", "Пересекает снизу");
         Add("CONDITION_BETWEEN", "Между");
         
         // Логические операторы
         Add("LOGIC_AND", "И");
         Add("LOGIC_OR", "ИЛИ");
         Add("LOGIC_NOT", "НЕ");
      }
   }
   
   // Aggiunge una traduzione
   void Add(const string key, const string value)
   {
      int index = FindKey(key);
      
      if(index >= 0)
      {
         // Aggiorna il valore se la chiave esiste già
         m_values[index] = value;
      }
      else
      {
         // Aggiungi una nuova traduzione
         ArrayResize(m_keys, m_count + 1);
         ArrayResize(m_values, m_count + 1);
         
         m_keys[m_count] = key;
         m_values[m_count] = value;
         m_count++;
      }
   }
   
   // Verifica se una chiave esiste
   bool ContainsKey(const string key)
   {
      return FindKey(key) >= 0;
   }
   
   // Ottieni il valore di una chiave
   string GetValue(const string key)
   {
      int index = FindKey(key);
      
      if(index >= 0)
         return m_values[index];
         
      return key;
   }
   
   // Imposta la lingua
   void SetLanguage(const string language)
   {
      if(m_language != language)
      {
         m_language = language;
         InitTranslations();
      }
   }
   
   // Ottieni la traduzione
   string Translate(const string key)
   {
      if(ContainsKey(key))
      {
         return GetValue(key);
      }
      
      return key; // Ritorna la chiave se non esiste una traduzione
   }
};

// Istanza globale
CLocalization g_localization;

// Funzione per inizializzare la localizzazione
void InitLocalization(const string language)
{
   g_localization.SetLanguage(language);
}

// Funzione per ottenere una traduzione
string Translate(const string key)
{
   return g_localization.Translate(key);
}
