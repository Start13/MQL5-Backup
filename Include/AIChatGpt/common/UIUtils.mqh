// UIUtils.mqh
// Utility comuni per l'interfaccia utente
// Copyright 2025, BlueTrendTeam
#pragma once

//+------------------------------------------------------------------+
//| Crea un'etichetta di testo sull'interfaccia                      |
//+------------------------------------------------------------------+
void CreateLabel(string name, int x, int y, string text, color text_color = clrWhite, int font_size = 8) {
   ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, text_color);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
}

//+------------------------------------------------------------------+
//| Crea un campo di testo modificabile sull'interfaccia             |
//+------------------------------------------------------------------+
void CreateEdit(string name, int x, int y, int width, int height, string text, color bg_color = clrLightGray) {
   ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
}

//+------------------------------------------------------------------+
//| Crea un pulsante sull'interfaccia                                |
//+------------------------------------------------------------------+
void CreateButton(string name, int x, int y, int width, int height, string text, color bg_color = clrSteelBlue) {
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
}

//+------------------------------------------------------------------+
//| Crea un rettangolo sull'interfaccia                              |
//+------------------------------------------------------------------+
void CreateRectangle(string name, int x, int y, int width, int height, color bg_color = clrDarkSlateGray, color border_color = clrBlack) {
   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_color);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_color);
}

//+------------------------------------------------------------------+
//| Elimina tutti gli oggetti con un prefisso specifico              |
//+------------------------------------------------------------------+
void DeleteObjectsByPrefix(string prefix) {
   for(int i = ObjectsTotal(0) - 1; i >= 0; i--) {
      string name = ObjectName(0, i);
      if(StringSubstr(name, 0, StringLen(prefix)) == prefix) {
         ObjectDelete(0, name);
      }
   }
}
