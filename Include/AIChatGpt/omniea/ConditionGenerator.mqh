//+------------------------------------------------------------------+
//|            ConditionGenerator.mqh v1.1 (compatibile)            |
//+------------------------------------------------------------------+

enum ENUM_INDICATOR_CLASS
{
   INDCLASS_OSCILLATOR,
   INDCLASS_TREND,
   INDCLASS_VOLATILITY,
   INDCLASS_VOLUME,
   INDCLASS_UNKNOWN
};

//──────────────────────────────────────────────────────────
ENUM_INDICATOR_CLASS DetectIndicatorClass(string name)
{
   string lname = name;
   StringToLower(lname);


   if (StringFind(lname, "rsi") != -1 || StringFind(lname, "stoch") != -1 || StringFind(lname, "cci") != -1)
      return INDCLASS_OSCILLATOR;

   if (StringFind(lname, "ma") != -1 || StringFind(lname, "macd") != -1 || StringFind(lname, "ichimoku") != -1)
      return INDCLASS_TREND;

   if (StringFind(lname, "boll") != -1 || StringFind(lname, "atr") != -1)
      return INDCLASS_VOLATILITY;

   if (StringFind(lname, "volume") != -1 || StringFind(lname, "obv") != -1)
      return INDCLASS_VOLUME;

   return INDCLASS_UNKNOWN;
}

//──────────────────────────────────────────────────────────
// Ritorna array di condizioni suggerite per tipo
void GetValidConditions(string indicator, string &out[])
{
   ENUM_INDICATOR_CLASS type = DetectIndicatorClass(indicator);
   ArrayResize(out, 0);

   if (type == INDCLASS_OSCILLATOR)
   {
      ArrayResize(out, 3);
      out[0] = "OVERBOUGHT";
      out[1] = "OVERSOLD";
      out[2] = "CROSSLEVEL";
   }
   else if (type == INDCLASS_TREND)
   {
      ArrayResize(out, 3);
      out[0] = "CROSSOVER";
      out[1] = "CROSSUNDER";
      out[2] = "SLOPE_UP";
   }
   else if (type == INDCLASS_VOLATILITY)
   {
      ArrayResize(out, 2);
      out[0] = "EXPAND";
      out[1] = "TOUCH_BAND";
   }
   else if (type == INDCLASS_VOLUME)
   {
      ArrayResize(out, 2);
      out[0] = "PEAK";
      out[1] = "VOLUME_RISE";
   }
   else
   {
      ArrayResize(out, 1);
      out[0] = "GREATER_THAN";
   }
}
