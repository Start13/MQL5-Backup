//+------------------------------------------------------------------+
//| Gestione degli eventi per OmniEA                                 |
//+------------------------------------------------------------------+
#property strict

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if (id == CHARTEVENT_OBJECT_CLICK && sparam == "AddIndicatorButton")
   {
      Print("Indicator Box Clicked");
   }
}