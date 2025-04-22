//+------------------------------------------------------------------+
//| Gestione degli indicatori per OmniEA                             |
//+------------------------------------------------------------------+
#property strict

struct IndicatorData
{
   string name;
   int handle;
   int window;
   double buffer_values[];
   int buffer_count;
};

struct Tracker
{
   string last_error;
   IndicatorData indicators[];
   int indicator_count;
   bool waiting_for_indicator;
   datetime wait_start_time;
   datetime last_indicator_time;
   int blink_stage;
};

void InitializeTracker(Tracker &tracker, int maxIndicators)
{
   ArrayResize(tracker.indicators, maxIndicators);
   tracker.indicator_count = 0;
   tracker.waiting_for_indicator = false;
   tracker.last_indicator_time = 0;
   tracker.blink_stage = 0;
   tracker.last_error = "";
   Print("Tracker initialized.");
}

void ResetTracker(Tracker &tracker)
{
   tracker.waiting_for_indicator = false;
   tracker.last_indicator_time = 0;
   tracker.indicator_count = 0;
   ArrayResize(tracker.indicators, 0);
   Print("Tracker reset.");
}

void CheckForNewIndicators(Tracker &tracker)
{
   Print("Checking for new indicators...");
   // Logica per rilevare nuovi indicatori e aggiornare il tracker
}