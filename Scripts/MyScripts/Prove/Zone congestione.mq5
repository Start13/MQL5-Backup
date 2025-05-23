//+------------------------------------------------------------------+
//|                                               Zone_congestione.mq5|
//|                        Copyright 2025, Kondrad01                 |
//|                                      https://github.com/Kondrad01|
//+------------------------------------------------------------------+
#property strict

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
#property indicator_color3 clrGreen

input int MA_Period = 14; // Periodo Media Mobile
input int ZigZag_Depth = 12; // Profondità del ZigZag
input int Congestion_Bars = 20; // Numero di barre per identificare la congestione

double MA_Buffer[];
double ZigZag_High[];
double ZigZag_Low[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Indicatore Media Mobile
   SetIndexBuffer(0, MA_Buffer, INDICATOR_DATA);
   SetIndexBuffer(1, ZigZag_High, INDICATOR_DATA);
   SetIndexBuffer(2, ZigZag_Low, INDICATOR_DATA);
   IndicatorSetString(INDICATOR_SHORTNAME, "Congestion Zones");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[],
                const double &open[], const double &high[], const double &low[], const double &close[],
                const long &tick_volume[], const long &volume[], const int &spread[])
  {
   if (rates_total < MA_Period)
      return(0);

   // Calcolo Media Mobile
   int ma_handle = iMA(NULL, PERIOD_CURRENT, MA_Period, 0, MODE_SMA, PRICE_CLOSE);
   CopyBuffer(ma_handle, 0, 0, rates_total, MA_Buffer);

   // Calcolo ZigZag
   for (int i = 0; i < rates_total; i++)
     {
      ZigZag_High[i] = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, 5, 3, 0, i);
      ZigZag_Low[i] = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, 5, 3, 1, i);
     }

   // Identificazione delle Zone di Congestione
   for (int i = Congestion_Bars; i < rates_total; i++)
     {
      double max_price = high[i];
      double min_price = low[i];
      bool is_congested = true;

      for (int j = 1; j < Congestion_Bars; j++)
        {
         if (high[i - j] > max_price)
            max_price = high[i - j];
         if (low[i - j] < min_price)
            min_price = low[i - j];

         if ((max_price - min_price) / min_price > 0.01) // 1% di variazione
           {
            is_congested = false;
            break;
           }
        }

      if (is_congested)
        {
         ObjectCreate(0, "CongestionZone" + IntegerToString(i), OBJ_RECTANGLE, 0, time[i], max_price, time[i - Congestion_Bars], min_price);
         ObjectSetInteger(0, "CongestionZone" + IntegerToString(i), OBJPROP_COLOR, clrRed);
        }
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+