//+------------------------------------------------------------------+
//|                                         High Low per Zig Zag.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int shift= 20;
input int counter= 60;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnInit()
  {
Print ("iHigh: ",iHigh(Symbol(),PERIOD_CURRENT,shift));
 Print (" iLow: ",iLow(Symbol(),PERIOD_CURRENT,shift)); 
   {
//---+   
   //--- checking the number of bars
  
  int rates_total = iBars(Symbol(),PERIOD_CURRENT);
   //--- declare the local variables 
   int first, bar;
   double BULLS, BEARS;
   
   //--- calculation of the starting bar number
int prev_calculated = 0;  // checking for the first start of the indicator calculation
     first = 0; // starting number for the calculation of all of the bars
 

   //--- main loop
   for(bar = first; bar < rates_total; bar++)
    {
     //--- calculation of values
     BULLS = 100 - (bar - iHighest(high, AroonPeriod, bar) + 0.5) * 100 / AroonPeriod;
     BEARS = 100 - (bar - iLowest (low,  AroonPeriod, bar) + 0.5) * 100 / AroonPeriod;

     //--- filling the indicator buffers with the calculated values 
     BullsAroonBuffer[bar] = BULLS;
     BearsAroonBuffer[bar] = BEARS;
    }
//---+     
   return(rates_total);
  } 
  }
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
   count = counter;
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
   //count = counter;   
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