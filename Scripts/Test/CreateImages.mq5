#include <Canvas\Canvas.mqh>
#include <Files\FileBin.mqh>

void OnStart()
{
   CCanvas canvas;

   // Creazione di DropOn.bmp
   if (canvas.Create("DropOn", 16, 16, COLOR_FORMAT_XRGB_NOALPHA))
   {
      canvas.Erase(ARGB(255, 255, 0, 0)); // Riempie con colore rosso
      if (SaveCanvasToFile(canvas, "DropOn.bmp"))
         Print("DropOn.bmp creato con successo.");
      else
         Print("Errore nel salvataggio di DropOn.bmp.");
   }
   else
   {
      Print("Errore nella creazione di DropOn.bmp.");
   }

   // Creazione di DropOff.bmp
   if (canvas.Create("DropOff", 16, 16, COLOR_FORMAT_XRGB_NOALPHA))
   {
      canvas.Erase(ARGB(255, 0, 255, 0)); // Riempie con colore verde
      if (SaveCanvasToFile(canvas, "DropOff.bmp"))
         Print("DropOff.bmp creato con successo.");
      else
         Print("Errore nel salvataggio di DropOff.bmp.");
   }
   else
   {
      Print("Errore nella creazione di DropOff.bmp.");
   }
}

// Funzione per salvare il canvas in un file
bool SaveCanvasToFile(CCanvas &canvas, const string filename)
{
   int width = canvas.Width();
   int height = canvas.Height();
   uint pixels[];

   // Legge i dati del canvas utilizzando ResourceReadImage
   if (!ResourceReadImage(canvas.ResourceName(), pixels, width, height))
   {
      Print("Errore nella lettura dei dati del canvas.");
      return false;
   }

   // Scrive i dati nel file
   int file_handle = FileOpen(filename, FILE_WRITE | FILE_BIN);
   if (file_handle != INVALID_HANDLE)
   {
      FileWriteArray(file_handle, pixels, 0, ArraySize(pixels));
      FileClose(file_handle);
      return true; // Salvataggio riuscito
   }
   else
   {
      Print("Errore nell'apertura del file: ", filename);
      return false; // Errore nell'apertura del file
   }
}