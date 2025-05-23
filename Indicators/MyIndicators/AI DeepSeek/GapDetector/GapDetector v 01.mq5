//+------------------------------------------------------------------+
//|                                                      GapDetector.mq5 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.metaquotes.net/"
#property version   "5.4"
#property indicator_chart_window
#property indicator_plots 0

//+------------------------------------------------------------------+
//| Enumerations                                                     |
//+------------------------------------------------------------------+
enum ENUM_GAP_UNIT
{
   GAP_IN_POINTS,    // Points
   GAP_IN_PIPS       // Pips
};

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
input string            Symbol1 = "EURUSD";            // Symbol 1
input string            Symbol2 = "GBPUSD";            // Symbol 2
input string            Symbol3 = "USDJPY";            // Symbol 3
input string            Symbol4 = "USDCAD";            // Symbol 4
input ENUM_TIMEFRAMES   Timeframe = PERIOD_CURRENT;    // Timeframe to analyze
input double            MinGapSize = 5.0;              // Minimum gap size
input ENUM_GAP_UNIT     GapUnit = GAP_IN_POINTS;       // Gap measurement unit
input bool              EnableAlerts = false;          // Enable alerts
input int               HistoryBars = 300;             // Historical bars to check
input int               PanelX = 20;                   // Panel X position
input int               PanelY = 20;                   // Panel Y position
input color             BullishGapColor = clrGreen;    // Bullish gap color
input color             BearishGapColor = clrRed;      // Bearish gap color

// Pin Bar Detection
input bool              EnablePinBarDetection = true;  // Enable Pin Bar detection
input double            PinBarRatio = 2.0;            // Min shadow/body ratio
input int               PinBarLookback = 5;           // Bars to check for pin bars
input color             BullishPinBarColor = clrTurquoise; // Bullish pin bar color
input color             BearishPinBarColor = clrYellow;    // Bearish pin bar color

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
string symbols[4];
double gapSizes[4];
int gapDirections[4]; // 1=bullish, -1=bearish, 0=no gap
datetime lastBarTime = 0;
int panelHandle;
bool alertsSent[4];
ENUM_TIMEFRAMES currentTimeframe;
bool firstRun = true;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Initialize symbols
   symbols[0] = NormalizeSymbol(Symbol1);
   symbols[1] = NormalizeSymbol(Symbol2);
   symbols[2] = NormalizeSymbol(Symbol3);
   symbols[3] = NormalizeSymbol(Symbol4);
   
   // Reset status arrays
   ArrayInitialize(alertsSent, false);
   ArrayInitialize(gapDirections, 0);
   ArrayInitialize(gapSizes, 0);
   
   // Create UI elements
   CreateInfoPanel();
   
   // Check historical data
   CheckAllHistoricalGaps();
   
   currentTimeframe = Timeframe;
   firstRun = true;
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Clean up all objects
   ObjectsDeleteAll(0, "GapDetector_");
   ObjectsDeleteAll(0, "GapArrow_");
   ObjectsDeleteAll(0, "PinBar_");
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   // Handle timeframe changes
   if(currentTimeframe != Timeframe)
   {
      currentTimeframe = Timeframe;
      ObjectsDeleteAll(0, "GapArrow_");
      CheckAllHistoricalGaps();
   }
   
   // Check for new bar
   datetime currentBarTime = iTime(_Symbol, Timeframe, 0);
   
   if(currentBarTime != lastBarTime || firstRun)
   {
      // Reset alerts for new bar
      ArrayInitialize(alertsSent, false);
      lastBarTime = currentBarTime;
      firstRun = false;
      
      // Perform detection
      CheckCurrentGaps();
      UpdateInfoPanel();
      
      if(EnablePinBarDetection)
         CheckPinBars();
   }
   
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Panel Management Functions                                       |
//+------------------------------------------------------------------+
void CreateInfoPanel()
{
   // Delete existing panel first
   ObjectsDeleteAll(0, "GapDetector_");
   
   // Main panel background - SOLID and on TOP
   ObjectCreate(0, "GapDetector_Panel", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_XDISTANCE, PanelX);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_YDISTANCE, PanelY);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_XSIZE, 220);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_YSIZE, 180);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_BGCOLOR, clrWhiteSmoke);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_BORDER_COLOR, clrSilver);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_ZORDER, 1000);  // Highest priority
   ObjectSetInteger(0, "GapDetector_Panel", OBJPROP_BACK, false);   // No transparency

   // Title
   CreatePanelLabel("Title", "Gap Detector v5.4", PanelX + 10, PanelY + 10, clrBlack, 10);

   // Settings
   CreatePanelLabel("Settings", StringFormat("TF: %s | Gap: %.1f %s", 
                  EnumToString(Timeframe), MinGapSize, (GapUnit == GAP_IN_PIPS) ? "pips" : "points"), 
                  PanelX + 10, PanelY + 30, clrGray, 8);

   // Pin Bar Settings
   CreatePanelLabel("PinBarSettings", StringFormat("PinBar: Ratio %.1f | Lookback %d", 
                  PinBarRatio, PinBarLookback), PanelX + 10, PanelY + 50, clrGray, 8);

   // Headers
   CreatePanelLabel("SymbolHeader", "Symbol", PanelX + 10, PanelY + 80, clrBlack, 8);
   CreatePanelLabel("GapHeader", "Gap", PanelX + 100, PanelY + 80, clrBlack, 8);
   CreatePanelLabel("DirHeader", "Dir", PanelX + 180, PanelY + 80, clrBlack, 8);

   // Symbol rows
   for(int i = 0; i < 4; i++)
   {
      CreatePanelLabel("SymbolLabel" + IntegerToString(i), symbols[i], PanelX + 10, PanelY + 100 + i * 20, clrBlack, 8);
      CreatePanelLabel("GapValue" + IntegerToString(i), "-", PanelX + 100, PanelY + 100 + i * 20, clrGray, 8);
      CreatePanelLabel("GapArrow" + IntegerToString(i), "-", PanelX + 180, PanelY + 100 + i * 20, clrGray, 12);
   }
}

void CreatePanelLabel(string name, string text, int x, int y, color clr, int fontSize=8)
{
   if(ObjectFind(0, "GapDetector_" + name) >= 0)
      ObjectDelete(0, "GapDetector_" + name);
   
   ObjectCreate(0, "GapDetector_" + name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, "GapDetector_" + name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_FONTSIZE, fontSize);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "GapDetector_" + name, OBJPROP_ZORDER, 50);
}

void UpdateInfoPanel()
{
   for(int i = 0; i < 4; i++)
   {
      string gapText = "-";
      string arrowText = "-";
      color textColor = clrGray;
      
      if(gapDirections[i] != 0 && gapSizes[i] >= MinGapSize)
      {
         gapText = DoubleToString(gapSizes[i], 1);
         arrowText = (gapDirections[i] == 1) ? "▲" : "▼";
         textColor = (gapDirections[i] == 1) ? BullishGapColor : BearishGapColor;
      }
      
      // Update gap value
      ObjectSetString(0, "GapDetector_GapValue" + IntegerToString(i), OBJPROP_TEXT, gapText);
      ObjectSetInteger(0, "GapDetector_GapValue" + IntegerToString(i), OBJPROP_COLOR, textColor);
      
      // Update direction arrow
      ObjectSetString(0, "GapDetector_GapArrow" + IntegerToString(i), OBJPROP_TEXT, arrowText);
      ObjectSetInteger(0, "GapDetector_GapArrow" + IntegerToString(i), OBJPROP_COLOR, textColor);
   }
}

//+------------------------------------------------------------------+
//| Detection Functions                                              |
//+------------------------------------------------------------------+
void CheckAllHistoricalGaps()
{
   for(int i = 0; i < 4; i++)
   {
      if(StringLen(symbols[i]) == 0) continue;
      
      MqlRates history[];
      if(CopyRates(symbols[i], Timeframe, 0, HistoryBars, history) < HistoryBars) continue;
      
      for(int j = 1; j < HistoryBars; j++)
      {
         double gap = CalculateGapSize(history[j].open, history[j-1].close, symbols[i]);
         if(gap >= MinGapSize)
         {
            int dir = (history[j].open > history[j-1].close) ? 1 : -1;
            if(symbols[i] == _Symbol)
            {
               DrawArrow("GapArrow_" + symbols[i] + "_" + TimeToString(history[j].time), 
                        history[j].time, history[j].open, dir, 
                        dir == 1 ? BullishGapColor : BearishGapColor);
            }
         }
      }
   }
}

void CheckCurrentGaps()
{
   for(int i = 0; i < 4; i++)
   {
      if(StringLen(symbols[i]) == 0) continue;
      
      double closes[], opens[];
      CopyClose(symbols[i], Timeframe, 1, 2, closes);
      CopyOpen(symbols[i], Timeframe, 0, 1, opens);
      
      if(ArraySize(closes) < 2 || ArraySize(opens) < 1) continue;
      
      gapSizes[i] = CalculateGapSize(opens[0], closes[1], symbols[i]);
      gapDirections[i] = (opens[0] > closes[1]) ? 1 : -1;
      
      if(gapSizes[i] >= MinGapSize)
      {
         if(!alertsSent[i] && EnableAlerts)
         {
            string dirStr = (gapDirections[i] == 1) ? "Bullish" : "Bearish";
            string unit = (GapUnit == GAP_IN_PIPS) ? "pips" : "points";
            Alert(dirStr, " gap on ", symbols[i], " (", EnumToString(Timeframe), ")! Size: ", 
                  DoubleToString(gapSizes[i], 1), " ", unit);
            alertsSent[i] = true;
         }
         
         if(symbols[i] == _Symbol)
         {
            DrawArrow("GapArrow_" + symbols[i] + "_Current", 
                     iTime(symbols[i], Timeframe, 0), 
                     iOpen(symbols[i], Timeframe, 0), 
                     gapDirections[i], 
                     gapDirections[i] == 1 ? BullishGapColor : BearishGapColor);
         }
      }
      else
      {
         gapDirections[i] = 0;
         gapSizes[i] = 0;
      }
   }
}

void CheckPinBars()
{
   MqlRates rates[];
   if(CopyRates(_Symbol, _Period, 0, PinBarLookback, rates) < PinBarLookback) return;
   
   for(int i = 0; i < PinBarLookback; i++)
   {
      double bodySize = MathAbs(rates[i].close - rates[i].open);
      if(bodySize == 0) continue;
      
      double upperShadow = rates[i].high - MathMax(rates[i].close, rates[i].open);
      double lowerShadow = MathMin(rates[i].close, rates[i].open) - rates[i].low;
      
      // Bullish Pin Bar
      if(lowerShadow/bodySize >= PinBarRatio && upperShadow/bodySize < 1.0)
      {
         string name = "PinBar_Bull_" + TimeToString(rates[i].time);
         DrawArrow(name, rates[i].time, rates[i].low, 1, BullishPinBarColor, 2, ANCHOR_TOP);
      }
      
      // Bearish Pin Bar
      if(upperShadow/bodySize >= PinBarRatio && lowerShadow/bodySize < 1.0)
      {
         string name = "PinBar_Bear_" + TimeToString(rates[i].time);
         DrawArrow(name, rates[i].time, rates[i].high, -1, BearishPinBarColor, 2, ANCHOR_BOTTOM);
      }
   }
}

//+------------------------------------------------------------------+
//| Utility Functions                                                |
//+------------------------------------------------------------------+
string NormalizeSymbol(string symbol)
{
   if(StringLen(symbol) == 0) return "";
   
   StringReplace(symbol, ".", "");
   StringReplace(symbol, "#", "");
   StringReplace(symbol, " ", "");
   StringToUpper(symbol);
   return symbol;
}

double CalculateGapSize(double open, double close, string symbol)
{
   double pointValue = SymbolInfoDouble(symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   
   if(GapUnit == GAP_IN_PIPS)
      return MathAbs(open - close) / (pointValue * ((digits == 3 || digits == 5) ? 10 : 1));
   else
      return MathAbs(open - close) / pointValue;
}

void DrawArrow(string name, datetime time, double price, int direction, color clr, int width=2, ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_ARROW, 0, time, price);
      ObjectSetInteger(0, name, OBJPROP_ARROWCODE, direction == 1 ? 233 : 234);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, -1);  // Lowest priority
   }
}