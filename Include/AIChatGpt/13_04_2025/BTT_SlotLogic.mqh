// BTT_SlotLogic.mqh
#pragma once

#include <Files\File.mqh>

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
   string logic_mode; // "AND" o "OR"
};

IndicatorSlot signal_buy_slots[3];
IndicatorSlot signal_sell_slots[3];
IndicatorSlot filter_slots[2];

double risk_percent = 1.0;
int trailing_stop = 0;
int break_even = 0;
bool show_assignment_alert = true;
long last_tick = 0;
color blink_colors[] = {clrLightGray, clrYellow, clrWhite, clrYellow, clrLightGray};
int active_section = -1;
int active_slot = -1;
string last_removed_indicator = "";
string existing_indicators[];

void InitializeSlotState() {
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
      signal_buy_slots[i].logic_mode = "AND";

      signal_sell_slots[i] = signal_buy_slots[i];
   }
   for (int i = 0; i < 2; i++) {
      filter_slots[i] = signal_buy_slots[0];
   }
}

void HandlePanelEvents(const int id, const string &sparam) {
   if (id != CHARTEVENT_OBJECT_CLICK) return;
   string parts[];
   StringSplit(sparam, '_', parts);
   if (ArraySize(parts) < 3 || parts[2] != "AndOr") return;

   string section = parts[0];
   int index = (int)StringToInteger(parts[1]);
   string obj_name = sparam;

   IndicatorSlot *slot = NULL;
   if (section == "SignalBuy") slot = &signal_buy_slots[index];
   else if (section == "SignalSell") slot = &signal_sell_slots[index];
   else if (section == "Filter") slot = &filter_slots[index];

   if (slot == NULL) return;
   slot.logic_mode = (slot.logic_mode == "AND" ? "OR" : "AND");
   color logic_color = (slot.logic_mode == "AND" ? clrLime : clrBlue);
   ObjectSetString(0, obj_name, OBJPROP_TEXT, slot.logic_mode);
   ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, logic_color);
   SaveIndicatorSlots();
   ChartRedraw();
}

void SaveIndicatorSlots();
void LoadIndicatorSlots();
void DetectExistingIndicators();
void OnSlotClick(string section, int slot_index);
void CheckForNewIndicators();
int DetectBufferCount(int handle);
void UpdateSlotTimers();
