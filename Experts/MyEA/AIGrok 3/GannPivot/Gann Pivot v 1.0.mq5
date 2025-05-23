#property copyright "Grok 3 - xAI"
#property link      "https://xai.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

// Input parameters
input double StartPrice = 1.2000; // Prezzo di partenza per il calcolo
input int LevelsToShow = 8;       // Numero di livelli da visualizzare (sopra e sotto)
input color LineColor = clrGray;  // Colore delle linee
input int LineWidth = 1;          // Spessore delle linee

// Global variables
double GannLevels[];
string ObjectNames[];

//+------------------------------------------------------------------+
int OnInit()
{
   CalculateGannLevels();
   DrawGannLevels();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Rimuovi tutte le linee quando l'EA viene rimosso
   for(int i = 0; i < ArraySize(ObjectNames); i++)
   {
      ObjectDelete(0, ObjectNames[i]);
   }
}

//+------------------------------------------------------------------+
void CalculateGannLevels()
{
   // Ridimensiona l'array per contenere i livelli (sopra e sotto)
   ArrayResize(GannLevels, LevelsToShow * 2 + 1);
   ArrayResize(ObjectNames, LevelsToShow * 2 + 1);
   
   // Il prezzo iniziale è il livello centrale
   GannLevels[LevelsToShow] = StartPrice;
   
   // Calcolo della radice quadrata del prezzo iniziale
   double sqrtPrice = MathSqrt(StartPrice);
   
   // Calcolo dei livelli sopra e sotto usando incrementi Gann
   for(int i = 1; i <= LevelsToShow; i++)
   {
      // Livelli sopra
      double levelUp = MathPow(sqrtPrice + (i * 0.125), 2); // Incremento di 45° (0.125 = 1/8)
      GannLevels[LevelsToShow + i] = NormalizeDouble(levelUp, 5);
      
      // Livelli sotto
      double levelDown = MathPow(sqrtPrice - (i * 0.125), 2);
      GannLevels[LevelsToShow - i] = NormalizeDouble(levelDown > 0 ? levelDown : 0, 5);
   }
}

//+------------------------------------------------------------------+
void DrawGannLevels()
{
   for(int i = 0; i < ArraySize(GannLevels); i++)
   {
      if(GannLevels[i] <= 0) continue; // Salta livelli non validi
      
      string name = "GannLevel_" + DoubleToString(GannLevels[i], 5);
      ObjectNames[i] = name;
      
      // Crea la linea orizzontale tratteggiata
      ObjectCreate(0, name, OBJ_HLINE, 0, 0, GannLevels[i]);
      ObjectSetInteger(0, name, OBJPROP_COLOR, LineColor);
      ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT); // Linea tratteggiata fine
      ObjectSetInteger(0, name, OBJPROP_WIDTH, LineWidth);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
   }
}

//+------------------------------------------------------------------+
void OnTick()
{
   // Opzionale: aggiorna i livelli dinamicamente se necessario
}