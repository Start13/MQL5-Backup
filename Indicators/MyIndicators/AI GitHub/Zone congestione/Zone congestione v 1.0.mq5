//+------------------------------------------------------------------+
//| Indicatore ZigZag con Zone di Congestione                       |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

// Dichiarazione dei buffer
double ZigZagBuffer[];
double CongestionZoneBuffer[];

// Parametri dell'indicatore
input int Depth = 12;           // Profondità per l'indicatore ZigZag
input double Deviation = 5.0;  // Deviazione percentuale
input int Backstep = 3;        // Numero di barre da considerare per la retrospettiva
input int CongestionThreshold = 5; // Soglia per definire una zona di congestione

//+------------------------------------------------------------------+
//| Funzione di Inizializzazione dell'Indicatore                    |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Impostazione dei buffer
   SetIndexBuffer(0, ZigZagBuffer);
   SetIndexBuffer(1, CongestionZoneBuffer);

   // Impostazione delle etichette degli indicatori
   PlotIndexSetString(0, PLOT_LABEL, "ZigZag");
   PlotIndexSetString(1, PLOT_LABEL, "Zona Congestione");

   // Impostazione degli stili delle linee
   PlotIndexSetInteger(0, PLOT_LINE_STYLE, STYLE_SOLID);
   PlotIndexSetInteger(1, PLOT_LINE_STYLE, STYLE_SOLID);

   // Impostazione dello spessore delle linee
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, 2);
   PlotIndexSetInteger(1, PLOT_LINE_WIDTH, 2);

   // Restituisce il risultato dell'inizializzazione
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Funzione di Calcolo dell'Indicatore                            |
//+------------------------------------------------------------------+
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
   // Verifica se ci sono abbastanza dati
   if(rates_total < Depth)
      return(0);

   // Calcolo del ZigZag
   int start = rates_total - Depth;
   for(int i = start; i >= 0; i--)
     {
      if(i == start || (high[i] > high[i-1] && high[i] > high[i+1])) // Punto di inversione rialzista
        {
         ZigZagBuffer[i] = high[i];
        }
      else if(i == start || (low[i] < low[i-1] && low[i] < low[i+1])) // Punto di inversione ribassista
        {
         ZigZagBuffer[i] = low[i];
        }
      else
        {
         ZigZagBuffer[i] = EMPTY_VALUE;
        }
     }

   // Identificazione delle Zone di Congestione
   for(int i = start; i >= 1; i--)
     {
      // Verifica se la variazione tra le due candele consecutive è inferiore alla soglia
      if(MathAbs(close[i] - close[i-1]) < CongestionThreshold * Point()) // Rileva congestione (movimento laterale)
        {
         CongestionZoneBuffer[i] = close[i]; // Memorizza il valore della zona di congestione
      }
      else
        {
         CongestionZoneBuffer[i] = EMPTY_VALUE; // Se non c'è congestione, non fare nulla
      }

      // Aggiungi un output di diagnostica per il valore di congestione
      Print("Congestione valore: ", CongestionZoneBuffer[i], " a barra ", i);
     }

   // Restituisce il numero di barre calcolate
   return(rates_total);
  }
