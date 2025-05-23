//+------------------------------------------------------------------+
//|  OptimizerGenerator.mqh - versione lite, senza dipendenze OOP   |
//+------------------------------------------------------------------

class OptimizerGenerator
{
private:
   struct Param
   {
      string name;
      double start;
      double step;
      double stop;
   };

   Param params[];
   int paramCount;

public:
   OptimizerGenerator()
   {
      ArrayResize(params, 0);
      paramCount = 0;
   }

   void Add(string name, double start, double step, double stop)
   {
      Param p;
      p.name = name;
      p.start = start;
      p.step = step;
      p.stop = stop;

      paramCount++;
      ArrayResize(params, paramCount);
      params[paramCount - 1] = p;
   }

   void SaveToFile(string fileName)
   {
      int handle = FileOpen(fileName, FILE_WRITE | FILE_TXT | FILE_ANSI);
      if(handle == INVALID_HANDLE)
      {
         Print("❌ Errore apertura file: ", fileName);
         return;
      }

      for(int i = 0; i < paramCount; i++)
      {
         string line = StringFormat("%s=%g|%g|%g", params[i].name, params[i].start, params[i].step, params[i].stop);
         FileWrite(handle, line);
      }

      FileClose(handle);
   }
};
