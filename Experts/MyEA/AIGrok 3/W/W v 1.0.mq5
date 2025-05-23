#property copyright "xAI"
#property link      "https://www.xai.com"
#property version   "1.00"
#property description "EA che mostra trend line rialziste e ribassiste sui massimi/minimi relativi"

// Input parameters
input int Lookback = 50;    // Periodo di lookback per trovare massimi/minimi
input int FractalSize = 5;  // Numero di barre per identificare un frattale (deve essere dispari)

// Global variables
string eaName = "W";

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   if(FractalSize % 2 == 0)
   {
      Print("FractalSize deve essere un numero dispari!");
      return(INIT_PARAMETERS_INCORRECT);
   }
   ObjectsDeleteAll(0, eaName);
   DrawTrendLines();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, eaName);
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   DrawTrendLines();
}

//+------------------------------------------------------------------+
//| Funzione per disegnare le trend line                               |
//+------------------------------------------------------------------+
void DrawTrendLines()
{
   ObjectsDeleteAll(0, eaName);
   
   // Trova i punti per le trend line rialziste
   datetime time1Up, time2Up;
   double price1Up, price2Up;
   FindUptrendPoints(time1Up, price1Up, time2Up, price2Up);
   
   // Trova i punti per le trend line ribassiste
   datetime time1Down, time2Down;
   double price1Down, price2Down;
   FindDowntrendPoints(time1Down, price1Down, time2Down, price2Down);
   
   // Disegna trend line rialzista (verde)
   if(time1Up != 0 && time2Up != 0)
   {
      ObjectCreate(0, eaName + "_Uptrend", OBJ_TREND, 0, time1Up, price1Up, time2Up, price2Up);
      ObjectSetInteger(0, eaName + "_Uptrend", OBJPROP_COLOR, clrGreen);
      ObjectSetInteger(0, eaName + "_Uptrend", OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, eaName + "_Uptrend", OBJPROP_RAY_RIGHT, true);
   }
   
   // Disegna trend line ribassista (rosso)
   if(time1Down != 0 && time2Down != 0)
   {
      ObjectCreate(0, eaName + "_Downtrend", OBJ_TREND, 0, time1Down, price1Down, time2Down, price2Down);
      ObjectSetInteger(0, eaName + "_Downtrend", OBJPROP_COLOR, clrRed);
      ObjectSetInteger(0, eaName + "_Downtrend", OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, eaName + "_Downtrend", OBJPROP_RAY_RIGHT, true);
   }
}

//+------------------------------------------------------------------+
//| Trova punti per trend rialzista (minimi relativi)                  |
//+------------------------------------------------------------------+
void FindUptrendPoints(datetime &time1, double &price1, datetime &time2, double &price2)
{
   int shift1 = 0, shift2 = 0;
   int halfFractal = FractalSize / 2;
   
   // Trova il primo minimo relativo
   for(int i = Lookback - 1; i >= halfFractal; i--)
   {
      if(IsLocalLow(i))
      {
         shift1 = i;
         time1 = iTime(NULL, 0, i);
         price1 = iLow(NULL, 0, i);
         break;
      }
   }
   
   // Trova il secondo minimo relativo più alto
   for(int i = shift1 - halfFractal; i >= halfFractal; i--)
   {
      if(IsLocalLow(i) && iLow(NULL, 0, i) > price1)
      {
         shift2 = i;
         time2 = iTime(NULL, 0, i);
         price2 = iLow(NULL, 0, i);
         break;
      }
   }
   
   if(shift2 == 0 || price2 <= price1)
   {
      time1 = 0;
      time2 = 0;
   }
}

//+------------------------------------------------------------------+
//| Trova punti per trend ribassista (massimi relativi)                |
//+------------------------------------------------------------------+
void FindDowntrendPoints(datetime &time1, double &price1, datetime &time2, double &price2)
{
   int shift1 = 0, shift2 = 0;
   int halfFractal = FractalSize / 2;
   
   // Trova il primo massimo relativo
   for(int i = Lookback - 1; i >= halfFractal; i--)
   {
      if(IsLocalHigh(i))
      {
         shift1 = i;
         time1 = iTime(NULL, 0, i);
         price1 = iHigh(NULL, 0, i);
         break;
      }
   }
   
   // Trova il secondo massimo relativo più basso
   for(int i = shift1 - halfFractal; i >= halfFractal; i--)
   {
      if(IsLocalHigh(i) && iHigh(NULL, 0, i) < price1)
      {
         shift2 = i;
         time2 = iTime(NULL, 0, i);
         price2 = iHigh(NULL, 0, i);
         break;
      }
   }
   
   if(shift2 == 0 || price2 >= price1)
   {
      time1 = 0;
      time2 = 0;
   }
}

//+------------------------------------------------------------------+
//| Verifica se è un minimo locale                                     |
//+------------------------------------------------------------------+
bool IsLocalLow(int shift)
{
   int halfFractal = FractalSize / 2;
   double center = iLow(NULL, 0, shift);
   
   for(int i = 1; i <= halfFractal; i++)
   {
      if(iLow(NULL, 0, shift - i) <= center || iLow(NULL, 0, shift + i) <= center)
         return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| Verifica se è un massimo locale                                    |
//+------------------------------------------------------------------+
bool IsLocalHigh(int shift)
{
   int halfFractal = FractalSize / 2;
   double center = iHigh(NULL, 0, shift);
   
   for(int i = 1; i <= halfFractal; i++)
   {
      if(iHigh(NULL, 0, shift - i) >= center || iHigh(NULL, 0, shift + i) >= center)
         return false;
   }
   return true;
}
//+------------------------------------------------------------------+