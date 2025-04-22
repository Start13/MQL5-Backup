//+------------------------------------------------------------------+
//|                                                   prove enum.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

input ENUM_MQL_INFO_INTEGER modo;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
Comment ("modo ", StringSubstr(EnumToString(ENUM_MQL_INFO_INTEGER(modo)),5,0), DoubleToString(ENUM_MQL_INFO_INTEGER(modo)));



   
  }
//+------------------------------------------------------------------+
