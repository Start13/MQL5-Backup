//+------------------------------------------------------------------+
//|                                             MyCPatternZigzag.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ����������� ����� MyCPattern. ��������� ������� ����� ��������:  |
//| 1. ����� ������ �����������(�������� ����.Zigzag);               |
//| 2. ����� �������� �������� ����: level_0, level_1(���� �����)    |
//| 3. ����� �������������� � ������� MyCComment(����������� �������)|
//+------------------------------------------------------------------+
//|+ 07/06/2014: �������� ��������� ��������� ��������� ����/������� |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, A. Emelyanov"
#property link      "A.Emelyanov2010@yandex.ru"
#property version   "1.04"
//+------------------------------------------------------------------+
//| ������������ ����������                                          |
//+------------------------------------------------------------------+
#include <MyMath\Pattern\MyCPattern.mqh>
#include <MyMath\Extremum\MyCExtremum.mqh>
#include <MyObjects\MyCComment.mqh>
//+------------------------------------------------------------------+
//| ���������� ��������� ����������                                  |
//+------------------------------------------------------------------+
#define PATTERN_ZIG_RESERVE 50
//+------------------------------------------------------------------+
//| ����� MyCPatternZigzag ������� MyCPattern                        |
//+------------------------------------------------------------------+
class MyCPatternZigzag : public MyCPattern
  {
protected:
   //--- ����������, ��������� ��� ���������� �����������
   int               Depth;                                       // ���� ������ ����������
   int               Deviation;                                   // ��������� ���� � �������
   int               Backstep;                                    // ����������� ���
   int               SizeBuffers;                                 // ������ �������
   int               NumberLineComment;                           // ����� ������ "��������"
   double            pE;                                          // �������: ����� "�������� level_0"
   double            pM;                                          // �������: ����� "�������  level_0"
   double            pEv1;                                        // �������: ����� "�������� level_1"
   double            pM1;                                         // �������: ����� "�������  level_1"
   datetime          tA;                                          // �����  ����� A
   datetime          tB;                                          // �����  ����� B
   datetime          tC;                                          // �����  ����� C
   datetime          tD;                                          // �����  ����� D
   datetime          tE;                                          // �����  ����� E
   datetime          tEv;                                         // �����  ����� "��������"
   datetime          tM;                                          // �����  ����� "�������"
   int               iA;                                          // ������ ����� �
   int               iB;                                          // ������ ����� B
   int               iC;                                          // ������ ����� C 
   int               iD;                                          // ������ ����� D 
   int               iE;                                          // ������ ����� E 
   int               iEv;                                         // �������: ������ ����� "��������"
   int               iM;                                          // �������: ������ ����� "�������"
   int               countEvolution;                              // ������� ��������
   int               countMutation;                               // ������� �������
   int               countError;                                  // ������� "������ ������"
   MyCExtremum*      Extremum;                                    // ����� ���������(Zigzag)
   MyCComment*       MyComment;                                   // ����� "��������"
public:
   //--- ������������
                     MyCPatternZigzag();
                    ~MyCPatternZigzag();
   //--- ������ Set ���������
   void              SetDepth(int depth){Depth = depth;};         // ��������� "���� ������ ����������"
   void              SetDeviation(int dev){Deviation=dev;};       // ��������� "��������� ���� � �������"
   void              SetBackstep(int back){Backstep = back;};     // ��������� "����������� ���"
   void              SetSizeBuffers(int size){SizeBuffers = size;};//��������� "������ �������"
   void              SetNumberLineComment(int NL){if(NL>0&&NL<31){NumberLineComment = NL;
                                                    }else NumberLineComment = 1;};//��������� ������ ������ "��������"
   //--- ������ Get ���������
   int               GetDepth(){return(Depth);};                  // ���� ������ ����������
   int               GetDeviation(){return(Deviation);};          // ��������� ���� � �������
   int               GetBackstep(){return(Backstep);};            // 
   int               GetSizeBuffers(){return(SizeBuffers);};      // ������ �������
   int               GetNumberLineComment(){return(NumberLineComment);};//����� ������ "��������"
   int               GetCountLineComment();                       // ���������� ���-�� ����� "�����������"
   //--- ������ Get �������...
   string            GetNamePattern(double &high[],double &low[],datetime &time[]);// ��������� ������� �������
   string            GetNameLastPattern(void){
                       return(EnumToString(GetLastPattern()));};  // �������� ��� ���������� ��������� �������
   string            GetNamePrevPattern(void){
                       return(EnumToString(GetPrevPattern()));};  // �������� ��� ���������� �������
   string            GetNameEvolution(void);                      // �������� ��������� �������(����� �������� �����)
   string            GetNameMutation(void);                       // �������� ��������� �������(����� ������� �����)
   double            GetSumModel(void);                           // �������� ����� ������(��������� �������� � �����. ���-��)
   //--- ����� �������
   void              PrintComment(void);                          // ����� �� ����� ��������
   double            GetPointEvolution(){return(pE);};            // �������� �������� ����� "�������� level_0"
   double            GetPointMutation(){return(pM);};             // �������� �������� ����� "�������  level_0"
   double            GetPointEvolutionLevel1(){return(pEv1);};    // �������� �������� ����� "�������� level_1"
   double            GetPointMutationLevel1(){return(pM1);};      // �������� �������� ����� "�������  level_1"
   datetime          GetTimeA(){return(tA);};                     // �������� ����� ����� A
   datetime          GetTimeB(){return(tB);};                     // �������� ����� ����� B
   datetime          GetTimeC(){return(tC);};                     // �������� ����� ����� C
   datetime          GetTimeD(){return(tD);};                     // �������� ����� ����� D
   datetime          GetTimeE(){return(tE);};                     // �������� ����� ����� E
   datetime          GetTimeEvolution(){return(tEv);};            // �������� ����� ����� "��������"
   datetime          GetTimeMutation(){return(tM);};              // �������� ����� ����� "�������"
   int               GetIndexA(){return(iA);};                    // �������� ������ ����� A
   int               GetIndexB(){return(iB);};                    // �������� ������ ����� B
   int               GetIndexC(){return(iC);};                    // �������� ������ ����� C
   int               GetIndexD(){return(iD);};                    // �������� ������ ����� D
   int               GetIndexE(){return(iE);};                    // �������� ������ ����� E
   int               GetIndexEvolution(){return(iEv);};           // �������� ������ ����� "��������"
   int               GetIndexMutation(){return(iM);};             // �������� ������ ����� "�������"
   //--- ������ ������
   void              AddPointerCommet(MyCComment* pComment);      // ��������� ��������� �� "�����������"
private:
   //--- ���������� �������
   bool              SeachParams(double &high[],double &low[],datetime &time[]);// ����� ���������� �������-�������
   void              CalcModelCount(void);                        // ��������� ������� ������ 
   void              CalcPrognozPoint(void);                      // ��������� �������. �����(��������/�������)
   void              CalcPrognozLevel1(void);                     // ��������� �������. level_1
   double            CalcRegress(int nLast, double &a, int nA, double &b, int nB, 
                                 double c = 0.0, int nC = 0);     // ��������� ���. ���������
   void              MyCRegressia(double &fMassX[], double &fMassY[], double &fB0, double &fB1);
  };
//+------------------------------------------------------------------+
//| �����������                                                      |
//+------------------------------------------------------------------+
MyCPatternZigzag::MyCPatternZigzag()
  {
   //+---------------------------------------------------------------+
   //| "��������� ��������" - ��������� �� ���������                 |
   //+---------------------------------------------------------------+
   Depth      = 24;                                   // ���� ������ ����������
   Deviation  = 12;                                   // ��������� ���� � �������
   Backstep   = 9;                                    // ����������� ���
   SizeBuffers= 500;                                  // ������ �������
   //+---------------------------------------------------------------+
   //| ������� ����� �����������                                     |
   //+---------------------------------------------------------------+
   Extremum = new MyCExtremum;
   //--- �������� ���� ��� �������� ������������ ��������
   tA = NULL;                                         // ����� ����� A
   tB = NULL;                                         // ����� ����� B
   tC = NULL;                                         // ����� ����� C
   tD = NULL;                                         // ����� ����� D
   tE = NULL;                                         // ����� ����� E
   //---
   iA = 0;                                            // ������ ����� �
   iB = 0;                                            // ������ ����� B
   iC = 0;                                            // ������ ����� C 
   iD = 0;                                            // ������ ����� D 
   iE = 0;                                            // ������ ����� E 
   //--- �������� ��� "���������"
   MyComment = NULL;
   NumberLineComment = 2;
   //--- �������� ��������
   countEvolution = 0;                                // ������� ��������
   countMutation  = 0;                                // ������� �������
   countError     = 0;                                // ������� "������ ������"
   //--- �������� ����� ��������
   pE  = 0.0;                                         //
   pM  = 0.0;                                         //
   pEv1= 0.0;                                         // �������: ������ ����� "�������� level_1"
   pM1 = 0.0;                                         // �������: ������ ����� "�������  level_1"
   iEv = 0;                                           //
   iM  = 0;                                           //
  }
//+------------------------------------------------------------------+
//| �������������                                                    |
//+------------------------------------------------------------------+
MyCPatternZigzag::~MyCPatternZigzag()
  {
   //+---------------------------------------------------------------+
   //| ������� ����� �����������                                     |
   //+---------------------------------------------------------------+
   delete Extremum;
  }
//+------------------------------------------------------------------+
//| ��������� ������ ������                                          |
//+------------------------------------------------------------------+
//| ���������� ���-�� ����� "�����������"                            |
//+------------------------------------------------------------------+
int MyCPatternZigzag::GetCountLineComment(void)
  {
   if(MQL5InfoInteger(MQL5_TESTER))
     {
      return(5);
     }
   return(4);
  }
//+------------------------------------------------------------------+
//| ��������� ������ ��������                                        |
//+------------------------------------------------------------------+
string MyCPatternZigzag::GetNamePattern(double &high[],double &low[],datetime &time[])
  {
   //--- 
   if(SeachParams(high,low,time))
     {
      //--- ��������� & ������������� ������� � �������
      Get();                                          // ������� ������� ������
      //--- ���� �. E "��������������" �� ������������ ������ � �����
      if(IsPointENotReal())
        {
         iE = SizeBuffers-1;
         tE = time[SizeBuffers-1];
        }
      //---
      CalcModelCount();                               // ������� ������
      CalcPrognozPoint();                             // ������� ������
      //--- ��������� ��� �������� ������������
      return(EnumToString(GetLastPattern()));
     } 
   //--- ��� �����...
   return("ERROR");   
  }
//+------------------------------------------------------------------+
//| �������� ��������� �������(����� �������� �����)                 |
//|��������: �������� ������� ����� ������ Get()!                    |
//+------------------------------------------------------------------+
//|out: string - ������� ��������� ��������                          |
//+------------------------------------------------------------------+
string MyCPatternZigzag::GetNameEvolution(void)
  {
   //--- �������� ����� �������� ������ � ��������� � ������
   return(EnumToString(this.GetNextEvolution()));
  }
//+------------------------------------------------------------------+
//| �������� ��������� �������(����� ������� �����)                  |
//|��������: �������� ������� ����� ������ Get()!                    |
//+------------------------------------------------------------------+
//|out: string - ������� ��������� ��������                          |
//+------------------------------------------------------------------+
string MyCPatternZigzag::GetNameMutation(void)
  {
   //--- �������� ����� �������� ������ � ��������� � ������
   return(EnumToString(this.GetNextMutation()));
  }
//+------------------------------------------------------------------+
//| ��������: ������ ����� �� ������ ��������� ������-�����������!   |
//| ��������� ��������� �� "�����������"                             |
//+------------------------------------------------------------------+
void MyCPatternZigzag::AddPointerCommet(MyCComment* pComment)
  {
   if(pComment != NULL)
     {
      MyComment = pComment;
     }
  }
//+------------------------------------------------------------------+
//| ����� �� ����� ��������                                          |
//+------------------------------------------------------------------+
void MyCPatternZigzag::PrintComment(void)
  {
      //--- ���� ���� ��������� �� �������...
      if(MyComment != NULL)
        {
         MyComment.AddLineOfIndex(NumberLineComment,  "Now is pattern: "+EnumToString(GetLastPattern()));
         MyComment.AddLineOfIndex(NumberLineComment+1,"Next pattern(Evolution): "+GetNameEvolution()+
                                  ", price = "+DoubleToString(GetPointEvolution(),_Digits));
         MyComment.AddLineOfIndex(NumberLineComment+2,"Next pattern(Mutation ): "+GetNameMutation()+
                                  ", price = "+DoubleToString(GetPointMutation(),_Digits));
         if(countEvolution + countMutation + countError < 10)
           {
            MyComment.AddLineOfIndex(NumberLineComment+3,"No counter calculation.");
           }else
              {
               int    nSumModel = countEvolution+countMutation+countError;
               string sout  = "Evolution: " + DoubleToString(100*countEvolution/nSumModel,2)+
                              "% Mutation: "+ DoubleToString(100*countMutation/nSumModel,2)+
                              "% Error: "   + DoubleToString(100*countError/nSumModel,2)+"%"; 
               MyComment.AddLineOfIndex(NumberLineComment+3,sout);
              }
         //+---------------------------------------------------------+
         //| ��� DEBUG_MODE: �������� ������ ��������.               |
         //+---------------------------------------------------------+
         if(MQL5InfoInteger(MQL5_TESTER))
           {
            string sout  = "DEBUG_MODE: countEvolution= " + IntegerToString(countEvolution)+
                           "; countMutation= "+ IntegerToString(countMutation)+
                           "; countError= "   + IntegerToString(countError)+
                           "; oldPattern= "   + EnumToString(oldPattern); 
            MyComment.AddLineOfIndex(NumberLineComment+4,sout);
           }
        }
  }
//+------------------------------------------------------------------+
//| �������� ����� ������ (��������� �������� � �����. ���-��)       |
//| ret = ���-��_����/(���-��_����+���-��_���)                       |
//+------------------------------------------------------------------+
double MyCPatternZigzag::GetSumModel(void)
  {
   double ret = (double)(countEvolution + countMutation);
   if(ret != 0)
     {
      ret = countEvolution/ret;
      return(ret);
     }
   //--- ������� ���� ��� �������
   return(0);
  }
//+------------------------------------------------------------------+
//| ���������� ������ ������                                         |
//+------------------------------------------------------------------+
//| ����� ���������� ��������� �������: A, B, C, D, E                |
//| � ����-�������� �������.                                         |
//+------------------------------------------------------------------+
bool MyCPatternZigzag::SeachParams(double &high[], double &low[], datetime &time[])
  {
   //--- ���������� ��� ��������
   int ret =-1, ind=0, indD = 0;
   //--- �������� ������� �������
   if(ArrayRange(high,0) < SizeBuffers) return false;
   if(ArrayRange(low,0)  < SizeBuffers) return false;
   if(ArrayRange(time,0) < SizeBuffers) return false;   
   //--- � ������ �������� Zigzag
   ret = Extremum.GetClassicZigzag(high, low, Depth, Deviation, Backstep);
   //+---------------------------------------------------------------+
   //| ����� ������� A, B, C, D, E                                   |
   //+---------------------------------------------------------------+
   if(ret>0)
     {
      for(ind=ret-1;ind>0;ind--)
        {
         //--- �������� ���� D, �� ��� ����� ���� E!
         double mD  = Extremum.ZigzagBuffer[ind];
         if(mD!=0) 
           {
            tD = time[ind];
            SetD(mD);
            indD = ind;                               // ��������� ������ ����� D!
            iD   = ind;
            break;
           }
        }
      //+------------------------------------------------------------+
      //| ������� �������� �� "��������" ������: ���� ����� Backstep,|
      //| �� ��� �� D � E! � ������� ������������ ����� D.           |
      //+------------------------------------------------------------+
      if(ind > ret-Backstep)
        {
         tE = tD;
         iE = iD;
         SetE(GetD());
         indD = -1;                                   // ������� ������������ E!
         for(ind=ind-1;ind>0;ind--)
           {
            //--- �� ������ �� ����� ���� D!
            double mD  = Extremum.ZigzagBuffer[ind];
            if(mD!=0) 
              {
               tD = time[ind];
               SetD(mD);
               iD = ind;
               break;
              }
           }
        }      
      //--- ���������� ����� ���������� �����
      for(ind=ind-1;ind>0;ind--)
        {
         //--- ���� C
         double mC = Extremum.ZigzagBuffer[ind]; 
         if(mC!=0)
           {
            SetC(mC);
            tC = time[ind];
            iC = ind;
            break;
           }
        }
      for(ind=ind-1;ind>0;ind--)
        {
         //--- ���� B
         double mB = Extremum.ZigzagBuffer[ind];
         if(mB!=0)
           {
            SetB(mB);
            tB = time[ind];
            iB = ind;
            break;
           }
        }
      for(ind=ind-1;ind>0;ind--)
        {
         //--- ���� A
         double mA = Extremum.ZigzagBuffer[ind];
         if(mA!=0)
           {
            SetA(mA);
            tA = time[ind];
            iA = ind;
            break;
           }
        }
     }else
        {
         //--- ��� ������ ��� �������
         return(false);
        }
   //--- ��������: ����� �� ������ E
   if(indD < 0) return(true);
   //--- �������� �
   if(GetC() > GetD())
     {
      //--- ���� ���������
      ind = ArrayMaximum(high,indD+1,SizeBuffers-indD-1);
      //---
      if(ind > 0)
        {
         SetE(high[ind]);
         tE = time[ind];
         iE = ind;
        }else
           {
            SetE(high[SizeBuffers-2]);
            tE = time[SizeBuffers-2];
            iE = SizeBuffers-2;
           }
     }else
        {
         //--- ���� ��������
         ind = ArrayMinimum(low,indD+1,SizeBuffers-indD-1);
         //---
         if(ind > 0)
           {
            SetE(low[ind]);
            tE = time[ind];
            iE = ind;
           }else
             {
              SetE(low[SizeBuffers-2]);
              tE = time[SizeBuffers-2];
              iE = SizeBuffers-2;
             }
        }
   //+------------------------------------------------------------+
   //|                    ����-����                               |
   //+------------------------------------------------------------+
   double deltaED = MathAbs(GetE()-GetD());        // ������� �� ������
   int       dnED = (int)(deltaED/_Point);         // ���-�� �������
   //--- ���� ������� ����� E & D ������ Deviation, �� E ������� �� �����(������ �� "����")
   if(dnED < Deviation)
     {//--- �� ����� �� ��������� E & D! �� ������ �� "����"
      //--- ����� ����� E:
      SetE(GetD());
      tE = tD;
      iE = iD;
      //--- ����� ����� D:
      SetD(GetC());
      tD = tC;
      iD = iC;
      //--- ����� ����� C:
      SetC(GetB());
      tC = tB;
      iC = iB;
      //--- ����� ����� B:
      SetB(GetA());
      tB = tA;
      iB = iA;
      //--- ��������� ����� A:
      ind= iB;
      for(ind=ind-1;ind>0;ind--)
        {
         //--- ���� A
         double mA = Extremum.ZigzagBuffer[ind];
         if(mA!=0)
           {
            SetA(mA);
            tA = time[ind];
            iA = ind;
            break;
           }
        }      
     }
   //---
   return(true);
  }
//+------------------------------------------------------------------+
//| ������� ������������ ���-��: ��������, �������, ������ ������.   |
//| ������ �������� � ����������:                                    |
//| countEvolution, countMutation, countError                        |
//+------------------------------------------------------------------+
void MyCPatternZigzag::CalcModelCount(void)
  {
   //--- ��� ������ ��������? �� - �����....
   if((countEvolution == 0)&&(countMutation == 0)&&(countError == 0)&&(oldPattern == NOPATTERN)) return;
   //--- �� ���� ����� �������� - �����...
   if(oldPattern == pattern) return;
   //--- ����� ������!
   if(pattern == NOPATTERN)
     {
      countError++;                                // ������� "������ ������"
      return;
     }
   //--- � ��� �� ������! ����� ����� "������� ���� ������"
   if(oldPattern == NOPATTERN) return;
   //--- ���� ��������?
   if(IsRightEvolution() == 1)
     {
      countEvolution++;                         // ������� ��������
      return;
     }
   //--- ���� �������?
   if(IsRightMutation() == 1)
     {
      countMutation++;                          // ������� �������
      return;
     }
   //--- ������ "������ ������"
   countError++;                                // ������� "������ ������"
   return;
  }
//+------------------------------------------------------------------+
//| ������� ��������� �������� ���������:                            |
//| y = b*bar+a;                                                     |
//+------------+-----------------------------------------------------+
//| ���������� | ����������                                          |
//+------------+-----------------------------------------------------+
//| OUT        | ������� ��������(�����������) ������� (DOUBLE)      |
//| nLast      | ����� ���������� ���� (INT)                         |
//| a          | ������ ��������� �������� (DOUBLE), ��������� a     |
//| nA         | ����� ���� ������� ���������� �������� (INT)        |
//| b          | ������ ��������� �������� (DOUBLE), ��������� b     |
//| nB         | ����� ���� ������� ���������� �������� (INT)        |
//| c          | ������ ��������� �������� (DOUBLE)                  |
//| nC         | ����� ���� �������� ���������� �������� (INT)       |
//+------------+-----------------------------------------------------+
double MyCPatternZigzag::CalcRegress(int nLast, double &a,      int nA,    double &b, 
                                     int nB,    double c = 0.0, int nC = 0)
  {
   //--- ����������
   double dA              = 0;                        // ����������� ������� �����
   double dB              = 0;                        // ����������� ������� �����
   double ret             = -1;                       // ����������� ��������
   double ArDataX[];                                  // ����� ������� ������
   double ArDataY[];                                  // ����� ������� ������
   //--- 1. �������� ��������
   if(nC>0)
     {
      ArrayResize(ArDataX,3);
      ArrayResize(ArDataY,3);
     }else
        {
         ArrayResize(ArDataX,2);
         ArrayResize(ArDataY,2);
        }
   //--- 
   ArDataX[0] = nA;                                   // input 1
   ArDataY[0] = a;                                
   ArDataX[1] = nB;                                   // input 2
   ArDataY[1] = b;
   if(nC > 0)
     {
      ArDataX[2] = nC;                                // input 3
      ArDataY[2] = c;                                    
     }  
   //--- 3. ������ ������������� ���������� �������
   MyCRegressia(ArDataX, ArDataY, dA, dB);
   //--- 4. ������ �������������� �������� �� �������
   ret = dB*nLast+dA;
   a   = dA;
   b   = dB; 
   //--- 5. �����
   return(ret);
  }
//+------------------------------------------------------------------+
//| �������: ��������� ��������                                      |
//| y(x) = b1*x+b0                                                   |
//|fMass        -       ������ ��������                              |
//|nMassSize    -       ������ ������� ��������                      |
//|fB0          -       ��������� �� ���������� b0                   |
//|fB1          -       ��������� �� ���������� b1                   |
//+------------------------------------------------------------------+
void MyCPatternZigzag::MyCRegressia(double &fMassX[], double &fMassY[], double &fB0, double &fB1)
  {
   //---
   int i;
   double a=0, b=0, c=0, d=0;
   //---
   for(i = 0; i<ArrayRange(fMassX,0); i++)
     {
      a += fMassX[i];
      b += fMassY[i];
      c += MathPow(fMassX[i], 2);
      d += fMassX[i]*fMassY[i];
     }
   fB1 = (a*b-i*d)/(MathPow(a, 2)-i*c);
   fB0 = (b-fB1*a)/i;
  }
//+------------------------------------------------------------------+
//| ������� ������� �������. �����(��������/�������)                 |
//| in : ��� (������� ������� �������� ��������)                     |
//| out: ��� (������ double pE, double pM, int iE, int iM)           |
//+------------------------------------------------------------------+
//| ������� "��������� ���������" ("������� �������" ������ 1):      |
//|   �    (D-E)/(D-C)   "�� ������1" �  (E-D)/(C-D)   "�� ������1"  |
//|   M1    2             1.618       W1  0.3334        0.3819       |
//|   M2    0.5           0.5         W2  0.6667        0.618        |
//|   M3    1.5           1.2720      W3  1.5           1.2720       |
//|   M4    0.6667	     0.618       W4  0.5           0.5          |
//|   M5    1.3334        1.2720      W5  2             1.618        |
//|   M6    0.75          0.618       W6  0.25          0.25         |
//|   M7    3             3.0000      W7  0.5           0.5          |
//|   M8    0.3334        0.3819      W8  2             1.618        |
//|   M9    2             1.618       W9  0.3334        0.3819       |
//|   M10   0.5           0.5         W10 3             3.0000       |
//|   M11   0.25          0.25        W11 0.75          0.618        |
//|   M12   2             1.618       W12 1.3334        1.2720       |
//|   M13   0.5           0.5         W13 0.6667        0.618        |
//|   M14   1.5           1.2720      W14 1.5           1.2720       |
//|   M15   0.6667        0.618       W15 0.5           0.5          |
//|   M16   0.3334        0.3819      W16 2             1.618        |
//+------------------------------------------------------------------+
void MyCPatternZigzag::CalcPrognozPoint(void)
  {
   //--- �������� ������� �������� ��������
   if(pattern == NOPATTERN)
     {
      pE = 0.0; pM = 0.0; iEv = 0; iM = 0;            // ��� ��������
      CalcPrognozLevel1();
      return;                                         // ��� �������� - �����
     } 
   //+---------------------------------------------------------------+
   //|   ��������������� �������� ������� ��� �������.�����          |
   //+---------------------------------------------------------------+
   int iTemp = 0;
   if(((iE - iA)/5 < 3)&&((iE - iA)/5 > Backstep*2))
     {
      iTemp  = iE + (iE - iA)/5;
     }else
        {
         iTemp  = iE + Backstep*2;
        }
   //--- ��������� ���� ��������:
   tEv = (iTemp-iE)*PeriodSeconds()+GetTimeE();
   tM  = (iTemp-iE)*PeriodSeconds()+GetTimeE();
   double rA = 0, rB = 0;
   //+---------------------------------------------------------------+
   //| ������ ����� ��������                                         |
   //+---------------------------------------------------------------+
   switch(pattern)
     {
      case  M1:
      //+------------------------------------------------------------+
      //| �������: M1 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ���= 0                                  |
      //| ����� "�������" => W1 = 0.3819 * (D - E) + E               |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0.0; iEv = 0;
        //---
        pM = NormalizeDouble(0.3819 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M2:
      //+------------------------------------------------------------+
      //| �������: M2 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M1 = D - 1.618 * (D - C)                |
      //| ����� "�������" => W4 = 0.5 * (D - E) + E                  |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 1.618 * (D - C),_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(0.5 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M3:
      //+------------------------------------------------------------+
      //| �������: M3 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ���= 0                                  |
      //| ����� "�������" => W1 = 0.3819 * (D - E) + E               |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0.0; iEv = 0;
        //---
        pM = NormalizeDouble(0.3819 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M4:
      //+------------------------------------------------------------+
      //| �������: M4 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M3 = D - 1.272 * (D - C)                |
      //| ����� "�������" => W4 = 0.5 * (D - E) + E                  |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 1.272 * (D - C),_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(0.5 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M5:
      //+------------------------------------------------------------+
      //| �������: M5 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => W6  = 0.25 * (D - E) + E                |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0.0; iEv = 0;
        //---
        pM = NormalizeDouble(0.25 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M6:
      //+------------------------------------------------------------+
      //| �������: M6 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M5 = D - 1.272 * (D - C)                |
      //| ����� "�������" => W9 = 0.3819 * (D - E) + E               |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 1.272 * (D - C),_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(0.3819 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M7:
      //+------------------------------------------------------------+
      //| �������: M7 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => W1  = 0.3819 * (D - E) + E              |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0.0; iEv = 0;
        //---
        pM = NormalizeDouble(0.3819 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M8:
      //+------------------------------------------------------------+
      //| �������: M8 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M4 = D - 0.618 * (D - C)                |
      //| ����� "�������" => W4 = 0.5 * (D - E) + E                  |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 0.618 * (D - C),_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(0.5 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M9:
      //+------------------------------------------------------------+
      //| �������: M9 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => W6  = 0.25 * (D - E) + E                |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0.0; iEv = 0;
        //---
        pM = NormalizeDouble(0.25 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M10:
      //+------------------------------------------------------------+
      //| �������: M10 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M6 = D - 0.618 * (D - C)                |
      //| ����� "�������" => W9 = 0.3819 * (D - E) + E               |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 0.618 * (D - C),_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(0.3819 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M11:
      //+------------------------------------------------------------+
      //| �������: M11 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M10 = D - 0.5 * (D - C)                 |
      //| ����� "�������" => W15 = 0.5 * (D - E) + E                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 0.5 * (D - C),_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(0.5 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M12:
      //+------------------------------------------------------------+
      //| �������: M12 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M7 = D - 3.0000 * (D - C)               |
      //| ����� "�������" => W1 = 0.3819 * (D - E) + E               |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 3.0000 * (D - C),_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(0.3819 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M13:
      //+------------------------------------------------------------+
      //| �������: M13 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M12 = D - 1.618 * (D - C)               |
      //| ����� "�������" => W4  = 0.5 * (D - E) + E                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 1.618 * (D - C),_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(0.5 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M14:
      //+------------------------------------------------------------+
      //| �������: M14 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M9 = D - 1.618 * (D - C)                |
      //| ����� "�������" => W6 = 0.25 * (D - E) + E                 |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(D - 1.618 * (D - C),_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(0.25 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M15:
      //+------------------------------------------------------------+
      //| �������: M15 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M14 = D - 1.272 * (D - C)               |
      //| ����� "�������" => W9  = 0.3819 * (D - E) + E              |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(C-(C-A)/1.618,_Digits);
        iEv= iTemp;
        //---
        pM = NormalizeDouble(E+(B-E)/1.618,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  M16:
      //+------------------------------------------------------------+
      //| �������: M16 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> M15 = D - 0.618 * (D - C)               |
      //| ����� "�������" => W15 = 0.5 * (D - E) + E                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(D - 0.618 * (D - C),_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(0.5 * (D - E) + E,_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W1:
      //+------------------------------------------------------------+
      //| �������: W1 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W2  = 0.618 * (C - D) + D               |
      //| ����� "�������" => M2  = E - 0.5 * (E - D)                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(0.618 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.5 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W2:
      //+------------------------------------------------------------+
      //| �������: W2 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W3  = 1.272 * (C - D) + D               |
      //| ����� "�������" => M8  = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(1.272 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W3:
      //+------------------------------------------------------------+
      //| �������: W3 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W8  = 1.618 * (C - D) + D               |
      //| ����� "�������" => M11 = E - 0.25 * (E - D)                |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(1.618 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.25 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W4:
      //+------------------------------------------------------------+
      //| �������: W4 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W5  = 1.618 * (C - D) + D               |
      //| ����� "�������" => M13 = E - 0.5 * (E - D)                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(1.618 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.5 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W5:
      //+------------------------------------------------------------+
      //| �������: W5 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W10 = 3.0000 * (C - D) + D              |
      //| ����� "�������" => M16 = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(3.0000 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W6:
      //+------------------------------------------------------------+
      //| �������: W6 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W7 = 0.5 * (C - D) + D                  |
      //| ����� "�������" => M2 = E - 0.5 * (E - D)                  |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(0.5 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.5 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W7:
      //+------------------------------------------------------------+
      //| �������: W7 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W11 = 0.618 * (C - D) + D               |
      //| ����� "�������" => M8  = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(0.618 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W8:
      //+------------------------------------------------------------+
      //| �������: W8 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => M11 = E - 0.25 * (E - D)                |
      //+------------------------------------------------------------+
        pE = 0; iEv= 0;        
        //---
        pM = NormalizeDouble(E - 0.25 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W9:
      //+------------------------------------------------------------+
      //| �������: W9 +++                                            |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W13 = 0.618 * (C - D) + D               |
      //| ����� "�������" => M13 = E - 0.5 * (E - D)                 |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(0.618 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.5 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W10:
      //+------------------------------------------------------------+
      //| �������: W10 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => M16 = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        pE = 0; iEv= 0;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;        
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W11:
      //+------------------------------------------------------------+
      //| �������: W11 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W12 = 1.272 * (C - D) + D               |
      //| ����� "�������" => M8  = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        pE = NormalizeDouble(1.272 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W12:
      //+------------------------------------------------------------+
      //| �������: W12 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => M11 = E - 0.25 * (E - D)                |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0; iEv= 0;        
        //---
        pM = NormalizeDouble(E - 0.25 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W13:
      //+------------------------------------------------------------+
      //| �������: W13 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W14 = 1.272 * (C - D) + D               |
      //| ����� "�������" => M13 = E - 0.5 * (E - D)                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(1.272 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.5 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W14:
      //+------------------------------------------------------------+
      //| �������: W14 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => M16 = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0; iEv= 0;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W15:
      //+------------------------------------------------------------+
      //| �������: W15 +++                                           |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> W16 = 1.618 * (C - D) + D               |
      //| ����� "�������" => M13 = E - 0.5 * (E - D)                 |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = NormalizeDouble(1.618 * (C - D) + D,_Digits);
        iEv= iTemp;        
        //---
        pM = NormalizeDouble(E - 0.5 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      case  W16:
      //+------------------------------------------------------------+
      //| �������: W16 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => M16 = E - 0.3819 * (E - D)              |
      //+------------------------------------------------------------+
        //--- level_0:
        pE = 0; iEv= 0;        
        //---
        pM = NormalizeDouble(E - 0.3819 * (E - D),_Digits);
        iM = iTemp;
        //--- level_1:
        CalcPrognozLevel1();
        break;
      default:
      //+------------------------------------------------------------+
      //| �������: ERROR                                             |
      //| ����� "��������"=> ��� = 0                                 |
      //| ����� "�������" => ��� = 0                                 |
      //+------------------------------------------------------------+
        pE = 0.0; pM = 0.0; iEv = 0; iM = 0; 
        //--- level_1:
        CalcPrognozLevel1();
        break;
     }
  }
//+------------------------------------------------------------------+
//| ��������� �������. level_1                                       |
//+------------------------------------------------------------------+
void MyCPatternZigzag::CalcPrognozLevel1(void)
  {
   double rA = 0.0, rB = 0.0;
   //---
   switch(pattern)
     {
      case  M1:
      //+------------------------------------------------------------+
      //| �������: M1 +                                              |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = ��� �����                               |
      //| ����� "�������"  = E+(B-D)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = 0.0;
        //---
        pM1  = NormalizeDouble(E+(B-D)*1.618,_Digits);
        break;
      case  M3:
      //+------------------------------------------------------------+
      //| �������: M3 +                                              |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = ��� �����                               |
      //| ����� "�������"  = E+(B-D)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = 0;
        //---
        pM1  = NormalizeDouble(E+(B-D)*1.618,_Digits);
        break;
      case  M5:
      //+------------------------------------------------------------+
      //| �������: M5 +                                              |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = ���                                     |
      //| ����� "�������"  = regress(B, D)                           |
      //+------------------------------------------------------------+
        pEv1 = 0;
        //---
        rA   = B; rB = D;
        pM1  = NormalizeDouble(CalcRegress(iM, rA, iB, rB, iD),_Digits);
        break;
      case  M13:
      //+------------------------------------------------------------+
      //| �������: M13 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = E-(B-A)*0.618                           |
      //| ����� "�������"  = E+(B-A)*0.618                           |
      //+------------------------------------------------------------+
        pEv1 = NormalizeDouble(E-(B-A)*0.618,_Digits);
        //---
        pM1  = NormalizeDouble(E+(B-A)*0.618,_Digits);
        break;
      case  M15:
      //+------------------------------------------------------------+
      //| �������: M15 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = E-(D-E)*1.618                           |
      //| ����� "�������"  = E+(D-E)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = NormalizeDouble(E-(D-E)*1.618,_Digits);
        //---
        pM1  = NormalizeDouble(E+(D-E)*1.618,_Digits);
        break;
      case  M16:
      //+------------------------------------------------------------+
      //| �������: M16 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = A-(B-A)*0.618                           |
      //| ����� "�������"  = E+(D-E)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = NormalizeDouble(A-(B-A)*0.618,_Digits);
        //---
        pM1  = NormalizeDouble(E+(D-E)*1.618,_Digits);
        break;
      case  W1:
      //+------------------------------------------------------------+
      //| �������: W1 +                                              |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = E+(A-B)*1.618                           |
      //| ����� "�������"  = E-(C-D)*0.618                           |
      //+------------------------------------------------------------+
        pEv1 = NormalizeDouble(E+(A-B)*1.618,_Digits);
        //---
        pM1  = NormalizeDouble(E-(C-D)*0.618,_Digits);
        break;
      case  W2:
      //+------------------------------------------------------------+
      //| �������: W2 +                                              |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = E+(E-D)*1.618                           |
      //| ����� "�������"  = E-(E-D)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = NormalizeDouble(E+(E-D)*1.618,_Digits);
        //---
        pM1  = NormalizeDouble(E-(E-D)*1.618,_Digits);
        break;
      case  W4:
      //+------------------------------------------------------------+
      //| �������: W4 +                                              |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = E+(B-A)*0.618                           |
      //| ����� "�������"  = E-(B-A)*0.618                           |
      //+------------------------------------------------------------+
        pEv1 = NormalizeDouble(E+(B-A)*0.618,_Digits);
        //---
        pM1  = NormalizeDouble(E-(B-A)*0.618,_Digits);
        break;
      case  W12:
      //+------------------------------------------------------------+
      //| �������: W12 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = ���                                     |
      //| ����� "�������"  = regress(B, D)                           |
      //+------------------------------------------------------------+
        pEv1 = 0;        
        //---
        rA   = B; rB = D;
        pM1  = NormalizeDouble(CalcRegress(iM, rA, iB, rB, iD),_Digits);
        break;
      case  W14:
      //+------------------------------------------------------------+
      //| �������: W14 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = ���                                     |
      //| ����� "�������"  = E-(C-B)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = 0;        
        //---
        pM1  = NormalizeDouble(E-(C-B)*1.618,_Digits);
        break;
      case  W16:
      //+------------------------------------------------------------+
      //| �������: W16 +                                             |
      //| ���������� ����� ��������:                                 |
      //| ����� "��������" = ���                                     |
      //| ����� "�������"  = E-(C-B)*1.618                           |
      //+------------------------------------------------------------+
        pEv1 = 0;        
        //---
        pM1  = NormalizeDouble(E-(C-B)*1.618,_Digits);
        break;
      default:
        //--- ��� �������...
        pEv1 = 0.0;                                   // �������: ������ ����� "�������� level_1"
        pM1  = 0.0;                                   // �������: ������ ����� "�������  level_1"
        break;
     }
  }
//+------------------------------------------------------------------+