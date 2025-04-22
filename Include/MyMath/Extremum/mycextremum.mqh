//+------------------------------------------------------------------+
//|                                                  MyCExtremum.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ��� �������� ������� ���������� ZigZag - ����������:             |
//| 1. ZigZag ������� ������ ��� �� MetaQuotes;                      |
//+------------------------------------------------------------------+
//| ��������:                                                        |
//| 2. ZigZag �������� ���������� ���� - �������� ������;            |
//| 3. ������������� ���������� ����� ����������� �������.           |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, A. Emelyanov"
#property link      "A.Emelyanov2010@yandex.ru"
#property version   "1.00"
//+------------------------------------------------------------------+
//| ���������� ��������� ����������                                  |
//+------------------------------------------------------------------+
#define EXTREMUM_RESERVE 1000
//--- auxiliary enumeration
enum looling_for
  {
   Pike=1,                                         // searching for next high
   Sill=-1                                         // searching for next low
  };
//+------------------------------------------------------------------+
//| ������������ ����������                                          |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| �������� ������                                                  |
//+------------------------------------------------------------------+
class MyCExtremum : public CObject
  {
public:
   //--- ����������, ������ ��� ������ �����������
   double            HighMapBuffer[];                             // ������ ���� "����������� ����." 
   double            LowMapBuffer[];                              // ������ ���� "����������� ���."
   double            ZigzagBuffer[];                              // ������ ���  "������"

public:
                     MyCExtremum();
                    ~MyCExtremum();
   
   //--- ����������� ZIGZAG
   int               GetHighMapZigzag(double &in[], int ExtDepth, int ExtDeviation, 
                                      int ExtBackstep);           // ��������� ������� ����������� �����   
   int               GetLowMapZigzag(double &in[], int ExtDepth, int ExtDeviation, 
                                      int ExtBackstep);           // ��������� ������� ����������� ����
   int               GetClassicZigzag(double &high[],double &low[], int ExtDepth, 
                                      int ExtDeviation, int ExtBackstep);// �������� ����������� ������

   //--- ���������������� ZIGZAG
   int               _GetHighMapZigzag(double &in[], int ExtDepth, int ExtDeviation, 
                                      int ExtBackstep);           // ��������� ������� ����������� �����   
   int               _GetLowMapZigzag(double &in[], int ExtDepth, int ExtDeviation, 
                                      int ExtBackstep);           // ��������� ������� ����������� ����
   int               GetModZigzag(double &high[],double &low[], int ExtDepth, 
                                      int ExtDeviation, int ExtBackstep);// �������� ����������� ������
   
private:
   //--- ���������� �������
   int               iHighest(double &array[], int depth, 
                                       int startPos);             // ����� ���������
   int               iLowest(double &array[], int depth, 
                                       int startPos);             // ����� ��������
   void              CorrectMapHigh(double &in[]);                // �������������� ������� high(���. ZIGZAG)
   void              CorrectMapLow(double &in[]);                 // �������������� ������� low(���. ZIGZAG)
   void              CorrectMapZigzag();                          // ������ �������������� �������(���. ZIGZAG)
   void              CorrectMapClassicZigzag();                   // ���������� ����. ����� ������������� Zigzag
  };
//+------------------------------------------------------------------+
//| ����������� ������                                               |
//+------------------------------------------------------------------+
MyCExtremum::MyCExtremum()
  {
  }
//+------------------------------------------------------------------+
//| ����������  ������                                               |
//+------------------------------------------------------------------+
MyCExtremum::~MyCExtremum()
  {
  }
//+------------------------------------------------------------------+
//| ������� ���� �������� � ������ array                             |
//+------------------------------------------------------------------+
int MyCExtremum::iHighest(double &array[],int depth,int startPos)
  {
   int index=startPos;
   //--- start index validation
   if(startPos<0)
     {
      Print(__FUNCTION__," ERROR: Invalid parameter in the function iHighest(...)");
      return 0;
     }
   //--- depth correction if need
   if(startPos-depth<0) depth=startPos;
   double max=array[startPos];
   //--- start searching
   for(int i=startPos;i>startPos-depth;i--)
     {
      if(array[i]>max)
        {
         index=i;
         max=array[i];
        }
     }
   //--- return index of the highest bar
   return(index);
  }
//+------------------------------------------------------------------+
//| ������� ���� �������  � ������ array                             |
//+------------------------------------------------------------------+
int MyCExtremum::iLowest(double &array[],int depth,int startPos)
  {
   int index=startPos;
   //--- start index validation
   if(startPos<0)
     {
      Print(__FUNCTION__," ERROR: Invalid parameter in the function iLowest(...)");
      return 0;
     }
   //--- depth correction if need
   if(startPos-depth<0) depth=startPos;
   double min=array[startPos];
   //--- start searching
   for(int i=startPos;i>startPos-depth;i--)
     {
      if(array[i]<min)
        {
         index=i;
         min=array[i];
        }
     }
   //--- return index of the lowest bar
   return(index);
  }
//+------------------------------------------------------------------+
//| ������������ ZIGZAG                                              |
//+------------------------------------------------------------------+
//| ��������� ������� ����������� �����                              |
//+------------------------------------------------------------------+
int MyCExtremum::GetHighMapZigzag(double &in[],int ExtDepth,int ExtDeviation,int ExtBackstep)
  {
   //--- ���������� �������
   int    shift    = 0, back = 0; 
   double lasthigh = 0, res  = 0, val = 0;
   
   //--- "����������" �������������� �������� ������������� ����(���������� ������ ��...)
   int    rates_total     = ArrayRange(in,0);         // ������ ������� ���������
   double deviation       = ExtDeviation * _Point;    // ���������� ���� � �������
   
   //--- ���������� �������� ������� ������ �� ������������
   if(rates_total<100)
     { 
      Print(__FUNCTION__," ERROR: the small size of the buffer!");
      return(-1);                                     //������, ��������� ������ ������!
     }
   
   //--- ��������� ������������� ������� �������� ����������
   ArrayResize(HighMapBuffer,  rates_total, EXTREMUM_RESERVE);
   ArrayFill(HighMapBuffer, 0, rates_total, 0.0);     // ���� �������� NULL, �� �����, ��� ���������� ����� 0.0

   //--- � ��� � ��� ���... Searching High
   for(shift=ExtDepth;shift<rates_total;shift++)
     {//--- high
      val=in[iHighest(in,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else
        {
         lasthigh=val;
         if((val-in[shift])>deviation) val=0.0;
         else
           {
            for(back=1;back<=ExtBackstep;back++)
              {
               res=HighMapBuffer[shift-back];
               if((res!=0) && (res<val)) HighMapBuffer[shift-back]=0.0;
              }
           }
        }
      if(in[shift]==val) HighMapBuffer[shift]=val; else HighMapBuffer[shift]=0.0;
     }   
   //--- ������ ������� ������ ��� ������
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ��������� ������� ����������� ����                               |
//+------------------------------------------------------------------+
int MyCExtremum::GetLowMapZigzag(double &in[],int ExtDepth,int ExtDeviation,int ExtBackstep)
  {
   //--- ���������� �������
   int    shift = 0, back    = 0; 
   double val   = 0, lastlow = 0, res = 0;  

   //--- "����������" �������������� �������� ������������� ����(���������� ������ ��...)
   int    rates_total     = ArrayRange(in,0);         // ������ ������� ���������
   double deviation       = ExtDeviation * _Point;    // ���������� ���� � �������

   //--- ���������� �������� ������� ������ �� ������������
   if(rates_total<100)
     { 
      Print(__FUNCTION__," ERROR: the small size of the buffer!");
      return(-1);                                     //������, ��������� ������ ������!
     }

   //--- ��������� ������������� ������� �������� ����������
   ArrayResize(LowMapBuffer,   rates_total, EXTREMUM_RESERVE);
   ArrayFill(LowMapBuffer,  0, rates_total, 0.0);    // ���� �������� NULL, �� �����, ��� ���������� ����� 0.0

   //--- � ��� � ��� ���... Searching Low
   for(shift=ExtDepth;shift<rates_total;shift++)
     {
      val=in[iLowest(in,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else
        {
         lastlow=val;
         if((in[shift]-val)>deviation) val=0.0;
         else
           {
            for(back=1;back<=ExtBackstep;back++)
              {
               res=LowMapBuffer[shift-back];
               if((res!=0) && (res>val)) LowMapBuffer[shift-back]=0.0;
              }
           }
        }
      if(in[shift]==val) LowMapBuffer[shift]=val; else LowMapBuffer[shift]=0.0;
     }
   //--- ������ ������� ������ ��� ������
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ���������� ����. ����� ������������� Zigzag                      |
//+------------------------------------------------------------------+
void MyCExtremum::CorrectMapClassicZigzag(void)
  {
   //---
   int rates_total = ArrayRange(ZigzagBuffer,0);      // ������ ���������
   //---
   for(int i=0;i<rates_total-1;i++)
     {
      if(ZigzagBuffer[i]!=0)
        {
         //--- ����� ����������� �����
         if(LowMapBuffer[i]!=0)
           {
            for(int a=i;a>0;a--)
              {
               if(HighMapBuffer[a]!=0)
                 {
                  ZigzagBuffer[a]=HighMapBuffer[a];
                  return;
                 }
              }
            return;
           }
         //--- ����� ����������  ����
         if(HighMapBuffer[i]!=0)
           {
            for(int a=i;a>0;a--)
              {
               if(LowMapBuffer[a]!=0)
                 {
                  ZigzagBuffer[a] = LowMapBuffer[a];
                  return;
                 }
              }
            return;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| ��������� ������������� �������                                  |
//+------------------------------------------------------------------+
int MyCExtremum::GetClassicZigzag(double &high[],double &low[],int ExtDepth,int ExtDeviation,int ExtBackstep)
  {
   //+---------------------------------------------------------------+
   //| ����� ������ �������� �������� �� ������������ ����������!    |
   //| �������� ����������� �������, ��������� ��������� �����������:|
   //| ��� = 0 <- �������, ���=MAX <- ���������(�� ���������)        |
   //+---------------------------------------------------------------+
   if(ArrayIsSeries(high)) ArraySetAsSeries(high,false);
   if(ArrayIsSeries(low))  ArraySetAsSeries(low,false);
   //--- ���������� �������
   int    rates_total     = ArrayRange(high,0);       // ������ ������� ���������
   if(rates_total > ArrayRange(low,0))
     {
      rates_total = ArrayRange(low,0);                // ���� � low ������ ������, �������� ���.������
     }
   int    limit           = rates_total - ExtDepth;   // ����� �� �������...

   //--- "����������" �������������� �������� ������������� ����(���������� ������ ��...)
   int    shift=0, whatlookfor=0, lasthighpos=0, lastlowpos=0;
   double res=0.0, curlow=0.0, curhigh=0.0, lasthigh=0.0, lastlow=0.0;

   //--- �������� ������� ������
   if(rates_total<100)
     { 
      Print(__FUNCTION__," ERROR: the small size of the buffer!");
      return(-1);                                     //������, ��������� ������ ������!
     }
     
   //--- ������� ����� ZigzagBuffer[]
   ArrayResize(ZigzagBuffer,   rates_total, EXTREMUM_RESERVE);
   ArrayFill(ZigzagBuffer,  0, rates_total, 0.0);    // ���� �������� NULL, �� �����, ��� ���������� ����� 0.0
   
   //--- �������� "������" �������� � ���������
   if(GetHighMapZigzag(high,ExtDepth,ExtDeviation,ExtBackstep) < 0) return(0);
   if(GetLowMapZigzag(low,ExtDepth,ExtDeviation,ExtBackstep)   < 0) return(0);
   
   //--- ���: last preparation
   if(whatlookfor==0)// uncertain quantity
     {
      lastlow=0;
      lasthigh=0;
     }else
       {
        lastlow=curlow;
        lasthigh=curhigh;
       }
   //--- final rejection
   for(shift=ExtDepth;shift<rates_total;shift++)
     {
      res=0.0;
      switch(whatlookfor)
        {
         case 0: // search for peak or lawn
            if(lastlow==0 && lasthigh==0)
              {
               if(HighMapBuffer[shift]!=0)
                 {
                  lasthigh=high[shift];
                  lasthighpos=shift;
                  whatlookfor=Sill;
                  ZigzagBuffer[shift]=lasthigh;
                  res=1;
                 }
               if(LowMapBuffer[shift]!=0)
                 {
                  lastlow=low[shift];
                  lastlowpos=shift;
                  whatlookfor=Pike;
                  ZigzagBuffer[shift]=lastlow;
                  res=1;
                 }
              }
            break;
         case Pike: // search for peak
            if(LowMapBuffer[shift]!=0.0 && LowMapBuffer[shift]<lastlow && HighMapBuffer[shift]==0.0)
              {
               ZigzagBuffer[lastlowpos]=0.0;
               lastlowpos=shift;
               lastlow=LowMapBuffer[shift];
               ZigzagBuffer[shift]=lastlow;
               res=1;
              }
            if(HighMapBuffer[shift]!=0.0 && LowMapBuffer[shift]==0.0)
              {
               lasthigh=HighMapBuffer[shift];
               lasthighpos=shift;
               ZigzagBuffer[shift]=lasthigh;
               whatlookfor=Sill;
               res=1;
              }
            break;
         case Sill: // search for lawn
            if(HighMapBuffer[shift]!=0.0 && HighMapBuffer[shift]>lasthigh && LowMapBuffer[shift]==0.0)
              {
               ZigzagBuffer[lasthighpos]=0.0;
               lasthighpos=shift;
               lasthigh=HighMapBuffer[shift];
               ZigzagBuffer[shift]=lasthigh;
              }
            if(LowMapBuffer[shift]!=0.0 && HighMapBuffer[shift]==0.0)
              {
               lastlow=LowMapBuffer[shift];
               lastlowpos=shift;
               ZigzagBuffer[shift]=lastlow;
               whatlookfor=Pike;
              }
            break;
         default: 
            CorrectMapClassicZigzag();
            return(rates_total);
        }
     }
   //--- return value of prev_calculated for next call
   CorrectMapClassicZigzag();
   return(rates_total);   
  }
//+------------------------------------------------------------------+
//| ������������ ���������������� ZIGZAG                             |
//+------------------------------------------------------------------+
//| ��������� ������� ����������� �����                              |
//+------------------------------------------------------------------+
int MyCExtremum::_GetHighMapZigzag(double &in[],int ExtDepth,int ExtDeviation,int ExtBackstep)
  {
   //--- ���������� �������
   int    shift    = 0, back = 0; 
   double lasthigh = 0, res  = 0, val = 0;
   
   //--- "����������" �������������� �������� ������������� ����(���������� ������ ��...)
   int    rates_total     = ArrayRange(in,0);         // ������ ������� ���������
   int    limit           = rates_total - ExtDepth;   // ����� �� �������...
   double deviation       = ExtDeviation * _Point;    // ���������� ���� � �������
   
   //--- ���������� �������� ������� ������ �� ������������
   if(rates_total<100)
     { 
      Print(__FUNCTION__," ERROR: the small size of the buffer!");
      return(-1);                                     //������, ��������� ������ ������!
     }
   
   //--- ��������� ������������� ������� �������� ����������
   ArrayResize(HighMapBuffer,  rates_total, EXTREMUM_RESERVE);
   ArrayFill(HighMapBuffer, 0, rates_total, 0.0);     // ���� �������� NULL, �� �����, ��� ���������� ����� 0.0

   //--- � ��� � ��� ���... Searching High
   //for(shift=ExtDepth;shift<rates_total;shift++)
   for(shift=limit; shift>=0; shift--)
     {//--- high
      val=in[iHighest(in,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else
        {
         lasthigh=val;
         if((val-in[shift])>deviation) val=0.0;
         else
           {
            for(back=1;back<=ExtBackstep;back++)
              {
               res=HighMapBuffer[shift+back];//res=HighMapBuffer[shift-back];
               if((res!=0) && (res<val)) HighMapBuffer[shift+back]=0.0;//if((res!=0) && (res<val)) HighMapBuffer[shift-back]=0.0;
              }
           }
        }
      if(in[shift]==val) HighMapBuffer[shift+1]=val; else HighMapBuffer[shift+1]=0.0;
     }   
   //--- ����� �������������� �������
   CorrectMapHigh(in);
   //--- ������ ������� ������ ��� ������
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ��������� ������� ����������� ����                               |
//+------------------------------------------------------------------+
int MyCExtremum::_GetLowMapZigzag(double &in[],int ExtDepth,int ExtDeviation,int ExtBackstep)
  {
   //--- ���������� �������
   int    shift = 0, back    = 0; 
   double val   = 0, lastlow = 0, res = 0;  

   //--- "����������" �������������� �������� ������������� ����(���������� ������ ��...)
   int    rates_total     = ArrayRange(in,0);         // ������ ������� ���������
   int    limit           = rates_total - ExtDepth;   // ����� �� �������...
   double deviation       = ExtDeviation * _Point;    // ���������� ���� � �������

   //--- ���������� �������� ������� ������ �� ������������
   if(rates_total<100)
     { 
      Print(__FUNCTION__," ERROR: the small size of the buffer!");
      return(-1);                                     //������, ��������� ������ ������!
     }

   //--- ��������� ������������� ������� �������� ����������
   ArrayResize(LowMapBuffer,   rates_total, EXTREMUM_RESERVE);
   ArrayFill(LowMapBuffer,  0, rates_total, 0.0);    // ���� �������� NULL, �� �����, ��� ���������� ����� 0.0

   //--- � ��� � ��� ���... Searching Low
   for(shift=limit; shift>=0; shift--)//for(shift=ExtDepth;shift<rates_total;shift++)
     {
      val=in[iLowest(in,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else
        {
         lastlow=val;
         if((in[shift]-val)>deviation) val=0.0;
         else
           {
            for(back=1;back<=ExtBackstep;back++)
              {
               
               res=LowMapBuffer[shift+back];//res=LowMapBuffer[shift-back];
               if((res!=0) && (res>val)) LowMapBuffer[shift+back]=0.0;//if((res!=0) && (res>val)) LowMapBuffer[shift-back]=0.0;
              }
           }
        }
      if(in[shift]==val) LowMapBuffer[shift+1]=val; else LowMapBuffer[shift+1]=0.0;
     }
   //--- ����� �������������� �������
   CorrectMapLow(in);
   //--- ������ ������� ������ ��� ������
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| �������������� ������� high                                      |
//+------------------------------------------------------------------+
void MyCExtremum::CorrectMapHigh(double &in[])
  {
   //---
   int rates_total = ArrayRange(HighMapBuffer,0);     // ������ ������� ���������
   //---
   for(int i=0;i<rates_total;i++)
     {
      if(HighMapBuffer[i]!=0)
        {
         HighMapBuffer[i] = in[i];
        }
     }
  }
//+------------------------------------------------------------------+
//| �������������� ������� low                                       |
//+------------------------------------------------------------------+
void MyCExtremum::CorrectMapLow(double &in[])
  {
   //---
   int rates_total = ArrayRange(LowMapBuffer,0);      // ������ ������� ���������
   //---
   for(int i=0;i<rates_total;i++)
     {
      if(LowMapBuffer[i]!=0)
        {
         LowMapBuffer[i] = in[i];
        }
     }
  }
//+------------------------------------------------------------------+
//| ������ �������������� �������                                    |
//+------------------------------------------------------------------+
void MyCExtremum::CorrectMapZigzag(void)
  {
   //---
   int rates_total = ArrayRange(HighMapBuffer,0);     // ������ ������� ���������
   //---
   for(int i=0;i<rates_total;i++)
     {
      if(HighMapBuffer[i]!=0&&LowMapBuffer[i]!=0)
        {
         HighMapBuffer[i] = 0.0;
         LowMapBuffer[i]  = 0.0;
        }
     }
  }
//+------------------------------------------------------------------+
//| ���������������� �������� ������� �������                        |
//+------------------------------------------------------------------+
int MyCExtremum::GetModZigzag(double &high[],double &low[],int ExtDepth,int ExtDeviation,int ExtBackstep)
  {
   /*//--- auxiliary enumeration
   enum looling_for
     {
      Pike=1,                                         // searching for next high
      Sill=-1                                         // searching for next low
     };
   */
   //--- ���������� �������
   int    rates_total     = ArrayRange(high,0);       // ������ ������� ���������
   if(rates_total > ArrayRange(low,0))
     {
      rates_total = ArrayRange(low,0);                // ���� � low ������ ������, �������� ���.������
     }
   int    limit           = rates_total - ExtDepth;   // ����� �� �������...

   //--- "����������" �������������� �������� ������������� ����(���������� ������ ��...)
   int    shift=0, whatlookfor=0, lasthighpos=0, lastlowpos=0;
   double res=0.0, curlow=0.0, curhigh=0.0, lasthigh=0.0, lastlow=0.0;

   //--- �������� ������� ������
   if(rates_total<100)
     { 
      Print(__FUNCTION__," ERROR: the small size of the buffer!");
      return(-1);                                     //������, ��������� ������ ������!
     }
     
   //--- ������� ����� ZigzagBuffer[]
   ArrayResize(ZigzagBuffer,   rates_total, EXTREMUM_RESERVE);
   ArrayFill(ZigzagBuffer,  0, rates_total, 0.0);    // ���� �������� NULL, �� �����, ��� ���������� ����� 0.0
   
   //--- �������� "������" �������� � ���������
   if(_GetHighMapZigzag(high,ExtDepth,ExtDeviation,ExtBackstep) < 0) return(0);
   if(_GetLowMapZigzag(low,ExtDepth,ExtDeviation,ExtBackstep)   < 0) return(0);
   CorrectMapZigzag();
   
   //--- ���: last preparation
   if(whatlookfor==0)// uncertain quantity
     {
      lastlow=0;
      lasthigh=0;
     }else
       {
        lastlow=curlow;
        lasthigh=curhigh;
       }
   //--- final rejection
   for(shift=limit;shift>=0;shift--)//for(shift=ExtDepth;shift<rates_total;shift++)
     {
      res=0.0;
      switch(whatlookfor)
        {
         case 0: // search for peak or lawn
            if(lastlow==0 && lasthigh==0)
              {
               if(HighMapBuffer[shift]!=0)
                 {
                  lasthigh=high[shift];
                  lasthighpos=shift;
                  whatlookfor=Sill;
                  ZigzagBuffer[shift]=lasthigh;
                  res=1;
                 }
               if(LowMapBuffer[shift]!=0)
                 {
                  lastlow=low[shift];
                  lastlowpos=shift;
                  whatlookfor=Pike;
                  ZigzagBuffer[shift]=lastlow;
                  res=1;
                 }
              }
            break;
         case Pike: // search for peak
            if(LowMapBuffer[shift]!=0.0 && LowMapBuffer[shift]<lastlow && HighMapBuffer[shift]==0.0)
              {
               ZigzagBuffer[lastlowpos]=0.0;
               lastlowpos=shift;
               lastlow=LowMapBuffer[shift];
               ZigzagBuffer[shift]=lastlow;
               res=1;
              }
            if(HighMapBuffer[shift]!=0.0 && LowMapBuffer[shift]==0.0)
              {
               lasthigh=HighMapBuffer[shift];
               lasthighpos=shift;
               ZigzagBuffer[shift]=lasthigh;
               whatlookfor=Sill;
               res=1;
              }
            break;
         case Sill: // search for lawn
            if(HighMapBuffer[shift]!=0.0 && HighMapBuffer[shift]>lasthigh && LowMapBuffer[shift]==0.0)
              {
               ZigzagBuffer[lasthighpos]=0.0;
               lasthighpos=shift;
               lasthigh=HighMapBuffer[shift];
               ZigzagBuffer[shift]=lasthigh;
              }
            if(LowMapBuffer[shift]!=0.0 && HighMapBuffer[shift]==0.0)
              {
               lastlow=LowMapBuffer[shift];
               lastlowpos=shift;
               ZigzagBuffer[shift]=lastlow;
               whatlookfor=Pike;
              }
            break;
         default: return(rates_total);
        }
     }
   //--- return value of prev_calculated for next call
   return(rates_total);   
  }
//+------------------------------------------------------------------+
