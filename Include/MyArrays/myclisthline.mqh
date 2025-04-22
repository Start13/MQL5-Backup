//+------------------------------------------------------------------+
//|                                                 MyCListHLine.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ����� ��������� ��������� ��� �������� �������� HLine � �����-   |
//| ���� �� �������������, ����� �� ���� ��� ������� ������������    |
//| HLine-��������.                                                  |
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
#include <MyObjects\MyCHLine.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyCListHLine
  {
private:
   CList*            ListHLine;                                    // ��. ���. �� ������ HLine
public:
                     MyCListHLine();
                    ~MyCListHLine();
   //--- ������ Insert
   void              Insert(void);                                 // ���� HLine
   void              Insert(double Price);                         // ���� HLine + ����������
   void              Insert(double Price, ENUM_LINE_STYLE Style);  // ���� HLine + ���������� + style
   bool              Insert(string Name, double Price, 
                            ENUM_LINE_STYLE Style);                // ���� HLine + ���������� + style + name   
   //--- ������ Set
   bool              SetAtIndexName(int ind, string NewName);      // ����� ���. �����
   bool              SetAtNameOfName(string Name, string NewName); // ����� ���. �����
   bool              SetAtIndexPrice(int ind, double NewPrice);    // ����� ���. ���� 
   bool              SetAtNameOfPrice(string Name, double NewPrice);//����� ���. ���� 
   bool              SetAtIndexColor(int ind, color NewColor);     // ����� ���. �����
   bool              SetAtNameOfColor(string Name, color NewColor);// ����� ���. �����
   bool              SetAtIndexStyle(int ind, ENUM_LINE_STYLE style);// ����� ���. �����
   bool              SetAtNameOfStyle(string Name, ENUM_LINE_STYLE style);// ����� ���. �����
   bool              SetAtIndexWidth(int ind, int width);          // ����� ���. �������
   bool              SetAtNameOfWidth(string Name, int width);     // ����� ���. �������
   bool              SetAtIndexBack(int ind, bool back);           // ����� ���. "������ ����"
   bool              SetAtNameOfBack(string Name, bool back);      // ����� ���. "������ ����"
   bool              SetAtIndexHidden(int ind, bool hidden);       // ����� ���. "������ � ������"
   bool              SetAtNameOfHidden(string Name, bool hidden);  // ����� ���. "������ � ������"   
   //--- M����� Get
   int               GetSize();                                    // ��������� ������� ListTrendLine
   string            GetAtIndexName(int ind);                      // ����� ���. �����
   string            GetLastHLineName();                           // ��������� ���������� �����
   string            GetLastName(){return(GetLastHLineName());};   // ��������� ���������� �����
   int               GetAtNameOfIndex(string Name);                // ����� ���. �������
   double            GetAtIndexPrice(int ind);                     // ����� ���. ����  �� ������ �������
   double            GetAtNameOfPrice(string Name);                // ����� ���. ����  �� �����  �������
   color             GetAtIndexColor(int ind);                     // ����� ���. ����� �� �������
   color             GetAtNameOfColor(string Name);                // ����� ���. ����� �� �����
   ENUM_LINE_STYLE   GetAtIndexStyle(int ind);                     // ����� ���. ���� �� �������
   ENUM_LINE_STYLE   GetAtNameOfStyle(string Name);                // ����� ���. ���� �� �����
   int               GetAtIndexWidth(int ind);                     // ����� ���. ������� ����� �� �������
   int               GetAtNameOfWidth(string Name);                // ����� ���. ������� ����� �� �����
   bool              GetAtIndexBack(int ind);                      // ����� ���. "������ ����" ����� �� �������
   bool              GetAtNameOfBack(string Name);                 // ����� ���. "������ ����" ����� �� �����
   bool              GetAtIndexHidden(int ind);                    // ����� ���. "������ � ������" ����� �� �������
   bool              GetAtNameOfHidden(string Name);               // ����� ���. "������ � ������" ����� �� �����
   //--- ������ Delet
   void              ClearAll();                                   // ����� ����!!!
   bool              DeletAtIndex(int ind);                        // ������ ������ �� �������
   bool              DeletAtName(string Name);                     // ������ �� �����
private:
   //--- ������ Find
   bool              FindName(string Name);                        // ����� �� ����� HLine
   int               iFindName(string Name);                       // ����� �� ����� HLine
  };
//+------------------------------------------------------------------+
//| �����������                                                      |
//+------------------------------------------------------------------+
MyCListHLine::MyCListHLine()
  {
   //--- �������� ������
   ListHLine = new CList;
   //--- �����-������ ��� ������ ������
   ListHLine.FreeMode(true);
  }
//+------------------------------------------------------------------+
//| ����������                                                       |
//+------------------------------------------------------------------+
MyCListHLine::~MyCListHLine()
  {
   //---
   if(ListHLine.Total()>0)
     {
      ListHLine.Clear();
     }
   //---
   delete ListHLine;
  }
//+------------------------------------------------------------------+
//| Insert ������                                                    |
//+------------------------------------------------------------------+
//| ������� Insert                                                   |
//+------------------------------------------------------------------+
void MyCListHLine::Insert(void)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //---
   NewHLine = new MyCHLine();
   ListHLine.Add(NewHLine);
  }
//+------------------------------------------------------------------+
//| Insert + ����������                                              |
//+------------------------------------------------------------------+
void MyCListHLine::Insert(double Price)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //---
   NewHLine = new MyCHLine(Price);
   ListHLine.Add(NewHLine);
  }
//+------------------------------------------------------------------+
//| Insert + ���������� + style                                      |
//+------------------------------------------------------------------+
void MyCListHLine::Insert(double Price,ENUM_LINE_STYLE Style)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //---
   NewHLine = new MyCHLine(Price,Style);
   ListHLine.Add(NewHLine);
  }
//+------------------------------------------------------------------+
//| Insert + ���������� + style + name                               |
//+------------------------------------------------------------------+
bool MyCListHLine::Insert(string Name,double Price,ENUM_LINE_STYLE Style)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- ����� �� ����� �������
   if(ListHLine.Total()>0)
     {
      //--- ����� ������ ������
      if(this.FindName(Name)) return(false); // ���� ���������� �� ����� HLine
     }
   //---
   NewHLine = new MyCHLine(Name,Price,Style);
   ListHLine.Add(NewHLine);
   //---
   return(true);
  }
//+------------------------------------------------------------------+
//| ��������� SET...                                                 |
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtIndexName(int ind,string NewName)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetName(NewName));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfName(string Name,string NewName)
  {
   //---
   if(ListHLine.Total()>0)
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
//| ����� ���. ����                                                  |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtIndexPrice(int ind,double NewPrice)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetPrice(NewPrice));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����                                                  |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfPrice(string Name,double NewPrice)
  {
   //---
   if(ListHLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexPrice(ind, NewPrice));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtIndexColor(int ind,color NewColor)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetColor(NewColor));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfColor(string Name,color NewColor)
  {
   //---
   if(ListHLine.Total()>0)
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
bool MyCListHLine::SetAtIndexStyle(int ind,ENUM_LINE_STYLE style)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetStyle(style));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfStyle(string Name,ENUM_LINE_STYLE style)
  {
   //---
   if(ListHLine.Total()>0)
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
bool MyCListHLine::SetAtIndexWidth(int ind,int width)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetWidth(width));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �������                                               |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfWidth(string Name,int width)
  {
   //---
   if(ListHLine.Total()>0)
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
bool MyCListHLine::SetAtIndexBack(int ind,bool back)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetBack(back));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ ����"                                         |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfBack(string Name,bool back)
  {
   //---
   if(ListHLine.Total()>0)
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
//| ����� ���. "������ � ������"                                     |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtIndexHidden(int ind,bool hidden)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.SetHidden(hidden));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ � ������"                                     |
//+------------------------------------------------------------------+
bool MyCListHLine::SetAtNameOfHidden(string Name,bool hidden)
  {
   //---
   if(ListHLine.Total()>0)
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
//| ��������� ������� ListHLine                                      |
//+------------------------------------------------------------------+
int MyCListHLine::GetSize(void)
  {
   return(ListHLine.Total());
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �������                                      |
//+------------------------------------------------------------------+
string MyCListHLine::GetAtIndexName(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetName());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ��������� ���������� ����� � ������                              |
//+------------------------------------------------------------------+
string MyCListHLine::GetLastHLineName(void)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>0)
     {
      //---
      NewHLine = ListHLine.GetLastNode();
      //---
      return(NewHLine.GetName());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� �� �����(�������������)                       |
//+------------------------------------------------------------------+
int MyCListHLine::GetAtNameOfIndex(string Name)
  {
   return(this.iFindName(Name));
  }
//+------------------------------------------------------------------+
//| ����� ���. ����   �� ������                                      |
//+------------------------------------------------------------------+
double MyCListHLine::GetAtIndexPrice(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetPrice());
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����   �� �����  �������                              |
//+------------------------------------------------------------------+
double MyCListHLine::GetAtNameOfPrice(string Name)
  {
   //---
   if(ListHLine.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexPrice(ind));
        }
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �������                                      |
//+------------------------------------------------------------------+
color MyCListHLine::GetAtIndexColor(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetColor());
     }
   //--- ������ ����
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �����                                        |
//+------------------------------------------------------------------+
color MyCListHLine::GetAtNameOfColor(string Name)
  {
   //---
   if(ListHLine.Total()>0)
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
ENUM_LINE_STYLE MyCListHLine::GetAtIndexStyle(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetStyle());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����� �� �����                                        |
//+------------------------------------------------------------------+
ENUM_LINE_STYLE MyCListHLine::GetAtNameOfStyle(string Name)
  {
   //---
   if(ListHLine.Total()>0)
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
int MyCListHLine::GetAtIndexWidth(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetWidth());
     }
   //---
   return(-1);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������� ����� �� �����                                |
//+------------------------------------------------------------------+
int MyCListHLine::GetAtNameOfWidth(string Name)
  {
   //---
   if(ListHLine.Total()>0)
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
bool MyCListHLine::GetAtIndexBack(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetBack());
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ ����" ����� �� �����                          |
//+------------------------------------------------------------------+
bool MyCListHLine::GetAtNameOfBack(string Name)
  {
   //---
   if(ListHLine.Total()>0)
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
//| ����� ���. "������ � ������" ����� �� �������                    |
//+------------------------------------------------------------------+
bool MyCListHLine::GetAtIndexHidden(int ind)
  {
   //--- ����������
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>ind)
     {
      //---
      NewHLine = ListHLine.GetNodeAtIndex(ind);
      //---
      return(NewHLine.GetHidden());
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. "������ � ������" ����� �� �����                      |
//+------------------------------------------------------------------+
bool MyCListHLine::GetAtNameOfHidden(string Name)
  {
   //---
   if(ListHLine.Total()>0)
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
void MyCListHLine::ClearAll(void)
  {
   //---
   if(ListHLine.Total()>0)
     {
      ListHLine.Clear();
     }
  }
//+------------------------------------------------------------------+
//| ����� �� �������                                                 |
//+------------------------------------------------------------------+
bool MyCListHLine::DeletAtIndex(int ind)
  {
   //---
   if(ListHLine.Total()>ind)
     {
      return(ListHLine.Delete(ind));
     }
   //---
   return(false); // ��� ������ �������!!!
  }
//+------------------------------------------------------------------+
//| ����� �� �����                                                   |
//+------------------------------------------------------------------+
bool MyCListHLine::DeletAtName(string Name)
  {
   //---
   if(ListHLine.Total()>0)
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
//| ����� �� ����� HLine                                             |
//+------------------------------------------------------------------+
bool MyCListHLine::FindName(string Name)
  {
   //--- ����������
   int ind = 0;
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>0)
     {
      //--- ��������� ����
      while(ind<ListHLine.Total())
        {
         //--- �������� ��������� �� ������ HLine
         NewHLine = ListHLine.GetNodeAtIndex(ind);
         //--- ���������� ��� ������ �� ���������
         if(Name == NewHLine.GetName())
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
int MyCListHLine::iFindName(string Name)
  {
   //---
   int ind = 0;
   int ret = -1;
   MyCHLine* NewHLine;
   //--- 
   if(ListHLine.Total()>0)
     {
      //--- ��������� ����
      while(ind<ListHLine.Total())
        {
         //--- �������� ��������� �� ������ HLine
         NewHLine = ListHLine.GetNodeAtIndex(ind);
         //--- ���������� ��� ������ �� ���������
         if(Name == NewHLine.GetName())
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