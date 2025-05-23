//+------------------------------------------------------------------+
//|                    Add Indicators OmniEA - v3.0                  |
//+------------------------------------------------------------------+
#property strict
#property version "3.0"
#property description "Gestore universale indicatori con pulsante interattivo"
#property description "Clicca il pulsante e trascina gli indicatori sul grafico"

input color ButtonColor = clrRoyalBlue;
input color HighlightColor1 = clrDodgerBlue;
input color HighlightColor2 = clrDeepSkyBlue;
input color TextColor = clrWhite;
input int FontSize = 8;
input int MaxBuffersToCheck = 20;
input int BlinkSpeed = 200;

struct IndicatorData {
   string name;
   int handle;
   int window;
   double buffer_values[];
   int buffer_count;
};

struct Tracker {
   string last_error;
   IndicatorData current_indicator;
   bool waiting_for_indicator;
   datetime wait_start_time;
   int blink_stage;
   bool has_indicator;
   string initial_indicators[]; // Lista degli indicatori presenti all'inizio del countdown
};

Tracker tracker;
int button_handle = -1;
color current_button_color = ButtonColor;

color blink_colors[] = {ButtonColor, HighlightColor1, HighlightColor2, HighlightColor1, ButtonColor};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   int actualFontSize = MathMax(8, MathMin(FontSize, 20));
   int actualMaxBuffers = MathMax(1, MathMin(MaxBuffersToCheck, 50));
   int actualBlinkSpeed = MathMax(100, MathMin(BlinkSpeed, 500));
   
   CreateButton(actualFontSize);
   tracker.waiting_for_indicator = false;
   tracker.has_indicator = false;
   tracker.blink_stage = 0;
   
   EventSetMillisecondTimer(actualBlinkSpeed);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(tracker.current_indicator.handle != INVALID_HANDLE)
      IndicatorRelease(tracker.current_indicator.handle);
   
   ObjectDelete(0, "AddIndicatorButton");
   EventKillTimer();
}

void CreateButton(int fontSize)
{
   button_handle = ObjectCreate(0, "AddIndicatorButton", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_XDISTANCE, 50);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_YDISTANCE, 50);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_XSIZE, 200);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_YSIZE, 60);
   
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_BGCOLOR, ButtonColor);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_COLOR, TextColor);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_FONTSIZE, fontSize);
   ObjectSetString(0, "AddIndicatorButton", OBJPROP_TEXT, "Add Indicator");
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_ALIGN, ALIGN_CENTER);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   if(tracker.waiting_for_indicator)
   {
      tracker.blink_stage = (tracker.blink_stage + 1) % ArraySize(blink_colors);
      current_button_color = blink_colors[tracker.blink_stage];
      ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_BGCOLOR, current_button_color);
      
      int seconds_left = 10 - (int)(TimeCurrent() - tracker.wait_start_time);
      
      if(seconds_left <= 0)
      {
         ResetButtonState(); // Se il countdown termina senza aggiungere un indicatore
         return;
      }
      
      string button_text = StringFormat("Drop Indicator on Chart \nCountdown: %ds", seconds_left);
      ObjectSetString(0, "AddIndicatorButton", OBJPROP_TEXT, button_text);
      
      CheckForNewIndicators(); // Controlla se è stato aggiunto un nuovo indicatore
   }
}

//+------------------------------------------------------------------+
//| Reset dello stato del pulsante                                  |
//+------------------------------------------------------------------+
void ResetButtonState()
{
   tracker.waiting_for_indicator = false;
   ObjectSetString(0, "AddIndicatorButton", OBJPROP_TEXT, tracker.has_indicator ? tracker.current_indicator.name : "Add Indicator");
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_BGCOLOR, ButtonColor);
}

//+------------------------------------------------------------------+
//| Funzioni per il rilevamento indicatori                           |
//+------------------------------------------------------------------+
void CheckForNewIndicators()
{
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for(int i = 0; i < windows; i++)
   {
      int count = ChartIndicatorsTotal(0, i);
      for(int j = 0; j < count; j++)
      {
         string name = ChartIndicatorName(0, i, j);
         int handle = ChartIndicatorGet(0, i, name);
         
         if(handle == INVALID_HANDLE) continue;

         // Verifica se l'indicatore è nuovo rispetto a quelli iniziali
         if(IsNewIndicator(name))
         {
            ProcessNewIndicator(name, handle, i);
            return;
         }
      }
   }
}

bool IsNewIndicator(string name)
{
   // Confronta il nome dell'indicatore con quelli iniziali
   for(int i = 0; i < ArraySize(tracker.initial_indicators); i++)
   {
      if(tracker.initial_indicators[i] == name)
         return false; // L'indicatore è già esistente
   }
   return true; // L'indicatore è nuovo
}

void ProcessNewIndicator(string name, int handle, int window)
{
   tracker.current_indicator.name = name;
   tracker.current_indicator.handle = handle;
   tracker.current_indicator.window = window;

   int buffers = DetectBufferCount(handle);
   tracker.current_indicator.buffer_count = buffers;
   ArrayResize(tracker.current_indicator.buffer_values, buffers);

   // Copia e stampa solo l'ultimo valore dei buffer
   for(int b = 0; b < buffers; b++)
   {
      double values[];
      ArraySetAsSeries(values, true);
      if(CopyBuffer(handle, b, 0, 1, values) > 0) // Copia solo l'ultimo valore
      {
         tracker.current_indicator.buffer_values[b] = values[0];
         Print("Buffer ", b, " Latest Value: ", DoubleToString(values[0], 5));
      }
   }

   tracker.has_indicator = true;
   tracker.waiting_for_indicator = false;
   ObjectSetString(0, "AddIndicatorButton", OBJPROP_TEXT, name);
   ObjectSetInteger(0, "AddIndicatorButton", OBJPROP_BGCOLOR, ButtonColor);
   
   Print("Indicator added: ", name, " (", buffers, " buffers)");
}

int DetectBufferCount(int handle)
{
   int buffers = 0;
   while(buffers < MaxBuffersToCheck)
   {
      double values[];
      ArraySetAsSeries(values, true);
      if(CopyBuffer(handle, buffers, 0, 1, values) <= 0)
         break;
      buffers++;
   }
   return buffers;
}

void RecordInitialIndicators()
{
   // Registra tutti gli indicatori presenti sul grafico prima del countdown
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   ArrayResize(tracker.initial_indicators, 0); // Resetta l'array
   for(int i = 0; i < windows; i++)
   {
      int count = ChartIndicatorsTotal(0, i);
      for(int j = 0; j < count; j++)
      {
         string name = ChartIndicatorName(0, i, j);
         ArrayResize(tracker.initial_indicators, ArraySize(tracker.initial_indicators) + 1);
         tracker.initial_indicators[ArraySize(tracker.initial_indicators) - 1] = name;
      }
   }
}

//+------------------------------------------------------------------+
//| Gestione eventi                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "AddIndicatorButton")
   {
      if(tracker.waiting_for_indicator)
      {
         ResetButtonState();
         Print("Countdown interrotto dall'utente");
      }
      else if(tracker.has_indicator)
      {
         // Chiede conferma per rimuovere l'indicatore
         int result = MessageBox(StringFormat("Remove indicator '%s'?", tracker.current_indicator.name), "Confirm Removal", MB_YESNO | MB_ICONQUESTION);
         if(result == IDYES)
         {
            ResetIndicator();
         }
      }
      else
      {
         StartIndicatorAcquisition();
      }
   }
}

void ResetIndicator()
{
   if(tracker.current_indicator.handle != INVALID_HANDLE)
      IndicatorRelease(tracker.current_indicator.handle);
   
   tracker.current_indicator.name = "";
   tracker.current_indicator.handle = INVALID_HANDLE;
   tracker.current_indicator.buffer_count = 0;
   tracker.has_indicator = false;
   ResetButtonState();
}

void StartIndicatorAcquisition()
{
   tracker.waiting_for_indicator = true;
   tracker.wait_start_time = TimeCurrent();
   tracker.blink_stage = 0;
   RecordInitialIndicators(); // Registra lo stato iniziale degli indicatori
   
   ObjectSetString(0, "AddIndicatorButton", OBJPROP_TEXT, "Drop Indicator on Chart \nCountdown: 10s");
   Print("Ready to add indicators - drag onto chart");
}