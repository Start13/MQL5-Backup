//+------------------------------------------------------------------+
//|                                           BufferLabeling.mqh |
//|        Sistema di etichettatura buffer per OmniEA            |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

//+------------------------------------------------------------------+
//| Ottiene un'etichetta descrittiva per un buffer di indicatore     |
//+------------------------------------------------------------------+
string GetBufferLabel(int index, string indicatorName)
{
   string base = "Buff" + StringFormat("%02d", index);
   string type = DetectBufferType(index, indicatorName);
   
   return base + " [" + type + "]";
}

//+------------------------------------------------------------------+
//| Rileva euristicamente il tipo di buffer in base all'indicatore   |
//+------------------------------------------------------------------+
string DetectBufferType(int index, string name)
{
   string lname = name;
   StringToLower(lname);
   
   // RSI
   if(StringFind(lname, "rsi") != -1)
   {
      if(index == 0) return "Valore RSI";
      if(index == 1) return "Segnale RSI";
   }
   
   // Stocastico
   if(StringFind(lname, "stoch") != -1)
   {
      if(index == 0) return "%K";
      if(index == 1) return "%D";
      if(index == 2) return "Segnale";
   }
   
   // MACD
   if(StringFind(lname, "macd") != -1)
   {
      if(index == 0) return "MACD";
      if(index == 1) return "Segnale";
      if(index == 2) return "Istogramma";
   }
   
   // Bande di Bollinger
   if(StringFind(lname, "bands") != -1 || StringFind(lname, "bollinger") != -1)
   {
      if(index == 0) return "Banda Superiore";
      if(index == 1) return "Banda Media";
      if(index == 2) return "Banda Inferiore";
   }
   
   // Medie Mobili
   if(StringFind(lname, "ma") != -1 || StringFind(lname, "moving") != -1 || StringFind(lname, "average") != -1)
   {
      return "Media Mobile";
   }
   
   // Ichimoku
   if(StringFind(lname, "ichimoku") != -1)
   {
      if(index == 0) return "Tenkan-sen";
      if(index == 1) return "Kijun-sen";
      if(index == 2) return "Senkou Span A";
      if(index == 3) return "Senkou Span B";
      if(index == 4) return "Chikou Span";
   }
   
   // ADX
   if(StringFind(lname, "adx") != -1)
   {
      if(index == 0) return "ADX";
      if(index == 1) return "+DI";
      if(index == 2) return "-DI";
   }
   
   // CCI
   if(StringFind(lname, "cci") != -1)
   {
      return "CCI";
   }
   
   // ATR
   if(StringFind(lname, "atr") != -1)
   {
      return "ATR";
   }
   
   // Momentum
   if(StringFind(lname, "momentum") != -1)
   {
      return "Momentum";
   }
   
   // Alligator
   if(StringFind(lname, "alligator") != -1)
   {
      if(index == 0) return "Jaw (13)";
      if(index == 1) return "Teeth (8)";
      if(index == 2) return "Lips (5)";
   }
   
   // Awesome Oscillator
   if(StringFind(lname, "awesome") != -1 || StringFind(lname, "ao") != -1)
   {
      return "AO";
   }
   
   // Accelerator Oscillator
   if(StringFind(lname, "accelerator") != -1 || StringFind(lname, "ac") != -1)
   {
      return "AC";
   }
   
   // Parabolic SAR
   if(StringFind(lname, "sar") != -1)
   {
      return "SAR";
   }
   
   // DeMarker
   if(StringFind(lname, "demarker") != -1 || StringFind(lname, "demark") != -1)
   {
      return "DeMarker";
   }
   
   // Force Index
   if(StringFind(lname, "force") != -1)
   {
      return "Force Index";
   }
   
   // Bears/Bulls Power
   if(StringFind(lname, "bears") != -1)
   {
      return "Bears Power";
   }
   if(StringFind(lname, "bulls") != -1)
   {
      return "Bulls Power";
   }
   
   // Volumes
   if(StringFind(lname, "volume") != -1 || StringFind(lname, "vol") != -1)
   {
      return "Volume";
   }
   
   // OBV
   if(StringFind(lname, "obv") != -1)
   {
      return "OBV";
   }
   
   // Etichetta generica se non è stato possibile identificare il tipo
   return "Buffer " + IntegerToString(index);
}

//+------------------------------------------------------------------+
//| Ottiene il colore appropriato per un buffer                      |
//+------------------------------------------------------------------+
color GetBufferColor(int index, string indicatorName)
{
   string lname = indicatorName;
   StringToLower(lname);
   
   // Colori predefiniti per i buffer più comuni
   if(StringFind(lname, "macd") != -1)
   {
      if(index == 0) return clrBlue;      // MACD
      if(index == 1) return clrRed;       // Segnale
      if(index == 2) return clrLimeGreen; // Istogramma
   }
   
   if(StringFind(lname, "bands") != -1 || StringFind(lname, "bollinger") != -1)
   {
      if(index == 0) return clrRed;    // Banda Superiore
      if(index == 1) return clrBlue;   // Banda Media
      if(index == 2) return clrRed;    // Banda Inferiore
   }
   
   if(StringFind(lname, "rsi") != -1)
   {
      if(index == 0) return clrBlue;   // Valore RSI
      if(index == 1) return clrRed;    // Segnale RSI
   }
   
   // Colori predefiniti per indice
   color defaultColors[] = {clrBlue, clrRed, clrGreen, clrMagenta, clrYellow, clrCyan, clrOrange, clrPurple};
   int colorIndex = index % ArraySize(defaultColors);
   
   return defaultColors[colorIndex];
}

//+------------------------------------------------------------------+
//| Ottiene una descrizione estesa del buffer                        |
//+------------------------------------------------------------------+
string GetBufferDescription(int index, string indicatorName)
{
   string label = GetBufferLabel(index, indicatorName);
   string description = "Buffer: " + IntegerToString(index) + "\n";
   description += "Etichetta: " + label + "\n";
   
   // Aggiungi informazioni specifiche per indicatore
   string lname = indicatorName;
   StringToLower(lname);
   
   if(StringFind(lname, "rsi") != -1)
   {
      description += "L'RSI misura la forza relativa dei movimenti di prezzo.\n";
      description += "Valori sopra 70 indicano ipercomprato, sotto 30 ipervenduto.";
   }
   else if(StringFind(lname, "macd") != -1)
   {
      description += "Il MACD mostra la relazione tra due medie mobili.\n";
      description += "Segnali: incrocio della linea MACD con la linea di segnale.";
   }
   else if(StringFind(lname, "bands") != -1 || StringFind(lname, "bollinger") != -1)
   {
      description += "Le Bande di Bollinger mostrano la volatilità del prezzo.\n";
      description += "Segnali: prezzo che tocca o supera le bande esterne.";
   }
   else if(StringFind(lname, "stoch") != -1)
   {
      description += "Lo Stocastico confronta il prezzo di chiusura con il range di prezzo.\n";
      description += "Valori sopra 80 indicano ipercomprato, sotto 20 ipervenduto.";
   }
   
   return description;
}

//+------------------------------------------------------------------+
//| Ottiene il valore tipico per confronti                           |
//+------------------------------------------------------------------+
double GetTypicalCompareValue(int index, string indicatorName)
{
   string lname = indicatorName;
   StringToLower(lname);
   
   // RSI
   if(StringFind(lname, "rsi") != -1)
   {
      if(index == 0) return 70.0; // Livello di ipercomprato
   }
   
   // Stocastico
   if(StringFind(lname, "stoch") != -1)
   {
      if(index == 0 || index == 1) return 80.0; // Livello di ipercomprato
   }
   
   // MACD
   if(StringFind(lname, "macd") != -1)
   {
      return 0.0; // Linea zero
   }
   
   // CCI
   if(StringFind(lname, "cci") != -1)
   {
      return 100.0; // Livello di ipercomprato
   }
   
   // Valore predefinito
   return 0.0;
}

//+------------------------------------------------------------------+
//| Ottiene la condizione tipica per un buffer                       |
//+------------------------------------------------------------------+
int GetTypicalCondition(int index, string indicatorName)
{
   string lname = indicatorName;
   StringToLower(lname);
   
   // 0 = CONDITION_GREATER, 1 = CONDITION_LESS, 2 = CONDITION_EQUAL,
   // 3 = CONDITION_CROSS_ABOVE, 4 = CONDITION_CROSS_BELOW, 5 = CONDITION_BETWEEN
   
   // RSI
   if(StringFind(lname, "rsi") != -1)
   {
      if(index == 0) return 0; // Maggiore di (per ipercomprato)
   }
   
   // Stocastico
   if(StringFind(lname, "stoch") != -1)
   {
      if(index == 0 || index == 1) return 0; // Maggiore di (per ipercomprato)
   }
   
   // MACD
   if(StringFind(lname, "macd") != -1)
   {
      if(index == 0) return 3; // Incrocia sopra
      if(index == 1) return 4; // Incrocia sotto
   }
   
   // Medie Mobili
   if(StringFind(lname, "ma") != -1 || StringFind(lname, "moving") != -1 || StringFind(lname, "average") != -1)
   {
      return 3; // Incrocia sopra
   }
   
   // Valore predefinito
   return 0; // Maggiore di
}
