//+------------------------------------------------------------------+
//|                 BTT_SlotLogic.mqh v1.1                          |
//+------------------------------------------------------------------+

enum ENUM_SLOT_TYPE
{
   SLOT_BUY,
   SLOT_SELL,
   SLOT_FILTER
};

//──────────────────────────────────────────────────────────
// Funzioni "mock" per lettura input simulati
string GetInputString(string key) { return ""; }
int GetInputInt(string key) { return 0; }
double GetInputDouble(string key) { return 0.0; }
bool GetInputBool(string key) { return true; }

//──────────────────────────────────────────────────────────
bool Slot_IsSignalValid(ENUM_SLOT_TYPE slotType, int slotIndex)
{
   string prefix;
   switch (slotType)
   {
      case SLOT_BUY:    prefix = "Buy_" + IntegerToString(slotIndex) + "_"; break;
      case SLOT_SELL:   prefix = "Sell_" + IntegerToString(slotIndex) + "_"; break;
      case SLOT_FILTER: prefix = "Filter_" + IntegerToString(slotIndex) + "_"; break;
   }

   string indName      = GetInputString(prefix + "IndName");
   int bufferIndex     = GetInputInt(prefix + "BufferIndex");
   string condition    = GetInputString(prefix + "Condition");
   double compareValue = GetInputDouble(prefix + "CompareValue");
   bool enabled        = GetInputBool(prefix + "Enabled");

   if (!enabled) return false;

   int handle = iCustom(_Symbol, _Period, indName);
   if (handle == INVALID_HANDLE)
   {
      Print("⚠️ Indicator handle invalido per ", indName);
      return false;
   }

   double bufferData[2];
   if (CopyBuffer(handle, bufferIndex, 0, 2, bufferData) <= 0)
   {
      Print("⚠️ CopyBuffer fallito per ", indName);
      return false;
   }

   double v0 = bufferData[0];
   double v1 = bufferData[1];

   return EvaluateCondition(condition, v0, v1, compareValue);
}

//──────────────────────────────────────────────────────────
bool EvaluateCondition(string cond, double v0, double v1, double threshold)
{
   if (cond == "CROSSOVER")
      return (v1 < threshold && v0 > threshold);

   if (cond == "CROSSUNDER")
      return (v1 > threshold && v0 < threshold);

   if (cond == "GREATER_THAN")
      return (v0 > threshold);

   if (cond == "LESS_THAN")
      return (v0 < threshold);

   if (cond == "OVERBOUGHT")
      return (v0 > 70);

   if (cond == "OVERSOLD")
      return (v0 < 30);

   return false;
}
