void OnStart() {
   int handle = FileOpen("XAUUSD_mt5_bars.txt", FILE_CSV|FILE_READ, ',');
   if(handle == INVALID_HANDLE) {
      Print("Errore apertura file: ", GetLastError());
   } else {
      Print("File aperto con successo! Prime 2 righe:");
      for(int i = 0; i < 2 && !FileIsEnding(handle); i++) {
         string date = FileReadString(handle);
         string time = FileReadString(handle);
         double open = StringToDouble(FileReadString(handle));
         double high = StringToDouble(FileReadString(handle));
         double low = StringToDouble(FileReadString(handle));
         double close = StringToDouble(FileReadString(handle));
         string vol = FileReadString(handle);
         string bid_vol = FileReadString(handle);
         string ask_vol = FileReadString(handle);
         Print(date, ",", time, ",", open, ",", high, ",", low, ",", close, ",", vol, ",", bid_vol, ",", ask_vol);
      }
      FileClose(handle);
   }
}