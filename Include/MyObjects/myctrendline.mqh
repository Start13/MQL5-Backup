//+------------------------------------------------------------------+
//|                                                 MyCTrendLine.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ������� ����� ��� ����������� � �������� �������� ��������� �����|
//| ������ ��� ���������� ������ � ������������ ��������� � �����-   |
//| ����� ��. ������ MyCListTrendLine - ������ �������� ����� �����. |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, A. Emelyanov"
#property link      "A.Emelyanov2010@yandex.ru"
#property version   "1.00"
//+------------------------------------------------------------------+
//| ������������ ����������                                          |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyCTrendLine : public CObject
  {
private:
   //--- "���������" ������� /��������/
   string            TrendLineName;                        //1  ���          ������� 
   double            TrendLinePrice1;                      //2  ����  1      ������� 
   datetime          TrendLineTime1;                       //3  ����� 1      ������� 
   double            TrendLinePrice2;                      //4  ����  2      ������� 
   datetime          TrendLineTime2;                       //5  ����� 2      ������� 
   ENUM_LINE_STYLE   TrendLineStyle;                       //6  �����
   //--- "���������" ������� /��������������/
   color             TrendLineColor;                       //7  ����         
   int               TrendLineWidth;                       //8  �������
   bool              TrendLineBack;                        //9  ������ ����(������� ������� �� �������)
   bool              TrendLineRayLeft;                     //10 ���������� ����� �����
   bool              TrendLineRayRight;                    //11 ���������� ����� ������
   bool              TrendLineHidden;                      //12 "������ � ������ ��������" 
public:
   //--- ��������� ������
                     MyCTrendLine();
                    ~MyCTrendLine();
   //--- ������������ � ����������� 
                     MyCTrendLine(double price1, datetime time1, 
                                  double price2, datetime time2);
                     MyCTrendLine(double price1, datetime time1, double price2, 
                                  datetime time2, ENUM_LINE_STYLE style);
                     MyCTrendLine(string name, double price1, datetime time1, 
                                  double price2, datetime time2, ENUM_LINE_STYLE style);
   //--- ������ Set-��������� �������
   bool              SetName(string name);                       // ����������  ���          ������� 
   bool              SetPrice1(double price1);                   // ����������  ����  1      ������� 
   bool              SetTime1(datetime time1);                   // ����������  ����� 1      ������� 
   bool              SetPrice2(double price2);                   // ����������  ����  2      ������� 
   bool              SetTime2(datetime time2);                   // ����������  ����� 2      ������� 
   bool              SetColor(color col);                        // ����������  ����         
   bool              SetStyle(ENUM_LINE_STYLE style);            // ����������  �����
   bool              SetWidth(int width);                        // ����������  �������
   bool              SetBack(bool back);                         // ����������  "������ ����"
   bool              SetRayLeft(bool left);                      // ���������� ���������� ����� �����
   bool              SetRayRight(bool right);                    // ���������� ���������� ����� ������
   bool              SetHidden(bool hidden);                     // ���������� "������ � ������ ��������"
   
   //--- M����� Get-��������� �������
   string            GetName(void){return(TrendLineName);};      // ��������  ���          ������� 
   double            GetPrice1(void){return(TrendLinePrice1);};  // ��������  ����  1      ������� 
   datetime          GetTime1(void){return(TrendLineTime1);};    // ��������  ����� 1      ������� 
   double            GetPrice2(void){return(TrendLinePrice2);};  // ��������  ����  2      ������� 
   datetime          GetTime2(void){return(TrendLineTime2);};    // ��������  ����� 2      ������� 
   color             GetColor(void){return(TrendLineColor);};    // ��������  ����         
   ENUM_LINE_STYLE   GetStyle(void){return(TrendLineStyle);};    // ��������  �����
   int               GetWidth(void){return(TrendLineWidth);};    // ��������  �������
   bool              GetBack(void){return(TrendLineBack);};      // ��������  "������ ����"
   bool              GetRayLeft(void){return(TrendLineRayLeft);};// �������� ���������� ����� �����
   bool              GetRayRight(void){return(TrendLineRayRight);};// �������� ���������� ����� ������
   bool              GetHidden(void){return(TrendLineHidden);};  // �������� "������ � ������ ��������"
private:
   //--- ��������� ������
   void              CreateTrend(void);                    // ����� �� ����� �������
   void              DeletTrend(void);                     // �������� �� ������
   string            GenerateRandName();                   // ������������ ��������� ���               
  };
//+------------------------------------------------------------------+
//| ����������� ��� ����������                                       |
//+------------------------------------------------------------------+
MyCTrendLine::MyCTrendLine()
  {
   //--- "����������"
   MqlTick last_tick;
   //--- 1.
   this.TrendLineName = this.GenerateRandName();
   //--- 2-5. 
   if(SymbolInfoTick(_Symbol,last_tick))
     {//--- �������� ������� �������� ���� � �������
      this.TrendLinePrice1 = last_tick.ask;
      this.TrendLineTime1  = last_tick.time;
      this.TrendLinePrice2 = last_tick.bid;
      this.TrendLineTime2  = last_tick.time-_Period;
     }
     else
       {//--- �� ����������, ������������� "����"
        this.TrendLinePrice1 = 0;
        this.TrendLineTime1  = D'1970.01.01 12:00:00';
        this.TrendLinePrice2 = 0.01;
        this.TrendLineTime2  = D'1970.01.01 12:00:00'+_Period;
       }
   //--- 6. 
   this.TrendLineStyle = STYLE_SOLID;
   //--- 7.
   this.TrendLineColor = clrRed;
   //--- 8.
   this.TrendLineWidth = 1;
   //--- 9.
   this.TrendLineBack = false;
   //--- 10-11.
   this.TrendLineRayLeft  = false;
   this.TrendLineRayRight = false;
   //--- 12.
   this.TrendLineHidden = true;
   //--- � ������ ����� ������� ������
   this.CreateTrend();
  }
//+------------------------------------------------------------------+
//| �������������                                                    |
//+------------------------------------------------------------------+
MyCTrendLine::~MyCTrendLine()
  {
   //---
   if(ObjectFind(0, this.TrendLineName) >= 0)
     {
      this.DeletTrend();
     }
  }
//+------------------------------------------------------------------+
//| ������������ � �����������                                       |
//+------------------------------------------------------------------+
//| ����������� � ������������                                       |
//+------------------------------------------------------------------+
MyCTrendLine::MyCTrendLine(double price1,datetime time1,double price2,datetime time2)
  {
   //--- 1.
   this.TrendLineName = this.GenerateRandName();
   //--- 2-5. 
   this.TrendLinePrice1 = price1;
   this.TrendLineTime1  = time1;
   this.TrendLinePrice2 = price2;
   this.TrendLineTime2  = time2;
   //--- 6. 
   this.TrendLineStyle = STYLE_SOLID;
   //--- 7.
   this.TrendLineColor = clrRed;
   //--- 8.
   this.TrendLineWidth = 1;
   //--- 9.
   this.TrendLineBack = false;
   //--- 10-11.
   this.TrendLineRayLeft  = false;
   this.TrendLineRayRight = false;
   //--- 12.
   this.TrendLineHidden = true;
   //--- � ������ ����� ������� ������
   this.CreateTrend();
  }
//+------------------------------------------------------------------+
//| ����������� � ������������ + ���                                 |
//+------------------------------------------------------------------+
MyCTrendLine::MyCTrendLine(double price1,datetime time1,double price2,datetime time2,ENUM_LINE_STYLE style)
  {
   //--- 1.
   this.TrendLineName = this.GenerateRandName();
   //--- 2-5. 
   this.TrendLinePrice1 = price1;
   this.TrendLineTime1  = time1;
   this.TrendLinePrice2 = price2;
   this.TrendLineTime2  = time2;
   //--- 6. 
   this.TrendLineStyle = style;
   //--- 7.
   this.TrendLineColor = clrRed;
   //--- 8.
   this.TrendLineWidth = 1;
   //--- 9.
   this.TrendLineBack = false;
   //--- 10-11.
   this.TrendLineRayLeft  = false;
   this.TrendLineRayRight = false;
   //--- 12.
   this.TrendLineHidden = true;
   //--- � ������ ����� ������� ������
   this.CreateTrend();
  }
//+------------------------------------------------------------------+
//| ����������� � ������������ + ��� + ���                           |
//| ����������(�����):                                               |
//| ����� ������ ������� ������, �� ��� ������� ����� ���� ������!   |
//+------------------------------------------------------------------+
MyCTrendLine::MyCTrendLine(string name,double price1,datetime time1,double price2,datetime time2,ENUM_LINE_STYLE style)
  {
   //--- 1.
   if(ObjectFind(0,name) < 0)
     {
      this.TrendLineName = name;
     }else this.TrendLineName = this.GenerateRandName();        
   //--- 2-5. 
   this.TrendLinePrice1 = price1;
   this.TrendLineTime1  = time1;
   this.TrendLinePrice2 = price2;
   this.TrendLineTime2  = time2;
   //--- 6. 
   this.TrendLineStyle = style;
   //--- 7.
   this.TrendLineColor = clrRed;
   //--- 8.
   this.TrendLineWidth = 1;
   //--- 9.
   this.TrendLineBack = false;
   //--- 10-11.
   this.TrendLineRayLeft  = false;
   this.TrendLineRayRight = false;
   //--- 12.
   this.TrendLineHidden = true;
   //--- � ������ ����� ������� ������
   this.CreateTrend();
  }
//+------------------------------------------------------------------+
//| ��������� ������ ������                                          |
//+------------------------------------------------------------------+
//| Set ��� �������                                                  |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetName(string name)
  {
   if(ObjectSetString(0, this.TrendLineName,OBJPROP_NAME,name))
     {
      //---
      this.TrendLineName = name;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set ���� 1                                                       |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetPrice1(double price1)
  {
   if(ObjectSetDouble(0,this.TrendLineName,OBJPROP_PRICE,0,price1))
     {
      //---
      this.TrendLinePrice1 = price1;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set time 1                                                       |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetTime1(datetime time1)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_TIME,0,time1))
     {
      //---
      this.TrendLineTime1 = time1;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set price 2                                                      |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetPrice2(double price2)
  {
   if(ObjectSetDouble(0,this.TrendLineName,OBJPROP_PRICE,1,price2))
     {
      //---
      this.TrendLinePrice2 = price2;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set time 2                                                       |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetTime2(datetime time2)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_TIME,1,time2))
     {
      //---
      this.TrendLineTime2 = time2;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set style                                                        |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetStyle(ENUM_LINE_STYLE style)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_STYLE,style))
     {
      //---
      this.TrendLineStyle = style;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set color                                                        |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetColor(color col)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_COLOR,col))
     {
      //---
      this.TrendLineColor = col;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set ������� �������                                              |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetWidth(int width)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_WIDTH,width))
     {
      //---
      this.TrendLineWidth = width;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set "������ ����"                                                |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetBack(bool back)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_BACK,back))
     {
      //---
      this.TrendLineBack = back;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ���������� "���������� ����� �����"                              |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetRayLeft(bool left)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_RAY_LEFT,left))
     {
      //---
      this.TrendLineRayLeft = left;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ���������� ���������� ����� ������                               |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetRayRight(bool right)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_RAY_RIGHT,right))
     {
      //---
      this.TrendLineRayRight = right;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ���������� "������ � ������ ��������"                            |
//+------------------------------------------------------------------+
bool MyCTrendLine::SetHidden(bool hidden)
  {
   if(ObjectSetInteger(0,this.TrendLineName,OBJPROP_HIDDEN,hidden))
     {
      //---
      this.TrendLineHidden = hidden;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ���������� ������ ������                                         |
//+------------------------------------------------------------------+
//| ������������� ���������� �����                                   |
//+------------------------------------------------------------------+
string MyCTrendLine::GenerateRandName(void)
  {
   //---
   int ind = 0;
   string RandName;
   //---
   MathSrand(GetTickCount());
   //--- ���� ������ ������ ���������� �����
   while(ind < 32767)
     {
	  //---
	  RandName = "No_Name_Trend_"+IntegerToString(MathRand());
	  //---
	  if(ObjectFind(0, RandName) < 0)
	    {
		  //---
		  return(RandName);
		 }
	  //---
	  ind++;
	 }
   //---
   return("Error");
  }
//+------------------------------------------------------------------+
//| CreateArrow                                                      |
//+------------------------------------------------------------------+
void MyCTrendLine::CreateTrend(void)
  {
   //--- �������� �������... ���������: 1, 2, 3, 4, 5 
   ObjectCreate(0, this.TrendLineName, OBJ_TREND, 0, this.TrendLineTime1, 
                this.TrendLinePrice1, this.TrendLineTime2, this.TrendLinePrice2);
   //--- ��������� ��������� 6
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_STYLE,this.TrendLineStyle);
   //--- ��������� ��������� 7
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_COLOR,this.TrendLineColor);
   //--- ��������� ��������� 8
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_WIDTH,this.TrendLineWidth);
   //+---------------------------------------------------------------+
   //| �������� ����� ����������� ����� �����, ������� ��������� ��� |
   //| � ���������� ������� ������!                                  |
   //+---------------------------------------------------------------+
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_SELECTED,false);
   //--- ��������� ��������� 9 
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_BACK,this.TrendLineBack);
   //--- ��������� ��������� 10 
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_RAY_LEFT,this.TrendLineRayLeft);
   //--- ��������� ��������� 11 
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_RAY_RIGHT,this.TrendLineRayRight);
   //--- ��������� ��������� 12
   ObjectSetInteger(0,this.TrendLineName,OBJPROP_HIDDEN,this.TrendLineHidden);
   //---
   ChartRedraw(0);   
  }
//+------------------------------------------------------------------+
//| �������� �� ������                                               |
//+------------------------------------------------------------------+
void MyCTrendLine::DeletTrend(void)
  {
   ObjectDelete(0, this.TrendLineName);
   ChartRedraw(0);   
  }
//+------------------------------------------------------------------+
