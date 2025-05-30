//+------------------------------------------------------------------+
//|                                                PriceTrends.mq5 |
//|                                  Copyright 2024, Corrado Bruni |
//|                                         https://www.cbalgotrade.com |
//+------------------------------------------------------------------+
#property copyright   "Corrado Bruni"
#property link        "https://www.cbalgotrade.com"
#property version     "1.01"
#property strict

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
input color TrendUpColor      = clrLime;
input color TrendDownColor    = C'255,160,122';
input int   TrendWidth        = 1;
input ENUM_TIMEFRAMES Timeframe       = PERIOD_CURRENT;
input int   LookbackBars      = 100;
input int   MinDistance       = 5;
input int   BreakCandles      = 2;
input double SlopeThreshold      = 30.0;
input double RiskPercentage    = 1.0;  // Rischio in percentuale del capitale
input int   StopLossPips      = 100;
input int   TakeProfitPips    = 200;
input int   TrailingStopPips  = 50;   // Trailing stop in pips
input bool  UseVolumeFilter   = true; // Usa filtro volume

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
string TrendUpName       = "TrendUp_";
string TrendDownName     = "TrendDown_";
string SlopeTextName     = "SlopeText_";
double HighBuffer[];
double LowBuffer[];
double CloseBuffer[];
double VolumeBuffer[];
datetime LastBarTime       = 0;

struct Extremum
  {
   datetime time;
   double   price;
   bool     isHigh;
  };
Extremum extrema[];

struct TrendLine
  {
   string   name;
   datetime startTime;
   double   startPrice;
   datetime endTime;
   double   endPrice;
   double   slope;
   double   slopeDeg;
   int      breakCount;
   bool     isUp;
   bool     isValidForOrder;
  };
TrendLine trendLines[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArraySetAsSeries(HighBuffer, true);
   ArraySetAsSeries(LowBuffer, true);
   ArraySetAsSeries(CloseBuffer, true);
   ArraySetAsSeries(VolumeBuffer, true);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   DeleteTrendLines();
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime currentBarTime = iTime(_Symbol, Timeframe, 0);
   if(currentBarTime != LastBarTime)
     {
      UpdatePriceTrends();
      LastBarTime = currentBarTime;
     }
  }

//+------------------------------------------------------------------+
//| Update price trends                                              |
//+------------------------------------------------------------------+
void UpdatePriceTrends()
  {
   int bars = iBars(_Symbol, Timeframe);
   if(bars < LookbackBars)
      return;

   ArrayResize(HighBuffer, LookbackBars);
   ArrayResize(LowBuffer, LookbackBars);
   ArrayResize(CloseBuffer, LookbackBars);
   ArrayResize(VolumeBuffer, LookbackBars);

   if(CopyHigh(_Symbol, Timeframe, 0, LookbackBars, HighBuffer) <= 0 ||
      CopyLow(_Symbol, Timeframe, 0, LookbackBars, LowBuffer) <= 0 ||
      CopyClose(_Symbol, Timeframe, 0, LookbackBars, CloseBuffer) <= 0)
     {
      Print("Error loading data: ", GetLastError());
      return;
     }

   FindExtrema();
   DeleteTrendLines();

   int trendUpCount = 0, trendDownCount = 0;
   ArrayResize(trendLines, ArraySize(extrema));
   int trendLineIndex = 0;

   datetime lastHighTime = 0, lastLowTime = 0;
   double lastHighPrice = 0, lastLowPrice = 0;

   for(int i = 0; i < ArraySize(extrema); i++)
     {
      if(extrema[i].isHigh)
        {
         if(lastHighTime != 0 && extrema[i].price < lastHighPrice)
           {
            string trendName = TrendDownName + IntegerToString(trendDownCount);
            ObjectCreate(0, trendName, OBJ_TREND, 0, lastHighTime, lastHighPrice, extrema[i].time, extrema[i].price);
            ObjectSetInteger(0, trendName, OBJPROP_COLOR, TrendDownColor);
            ObjectSetInteger(0, trendName, OBJPROP_WIDTH, TrendWidth);
            ObjectSetInteger(0, trendName, OBJPROP_RAY_RIGHT, true);

            double deltaPrice = extrema[i].price - lastHighPrice;
            double deltaBars = (double)(extrema[i].time - lastHighTime) / PeriodSeconds(Timeframe);
            double slopeDeg = MathArctan(deltaPrice / deltaBars) * 180 / M_PI;
            bool isValidForOrder = (slopeDeg < -SlopeThreshold);

            string slopeText = SlopeTextName + IntegerToString(trendDownCount);
            ObjectCreate(0, slopeText, OBJ_TEXT, 0, extrema[i].time, extrema[i].price + 10 * _Point);
            ObjectSetString(0, slopeText, OBJPROP_TEXT, StringFormat("Slope: %.2f°", slopeDeg));
            ObjectSetInteger(0, slopeText, OBJPROP_COLOR, TrendDownColor);
            ObjectSetInteger(0, slopeText, OBJPROP_FONTSIZE, 8);

            trendLines[trendLineIndex].name = trendName;
            trendLines[trendLineIndex].startTime = lastHighTime;
            trendLines[trendLineIndex].startPrice = lastHighPrice;
            trendLines[trendLineIndex].endTime = extrema[i].time;
            trendLines[trendLineIndex].endPrice = extrema[i].price;
            trendLines[trendLineIndex].slope = deltaPrice / deltaBars;
            trendLines[trendLineIndex].slopeDeg = slopeDeg;
            trendLines[trendLineIndex].breakCount = 0;
            trendLines[trendLineIndex].isUp = false;
            trendLines[trendLineIndex].isValidForOrder = isValidForOrder;
            trendLineIndex++;
            trendDownCount++;
           }
         lastHighTime = extrema[i].time;
         lastHighPrice = extrema[i].price;
        }
      else
        {
         if(lastLowTime != 0 && extrema[i].price > lastLowPrice)
           {
            string trendName = TrendUpName + IntegerToString(trendUpCount);
            ObjectCreate(0, trendName, OBJ_TREND, 0, lastLowTime, lastLowPrice, extrema[i].time, extrema[i].price);
            ObjectSetInteger(0, trendName, OBJPROP_COLOR, TrendUpColor);
            ObjectSetInteger(0, trendName, OBJPROP_WIDTH, TrendWidth);
            ObjectSetInteger(0, trendName, OBJPROP_RAY_RIGHT, true);

            double deltaPrice = extrema[i].price - lastLowPrice;
            double deltaBars = (double)(extrema[i].time - lastLowTime) / PeriodSeconds(Timeframe);
            double slopeDeg = MathArctan(deltaPrice / deltaBars) * 180 / M_PI;
            bool isValidForOrder = (slopeDeg > SlopeThreshold);

            string slopeText = SlopeTextName + IntegerToString(trendUpCount);
            ObjectCreate(0, slopeText, OBJ_TEXT, 0, extrema[i].time, extrema[i].price - 10 * _Point);
            ObjectSetString(0, slopeText, OBJPROP_TEXT, StringFormat("Slope: %.2f°", slopeDeg));
            ObjectSetInteger(0, slopeText, OBJPROP_COLOR, TrendUpColor);
            ObjectSetInteger(0, slopeText, OBJPROP_FONTSIZE, 8);

            trendLines[trendLineIndex].name = trendName;
            trendLines[trendLineIndex].startTime = lastLowTime;
            trendLines[trendLineIndex].startPrice = lastLowPrice;
            trendLines[trendLineIndex].endTime = extrema[i].time;
            trendLines[trendLineIndex].endPrice = extrema[i].price;
            trendLines[trendLineIndex].slope = deltaPrice / deltaBars;
            trendLines[trendLineIndex].slopeDeg = slopeDeg;
            trendLines[trendLineIndex].breakCount = 0;
            trendLines[trendLineIndex].isUp = true;
            trendLines[trendLineIndex].isValidForOrder = isValidForOrder;
            trendLineIndex++;
            trendUpCount++;
           }
         lastLowTime = extrema[i].time;
         lastLowPrice = extrema[i].price;
        }
     }
   ArrayResize(trendLines, trendLineIndex);
   CheckTrendLineBreaks();
  }

//+------------------------------------------------------------------+
//| Find extrema (relative highs and lows)                           |
//+------------------------------------------------------------------+
void FindExtrema()
  {
   ArrayResize(extrema, LookbackBars);
   int count = 0;

   for(int i = LookbackBars - 1; i >= 0; i--)
     {
      bool isHigh = true, isLow = true;
      for(int j = 1; j <= MinDistance && (i - j >= 0 || i + j < LookbackBars); j++)
        {
         if(i - j >= 0 && HighBuffer[i - j] >= HighBuffer[i])
            isHigh = false;
         if(i + j < LookbackBars && HighBuffer[i + j] >= HighBuffer[i])
            isHigh = false;
         if(i - j >= 0 && LowBuffer[i - j] <= LowBuffer[i])
            isLow = false;
         if(i + j < LookbackBars && LowBuffer[i + j] <= LowBuffer[i])
            isLow = false;
        }

      if(isHigh)
        {
         extrema[count].time = iTime(_Symbol, Timeframe, i);
         extrema[count].price = HighBuffer[i];
         extrema[count].isHigh = true;
         count++;
        }
      else if(isLow)
        {
         extrema[count].time = iTime(_Symbol, Timeframe, i);
         extrema[count].price = LowBuffer[i];
         extrema[count].isHigh = false;
         count++;
        }
     }
   ArrayResize(extrema, count);
  }

//+------------------------------------------------------------------+
//| Check trend line breaks and manage orders                         |
//+------------------------------------------------------------------+
void CheckTrendLineBreaks()
  {
   for(int i = 0; i < ArraySize(trendLines); i++)
     {
      datetime currentTime = iTime(_Symbol, Timeframe, 0);
      int shift = iBarShift(_Symbol, Timeframe, currentTime);
      double currentClose = CloseBuffer[shift];
      double trendValue = CalculateTrendLineValue(trendLines[i], currentTime);

      if(trendLines[i].isUp)
        {
         if(currentClose < trendValue)
           {
            trendLines[i].breakCount++;
            if(trendLines[i].breakCount >= BreakCandles && trendLines[i].isValidForOrder && IsVolumeConfirmingBreak(shift))
              {
               OpenSellOrder();
               ObjectSetInteger(0, trendLines[i].name, OBJPROP_COLOR, clrGray);
              }
           }
         else
           {
            trendLines[i].breakCount = 0;
           }
        }
      else
        {
         if(currentClose > trendValue)
           {
            trendLines[i].breakCount++;
            if(trendLines[i].breakCount >= BreakCandles && trendLines[i].isValidForOrder && IsVolumeConfirmingBreak(shift))
              {
               OpenBuyOrder();
               ObjectSetInteger(0, trendLines[i].name, OBJPROP_COLOR, clrGray);
              }
           }
         else
           {
            trendLines[i].breakCount = 0;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Calculate trend line value at a given time                       |
//+------------------------------------------------------------------+
double CalculateTrendLineValue(TrendLine &trendLine, datetime time)
  {
   double timeDiff = (double)(time - trendLine.startTime) / PeriodSeconds(Timeframe);
   return(trendLine.startPrice + trendLine.slope * timeDiff);
  }

//+------------------------------------------------------------------+
//| Check if volume confirms the break                               |
//+------------------------------------------------------------------+
bool IsVolumeConfirmingBreak(int shift)
  {
   if(!UseVolumeFilter)
      return(true);

   double currentVolume = iVolume(_Symbol, Timeframe, shift); // Corrected: added shift
   double previousVolume = iVolume(_Symbol, Timeframe, shift + 1);
   return(currentVolume > previousVolume * 1.5);
  }

//+------------------------------------------------------------------+
//| Open Buy order                                                   |
//+------------------------------------------------------------------+
void OpenBuyOrder()
  {
   CTrade trade;
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double lotSize = CalculateLotSize(RiskPercentage, StopLossPips);
   double sl = price - StopLossPips * _Point;
   double tp = price + TakeProfitPips * _Point;

   if(trade.Buy(lotSize, _Symbol, price, sl, tp, "Buy from trend line"))
     {
      Print("Buy order opened, ticket: ", trade.ResultOrder());
     }
   else
     {
      Print("Error opening Buy order: ", GetLastError());
     }
  }

//+------------------------------------------------------------------+
//| Open Sell order                                                  |
//+------------------------------------------------------------------+
void OpenSellOrder()
  {
   CTrade trade;
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double lotSize = CalculateLotSize(RiskPercentage, StopLossPips);
   double sl = price + StopLossPips * _Point;
   double tp = price - TakeProfitPips * _Point;

   if(trade.Sell(lotSize, _Symbol, price, sl, tp, "Sell from trend line"))
     {
      Print("Sell order opened, ticket: ", trade.ResultOrder());
     }
   else
     {
      Print("Error opening Sell order: ", GetLastError());
     }
  }

//+------------------------------------------------------------------+
//| Calculate lot size based on risk percentage                      |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskPercentage, double stopLossPips)
  {
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * riskPercentage / 100.0;
   double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   return(NormalizeDouble(riskAmount / (stopLossPips * pipValue),2));
  }

//+------------------------------------------------------------------+
//| Delete all trend lines and texts from the chart                   |
//+------------------------------------------------------------------+
void DeleteTrendLines()
  {
   for(int i = 0; i < 1000; i++)
     {
      ObjectDelete(0, TrendUpName + IntegerToString(i));
      ObjectDelete(0, TrendDownName + IntegerToString(i));
      ObjectDelete(0, SlopeTextName + IntegerToString(i));
     }
  }
//+------------------------------------------------------------------+