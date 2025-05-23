#include <Files\File.mqh> // Necessario per Save/Load

struct IndicatorSlot {
   string name;
   bool is_assigning;
   int countdown;
   bool is_blinking;
   color current_color;
   long last_update;
   bool show_name_temp;
   long name_display_start;
   int handle;
   int buffer_count;
};

IndicatorSlot signal_buy_slots[3];
IndicatorSlot signal_sell_slots[3];
IndicatorSlot filter_slots[2];
double risk_percent = 1.0; // Default: 1%
int trailing_stop = 0;     // Default: 0 (disattivato)
int break_even = 0;        // Default: 0 (disattivato)

bool show_assignment_alert = true;
long last_tick = 0;
color blink_colors[] = {clrLightGray, clrYellow, clrWhite, clrYellow, clrLightGray};
int active_section = -1; // 0: SignalBuy, 1: SignalSell, 2: Filter
int active_slot = -1;
string last_removed_indicator = ""; // Per tracciare l'ultimo indicatore rimosso
string existing_indicators[]; // Per tracciare gli indicatori preesistenti all'avvio

// Funzioni di supporto per il layout
void CreateLabel(string name, int x, int y, string text, color text_color = clrWhite, int font_size = 8) {
   ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, text_color);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
}

void CreateEdit(string name, int x, int y, int width, int height, string text, color bg_color = clrLightGray) {
   ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
}

void CreateButton(string name, int x, int y, int width, int height, string text, color bg_color = clrLightGray, int font_size = 8) {
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
}

void CreateRectangle(string name, int x, int y, int width, int height, color border_color, int border_width) {
   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clrDarkGray);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, border_width);
}

// Funzione per rilevare gli indicatori preesistenti sul grafico
void DetectExistingIndicators() {
   ArrayResize(existing_indicators, 0);
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for (int i = 0; i < windows; i++) {
      int count = ChartIndicatorsTotal(0, i);
      for (int j = 0; j < count; j++) {
         string name = ChartIndicatorName(0, i, j);
         ArrayResize(existing_indicators, ArraySize(existing_indicators) + 1);
         existing_indicators[ArraySize(existing_indicators) - 1] = name;
         Print("Indicatore preesistente rilevato: ", name);
      }
   }
   Print("Totale indicatori preesistenti rilevati: ", ArraySize(existing_indicators));
}

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

      signal_sell_slots[i] = signal_buy_slots[i];
   }
   for (int i = 0; i < 2; i++) {
      filter_slots[i] = signal_buy_slots[0];
   }
   last_removed_indicator = "";
   active_section = -1;
   active_slot = -1;
   DetectExistingIndicators();
   LoadIndicatorSlots();
   DrawBigPanel();
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

void RemoveIndicatorFromChart(int handle, string name) {
   if (handle != INVALID_HANDLE) {
      bool removed = false;
      for (int i = 0; i < ChartIndicatorsTotal(0, 0); i++) {
         string ind_name = ChartIndicatorName(0, 0, i);
         if (ind_name == name) {
            if (ChartIndicatorDelete(0, 0, ind_name)) {
               removed = true;
               last_removed_indicator = name;
               Print("Indicatore rimosso dal grafico: ", name);
            }
            break;
         }
      }
      if (!removed) {
         Print("Errore: impossibile rimuovere l'indicatore ", name, " dal grafico");
      }
      IndicatorRelease(handle);
      ChartRedraw(); // Forziamo un aggiornamento del grafico
      // Verifichiamo che l'indicatore sia effettivamente rimosso
      for (int i = 0; i < ChartIndicatorsTotal(0, 0); i++) {
         string ind_name = ChartIndicatorName(0, 0, i);
         if (ind_name == name) {
            Print("Attenzione: l'indicatore ", name, " è ancora presente sul grafico dopo la rimozione!");
         }
      }
   }
}

void OnSlotClick(string section, int slot_index) {
   string obj_name = section + "_Slot_" + IntegerToString(slot_index);

   if (section == "SignalBuy" && signal_buy_slots[slot_index].name != "Add Indicator") {
      int result = MessageBox("Rimuovere l'indicatore " + signal_buy_slots[slot_index].name + "?", "Conferma Rimozione", MB_YESNOCANCEL | MB_ICONQUESTION);
      if (result == IDYES) {
         RemoveIndicatorFromChart(signal_buy_slots[slot_index].handle, signal_buy_slots[slot_index].name);
         signal_buy_slots[slot_index].name = "Add Indicator";
         signal_buy_slots[slot_index].current_color = clrLightGray;
         signal_buy_slots[slot_index].buffer_count = 0;
         signal_buy_slots[slot_index].is_assigning = false;
         signal_buy_slots[slot_index].is_blinking = false;
         signal_buy_slots[slot_index].countdown = 0;
         signal_buy_slots[slot_index].handle = INVALID_HANDLE;
         signal_buy_slots[slot_index].show_name_temp = false;
         signal_buy_slots[slot_index].name_display_start = 0;
         ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_buy_slots[slot_index].name);
         ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
         ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
         SaveIndicatorSlots();
         ChartRedraw();
      }
      return;
   }
   if (section == "SignalSell" && signal_sell_slots[slot_index].name != "Add Indicator") {
      int result = MessageBox("Rimuovere l'indicatore " + signal_sell_slots[slot_index].name + "?", "Conferma Rimozione", MB_YESNOCANCEL | MB_ICONQUESTION);
      if (result == IDYES) {
         RemoveIndicatorFromChart(signal_sell_slots[slot_index].handle, signal_sell_slots[slot_index].name);
         signal_sell_slots[slot_index].name = "Add Indicator";
         signal_sell_slots[slot_index].current_color = clrLightGray;
         signal_sell_slots[slot_index].buffer_count = 0;
         signal_sell_slots[slot_index].is_assigning = false;
         signal_sell_slots[slot_index].is_blinking = false;
         signal_sell_slots[slot_index].countdown = 0;
         signal_sell_slots[slot_index].handle = INVALID_HANDLE;
         signal_sell_slots[slot_index].show_name_temp = false;
         signal_sell_slots[slot_index].name_display_start = 0;
         ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_sell_slots[slot_index].name);
         ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
         ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
         SaveIndicatorSlots();
         ChartRedraw();
      }
      return;
   }
   if (section == "Filter" && filter_slots[slot_index].name != "Add Indicator") {
      int result = MessageBox("Rimuovere l'indicatore " + filter_slots[slot_index].name + "?", "Conferma Rimozione", MB_YESNOCANCEL | MB_ICONQUESTION);
      if (result == IDYES) {
         RemoveIndicatorFromChart(filter_slots[slot_index].handle, filter_slots[slot_index].name);
         filter_slots[slot_index].name = "Add Indicator";
         filter_slots[slot_index].current_color = clrLightGray;
         filter_slots[slot_index].buffer_count = 0;
         filter_slots[slot_index].is_assigning = false;
         filter_slots[slot_index].is_blinking = false;
         filter_slots[slot_index].countdown = 0;
         filter_slots[slot_index].handle = INVALID_HANDLE;
         filter_slots[slot_index].show_name_temp = false;
         filter_slots[slot_index].name_display_start = 0;
         ObjectSetString(0, obj_name, OBJPROP_TEXT, filter_slots[slot_index].name);
         ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
         ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
         SaveIndicatorSlots();
         ChartRedraw();
      }
      return;
   }

   if (section == "SignalBuy" && signal_buy_slots[slot_index].is_assigning) {
      signal_buy_slots[slot_index].is_assigning = false;
      signal_buy_slots[slot_index].countdown = 0;
      signal_buy_slots[slot_index].is_blinking = false;
      signal_buy_slots[slot_index].current_color = clrLightGray;
      signal_buy_slots[slot_index].name = "Add Indicator";
      ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_buy_slots[slot_index].name);
      ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
      ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
      active_section = -1;
      active_slot = -1;
      ChartRedraw();
      return;
   }
   if (section == "SignalSell" && signal_sell_slots[slot_index].is_assigning) {
      signal_sell_slots[slot_index].is_assigning = false;
      signal_sell_slots[slot_index].countdown = 0;
      signal_sell_slots[slot_index].is_blinking = false;
      signal_sell_slots[slot_index].current_color = clrLightGray;
      signal_sell_slots[slot_index].name = "Add Indicator";
      ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_sell_slots[slot_index].name);
      ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
      ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
      active_section = -1;
      active_slot = -1;
      ChartRedraw();
      return;
   }
   if (section == "Filter" && filter_slots[slot_index].is_assigning) {
      filter_slots[slot_index].is_assigning = false;
      filter_slots[slot_index].countdown = 0;
      filter_slots[slot_index].is_blinking = false;
      filter_slots[slot_index].current_color = clrLightGray;
      filter_slots[slot_index].name = "Add Indicator";
      ObjectSetString(0, obj_name, OBJPROP_TEXT, filter_slots[slot_index].name);
      ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
      ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
      active_section = -1;
      active_slot = -1;
      ChartRedraw();
      return;
   }

   if (show_assignment_alert) {
      int result = MessageBox("Trascina l'indicatore dal Navigator al grafico.\nVuoi ripetere questo avviso?", "OmniEA - Aggiungi Indicatore", MB_YESNOCANCEL | MB_ICONINFORMATION);
      if (result == IDYES) show_assignment_alert = true;
      else if (result == IDNO) show_assignment_alert = false;
      else return;
   }

   if (section == "SignalBuy") {
      signal_buy_slots[slot_index].is_assigning = true;
      signal_buy_slots[slot_index].countdown = 10;
      signal_buy_slots[slot_index].is_blinking = true;
      signal_buy_slots[slot_index].current_color = clrYellow;
      signal_buy_slots[slot_index].last_update = GetTickCount();
   } else if (section == "SignalSell") {
      signal_sell_slots[slot_index].is_assigning = true;
      signal_sell_slots[slot_index].countdown = 10;
      signal_sell_slots[slot_index].is_blinking = true;
      signal_sell_slots[slot_index].current_color = clrYellow;
      signal_sell_slots[slot_index].last_update = GetTickCount();
   } else if (section == "Filter") {
      filter_slots[slot_index].is_assigning = true;
      filter_slots[slot_index].countdown = 10;
      filter_slots[slot_index].is_blinking = true;
      filter_slots[slot_index].current_color = clrYellow;
      filter_slots[slot_index].last_update = GetTickCount();
   }
   active_section = (section == "SignalBuy" ? 0 : section == "SignalSell" ? 1 : 2);
   active_slot = slot_index;
   ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(10) + "s");
   ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrYellow);
   ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
   ChartRedraw();
}

void CheckForNewIndicators() {
   if (active_section == -1 || active_slot == -1) return;

   string section_name;
   if (active_section == 0) section_name = "SignalBuy";
   else if (active_section == 1) section_name = "SignalSell";
   else section_name = "Filter";

   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for (int i = 0; i < windows; i++) {
      int count = ChartIndicatorsTotal(0, i);
      for (int j = 0; j < count; j++) {
         string name = ChartIndicatorName(0, i, j);
         int handle = ChartIndicatorGet(0, i, name);
         if (handle == INVALID_HANDLE) continue;

         // Ignoriamo gli indicatori preesistenti
         bool is_existing = false;
         for (int k = 0; k < ArraySize(existing_indicators); k++) {
            if (name == existing_indicators[k]) {
               is_existing = true;
               Print("Indicatore ignorato (preesistente): ", name);
               break;
            }
         }
         if (is_existing) continue;

         // Evitiamo di aggiungere l'ultimo indicatore rimosso
         if (name == last_removed_indicator) {
            last_removed_indicator = "";
            Print("Indicatore ignorato (ultimo rimosso): ", name);
            continue;
         }

         bool is_new = true;
         for (int k = 0; k < 3; k++) {
            if (signal_buy_slots[k].handle == handle || signal_sell_slots[k].handle == handle) {
               is_new = false;
               break;
            }
         }
         for (int k = 0; k < 2; k++) {
            if (filter_slots[k].handle == handle) {
               is_new = false;
               break;
            }
         }
         if (!is_new) continue;

         int buffer_count = DetectBufferCount(handle);
         if (active_section == 0) {
            signal_buy_slots[active_slot].is_assigning = false;
            signal_buy_slots[active_slot].is_blinking = false;
            signal_buy_slots[active_slot].current_color = clrGreen;
            signal_buy_slots[active_slot].name = name;
            signal_buy_slots[active_slot].handle = handle;
            signal_buy_slots[active_slot].buffer_count = buffer_count;
            signal_buy_slots[active_slot].show_name_temp = true;
            signal_buy_slots[active_slot].name_display_start = GetTickCount();
         } else if (active_section == 1) {
            signal_sell_slots[active_slot].is_assigning = false;
            signal_sell_slots[active_slot].is_blinking = false;
            signal_sell_slots[active_slot].current_color = clrGreen;
            signal_sell_slots[active_slot].name = name;
            signal_sell_slots[active_slot].handle = handle;
            signal_sell_slots[active_slot].buffer_count = buffer_count;
            signal_sell_slots[active_slot].show_name_temp = true;
            signal_sell_slots[active_slot].name_display_start = GetTickCount();
         } else {
            filter_slots[active_slot].is_assigning = false;
            filter_slots[active_slot].is_blinking = false;
            filter_slots[active_slot].current_color = clrGreen;
            filter_slots[active_slot].name = name;
            filter_slots[active_slot].handle = handle;
            filter_slots[active_slot].buffer_count = buffer_count;
            filter_slots[active_slot].show_name_temp = true;
            filter_slots[active_slot].name_display_start = GetTickCount();
         }

         string obj_name = section_name + "_Slot_" + IntegerToString(active_slot);
         if (active_section == 0) {
            ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_buy_slots[active_slot].name);
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, signal_buy_slots[active_slot].current_color);
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
         } else if (active_section == 1) {
            ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_sell_slots[active_slot].name);
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, signal_sell_slots[active_slot].current_color);
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
         } else {
            ObjectSetString(0, obj_name, OBJPROP_TEXT, filter_slots[active_slot].name);
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, filter_slots[active_slot].current_color);
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
         }
         SaveIndicatorSlots();
         Print("Indicator added to ", section_name, " slot ", IntegerToString(active_slot), ": ", name, " (", IntegerToString(buffer_count), " buffers)");
         active_section = -1;
         active_slot = -1;
         ChartRedraw();
         return;
      }
   }
}

int DetectBufferCount(int handle) {
   int buffers = 0;
   while (buffers < 20) {
      double values[];
      ArraySetAsSeries(values, true);
      if (CopyBuffer(handle, buffers, 0, 1, values) <= 0) break;
      buffers++;
   }
   return buffers;
}

void UpdatePanel() {
   long current_tick = GetTickCount();
   if (current_tick - last_tick < 100) return;
   last_tick = current_tick;

   bool config_changed = false;
   string sections[] = {"SignalBuy", "SignalSell", "Filter"};
   int sizes[] = {3, 3, 2};

   for (int s = 0; s < 3; s++) {
      for (int i = 0; i < sizes[s]; i++) {
         string obj_name = sections[s] + "_Slot_" + IntegerToString(i);

         if (s == 0 && signal_buy_slots[i].is_assigning) {
            long elapsed = (GetTickCount() - signal_buy_slots[i].last_update) / 1000;
            signal_buy_slots[i].countdown = 10 - (int)elapsed;

            if (signal_buy_slots[i].countdown <= 0) {
               signal_buy_slots[i].is_assigning = false;
               signal_buy_slots[i].is_blinking = false;
               signal_buy_slots[i].current_color = clrLightGray;
               signal_buy_slots[i].name = "Add Indicator";
               ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_buy_slots[i].name);
               ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
               ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
               ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
               active_section = -1;
               active_slot = -1;
               config_changed = true;
               ChartRedraw();
               continue;
            }

            signal_buy_slots[i].is_blinking = !signal_buy_slots[i].is_blinking;
            signal_buy_slots[i].current_color = blink_colors[(GetTickCount() / 200) % ArraySize(blink_colors)];
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, signal_buy_slots[i].current_color);
            ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(signal_buy_slots[i].countdown) + "s");
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
            CheckForNewIndicators();
         }
         else if (s == 1 && signal_sell_slots[i].is_assigning) {
            long elapsed = (GetTickCount() - signal_sell_slots[i].last_update) / 1000;
            signal_sell_slots[i].countdown = 10 - (int)elapsed;

            if (signal_sell_slots[i].countdown <= 0) {
               signal_sell_slots[i].is_assigning = false;
               signal_sell_slots[i].is_blinking = false;
               signal_sell_slots[i].current_color = clrLightGray;
               signal_sell_slots[i].name = "Add Indicator";
               ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_sell_slots[i].name);
               ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
               ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
               ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
               active_section = -1;
               active_slot = -1;
               config_changed = true;
               ChartRedraw();
               continue;
            }

            signal_sell_slots[i].is_blinking = !signal_sell_slots[i].is_blinking;
            signal_sell_slots[i].current_color = blink_colors[(GetTickCount() / 200) % ArraySize(blink_colors)];
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, signal_sell_slots[i].current_color);
            ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(signal_sell_slots[i].countdown) + "s");
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
            CheckForNewIndicators();
         }
         else if (s == 2 && filter_slots[i].is_assigning) {
            long elapsed = (GetTickCount() - filter_slots[i].last_update) / 1000;
            filter_slots[i].countdown = 10 - (int)elapsed;

            if (filter_slots[i].countdown <= 0) {
               filter_slots[i].is_assigning = false;
               filter_slots[i].is_blinking = false;
               filter_slots[i].current_color = clrLightGray;
               filter_slots[i].name = "Add Indicator";
               ObjectSetString(0, obj_name, OBJPROP_TEXT, filter_slots[i].name);
               ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
               ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrLightGray);
               ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);
               active_section = -1;
               active_slot = -1;
               config_changed = true;
               ChartRedraw();
               continue;
            }

            filter_slots[i].is_blinking = !filter_slots[i].is_blinking;
            filter_slots[i].current_color = blink_colors[(GetTickCount() / 200) % ArraySize(blink_colors)];
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, filter_slots[i].current_color);
            ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(filter_slots[i].countdown) + "s");
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
            CheckForNewIndicators();
         }
         else if (s == 0 && signal_buy_slots[i].show_name_temp) {
            long elapsed = GetTickCount() - signal_buy_slots[i].name_display_start;
            if (elapsed >= 2000) {
               signal_buy_slots[i].show_name_temp = false;
               ChartRedraw();
            }
         }
         else if (s == 1 && signal_sell_slots[i].show_name_temp) {
            long elapsed = GetTickCount() - signal_sell_slots[i].name_display_start;
            if (elapsed >= 2000) {
               signal_sell_slots[i].show_name_temp = false;
               ChartRedraw();
            }
         }
         else if (s == 2 && filter_slots[i].show_name_temp) {
            long elapsed = GetTickCount() - filter_slots[i].name_display_start;
            if (elapsed >= 2000) {
               filter_slots[i].show_name_temp = false;
               ChartRedraw();
            }
         }
      }
   }
   if (config_changed) SaveIndicatorSlots();
}

void DrawBigPanel() {
   Print("Disegno del Pannello Grande...");

   // Sfondo principale
   CreateRectangle("PanelBackground", 10, 10, 700, 400, clrBlack, 2);

   // Titolo
   CreateRectangle("TitleBar", 10, 10, 700, 30, clrDarkSlateBlue, 1);
   CreateLabel("TitleLabel", 20, 15, "OMNIEA LITE v1.0 by BTT", clrWhite, 10);

   // Pulsanti di controllo (minimizza, chiudi)
   CreateButton("MinimizeButton", 670, 15, 20, 20, "-");
   CreateButton("CloseButton", 690, 15, 20, 20, "X");

   // Sezione Informazioni
   CreateRectangle("InfoSection", 20, 50, 680, 100, clrBlack, 1);

   // Colonna 1
   CreateLabel("BrokerLabel", 30, 60, "Broker");
   CreateLabel("BrokerValue", 100, 60, "XXXX");
   CreateLabel("AccountLabel", 30, 80, "Account");
   CreateLabel("AccountValue", 100, 80, "XXXX");
   CreateLabel("BalanceLabel", 30, 100, "Balance");
   CreateLabel("BalanceValue", 100, 100, "XXXXXX");
   CreateLabel("MarketLabel", 30, 120, "Market");
   CreateLabel("MarketValue", 100, 120, "XXXXXX");
   CreateLabel("SpreadLabel", 30, 140, "Spread");
   CreateLabel("SpreadValue", 100, 140, "XXXXXX");

   // Colonna 2
   CreateLabel("OpenOrderLabel", 150, 60, "Open Order");
   CreateLabel("OpenOrderValue", 220, 60, "LIVE/Candle close");
   CreateLabel("TPLabel", 150, 80, "TP");
   CreateLabel("TPValue", 220, 80, "YYYYYYYY");
   CreateLabel("SLLabel", 150, 100, "SL");
   CreateLabel("SLValue", 220, 100, "XXXXXXXX");
   CreateLabel("TsLabel", 150, 120, "Ts");
   CreateEdit("TsInput", 220, 120, 60, 25, IntegerToString(trailing_stop), trailing_stop >= 0 && trailing_stop <= 1000 ? clrGreen : clrRed);
   CreateLabel("BELabel", 150, 140, "BE");
   CreateEdit("BEInput", 220, 140, 60, 25, IntegerToString(break_even), break_even >= 0 && break_even <= 1000 ? clrGreen : clrRed);

   // Colonna 3
   CreateLabel("TimeTrading1Label", 300, 60, "Time trading 1");
   CreateLabel("TimeTrading1Value", 370, 60, "To xxxx from XXXX%page");
   CreateLabel("TimeTrading2Label", 300, 80, "Time trading 2");
   CreateLabel("TimeTrading2Value", 370, 80, "To xxxx from XXXX%compounding");
   CreateLabel("NewsStopLabel", 300, 100, "News Stop");
   CreateLabel("NewsStopValue", 370, 100, "No/high/med/low/no");
   CreateLabel("LotRiskLabel", 300, 120, "Lot/Risk %");
   CreateLabel("LotRiskValue", 370, 120, "0.01");
   CreateLabel("RiskPercentLabel", 300, 140, "Risk %");
   CreateEdit("RiskPercentInput", 370, 140, 60, 25, DoubleToString(risk_percent, 2), risk_percent >= 0.01 && risk_percent <= 100 ? clrGreen : clrRed);

   // Colonna 4
   CreateLabel("SlippageLabel", 450, 60, "Slippage");
   CreateLabel("SlippageValue", 520, 60, "XXXXXX");
   CreateLabel("CompoundingLabel", 450, 80, "Compounding");
   CreateLabel("CompoundingValue", 520, 80, "XXXXXXXXX");
   CreateLabel("CapitaleLabel", 450, 100, "Capitale da allocare");
   CreateLabel("CapitaleValue", 520, 100, "No/high/med/low/no");
   CreateLabel("NewsStop2Label", 450, 120, "News Stop");
   CreateLabel("NewsStop2Value", 520, 120, "XXXXXXXX");
   CreateLabel("MagicNumberLabel", 450, 140, "Magic Number");
   CreateLabel("MagicNumberValue", 520, 140, "ZZZZZZZZ");

   // Sezione Signal Buy
   CreateRectangle("SignalBuySection", 20, 160, 340, 110, clrBlack, 1);
   CreateLabel("SignalBuyLabel", 30, 165, "Signal Buy", clrWhite, 10);
   for (int i = 0; i < 3; i++) {
      string slot_name = "SignalBuy_Slot_" + IntegerToString(i);
      CreateButton(slot_name, 30, 190 + i * 30, 120, 25, signal_buy_slots[i].name, signal_buy_slots[i].current_color);
      CreateButton(slot_name + "_AndOr", 160, 190 + i * 30, 50, 25, "And/Or");
      CreateButton(slot_name + "_Option", 220, 190 + i * 30, 50, 25, "Opzione ind");
      CreateButton(slot_name + "_Value", 280, 190 + i * 30, 50, 25, "Valore opzione");
   }

   // Sezione Signal Sell
   CreateRectangle("SignalSellSection", 370, 160, 330, 110, clrBlack, 1);
   CreateLabel("SignalSellLabel", 380, 165, "Signal Sell", clrWhite, 10);
   for (int i = 0; i < 3; i++) {
      string slot_name = "SignalSell_Slot_" + IntegerToString(i);
      CreateButton(slot_name, 380, 190 + i * 30, 120, 25, signal_sell_slots[i].name, signal_sell_slots[i].current_color);
      CreateButton(slot_name + "_AndOr", 510, 190 + i * 30, 50, 25, "And/Or");
      CreateButton(slot_name + "_Option", 570, 190 + i * 30, 50, 25, "Opzione ind");
      CreateButton(slot_name + "_Value", 630, 190 + i * 30, 50, 25, "Valore opzione");
   }

   // Sezione Filter
   CreateRectangle("FilterSection", 20, 280, 680, 80, clrBlack, 1);
   CreateLabel("FilterLabel", 30, 285, "Filtri", clrWhite, 10);
   for (int i = 0; i < 2; i++) {
      string slot_name = "Filter_Slot_" + IntegerToString(i);
      CreateButton(slot_name, 30, 310 + i * 30, 120, 25, filter_slots[i].name, filter_slots[i].current_color);
      CreateButton(slot_name + "_AndOr", 160, 310 + i * 30, 50, 25, "And/Or");
      CreateButton(slot_name + "_Option", 220, 310 + i * 30, 50, 25, "Opzione ind");
      CreateButton(slot_name + "_Value", 280, 310 + i * 30, 50, 25, "Valore opzione");
   }

   ChartRedraw();
}

void HandlePanelChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK) {
      // Gestione click su caselle indicatori
      for (int s = 0; s < 3; s++) {
         string section = (s == 0 ? "SignalBuy" : s == 1 ? "SignalSell" : "Filter");
         int size = (s < 2 ? 3 : 2);
         for (int i = 0; i < size; i++) {
            string obj_name = section + "_Slot_" + IntegerToString(i);
            if (sparam == obj_name) {
               OnSlotClick(section, i);
               return;
            }
         }
      }
      // Gestione click su pulsanti di controllo
      if (sparam == "CloseButton") {
         ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, false);
         return;
      }
      if (sparam == "MinimizeButton") {
         // Logica per minimizzare (da implementare)
         return;
      }
   }
   if (id == CHARTEVENT_OBJECT_ENDEDIT) {
      if (sparam == "RiskPercentInput") {
         double new_value = StringToDouble(ObjectGetString(0, sparam, OBJPROP_TEXT));
         if (new_value < 0.01 || new_value > 100) {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrRed);
         } else {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrGreen);
            risk_percent = new_value;
            SaveIndicatorSlots();
         }
      }
      if (sparam == "TsInput") {
         int new_value = (int)StringToInteger(ObjectGetString(0, sparam, OBJPROP_TEXT));
         if (new_value < 0 || new_value > 1000) {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrRed);
         } else {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrGreen);
            trailing_stop = new_value;
            SaveIndicatorSlots();
         }
      }
      if (sparam == "BEInput") {
         int new_value = (int)StringToInteger(ObjectGetString(0, sparam, OBJPROP_TEXT));
         if (new_value < 0 || new_value > 1000) {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrRed);
         } else {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrGreen);
            break_even = new_value;
            SaveIndicatorSlots();
         }
      }
   }
}