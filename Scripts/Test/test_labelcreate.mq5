//+------------------------------------------------------------------+
//|                                             test LabelCreate.mq5 |
//|                                                2015, Dina Paches |
//|                           https://login.mql5.com/ru/users/dipach |
//+------------------------------------------------------------------+
#property copyright "2015, Dina Paches"
#property link      "https://login.mql5.com/ru/users/dipach"
#property version   "1.00"
#include <ObjectCreateAndSet.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   string nameObj="testLabel";
   string text[10]=
     {
      "A a","B b","C c","D d","E e",
      "F f","G g","H h","I i","J j"
     };
   color clr[10]=
     {
      clrRed,clrGreen,clrBlue,clrSlateBlue,clrBlueViolet,
      clrDeepPink,clrSeaGreen,clrGreen,clrBurlyWood,clrDarkGreen
     };
//---
   double angle=90.0;//íàêëîí òåêñòà
   int x_distance=ChartWidthInPixels()/2;
   int y_distance=ChartHeightInPixelsGet()/2;
//--- Create a text label
   if(ObjectFind(0,nameObj)<0)
     {
      LabelCreate(0,nameObj,0,x_distance,y_distance,"\n",CORNER_LEFT_UPPER,
                  text[0],"Arial",24,clr[0],angle,ANCHOR_LEFT_UPPER);
     }
//---
   ChartRedraw();
   Sleep(1000);
//---
   int i=0;
   while(angle>0 && !IsStopped())
     {
      angle=angle-10;
      i=i+1;
      //---
      ObSetDouble(0,nameObj,OBJPROP_ANGLE,angle);
      ObSetString(0,nameObj,OBJPROP_TEXT,text[i]);
      ObSetIntegerColor(0,nameObj,OBJPROP_COLOR,clr[i]);
      //---
      ChartRedraw();
      Sleep(1000);
     }
//---
   ObDelete(0,nameObj);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Gets the width of chart (in pixels)                              |
//| MQL5 Reference / Standard Constants, Enumerations and Structures | 
//| /  Chart Constants / Examples of Working with the Chart          |
//+------------------------------------------------------------------+
int ChartWidthInPixels(const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_WIDTH_IN_PIXELS,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+
//| Gets the height of chart (in pixels)                             |
//| MQL5 Reference / Standard Constants, Enumerations and Structures |
//| /  Chart Constants / Examples of Working with the Chart          |
//+------------------------------------------------------------------+
int ChartHeightInPixelsGet(const long chart_ID=0,const int sub_window=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_HEIGHT_IN_PIXELS,sub_window,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+
