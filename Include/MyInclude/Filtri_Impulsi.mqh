#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
//|                        OrdiniSuStessaCandela                     |Restituisce false quando sulla stessa candela è stato aperto un primo ordine
//+------------------------------------------------------------------+
bool OrdiniSuStessaCandela(bool ordStCand, ulong mag,string comm)   
  {
   bool a = true;
   if(ordStCand)return a;
     
   int static pos = 0;    // Numero posizioni aperte
   int static cand = 0;   // Numero candela all'apertura ordine
   int numOrd = NumPrimiOrdini(mag);
   
   if(numOrd < pos) {pos  = numOrd;}   //se chiude posizioni
   if(numOrd > pos)    //se apre nuove posizioni o chiude posizioni
     {
      pos  = numOrd;    // "a" memorizza il numero di posizioni aperte
      cand = iBars(Symbol(),PERIOD_CURRENT);
     } // "b" memorizza la candela di variazione posizioni

   if(pos == numOrd && cand == iBars(Symbol(),PERIOD_CURRENT)) {a = false;}

   if(pos == numOrd && cand != iBars(Symbol(),PERIOD_CURRENT)) {a = true;}

   return a;
  }
//+------------------------------------------------------------------+
//|                   filtrochiusuraOrdiniStessaCandela              |Restituisce false quando sulla stessa candela è stato chiuso o aperto un primo ordine
//+------------------------------------------------------------------+
bool filtrochiusuraOrdiniStessaCandela(ulong magicNum)
  {
   bool c = true;
   int static a = 0;   // Numero posizioni aperte
   int  static b = 0;   // Numero candela all'apertura ordine
   int  barre = iBars(Symbol(),PERIOD_CURRENT);
   int  numPos = NumPrimiOrdini(magicNum);
   
   if(a != numPos)    //se apre nuove posizioni o chiude posizioni
     {
      a = numPos;    // "a" memorizza il numero di posizioni aperte
      b = barre;     // "b" memorizza la candela di variazione posizioni
     } 
   if(numPos == a && barre == b) c = false;
   if(numPos == a && barre != b) c = true;    
   return c;
  }
//+------------------------------------------------------------------+
//|                      OrdiniSuStessaCand                          |Restituisce false quando sulla stessa candela è stato chiuso o aperto un primo ordine
//+------------------------------------------------------------------+
bool OrdiniSuStessaCand(bool ordSuStessaCand,ulong magic)
  {
   bool c=true;
  if(ordSuStessaCand){c = true;return c;}
   int  static a = 0;   // static per Numero posizioni aperte
   int  static b = 0;   // Numero candela all'apertura ordine
   int  numord   = NumOrdini(magic);
   int  numBars  = iBars(Symbol(),PERIOD_CURRENT);
   
   if(a != numord)    //se apre nuove posizioni o chiude posizioni
     {
      a  = numord;    // "a" memorizza il numero di posizioni aperte
      b = numBars;    // "b" memorizza la candela di variazione posizioni
     } 
   if(a == numord &&  b == numBars) c = false;
   if(a == numord &&  b != numBars) c = true;
   return c;
  }  
//+------------------------------------------------------------------+
//|                      OrdiniSuStessaCandela                       |
//+------------------------------------------------------------------+
bool OrdiniSuStessaCandela(const string &sniperStri[], const int &arrInput__[], const double &valoriArr_[])
  {
   bool static c;
  if(arrInput__[22]){c = true;return c;}
   char static a = 0;   // Numero posizioni aperte
   int  static b = 0;   // Numero candela all'apertura ordine
   
   if(a != NumPosiz(sniperStri, arrInput__, valoriArr_))    //se apre nuove posizioni o chiude posizioni
     {
      a  = NumPosiz(sniperStri, arrInput__, valoriArr_);    // "a" memorizza il numero di posizioni aperte
      b = iBars(Symbol(),PERIOD_CURRENT);
     } // "b" memorizza la candela di variazione posizioni

   if(a == NumPosiz(sniperStri, arrInput__, valoriArr_) &&  b == iBars(Symbol(),PERIOD_CURRENT)) {c = false;}

   if(a == NumPosiz(sniperStri, arrInput__, valoriArr_) &&  b != iBars(Symbol(),PERIOD_CURRENT)) {c = true;}

   return c;
  }

//+------------------------------------------------------------------+
//|                        RSIStochastic()                           |
//+------------------------------------------------------------------+ 
void RSIStochastic(ENUM_TIMEFRAMES periodstok,int Kperiod,int Dperiod,int SlowDown_,ENUM_MA_METHOD stokmethod,ENUM_STO_PRICE StochasticCalculationMethod,int IndiceCandela,double &KValue,double &DValue)
{  
//creating arrays for %K line and %D line   
   double Karray[];
   double Darray[];
//sorting arrays from the current data   
   ArraySetAsSeries(Karray, true);
   ArraySetAsSeries(Darray, true);
int handleStok=iStochastic(Symbol(),periodstok,Kperiod,Dperiod,SlowDown_,stokmethod,StochasticCalculationMethod);
   if(handleStok>INVALID_HANDLE){
   if(CopyBuffer(handleStok,0,IndiceCandela,1,Karray)) {if(ArraySize(Karray) > 0) KValue = Karray[0];}
   if(CopyBuffer(handleStok,1,IndiceCandela,1,Darray)) {if(ArraySize(Darray) > 0) DValue = Darray[0];}
//commenting calcualted values on the chart   
//Comment("K value is ",KValue,"\n""D Value is ",DValue);    
}      
}
//+------------------------------------------------------------------+
//|                        CrossStochastic()                         |
//+------------------------------------------------------------------+ 
bool CrossStochastic(bool enable,int liveCandle1,ENUM_TIMEFRAMES periodstok,int Kperiod,int Dperiod,int SlowDown_,ENUM_MA_METHOD stokmethod,ENUM_STO_PRICE StochasticCalculationMethod,
                     int IndiceCandela,double livSup,double livInf,double &KValue,double &DValue,bool &Buy,bool &Sell)
{
bool a = false;
Buy    = false;
Sell   = false;
if(!enable) return a;
int prec=0;
int succ=0;
if(!liveCandle1){prec=0;succ=1;}
if(liveCandle1==1){prec=1;succ=2;}
RSIStochastic(periodstok,Kperiod,Dperiod,SlowDown_,stokmethod,StochasticCalculationMethod,prec,KValue,DValue);
double KValue1=KValue;
double DValue1=DValue;
RSIStochastic(periodstok,Kperiod,Dperiod,SlowDown_,stokmethod,StochasticCalculationMethod,succ,KValue,DValue);
double KValue2=KValue;
double DValue2=DValue;

   if (KValue1<livInf&&DValue1<livInf&&KValue1>DValue1&&KValue2<DValue2) {Buy = true;} 
   if (KValue1>livSup&&DValue1>livSup&&KValue1<DValue1&&KValue2>DValue2) {Sell = true;}
   if (Buy||Sell) a = true;
return a;   
}
/*
//-------- RSIStochastic ------------------
enum StokbelowLevel1
  {
   noFilter                        = 0, //Buy and Sell
   OnlyBuy                         = 1, //Only Buy
   OnlySell                        = 2, //Only Sell
   DisableOrders                   = 3, //No Buy / No Sell
  };
enum StokDaLev1Alev2
  {
   noFilter                        = 0, //Buy and Sell
   OnlyBuy                         = 1, //Only Buy
   OnlySell                        = 2, //Only Sell
   DisableOrders                   = 3, //No Buy / No Sell
  };
enum StokaboveLevel2
  {
   noFilter                        = 0, //Buy and Sell
   OnlyBuy                         = 1, //Only Buy
   OnlySell                        = 2, //Only Sell
   DisableOrders                   = 3, //No Buy / No Sell
  };  
*/  
//+------------------------------------------------------------------+
//|                       filtroRSIStochastic                        |
//+------------------------------------------------------------------+
bool filtroRSIStochastic(bool FilterRSIstok,int aboveLev2_,int daLev1Alev2_,int belowLev1_,int liveCandle1,ENUM_TIMEFRAMES periodstok,int Kperiod,int Dperiod,int SlowDown_,ENUM_MA_METHOD stokmethod,ENUM_STO_PRICE StochasticCalculationMethod,
                         int IndiceCandela,double livSup,double livInf,double &KValue,double &DValue,bool &Buy,bool &Sell)
  {
bool a = true;  
Buy    = true;
Sell   = true;
if(!FilterRSIstok) return a;

int prec=0;
int succ=0;
bool inf=false;
bool medium=false;
bool high_=false;
if(!liveCandle1)prec=0;
if(liveCandle1==1)prec=1;

RSIStochastic(periodstok,Kperiod,Dperiod,SlowDown_,stokmethod,StochasticCalculationMethod,prec,KValue,DValue);

   if (KValue<livInf&&DValue<livInf) inf = true;
   if (KValue<=livSup&&DValue>=livInf&&DValue<=livSup&&DValue>=livInf) medium = true;
   if (KValue>livSup&&DValue>livSup) high_ = true;

   if((aboveLev2_ != 0) && (aboveLev2_ == 2 || aboveLev2_ == 3) &&  high_){Buy = false;  }//sopra liv 2,
   if((daLev1Alev2_ != 0) && (daLev1Alev2_ == 2 || daLev1Alev2_ == 3) && medium){Buy = false;  }//medio , solo sell e block
   if((belowLev1_ != 0) && (belowLev1_ == 2 || belowLev1_ == 3) &&  inf){Buy = false;  }//sotto liv 1 - solo sell e block
        
   if((aboveLev2_ != 0) && (aboveLev2_ == 1 || aboveLev2_ == 3) &&  high_){Sell = false;}
   if((daLev1Alev2_ != 0) && (daLev1Alev2_ == 1 || daLev1Alev2_ == 3) && medium){Sell = false;}
   if((belowLev1_ != 0) && (belowLev1_ == 1 || belowLev1_ == 3) &&  inf){Sell = false;  }//sotto liv 1 - solo buy e block

   return a;
  }
//+------------------------------------------------------------------+
//|                         numMaxOrdInsieme()                       |Da rifinire con il controllo Grid ed Hedge
//+------------------------------------------------------------------+  
bool numMaxOrdInsieme(int N_Max_pos_,bool &numMaxBuy,bool &numMaxSell,ulong magic)
{
bool a    = true;
numMaxBuy = true;
numMaxSell= true;
if(NumPrimiOrdini(magic)>=N_Max_pos_){numMaxBuy=false;numMaxSell=false;a=false;}
if(N_Max_pos_>1&&(TicketPrimoOrdineBuy(magic))){numMaxBuy=false;a=false;}
if(N_Max_pos_>1&&(TicketPrimoOrdineSell(magic))){numMaxSell=false;a=false;}
return a;
}  


//+------------------------------------------------------------------+
//|                         ordini_Tipo_NumMax()                     |
//+------------------------------------------------------------------+  

/*
   enum nMaxPos
  {
   Una_posizione   = 1,  //Max 1 Ordine
   Due_posizioni   = 2,  //Max 2 Ordini
  };

   enum Type_Orders
  {
   Buy_Sell         = 0,               //Orders Buy e Sell
   Buy              = 1,               //Only Buy Orders
   Sell             = 2                //Only Sell Orders
  };
*/

//input Type_Orders Type_Orders_               =   0;         //Tipo di Ordini
//input nMaxPos     N_Max_pos                  =   1;         //Massimo numero di Ordini contemporaneamente

//ordini_Tipo_NumMax( "Buy",Type_Orders_,N_Max_pos,magicNumber,Commen)
bool ordini_Tipo_NumMax(string BuySell,int tipoBuySell,int N_Max_pos_,ulong magic,string comment)
{
bool a    = true;
if(BuySell == "Buy"  && (NumOrdini(magic,comment) >= N_Max_pos_ || NumOrdBuy(magic,comment)  || tipoBuySell == 2)) {a = false; return a;}

if(BuySell == "Sell" && (NumOrdini(magic,comment) >= N_Max_pos_ || NumOrdSell(magic,comment) || tipoBuySell == 1)) {a = false; return a;}

return a;
}  

//+------------------------------------------------------------------+
//|                          SpreadMax()                             |
//+------------------------------------------------------------------+
// input int SpreadMax                                          =    0;        //Spread Max consentito  incollare negl'input'


bool FiltroSpreadMax(int MaxSpread_)
  {
   int Spread=(int)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
   bool a=false;
   if(MaxSpread_==0 || ((Spread < MaxSpread_) && MaxSpread_!=0))
     {a=true;}
   return a;
  }