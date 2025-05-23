#ifndef BTT_SETTINGS_MANAGER_MQH
#define BTT_SETTINGS_MANAGER_MQH

#include <Files\File.mqh>

// Funzione per salvare le impostazioni in un file
bool SaveSettingsToFile(string filename, string data) {
   int handle = FileOpen(filename, FILE_WRITE | FILE_TXT);
   if (handle == INVALID_HANDLE) {
      Print("Errore durante il salvataggio di ", filename, ": ", GetLastError());
      return false;
   }
   FileWriteString(handle, data);
   FileClose(handle);
   Print("Configurazione salvata in ", filename);
   return true;
}

// Funzione per caricare le impostazioni da un file
bool LoadSettingsFromFile(string filename, string &data) {
   if (!FileIsExist(filename)) {
      Print("File ", filename, " non trovato, uso valori predefiniti");
      return false;
   }
   int handle = FileOpen(filename, FILE_READ | FILE_TXT);
   if (handle == INVALID_HANDLE) {
      Print("Errore durante il caricamento di ", filename, ": ", GetLastError());
      return false;
   }
   ulong file_size = FileSize(handle); // Usiamo ulong per evitare perdita di dati
   // Controlliamo se il file è troppo grande per essere letto con FileReadString (limite int)
   if (file_size > INT_MAX) {
      Print("Errore: Il file ", filename, " è troppo grande (", file_size, " byte). Limite massimo: ", INT_MAX, " byte.");
      FileClose(handle);
      return false;
   }
   // Convertiamo in int in modo sicuro
   int size_to_read = (int)file_size;
   data = FileReadString(handle, size_to_read);
   FileClose(handle);
   return true;
}

#endif // BTT_SETTINGS_MANAGER_MQH