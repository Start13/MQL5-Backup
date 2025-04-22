//+------------------------------------------------------------------+
//|                                              TimeTrading.mqh |
//|        Filtro orario per OmniEA                             |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

// Classe per gestire il filtro orario
class CTimeTrading
{
private:
   bool              m_useTimeFilter;    // Usa filtro orario
   string            m_startTime;        // Orario di inizio trading
   string            m_endTime;          // Orario di fine trading
   
public:
   // Costruttore
   CTimeTrading()
   {
      m_useTimeFilter = false;
      m_startTime = "00:00";
      m_endTime = "23:59";
   }
   
   // Imposta gli orari di trading
   void SetTradingHours(bool useFilter, string startTime, string endTime)
   {
      m_useTimeFilter = useFilter;
      m_startTime = startTime;
      m_endTime = endTime;
   }
   
   // Verifica se il trading è permesso nell'orario corrente
   bool IsTradingAllowed()
   {
      if(!m_useTimeFilter) return true;
      
      datetime now = TimeCurrent();
      MqlDateTime dt;
      TimeToStruct(now, dt);
      int currentHour = dt.hour;
      int currentMinute = dt.min;
      
      // Converti l'orario corrente in minuti
      int currentTimeInMinutes = currentHour * 60 + currentMinute;
      
      // Converti l'orario di inizio in minuti
      int startHour = (int)StringToInteger(StringSubstr(m_startTime, 0, 2));
      int startMinute = (int)StringToInteger(StringSubstr(m_startTime, 3, 2));
      int startTimeInMinutes = startHour * 60 + startMinute;
      
      // Converti l'orario di fine in minuti
      int endHour = (int)StringToInteger(StringSubstr(m_endTime, 0, 2));
      int endMinute = (int)StringToInteger(StringSubstr(m_endTime, 3, 2));
      int endTimeInMinutes = endHour * 60 + endMinute;
      
      // Verifica se l'orario corrente è nell'intervallo di trading
      if(startTimeInMinutes <= endTimeInMinutes)
      {
         // Intervallo normale (es. 08:00-16:00)
         return (currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes <= endTimeInMinutes);
      }
      else
      {
         // Intervallo che attraversa la mezzanotte (es. 22:00-06:00)
         return (currentTimeInMinutes >= startTimeInMinutes || currentTimeInMinutes <= endTimeInMinutes);
      }
   }
};
