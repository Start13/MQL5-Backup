//+------------------------------------------------------------------+
//|                                             MyCListTrendLine.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ����� ��������� ��������� ��� �������� �������� Trend � �����-   |
//| ���� �� �������������, ����� �� ���� ��� ������� ������������    |
//| Trend-��������.                                                  |
//| ������: ������ - ��� ��������� ������!                           |
//| ������ ��� ��������� ��������� �������:                          |
//| CHARTEVENT_OBJECT_CLICK,  CHARTEVENT_OBJECT_DRAG                 |
//| CHARTEVENT_OBJECT_CHANGE, CHARTEVENT_OBJECT_DELETE               |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, A. Emelyanov"
#property link      "A.Emelyanov2010@yandex.ru"
#property version   "1.00"
//+------------------------------------------------------------------+
//| ������������ ����������                                          |
//+------------------------------------------------------------------+
#include <Arrays\List.mqh>
#include <MyObjects\MyCTrendLine.mqh>
//+------------------------------------------------------------------+
//| ����� MyCListTrendLine                                           |
//+------------------------------------------------------------------+
class MyCListTrendLine
  {
private:
   CList*            ListTrendLine;                                // ��. ���. �� ������ Trend
public:
                     MyCListTrendLine();
                    ~MyCListTrendLine();
   //--- ������ Insert
   void              Insert();                                     // ���� Trend
   void              Insert(double Price1, datetime Time1,
                            double Price2, datetime Time2);        // ���� Trend + ����������
   void              Insert(double Price1, datetime Time1, double Price2, 
                            datetime Time2, ENUM_LINE_STYLE Style);// ���� Trend + ���������� + style
   bool              Insert(string Name, double Price1, datetime Time1, double Price2, 
                            datetime Time2, ENUM_LINE_STYLE Style);// ���� Trend+����������+style+name   
   //--- ������ Set
   bool              SetAtIndexName(int ind, string NewName);      // ����� ���. �����
   bool              SetAtNameOfName(string Name, string NewName); // ����� ���. �����
   bool              SetAtIndexPrice1(int ind, double NewPrice);   // ����� ���. ���� 1
   bool              SetAtIndexPrice2(int ind, double NewPrice);   // ����� ���. ���� 2
   bool              SetAtNameOfPrice1(string Name, double NewPrice);// ����� ���. ���� 1
   bool              SetAtNameOfPrice2(string Name, double NewPrice);// ����� ���. ���� 2
   bool              SetAtIndexTime1(int ind, datetime NewTime);   // ����� ���. ���� 1
   bool              SetAtIndexTime2(int ind, datetime NewTime);   // ����� ���. ���� 2
   bool              SetAtNameOfTime1(string Name, datetime NewTime);// ����� ���. ���� 1
   bool              SetAtNameOfTime2(string Name, datetime NewTime);// ����� ���. ���� 2
   bool              SetAtIndexColor(int ind, color NewColor);     // ����� ���. �����
   bool              SetAtNameOfColor(string Name, color NewColor);// ����� ���. �����
   bool              SetAtIndexStyle(int ind, ENUM_LINE_STYLE style);// ����� ���. �����
   bool              SetAtNameOfStyle(string Name, ENUM_LINE_STYLE style);// ����� ���. �����
   bool              SetAtIndexWidth(int ind, int width);          // ����� ���. �������
   bool              SetAtNameOfWidth(string Name, int width);     // ����� ���. �������
   bool              SetAtIndexBack(int ind, bool back);           // ����� ���. "������ ����"
   bool              SetAtNameOfBack(string Name, bool back);      // ����� ���. "������ ����"
   bool              SetAtIndexRayLeft(int ind, bool left);        // ����� ���. "��� �����"
   bool              SetAtNameOfRayLeft(string Name, bool left);   // ����� ���. "��� �����"
   bool              SetAtIndexRayRight(int ind, bool right);      // ����� ���. "��� ������"
   bool              SetAtNameOfRayRight(string Name, bool rigth); // ����� ���. "��� ������"
   bool              SetAtIndexHidden(int ind, bool hidden);       // ����� ���. "������ � ������"
   bool              SetAtNameOfHidden(string Name, bool hidden);  // ����� ���. "������ � ������"
   //--- M����� Get
   int               GetSize();                                    // ��������� ������� ListTrendLine
   string            GetAtIndexName(int ind);                      // ����� ���. �����
   string            GetLastTrendName();                           // ��������� ���������� �����
   string            GetLastName(){return(GetLastTrendName());};   // ��������� ���������� �����
   int               GetAtNameOfIndex(string Name);                // ����� ���. �������
   double            GetAtIndexPrice1(int ind);                    // ����� ���. ���� 1 �� ������ �������
   double            GetAtIndexPrice2(int ind);                    // ����� ���. ���� 2 �� ������ �������
   double            GetAtNameOfPrice1(string Name);               // ����� ���. ���� 1 �� �����  �������
   double            GetAtNameOfPrice2(string Name);               // ����� ���. ���� 2 �� �����  �������
   datetime          GetAtIndexTime1(int ind);                     // ����� ���. ������� 1 �� �������
   datetime          GetAtIndexTime2(int ind);                     // ����� ���. ������� 2 �� �������
   datetime          GetAtNameOfTime1(string Name);                // ����� ���. ������� 1 �� �����
   datetime          GetAtNameOfTime2(string Name);                // ����� ���. ������� 2 �� �����
   color             GetAtIndexColor(int ind);                     // ����� ���. ����� �� �������
   color             GetAtNameOfColor(string Name);                // ����� ���. ����� �� �����
   ENUM_LINE_STYLE   GetAtIndexStyle(int ind);                     // ����� ���. ���� �� �������
   ENUM_LINE_STYLE   GetAtNameOfStyle(string Name);                // ����� ���. ���� �� �����
   int               GetAtIndexWidth(int ind);                     // ����� ���. ������� ����� �� �������
   int               GetAtNameOfWidth(string Name);                // ����� ���. ������� ����� �� �����
   bool              GetAtIndexBack(int ind);                      // ����� ���. "������ ����" ����� �� �������
   bool              GetAtNameOfBack(string Name);                 // ����� ���. "������ ����" ����� �� �����
   bool              GetAtIndexRayLeft(int ind);                   // ����� ���. "��� �����" ����� �� �������
   bool              GetAtNameOfRayLeft(string Name);              // ����� ���. "��� �����" ����� �� �����
   bool              GetAtIndexRayRight(int ind);                  // ����� ���. "��� ������" ����� �� �������
   bool              GetAtNameOfRayRight(string Name);             // ����� ���. "��� ������" ����� �� �����
   bool              GetAtIndexHidden(int ind);                    // ����� ���. "������ � ������" ���. �� �������
   bool              GetAtNameOfHidden(string Name);               // ����� ���. "������ � ������" ���. �� �����
   //--- ������ Delet
   void              ClearAll();                                   // ����� ����!!!
   bool              DeletAtIndex(int ind);                        // ������ ������ �� �������
   bool              DeletAtName(string Name);                     // ������ �� �����
private:
   //--- ������ Find
   bool              FindName(string Name);                        // ����� �� ����� Trend
   int               iFindName(string Name);                       // ����� �� ����� Trend
  };
//+------------------------------------------------------------------+
//| �����������                                                      |
//+------------------------------------------------------------------+
MyCListTrendLine::MyCListTrendLine()
  {
   //--- �������� ������
   ListTrendLine = new CList;
   //--- �����-������ ��� ������ ������
   ListTrendLine.FreeMode(true);
  }
//+------------------------------------------------------------------+
//| ����������                                                       |
//+------------------------------------------------------------------+
MyCListTrendLine::~MyCListTrendLine()
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      ListTrendLine.Clear();
     }
   //---
   delete ListTrendLine;
  }
//+------------------------------------------------------------------+
//| Insert ������                                                    |
//+------------------------------------------------------------------+
//| ������� Insert                                                   |
//+------------------------------------------------------------------+
void MyCListTrendLine::Insert(void)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //---
   NewTrend = new MyCTrendLine();
   ListTrendLine.Add(NewTrend);
  }
//+------------------------------------------------------------------+
//| Insert + ����������                                              |
//+------------------------------------------------------------------+
void MyCListTrendLine::Insert(double Price1,datetime Time1,double Price2,datetime Time2)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //---
   NewTrend = new MyCTrendLine(Price1, Time1, Price2, Time2);
   //---
   ListTrendLine.Add(NewTrend);
  }
//+------------------------------------------------------------------+
//| Insert + ���������� + style                                      |
//+------------------------------------------------------------------+
void MyCListTrendLine::Insert(double Price1,datetime Time1,
                              double Price2,datetime Time2,ENUM_LINE_STYLE Style)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //---
   NewTrend = new MyCTrendLine(Price1, Time1, Price2, Time2, Style);
   //---
   ListTrendLine.Add(NewTrend);
  }
//+------------------------------------------------------------------+
//| Insert + ���������� + style + name                               |
//+------------------------------------------------------------------+
bool MyCListTrendLine::Insert(string Name,double Price1,datetime Time1,
                              double Price2,datetime Time2,ENUM_LINE_STYLE Style)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- ����� �� ����� �������
   if(ListTrendLine.Total()>0)
     {
      //--- ����� ������ ������
      if(this.FindName(Name)) return(false); // ���� ���������� �� ����� Trend!
     }
   //---
   NewTrend = new MyCTrendLine(Name, Price1, Time1, Price2, Time2, Style);
   //---
   ListTrendLine.Add(NewTrend);
   //---
   return(true);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ������                                          |
//+------------------------------------------------------------------+
//| ��������� SET...                                                 |
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexName(int ind,string NewName)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetName(NewName));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfName(string Name,string NewName)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexName(ind, NewName));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 1                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexPrice1(int ind,double NewPrice)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetPrice1(NewPrice));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 2                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexPrice2(int ind,double NewPrice)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetPrice2(NewPrice));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 1                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfPrice1(string Name,double NewPrice)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexPrice1(ind, NewPrice));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 2                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfPrice2(string Name,double NewPrice)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexPrice2(ind, NewPrice));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 1                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexTime1(int ind,datetime NewTime)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetTime1(NewTime));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 2                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexTime2(int ind,datetime NewTime)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetTime2(NewTime));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 1                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfTime1(string Name,datetime NewTime)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexTime1(ind, NewTime));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 2                                                |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfTime2(string Name,datetime NewTime)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexTime2(ind, NewTime));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexColor(int ind,color NewColor)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetColor(NewColor));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfColor(string Name,color NewColor)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexColor(ind, NewColor));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexStyle(int ind,ENUM_LINE_STYLE style)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetStyle(style));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfStyle(string Name,ENUM_LINE_STYLE style)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexStyle(ind,style));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �������                                               |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexWidth(int ind,int width)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetWidth(width));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �������                                               |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfWidth(string Name,int width)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexWidth(ind,width));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ ����"                                         |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexBack(int ind,bool back)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetBack(back));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ ����"                                         |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfBack(string Name,bool back)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexBack(ind,back));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� �����"                                           |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexRayLeft(int ind,bool left)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetRayLeft(left));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� �����"                                           |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfRayLeft(string Name,bool left)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexRayLeft(ind,left));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� ������"                                          |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexRayRight(int ind,bool right)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetRayRight(right));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� ������"                                          |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfRayRight(string Name,bool rigth)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexRayRight(ind,rigth));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ � ������"                                     |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtIndexHidden(int ind,bool hidden)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.SetHidden(hidden));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ � ������"                                     |
//+------------------------------------------------------------------+
bool MyCListTrendLine::SetAtNameOfHidden(string Name,bool hidden)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexHidden(ind,hidden));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� GET...                                                 |
//+------------------------------------------------------------------+
//| ��������� ������� ListTrend                                      |
//+------------------------------------------------------------------+
int MyCListTrendLine::GetSize(void)
  {
   return(ListTrendLine.Total());
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �������                                      |
//+------------------------------------------------------------------+
string MyCListTrendLine::GetAtIndexName(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetName());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ��������� ���������� ����� � ������                              |
//+------------------------------------------------------------------+
string MyCListTrendLine::GetLastTrendName(void)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>0)
     {
      //---
      NewTrend = ListTrendLine.GetLastNode();
      //---
      return(NewTrend.GetName());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� �� �����(�������������)                       |
//+------------------------------------------------------------------+
int MyCListTrendLine::GetAtNameOfIndex(string Name)
  {
   return(this.iFindName(Name));
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 1 �� ������                                      |
//+------------------------------------------------------------------+
double MyCListTrendLine::GetAtIndexPrice1(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetPrice1());
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 2 �� ������                                      |
//+------------------------------------------------------------------+
double MyCListTrendLine::GetAtIndexPrice2(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetPrice2());
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 1 �� �����  �������                              |
//+------------------------------------------------------------------+
double MyCListTrendLine::GetAtNameOfPrice1(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexPrice1(ind));
        }
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���� 2 �� �����  �������                              |
//+------------------------------------------------------------------+
double MyCListTrendLine::GetAtNameOfPrice2(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexPrice2(ind));
        }
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� 1 �� �������                                  |
//+------------------------------------------------------------------+
datetime MyCListTrendLine::GetAtIndexTime1(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetTime1());
     }
   //---
   return(NULL);// ��������� �����
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� 2 �� �������                                  |
//+------------------------------------------------------------------+
datetime MyCListTrendLine::GetAtIndexTime2(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetTime2());
     }
   //---
   return(NULL);// ��������� �����
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� 1 �� �����                                    |
//+------------------------------------------------------------------+
datetime MyCListTrendLine::GetAtNameOfTime1(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexTime1(ind));
        }
     }
   //---
   return(NULL);// ��������� �����
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� 2 �� �����                                    |
//+------------------------------------------------------------------+
datetime MyCListTrendLine::GetAtNameOfTime2(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexTime2(ind));
        }
     }
   //---
   return(NULL);// ��������� �����
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �������                                      |
//+------------------------------------------------------------------+
color MyCListTrendLine::GetAtIndexColor(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetColor());
     }
   //--- ������ ����
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �����                                        |
//+------------------------------------------------------------------+
color MyCListTrendLine::GetAtNameOfColor(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexColor(ind));
        }
     }
   //---Error
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �������                                      |
//+------------------------------------------------------------------+
ENUM_LINE_STYLE MyCListTrendLine::GetAtIndexStyle(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetStyle());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �����                                        |
//+------------------------------------------------------------------+
ENUM_LINE_STYLE MyCListTrendLine::GetAtNameOfStyle(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexStyle(ind));
        }
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� ����� �� �������                              |
//+------------------------------------------------------------------+
int MyCListTrendLine::GetAtIndexWidth(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetWidth());
     }
   //---
   return(-1);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� ����� �� �����                                |
//+------------------------------------------------------------------+
int MyCListTrendLine::GetAtNameOfWidth(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexWidth(ind));
        }
     }
   //---
   return(-1);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ ����" ����� �� �������                        |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtIndexBack(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetBack());
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ ����" ����� �� �����                          |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtNameOfBack(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexBack(ind));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� �����" ����� �� �������                          |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtIndexRayLeft(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetRayLeft());
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� �����" ����� �� �����                            |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtNameOfRayLeft(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexRayLeft(ind));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� ������" ����� �� �������                         |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtIndexRayRight(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetRayRight());
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "��� ������" ����� �� �����                           |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtNameOfRayRight(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexRayRight(ind));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ � ������" ����� �� �������                    |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtIndexHidden(int ind)
  {
   //--- ����������
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>ind)
     {
      //---
      NewTrend = ListTrendLine.GetNodeAtIndex(ind);
      //---
      return(NewTrend.GetHidden());
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ � ������" ����� �� �����                      |
//+------------------------------------------------------------------+
bool MyCListTrendLine::GetAtNameOfHidden(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexHidden(ind));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� Delet...                                               |
//+------------------------------------------------------------------+
//| ����� ����!!!                                                    |
//+------------------------------------------------------------------+
void MyCListTrendLine::ClearAll(void)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      ListTrendLine.Clear();
     }
  }
//+------------------------------------------------------------------+
//| ����� �� �������                                                 |
//+------------------------------------------------------------------+
bool MyCListTrendLine::DeletAtIndex(int ind)
  {
   //---
   if(ListTrendLine.Total()>ind)
     {
      return(ListTrendLine.Delete(ind));
     }
   //---
   return(false); // ��� ������ �������!!!
  }
//+------------------------------------------------------------------+
//| ����� �� �����                                                   |
//+------------------------------------------------------------------+
bool MyCListTrendLine::DeletAtName(string Name)
  {
   //---
   if(ListTrendLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.DeletAtIndex(ind));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ���������� ������ ������                                         |
//+------------------------------------------------------------------+
//| ����� �� ����� Trend                                             |
//+------------------------------------------------------------------+
bool MyCListTrendLine::FindName(string Name)
  {
   //--- ����������
   int ind = 0;
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>0)
     {
      //--- ��������� ����
      while(ind<ListTrendLine.Total())
        {
         //--- �������� ��������� �� ������ Arrow
         NewTrend = ListTrendLine.GetNodeAtIndex(ind);
         //--- ���������� ��� ������ �� ���������
         if(Name == NewTrend.GetName())
           {
            //--- ������� ���������
            return(true);
           }
         //--- ��������� �������
         ind++;
        }
     }
   //--- ��������� �� �������
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� �����, ������ �������                                      |
//+------------------------------------------------------------------+
//| ret > -1, - ������ ������, ����� ������                          |
//+------------------------------------------------------------------+
int MyCListTrendLine::iFindName(string Name)
  {
   //---
   int ind = 0;
   int ret = -1;
   MyCTrendLine* NewTrend;
   //--- 
   if(ListTrendLine.Total()>0)
     {
      //--- ��������� ����
      while(ind<ListTrendLine.Total())
        {
         //--- �������� ��������� �� ������ Arrow
         NewTrend = ListTrendLine.GetNodeAtIndex(ind);
         //--- ���������� ��� ������ �� ���������
         if(Name == NewTrend.GetName())
           {
            //--- ������� ���������
            ret = ind;
            break;
           }
         //--- ��������� �������
         ind++;
        }
     }
   //--- ��������� �����
   return(ret);
  }
//+------------------------------------------------------------------+