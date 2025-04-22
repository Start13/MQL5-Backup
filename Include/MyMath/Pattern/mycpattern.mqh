//+------------------------------------------------------------------+
//|                                                   MyCPattern.mqh |
//|                                     Copyright 2014, A. Emelyanov |
//|                                        A.Emelyanov2010@yandex.ru |
//+------------------------------------------------------------------+
//| ������� �����:    M & W WAVE PATTERNS.                           |
//| ������� ������:   M & W ����, 16/16 = 32.                        |
//| ����������������: �� ������ ��������(5/5=10 ���/����� ��������). |
//| �� ���������� ����� �������� � ������� ����.                     |
//+------------------------------------------------------------------+
//|+ 06/06/2014: �������� ���������� ��������� ��������� dE/dD.      |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, A. Emelyanov"
#property link      "A.Emelyanov2010@yandex.ru"
#property version   "1.04"
//+------------------------------------------------------------------+
//| ������������ ����������                                          |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| ������������ ���������:                                          |
//| M1...M16 - M-WAVE                                                |
//| W1...W16 - W-WAVE                                                |
//+------------------------------------------------------------------+
//| ��� �� ������ ����� - ��� ������� �����!                         |
//| ����� ������������ ���������, ��� ��������!                      |
//+------------------------------------------------------------------+
//| ������� ������ ���-�����: 2                                      |
//+------------------------------------------------------------------+
enum NamePattern
  {
   ERROR     = 2,
   NOPATTERN = 3,
   W15       = 8,
   W16       = 12,
   M8        = 64,
   M4        = 80,
   M3        = 112,
   W9        = 512,
   W13       = 640,
   W14       = 896,
   M13       = 4096,
   M12       = 5120,
   M7        = 7168,
   W4        = 32768,
   W5        = 40960,
   W10       = 57344,
   M11       = 262144,
   M10       = 327680,
   M5        = 393216,
   M6        = 458752,
   M16       = 2097152,
   M15       = 2621440,
   M14       = 3145728,
   M9        = 3670016,
   W1        = 16777216,
   W2        = 20971520,
   W3        = 25165824,
   W8        = 29360128,
   W6        = 134217728,
   W7        = 167772160,
   W11       = 201326592,
   W12       = 234881024,
   M1        = 536870912,
   M2        = 805306368
  };
//+------------------------------------------------------------------+
//| ������� ����� MyCPattern                                         |
//+------------------------------------------------------------------+
class MyCPattern : public CObject
  {
protected:
   //--- ���������� ������
   double            A;                                           // ����� ������... �. �
   double            B;                                           // �. �
   double            C;                                           // �. �
   double            D;                                           // �. D
   double            E;                                           // �. �
   NamePattern       pattern;                                     // ������� �������
   NamePattern       oldPattern;                                  // ������� ������
   bool              IsPointNotReal;                              // �������� ����������� �. E (true - ���� �����������)
public:
                     MyCPattern();
                    ~MyCPattern();
   //--- ������ Get pattern  
   NamePattern       Get();                                       // ��������:(������!) ������� �������
   NamePattern       Get(double a, double b, double c,
                         double d, double e);                     // ��������:(������!) ������� ������� + ���������� �����.
   NamePattern       GetLastPattern() {return(pattern);};         // ��������:(���������� ���!) ��������� �������
   NamePattern       GetPrevPattern() {return(oldPattern);};      // ��������: ���������� �������   
   //--- ������ Get A, B...E
   double            GetA(){return(A);};                          // ��������: �������� ����� A
   double            GetB(){return(B);};                          // ��������: �������� ����� B
   double            GetC(){return(C);};                          // ��������: �������� ����� C
   double            GetD(){return(D);};                          // ��������: �������� ����� D
   double            GetE(){return(E);};                          // ��������: �������� ����� E
   //--- ������ Set A, B...E
   void              Set(double a, double b, double c, 
                         double d, double e);                     // ���������: A, B.. E
   void              SetA(double a){A=a;};                        // ����������: �������� A
   void              SetB(double b){B=b;};                        // ����������: �������� B
   void              SetC(double c){C=c;};                        // ����������: �������� C
   void              SetD(double d){D=d;};                        // ����������: �������� D
   void              SetE(double e){E=e;};                        // ����������: �������� E
   //--- ������ �������� � �������
   NamePattern       GetNextEvolution(void);                      // ��������: ��������� �������(����� �������� �����)
   NamePattern       GetNextMutation(void);                       // ��������: ��������� �������(����� ������� �����)
   int               IsRightEvolution(void);                      // ��������: ������������ ������ ��������(����� ��������)
   int               IsRightMutation(void);                       // ��������: ������������ ������ ��������(����� �������)
   bool              IsPointENotReal(){return(IsPointNotReal);};  // ��������: �������� �� �������� E
private:
   NamePattern       GetMutation(NamePattern NowPattern);         // �������� ������� ��������
   void              AnalysisPointE(void);                        // ����������(���������) ���������� ����� E
  };
//+------------------------------------------------------------------+
//| �����������                                                      |
//+------------------------------------------------------------------+
MyCPattern::MyCPattern()
  {
   //--- ������ ������...
   A = 0.0; B = 0.0; C = 0.0; D = 0.0; E = 0.0; 
   IsPointNotReal = false;
   pattern        = NOPATTERN;
   oldPattern     = NOPATTERN;
  }
//+------------------------------------------------------------------+
//| ������������                                                     |
//+------------------------------------------------------------------+
MyCPattern::~MyCPattern()
  {
  }
//+------------------------------------------------------------------+
//| ��������� ����������                                             |
//+------------------------------------------------------------------+
void MyCPattern::Set(double a,double b,double c,double d,double e)
  {
   //--- ������� ������...
   A = a; B = b; C = c; D = d; E = e;
  }
//+------------------------------------------------------------------+
//| ����� ��������� ������� � ������������� ���������                |
//+------------------------------------------------------------------+
NamePattern MyCPattern::Get(double a,double b,double c,double d,double e)
  {
   //--- ����� ������ Set...
   Set(a,b,c,d,e);
   //--- ����� ������ Get...
   return(Get());   
  }
//+------------------------------------------------------------------+
//| ����� ��������� �������                                          |
//+------------------------------------------------------------------+
NamePattern MyCPattern::Get(void)
  {
   //--- ��������� ����� �����
   IsPointNotReal = false;
   //--- ��������� ������ �������
   oldPattern = pattern;
   //--- M1
   if(B>A&&A>D&&D>C&&C>E)
     {
      pattern = M1;
      AnalysisPointE();
      return(pattern);
     }
   //--- M2
   if(B>A&&A>D&&D>E&&E>C)
     {
      pattern = M2;
      AnalysisPointE();
      return(pattern);
     }
   //--- M3
   if(B>D&&D>A&&A>C&&C>E)
     {
      pattern = M3;
      AnalysisPointE();
      return(pattern);
     }
   //--- M4
   if(B>D&&D>A&&A>E&&E>C)
     {
      pattern = M4;
      AnalysisPointE();
      return(pattern);
     }
   //--- M5
   if(D>B&&B>A&&A>C&&C>E)
     {
      pattern = M5;
      AnalysisPointE();
      return(pattern);
     }
   //--- M6
   if(D>B&&B>A&&A>E&&E>C)
     {
      pattern = M6;
      AnalysisPointE();
      return(pattern);
     }
   //--- M7
   if(B>D&&D>C&&C>A&&A>E)
     {
      pattern = M7;
      AnalysisPointE();
      return(pattern);
     }
   //--- M8
   if(B>D&&D>E&&E>A&&A>C)
     {
      pattern = M8;
      AnalysisPointE();
      return(pattern);
     }
   //--- M9
   if(D>B&&B>C&&C>A&&A>E)
     {
      pattern = M9;
      AnalysisPointE();
      return(pattern);
     }
   //--- M10
   if(D>B&&B>E&&E>A&&A>C)
     {
      pattern = M10;
      AnalysisPointE();
      return(pattern);
     }
   //--- M11
   if(D>E&&E>B&&B>A&&A>C)
     {
      pattern = M11;
      AnalysisPointE();
      return(pattern);
     }
   //--- M12
   if(B>D&&D>C&&C>E&&E>A)
     {
      pattern = M12;
      AnalysisPointE();
      return(pattern);
     }
   //--- M13
   if(B>D&&D>E&&E>C&&C>A)
     {
      pattern = M13;
      AnalysisPointE();
      return(pattern);
     }
   //--- M14
   if(D>B&&B>C&&C>E&&E>A)
     {
      pattern = M14;
      AnalysisPointE();
      return(pattern);
     }
   //--- M15
   if(D>B&&B>E&&E>C&&C>A)
     {
      pattern = M15;
      AnalysisPointE();
      return(pattern);
     }
   //--- M16
   if(D>E&&E>B&&B>C&&C>A)
     {
      pattern = M16;
      AnalysisPointE();
      return(pattern);
     }
   //--- W1
   if(A>C&&C>B&&B>E&&E>D)
     {
      pattern = W1;
      AnalysisPointE();
      return(pattern);
     }
   //--- W2
   if(A>C&&C>E&&E>B&&B>D)
     {
      pattern = W2;
      AnalysisPointE();
      return(pattern);
     }
   //--- W3
   if(A>E&&E>C&&C>B&&B>D)
     {
      pattern = W3;
      AnalysisPointE();
      return(pattern);
     }
   //--- W4
   if(A>C&&C>E&&E>D&&D>B)
     {
      pattern = W4;
      AnalysisPointE();
      return(pattern);
     }
   //--- W5
   if(A>E&&E>C&&C>D&&D>B)
     {
      pattern = W5;
      AnalysisPointE();
      return(pattern);
     }
   //--- W6
   if(C>A&&A>B&&B>E&&E>D)
     {
      pattern = W6;
      AnalysisPointE();
      return(pattern);
     }
   //--- W7
   if(C>A&&A>E&&E>B&&B>D)
     {
      pattern = W7;
      AnalysisPointE();
      return(pattern);
     }
   //--- W8
   if(E>A&&A>C&&C>B&&B>D)
     {
      pattern = W8;
      AnalysisPointE();
      return(pattern);
     }
   //--- W9
   if(C>A&&A>E&&E>D&&D>B)
     {
      pattern = W9;
      AnalysisPointE();
      return(pattern);
     }
   //--- W10
   if(E>A&&A>C&&C>D&&D>B)
     {
      pattern = W10;
      AnalysisPointE();
      return(pattern);
     }
   //--- W11
   if(C>E&&E>A&&A>B&&B>D)
     {
      pattern = W11;
      AnalysisPointE();
      return(pattern);
     }
   //--- W12
   if(E>C&&C>A&&A>B&&B>D)
     {
      pattern = W12;
      AnalysisPointE();
      return(pattern);
     }
   //--- W13
   if(C>E&&E>A&&A>D&&D>B)
     {
      pattern = W13;
      AnalysisPointE();
      return(pattern);
     }
   //--- W14
   if(E>C&&C>A&&A>D&&D>B)
     {
      pattern = W14;
      AnalysisPointE();
      return(pattern);
     }
   //--- W15
   if(C>E&&E>D&&D>A&&A>B)
     {
      pattern = W15;
      AnalysisPointE();
      return(pattern);
     }
   //--- W16
   if(E>C&&C>D&&D>A&&A>B)
     {
      pattern = W16;
      AnalysisPointE();
      return(pattern);
     }
   //--- NOPATTERN
   pattern = NOPATTERN;
   return(pattern);
  }
//+------------------------------------------------------------------+
//| ������ �������� � �������                                        |
//+------------------------------------------------------------------+
//| �������� ��������� �������(����� �������� �����)                 |
//|��������: �������� ������� ����� ������ Get()!                    |
//+------------------------------------------------------------------+
//|out: ������� ��������� ��������                                   |
//+------------------------------------------------------------------+
NamePattern MyCPattern::GetNextEvolution(void)
  {
   //--- M1->M2
   if(pattern == M1)  return(NOPATTERN);
   if(pattern == M2)  return(M1);
   //--- M8->M4->M3
   if(pattern == M3)  return(NOPATTERN);
   if(pattern == M4)  return(M3);
   if(pattern == M8)  return(M4);
   //--- M11->M10->M6->M5
   if(pattern == M5)  return(NOPATTERN);
   if(pattern == M6)  return(M5);
   if(pattern == M10) return(M6);
   if(pattern == M11) return(M10);
   //--- M13->M12->M7
   if(pattern == M7)  return(NOPATTERN);
   if(pattern == M12) return(M7);
   if(pattern == M13) return(M12);
   //--- M16->M15->M14->M9
   if(pattern == M9)  return(NOPATTERN);
   if(pattern == M14) return(M9);
   if(pattern == M15) return(M14);
   if(pattern == M16) return(M15);
   //--- W1->W2->W3->W8
   if(pattern == W8)  return(NOPATTERN);
   if(pattern == W3)  return(W8);
   if(pattern == W2)  return(W3);
   if(pattern == W1)  return(W2);
   //--- W4->W5->W10
   if(pattern == W10) return(NOPATTERN);
   if(pattern == W5)  return(W10);
   if(pattern == W4)  return(W5);
   //--- W6->W7->W11->W12
   if(pattern == W12) return(NOPATTERN);
   if(pattern == W11) return(W12);
   if(pattern == W7)  return(W11);
   if(pattern == W6)  return(W7);
   //--- W9->W13->W14
   if(pattern == W14) return(NOPATTERN);
   if(pattern == W13) return(W14);
   if(pattern == W9)  return(W13);
   //--- W16->W15
   if(pattern == W16) return(NOPATTERN);
   if(pattern == W15) return(W16);
   //--- ��� ����������� � "������ �������"
   return(NOPATTERN);
  }
//+------------------------------------------------------------------+
//| �������� ��������� �������(����� ������� �����)                  |
//|��������: �������� ������� ����� ������ Get()!                    |
//+------------------------------------------------------------------+
//|out: ������� ��������� ��������                                   |
//+------------------------------------------------------------------+
NamePattern MyCPattern::GetNextMutation(void)
  {
   return(GetMutation(pattern));
  }
//+------------------------------------------------------------------+
//| �������� ������� �����. ���������� �����!                        |
//+------------------------------------------------------------------+
//|out: ������� ��������� ��������                                   |
//+------------------------------------------------------------------+
NamePattern MyCPattern::GetMutation(NamePattern NowPattern)
  {
   //--- W1: M1, M3, M7, M12
   if((NowPattern == M1)||(NowPattern == M3)||(NowPattern == M7)||(NowPattern == M12))   return(W1);
   //--- W4: M2, M4, M8, M13
   if((NowPattern == M2)||(NowPattern == M4)||(NowPattern == M8)||(NowPattern == M13))   return(W4);
   //--- W6: M5, M9, M14
   if((NowPattern == M5)||(NowPattern == M9)||(NowPattern == M14))  return(W6);
   //--- W9: M6, M10, M15
   if((NowPattern == M6)||(NowPattern == M10)||(NowPattern == M15)) return(W9);
   //--- W15: M11, M16
   if((NowPattern == M11)||(NowPattern == M16)) return(W15);
   //--- M2: W1, W6
   if((NowPattern == W1)||(NowPattern == W6))   return(M2);
   //--- M8: W2, W7, W11
   if((NowPattern == W2)||(NowPattern == W7)||(NowPattern == W11))  return(M8);
   //--- M11: W3, W8, W12
   if((NowPattern == W3)||(NowPattern == W8)||(NowPattern == W12))  return(M11);
   //--- M13: W4, W9, W13, W15
   if((NowPattern == W4)||(NowPattern == W9)||(NowPattern == W13)||(NowPattern == W15))  return(M13);
   //--- M16: W5, W10, W14, W16
   if((NowPattern == W5)||(NowPattern == W10)||(NowPattern == W14)||(NowPattern == W16)) return(M16);
   //--- ��� ����������� � "������ �������"
   return(NOPATTERN);
  }
//+------------------------------------------------------------------+
//| �������� ������������ ������ ��������(����� ��������)            |
//+------------------------------------------------------------------+
//|out: 1-�������� ����, 0-�� ���� ��������, -1-�� ��������� ������� |
//+------------------------------------------------------------------+
int MyCPattern::IsRightEvolution(void)
  {
   //--- � ��� ����� �������?
   if(oldPattern != pattern)
     {
      //+------------------------------------------------------------+
      //| ������ ����� �������� ����� ��������� � ���� ������� �����,|
      //|������� ��� ����� ������ ������� ��������, ���������� ���-  |
      //|������� ���������� �, ���� ����� �� ���� - ������ ��������! |
      //+------------------------------------------------------------+
      //| "����� ��������-�������" :-)                               |
      //+------------------------------------------------------------+
      if((oldPattern & pattern) != 0) return(1);
	  //--- �� ���� ��������
	  return(0);
     }
   //--- �� ��������� �������
   return(-1);
  }
//+------------------------------------------------------------------+
//| �������� ������������ ������ ��������(����� �������)             |
//+------------------------------------------------------------------+
//|out: 1- ������� ����, 0- �� ���� �������, -1-�� ��������� ������� |
//+------------------------------------------------------------------+
int MyCPattern::IsRightMutation(void) 
  {
   //--- � ��� ����� �������?
   if(oldPattern != pattern)
     {
      //--- �������� ������� ����� �������
      NamePattern MajorMutation = GetMutation(oldPattern);
      //+------------------------------------------------------------+
      //| ������ ����� �������� ����� ��������� � ���� ������� �����,|
      //|������� ��� ����� ������ ������� ��������, ���������� ���-  |
      //|������� ���������� � .                                      |
      //+------------------------------------------------------------+
      //| "����� ��������-�������" :-)                               |
      //+------------------------------------------------------------+
      if((MajorMutation & pattern) != 0) return(1);
	  //--- �� ���� �������
	  return(0);
     }
   //--- �� ��������� �������
   return(-1);
  }
//+------------------------------------------------------------------+
//| ����������(���������) ���������� ����� E.                        |
//| ��������: �������� ������� ���� � ������������� �� ��������� ��- |
//| �������� "��������� ���������" ("������� �������" ������ 1):     |
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
void MyCPattern::AnalysisPointE(void)
  {
   //--- ����������� ����� �����
   IsPointNotReal = false;
   //--- 1. ���� ������� ��������� �� ����� �������������/�������������� �������� E
   if((pattern != NOPATTERN)&&(pattern != ERROR))
     {
      if(pattern == M1)
        {
         if(((D-E)/(D-C)) < 1.618)
           {
            E = NormalizeDouble(D - 1.618 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M2)
        {
         if(((D-E)/(D-C)) < 0.5)
           {
            E = NormalizeDouble(D - 0.5 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M3)
        {
         if(((D-E)/(D-C)) < 1.2720)
           {
            E = NormalizeDouble(D - 1.2720 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M4)
        {
         if(((D-E)/(D-C)) < 0.618)
           {
            E = NormalizeDouble(D - 0.618 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M5)
        {
         if(((D-E)/(D-C)) < 1.2720)
           {
            E = NormalizeDouble(D - 1.2720 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M6)
        {
         if(((D-E)/(D-C)) < 0.618)
           {
            E = NormalizeDouble(D - 0.618 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M7)
        {
         if(((D-E)/(D-C)) < 3.0000)
           {
            E = NormalizeDouble(D - 3.0000 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M8)
        {
         if(((D-E)/(D-C)) < 0.3819)
           {
            E = NormalizeDouble(D - 0.3819 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M9)
        {
         if(((D-E)/(D-C)) < 1.618)
           {
            E = NormalizeDouble(D - 1.618 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M10)
        {
         if(((D-E)/(D-C)) < 0.5)
           {
            E = NormalizeDouble(D - 0.5 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M11)
        {
         if(((D-E)/(D-C)) < 0.25)
           {
            E = NormalizeDouble(D - 0.25 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M12)
        {
         if(((D-E)/(D-C)) < 1.618)
           {
            E = NormalizeDouble(D - 1.618 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M13)
        {
         if(((D-E)/(D-C)) < 0.5)
           {
            E = NormalizeDouble(D - 0.5 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M14)
        {
         if(((D-E)/(D-C)) < 1.2720)
           {
            E = NormalizeDouble(D - 1.2720 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M15)
        {
         if(((D-E)/(D-C)) < 0.618)
           {
            E = NormalizeDouble(D - 0.618 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == M16)
        {
         if(((D-E)/(D-C)) < 0.3819)
           {
            E = NormalizeDouble(D - 0.3819 * (D - C),_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W1)
        {
         if(((E-D)/(C-D)) < 0.3819)
           {
            E = NormalizeDouble(0.3819 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W2)
        {
         if(((E-D)/(C-D)) < 0.618)
           {
            E = NormalizeDouble(0.618 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W3)
        {
         if(((E-D)/(C-D)) < 1.2720)
           {
            E = NormalizeDouble(1.2720 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W4)
        {
         if(((E-D)/(C-D)) < 0.5)
           {
            E = NormalizeDouble(0.5 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W5)
        {
         if(((E-D)/(C-D)) < 1.618)
           {
            E = NormalizeDouble(1.618 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W6)
        {
         if(((E-D)/(C-D)) < 0.25)
           {
            E = NormalizeDouble(0.25 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W7)
        {
         if(((E-D)/(C-D)) < 0.5)
           {
            E = NormalizeDouble(0.5 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W8)
        {
         if(((E-D)/(C-D)) < 1.618)
           {
            E = NormalizeDouble(1.618 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W9)
        {
         if(((E-D)/(C-D)) < 0.3819)
           {
            E = NormalizeDouble(0.3819 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W10)
        {
         if(((E-D)/(C-D)) < 3.0000)
           {
            E = NormalizeDouble(3.0000 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W11)
        {
         if(((E-D)/(C-D)) < 0.618)
           {
            E = NormalizeDouble(0.618 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W12)
        {
         if(((E-D)/(C-D)) < 1.2720)
           {
            E = NormalizeDouble(1.2720 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W13)
        {
         if(((E-D)/(C-D)) < 0.618)
           {
            E = NormalizeDouble(0.618 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
     if(pattern == W14)
        {
         if(((E-D)/(C-D)) < 1.2720)
           {
            E = NormalizeDouble(1.2720 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W15)
        {
         if(((E-D)/(C-D)) < 0.5)
           {
            E = NormalizeDouble(0.5 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
      if(pattern == W16)
        {
         if(((E-D)/(C-D)) < 1.618)
           {
            E = NormalizeDouble(1.618 * (C - D) + D,_Digits);
            //--- ���� �����������
            IsPointNotReal = true;
           }
        }
     }
  }
//--------------------------------------------------------------------
