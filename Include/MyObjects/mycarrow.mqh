//+------------------------------------------------------------------+
//|                                                      MyArrow.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ������� ����� ��� ����������� � �������� ������� ���� �������.   |
//| ������ ��� ���������� ������ � ������������ ��������� � �����-   |
//| ����� ��. ������ MyCListArrow - ������ �������� �������.         |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, A. Emelyanov"
#property link      "A.Emelyanov2010@yandex.ru"
#property version   "1.00"
//+------------------------------------------------------------------+
//| ������������ ����������                                          |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| ��� ��� ������ ��� �������� ������������ ������� "�������".      |
//+------------------------------------------------------------------+
class MyCArrow : public CObject
  {
private:
   //--- "���������" ������� MyCArrow /��������/
   string            ArrowName;          // ���          ������� �������
   string            ArrowTip;           // ��������     ������� �������
   double            ArrowPrice;         // ����         ������� �������
   datetime          ArrowTime;          // �����        ������� �������
   ENUM_OBJECT       ArrowType;          // ���          ������� �������
   //--- "���������" ������� MyCArrow /��������������/
   int               ArrowCode;          // ���/�������� ������� �������
   color             ArrowColor;         // ����         ������� �������
   ENUM_ARROW_ANCHOR ArrowAnchor;        // ������������ ������� �������
public:
   //--- ��������� ������
                     MyCArrow(void);
                    ~MyCArrow(void);
   //--- ������������ � ����������� 
                     MyCArrow(double APrice, datetime ATime);  
                     MyCArrow(double APrice, datetime ATime, ENUM_OBJECT AType);  
                     MyCArrow(string AName, string ATip, double APrice, 
                             datetime ATime, ENUM_OBJECT AType);  
   //--- ������ Set
   bool              SetName(string NewName);      // ����� ���. �����
   bool              SetTip(string NewTip);        // ����� ���. ��������
   bool              SetPrice(double NewPrice);    // ����� ���. ����
   bool              SetTime(datetime NewTime);    // ����� ���. ����
   bool              SetType(ENUM_OBJECT NewType); // ����� ���. ����
   //--- ���. ������ Set
   bool              SetCode(int NewCode);         // ����� ���. ���/����
   bool              SetColor(color NewColor);     // ����� ���. �����
   bool              SetAnchor(ENUM_ARROW_ANCHOR Anchor);// ����� ���. ������������
   //--- M����� Get
   string            GetName(void)  {return(ArrowName);};  // ����� ���. �����
   string            GetTip(void)   {return(ArrowTip);};   // ����� ���. ��������
   double            GetPrice(void) {return(ArrowPrice);}; // ����� ���. ����
   datetime          GetTime(void)  {return(ArrowTime);};  // ����� ���. �������
   ENUM_OBJECT       GetType(void)  {return(ArrowType);};  // ����� ���. ����
   //--- ���. ������ Get
   int               GetCode(void)  {return(ArrowCode);};  // ����� ���. ���/����
   color             GetColor(void) {return(ArrowColor);}; // ����� ���. �����
   ENUM_ARROW_ANCHOR GetAnchor(void){return(ArrowAnchor);};// ����� ���. ������������
private:
   //--- ��������� ������
   void              CreateArrow(void);                    // ����� �� ����� �������
   void              DeletArrow(void);                     // �������� �� ������
   string            GenerateRandName();                   // ������������ ��������� ���               
  };
//+------------------------------------------------------------------+
//| ����������� ��� ����������                                       |
//+------------------------------------------------------------------+
MyCArrow::MyCArrow(void)
  {
   //--- "����������"
   MqlTick last_tick;
   //--- �� ���������...
   if(SymbolInfoTick(_Symbol,last_tick))
     {//--- �������� ������� �������� ���� � �������
      this.ArrowPrice = last_tick.ask;
      this.ArrowTime  = last_tick.time;
     }
     else
       {//--- �� ����������, ������������� "����"
        this.ArrowPrice = 0.0;
        this.ArrowTime  = D'1970.01.01 12:00:00';
       }
   //--- 
   this.ArrowName  = GenerateRandName();        
   this.ArrowTip   = "No_Tip";
   this.ArrowType  = OBJ_ARROW;
   this.ArrowCode  = 58;
   this.ArrowColor = clrRed;
   this.ArrowAnchor= ANCHOR_TOP;
   //--- 
   this.CreateArrow();
  }
//+------------------------------------------------------------------+
//| ����������� � �����������                                        |
//+------------------------------------------------------------------+
MyCArrow::MyCArrow(double APrice,datetime ATime,ENUM_OBJECT AType)
  {
   //--- 
   this.ArrowName    = GenerateRandName();        
   this.ArrowTip     = "No_Tip";
   this.ArrowPrice   = APrice;
   this.ArrowTime    = ATime;
   this.ArrowCode    = 58;
   this.ArrowColor   = clrRed;
   this.ArrowAnchor  = ANCHOR_TOP;
   switch(AType)
     {
      case  OBJ_ARROW_BUY:
      case  OBJ_ARROW_SELL:
      case  OBJ_ARROW_STOP:
      case  OBJ_ARROW_CHECK:
      case  OBJ_ARROW_UP:
      case  OBJ_ARROW_DOWN:
      case  OBJ_ARROW_LEFT_PRICE:
      case  OBJ_ARROW_RIGHT_PRICE:
      case  OBJ_ARROW_THUMB_UP:
      case  OBJ_ARROW_THUMB_DOWN:
        this.ArrowType = AType; 
        break;
      default:
        this.ArrowType = OBJ_ARROW;
        break;
     }
   //---
   this.CreateArrow();
  }
//+------------------------------------------------------------------+
//| ����������� � �����������                                        |
//+------------------------------------------------------------------+
MyCArrow::MyCArrow(double APrice,datetime ATime)
  {
   //--- 
   this.ArrowName    = GenerateRandName();        
   this.ArrowTip     = "No_Tip";
   this.ArrowPrice   = APrice;
   this.ArrowTime    = ATime;
   this.ArrowType    = OBJ_ARROW;
   this.ArrowCode    = 58;
   this.ArrowColor   = clrRed;
   this.ArrowAnchor  = ANCHOR_TOP;
   //---
   this.CreateArrow();
  }
//+------------------------------------------------------------------+
//| ����������� � �����������                                        |
//| ����������(�����):                                               |
//| ����� ������ ������� ������, �� ��� ������� ����� ���� ������!   |
//+------------------------------------------------------------------+
MyCArrow::MyCArrow(string AName, string ATip, double APrice,datetime ATime,ENUM_OBJECT AType)
  {
   //---
   if(ObjectFind(0,AName) < 0)
     {
      this.ArrowName = AName;   
     }else this.ArrowName = GenerateRandName();        
   //---
   this.ArrowTip     = ATip;
   this.ArrowPrice   = APrice;
   this.ArrowTime    = ATime;
   this.ArrowCode    = 58;
   this.ArrowColor   = clrRed;
   this.ArrowAnchor  = ANCHOR_TOP;
   //---
   switch(AType)
     {
      case  OBJ_ARROW_BUY:
      case  OBJ_ARROW_SELL:
      case  OBJ_ARROW_STOP:
      case  OBJ_ARROW_CHECK:
      case  OBJ_ARROW_UP:
      case  OBJ_ARROW_DOWN:
      case  OBJ_ARROW_LEFT_PRICE:
      case  OBJ_ARROW_RIGHT_PRICE:
      case  OBJ_ARROW_THUMB_UP:
      case  OBJ_ARROW_THUMB_DOWN:
        this.ArrowType = AType; 
        break;
      default:
        this.ArrowType = OBJ_ARROW;
        break;
     }
   //---
    this.CreateArrow();
  }
//+------------------------------------------------------------------+
//| �������������                                                    |
//+------------------------------------------------------------------+
MyCArrow::~MyCArrow(void)
  {
   //---
   if(ObjectFind(0, this.ArrowName) >= 0)
     {
      DeletArrow();
     }
  }
//+------------------------------------------------------------------+
//| CreateArrow                                                      |
//+------------------------------------------------------------------+
void MyCArrow::CreateArrow(void)
  {
   //---
   ObjectCreate(0, this.ArrowName, this.ArrowType, 0,
                this.ArrowTime, this.ArrowPrice);
   //---
   if(this.ArrowType == OBJ_ARROW)
     {
      ObjectSetInteger(0, this.ArrowName, OBJPROP_ARROWCODE, this.ArrowCode);
     }
   //---
   ObjectSetInteger(0,this.ArrowName,OBJPROP_COLOR,this.ArrowColor);
   //---
   ObjectSetString(0,this.ArrowName,OBJPROP_TOOLTIP,this.ArrowTip);
   //---
   ObjectSetInteger(0,this.ArrowName,OBJPROP_ANCHOR,this.ArrowAnchor);
   //---
   ChartRedraw(0);   
  }
//+------------------------------------------------------------------+
//| �������� �� ������                                               |
//+------------------------------------------------------------------+
void MyCArrow::DeletArrow(void)
  {
   ObjectDelete(0, this.ArrowName);
   ChartRedraw(0);   
  }
//+------------------------------------------------------------------+
//| ����� ���. ������������                                          |
//+------------------------------------------------------------------+
bool MyCArrow::SetAnchor(ENUM_ARROW_ANCHOR Anchor)
  {
   if(ObjectSetInteger(0,this.ArrowName,OBJPROP_ANCHOR,Anchor))
     {
      //---
      this.ArrowAnchor = Anchor;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| �������������� ������� �������                                   |
//+------------------------------------------------------------------+
bool MyCArrow::SetName(string NewName)
  {
   if(ObjectSetString(0, this.ArrowName,OBJPROP_NAME,NewName))
     {
      //---
      this.ArrowName = NewName;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ����� ���������� ��� �������                                     |
//+------------------------------------------------------------------+
bool MyCArrow::SetTip(string NewTip)
  {
   if(ObjectSetString(0, this.ArrowName,OBJPROP_TOOLTIP,NewTip))
     {
      //---
      this.ArrowTip = NewTip;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� ����� ����                                             |
//+------------------------------------------------------------------+
bool MyCArrow::SetPrice(double NewPrice)
  {
   if(ObjectSetDouble(0, this.ArrowName,OBJPROP_PRICE,NewPrice))
     {
      //---
      this.ArrowPrice = NewPrice;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� ������ �������                                         |
//+------------------------------------------------------------------+
bool MyCArrow::SetTime(datetime NewTime)
  {
   if(ObjectSetInteger(0, this.ArrowName,OBJPROP_TIME,NewTime))
     {
      //---
      this.ArrowTime = NewTime;
      //---
      ChartRedraw(0);   
      //---
      return(true);
     }
   Print(__FUNCTION__," ERROR: ",GetLastError());
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ���� �������                                    |
//+------------------------------------------------------------------+
bool MyCArrow::SetType(ENUM_OBJECT NewType)
  {
   //--- ���������� ������
   this.DeletArrow();
   //---
   this.ArrowType = NewType;
   //--- ������� �����
   this.CreateArrow();
   //---
   return(true);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ���/���� �������                                |
//+------------------------------------------------------------------+
bool MyCArrow::SetCode(int NewCode)
  {
   //---
   if(this.ArrowType == OBJ_ARROW)
     {
      //---
      if(NewCode>=32&&NewCode<=255)
        {
         this.ArrowCode = NewCode;
        }else return(false);      
      //---
      bool ret = ObjectSetInteger(0, this.ArrowName, OBJPROP_ARROWCODE, this.ArrowCode);
      //---
      ChartRedraw(0);
      //---
      return(ret);
     }
   //---
   return(false);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ����� �������                                   |
//+------------------------------------------------------------------+
bool MyCArrow::SetColor(color NewColor)
  {
   //---
   this.ArrowColor = NewColor;
   //---
   bool ret = ObjectSetInteger(0, this.ArrowName, OBJPROP_COLOR, this.ArrowColor);
   //---
   ChartRedraw(0);
   //---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ������������� ���������� �����                                   |
//+------------------------------------------------------------------+
string MyCArrow::GenerateRandName(void)
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
	  RandName = "No_Name_Arrow_"+IntegerToString(MathRand());
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
