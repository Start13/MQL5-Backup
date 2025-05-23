//+------------------------------------------------------------------+
//|                   PresetLoader.mqh v1.1                          |
//|  Lettura semplice di preset da file TXT (chiave=valore)         |
//+------------------------------------------------------------------+
class CPresetLoader
{
public:
   bool Load(string file)
   {
      ResetLastError();
      int handle = FileOpen(file, FILE_READ | FILE_TXT | FILE_ANSI);
      if (handle == INVALID_HANDLE)
      {
         Print("❌ Errore apertura file preset: ", file, " → ", GetLastError());
         return false;
      }

      while (!FileIsEnding(handle))
      {
         string line = FileReadString(handle);
         ParseLine(line);
      }

      FileClose(handle);
      return true;
   }

private:
   void ParseLine(string line)
   {
      int pos = StringFind(line, "=");
      if (pos == -1) return;

      string key = StringSubstr(line, 0, pos);
      string val = StringSubstr(line, pos + 1);

      PrintFormat("🧩 Parametro: %s = %s", key, val);
      // ⛔ In MQL5 non possiamo settare input direttamente
      // Questa parte è di debug o per override manuale
   }
};
