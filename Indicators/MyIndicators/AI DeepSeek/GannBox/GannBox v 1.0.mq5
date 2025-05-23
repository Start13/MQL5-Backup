//+------------------------------------------------------------------+
//|                                                      GannBox.mq5 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.metaquotes.net/"
#property version   "2.00"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

// Input parameters
input color BoxColor = clrDodgerBlue;  // Colore della scatola
input bool  ShowAngles = true;         // Mostra angoli
input bool  ShowPriceLevels = true;    // Mostra livelli di prezzo
input bool  ShowTimeLevels = true;     // Mostra livelli di tempo
input bool  ShowLabels = true;         // Mostra etichette

// Variabili globali
datetime startTime, endTime;
double startPrice, endPrice;
bool drawing = false;
int mouseClicks = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Registra gli eventi del mouse
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 1);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 1);
   
   // Crea il pulsante per avviare il disegno
   ObjectCreate(0, "GannBox_StartButton", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_YDISTANCE, 10);
   ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_XSIZE, 100);
   ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_YSIZE, 20);
   ObjectSetString(0, "GannBox_StartButton", OBJPROP_TEXT, "Disegna Gann Box");
   ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_BGCOLOR, clrRoyalBlue);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Funzione per gestire gli eventi del grafico                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // Click sul pulsante di avvio
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "GannBox_StartButton")
   {
      drawing = true;
      mouseClicks = 0;
      ObjectSetInteger(0, "GannBox_StartButton", OBJPROP_STATE, false);
      Comment("Clicca sul primo angolo della Scatola di Gann");
      return;
   }
   
   // Se non siamo in modalità disegno, esci
   if(!drawing) return;
   
   // Gestione del mouse
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      // Se stiamo disegnando e abbiamo il primo punto, aggiorna il rettangolo temporaneo
      if(mouseClicks == 1)
      {
         datetime time;
         double price;
         int window;
         
         // Ottieni la posizione del mouse
         ChartXYToTimePrice(0, (int)lparam, (int)dparam, window, time, price);
         
         // Aggiorna il rettangolo temporaneo
         UpdateTempRectangle(startTime, startPrice, time, price);
      }
   }
   else if(id == CHARTEVENT_CLICK)
   {
      datetime time;
      double price;
      int window;
      
      // Ottieni la posizione del click
      ChartXYToTimePrice(0, (int)lparam, (int)dparam, window, time, price);
      
      if(mouseClicks == 0)
      {
         // Primo click - punto di partenza
         startTime = time;
         startPrice = price;
         mouseClicks++;
         Comment("Trascina per definire la dimensione della Scatola di Gann e rilascia");
      }
      else if(mouseClicks == 1)
      {
         // Secondo click - punto finale
         endTime = time;
         endPrice = price;
         mouseClicks++;
         drawing = false;
         Comment("");
         
         // Disegna la scatola finale
         DrawGannBox(startTime, startPrice, endTime, endPrice);
         
         // Rimuovi il rettangolo temporaneo
         ObjectDelete(0, "GannBox_Temp");
      }
   }
}

//+------------------------------------------------------------------+
//| Aggiorna il rettangolo temporaneo durante il disegno             |
//+------------------------------------------------------------------+
void UpdateTempRectangle(datetime time1, double price1, datetime time2, double price2)
{
   ObjectCreate(0, "GannBox_Temp", OBJ_RECTANGLE, 0, time1, price1, time2, price2);
   ObjectSetInteger(0, "GannBox_Temp", OBJPROP_COLOR, BoxColor);
   ObjectSetInteger(0, "GannBox_Temp", OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(0, "GannBox_Temp", OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, "GannBox_Temp", OBJPROP_BACK, false);
   ObjectSetInteger(0, "GannBox_Temp", OBJPROP_SELECTABLE, false);
}

//+------------------------------------------------------------------+
//| Disegna la Scatola di Gann completa                              |
//+------------------------------------------------------------------+
void DrawGannBox(datetime time1, double price1, datetime time2, double price2)
{
   // Pulisci gli oggetti precedenti (mantieni il pulsante)
   string name;
   for(int i = ObjectsTotal(0) - 1; i >= 0; i--)
   {
      name = ObjectName(0, i);
      if(StringFind(name, "GannBox_") == 0 && name != "GannBox_StartButton")
         ObjectDelete(0, name);
   }
   
   // Disegna il rettangolo principale
   ObjectCreate(0, "GannBox_Main", OBJ_RECTANGLE, 0, time1, price1, time2, price2);
   ObjectSetInteger(0, "GannBox_Main", OBJPROP_COLOR, BoxColor);
   ObjectSetInteger(0, "GannBox_Main", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, "GannBox_Main", OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, "GannBox_Main", OBJPROP_BACK, true);
   ObjectSetInteger(0, "GannBox_Main", OBJPROP_FILL, true);
   
   // Disegna gli angoli se richiesto
   if(ShowAngles)
   {
      // Linea diagonale
      ObjectCreate(0, "GannBox_Diagonal", OBJ_TREND, 0, time1, price1, time2, price2);
      ObjectSetInteger(0, "GannBox_Diagonal", OBJPROP_COLOR, BoxColor);
      ObjectSetInteger(0, "GannBox_Diagonal", OBJPROP_STYLE, STYLE_DOT);
      ObjectSetInteger(0, "GannBox_Diagonal", OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, "GannBox_Diagonal", OBJPROP_RAY, false);
   }
   
   // Livelli predefiniti di Gann
   double levels[] = {0.125, 0.25, 0.333, 0.5, 0.666, 0.75, 0.875, 1.0};
   
   // Disegna i livelli di prezzo
   if(ShowPriceLevels)
   {
      double priceRange = price2 - price1;
      for(int i = 0; i < ArraySize(levels); i++)
      {
         double levelPrice = price1 + (priceRange * levels[i]);
         name = "GannBox_PriceLevel_" + IntegerToString(i);
         
         // Linea orizzontale
         ObjectCreate(0, name, OBJ_HLINE, 0, 0, levelPrice);
         ObjectSetInteger(0, name, OBJPROP_COLOR, BoxColor);
         ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
         
         // Etichette
         if(ShowLabels)
         {
            string labelName = name + "_Label";
            ObjectCreate(0, labelName, OBJ_TEXT, 0, time1, levelPrice);
            ObjectSetString(0, labelName, OBJPROP_TEXT, DoubleToString(levels[i]*100, 1) + "%");
            ObjectSetInteger(0, labelName, OBJPROP_COLOR, BoxColor);
            ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, ANCHOR_LEFT);
         }
      }
   }
   
   // Disegna i livelli di tempo
   if(ShowTimeLevels)
   {
      long timeRange = time2 - time1;
      for(int i = 0; i < ArraySize(levels); i++)
      {
         datetime levelTime = time1 + (datetime)(timeRange * levels[i]);
         name = "GannBox_TimeLevel_" + IntegerToString(i);
         
         // Linea verticale
         ObjectCreate(0, name, OBJ_VLINE, 0, levelTime, 0);
         ObjectSetInteger(0, name, OBJPROP_COLOR, BoxColor);
         ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
         
         // Etichette
         if(ShowLabels)
         {
            string labelName = name + "_Label";
            ObjectCreate(0, labelName, OBJ_TEXT, 0, levelTime, price1);
            ObjectSetString(0, labelName, OBJPROP_TEXT, DoubleToString(levels[i]*100, 1) + "%");
            ObjectSetInteger(0, labelName, OBJPROP_COLOR, BoxColor);
            ObjectSetInteger(0, labelName, OBJPROP_ANCHOR, ANCHOR_UPPER);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Funzione per deinizializzare l'indicatore                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Non eliminare il pulsante se stiamo ricaricando l'indicatore
   if(reason != REASON_CHARTCHANGE && reason != REASON_PARAMETERS)
      ObjectDelete(0, "GannBox_StartButton");
   
   ObjectsDeleteAll(0, "GannBox_");
   Comment("");
}