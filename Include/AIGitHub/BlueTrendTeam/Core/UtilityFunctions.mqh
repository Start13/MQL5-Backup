//+------------------------------------------------------------------+
//| Funzioni di utilità per OmniEA                                   |
//+------------------------------------------------------------------+
#property strict

double GetSymbolSpread(string symbol)
{
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

   if (ask <= 0 || bid <= 0 || point <= 0)
   {
      Print("Errore: dati del simbolo non validi per ", symbol);
      return -1.0;
   }

   return (ask - bid) / point;
}