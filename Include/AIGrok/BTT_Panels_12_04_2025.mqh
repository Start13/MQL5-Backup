#include <AIGrok\BTT_IndicatorSlots_12_04_2025.mqh>

enum PanelMode {
   MODE_MINIMIZED,
   MODE_SMALL,
   MODE_LARGE
};
PanelMode current_mode = MODE_LARGE;

bool show_assignment_alert = true;
datetime last_tick = 0;
color blink_colors[] = {clrYellow, clrWhite, clrYellow, clrWhite};
int active_section = -1; // 0: SignalBuy, 1: SignalSell, 2: Filter
int active_slot = -1;

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

bool IsMarketOpen() {
   MqlDateTime time;
   TimeToStruct(TimeCurrent(), time);
   return (time.hour >= 8 && time.hour < 22);
}

void UpdatePanelColors() {
   color panel_color = IsMarketOpen() ? clrGreen : clrRed;
   ObjectSetInteger(0, "PanelBackground", OBJPROP_BORDER_COLOR, panel_color);
   ObjectSetInteger(0, "TitleBar", OBJPROP_BGCOLOR, panel_color);
}

void DrawBigPanel() {
   Print("Disegno del Pannello Grande...");
   color panel_color = IsMarketOpen() ? clrGreen : clrRed;
   CreateRectangle("PanelBackground", 10, 10, 700, 400, panel_color, 2);
   CreateRectangle("TitleBar", 10, 10, 700, 30, panel_color, 1);
   CreateLabel("TitleLabel", 20, 15, "OMNIEA LITE v1.0 by BTT", clrWhite, 10);
   CreateButton("MinimizeButton", 670, 15, 20, 20, "-");
   CreateButton("CloseButton", 690, 15, 20, 20, "X");

   CreateRectangle("InfoSection", 20, 50, 680, 100, clrBlack, 1);
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

   CreateRectangle("SignalBuySection", 20, 160, 340, 110, clrBlack, 1);
   CreateLabel("SignalBuyLabel", 30, 165, "Signal Buy", clrWhite, 10);
   for (int i = 0; i < 3; i++) {
      string slot_name = "SignalBuy_Slot_" + IntegerToString(i);
      CreateButton(slot_name, 30, 190 + i * 30, 120, 25, signal_buy_slots[i].name, signal_buy_slots[i].current_color);
      CreateButton(slot_name + "_AndOr", 160, 190 + i * 30, 50, 25, "And/Or");
      CreateButton(slot_name + "_Option", 220, 190 + i * 30, 50, 25, "Opzione ind");
      CreateButton(slot_name + "_Value", 280, 190 + i * 30, 50, 25, "Valore opzione");
   }

   CreateRectangle("SignalSellSection", 370, 160, 330, 110, clrBlack, 1);
   CreateLabel("SignalSellLabel", 380, 165, "Signal Sell", clrWhite, 10);
   for (int i = 0; i < 3; i++) {
      string slot_name = "SignalSell_Slot_" + IntegerToString(i);
      CreateButton(slot_name, 380, 190 + i * 30, 120, 25, signal_sell_slots[i].name, signal_sell_slots[i].current_color);
      CreateButton(slot_name + "_AndOr", 510, 190 + i * 30, 50, 25, "And/Or");
      CreateButton(slot_name + "_Option", 570, 190 + i * 30, 50, 25, "Opzione ind");
      CreateButton(slot_name + "_Value", 630, 190 + i * 30, 50, 25, "Valore opzione");
   }

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

void MinimizePanel() {
   current_mode = MODE_MINIMIZED;
   ObjectSetInteger(0, "InfoSection", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "SignalBuySection", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "SignalSellSection", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "FilterSection", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_YSIZE, 40);
   ChartRedraw();
}

void SmallPanel() {
   current_mode = MODE_SMALL;
   ObjectSetInteger(0, "InfoSection", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "SignalBuySection", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "SignalSellSection", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "FilterSection", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_YSIZE, 280);
   ChartRedraw();
}

void RestorePanel() {
   current_mode = MODE_LARGE;
   ObjectSetInteger(0, "InfoSection", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "SignalBuySection", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "SignalSellSection", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "FilterSection", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "PanelBackground", OBJPROP_YSIZE, 400);
   ChartRedraw();
}

void OnSlotClick(string section, int slot_index) {
   string obj_name = section + "_Slot_" + IntegerToString(slot_index);

   if (section == "SignalBuy" && signal_buy_slots[slot_index].name != "Add Indicator") {
      int result = MessageBox("Rimuovere l'indicatore " + signal_buy_slots[slot_index].name + "?", "Conferma Rimozione", MB_YESNOCANCEL | MB_ICONQUESTION);
      if (result == IDYES) {
         RemoveIndicatorFromChart(signal_buy_slots[slot_index].handle, signal_buy_slots[slot_index].name, section, slot_index);
         signal_buy_slots[slot_index].name = "Add Indicator";
         signal_buy_slots[slot_index].current_color = clrLightGray;
         signal_buy_slots[slot_index].buffer_count = 0;
         signal_buy_slots[slot_index].is_assigning = false;
         signal_buy_slots[slot_index].is_blinking = false;
         signal_buy_slots[slot_index].countdown = 0;
         signal_buy_slots[slot_index].handle = INVALID_HANDLE;
         signal_buy_slots[slot_index].show_name_temp = false;
         signal_buy_slots[slot_index].name_display_start = 0;
         signal_buy_slots[slot_index].unique_id = "";
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
         RemoveIndicatorFromChart(signal_sell_slots[slot_index].handle, signal_sell_slots[slot_index].name, section, slot_index);
         signal_sell_slots[slot_index].name = "Add Indicator";
         signal_sell_slots[slot_index].current_color = clrLightGray;
         signal_sell_slots[slot_index].buffer_count = 0;
         signal_sell_slots[slot_index].is_assigning = false;
         signal_sell_slots[slot_index].is_blinking = false;
         signal_sell_slots[slot_index].countdown = 0;
         signal_sell_slots[slot_index].handle = INVALID_HANDLE;
         signal_sell_slots[slot_index].show_name_temp = false;
         signal_sell_slots[slot_index].name_display_start = 0;
         signal_sell_slots[slot_index].unique_id = "";
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
         RemoveIndicatorFromChart(filter_slots[slot_index].handle, filter_slots[slot_index].name, section, slot_index);
         filter_slots[slot_index].name = "Add Indicator";
         filter_slots[slot_index].current_color = clrLightGray;
         filter_slots[slot_index].buffer_count = 0;
         filter_slots[slot_index].is_assigning = false;
         filter_slots[slot_index].is_blinking = false;
         filter_slots[slot_index].countdown = 0;
         filter_slots[slot_index].handle = INVALID_HANDLE;
         filter_slots[slot_index].show_name_temp = false;
         filter_slots[slot_index].name_display_start = 0;
         filter_slots[slot_index].unique_id = "";
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

   Print("Clic su ", section, " slot ", slot_index, ": last_update=", TimeToString(TimeCurrent()));
   if (section == "SignalBuy") {
      signal_buy_slots[slot_index].is_assigning = true;
      signal_buy_slots[slot_index].countdown = 10;
      signal_buy_slots[slot_index].is_blinking = true;
      signal_buy_slots[slot_index].current_color = clrYellow;
      signal_buy_slots[slot_index].last_update = TimeCurrent();
      RecordInitialIndicatorsForSlot(signal_buy_slots[slot_index]);
   } else if (section == "SignalSell") {
      signal_sell_slots[slot_index].is_assigning = true;
      signal_sell_slots[slot_index].countdown = 10;
      signal_sell_slots[slot_index].is_blinking = true;
      signal_sell_slots[slot_index].current_color = clrYellow;
      signal_sell_slots[slot_index].last_update = TimeCurrent();
      RecordInitialIndicatorsForSlot(signal_sell_slots[slot_index]);
   } else if (section == "Filter") {
      filter_slots[slot_index].is_assigning = true;
      filter_slots[slot_index].countdown = 10;
      filter_slots[slot_index].is_blinking = true;
      filter_slots[slot_index].current_color = clrYellow;
      filter_slots[slot_index].last_update = TimeCurrent();
      RecordInitialIndicatorsForSlot(filter_slots[slot_index]);
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
   if (active_section == -1 || active_slot == -1) {
      Print("CheckForNewIndicators: Nessun slot attivo");
      return;
   }

   string section_name;
   IndicatorSlot temp_slot;

   if (active_section == 0) {
      section_name = "SignalBuy";
      temp_slot = signal_buy_slots[active_slot];
   } else if (active_section == 1) {
      section_name = "SignalSell";
      temp_slot = signal_sell_slots[active_slot];
   } else {
      section_name = "Filter";
      temp_slot = filter_slots[active_slot];
   }

   Print("CheckForNewIndicators: sezione=", section_name, ", slot=", active_slot);
   int windows = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for (int i = 0; i < windows; i++) {
      int count = ChartIndicatorsTotal(0, i);
      Print("Finestra ", i, ": ", count, " indicatori trovati");
      for (int j = 0; j < count; j++) {
         string name = ChartIndicatorName(0, i, j);
         Print("Verifica indicatore: ", name, ", Finestra: ", i);
         int handle = ChartIndicatorGet(0, i, name);
         if (handle == INVALID_HANDLE) {
            Print("Errore: handle non valido per ", name, " (finestra ", i, ")");
            continue;
         }

         bool is_existing = false;
         for (int k = 0; k < ArraySize(existing_indicators); k++) {
            if (name == existing_indicators[k]) {
               is_existing = true;
               Print("Ignorato (preesistente globale): ", name);
               break;
            }
         }
         if (is_existing) continue;

         if (!IsNewIndicator(name, temp_slot)) continue;

         if (name == last_removed_indicator) {
            last_removed_indicator = "";
            Print("Ignorato (ultimo rimosso): ", name);
            continue;
         }

         int buffer_count = DetectBufferCount(handle);
         Print("Indicatore ", name, ": ", buffer_count, " buffer rilevati");

         double values[];
         ArraySetAsSeries(values, true);
         bool buffer_ok = (CopyBuffer(handle, 0, 0, 1, values) > 0 && values[0] != EMPTY_VALUE);
         if (!buffer_ok) {
            Print("Buffer non inizializzato per ", name);
            continue;
         }

         bool is_new = true;
         for (int k = 0; k < 3; k++) {
            if (signal_buy_slots[k].unique_id == name + "_" + IntegerToString(handle) ||
                signal_sell_slots[k].unique_id == name + "_" + IntegerToString(handle)) {
               is_new = false;
               break;
            }
         }
         for (int k = 0; k < 2; k++) {
            if (filter_slots[k].unique_id == name + "_" + IntegerToString(handle)) {
               is_new = false;
               break;
            }
         }
         if (!is_new) {
            Print("Indicatore ", name, " già assegnato, ignorato");
            continue;
         }

         string buffer_values = "";
         for (int b = 0; b < buffer_count; b++) {
            double buffer_data[];
            ArraySetAsSeries(buffer_data, true);
            if (CopyBuffer(handle, b, 0, 1, buffer_data) > 0 && buffer_data[0] != EMPTY_VALUE) {
               buffer_values += "Buffer " + IntegerToString(b) + ": " + DoubleToString(buffer_data[0], 6) + "; ";
            } else {
               buffer_values += "Buffer " + IntegerToString(b) + ": Non disponibile; ";
            }
         }

         temp_slot.is_assigning = false;
         temp_slot.is_blinking = false;
         temp_slot.current_color = clrGreen;
         temp_slot.name = name;
         temp_slot.handle = handle;
         temp_slot.buffer_count = buffer_count;
         temp_slot.show_name_temp = true;
         temp_slot.name_display_start = TimeCurrent();
         temp_slot.unique_id = name + "_" + IntegerToString(handle);

         if (active_section == 0) {
            signal_buy_slots[active_slot] = temp_slot;
         } else if (active_section == 1) {
            signal_sell_slots[active_slot] = temp_slot;
         } else {
            filter_slots[active_slot] = temp_slot;
         }

         string obj_name = section_name + "_Slot_" + IntegerToString(active_slot);
         ObjectSetString(0, obj_name, OBJPROP_TEXT, temp_slot.name);
         ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
         ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, temp_slot.current_color);
         ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 8);

         SaveIndicatorSlots();
         Print("Indicatore assegnato a ", section_name, " slot ", active_slot, ": ", name, "; Buffer: ", buffer_values);
         active_section = -1;
         active_slot = -1;
         ChartRedraw();
         return;
      }
   }
   Print("Nessun nuovo indicatore rilevato");
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
   datetime current_time = TimeCurrent();
   UpdatePanelColors();

   bool config_changed = false;
   string sections[] = {"SignalBuy", "SignalSell", "Filter"};
   int sizes[] = {3, 3, 2};

   static datetime last_buffer_print = 0;
   if (current_time - last_buffer_print >= 10) {
      for (int s = 0; s < 3; s++) {
         for (int i = 0; i < sizes[s]; i++) {
            if (s == 0) PrintIndicatorBufferValues(sections[s], i, signal_buy_slots[i]);
            else if (s == 1) PrintIndicatorBufferValues(sections[s], i, signal_sell_slots[i]);
            else PrintIndicatorBufferValues(sections[s], i, filter_slots[i]);
         }
      }
      last_buffer_print = current_time;
   }

   for (int s = 0; s < 3; s++) {
      for (int i = 0; i < sizes[s]; i++) {
         string obj_name = sections[s] + "_Slot_" + IntegerToString(i);

         if (s == 0 && signal_buy_slots[i].is_assigning) {
            int elapsed = (int)(current_time - signal_buy_slots[i].last_update);
            signal_buy_slots[i].countdown = 10 - elapsed;
            Print("SignalBuy slot ", i, ": countdown=", signal_buy_slots[i].countdown, ", elapsed=", elapsed);

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
               Print("SignalBuy slot ", i, ": Timeout, assegnazione annullata");
               ChartRedraw();
               continue;
            }

            signal_buy_slots[i].is_blinking = !signal_buy_slots[i].is_blinking;
            signal_buy_slots[i].current_color = blink_colors[(int)(current_time % 2)];
            ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(signal_buy_slots[i].countdown) + "s");
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, signal_buy_slots[i].current_color);
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
            CheckForNewIndicators();
         }
         else if (s == 1 && signal_sell_slots[i].is_assigning) {
            int elapsed = (int)(current_time - signal_sell_slots[i].last_update);
            signal_sell_slots[i].countdown = 10 - elapsed;
            Print("SignalSell slot ", i, ": countdown=", signal_sell_slots[i].countdown, ", elapsed=", elapsed);

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
               Print("SignalSell slot ", i, ": Timeout, assegnazione annullata");
               ChartRedraw();
               continue;
            }

            signal_sell_slots[i].is_blinking = !signal_sell_slots[i].is_blinking;
            signal_sell_slots[i].current_color = blink_colors[(int)(current_time % 2)];
            ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(signal_sell_slots[i].countdown) + "s");
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, signal_sell_slots[i].current_color);
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
            CheckForNewIndicators();
         }
         else if (s == 2 && filter_slots[i].is_assigning) {
            int elapsed = (int)(current_time - filter_slots[i].last_update);
            filter_slots[i].countdown = 10 - elapsed;
            Print("Filter slot ", i, ": countdown=", filter_slots[i].countdown, ", elapsed=", elapsed);

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
               Print("Filter slot ", i, ": Timeout, assegnazione annullata");
               ChartRedraw();
               continue;
            }

            filter_slots[i].is_blinking = !filter_slots[i].is_blinking;
            filter_slots[i].current_color = blink_colors[(int)(current_time % 2)];
            ObjectSetString(0, obj_name, OBJPROP_TEXT, "Drag ind\nTime: " + IntegerToString(filter_slots[i].countdown) + "s");
            ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clrBlack);
            ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, filter_slots[i].current_color);
            ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, 6);
            CheckForNewIndicators();
         }
         else if (s == 0 && signal_buy_slots[i].show_name_temp) {
            int elapsed = (int)(current_time - signal_buy_slots[i].name_display_start);
            if (elapsed >= 2) {
               signal_buy_slots[i].show_name_temp = false;
               ChartRedraw();
            }
         }
         else if (s == 1 && signal_sell_slots[i].show_name_temp) {
            int elapsed = (int)(current_time - signal_sell_slots[i].name_display_start);
            if (elapsed >= 2) {
               signal_sell_slots[i].show_name_temp = false;
               ChartRedraw();
            }
         }
         else if (s == 2 && filter_slots[i].show_name_temp) {
            int elapsed = (int)(current_time - filter_slots[i].name_display_start);
            if (elapsed >= 2) {
               filter_slots[i].show_name_temp = false;
               ChartRedraw();
            }
         }
      }
   }
   if (config_changed) SaveIndicatorSlots();
}

void HandlePanelChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK) {
      for (int s = 0; s < 3; s++) {
         string section = (s == 0 ? "SignalBuy" : s == 1 ? "SignalSell" : "Filter");
         int size = (s < 2 ? 3 : 2);
         for (int i = 0; i < size; i++) {
            string slot_name = section + "_Slot_" + IntegerToString(i);
            if (sparam == slot_name) {
               OnSlotClick(section, i);
               return;
            }
            string and_or_name = slot_name + "_AndOr";
            string option_name = slot_name + "_Option";
            string value_name = slot_name + "_Value";
            if (sparam == and_or_name) {
               Print("Clic su And/Or per ", section, " slot ", i);
               return;
            }
            if (sparam == option_name) {
               Print("Clic su Opzione ind per ", section, " slot ", i);
               return;
            }
            if (sparam == value_name) {
               Print("Clic su Valore opzione per ", section, " slot ", i);
               return;
            }
         }
      }
      if (sparam == "CloseButton") {
         ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, false);
         return;
      }
      if (sparam == "MinimizeButton") {
         if (current_mode == MODE_LARGE) {
            MinimizePanel();
         } else if (current_mode == MODE_MINIMIZED) {
            SmallPanel();
         } else {
            RestorePanel();
         }
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