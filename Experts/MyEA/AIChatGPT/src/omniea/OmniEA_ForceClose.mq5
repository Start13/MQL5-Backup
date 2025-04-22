//+------------------------------------------------------------------+
//|                                          OmniEA_ForceClose.mq5   |
//|        Script per chiusura automatica posizioni in OmniEA       |
//+------------------------------------------------------------------+
#property script_show_inputs
#include <TradeExecutor.mqh>
#include <Trade\Trade.mqh>

input string Language = "it";
input string SymbolFilter = "";

CTrade trade;

void CloseAllPositions(const string symbol_filter)
  {
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      if(PositionGetTicket(i) > 0)
        {
         string symb = PositionGetString(POSITION_SYMBOL);
         if(symbol_filter == "" || symb == symbol_filter)
            trade.PositionClose(symb);
        }
     }
  }

void OnStart()
  {
   g_lang = Language;
   DrawNotification("Chiusura posizioni in corso...", clrOrangeRed);
   CloseAllPositions(SymbolFilter);
  }
