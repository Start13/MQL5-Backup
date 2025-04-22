//+------------------------------------------------------------------+
//| BTT_NewsFilter.mqh - News filtering for OmniEA                   |
//| Copyright 2025, BlueTrendTeam                                    |
//| https://www.mql5.com                                             |
//+------------------------------------------------------------------+
#property strict

//+------------------------------------------------------------------+
//| News event structure                                             |
//+------------------------------------------------------------------+
struct NewsEvent
{
   string   currency;
   string   title;
   datetime time;
   int      impact; // 0=Low, 1=Medium, 2=High
};

//+------------------------------------------------------------------+
//| CBTT_NewsFilter class                                            |
//+------------------------------------------------------------------+
class CBTT_NewsFilter
{
private:
   NewsEvent m_newsEvents[10];  // Array to store news events
   int       m_eventCount;      // Number of news events
   int       m_blockLevel;      // 0=No block, 1=High impact only, 2=High