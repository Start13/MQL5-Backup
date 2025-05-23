#include <Files\File.mqh>

struct IndicatorSlot {
   string name;
   bool is_assigning;
   int countdown;
   bool is_blinking;
   color current_color;
   datetime last_update;
   bool show_name_temp;
   datetime name_display_start;
   int handle;
   int buffer_count;
   string unique_id;
   string initial_indicators[];
};

IndicatorSlot signal_buy_slots[3];
IndicatorSlot signal_sell_slots[3];
IndicatorSlot filter_slots[2];
double risk_percent = 1.0;
int trailing_stop = 0;
int break_even = 0;
string last_removed_indicator = "";
string existing_indicators[];

void InitializeSlots() {
   for (int i = 0; i < 3; i++) {
      signal_buy_slots[i].name = "Add Indicator";
      signal_buy_slots[i].is_assigning = false;
      signal_buy_slots[i].countdown = 0;
      signal_buy_slots[i].is_blinking = false;
      signal_buy_slots[i].current_color = clrLightGray;
      signal_buy_slots[i].last_update = 0;
      signal_buy_slots[i].show_name_temp = false;
      signal_buy_slots[i].name_display_start = 0;
      signal_buy_slots[i].handle = INVALID_HANDLE;
      signal_buy_slots[i].buffer_count = 0;
      signal_buy_slots[i].unique_id = "";
      signal_sell_slots[i] = signal_buy_slots[i];
   }
   for (int i = 0; i < 2; i++) {
      filter_slots[i] = signal_buy_slots[0];
   }
   last_removed_indicator = "";
   DetectExistingIndicators();
   LoadIndicatorSlots();
}

void SaveIndicatorSlots() {
   string config_data = "";
   for (int i = 0; i < 3; i++) {
      config_data += "SignalBuy_Slot_" + IntegerToString(i) + "=" + signal_buy_slots[i].name + "\n";
      config_data += "SignalSell_Slot_" + IntegerToString(i) + "=" + signal_sell_slots[i].name + "\n";
   }
   for (int i = 0; i < 2; i++) {
      config_data += "Filter_Slot_" + IntegerToString(i) + "=" + filter_slots[i].name + "\n";
   }
   config_data += "RiskPercent=" + DoubleToString(risk_percent, 2) + "\n";
   config_data += "TrailingStop=" + IntegerToString(trailing_stop) + "\n";
   config_data += "BreakEven=" + IntegerToString(break_even) + "\n";
   int file_handle = FileOpen("last_config.set", FILE_WRITE | FILE_TXT);
   if (file_handle != INVALID_HANDLE) {
      FileWriteString(file_handle, config_data);
      FileClose(file_handle);
      Print("Configurazione salvata in last_config.set");
   } else {
      Print("Errore salvataggio configurazione: ", GetLastError());
   }
}

void LoadIndicatorSlots() {
   int file_handle = FileOpen("last_config.set", FILE_READ | FILE_TXT);
   if (file_handle != INVALID_HANDLE) {
      string config_data = FileReadString(file_handle, (int)FileSize(file_handle));
      FileClose(file_handle);
      string lines[];
      StringSplit(config_data, '\n', lines);
      for (int i = 0; i < ArraySize(lines); i++) {
         if (lines[i] == "") continue;
         string key_value[];
         StringSplit(lines[i], '=', key_value);
         if (ArraySize(key_value) != 2) continue;
         string key = key_value[0];
         string value = key_value[1];
         if (StringFind(key, "SignalBuy_Slot_") >= 0) {
            int slot = (int)StringSubstr(key, StringLen("SignalBuy_Slot_"));
            signal_buy_slots[slot].name = value;
            signal_buy_slots[slot].current_color = (value == "Add Indicator") ? clrLightGray : clrGreen;
         } else if (StringFind(key, "SignalSell_Slot_") >= 0) {
            int slot = (int)StringSubstr(key, StringLen("SignalSell_Slot_"));
            signal_sell_slots[slot].name = value;
            signal_sell_slots[slot].current_color = (value == "Add Indicator") ? clrLightGray : clrGreen;
         } else if (StringFind(key, "Filter_Slot_") >= 0) {
            int slot = (int)StringSubstr(key, StringLen("Filter_Slot_"));
            filter_slots[slot].name = value;
            filter_slots[slot].current_color = (value == "Add Indicator") ? clrLightGray : clrGreen;
         } else if (key == "RiskPercent") {
            risk_percent = StringToDouble(value);
         } else if (key == "TrailingStop") {
            trailing_stop = (int)StringToInteger(value);
         } else if (key == "BreakEven") {
            break_even = (int)StringToInteger(value);
         }
      }
   }
}

void DetectExistingIndicators() {
   ArrayResize(existing_indicators, 0);
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for (int i = 0; i < windows; i++) {
      int count = ChartIndicatorsTotal(0, i);
      for (int j = 0; j < count; j++) {
         string name = ChartIndicatorName(0, i, j);
         ArrayResize(existing_indicators, ArraySize(existing_indicators) + 1);
         existing_indicators[ArraySize(existing_indicators) - 1] = name;
         Print("Indicatore preesistente rilevato: ", name, " (finestra ", IntegerToString(i), ")");
      }
   }
   Print("Totale indicatori preesistenti rilevati: ", ArraySize(existing_indicators));
}

void RecordInitialIndicatorsForSlot(IndicatorSlot &slot) {
   ArrayResize(slot.initial_indicators, 0);
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for (int i = 0; i < windows; i++) {
      int count = ChartIndicatorsTotal(0, i);
      for (int j = 0; j < count; j++) {
         string name = ChartIndicatorName(0, i, j);
         ArrayResize(slot.initial_indicators, ArraySize(slot.initial_indicators) + 1);
         slot.initial_indicators[ArraySize(slot.initial_indicators) - 1] = name;
      }
   }
}

bool IsNewIndicator(string name, IndicatorSlot &slot) {
   for (int k = 0; k < ArraySize(slot.initial_indicators); k++) {
      if (name == slot.initial_indicators[k]) {
         Print("Indicatore ignorato (preesistente per slot): ", name);
         return false;
      }
   }
   return true;
}

void RemoveIndicatorFromChart(int handle, string name, string section, int slot_index) {
   if (handle != INVALID_HANDLE) {
      bool removed = false;
      int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
      for (int i = 0; i < windows; i++) {
         for (int j = 0; j < ChartIndicatorsTotal(0, i); j++) {
            string ind_name = ChartIndicatorName(0, i, j);
            if (ind_name == name) {
               if (ChartIndicatorDelete(0, i, ind_name)) {
                  removed = true;
                  last_removed_indicator = name;
                  Print("Indicatore rimosso dal grafico: ", name, " (finestra ", IntegerToString(i), ")");
               }
               break;
            }
         }
         if (removed) break;
      }
      if (!removed) {
         Print("Errore: impossibile rimuovere l'indicatore ", name, " dal grafico");
      }
      IndicatorRelease(handle);
      ChartRedraw();

      string obj_name = section + "_Slot_" + IntegerToString(slot_index);
      for (int j = 0; j < 3; j++) {
         ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrOrange);
         Sleep(200);
         ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
         Sleep(200);
      }
   }
}

void CheckForRemovedIndicators() {
   for (int i = 0; i < 3; i++) {
      if (signal_buy_slots[i].handle != INVALID_HANDLE) {
         bool found = false;
         int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
         for (int w = 0; w < windows; w++) {
            for (int j = 0; j < ChartIndicatorsTotal(0, w); j++) {
               string ind_name = ChartIndicatorName(0, w, j);
               if (ind_name == signal_buy_slots[i].name) {
                  found = true;
                  break;
               }
            }
            if (found) break;
         }
         if (!found) {
            MessageBox("Indicatore " + signal_buy_slots[i].name + " rimosso dal grafico!", "Avviso", MB_OK | MB_ICONWARNING);
            RemoveIndicatorFromChart(signal_buy_slots[i].handle, signal_buy_slots[i].name, "SignalBuy", i);
            signal_buy_slots[i].name = "Add Indicator";
            signal_buy_slots[i].current_color = clrLightGray;
            signal_buy_slots[i].handle = INVALID_HANDLE;
            signal_buy_slots[i].buffer_count = 0;
            signal_buy_slots[i].unique_id = "";
            ObjectSetString(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_TEXT, "Add Indicator");
            ObjectSetInteger(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_BGCOLOR, clrLightGray);
            SaveIndicatorSlots();
         }
      }
      if (signal_sell_slots[i].handle != INVALID_HANDLE) {
         bool found = false;
         int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
         for (int w = 0; w < windows; w++) {
            for (int j = 0; j < ChartIndicatorsTotal(0, w); j++) {
               string ind_name = ChartIndicatorName(0, w, j);
               if (ind_name == signal_sell_slots[i].name) {
                  found = true;
                  break;
               }
            }
            if (found) break;
         }
         if (!found) {
            MessageBox("Indicatore " + signal_sell_slots[i].name + " rimosso dal grafico!", "Avviso", MB_OK | MB_ICONWARNING);
            RemoveIndicatorFromChart(signal_sell_slots[i].handle, signal_sell_slots[i].name, "SignalSell", i);
            signal_sell_slots[i].name = "Add Indicator";
            signal_sell_slots[i].current_color = clrLightGray;
            signal_sell_slots[i].handle = INVALID_HANDLE;
            signal_sell_slots[i].buffer_count = 0;
            signal_sell_slots[i].unique_id = "";
            ObjectSetString(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_TEXT, "Add Indicator");
            ObjectSetInteger(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_BGCOLOR, clrLightGray);
            SaveIndicatorSlots();
         }
      }
   }
   for (int i = 0; i < 2; i++) {
      if (filter_slots[i].handle != INVALID_HANDLE) {
         bool found = false;
         int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
         for (int w = 0; w < windows; w++) {
            for (int j = 0; j < ChartIndicatorsTotal(0, w); j++) {
               string ind_name = ChartIndicatorName(0, w, j);
               if (ind_name == filter_slots[i].name) {
                  found = true;
                  break;
               }
            }
            if (found) break;
         }
         if (!found) {
            MessageBox("Indicatore " + filter_slots[i].name + " rimosso dal grafico!", "Avviso", MB_OK | MB_ICONWARNING);
            RemoveIndicatorFromChart(filter_slots[i].handle, filter_slots[i].name, "Filter", i);
            filter_slots[i].name = "Add Indicator";
            filter_slots[i].current_color = clrLightGray;
            filter_slots[i].handle = INVALID_HANDLE;
            filter_slots[i].buffer_count = 0;
            filter_slots[i].unique_id = "";
            ObjectSetString(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_TEXT, "Add Indicator");
            ObjectSetInteger(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_BGCOLOR, clrLightGray);
            SaveIndicatorSlots();
         }
      }
   }
}

void PrintIndicatorBufferValues(string section, int slot_index, IndicatorSlot &slot) {
   if (slot.handle == INVALID_HANDLE || slot.name == "Add Indicator") return;

   string buffer_values = "";
   for (int b = 0; b < slot.buffer_count; b++) {
      double buffer_data[];
      ArraySetAsSeries(buffer_data, true);
      if (CopyBuffer(slot.handle, b, 0, 1, buffer_data) > 0 && buffer_data[0] != EMPTY_VALUE) {
         buffer_values += "Buffer " + IntegerToString(b) + ": " + DoubleToString(buffer_data[0], 6) + "; ";
      } else {
         buffer_values += "Buffer " + IntegerToString(b) + ": Non disponibile; ";
      }
   }
   Print(section, " slot ", IntegerToString(slot_index), ": ", slot.name, "; Valori: ", buffer_values);
}