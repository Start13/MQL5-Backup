//+------------------------------------------------------------------+
//|                                                      ZigZag.mqh |
//|                        Copyright 2000-2024, MetaQuotes Ltd.      |
//|                                               https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __ZIGZAG_MQH__
#define __ZIGZAG_MQH__

// Definizione delle proprietà a livello globale
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   1
#property indicator_label1  "ZigZag"
#property indicator_type1   DRAW_SECTION
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

// Parametri di input
input int InpDepth    = 12;  // Depth
input int InpDeviation= 5;   // Deviation
input int InpBackstep = 3;   // Back Step

// Buffer dell'indicatore
double    ZigZagBuffer[];     // buffer principale
double    HighMapBuffer[];    // buffer alti ZigZag
double    LowMapBuffer[];     // buffer bassi ZigZag

// Parametri di calcolo
int       ExtRecalc = 3;     // numero di ultimi estremi da ricalcolare

enum EnSearchMode
{
   Extremum = 0, // cerca il primo estremum
   Peak = 1,     // cerca il prossimo picco ZigZag
   Bottom = -1   // cerca il prossimo fondo ZigZag
};

//+------------------------------------------------------------------+
//| Funzione di inizializzazione dell'indicatore                    |
//+------------------------------------------------------------------+
void OnInit()
{
   // Mappatura dei buffer
   SetIndexBuffer(0, ZigZagBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, HighMapBuffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(2, LowMapBuffer, INDICATOR_CALCULATIONS);

   // Impostazione del nome corto e delle cifre
   string short_name = StringFormat("ZigZag(%d,%d,%d)", InpDepth, InpDeviation, InpBackstep);
   IndicatorSetString(INDICATOR_SHORTNAME, short_name);
   PlotIndexSetString(0, PLOT_LABEL, short_name);
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);

   // Impostare un valore vuoto per l'indicatore
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
}

// Funzione di calcolo del ZigZag
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if (rates_total < 100)
      return (0);

   int i = 0;
   int start = 0, extreme_counter = 0, extreme_search = Extremum;
   int shift = 0, back = 0, last_high_pos = 0, last_low_pos = 0;
   double val = 0, res = 0;
   double curlow = 0, curhigh = 0, last_high = 0, last_low = 0;

   // Inizializzazione
   if (prev_calculated == 0)
   {
      ArrayInitialize(ZigZagBuffer, 0.0);
      ArrayInitialize(HighMapBuffer, 0.0);
      ArrayInitialize(LowMapBuffer, 0.0);
      start = InpDepth;
   }

   // Il ZigZag è già stato calcolato prima
   if (prev_calculated > 0)
   {
      i = rates_total - 1;
      // Cerca il terzo estremum dalla barra incompleta
      while (extreme_counter < ExtRecalc && i > rates_total - 100)
      {
         res = ZigZagBuffer[i];
         if (res != 0.0)
            extreme_counter++;
         i--;
      }
      i++;
      start = i;

      // Tipo di estremum da cercare
      if (LowMapBuffer[i] != 0.0)
      {
         curlow = LowMapBuffer[i];
         extreme_search = Peak;
      }
      else
      {
         curhigh = HighMapBuffer[i];
         extreme_search = Bottom;
      }

      // Azzera i valori dell'indicatore
      for (i = start + 1; i < rates_total && !IsStopped(); i++)
      {
         ZigZagBuffer[i] = 0.0;
         LowMapBuffer[i] = 0.0;
         HighMapBuffer[i] = 0.0;
      }
   }

   // Ricerca degli estremi di alto e basso
   for (shift = start; shift < rates_total && !IsStopped(); shift++)
   {
      // Basso
      val = low[Lowest(low, InpDepth, shift)];
      if (val == last_low)
         val = 0.0;
      else
      {
         last_low = val;
         if ((low[shift] - val) > InpDeviation * _Point)
            val = 0.0;
         else
         {
            for (back = 1; back <= InpBackstep; back++)
            {
               res = LowMapBuffer[shift - back];
               if ((res != 0) && (res > val))
                  LowMapBuffer[shift - back] = 0.0;
            }
         }
      }
      if (low[shift] == val)
         LowMapBuffer[shift] = val;
      else
         LowMapBuffer[shift] = 0.0;

      // Alto
      val = high[Highest(high, InpDepth, shift)];
      if (val == last_high)
         val = 0.0;
      else
      {
         last_high = val;
         if ((val - high[shift]) > InpDeviation * _Point)
            val = 0.0;
         else
         {
            for (back = 1; back <= InpBackstep; back++)
            {
               res = HighMapBuffer[shift - back];
               if ((res != 0) && (res < val))
                  HighMapBuffer[shift - back] = 0.0;
            }
         }
      }
      if (high[shift] == val)
         HighMapBuffer[shift] = val;
      else
         HighMapBuffer[shift] = 0.0;
   }

   // Impostare gli ultimi valori
   if (extreme_search == 0) // valori non definiti
   {
      last_low = 0.0;
      last_high = 0.0;
   }
   else
   {
      last_low = curlow;
      last_high = curhigh;
   }

   // Selezione finale dei punti estremi per il ZigZag
   for (shift = start; shift < rates_total && !IsStopped(); shift++)
   {
      res = 0.0;
      switch (extreme_search)
      {
         case Extremum:
            if (last_low == 0.0 && last_high == 0.0)
            {
               if (HighMapBuffer[shift] != 0)
               {
                  last_high = high[shift];
                  last_high_pos = shift;
                  extreme_search = Bottom;
                  ZigZagBuffer[shift] = last_high;
                  res = 1;
               }
               if (LowMapBuffer[shift] != 0.0)
               {
                  last_low = low[shift];
                  last_low_pos = shift;
                  extreme_search = Peak;
                  ZigZagBuffer[shift] = last_low;
                  res = 1;
               }
            }
            break;
         case Peak:
            if (LowMapBuffer[shift] != 0.0 && LowMapBuffer[shift] < last_low && HighMapBuffer[shift] == 0.0)
            {
               ZigZagBuffer[last_low_pos] = 0.0;
               last_low_pos = shift;
               last_low = LowMapBuffer[shift];
               ZigZagBuffer[shift] = last_low;
               res = 1;
            }
            if (HighMapBuffer[shift] != 0.0 && LowMapBuffer[shift] == 0.0)
            {
               last_high = HighMapBuffer[shift];
               last_high_pos = shift;
               ZigZagBuffer[shift] = last_high;
               extreme_search = Bottom;
               res = 1;
            }
            break;
         case Bottom:
            if (HighMapBuffer[shift] != 0.0 && HighMapBuffer[shift] > last_high && LowMapBuffer[shift] == 0.0)
            {
               ZigZagBuffer[last_high_pos] = 0.0;
               last_high_pos = shift;
               last_high = HighMapBuffer[shift];
               ZigZagBuffer[shift] = last_high;
            }
            if (LowMapBuffer[shift] != 0.0 && HighMapBuffer[shift] == 0.0)
            {
               last_low = LowMapBuffer[shift];
               last_low_pos = shift;
               ZigZagBuffer[shift] = last_low;
               extreme_search = Peak;
            }
            break;
         default:
            return (rates_total);
      }
   }

   return (rates_total);
}

// Funzione per trovare l'indice della barra più alta
int Highest(const double &array[], const int depth, const int start)
{
   if (start < 0)
      return (0);

   double max = array[start];
   int index = start;
   for (int i = start - 1; i > start - depth && i >= 0; i--)
   {
      if (array[i] > max)
      {
         index = i;
         max = array[i];
      }
   }
   return (index);
}

// Funzione per trovare l'indice della barra più bassa
int Lowest(const double &array[], const int depth, const int start)
{
   if (start < 0)
      return (0);

   double min = array[start];
   int index = start;
   for (int i = start - 1; i > start - depth && i >= 0; i--)
   {
      if (array[i] < min)
      {
         index = i;
         min = array[i];
      }
   }
   return (index);
}

#endif
