//+------------------------------------------------------------------+
//|                                           OmniEA_Tester.mq5     |
//|        Simulatore per test automatici EA OmniEA                 |
//+------------------------------------------------------------------+
#property strict
#include <TradeExecutor.mqh>
#include <Trade\Trade.mqh>

input string Language = "it";
input bool   SimulateBuy  = true;
input bool   SimulateSell = true;
input double TestLots     = 0.10;

CTrade trade;

int OnInit()
  {
   g_lang = Language;
   Print("[TESTER] Inizio simulazione OmniEA");
   return INIT_SUCCEEDED;
  }

void OnTick()
  {
   static bool executed = false;
   if(!executed)
     {
      string symbol = _Symbol;
      double price  = SymbolInfoDouble(symbol, SYMBOL_ASK);

      int stopLevel = (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
      double sl     = price - stopLevel * _Point - 10 * _Point;
      double tp     = price + stopLevel * _Point + 10 * _Point;

      if(SimulateBuy)
         trade.Buy(TestLots, symbol, price, sl, tp);
      if(SimulateSell)
         trade.Sell(TestLots, symbol, price, sl, tp);

      DrawNotification("[TEST] Ordini simulati inviati", clrSkyBlue);
      executed = true;
     }
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
