//+------------------------------------------------------------------+
//|                                              Enum_Day_Week.mqh   |
//|                                     BlueTrendTeam Copyright @2025  |
//|                                              Version: v 1.01     |
//|                                        Date: 25 March 2025       |
//+------------------------------------------------------------------+
#ifndef ENUM_DAY_WEEK_MQH
#define ENUM_DAY_WEEK_MQH

// --- Funzione per Verificare se il Trading è Permesso (Rinominata per evitare conflitti) ---
bool trade_session_new()
{
    // --- Controllo del Giorno della Settimana ---
    datetime currentTime = TimeCurrent();
    MqlDateTime timeStruct;
    TimeToStruct(currentTime, timeStruct);
    int currentDayOfWeek = timeStruct.day_of_week; // 0 (Domenica) a 6 (Sabato)

    // Escludi sabato e domenica
    if (currentDayOfWeek == 6 || currentDayOfWeek == 0) // 6 = Sabato, 0 = Domenica
    {
        Print("Trading Blocked: Weekend (Saturday/Sunday)");
        return false;
    }

    // --- Controllo delle Festività ---
    MqlCalendarValue values[];
    datetime startTime = currentTime - 86400; // 1 giorno prima
    datetime endTime = currentTime + 86400;   // 1 giorno dopo
    int valuesTotal = CalendarValueHistory(values, startTime, endTime);

    for (int i = 0; i < valuesTotal; i++)
    {
        MqlCalendarEvent event;
        CalendarEventById(values[i].event_id, event);

        MqlCalendarCountry country;
        CalendarCountryById(event.country_id, country);

        // Controlla se l'evento è una festività e riguarda il simbolo corrente
        if (event.type == CALENDAR_TYPE_HOLIDAY && StringFind(Symbol(), country.currency) >= 0)
        {
            datetime eventTime = values[i].time;
            if (eventTime >= startTime && eventTime <= endTime)
            {
                Print("Trading Blocked: Holiday - ", event.name, " on ", TimeToString(eventTime));
                return false;
            }
        }
    }

    // --- Controllo delle Sessioni di Trading per Simbolo ---
    bool inSession = false;
    uint sessionIndex = 0;
    datetime sessionStart, sessionEnd;

    // Converti l'orario corrente in minuti per il confronto
    int currentMinutes = timeStruct.hour * 60 + timeStruct.min;

    // Itera su tutte le sessioni disponibili per il giorno corrente
    while (SymbolInfoSessionTrade(Symbol(), (ENUM_DAY_OF_WEEK)currentDayOfWeek, sessionIndex, sessionStart, sessionEnd))
    {
        // Converti i tempi di inizio e fine in minuti
        MqlDateTime startStruct, endStruct;
        TimeToStruct(sessionStart, startStruct);
        TimeToStruct(sessionEnd, endStruct);

        int startMinutes = startStruct.hour * 60 + startStruct.min;
        int endMinutes = endStruct.hour * 60 + endStruct.min;

        // Controlla se l'orario corrente è all'interno della sessione
        if (currentMinutes >= startMinutes && currentMinutes <= endMinutes)
        {
            inSession = true;
            break;
        }

        sessionIndex++;
    }

    if (!inSession)
    {
        Print("Trading Blocked: Outside trading session for ", Symbol());
    }

    return inSession;
}

#endif