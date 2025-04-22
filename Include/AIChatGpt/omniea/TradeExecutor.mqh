//+------------------------------------------------------------------+
//|                                                TradeExecutor.mqh |
//|        Gestione ordini per OmniEA - BlueTrendTeam                |
//+------------------------------------------------------------------+
#ifndef __TRADE_EXECUTOR_MQH__
#define __TRADE_EXECUTOR_MQH__

#include <Trade\Trade.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>

#define ORDER_BUY  0
#define ORDER_SELL 1

string g_logfile = "OmniEA_TradeLog.csv";
string g_lang;

string Translate(string key)
  {
   if(g_lang == "it")
     {
      if(key == "TradeOpened") return "Ordine eseguito: ";
      if(key == "TradeFailed") return "Ordine fallito: ";
      if(key == "ClosedPositions") return "Posizioni chiuse: ";
     }
   if(g_lang == "en")
     {
      if(key == "TradeOpened") return "Trade opened: ";
      if(key == "TradeFailed") return "Trade failed: ";
      if(key == "ClosedPositions") return "Closed positions: ";
     }
   return key;
  }

void DrawNotification(string msg, color clr = clrRed)
  {
   string label = "label_notification";
   ObjectCreate(0, label, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, label, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, label, OBJPROP_XDISTANCE, 120);
   ObjectSetInteger(0, label, OBJPROP_YDISTANCE, 20);
   ObjectSetInteger(0, label, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, label, OBJPROP_COLOR, clr);
   ObjectSetString(0, label, OBJPROP_TEXT, msg);
   ObjectSetInteger(0, label, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, label, OBJPROP_SELECTABLE, false);
   EventKillTimer();
   EventSetTimer(5);
  }

void OnTimer()
  {
   ObjectDelete(0, "label_notification");
   EventKillTimer();
  }

//+------------------------------------------------------------------+
//| Example slot logic evaluator                                     |
//+------------------------------------------------------------------+
bool EvaluateSlotCondition(double value, double threshold, string condition)
  {
   if(condition == "above") return (value > threshold);
   if(condition == "below") return (value < threshold);
   if(condition == "equal") return (MathAbs(value - threshold) < _Point);
   return false;
  }

#endif // __TRADE_EXECUTOR_MQH__
