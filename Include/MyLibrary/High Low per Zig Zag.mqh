//+------------------------------------------------------------------+
//|                                         High Low per Zig Zag.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  searching index of the highest bar                              |
//+------------------------------------------------------------------+
int iHighest(const double &array[], // array for searching for the index of the maximum element
             int count,            // number of the elements in the array (in the decreasing order), 
             int startPos          // starting index
             )                     
  {
//---+
   int index = startPos;
   
   //---- checking the starting index
   if (startPos < 0)
     {
      Print("Incorrect value in the function iHighest, startPos = ", startPos);
      return (0);
     } 
   //---- checking the startPos values
   if (startPos - count < 0) count = startPos;
    
   double max = array[startPos];
   
   //---- index search
   for(int i = startPos; i > startPos - count; i--)
     {
      if(array[i] > max)
        {
         index = i;
         max = array[i];
        }
     }
//---+ return of the index of the largest bar
   return(index);
  }
//+------------------------------------------------------------------+
//|  searching index of the lowest bar                               |
//+------------------------------------------------------------------+
int iLowest(
            const double &array[], // array for searching for the index of the maximum element
            int count,            // number of the elements in the array (in the decreasing order),
            int startPos          // starting index
            ) 
{
//---+
   int index = startPos;
   
   //--- checking the stating index
   if (startPos < 0)
     {
      Print("Incorrect value in the iLowest function, startPos = ",startPos);
      return(0);
     }
     
   //--- checking the startPos value
   if (startPos - count < 0) count = startPos;
    
   double min = array[startPos];
   
   //--- index search
   for(int i = startPos; i > startPos - count; i--)
     {
      if (array[i] < min)
        {
         index = i;
         min = array[i];
        }
     }
//---+ return of the index of the smallest bar
   return(index);
  }