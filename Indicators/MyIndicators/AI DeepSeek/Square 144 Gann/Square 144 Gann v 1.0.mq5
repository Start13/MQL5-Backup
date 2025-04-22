//+------------------------------------------------------------------+
//|                                                      Gann144.mq5 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Based on TradingView script"
#property link      "https://www.mql5.com"
#property version   "1.10"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

// Input parameters
input datetime StartDate = D'2022.11.01 01:00';  // Starting Date
input double   MaxPrice  = 69198.0;              // Manual Max Price
input double   MinPrice  = 17595.0;              // Manual Min Price
input bool     AutoPricesAndBar = true;          // Set Upper/Lower Prices and Start Bar Automatically
input bool     UpdateNewBar = true;              // Update at new bar
input int      CandlesPerDivision = 1;           // Candles per division (min 1)
input bool     ShowTopXAxis = false;             // Top X-Axis
input bool     ShowBottomXAxis = true;           // Bottom X-Axis
input bool     ShowLeftYAxis = false;            // Left Y-Axis
input bool     ShowRightYAxis = true;            // Right Y-Axis
input bool     ShowPrices = true;                // Show Prices on the Right Y-Axis
input bool     ShowDivisions = true;             // Show Vertical Divisions
input bool     ShowExtraLines = true;            // Show Extra Lines
input bool     ShowGrid = true;                  // Show Grid
input bool     ShowBackground = true;            // Show Background

// Line Patterns
enum ENUM_PATTERNS {
   PATTERN_NONE,
   PATTERN_ARROW,
   PATTERN_STAR,
   PATTERN_36_72_108,
   PATTERN_ARROW_CROSS,
   PATTERN_CORNERS_CROSS,
   PATTERN_MASTER
};
input ENUM_PATTERNS Patterns = PATTERN_NONE;  // Line Patterns

// Colors
input color    LabelColor = clrGreen;          // Numbers Color
input color    DivisionsColor = clrBlue;       // Vertical Lines Color
input color    GridColor = clrGray;            // Grid Color
input color    TLSColor = C'0,128,0,80';       // Top Left Square Color
input color    TMSColor = C'255,0,0,80';       // Top Middle Square Color
input color    TRSColor = C'0,128,0,80';       // Top Right Square Color
input color    CLSColor = C'0,128,0,80';       // Center Left Square Color
input color    CMSColor = C'255,0,0,80';       // Center Middle Square Color
input color    CRSColor = C'0,128,0,80';       // Center Right Square Color
input color    BLSColor = C'0,128,0,80';       // Bottom Left Square Color
input color    BMSColor = C'255,0,0,80';       // Bottom Middle Square Color
input color    BRSColor = C'0,128,0,80';       // Bottom Right Square Color

// Connection colors for each angle
input color    LineColor6 = clrGreen;          // Connections from corners to 6
input color    LineColor12 = clrGreen;         // Connections from corners to 12
input color    LineColor18 = clrRed;           // Connections from corners to 18
input color    LineColor24 = clrGreen;         // Connections from corners to 24
input color    LineColor30 = clrGreen;         // Connections from corners to 30
input color    LineColor36 = clrRed;           // Connections from corners to 36
input color    LineColor42 = clrGreen;         // Connections from corners to 42
input color    LineColor48 = clrRed;           // Connections from corners to 48
input color    LineColor54 = clrGreen;         // Connections from corners to 54
input color    LineColor60 = clrGreen;         // Connections from corners to 60
input color    LineColor66 = clrGreen;         // Connections from corners to 66
input color    LineColor72 = clrGreen;         // Connections from corners to 72
input color    LineColor78 = clrGreen;         // Connections from corners to 78
input color    LineColor84 = clrGreen;         // Connections from corners to 84
input color    LineColor90 = clrGreen;         // Connections from corners to 90
input color    LineColor96 = clrRed;           // Connections from corners to 96
input color    LineColor102 = clrGreen;        // Connections from corners to 102
input color    LineColor108 = clrRed;          // Connections from corners to 108
input color    LineColor114 = clrGreen;        // Connections from corners to 114
input color    LineColor120 = clrGreen;        // Connections from corners to 120
input color    LineColor126 = clrRed;          // Connections from corners to 126
input color    LineColor132 = clrGreen;        // Connections from corners to 132
input color    LineColor138 = clrGreen;        // Connections from corners to 138
input color    LineColor144 = clrGreen;        // Connections from corners to 144

// Constants
const int Squares = 144;
const color ColorRed = clrRed;
const color ColorWhite = clrWhite;

// Global variables
int DateBarIndex = 0;
int StartBarIndex = 0;
int EndBarIndex = 0;
int MiddleBarIndex = 0;
int OnethirdPriceBar = 0;
int BarDiff = 0;
int BarIndexDiff = 0;
double ATR = 0;
double Highest = 0;
double Lowest = 0;
double LowerPrice = 0;
double UpperPrice = 0;
double MiddlePrice = 0;
double OnethirdPrice = 0;

// Arrays for graphical objects
string BottomXAxisArray[];
string LeftYAxisArray[];
string RightYAxisArray[];
string TopXAxisArray[];
string BLRArray[];
string BLTArray[];
string BRLArray[];
string BRTArray[];
string TLBArray[];
string TLRArray[];
string TRBArray[];
string TRLArray[];
string DivisionsArray[];
string ExtraArray[];
string GridArray[];
string CenterLinesArray[];
string BackSquares[9];

// Arrays for line properties
bool ShowGroup[192]; // 24 groups * 8 lines each
color LineColors[24];
int LineStyles[24]; // STYLE_SOLID=0, STYLE_DASH=1, STYLE_DOT=2
bool ExtendLines[24];

//+------------------------------------------------------------------+
//| Calculate indicator values                                       |
//+------------------------------------------------------------------+
void CalculateValues()
{
   // Calculate ATR
   ATR = iATR(NULL, 0, 5);
   
   // Calculate highest and lowest
   int halfSquares = (int)MathFloor(Squares * CandlesPerDivision / 2);
   Highest = iHigh(NULL, 0, iHighest(NULL, 0, MODE_HIGH, halfSquares + 1, 0));
   Lowest = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, halfSquares + 1, 0));
   
   // Calculate prices
   LowerPrice = AutoPricesAndBar ? Lowest : MinPrice;
   UpperPrice = AutoPricesAndBar ? Highest : MaxPrice;
   MiddlePrice = LowerPrice + (UpperPrice - LowerPrice) / 2;
   OnethirdPrice = (UpperPrice - LowerPrice) / 3;
   
   // Calculate bar indexes
   int visible_bars = (int)ChartGetInteger(0, CHART_VISIBLE_BARS);
   StartBarIndex = AutoPricesAndBar ? visible_bars - (int)MathFloor(Squares * CandlesPerDivision / 2) : DateBarIndex;
   if(StartBarIndex < 0) StartBarIndex = 0;
   
   EndBarIndex = StartBarIndex + Squares * CandlesPerDivision;
   MiddleBarIndex = StartBarIndex + (int)(Squares * CandlesPerDivision / 2);
   OnethirdPriceBar = (int)((EndBarIndex - StartBarIndex) / 3);
   BarDiff = Squares - (int)MathAbs(EndBarIndex - visible_bars);
   BarIndexDiff = BarDiff <= 0 ? 1 : BarDiff;
}

//+------------------------------------------------------------------+
//| Set lines pattern                                                |
//+------------------------------------------------------------------+
void SetPattern()
{
   if(Patterns != PATTERN_NONE)
   {
      // Reset all lines if pattern is not NONE
      ArrayInitialize(ShowGroup, false);
   }
   
   switch(Patterns)
   {
      case PATTERN_ARROW:
         ShowGroup[88] = true; // Top Left to Bottom 72
         ShowGroup[89] = true; // Top Left to Right 72
         ShowGroup[90] = true; // Bottom Left to Top 72
         ShowGroup[91] = true; // Bottom Left to Right 72
         break;
         
      case PATTERN_STAR:
         ShowGroup[88] = true; // Top Left to Bottom 72
         ShowGroup[89] = true; // Top Left to Right 72
         ShowGroup[90] = true; // Bottom Left to Top 72
         ShowGroup[91] = true; // Bottom Left to Right 72
         ShowGroup[92] = true; // Top Right to Bottom 72
         ShowGroup[93] = true; // Top Right to Left 72
         ShowGroup[94] = true; // Bottom Right to Top 72
         ShowGroup[95] = true; // Bottom Right to Left 72
         break;
         
      case PATTERN_36_72_108:
         ShowGroup[40] = true; // Top Left to Bottom 36
         ShowGroup[41] = true; // Top Left to Right 36
         ShowGroup[42] = true; // Bottom Left to Top 36
         ShowGroup[45] = true; // Top Right to Left 36
         ShowGroup[88] = true; // Top Left to Bottom 72
         ShowGroup[89] = true; // Top Left to Right 72
         ShowGroup[90] = true; // Bottom Left to Top 72
         ShowGroup[91] = true; // Bottom Left to Right 72
         ShowGroup[92] = true; // Top Right to Bottom 72
         ShowGroup[93] = true; // Top Right to Left 72
         ShowGroup[94] = true; // Bottom Right to Top 72
         ShowGroup[95] = true; // Bottom Right to Left 72
         ShowGroup[139] = true; // Bottom Left to Right 108
         ShowGroup[140] = true; // Top Right to Bottom 108
         ShowGroup[142] = true; // Bottom Right to Top 108
         ShowGroup[143] = true; // Bottom Right to Left 108
         ShowGroup[184] = true; // Top Left to Corner 144
         ShowGroup[186] = true; // Top Right to Corner 144
         break;
         
      case PATTERN_ARROW_CROSS:
         ShowGroup[88] = true; // Top Left to Bottom 72
         ShowGroup[89] = true; // Top Left to Right 72
         ShowGroup[90] = true; // Bottom Left to Top 72
         ShowGroup[91] = true; // Bottom Left to Right 72
         ShowGroup[184] = true; // Top Left to Corner 144
         ShowGroup[186] = true; // Top Right to Corner 144
         break;
         
      case PATTERN_CORNERS_CROSS:
         ShowGroup[88] = true; // Top Left to Bottom 72
         ShowGroup[89] = true; // Top Left to Right 72
         ShowGroup[90] = true; // Bottom Left to Top 72
         ShowGroup[91] = true; // Bottom Left to Right 72
         ShowGroup[92] = true; // Top Right to Bottom 72
         ShowGroup[93] = true; // Top Right to Left 72
         ShowGroup[94] = true; // Bottom Right to Top 72
         ShowGroup[95] = true; // Bottom Right to Left 72
         ShowGroup[184] = true; // Top Left to Corner 144
         ShowGroup[186] = true; // Top Right to Corner 144
         break;
         
      case PATTERN_MASTER:
         ShowGroup[42] = true; // Bottom Left to Top 36
         ShowGroup[43] = true; // Bottom Left to Right 36
         ShowGroup[88] = true; // Top Left to Bottom 72
         ShowGroup[89] = true; // Top Left to Right 72
         ShowGroup[90] = true; // Bottom Left to Top 72
         ShowGroup[91] = true; // Bottom Left to Right 72
         ShowGroup[138] = true; // Bottom Left to Top 108
         ShowGroup[139] = true; // Bottom Left to Right 108
         ShowGroup[184] = true; // Top Left to Corner 144
         ShowGroup[186] = true; // Top Right to Corner 144
         break;
   }
}

//+------------------------------------------------------------------+
//| Update the box that goes on the edge of the Gann's square        |
//+------------------------------------------------------------------+
void UpdateBox()
{
   datetime time1 = iTime(NULL, 0, StartBarIndex);
   datetime time2 = iTime(NULL, 0, EndBarIndex);
   
   if(!ObjectCreate(0, "GannSquareBox", OBJ_RECTANGLE, 0, time1, UpperPrice, time2, LowerPrice))
   {
      Print("Failed to create rectangle! Error code: ", GetLastError());
      return;
   }
   
   ObjectSetInteger(0, "GannSquareBox", OBJPROP_COLOR, ColorWhite);
   ObjectSetInteger(0, "GannSquareBox", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, "GannSquareBox", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "GannSquareBox", OBJPROP_BACK, true);
}

//+------------------------------------------------------------------+
//| Build the vertical divisions to divide the square in 9 smaller squares
//+------------------------------------------------------------------+
void BuildDivisions()
{
   ArrayResize(DivisionsArray, 4);
   
   // Horizontal lines
   DivisionsArray[0] = "Division_H1";
   if(!ObjectCreate(0, DivisionsArray[0], OBJ_TREND, 0, iTime(NULL, 0, StartBarIndex), LowerPrice + OnethirdPrice, 
                   iTime(NULL, 0, EndBarIndex), LowerPrice + OnethirdPrice))
   {
      Print("Failed to create division line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, DivisionsArray[0], OBJPROP_COLOR, DivisionsColor);
   ObjectSetInteger(0, DivisionsArray[0], OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, DivisionsArray[0], OBJPROP_RAY, false);
   
   DivisionsArray[1] = "Division_H2";
   if(!ObjectCreate(0, DivisionsArray[1], OBJ_TREND, 0, iTime(NULL, 0, StartBarIndex), LowerPrice + OnethirdPrice * 2, 
                   iTime(NULL, 0, EndBarIndex), LowerPrice + OnethirdPrice * 2))
   {
      Print("Failed to create division line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, DivisionsArray[1], OBJPROP_COLOR, DivisionsColor);
   ObjectSetInteger(0, DivisionsArray[1], OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, DivisionsArray[1], OBJPROP_RAY, false);
   
   // Vertical lines
   DivisionsArray[2] = "Division_V1";
   if(!ObjectCreate(0, DivisionsArray[2], OBJ_VLINE, 0, iTime(NULL, 0, StartBarIndex + OnethirdPriceBar), 0))
   {
      Print("Failed to create division line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, DivisionsArray[2], OBJPROP_COLOR, DivisionsColor);
   ObjectSetInteger(0, DivisionsArray[2], OBJPROP_STYLE, STYLE_DASH);
   
   DivisionsArray[3] = "Division_V2";
   if(!ObjectCreate(0, DivisionsArray[3], OBJ_VLINE, 0, iTime(NULL, 0, StartBarIndex + OnethirdPriceBar * 2), 0))
   {
      Print("Failed to create division line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, DivisionsArray[3], OBJPROP_COLOR, DivisionsColor);
   ObjectSetInteger(0, DivisionsArray[3], OBJPROP_STYLE, STYLE_DASH);
}

//+------------------------------------------------------------------+
//| Build both X-Axis and y-Axis labels                              |
//+------------------------------------------------------------------+
void BuildAxis()
{
   ArrayResize(BottomXAxisArray, (int)(Squares / 6) + 1);
   ArrayResize(LeftYAxisArray, (int)(Squares / 6) + 1);
   ArrayResize(RightYAxisArray, (int)(Squares / 6) + 1);
   ArrayResize(TopXAxisArray, (int)(Squares / 6) + 1);
   
   for(int j = 0; j <= Squares; j += 6)
   {
      int index = StartBarIndex + j * CandlesPerDivision;
      datetime time = iTime(NULL, 0, index);
      string name;
      
      if(ShowTopXAxis)
      {
         name = "TopXAxis_" + IntegerToString(j);
         TopXAxisArray[j/6] = name;
         if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, UpperPrice + ATR / 4))
         {
            Print("Failed to create top X axis label! Error code: ", GetLastError());
            continue;
         }
         ObjectSetString(0, name, OBJPROP_TEXT, IntegerToString(j));
         ObjectSetInteger(0, name, OBJPROP_COLOR, LabelColor);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LOWER);
      }
      
      if(ShowBottomXAxis)
      {
         name = "BottomXAxis_" + IntegerToString(j);
         BottomXAxisArray[j/6] = name;
         if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, LowerPrice - ATR / 2))
         {
            Print("Failed to create bottom X axis label! Error code: ", GetLastError());
            continue;
         }
         ObjectSetString(0, name, OBJPROP_TEXT, IntegerToString(j));
         ObjectSetInteger(0, name, OBJPROP_COLOR, LabelColor);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_UPPER);
      }
      
      if(ShowRightYAxis)
      {
         double price = UpperPrice - (UpperPrice - LowerPrice) / Squares * j;
         string text = IntegerToString(j);
         if(ShowPrices)
            text += " (" + DoubleToString(MathRound(price / _Point) * _Point, (int)_Digits) + ")";
         
         name = "RightYAxis_" + IntegerToString(j);
         RightYAxisArray[j/6] = name;
         if(!ObjectCreate(0, name, OBJ_TEXT, 0, iTime(NULL, 0, EndBarIndex + 8 * CandlesPerDivision), price))
         {
            Print("Failed to create right Y axis label! Error code: ", GetLastError());
            continue;
         }
         ObjectSetString(0, name, OBJPROP_TEXT, text);
         ObjectSetInteger(0, name, OBJPROP_COLOR, LabelColor);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT);
      }
      
      if(ShowLeftYAxis)
      {
         name = "LeftYAxis_" + IntegerToString(j);
         LeftYAxisArray[j/6] = name;
         if(!ObjectCreate(0, name, OBJ_TEXT, 0, iTime(NULL, 0, StartBarIndex - 3), 
                         UpperPrice - (UpperPrice - LowerPrice) / Squares * j))
         {
            Print("Failed to create left Y axis label! Error code: ", GetLastError());
            continue;
         }
         ObjectSetString(0, name, OBJPROP_TEXT, IntegerToString(j));
         ObjectSetInteger(0, name, OBJPROP_COLOR, LabelColor);
         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_RIGHT);
      }
   }
}

//+------------------------------------------------------------------+
//| Create the grid lines for reference                              |
//+------------------------------------------------------------------+
void BuildGrid()
{
   ArrayResize(GridArray, 48); // 24 vertical + 24 horizontal
   
   for(int i = 0; i < 24; i++)
   {
      int index = StartBarIndex + 6 * (i + 1) * CandlesPerDivision;
      double price = UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 6 * (i + 1);
      
      // Vertical lines
      GridArray[i * 2] = "Grid_V_" + IntegerToString(i);
      if(!ObjectCreate(0, GridArray[i * 2], OBJ_VLINE, 0, iTime(NULL, 0, index), 0))
      {
         Print("Failed to create vertical grid line! Error code: ", GetLastError());
         continue;
      }
      ObjectSetInteger(0, GridArray[i * 2], OBJPROP_COLOR, GridColor);
      ObjectSetInteger(0, GridArray[i * 2], OBJPROP_STYLE, STYLE_DOT);
      
      // Horizontal lines
      GridArray[i * 2 + 1] = "Grid_H_" + IntegerToString(i);
      if(!ObjectCreate(0, GridArray[i * 2 + 1], OBJ_HLINE, 0, 0, price))
      {
         Print("Failed to create horizontal grid line! Error code: ", GetLastError());
         continue;
      }
      ObjectSetInteger(0, GridArray[i * 2 + 1], OBJPROP_COLOR, GridColor);
      ObjectSetInteger(0, GridArray[i * 2 + 1], OBJPROP_STYLE, STYLE_DOT);
   }
}

//+------------------------------------------------------------------+
//| Update the background of the Gann's square                       |
//+------------------------------------------------------------------+
void UpdateBackgrounds()
{
   datetime s1 = iTime(NULL, 0, StartBarIndex);
   datetime s2 = iTime(NULL, 0, StartBarIndex + (int)((Squares / 3) * CandlesPerDivision));
   datetime s3 = iTime(NULL, 0, StartBarIndex + (int)((Squares / 3) * 2 * CandlesPerDivision));
   datetime s4 = iTime(NULL, 0, EndBarIndex);
   
   double t1 = UpperPrice;
   double t2 = UpperPrice - ((UpperPrice - LowerPrice) / 3);
   double t3 = UpperPrice - ((UpperPrice - LowerPrice) / 3) * 2;
   double t4 = LowerPrice;
   
   // Update all 9 background squares
   for(int i = 0; i < 9; i++)
   {
      string name = "BackSquare" + IntegerToString(i);
      color clr = clrNONE;
      
      if(i == 0) clr = TLSColor;
      else if(i == 1) clr = TMSColor;
      else if(i == 2) clr = TRSColor;
      else if(i == 3) clr = CLSColor;
      else if(i == 4) clr = CMSColor;
      else if(i == 5) clr = CRSColor;
      else if(i == 6) clr = BLSColor;
      else if(i == 7) clr = BMSColor;
      else if(i == 8) clr = BRSColor;
      
      datetime left = s1, right = s2;
      if(i % 3 == 1) { left = s2; right = s3; }
      else if(i % 3 == 2) { left = s3; right = s4; }
      
      double top = t1, bottom = t2;
      if(i >= 3 && i < 6) { top = t2; bottom = t3; }
      else if(i >= 6) { top = t3; bottom = t4; }
      
      if(!ObjectCreate(0, name, OBJ_RECTANGLE, 0, left, top, right, bottom))
      {
         Print("Failed to create background square ", i, "! Error code: ", GetLastError());
         continue;
      }
      
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_BACK, true);
      ObjectSetInteger(0, name, OBJPROP_FILL, true);
   }
}

//+------------------------------------------------------------------+
//| Build center lines (diagonali verdi dal centro dei lati)         |
//+------------------------------------------------------------------+
void BuildCenterLines()
{
   int midTopBar = StartBarIndex + (int)(Squares * CandlesPerDivision / 2);
   int midBottomBar = midTopBar;
   double midLeftPrice = UpperPrice - (UpperPrice - LowerPrice) / 2;
   double midRightPrice = midLeftPrice;
   
   ArrayResize(CenterLinesArray, 4);
   
   // From top center to left center
   string name = "CenterTopToLeft";
   CenterLinesArray[0] = name;
   if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL,0,midTopBar), UpperPrice, 
                   iTime(NULL,0,StartBarIndex), midLeftPrice))
   {
      Print("Failed to create center line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGreen);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   
   // From top center to right center
   name = "CenterTopToRight";
   CenterLinesArray[1] = name;
   if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL,0,midTopBar), UpperPrice, 
                   iTime(NULL,0,EndBarIndex), midRightPrice))
   {
      Print("Failed to create center line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGreen);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   
   // From bottom center to left center
   name = "CenterBottomToLeft";
   CenterLinesArray[2] = name;
   if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL,0,midBottomBar), LowerPrice, 
                   iTime(NULL,0,StartBarIndex), midLeftPrice))
   {
      Print("Failed to create center line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGreen);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   
   // From bottom center to right center
   name = "CenterBottomToRight";
   CenterLinesArray[3] = name;
   if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL,0,midBottomBar), LowerPrice, 
                   iTime(NULL,0,EndBarIndex), midRightPrice))
   {
      Print("Failed to create center line! Error code: ", GetLastError());
   }
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrGreen);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
}

//+------------------------------------------------------------------+
//| Update center lines                                              |
//+------------------------------------------------------------------+
void UpdateCenterLines()
{
   int midTopBar = StartBarIndex + (int)(Squares * CandlesPerDivision / 2);
   int midBottomBar = midTopBar;
   double midLeftPrice = UpperPrice - (UpperPrice - LowerPrice) / 2;
   double midRightPrice = midLeftPrice;
   
   // Update top center to left center
   ObjectMove(0, CenterLinesArray[0], 0, iTime(NULL,0,midTopBar), UpperPrice);
   ObjectMove(0, CenterLinesArray[0], 1, iTime(NULL,0,StartBarIndex), midLeftPrice);
   
   // Update top center to right center
   ObjectMove(0, CenterLinesArray[1], 0, iTime(NULL,0,midTopBar), UpperPrice);
   ObjectMove(0, CenterLinesArray[1], 1, iTime(NULL,0,EndBarIndex), midRightPrice);
   
   // Update bottom center to left center
   ObjectMove(0, CenterLinesArray[2], 0, iTime(NULL,0,midBottomBar), LowerPrice);
   ObjectMove(0, CenterLinesArray[2], 1, iTime(NULL,0,StartBarIndex), midLeftPrice);
   
   // Update bottom center to right center
   ObjectMove(0, CenterLinesArray[3], 0, iTime(NULL,0,midBottomBar), LowerPrice);
   ObjectMove(0, CenterLinesArray[3], 1, iTime(NULL,0,EndBarIndex), midRightPrice);
}

//+------------------------------------------------------------------+
//| Build the Gann's square                                          |
//+------------------------------------------------------------------+
bool BuildSquare()
{
   // Set the pattern based on input
   SetPattern();
   
   // Create the main square box
   UpdateBox();
   
   // Create the lines
   ArrayResize(TLBArray, (int)(Squares / 6) - 1);
   ArrayResize(TLRArray, (int)(Squares / 6) - 1);
   ArrayResize(BLTArray, (int)(Squares / 6) - 1);
   ArrayResize(BLRArray, (int)(Squares / 6) - 1);
   ArrayResize(TRBArray, (int)(Squares / 6) - 1);
   ArrayResize(TRLArray, (int)(Squares / 6) - 1);
   ArrayResize(BRTArray, (int)(Squares / 6) - 1);
   ArrayResize(BRLArray, (int)(Squares / 6) - 1);
   
   for(int i = 0; i < (int)(Squares / 6) - 1; i++)
   {
      int endIndex = StartBarIndex + 6 * (i + 1) * CandlesPerDivision;
      double endPrice = UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 6 * (i + 1);
      string name;
      
      // Top Left Bottom
      if(ShowGroup[i * 8])
      {
         name = "TLB_" + IntegerToString(i);
         TLBArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, StartBarIndex), UpperPrice, 
                         iTime(NULL, 0, endIndex), LowerPrice))
         {
            Print("Failed to create TLB line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Top Left Right
      if(ShowGroup[i * 8 + 1])
      {
         name = "TLR_" + IntegerToString(i);
         TLRArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, StartBarIndex), UpperPrice, 
                         iTime(NULL, 0, EndBarIndex), endPrice))
         {
            Print("Failed to create TLR line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Bottom Left Top
      if(ShowGroup[i * 8 + 2])
      {
         name = "BLT_" + IntegerToString(i);
         BLTArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, StartBarIndex), LowerPrice, 
                         iTime(NULL, 0, endIndex), UpperPrice))
         {
            Print("Failed to create BLT line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Bottom Left Right
      if(ShowGroup[i * 8 + 3])
      {
         name = "BLR_" + IntegerToString(i);
         BLRArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, StartBarIndex), LowerPrice, 
                         iTime(NULL, 0, EndBarIndex), endPrice))
         {
            Print("Failed to create BLR line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Top Right Bottom
      if(ShowGroup[i * 8 + 4])
      {
         name = "TRB_" + IntegerToString(i);
         TRBArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, EndBarIndex), UpperPrice, 
                         iTime(NULL, 0, endIndex), LowerPrice))
         {
            Print("Failed to create TRB line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Top Right Left
      if(ShowGroup[i * 8 + 5])
      {
         name = "TRL_" + IntegerToString(i);
         TRLArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, EndBarIndex), UpperPrice, 
                         iTime(NULL, 0, StartBarIndex), endPrice))
         {
            Print("Failed to create TRL line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Bottom Right Top
      if(ShowGroup[i * 8 + 6])
      {
         name = "BRT_" + IntegerToString(i);
         BRTArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, EndBarIndex), LowerPrice, 
                         iTime(NULL, 0, endIndex), UpperPrice))
         {
            Print("Failed to create BRT line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
      
      // Bottom Right Left
      if(ShowGroup[i * 8 + 7])
      {
         name = "BRL_" + IntegerToString(i);
         BRLArray[i] = name;
         if(!ObjectCreate(0, name, OBJ_TREND, 0, iTime(NULL, 0, EndBarIndex), LowerPrice, 
                         iTime(NULL, 0, StartBarIndex), endPrice))
         {
            Print("Failed to create BRL line! Error code: ", GetLastError());
            continue;
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, LineColors[i]);
         ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyles[i]);
         ObjectSetInteger(0, name, OBJPROP_RAY, ExtendLines[i]);
      }
   }
   
   // Extra lines
   if(ShowExtraLines)
   {
      ArrayResize(ExtraArray, 4);
      
      ExtraArray[0] = "Extra1";
      if(!ObjectCreate(0, ExtraArray[0], OBJ_TREND, 0, iTime(NULL, 0, MiddleBarIndex), UpperPrice, 
                      iTime(NULL, 0, StartBarIndex), UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 36))
      {
         Print("Failed to create extra line! Error code: ", GetLastError());
      }
      ObjectSetInteger(0, ExtraArray[0], OBJPROP_COLOR, ColorRed);
      ObjectSetInteger(0, ExtraArray[0], OBJPROP_STYLE, STYLE_DASH);
      
      ExtraArray[1] = "Extra2";
      if(!ObjectCreate(0, ExtraArray[1], OBJ_TREND, 0, iTime(NULL, 0, MiddleBarIndex), UpperPrice, 
                      iTime(NULL, 0, EndBarIndex), UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 36))
      {
         Print("Failed to create extra line! Error code: ", GetLastError());
      }
      ObjectSetInteger(0, ExtraArray[1], OBJPROP_COLOR, ColorRed);
      ObjectSetInteger(0, ExtraArray[1], OBJPROP_STYLE, STYLE_DASH);
      
      ExtraArray[2] = "Extra3";
      if(!ObjectCreate(0, ExtraArray[2], OBJ_TREND, 0, iTime(NULL, 0, MiddleBarIndex), LowerPrice, 
                      iTime(NULL, 0, StartBarIndex), UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 108))
      {
         Print("Failed to create extra line! Error code: ", GetLastError());
      }
      ObjectSetInteger(0, ExtraArray[2], OBJPROP_COLOR, ColorRed);
      ObjectSetInteger(0, ExtraArray[2], OBJPROP_STYLE, STYLE_DASH);
      
      ExtraArray[3] = "Extra4";
      if(!ObjectCreate(0, ExtraArray[3], OBJ_TREND, 0, iTime(NULL, 0, MiddleBarIndex), LowerPrice, 
                      iTime(NULL, 0, EndBarIndex), UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 108))
      {
         Print("Failed to create extra line! Error code: ", GetLastError());
      }
      ObjectSetInteger(0, ExtraArray[3], OBJPROP_COLOR, ColorRed);
      ObjectSetInteger(0, ExtraArray[3], OBJPROP_STYLE, STYLE_DASH);
      
      // Build center lines
      BuildCenterLines();
   }
   
   // Build other components
   BuildAxis();
   if(ShowDivisions)
      BuildDivisions();
   if(ShowGrid)
      BuildGrid();
   if(ShowBackground)
      UpdateBackgrounds();
   
   return true;
}

//+------------------------------------------------------------------+
//| Update each line created for the Gann's square                   |
//+------------------------------------------------------------------+
void UpdateSquare()
{
   for(int i = 0; i < (int)(Squares / 6) - 1; i++)
   {
      int endIndex = StartBarIndex + 6 * i * CandlesPerDivision;
      double endPrice = UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 6 * i;
      
      // Top Left Bottom
      if(ShowGroup[i * 8] && i < ArraySize(TLBArray))
      {
         ObjectMove(0, TLBArray[i], 0, iTime(NULL, 0, StartBarIndex), UpperPrice);
         ObjectMove(0, TLBArray[i], 1, iTime(NULL, 0, endIndex), LowerPrice);
      }
      
      // Top Left Right
      if(ShowGroup[i * 8 + 1] && i < ArraySize(TLRArray))
      {
         ObjectMove(0, TLRArray[i], 0, iTime(NULL, 0, StartBarIndex), UpperPrice);
         ObjectMove(0, TLRArray[i], 1, iTime(NULL, 0, EndBarIndex), endPrice);
      }
      
      // Bottom Left Top
      if(ShowGroup[i * 8 + 2] && i < ArraySize(BLTArray))
      {
         ObjectMove(0, BLTArray[i], 0, iTime(NULL, 0, StartBarIndex), LowerPrice);
         ObjectMove(0, BLTArray[i], 1, iTime(NULL, 0, endIndex), UpperPrice);
      }
      
      // Bottom Left Right
      if(ShowGroup[i * 8 + 3] && i < ArraySize(BLRArray))
      {
         ObjectMove(0, BLRArray[i], 0, iTime(NULL, 0, StartBarIndex), LowerPrice);
         ObjectMove(0, BLRArray[i], 1, iTime(NULL, 0, EndBarIndex), endPrice);
      }
      
      // Top Right Bottom
      if(ShowGroup[i * 8 + 4] && i < ArraySize(TRBArray))
      {
         ObjectMove(0, TRBArray[i], 0, iTime(NULL, 0, EndBarIndex), UpperPrice);
         ObjectMove(0, TRBArray[i], 1, iTime(NULL, 0, endIndex), LowerPrice);
      }
      
      // Top Right Left
      if(ShowGroup[i * 8 + 5] && i < ArraySize(TRLArray))
      {
         ObjectMove(0, TRLArray[i], 0, iTime(NULL, 0, EndBarIndex), UpperPrice);
         ObjectMove(0, TRLArray[i], 1, iTime(NULL, 0, StartBarIndex), endPrice);
      }
      
      // Bottom Right Top
      if(ShowGroup[i * 8 + 6] && i < ArraySize(BRTArray))
      {
         ObjectMove(0, BRTArray[i], 0, iTime(NULL, 0, EndBarIndex), LowerPrice);
         ObjectMove(0, BRTArray[i], 1, iTime(NULL, 0, endIndex), UpperPrice);
      }
      
      // Bottom Right Left
      if(ShowGroup[i * 8 + 7] && i < ArraySize(BRLArray))
      {
         ObjectMove(0, BRLArray[i], 0, iTime(NULL, 0, EndBarIndex), LowerPrice);
         ObjectMove(0, BRLArray[i], 1, iTime(NULL, 0, StartBarIndex), endPrice);
      }
   }
   
   // Update center lines
   if(ShowExtraLines)
   {
      UpdateCenterLines();
   }
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Initialize arrays
   ArrayInitialize(ShowGroup, false);
   
   // Set line colors according to inputs
   LineColors[0] = LineColor6;
   LineColors[1] = LineColor12;
   LineColors[2] = LineColor18;
   LineColors[3] = LineColor24;
   LineColors[4] = LineColor30;
   LineColors[5] = LineColor36;
   LineColors[6] = LineColor42;
   LineColors[7] = LineColor48;
   LineColors[8] = LineColor54;
   LineColors[9] = LineColor60;
   LineColors[10] = LineColor66;
   LineColors[11] = LineColor72;
   LineColors[12] = LineColor78;
   LineColors[13] = LineColor84;
   LineColors[14] = LineColor90;
   LineColors[15] = LineColor96;
   LineColors[16] = LineColor102;
   LineColors[17] = LineColor108;
   LineColors[18] = LineColor114;
   LineColors[19] = LineColor120;
   LineColors[20] = LineColor126;
   LineColors[21] = LineColor132;
   LineColors[22] = LineColor138;
   LineColors[23] = LineColor144;
   
   // Set line styles (dashed for specific angles)
   ArrayInitialize(LineStyles, STYLE_SOLID);
   LineStyles[2] = STYLE_DASH;  // 18
   LineStyles[5] = STYLE_DASH;  // 36
   LineStyles[7] = STYLE_DASH;  // 48
   LineStyles[15] = STYLE_DASH; // 96
   LineStyles[17] = STYLE_DASH; // 108
   LineStyles[20] = STYLE_DASH; // 126
   
   ArrayInitialize(ExtendLines, false);
   
   // Find the bar index for the start date
   DateBarIndex = iBarShift(NULL, 0, StartDate);
   
   // Calculate initial values
   CalculateValues();
   
   // Build the Gann Square
   if(!BuildSquare())
      return INIT_FAILED;
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
   // Update on new bar if enabled
   if(UpdateNewBar && rates_total > prev_calculated && AutoPricesAndBar)
   {
      // Recalculate values
      CalculateValues();
      
      // Update the square
      UpdateSquare();
      
      // Update axis labels
      for(int j = 0; j <= Squares - 1; j += 6)
      {
         int index = StartBarIndex + j * CandlesPerDivision;
         datetime t = iTime(NULL, 0, index);
         
         if(ShowTopXAxis && j/6 < ArraySize(TopXAxisArray))
         {
            ObjectMove(0, TopXAxisArray[j/6], 0, t, UpperPrice + ATR / 4);
         }
         
         if(ShowBottomXAxis && j/6 < ArraySize(BottomXAxisArray))
         {
            ObjectMove(0, BottomXAxisArray[j/6], 0, t, LowerPrice - ATR / 2);
         }
         
         if(ShowRightYAxis && j/6 < ArraySize(RightYAxisArray))
         {
            double price = UpperPrice - (UpperPrice - LowerPrice) / Squares * j;
            string text = IntegerToString(j);
            if(ShowPrices)
               text += " (" + DoubleToString(MathRound(price / _Point) * _Point, (int)_Digits) + ")";
            
            ObjectMove(0, RightYAxisArray[j/6], 0, iTime(NULL, 0, EndBarIndex + 8 * CandlesPerDivision), price);
            ObjectSetString(0, RightYAxisArray[j/6], OBJPROP_TEXT, text);
         }
         
         if(ShowLeftYAxis && j/6 < ArraySize(LeftYAxisArray))
         {
            ObjectMove(0, LeftYAxisArray[j/6], 0, iTime(NULL, 0, StartBarIndex - 3), 
                      UpperPrice - (UpperPrice - LowerPrice) / Squares * j);
         }
      }
      
      // Update divisions
      if(ShowDivisions && ArraySize(DivisionsArray) >= 4)
      {
         // Horizontal lines
         ObjectMove(0, DivisionsArray[0], 0, iTime(NULL, 0, StartBarIndex), LowerPrice + OnethirdPrice);
         ObjectMove(0, DivisionsArray[0], 1, iTime(NULL, 0, EndBarIndex), LowerPrice + OnethirdPrice);
         
         ObjectMove(0, DivisionsArray[1], 0, iTime(NULL, 0, StartBarIndex), LowerPrice + OnethirdPrice * 2);
         ObjectMove(0, DivisionsArray[1], 1, iTime(NULL, 0, EndBarIndex), LowerPrice + OnethirdPrice * 2);
         
         // Vertical lines
         ObjectMove(0, DivisionsArray[2], 0, iTime(NULL, 0, StartBarIndex + OnethirdPriceBar), 0);
         ObjectMove(0, DivisionsArray[3], 0, iTime(NULL, 0, StartBarIndex + OnethirdPriceBar * 2), 0);
      }
         
      // Update grid
      if(ShowGrid)
      {
         for(int i = 0; i < 24; i++)
         {
            int index = StartBarIndex + 6 * (i + 1) * CandlesPerDivision;
            double price = UpperPrice - ((UpperPrice - LowerPrice) / Squares) * 6 * (i + 1);
            
            if(i * 2 < ArraySize(GridArray))
            {
               ObjectMove(0, GridArray[i * 2], 0, iTime(NULL, 0, index), 0);
            }
            
            if(i * 2 + 1 < ArraySize(GridArray))
            {
               ObjectMove(0, GridArray[i * 2 + 1], 0, 0, price);
            }
         }
      }
   }
   
   return rates_total;
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Delete all graphical objects
   ObjectsDeleteAll(0, -1, -1);
}