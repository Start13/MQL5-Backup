//+------------------------------------------------------------------+
//|                                                     MyCHLine.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ������� ����� ��� ����������� � �������� �������� ��������. �����|
//| ������ ��� ���������� ������ � ������������ ��������� � �����-   |
//| ����� ��. ������ MyCListHLine   -   ������ �������� �����/�����. |
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
class MyCHLine : public CObject
  {
private:
   string            HLineName;                            //1  ���    ������� 
   double            HLinePrice;                           //2  ����   ������� 
   ENUM_LINE_STYLE   HLineStyle;                           //3  �����  �������
   //--- "���������" ������� /��������������/
   color             HLineColor;                           //4  ����         
   int               HLineWidth;                           //5  �������
   bool              HLineBack;                            //6  ������ ����(������� ������� �� �������)
   bool              HLineHidden;                          //7  "������ � ������ ��������" 
   string            HLineText;                            //8  ����� ��������
   string            HLineTip;                             //9  ����� ���������
public:
                     MyCHLine();
                    ~MyCHLine();
   //--- ������������ � ����������� 
                     MyCHLine(double price);
                     MyCHLine(double price,ENUM_LINE_STYLE style);
                     MyCHLine(string name,double price,ENUM_LINE_STYLE style);
   //--- ������ Set-��������� �������
   bool              SetName(string name);                 // ����������  ���   ������� 
   bool              SetPrice(double price);               // ����������  ����  ������� 
   bool              SetColor(color col);                  // ����������  ����         
   bool              SetStyle(ENUM_LINE_STYLE style);      // ����������  �����
   bool              SetWidth(int width);                  // ����������  �������
   bool              SetBack(bool back);                   // ����������  "������ ����"
   bool              SetHidden(bool hidden);               // ����������  "������ � ������ ��������"
   bool              SetText(string text);                 // ����������  �����
   bool              SetTip(string tip);                   // ����������  "���������"
   //--- M����� Get-��������� �������
   string            GetName(void){return(HLineName);};    // ��������  ���     ������� 
   double            GetPrice(void){return(HLinePrice);};  // ��������  ����    ������� 
   color             GetColor(void){return(HLineColor);};  // ��������  ����         
   ENUM_LINE_STYLE   GetStyle(void){return(HLineStyle);};  // ��������  �����
   int               GetWidth(void){return(HLineWidth);};  // ��������  �������
   bool              GetBack(void){return(HLineBack);};    // ��������  "������ ����"
   bool              GetHidden(void){return(HLineHidden);};// �������� "������ � ������ ��������"
   string            GetText(void){return(HLineText);};    // �������� ����� ��������
   string            GetTip(void){return(HLineTip);};      // �������� ���������(�����)
private:
   string            GenerateRandName(void);               // ������������ ��������� ���               
   void              CreateHLine(void);                    // ����� �� ����� �������
   void              DeletHLine(void);                     // �������� �������
  };
//+------------------------------------------------------------------+
//| ����������� ��� ����������                                       |
//+------------------------------------------------------------------+
MyCHLine::MyCHLine()
  {
   //--- "����������"
   MqlTick last_tick;
   //--- 1.
   this.HLineName   = this.GenerateRandName();
   //--- 2. 
   if(SymbolInfoTick(_Symbol,last_tick))
     {//--- �������� ������� �������� ���� � �������
      this.HLinePrice = last_tick.ask;
     }
     else
       {//--- �� ����������, ������������� "����"
        this.HLinePrice = 0;
       }
   //--- 3. 
   this.HLineStyle  = STYLE_SOLID;
   //--- 4.
   this.HLineColor  = clrRed;
   //--- 5.
   this.HLineWidth  = 1;
   //--- 6.
   this.HLineBack   = false;
   //--- 7.
   this.HLineHidden = true;
   //--- 8.
   this.HLineText   = NULL;
   //--- 9. 
   this.HLineTip    = NULL;   
   //--- � ������ ����� ������� ������
   this.CreateHLine();   
  }
//+------------------------------------------------------------------+
//| �������������                                                    |
//+------------------------------------------------------------------+
MyCHLine::~MyCHLine()
  {
   //---
   if(ObjectFind(0, this.HLineName) >= 0)
     {
      this.DeletHLine();
     }
  }
//+------------------------------------------------------------------+
//| ������������ � �����������                                       |
//+------------------------------------------------------------------+
//| ����������� � �����                                              |
//+------------------------------------------------------------------+
MyCHLine::MyCHLine(double price)
  {
   //--- 1.
   this.HLineName   = this.GenerateRandName();
   //--- 2. 
   this.HLinePrice  = price;
   //--- 3. 
   this.HLineStyle  = STYLE_SOLID;
   //--- 4.
   this.HLineColor  = clrRed;
   //--- 5.
   this.HLineWidth  = 1;
   //--- 6.
   this.HLineBack   = false;
   //--- 7.
   this.HLineHidden = true;
   //--- 8.
   this.HLineText   = NULL;
   //--- 9. 
   this.HLineTip    = NULL;   
   //--- � ������ ����� ������� ������
   this.CreateHLine();   
  }
//+------------------------------------------------------------------+
//| ����������� � ����� � �����                                      |
//+------------------------------------------------------------------+
MyCHLine::MyCHLine(double price,ENUM_LINE_STYLE style)
  {
   //--- 1.
   this.HLineName   = this.GenerateRandName();
   //--- 2. 
   this.HLinePrice  = price;
   //--- 3. 
   this.HLineStyle  = style;
   //--- 4.
   this.HLineColor  = clrRed;
   //--- 5.
   this.HLineWidth  = 1;
   //--- 6.
   this.HLineBack   = false;
   //--- 7.
   this.HLineHidden = true;
   //--- 8.
   this.HLineText   = NULL;
   //--- 9. 
   this.HLineTip    = NULL;   
   //--- � ������ ����� ������� ������
   this.CreateHLine();   
  }
//+------------------------------------------------------------------+
//| ����������� � ������, ����� � �����                              |
//+------------------------------------------------------------------+
MyCHLine::MyCHLine(string name,double price,ENUM_LINE_STYLE style)
  {
   //--- 1.
   this.HLineName   = name;
   //--- 2. 
   this.HLinePrice  = price;
   //--- 3. 
   this.HLineStyle  = style;
   //--- 4.
   this.HLineColor  = clrRed;
   //--- 5.
   this.HLineWidth  = 1;
   //--- 6.
   this.HLineBack   = false;
   //--- 7.
   this.HLineHidden = true;
   //--- 8.
   this.HLineText   = NULL;
   //--- 9. 
   this.HLineTip    = NULL;   
   //--- � ������ ����� ������� ������
   this.CreateHLine();   
  }
//+------------------------------------------------------------------+
//| ��������� ������ ������                                          |
//+------------------------------------------------------------------+
//| Set ��� �������                                                  |
//+------------------------------------------------------------------+
bool MyCHLine::SetName(string name)
  {
   if(ObjectSetString(0, this.HLineName,OBJPROP_NAME,name))
     {
      //---
      this.HLineName = name;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| Set ����                                                         |
//+------------------------------------------------------------------+
bool MyCHLine::SetPrice(double price)
  {
   if(ObjectSetDouble(0,this.HLineName,OBJPROP_PRICE,0,price))
     {
      //---
      this.HLinePrice = price;
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
bool MyCHLine::SetStyle(ENUM_LINE_STYLE style)
  {
   if(ObjectSetInteger(0,this.HLineName,OBJPROP_STYLE,style))
     {
      //---
      this.HLineStyle = style;
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
bool MyCHLine::SetColor(color col)
  {
   if(ObjectSetInteger(0,this.HLineName,OBJPROP_COLOR,col))
     {
      //---
      this.HLineColor = col;
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
bool MyCHLine::SetWidth(int width)
  {
   if(ObjectSetInteger(0,this.HLineName,OBJPROP_WIDTH,width))
     {
      //---
      this.HLineWidth = width;
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
bool MyCHLine::SetBack(bool back)
  {
   if(ObjectSetInteger(0,this.HLineName,OBJPROP_BACK,back))
     {
      //---
      this.HLineBack = back;
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
bool MyCHLine::SetHidden(bool hidden)
  {
   if(ObjectSetInteger(0,this.HLineName,OBJPROP_HIDDEN,hidden))
     {
      //---
      this.HLineHidden = hidden;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ��������                                        |
//+------------------------------------------------------------------+
bool MyCHLine::SetText(string text)
  {
   if(text != NULL)
     {
      ObjectSetString(0,this.HLineName,OBJPROP_TEXT,this.HLineText);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);
      this.HLineText = text;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ���������                                       |
//+------------------------------------------------------------------+
bool MyCHLine::SetTip(string tip)
  {
   if(tip != NULL)
     {
      ObjectSetString(0,this.HLineName,OBJPROP_TOOLTIP,this.HLineTip);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);      
      this.HLineTip = tip;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| ���������� ������ ������                                         |
//+------------------------------------------------------------------+
//| ������������� ���������� �����                                   |
//+------------------------------------------------------------------+
string MyCHLine::GenerateRandName(void)
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
	  RandName = "No_Name_HLine_"+IntegerToString(MathRand());
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
//| �������� ������� "�������������� �����"                          |
//+------------------------------------------------------------------+
void MyCHLine::CreateHLine(void)
  {
   //--- �������� �������... ���������: 1, 2
   ObjectCreate(0, this.HLineName, OBJ_HLINE, 0, 0, this.HLinePrice);
   //--- ��������� ��������� 3
   ObjectSetInteger(0,this.HLineName,OBJPROP_STYLE,this.HLineStyle);
   //--- ��������� ��������� 4
   ObjectSetInteger(0,this.HLineName,OBJPROP_COLOR,this.HLineColor);
   //--- ��������� ��������� 5
   ObjectSetInteger(0,this.HLineName,OBJPROP_WIDTH,this.HLineWidth);
   //+---------------------------------------------------------------+
   //| �������� ����� ����������� ����� �����, ������� ��������� ��� |
   //| � ���������� ������� ������!                                  |
   //+---------------------------------------------------------------+
   ObjectSetInteger(0,this.HLineName,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,this.HLineName,OBJPROP_SELECTED,false);
   //--- ��������� ��������� 6 
   ObjectSetInteger(0,this.HLineName,OBJPROP_BACK,this.HLineBack);
   //--- ��������� ��������� 7
   ObjectSetInteger(0,this.HLineName,OBJPROP_HIDDEN,this.HLineHidden);
   //--- 8.
   if(this.HLineText != NULL)
     {
      ObjectSetString(0,this.HLineName,OBJPROP_TEXT,this.HLineText);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);
     }
   //--- 9. 
   if(this.HLineTip != NULL)
     {
      ObjectSetString(0,this.HLineName,OBJPROP_TOOLTIP,this.HLineTip);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);
     }
   //---
   ChartRedraw(0);   
  }
//+------------------------------------------------------------------+
//| �������� �� ������                                               |
//+------------------------------------------------------------------+
void MyCHLine::DeletHLine(void)
  {
   ObjectDelete(0, this.HLineName);
   ChartRedraw(0);   
  }
//+------------------------------------------------------------------+
