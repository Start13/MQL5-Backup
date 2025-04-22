#pragma once

#include "BTT_UIUtils.mqh"
#include "BTT_SlotLogic.mqh"

void DrawLogicButton(string section, int index, int x, int y) {
   string name = section + "_" + IntegerToString(index) + "_AndOr";
   string mode = (section == "Filter") ? filter_slots[index].logic_mode :
                  (section == "SignalBuy") ? signal_buy_slots[index].logic_mode :
                  signal_sell_slots[index].logic_mode;

   color logic_color = (mode == "AND") ? clrLime : clrBlue;
   CreateButton(name, x, y, 40, 18, mode, logic_color, 8);
}

void DrawAllLogicButtons() {
   for (int i = 0; i < 3; i++) {
      DrawLogicButton("SignalBuy", i, 20 + i * 140, 50);
      DrawLogicButton("SignalSell", i, 20 + i * 140, 100);
   }
   for (int i = 0; i < 2; i++) {
      DrawLogicButton("Filter", i, 20 + i * 140, 150);
   }
}
