//+------------------------------------------------------------------+
//|                                              NewsFilter.mqh |
//|        Filtro notizie per OmniEA                            |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

// Enumerazione per l'impatto delle notizie
enum ENUM_NEWS_IMPACT
{
   IMPACT_LOW,     // Impatto basso
   IMPACT_MEDIUM,  // Impatto medio
   IMPACT_HIGH     // Impatto alto
};

// Classe per gestire il filtro notizie
class CNewsFilter
{
private:
   bool              m_useNewsFilter;    // Usa filtro notizie
   ENUM_NEWS_IMPACT  m_impact;           // Impatto minimo delle notizie da filtrare
   int               m_minutesBefore;    // Minuti prima della notizia
   int               m_minutesAfter;     // Minuti dopo la notizia
   
public:
   // Costruttore
   CNewsFilter()
   {
      m_useNewsFilter = false;
      m_impact = IMPACT_HIGH;
      m_minutesBefore = 15;
      m_minutesAfter = 15;
   }
   
   // Imposta i parametri del filtro notizie
   void SetNewsFilter(bool useFilter, ENUM_NEWS_IMPACT impact, int minutesBefore, int minutesAfter)
   {
      m_useNewsFilter = useFilter;
      m_impact = impact;
      m_minutesBefore = minutesBefore;
      m_minutesAfter = minutesAfter;
   }
   
   // Verifica se il trading è permesso in base alle notizie
   bool IsNewsAllowed()
   {
      if(!m_useNewsFilter) return true;
      
      // Qui implementerai la logica per verificare se ci sono notizie imminenti
      // Per la versione Lite, restituiamo sempre true (nessuna notizia)
      // Nella versione Pro, potrai implementare una vera connessione a un feed di notizie
      
      return true;
   }
   
   // Ottieni la prossima notizia importante
   string GetNextImportantNews()
   {
      if(!m_useNewsFilter) return "Nessuna notizia";
      
      // Qui implementerai la logica per ottenere la prossima notizia importante
      // Per la versione Lite, restituiamo un messaggio generico
      
      return "Nessuna notizia importante imminente";
   }
};
