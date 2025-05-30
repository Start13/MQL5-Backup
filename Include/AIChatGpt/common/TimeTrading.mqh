//+------------------------------------------------------------------+
//|                    TimeTrading.mqh v1.1                         |
//|   Compatibile con MQL5 - usa TimeToStruct per orario corrente   |
//+------------------------------------------------------------------+

bool IsTimeTradingActive(string from, string to)
{
   int h1, m1, h2, m2;
   StringToTimeComponents(from, h1, m1);
   StringToTimeComponents(to, h2, m2);

   MqlDateTime nowStruct;
   TimeToStruct(TimeCurrent(), nowStruct);

   int currentMinutes = nowStruct.hour * 60 + nowStruct.min;
   int fromMinutes = h1 * 60 + m1;
   int toMinutes = h2 * 60 + m2;

   // Se attraversa la mezzanotte
   if (fromMinutes > toMinutes)
      return (currentMinutes >= fromMinutes || currentMinutes < toMinutes);

   return (currentMinutes >= fromMinutes && currentMinutes < toMinutes);
}

//──────────────────────────────────────────────────────────
void StringToTimeComponents(string s, int &h, int &m)
{
   string parts[];
   StringSplit(s, ':', parts);
   h = (int)StringToInteger(parts[0]);
   m = (int)StringToInteger(parts[1]);
}
