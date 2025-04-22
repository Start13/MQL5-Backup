//+------------------------------------------------------------------+
//|                                                 MyCListArrow.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ����� ��������� ��������� ��� �������� �������� Arrow � �����-   |
//| ���� �� �������������, ����� �� ���� ��� ������� ������������    |
//| Arrow-��������.                                                  |
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
#include <MyObjects\MyCArrow.mqh>
//+------------------------------------------------------------------+
//| ����� MyCListArrow                                               |
//+------------------------------------------------------------------+
class MyCListArrow
  {
private:
   CList*            ListArrow;                                    // ��. ���. �� ������ Arrow
public:
                     MyCListArrow();
                    ~MyCListArrow();
   //--- ������ Insert
   void              Insert(); // ���� Arrow
   void              Insert(double Price, datetime Times);         // ���� Arrow
   void              Insert(double Price, datetime Times, 
                            ENUM_OBJECT Type);                     // ���� Arrow
   bool              Insert(string Name, string Tip, double Price, 
                             datetime Times, ENUM_OBJECT Type);    // ���� Arrow
   //--- ������ Set
   bool              SetAtIndexName(int ind, string NewName);      // ����� ���. �����
   bool              SetAtNameOfName(string Name, string NewName); // ����� ���. �����
   bool              SetAtIndexTip(int ind, string NewTip);        // ����� ���. ��������
   bool              SetAtNameOfTip(string Name, string NewTip);   // ����� ���. ��������
   bool              SetAtIndexPrice(int ind, double NewPrice);    // ����� ���. ����
   bool              SetAtNameOfPrice(string Name, double NewPrice);// ����� ���. ����
   bool              SetAtIndexTime(int ind, datetime NewTime);    // ����� ���. ����
   bool              SetAtNameOfTime(string Name, datetime NewTime);// ����� ���. ����
   bool              SetAtIndexType(int ind, ENUM_OBJECT NewType); // ����� ���. ����
   bool              SetAtNameOfType(string Name, ENUM_OBJECT NewType);// ����� ���. ����
   bool              SetAtIndexCode(int ind, int NewCode);        // ����� ���. ���. ����
   bool              SetAtNameOfCode(string Name, int NewCode);   // ����� ���. ���. ����
   bool              SetAtIndexColor(int ind, color NewColor);     // ����� ���. �����
   bool              SetAtNameOfColor(string Name, color NewColor);// ����� ���. �����
   bool              SetAtIndexAnchor(int ind, ENUM_ARROW_ANCHOR ArrowAnchor);// ����� ���. ������������
   bool              SetAtNameOfAnchor(string Name, ENUM_ARROW_ANCHOR ArrowAnchor);// ����� ���. ������������
   //--- M����� Get
   int               GetSize();                                    // ��������� ������� ListArrow
   string            GetLastArrowName();                           // ��������� ���������� �����
   string            GetAtIndexName(int ind);                      // ����� ���. �����
   int               GetAtNameOfIndex(string Name);                // ����� ���. �������
   string            GetAtIndexTip(int ind);                       // ����� ���. ��������
   string            GetAtNameOfTip(string Name);                  // ����� ���. ��������
   double            GetAtIndexPrice(int ind);                     // ����� ���. ����
   double            GetAtNameOfPrice(string Name);                // ����� ���. ����
   datetime          GetAtIndexTime(int ind);                      // ����� ���. �������
   datetime          GetAtNameOfTime(string Name);                 // ����� ���. �������
   ENUM_OBJECT       GetAtIndexType(int ind);                      // ����� ���. ����
   ENUM_OBJECT       GetAtNameOfType(string Name);                 // ����� ���. ����
   int               GetAtIndexCode(int ind);                      // ����� ���. ���. ����
   int               GetAtNameOfCode(string Name);                 // ����� ���. ���. ����
   color             GetAtIndexColor(int ind);                     // ����� ���. �����
   color             GetAtNameOfColor(string Name);                // ����� ���. �����
   ENUM_ARROW_ANCHOR GetAtIndexAnchor(int ind);                    // ����� ���. ������������
   ENUM_ARROW_ANCHOR GetAtNameOfAnchor(string Name);               // ����� ���. ������������
   //--- ������ Delet
   void              ClearAll();                                   // ����� ����!!!
   bool              DeletAtIndex(int ind);                        // ������ ������ �� �������
   bool              DeletAtName(string Name);                     // ������ �� �����
   //--- ������ Find
private:
   //--- ������ Find
   bool              FindName(string Name);                        // ����� �� ����� Arrow
   int               iFindName(string Name);                       // ����� �� ����� Arrow
  };
//+------------------------------------------------------------------+
//| �����������                                                      |
//+------------------------------------------------------------------+
MyCListArrow::MyCListArrow()
  {
   //--- �������� ������
   ListArrow = new CList;
   //--- �����-������ ��� ������ ������
   ListArrow.FreeMode(true);
  }
//+------------------------------------------------------------------+
//| ����������                                                       |
//+------------------------------------------------------------------+
MyCListArrow::~MyCListArrow()
  {
   //---
   if(ListArrow.Total()>0)
     {
      ListArrow.Clear();
     }
   //---
   delete ListArrow;
  }
//+------------------------------------------------------------------+
//| ��������� ������� ListArrow                                      |
//+------------------------------------------------------------------+
int MyCListArrow::GetSize(void)
  {
   return(ListArrow.Total());
  }
//+------------------------------------------------------------------+
//| ���� ������ �� Arrow                                             |
//+------------------------------------------------------------------+
bool MyCListArrow::Insert(string Name,string Tip,double Price,datetime Times,ENUM_OBJECT Type)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- ����� �� ����� �������
   if(ListArrow.Total()>0)
     {
      //--- ����� ������ ������
      if(this.FindName(Name)) return(false); // ���� ���������� �� ����� Arrow!
     }
   //---
   NewArrow = new MyCArrow(Name,Tip,Price,Times,Type);
   ListArrow.Add(NewArrow);
   //---
   return(true);
  }
//+------------------------------------------------------------------+
//| ���� ������ �� Arrow                                             |
//+------------------------------------------------------------------+
void MyCListArrow::Insert(double Price,datetime Times,ENUM_OBJECT Type)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //---
   NewArrow = new MyCArrow(Price,Times,Type);
   ListArrow.Add(NewArrow);
  }
//+------------------------------------------------------------------+
//| ���� ������ �� Arrow                                             |
//+------------------------------------------------------------------+
void MyCListArrow::Insert(double Price,datetime Times)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //---
   NewArrow = new MyCArrow(Price,Times);
   ListArrow.Add(NewArrow);
  }
//+------------------------------------------------------------------+
//| ���� ������ �� Arrow                                             |
//+------------------------------------------------------------------+
void MyCListArrow::Insert()
  {
   //--- ����������
   MyCArrow* NewArrow;
   //---
   NewArrow = new MyCArrow();
   ListArrow.Add(NewArrow);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ����� �� �����                                    |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfColor(string Name,color NewColor)
  {
   //---
   if(ListArrow.Total()>0)
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
//| ����� Set ���. ����� �� �������                                  |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexColor(int ind,color NewColor)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetColor(NewColor));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���. ������� �� �������                           |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexCode(int ind,int NewCode)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetCode(NewCode));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���. ������� �� �����                             |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfCode(string Name,int NewCode)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexCode(ind, NewCode));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ����� �� �������                                  |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexName(int ind,string NewName)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetName(NewName));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ����� �� �������                                  |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfName(string Name,string NewName)
  {
   //---
   if(ListArrow.Total()>0)
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
//| ����� Set ���. �������� �� �������                               |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexTip(int ind,string NewTip)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetTip(NewTip));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. �������� �� �������                               |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfTip(string Name,string NewTip)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexTip(ind, NewTip));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���� �� �������                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexPrice(int ind,double NewPrice)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetPrice(NewPrice));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���� �� �������                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfPrice(string Name,double NewPrice)
  {
   //---
   if(ListArrow.Total()>0)
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
//| ����� Set ���. ���� �� �������                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexTime(int ind,datetime NewTime)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetTime(NewTime));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���� �� �������                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfTime(string Name,datetime NewTime)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexTime(ind, NewTime));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���� �� �������                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexType(int ind,ENUM_OBJECT NewType)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetType(NewType));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� Set ���. ���� �� �������                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfType(string Name,ENUM_OBJECT NewType)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexType(ind, NewType));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������������                                          |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtIndexAnchor(int ind,ENUM_ARROW_ANCHOR ArrowAnchor)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.SetAnchor(ArrowAnchor));
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������������                                          |
//+------------------------------------------------------------------+
bool MyCListArrow::SetAtNameOfAnchor(string Name,ENUM_ARROW_ANCHOR ArrowAnchor)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.SetAtIndexAnchor(ind, ArrowAnchor));
        }
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
string MyCListArrow::GetAtIndexName(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetName());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| �������� ��� ���������� �������� � ������                        |
//+------------------------------------------------------------------+
string MyCListArrow::GetLastArrowName(void)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>0)
     {
      //---
      NewArrow = ListArrow.GetLastNode();
      //---
      return(NewArrow.GetName());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ��� ����� �� �������                                       |
//+------------------------------------------------------------------+
color MyCListArrow::GetAtIndexColor(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetColor());
     }
   //--- ������ ����
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ��������� ����� �� �����                                   |
//+------------------------------------------------------------------+
color MyCListArrow::GetAtNameOfColor(string Name)
  {
   //---
   if(ListArrow.Total()>0)
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
//| ����� ���. ���. ���� �� �������                                  |
//+------------------------------------------------------------------+
int MyCListArrow::GetAtIndexCode(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetCode());
     }
   //--- ������ ����
   return(-1);
  }
//+------------------------------------------------------------------+
//| ����� ���. ���. ���� �� �����                                    |
//+------------------------------------------------------------------+
int MyCListArrow::GetAtNameOfCode(string Name)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexCode(ind));
        }
     }
   //---Error
   return(-1);
  }
//+------------------------------------------------------------------+
//| ����� ���. �����                                                 |
//+------------------------------------------------------------------+
int MyCListArrow::GetAtNameOfIndex(string Name)
  {
   return(this.iFindName(Name));
  }
//+------------------------------------------------------------------+
//| ����� ���. ��������                                              |
//+------------------------------------------------------------------+
string MyCListArrow::GetAtIndexTip(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetTip());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ��������                                              |
//+------------------------------------------------------------------+
string MyCListArrow::GetAtNameOfTip(string Name)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexTip(ind));
        }
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����                                                  |
//+------------------------------------------------------------------+
double MyCListArrow::GetAtIndexPrice(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetPrice());
     }
   //---
   return(-1.0);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����                                                  |
//+------------------------------------------------------------------+
double MyCListArrow::GetAtNameOfPrice(string Name)
  {
   //---
   if(ListArrow.Total()>0)
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
//| ����� ���. �������                                               |
//+------------------------------------------------------------------+
datetime MyCListArrow::GetAtIndexTime(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetTime());
     }
   //---
   return(NULL);// ��������� �����
  }
//+------------------------------------------------------------------+
//| ����� ���. �������                                               |
//+------------------------------------------------------------------+
datetime MyCListArrow::GetAtNameOfTime(string Name)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexTime(ind));
        }
     }
   //---
   return(NULL);// ��������� �����
  }
//+------------------------------------------------------------------+
//| ����� ���. ����                                                  |
//+------------------------------------------------------------------+
ENUM_OBJECT MyCListArrow::GetAtIndexType(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetType());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ����                                                  |
//+------------------------------------------------------------------+
ENUM_OBJECT MyCListArrow::GetAtNameOfType(string Name)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexType(ind));
        }
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������������                                          |
//+------------------------------------------------------------------+
ENUM_ARROW_ANCHOR MyCListArrow::GetAtIndexAnchor(int ind)
  {
   //--- ����������
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>ind)
     {
      //---
      NewArrow = ListArrow.GetNodeAtIndex(ind);
      //---
      return(NewArrow.GetAnchor());
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� ���. ������������                                          |
//+------------------------------------------------------------------+
ENUM_ARROW_ANCHOR MyCListArrow::GetAtNameOfAnchor(string Name)
  {
   //---
   if(ListArrow.Total()>0)
     {
      int ind = this.iFindName(Name);
      //---
      if(ind>-1)
        {
         return(this.GetAtIndexAnchor(ind));
        }
     }
   //---
   return(NULL);
  }
//+------------------------------------------------------------------+
//| ����� �� ����� Arrow                                             |
//+------------------------------------------------------------------+
bool MyCListArrow::FindName(string Name)
  {
   //--- ����������
   int ind = 0;
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>0)
     {
      //--- ��������� ����
      while(ind<ListArrow.Total())
        {
         //--- �������� ��������� �� ������ Arrow
         NewArrow = ListArrow.GetNodeAtIndex(ind);
         //--- ���������� ��� ������ �� ���������
         if(Name == NewArrow.GetName())
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
int MyCListArrow::iFindName(string Name)
  {
   //---
   int ind = 0;
   int ret = -1;
   MyCArrow* NewArrow;
   //--- 
   if(ListArrow.Total()>0)
     {
      //--- ��������� ����
      while(ind<ListArrow.Total())
        {
         //--- �������� ��������� �� ������ Arrow
         NewArrow = ListArrow.GetNodeAtIndex(ind);
         //--- ���������� ��� ������ �� ���������
         if(Name == NewArrow.GetName())
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
//| ����� ����!!!                                                    |
//+------------------------------------------------------------------+
void MyCListArrow::ClearAll(void)
  {
   //---
   if(ListArrow.Total()>0)
     {
      ListArrow.Clear();
     }
  }
//+------------------------------------------------------------------+
//| ����� �� �������                                                 |
//+------------------------------------------------------------------+
bool MyCListArrow::DeletAtIndex(int ind)
  {
   //---
   if(ListArrow.Total()>ind)
     {
      return(ListArrow.Delete(ind));
     }
   //---
   return(false); // ��� ������ �������!!!
  }
//+------------------------------------------------------------------+
//| ����� �� �����                                                   |
//+------------------------------------------------------------------+
bool MyCListArrow::DeletAtName(string Name)
  {
   //---
   if(ListArrow.Total()>0)
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