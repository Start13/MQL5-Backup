//+------------------------------------------------------------------+
//|                                           GannSquareInteractive.mq5 |
//|                                          Copyright 2025, Cascade AI |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cascade AI"
#property link      ""
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

#include <Object.mqh>
#include <ChartObjects\ChartObject.mqh>

//--- plot dummy buffer
#property indicator_label1  "Gann Square"
#property indicator_type1   DRAW_NONE
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- input parameters
input int      GannPeriod = 144;       // Periodo di Gann
input color    MainGridColor = clrWhite;    // Colore griglia principale
input color    Level25Color = clrGreen;     // Colore livello 0.25
input color    Level33Color = clrRed;       // Colore livello 0.333
input color    Level50Color = clrYellow;    // Colore livello 0.5
input color    Level66Color = clrRed;       // Colore livello 0.666
input color    Level75Color = clrGreen;     // Colore livello 0.75

//--- global variables
string         PREFIX = "GannSq_";
double         DummyBuffer[];
bool           isDragging = false;
datetime       dragStartTime;
double         dragStartPrice;
datetime       initialTime1, initialTime2;
double         initialPrice1, initialPrice2;
datetime       originalTime1, originalTime2; // Coordinate iniziali per mantenere proporzioni
double         originalPrice1, originalPrice2;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                           |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, DummyBuffer, INDICATOR_CALCULATIONS);
   
   // Abilita gli eventi del mouse e degli oggetti sul grafico
   if(!ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true))
   {
      return(INIT_FAILED);
   }
   if(!ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE, true))
   {
      return(INIT_FAILED);
   }
   if(!ChartSetInteger(0, CHART_EVENT_OBJECT_DELETE, true))
   {
      return(INIT_FAILED);
   }
   
   datetime time1 = TimeCurrent();
   datetime time2 = time1 + PeriodSeconds(Period()) * GannPeriod;
   double price1 = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double price2 = price1 + (price1 * 0.1);
   
   // Memorizza le coordinate iniziali
   originalTime1 = time1;
   originalTime2 = time2;
   originalPrice1 = price1;
   originalPrice2 = price2;
   
   ObjectsDeleteAll(0, PREFIX);
   CreateGannSquare(time1, time2, price1, price2);
   ChartRedraw();
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                                |
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
//| Create Gann Square with control points                             |
//+------------------------------------------------------------------+
void CreateGannSquare(datetime time1, datetime time2, double price1, double price2)
{
   CreateRectangle(PREFIX+"Rect", time1, price1, time2, price2);
   
   // Punti di controllo invisibili agli angoli per ridimensionamento diagonale
   CreateControlPoint(PREFIX+"TL", time1, price2, OBJ_VLINE); // Top-Left
   CreateControlPoint(PREFIX+"TR", time2, price2, OBJ_VLINE); // Top-Right
   CreateControlPoint(PREFIX+"BL", time1, price1, OBJ_VLINE); // Bottom-Left
   CreateControlPoint(PREFIX+"BR", time2, price1, OBJ_VLINE); // Bottom-Right
   
   // Punti di controllo invisibili sulla metà dei lati per ridimensionamento laterale e verticale
   datetime midTime = time1 + (time2 - time1) / 2;
   double midPrice = price1 + (price2 - price1) / 2;
   CreateControlPoint(PREFIX+"Left", time1, midPrice, OBJ_VLINE); // Metà lato sinistro
   CreateControlPoint(PREFIX+"Right", time2, midPrice, OBJ_VLINE); // Metà lato destro
   CreateControlPoint(PREFIX+"Top", midTime, price2, OBJ_HLINE); // Metà lato superiore
   CreateControlPoint(PREFIX+"Bottom", midTime, price1, OBJ_HLINE); // Metà lato inferiore
   
   UpdateInternalLines();
}

//+------------------------------------------------------------------+
//| Update internal lines based on square boundaries                   |
//+------------------------------------------------------------------+
void UpdateInternalLines()
{
   double price1, price2;
   datetime time1, time2;
   if(!GetSquareCoordinates(time1, time2, price1, price2)) return;
   
   // Normalizza i vertici per avere min e max
   datetime minTime = MathMin(time1, time2);
   datetime maxTime = MathMax(time1, time2);
   double minPrice = MathMin(price1, price2);
   double maxPrice = MathMax(price1, price2);
   
   double currentTimeRange = (double)(maxTime - minTime);
   double currentPriceRange = maxPrice - minPrice;
   
   // Livelli per le linee orizzontali e verticali
   double levels[] = {0.25, 0.333, 0.5, 0.666, 0.75};
   color colors[] = {Level25Color, Level33Color, Level50Color, Level66Color, Level75Color};
   
   // Linee orizzontali e verticali
   for(int i=0; i<ArraySize(levels); i++)
   {
      // Linea orizzontale
      double priceLevel = minPrice + currentPriceRange * levels[i];
      CreateLine(PREFIX+"H"+DoubleToString(levels[i],3),
                minTime, priceLevel, maxTime, priceLevel,
                colors[i], STYLE_DOT);
                
      // Linea verticale
      datetime timeLevel = minTime + (datetime)(currentTimeRange * levels[i]);
      CreateLine(PREFIX+"V"+DoubleToString(levels[i],3),
                timeLevel, minPrice, timeLevel, maxPrice,
                colors[i], STYLE_DOT);
   }
   
   // Diagonali principali
   CreateLine(PREFIX+"D1", time1, price1, time2, price2, MainGridColor);
   CreateLine(PREFIX+"D2", time1, price2, time2, price1, MainGridColor);
   
   // Ventagli dai 4 angoli (3 diagonali per ciascuno)
   // Bottom-Left (BL)
   CreateLine(PREFIX+"BL1", minTime, minPrice, maxTime, maxPrice, MainGridColor); // Angolo opposto
   CreateLine(PREFIX+"BL2", minTime, minPrice, maxTime, minPrice + currentPriceRange/2, MainGridColor); // Centro destra
   CreateLine(PREFIX+"BL3", minTime, minPrice, minTime + (datetime)(currentTimeRange/2), maxPrice, MainGridColor); // Centro alto
   
   // Top-Left (TL)
   CreateLine(PREFIX+"TL1", minTime, maxPrice, maxTime, minPrice, MainGridColor); // Angolo opposto
   CreateLine(PREFIX+"TL2", minTime, maxPrice, maxTime, minPrice + currentPriceRange/2, MainGridColor); // Centro destra
   CreateLine(PREFIX+"TL3", minTime, maxPrice, minTime + (datetime)(currentTimeRange/2), minPrice, MainGridColor); // Centro basso
   
   // Bottom-Right (BR)
   CreateLine(PREFIX+"BR1", maxTime, minPrice, minTime, maxPrice, MainGridColor); // Angolo opposto
   CreateLine(PREFIX+"BR2", maxTime, minPrice, minTime, minPrice + currentPriceRange/2, MainGridColor); // Centro sinistra
   CreateLine(PREFIX+"BR3", maxTime, minPrice, maxTime - (datetime)(currentTimeRange/2), maxPrice, MainGridColor); // Centro alto
   
   // Top-Right (TR)
   CreateLine(PREFIX+"TR1", maxTime, maxPrice, minTime, minPrice, MainGridColor); // Angolo opposto
   CreateLine(PREFIX+"TR2", maxTime, maxPrice, minTime, minPrice + currentPriceRange/2, MainGridColor); // Centro sinistra
   CreateLine(PREFIX+"TR3", maxTime, maxPrice, maxTime - (datetime)(currentTimeRange/2), minPrice, MainGridColor); // Centro basso
}

//+------------------------------------------------------------------+
//| Get square coordinates from rectangle object                       |
//+------------------------------------------------------------------+
bool GetSquareCoordinates(datetime &time1, datetime &time2, double &price1, double &price2)
{
   long t1, t2;
   if(!ObjectGetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 0, t1)) return false;
   if(!ObjectGetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 1, t2)) return false;
   time1 = (datetime)t1;
   time2 = (datetime)t2;
   
   if(!ObjectGetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 0, price1)) return false;
   if(!ObjectGetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 1, price2)) return false;
   return true;
}

//+------------------------------------------------------------------+
//| Create rectangle object                                            |
//+------------------------------------------------------------------+
void CreateRectangle(string name, datetime t1, double p1, datetime t2, double p2)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, OBJ_RECTANGLE, 0, t1, p1, t2, p2);
   ObjectSetInteger(0, name, OBJPROP_COLOR, MainGridColor);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_FILL, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
}

//+------------------------------------------------------------------+
//| Create control point                                               |
//+------------------------------------------------------------------+
void CreateControlPoint(string name, datetime time, double price, ENUM_OBJECT type)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, type, 0, time, price);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 0); // Invisibile
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrNONE); // Nessun colore
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
}

//+------------------------------------------------------------------+
//| Create line object                                                 |
//+------------------------------------------------------------------+
void CreateLine(string name, datetime t1, double p1, datetime t2, double p2,
               color clr, ENUM_LINE_STYLE style=STYLE_SOLID)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, OBJ_TREND, 0, t1, p1, t2, p2);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
}

//+------------------------------------------------------------------+
//| Check if click is near the center of the rectangle                 |
//+------------------------------------------------------------------+
bool IsClickNearCenter(int x, int y, datetime &time, double &price)
{
   datetime time1, time2;
   double price1, price2;
   if(!GetSquareCoordinates(time1, time2, price1, price2)) return false;
   
   // Normalizza i vertici per calcolare il centro
   datetime minTime = MathMin(time1, time2);
   datetime maxTime = MathMax(time1, time2);
   double minPrice = MathMin(price1, price2);
   double maxPrice = MathMax(price1, price2);
   
   datetime timeMid = minTime + (maxTime - minTime) / 2;
   double priceMid = minPrice + (maxPrice - minPrice) / 2;
   
   // Converti coordinate del click in tempo e prezzo
   int subwindow;
   time = 0;
   price = 0.0;
   if(!ChartXYToTimePrice(0, x, y, subwindow, time, price))
   {
      return false;
   }
   
   // Definisci un'area di tolleranza attorno al centro (aumentata per maggiore sensibilità)
   datetime timeTolerance = (maxTime - minTime) / 4; // 25% della larghezza
   double priceTolerance = (maxPrice - minPrice) / 4; // 25% dell'altezza
   
   return (MathAbs(time - timeMid) <= timeTolerance && MathAbs(price - priceMid) <= priceTolerance);
}

//+------------------------------------------------------------------+
//| ChartEvent function                                               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   // Trascinamento del quadrato
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      int x = (int)lparam;
      int y = (int)dparam;
      int mouseState = (int)StringToInteger(sparam); // Converti sparam in intero
      
      datetime clickTime = 0;
      double clickPrice = 0.0;
      
      if(mouseState == 1) // Click sinistro premuto
      {
         if(!isDragging && IsClickNearCenter(x, y, clickTime, clickPrice))
         {
            isDragging = true;
            dragStartTime = clickTime;
            dragStartPrice = clickPrice;
            GetSquareCoordinates(initialTime1, initialTime2, initialPrice1, initialPrice2);
         }
         
         if(isDragging)
         {
            int subwindow;
            clickTime = 0;
            clickPrice = 0.0;
            if(ChartXYToTimePrice(0, x, y, subwindow, clickTime, clickPrice))
            {
               datetime timeDelta = clickTime - dragStartTime;
               double priceDelta = clickPrice - dragStartPrice;
               
               // Sposta il quadrato
               ObjectSetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 0, initialTime1 + timeDelta);
               ObjectSetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 1, initialTime2 + timeDelta);
               ObjectSetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 0, initialPrice1 + priceDelta);
               ObjectSetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 1, initialPrice2 + priceDelta);
               
               // Aggiorna i punti di controllo
               ObjectSetInteger(0, PREFIX+"TL", OBJPROP_TIME, initialTime1 + timeDelta);
               ObjectSetDouble(0, PREFIX+"TL", OBJPROP_PRICE, initialPrice2 + priceDelta);
               ObjectSetInteger(0, PREFIX+"TR", OBJPROP_TIME, initialTime2 + timeDelta);
               ObjectSetDouble(0, PREFIX+"TR", OBJPROP_PRICE, initialPrice2 + priceDelta);
               ObjectSetInteger(0, PREFIX+"BL", OBJPROP_TIME, initialTime1 + timeDelta);
               ObjectSetDouble(0, PREFIX+"BL", OBJPROP_PRICE, initialPrice1 + priceDelta);
               ObjectSetInteger(0, PREFIX+"BR", OBJPROP_TIME, initialTime2 + timeDelta);
               ObjectSetDouble(0, PREFIX+"BR", OBJPROP_PRICE, initialPrice1 + priceDelta);
               
               // Aggiorna i punti di controllo sui lati
               datetime midTime = (initialTime1 + timeDelta + initialTime2 + timeDelta) / 2;
               double midPrice = (initialPrice1 + priceDelta + initialPrice2 + priceDelta) / 2;
               ObjectSetInteger(0, PREFIX+"Left", OBJPROP_TIME, initialTime1 + timeDelta);
               ObjectSetDouble(0, PREFIX+"Left", OBJPROP_PRICE, midPrice);
               ObjectSetInteger(0, PREFIX+"Right", OBJPROP_TIME, initialTime2 + timeDelta);
               ObjectSetDouble(0, PREFIX+"Right", OBJPROP_PRICE, midPrice);
               ObjectSetInteger(0, PREFIX+"Top", OBJPROP_TIME, midTime);
               ObjectSetDouble(0, PREFIX+"Top", OBJPROP_PRICE, initialPrice2 + priceDelta);
               ObjectSetInteger(0, PREFIX+"Bottom", OBJPROP_TIME, midTime);
               ObjectSetDouble(0, PREFIX+"Bottom", OBJPROP_PRICE, initialPrice1 + priceDelta);
               
               UpdateInternalLines();
               ChartRedraw();
            }
         }
      }
      else
      {
         isDragging = false;
      }
   }
   
   // Ridimensionamento dagli angoli e dai lati
   if(id == CHARTEVENT_OBJECT_DRAG)
   {
      if(StringFind(sparam, PREFIX) == 0)
      {
         datetime time1, time2;
         double price1, price2;
         GetSquareCoordinates(time1, time2, price1, price2);
         
         datetime newTime = (datetime)ObjectGetInteger(0, sparam, OBJPROP_TIME);
         double newPrice = ObjectGetDouble(0, sparam, OBJPROP_PRICE);
         
         // Calcola il rapporto originale tra larghezza (tempo) e altezza (prezzo)
         double originalTimeRange = (double)(originalTime2 - originalTime1);
         double originalPriceRange = originalPrice2 - originalPrice1;
         double aspectRatio = originalPriceRange / originalTimeRange;
         
         // Ridimensionamento diagonale (dagli angoli)
         if(sparam == PREFIX+"TL")
         {
            time1 = newTime;
            price2 = newPrice;
            // Mantieni il rapporto proporzionale
            double newTimeRange = (double)(time2 - time1);
            double newPriceRange = newTimeRange * aspectRatio;
            price1 = price2 - newPriceRange;
         }
         else if(sparam == PREFIX+"TR")
         {
            time2 = newTime;
            price2 = newPrice;
            // Mantieni il rapporto proporzionale
            double newTimeRange = (double)(time2 - time1);
            double newPriceRange = newTimeRange * aspectRatio;
            price1 = price2 - newPriceRange;
         }
         else if(sparam == PREFIX+"BL")
         {
            time1 = newTime;
            price1 = newPrice;
            // Mantieni il rapporto proporzionale
            double newTimeRange = (double)(time2 - time1);
            double newPriceRange = newTimeRange * aspectRatio;
            price2 = price1 + newPriceRange;
         }
         else if(sparam == PREFIX+"BR")
         {
            time2 = newTime;
            price1 = newPrice;
            // Mantieni il rapporto proporzionale
            double newTimeRange = (double)(time2 - time1);
            double newPriceRange = newTimeRange * aspectRatio;
            price2 = price1 + newPriceRange;
         }
         // Ridimensionamento laterale (lato sinistro o destro)
         else if(sparam == PREFIX+"Left")
         {
            time1 = newTime;
            // Mantieni il rapporto proporzionale
            double newTimeRange = (double)(time2 - time1);
            double newPriceRange = newTimeRange * aspectRatio;
            if(price2 > price1)
               price2 = price1 + newPriceRange;
            else
               price2 = price1 - newPriceRange;
         }
         else if(sparam == PREFIX+"Right")
         {
            time2 = newTime;
            // Mantieni il rapporto proporzionale
            double newTimeRange = (double)(time2 - time1);
            double newPriceRange = newTimeRange * aspectRatio;
            if(price2 > price1)
               price2 = price1 + newPriceRange;
            else
               price2 = price1 - newPriceRange;
         }
         // Ridimensionamento verticale (lato superiore o inferiore)
         else if(sparam == PREFIX+"Top")
         {
            price2 = newPrice;
            // Mantieni il rapporto proporzionale
            double newPriceRange = MathAbs(price2 - price1);
            double newTimeRange = newPriceRange / aspectRatio;
            if(time2 > time1)
               time2 = time1 + (datetime)newTimeRange;
            else
               time2 = time1 - (datetime)newTimeRange;
         }
         else if(sparam == PREFIX+"Bottom")
         {
            price1 = newPrice;
            // Mantieni il rapporto proporzionale
            double newPriceRange = MathAbs(price2 - price1);
            double newTimeRange = newPriceRange / aspectRatio;
            if(time2 > time1)
               time2 = time1 + (datetime)newTimeRange;
            else
               time2 = time1 - (datetime)newTimeRange;
         }
         
         // Aggiorna il rettangolo
         ObjectSetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 0, time1);
         ObjectSetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 1, time2);
         ObjectSetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 0, price1);
         ObjectSetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 1, price2);
         
         // Aggiorna i punti di controllo agli angoli
         ObjectSetInteger(0, PREFIX+"TL", OBJPROP_TIME, time1);
         ObjectSetDouble(0, PREFIX+"TL", OBJPROP_PRICE, price2);
         ObjectSetInteger(0, PREFIX+"TR", OBJPROP_TIME, time2);
         ObjectSetDouble(0, PREFIX+"TR", OBJPROP_PRICE, price2);
         ObjectSetInteger(0, PREFIX+"BL", OBJPROP_TIME, time1);
         ObjectSetDouble(0, PREFIX+"BL", OBJPROP_PRICE, price1);
         ObjectSetInteger(0, PREFIX+"BR", OBJPROP_TIME, time2);
         ObjectSetDouble(0, PREFIX+"BR", OBJPROP_PRICE, price1);
         
         // Aggiorna i punti di controllo sui lati
         datetime midTime = (time1 + time2) / 2;
         double midPrice = (price1 + price2) / 2;
         ObjectSetInteger(0, PREFIX+"Left", OBJPROP_TIME, time1);
         ObjectSetDouble(0, PREFIX+"Left", OBJPROP_PRICE, midPrice);
         ObjectSetInteger(0, PREFIX+"Right", OBJPROP_TIME, time2);
         ObjectSetDouble(0, PREFIX+"Right", OBJPROP_PRICE, midPrice);
         ObjectSetInteger(0, PREFIX+"Top", OBJPROP_TIME, midTime);
         ObjectSetDouble(0, PREFIX+"Top", OBJPROP_PRICE, price2);
         ObjectSetInteger(0, PREFIX+"Bottom", OBJPROP_TIME, midTime);
         ObjectSetDouble(0, PREFIX+"Bottom", OBJPROP_PRICE, price1);
         
         UpdateInternalLines();
         ChartRedraw(); // Aggiorna il grafico in tempo reale durante il ridimensionamento
      }
   }
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, PREFIX);
}