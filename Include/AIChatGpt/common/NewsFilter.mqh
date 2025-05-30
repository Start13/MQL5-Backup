//+------------------------------------------------------------------+
//|                       NewsFilter.mqh                             |
//|   Sospende il trading attorno a eventi macroeconomici           |
//+------------------------------------------------------------------+

// Stub: Sostituibile con API reale in futuro
datetime LastMajorNewsTime()
{
   // → Deve restituire l'orario dell'ultima notizia rilevante
   // In una versione reale si integrerebbe con un indicatore .ex5 o una DLL
   return (datetime)GlobalVariableGet("LAST_MAJOR_NEWS");  // oppure time da buffer custom
}

//──────────────────────────────────────────────────────────
bool IsNewsTime(int pauseBeforeMin, int pauseAfterMin)
{
   datetime now = TimeCurrent();
   datetime newsTime = LastMajorNewsTime();

   if (newsTime == 0) return false;

   datetime pauseStart = newsTime - pauseBeforeMin * 60;
   datetime pauseEnd   = newsTime + pauseAfterMin  * 60;

   return (now >= pauseStart && now <= pauseEnd);
}
