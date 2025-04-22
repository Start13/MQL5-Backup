//+------------------------------------------------------------------+
//|                                          BigPanel_BufferFix.mq5  |
//|          Fixed: Buffer Reading and Button Display Issues         |
//+------------------------------------------------------------------+
#property strict
#property version "1.6"
#property description "Fix buffer reading and ensure button shows only the name."

struct IndicatorBox {
   string name;
   int handle;
   int window;
   bool is_waiting;
   datetime wait_start_time;
   int countdown_left;
   int blink_stage;
   bool post_blink;       // Flag for additional 2 seconds blinking
   datetime post_blink_start;
   string initial_indicators[64]; // Store initial indicators
   int initial_count;
};

input color BoxColor = clrRoyalBlue;
input color HighlightColor1 = clrDodgerBlue;
input color HighlightColor2 = clrDeepSkyBlue;
input int CountdownTime = 10;
input int BlinkSpeed = 200;

IndicatorBox box;
color blink_colors[] = {BoxColor, HighlightColor1, HighlightColor2, HighlightColor1, BoxColor};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   InitializeBox();
   EventSetMillisecondTimer(BlinkSpeed);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ResetBox();
   ObjectDelete(0, "IndicatorBox");
   EventKillTimer();
}

//+------------------------------------------------------------------+
//| Initialize the Indicator Box                                     |
//+------------------------------------------------------------------+
void InitializeBox()
{
   box.name = "Add Indicator 1";
   box.handle = -1;
   box.window = -1;
   box.is_waiting = false;
   box.wait_start_time = 0;
   box.countdown_left = CountdownTime;
   box.blink_stage = 0;
   box.post_blink = false;
   box.initial_count = 0;

   if (!ObjectCreate(0, "IndicatorBox", OBJ_BUTTON, 0, 0, 0)) return;
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_XDISTANCE, 50);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_YDISTANCE, 50);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_XSIZE, 200);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_YSIZE, 60);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_BGCOLOR, BoxColor);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, "IndicatorBox", OBJPROP_TEXT, box.name);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_ALIGN, ALIGN_CENTER);
}

//+------------------------------------------------------------------+
//| Reset the Indicator Box                                          |
//+------------------------------------------------------------------+
void ResetBox()
{
   box.is_waiting = false;
   box.wait_start_time = 0;
   box.countdown_left = CountdownTime;
   box.blink_stage = 0;
   box.post_blink = false;
   box.initial_count = 0;

   ObjectSetString(0, "IndicatorBox", OBJPROP_TEXT, box.name);
   ObjectSetInteger(0, "IndicatorBox", OBJPROP_BGCOLOR, BoxColor);
}

//+------------------------------------------------------------------+
//| Timer function - Manage Countdown and Detect Indicators          |
//+------------------------------------------------------------------+
void OnTimer()
{
   if (box.is_waiting)
   {
      // Blink Effect
      box.blink_stage = (box.blink_stage + 1) % ArraySize(blink_colors);
      ObjectSetInteger(0, "IndicatorBox", OBJPROP_BGCOLOR, blink_colors[box.blink_stage]);

      // Countdown Logic
      box.countdown_left = CountdownTime - (int)(TimeCurrent() - box.wait_start_time);
      if (box.countdown_left <= 0)
      {
         Print("Countdown ended. Drag and drop not detected.");
         ResetBox();
         return;
      }

      // Check for New Indicators
      CheckForNewIndicators();
   }
   else if (box.post_blink)
   {
      // Extended Blinking After Adding Indicator
      box.blink_stage = (box.blink_stage + 1) % ArraySize(blink_colors);
      ObjectSetInteger(0, "IndicatorBox", OBJPROP_BGCOLOR, blink_colors[box.blink_stage]);

      if (TimeCurrent() - box.post_blink_start >= 2)
      {
         box.post_blink = false;
         ObjectSetInteger(0, "IndicatorBox", OBJPROP_BGCOLOR, BoxColor);
      }
   }
}

//+------------------------------------------------------------------+
//| Detect new indicators                                            |
//+------------------------------------------------------------------+
void CheckForNewIndicators()
{
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);

   for (int i = 0; i < windows; i++)
   {
      int count = ChartIndicatorsTotal(0, i);
      for (int j = 0; j < count; j++)
      {
         string name = ChartIndicatorName(0, i, j);
         int handle = ChartIndicatorGet(0, i, name);

         // Skip if the indicator was already present at the start
         bool is_new = true;
         for (int k = 0; k < box.initial_count; k++)
         {
            if (box.initial_indicators[k] == name)
            {
               is_new = false;
               break;
            }
         }

         if (is_new && handle != INVALID_HANDLE)
         {
            // Assign the new indicator details
            box.name = name;
            box.handle = handle;
            box.window = i;

            // Log and update the button
            Print("New indicator detected: ", name);
            ObjectSetString(0, "IndicatorBox", OBJPROP_TEXT, name);
            box.is_waiting = false;

            // Start post-blink phase
            box.post_blink = true;
            box.post_blink_start = TimeCurrent();

            // Read and Print Indicator Buffers
            ReadIndicatorValues(handle);

            return;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Read and Print Indicator Buffers                                 |
//+------------------------------------------------------------------+
void ReadIndicatorValues(int handle)
{
   int bufferCount = 0;

   // Determine buffer count dynamically
   while (bufferCount < 64) // Max 64 buffers
   {
      double buffer[];
      ArraySetAsSeries(buffer, true);
      if (CopyBuffer(handle, bufferCount, 0, 1, buffer) <= 0) break;
      bufferCount++;
   }

   // Print all buffer values
   Print("Indicator: ", box.name, " | Buffer Count: ", bufferCount);

   for (int bufferIndex = 0; bufferIndex < bufferCount; bufferIndex++)
   {
      double values[];
      ArraySetAsSeries(values, true);

      if (CopyBuffer(handle, bufferIndex, 0, 1, values) > 0)
      {
         Print("Buffer ", bufferIndex, " Value: ", values[0]);
      }
      else
      {
         Print("Failed to read Buffer ", bufferIndex, " for ", box.name);
      }
   }
}

//+------------------------------------------------------------------+
//| Record Initial Indicators                                        |
//+------------------------------------------------------------------+
void RecordInitialIndicators()
{
   box.initial_count = 0;
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);

   for (int i = 0; i < windows; i++)
   {
      int count = ChartIndicatorsTotal(0, i);
      for (int j = 0; j < count; j++)
      {
         if (box.initial_count < 64)
         {
            box.initial_indicators[box.initial_count] = ChartIndicatorName(0, i, j);
            box.initial_count++;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Handle Chart Events                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if (id == CHARTEVENT_OBJECT_CLICK && sparam == "IndicatorBox")
   {
      if (box.is_waiting)
      {
         Print("Countdown interrupted by user.");
         ResetBox();
      }
      else
      {
         // Record the initial state of indicators
         RecordInitialIndicators();

         box.is_waiting = true;
         box.wait_start_time = TimeCurrent();
         box.blink_stage = 0;
         ObjectSetString(0, "IndicatorBox", OBJPROP_TEXT, "...");
         Print("Ready to add indicator. Drag onto chart.");
      }
   }
}