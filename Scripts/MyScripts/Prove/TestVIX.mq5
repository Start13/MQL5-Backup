void OnStart() {
   int file_handle = FileOpen("VOLIDXUSD_mt5_bars.csv", FILE_CSV|FILE_READ|FILE_UNICODE, ',');
   if(file_handle == INVALID_HANDLE) {
      Print("Errore apertura file: ", GetLastError());
      return;
   }
   Print("File aperto con successo!");
   for(int i = 0; i < 10 && !FileIsEnding(file_handle); i++) {
      string line = FileReadString(file_handle);
      Print("Riga ", i + 1, ": ", line);
   }
   FileClose(file_handle);
}