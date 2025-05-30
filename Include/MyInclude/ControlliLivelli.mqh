
#include <MyLibrary\MyLibrary.mqh>


//+------------------------------------------------------------------+
//|                       controlAccounts                            |
//+------------------------------------------------------------------+
/*
//------------ Controllo Numero Licenze e tempo Trial, Corrado ----------------------
datetime TimeLicence = D'3000.01.01 00:00:00';
long NumeroAccountOk [10];
long NumAccount0 = NumeroAccountOk[0] = 37114023;
long NumAccount1 = NumeroAccountOk[1] = 68152694;
long NumAccount2 = NumeroAccountOk[2] = 37127778;
long NumAccount3 = NumeroAccountOk[3] = 27081543;
long NumAccount4 = NumeroAccountOk[4] = 68170289;
long NumAccount5 = NumeroAccountOk[5] = 68168753;
long NumAccount6 = NumeroAccountOk[6] = 8918163;
long NumAccount7 = NumeroAccountOk[7] = 67113373;
long NumAccount8 = NumeroAccountOk[8] = 62039500;
long NumAccount9 = NumeroAccountOk[9] = 62039500;
*/
bool controlloAccounts(datetime TimeLicence,long NumAccount0,long NumAccount1,long NumAccount2,long NumAccount3,long NumAccount4,
                                         long NumAccount5,long NumAccount6,long NumAccount7,long NumAccount8,long NumAccount9)
  {
   if(!IsConnected())
     {
      Print("No connection");
      return true;
     }
   bool a = false;
   if(AccountNumber() == NumAccount0 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount1 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount2 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount3 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount4 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount5 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount6 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount7 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount8 && TimeLicence > TimeCurrent()) a = true;
   if(AccountNumber() == NumAccount9 && TimeLicence > TimeCurrent()) a = true;      
   if(a == true) Print("EA: Account Ok!");
   else
     {(Print("EA: trial license expired or Account without permission")); ExpertRemove();}
   return a;
  }




/*
int MeterPriceFascie(double priceInput,double &arrPrezzi[], int PercLivPerOpenPos_, int AbovePercNoOrder_,
                     double &prezzoLivPrec,double &prezzoLivSucc, double &sogliaPrecedente, double &sogliaSuccessiva, 
                     bool &fasciaLevel, bool &fasciaThreshol, int &fasciaDiPrezz)*/

//+------------------------------------------------------------------+
//|                      TpRaggiuntoCandPrima                        |
//+------------------------------------------------------------------+
/*
input int                    numCandLevSuccRaggiunto         = 0;         //If Tp level reached n° candles before: No Open Order
input int                    percLevTpRaggiunto              = 100;       //The % of Tp level achieved  
*/
bool TpRaggiuntoCandPrima (int nCandele, int percLevTpRagg, double &arrPrice[])
{
bool a = true;
if(nCandele<0 || percLevTpRagg<0){Print("Fix Setting \"N° of candles before Tp % reached: NO Open Order\" or \"The Tp % \"");
                                  Alert("Fix Setting \"N° of candles before Tp % reached: NO Open Order\" or \"The Tp % \"");return a;}
if(!nCandele)return a;
//Print(" nCandele: ",nCandele," percLevTpRagg: ",percLevTpRagg," A: ",a);
double sogliaPrec=0;
double sogliaSuccess=0;
double pricLivPrec  =0;
double pricLivSucc  =0;
double priceC1=iClose(Symbol(),PERIOD_CURRENT,1);
bool   fasciaLevel;
bool   fasciaThreshol;
int    fasciaDiPr;
int    ValoreFiltroAboveBelow=MeterPriceFascie(priceC1, arrPrice, 0, percLevTpRagg, pricLivPrec, pricLivSucc, sogliaPrec, sogliaSuccess,fasciaLevel, fasciaThreshol, fasciaDiPr);
//Print(" priceC1: ",priceC1," percLevTpRagg: ",percLevTpRagg," ValoreFiltroAboveBelow: ",ValoreFiltroAboveBelow," pricLivPrec: ",pricLivPrec," pricLivSucc: ",pricLivSucc," sogliaPrec: ",sogliaPrec," sogliaSuccess: ",sogliaSuccess," A: ",a);                     
if(priceC1>=pricLivPrec)
{
for(int i=1;i<=nCandele;i++)
{
double HighCand=iHigh(Symbol(),PERIOD_CURRENT,i);
if(HighCand>=sogliaSuccess){Print("Buy Stop Tp");a=false;return a;}
}}

if(priceC1<=sogliaPrec)
{
for(int i=1;i<=nCandele;i++)
{
double LowCand=iLow(Symbol(),PERIOD_CURRENT,i);
if(LowCand<=sogliaSuccess){Print("Sell Stop Tp");a=false;return a;}
}}
//Print(" TpRaggiuntoCandPrima: ",a);
return a;
}
/*
   arrPric[0] = price_;
   R1Price_   = arrPric[1];
   R2Price_   = arrPric[2];
   R3Price_   = arrPric[3];
   R4Price_   = arrPric[4];
   R5Price_   = arrPric[5];

   S1Price_   = arrPric[6];
   S2Price_   = arrPric[7];
   S3Price_   = arrPric[8];
   S4Price_   = arrPric[9];
   S5Price_   = arrPric[10];
   BuyAbove_  = arrPric[11];
   SellBelow_ = arrPric[12];
   arrPric[13]= priceDay;
   arrPric[14]= priceWeek;
   arrPric[15]= ThresholdUp_;//Per visualizzazione grafica
   arrPric[16]= ThresholdDw_;//Per visualizzazione grafica
   
   valoriArr [0]  = priceW;
   valoriArr [1]  = prezzoPivot;
   valoriArr [2]  = compraSopra;
   valoriArr [3]  = primoLevBuy;
   valoriArr [4]  = secondoLevBuy;
   valoriArr [5]  = terzoLevBuy;
   valoriArr [6]  = quartoLevBuy;
   valoriArr [7]  = quintoLevBuy;
   valoriArr [8]  = vendiSotto;
   valoriArr [9]  = primoLevSell;
   valoriArr [10] = secondoLevSell;
   valoriArr [11] = terzoLevSell;
   valoriArr [12] = quartoLevSell;
   valoriArr [13] = quintoLevSell;
   
   */
//+------------------------------------------------------------------+
//|                         MeterPriceInFascie()                     |
//+------------------------------------------------------------------+
// Elabora il prezzo passato in "priceInput"
// Restituisce "2"  se il prezzo è compreso tra le soglie Level consentite BUY.
// Restituisce "1"  se il prezzo è compreso tra le soglie AboveBelowPerc consentite BUY.
// Restituisce "0"  se il prezzo NON è compreso tra le soglie consentite.
// Restituisce "-1" se il prezzo è compreso tra le soglie AboveBelowPerc consentite SELL.
// Restituisce "-2" se il prezzo è compreso tra le soglie Level consentite SELL.
// Restituisce anche i valori della "sogliaPrecedente" e della "sogliaSuccessiva"
// Restituisce anche i valori del "LivelloPrecedente" e del "LivelloSuccessivo"
// Restituisce anche il valore bool della "fasciaLevel" e della "fasciaThreshol"
// Restituisce anche il valore int della "fasciaDiPrezzo" del priceInput
int MeterPriceFascie(double priceInput,double &arrPrezzi[], int PercLivPerOpenPos_, int AbovePercNoOrder_,
                     double &prezzoLivPrec,double &prezzoLivSucc, double &sogliaPrecedente, double &sogliaSuccessiva, 
                     bool &fasciaLevel, bool &fasciaThreshol, int &fasciaDiPrezz)
  {
   int a = 0;
   double prezzoValue      = 0.0;
   int level              = fasciaDiPrezzo(arrPrezzi,1);
   fasciaLevel        = false;
   fasciaThreshol     = false;

   //if(AbovePercNoOrder_ == 0)
    //  AbovePercNoOrder_ = 100;

   if(priceInput >= arrPrezzi[11])
     {
      prezzoValue = Ask(Symbol());
      fasciaDiPrezz = fasciaPrezzoInput(prezzoValue,arrPrezzi,1);
      sogliaPrecedente = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuccessiva = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      //Print("Buy sogliaPrecedente: ",sogliaPrecedente," sogliaSuccessiva: ",sogliaSuccessiva);
      prezzoLivPrec = PrezzoPrecedenteDiFascia(level, arrPrezzi);
      prezzoLivSucc = PrezzoSuccessivoDiFascia(level, arrPrezzi);//Print("Buy prezzoLivPrec: ",prezzoLivPrec," prezzoLivSucc: ",prezzoLivSucc);
      if(priceCompreso(prezzoValue,prezzoLivPrec,prezzoLivSucc))
        {a = 2; fasciaLevel = true;}      
      if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))
        {a = 1; fasciaThreshol = true;return a;}

     }
   if(priceInput <= arrPrezzi[12])
     {
      prezzoValue = Bid(Symbol());
      fasciaDiPrezz = fasciaPrezzoInput(prezzoValue,arrPrezzi,1);
      sogliaSuccessiva = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_);
      sogliaPrecedente = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_);
      //Print("Sell sogliaPrecedente: ",sogliaPrecedente," sogliaSuccessiva: ",sogliaSuccessiva);
      prezzoLivSucc = PrezzoSuccessivoDiFascia(level, arrPrezzi);
      prezzoLivPrec = PrezzoPrecedenteDiFascia(level, arrPrezzi);//Print("Sell prezzoLivPrec: ",prezzoLivPrec," prezzoLivSucc: ",prezzoLivSucc);
      if(priceCompreso(prezzoValue,prezzoLivPrec,prezzoLivSucc))
        {a = -2; fasciaLevel = true;}     
      if(priceCompreso(prezzoValue,sogliaSuccessiva,sogliaPrecedente))
        {a = -1; fasciaThreshol = true;return a;}

     }
   return a;
  }
/*
   BuyAbove_  = arrPric[11];
   SellBelow_ = arrPric[12];
//arrBoo[14]    = Usato per enablePrimoLiv;
//arrBoo[15]    = Usato per enableSecLiv;
//arrBoo[16]    = Usato per enableBuy;
//arrBoo[17]    = Vuoto disponibile
//arrBoo[18]    = Usato per enableSell;
*/   
//+------------------------------------------------------------------+
//|                         MeterPrezzoFascie()                      |Da provare
//+------------------------------------------------------------------+
// Elabora il prezzo del mercato Ask e Bid
// Restituisce "2"  se il prezzo è compreso tra le soglie Level consentite BUY.
// Restituisce "1"  se il prezzo è compreso tra le soglie AboveBelowPerc consentite BUY.
// Restituisce "0"  se il prezzo NON è compreso tra le soglie consentite.
// Restituisce "-1" se il prezzo è compreso tra le soglie AboveBelowPerc consentite SELL.
// Restituisce "-2" se il prezzo è compreso tra le soglie Level consentite SELL.
// Restituisce anche i valori double della "sogliaPrecedente" e della "sogliaSuccessiva"
// Restituisce anche i valori double del "PrezzoLivelloPrecedente" e del "PrezzoLivelloSuccessivo"
// Restituisce anche il valore bool della "fasciaLevel" e della "fasciaThreshol"
// Restituisce anche il valore int della "fasciaDiPrezzo" del priceInput
int MeterPrezzoFascie(double &arrPrezzi[], int PercLivPerOpenPos_, int AbovePercNoOrder_, double &sogliaPrec, double &sogliaSuccess, 
                      double &prezzoLivPrec,double &prezzoLivSucc,bool &fasciaLevel, bool &fasciaThreshol, int &fasciaDiPrez)
  {
   int a = 0;
   double prezzoValue      = 0.0;
   double sogliaPrecedente = 0.0;
   double sogliaSuccessiva = 0.0;
  
   int    level            = fasciaDiPrezzo(arrPrezzi,1);
   fasciaLevel             = false;
   fasciaThreshol          = false;

   if(AbovePercNoOrder_ == 0)
      AbovePercNoOrder_ = 100;

   if(Ask(Symbol()) >= arrPrezzi[11])
     {
      prezzoValue = Ask(Symbol());
      fasciaDiPrez = fasciaPrezzoInput(prezzoValue,arrPrezzi,1);
      sogliaPrecedente = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuccessiva = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))
        {a = 1; fasciaThreshol = true; return a;}
      prezzoLivPrec = PrezzoPrecedenteDiFascia(level, arrPrezzi);
      prezzoLivSucc = PrezzoSuccessivoDiFascia(level, arrPrezzi);
      if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))
        {a = 2; fasciaLevel = true; return a;}

     }
   if(Bid(Symbol()) <= arrPrezzi[12])
     {
      prezzoValue = Bid(Symbol());
      fasciaDiPrez = fasciaPrezzoInput(prezzoValue,arrPrezzi,1);
      sogliaSuccessiva = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_);
      sogliaPrecedente = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_);
      if(priceCompreso(prezzoValue,sogliaSuccessiva,sogliaPrecedente))
        {a = -1; fasciaThreshol = true; return a;}
      prezzoLivSucc = PrezzoSuccessivoDiFascia(level, arrPrezzi);
      prezzoLivPrec = PrezzoPrecedenteDiFascia(level, arrPrezzi);
      if(priceCompreso(prezzoValue,sogliaSuccessiva,sogliaPrecedente))
        {a = -2; fasciaLevel = true; return a;}
     }//Print("sogliaSuccessiva: ",sogliaSuccessiva," Soglia sogliaPrecedente: ",sogliaPrecedente);
   sogliaSuccess = sogliaSuccessiva;//Print("sogliaSuccessiva: ",sogliaSuccessiva);
   sogliaPrec    = sogliaPrecedente;//Print("sogliaPrecedente: ",sogliaPrecedente);
   return a;
  }
//+------------------------------------------------------------------+
//|                         doubleCompreso()                         |
//+------------------------------------------------------------------+
//Restituisce:
// "1" se priceVal è compreso tra i due valori,
// "0"  se priceVal non è compreso,
bool doubleCompreso(double priceVal, double value1, double value2)
  {
   bool a = false;
   if((priceVal <= value1 && priceVal>= value2)||(priceVal >= value1 && priceVal<= value2))
      a=true;
   return a;

  }
//+------------------------------------------------------------------+
//|                           intCompreso()                          |
//+------------------------------------------------------------------+
//Restituisce:
// "1" se priceVal è compreso tra i due valori,
// "0"  se priceVal non è compreso,
bool intCompreso(int Val, int value1, int value2)
  {
   bool a = false;
   if((Val >= value1 && Val<= value2)||(Val <= value1 && Val>= value2))
      a=true;
   return a;

  }
//+------------------------------------------------------------------+
//|                         priceCompreso()                          |
//+------------------------------------------------------------------+ 
bool priceCompreso(double priceVal, double value1, double value2)
{
return doubleCompreso(priceVal, value1, value2);
} 
//+------------------------------------------------------------------+
//|                         priceCompreso_()                         |
//+------------------------------------------------------------------+
//Restituisce:
// "1" se priceVal è compreso tra i due valori,
// "0"  se priceVal non è compreso,
// "-1" se piceVal è a zero oppure priceVal più uno dei due valori,
// "-2" se solo priceVal è superiore a zero,
// "-3" se tutti i tre valori sono a zero.
int priceCompreso_(double priceVal, double value1, double value2)
  {
   int a = 0;
   if(priceVal>0 && value1 && value2 && ((priceVal>=value2 && priceVal<=value1) || (priceVal<=value2 && priceVal>=value1)))
     {
      a=1;
      return a;
     }
   if((!priceVal && value1 && value2) || (!priceVal && !value1 && value2) || (!priceVal && value1 && !value2))
     {
      a=-1;
      return a;
     }
   if(priceVal && !value1 && !value2)
     {
      a=-2;
      return a;
     }
   if(!priceVal && !value1 && !value2)
      a=-3;
   return a;
  }
//+------------------------------------------------------------------+
//|             FiltroLivelliPresentiOra(PosizAperLiv)               |
//+------------------------------------------------------------------+
bool FiltroLivelliPresentiOra(bool PosizAperLiv_,const double&arrPre[],int magicNum)
  {
   bool a = true;
   if(!PosizAperLiv_)
     {
      a=true;
      return a;
     }
   if(PosizAperLiv_)
     {
      int fasciaNow=fasciaDiPrezzo(arrPre,1);
      int fasciaBuyNow=fasciaPrezzoInput(OpenPricePrimoOrdineBuy(magicNum),arrPre, 1);
      int fasciaSellNow=fasciaPrezzoInput(OpenPricePrimoOrdineSell(magicNum),arrPre, 1);
      if(fasciaNow == fasciaBuyNow || fasciaNow == fasciaSellNow)
         a=false;
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                           sup_liv_buy                            |
//+------------------------------------------------------------------+

int sup_liv_buy(double prezzoPivot_, double o1_, double c1_, double compraSopra_, double primoLevBuy_, double secondoLevBuy_, double terzoLevBuy_,
                double quartoLevBuy_,  double quintoLevBuy_, bool algebr, int PercLivPerOpenPos_)

  {
   if((c1_ < prezzoPivot_) || (c1_ < o1_))
      return 0;
   double a = (secondoLevBuy_ - primoLevBuy_) * 0.01 * PercLivPerOpenPos_;
//double b = (secondoLevBuy_ - primoLevBuy_) * 0.01 * PercLivNoOpenPos_;
   char superamento_Livello_Buy_  = 0 ;

   if(o1_<prezzoPivot_ && c1_>prezzoPivot_+a)
      superamento_Livello_Buy_            =1;
   if(o1_<compraSopra_ && c1_>compraSopra_+a)
      superamento_Livello_Buy_            =2;
   if(o1_<primoLevBuy_ && c1_>primoLevBuy_+a)
      superamento_Livello_Buy_            =3;
   if(o1_<secondoLevBuy_ && c1_>secondoLevBuy_+a)
      superamento_Livello_Buy_            =4;
   if(o1_<terzoLevBuy_ && c1_>terzoLevBuy_+a)
      superamento_Livello_Buy_            =5;
   if(o1_<quartoLevBuy_ && c1_>quartoLevBuy_+a)
      superamento_Livello_Buy_            =6;
   if(o1_<quintoLevBuy_ && c1_>quintoLevBuy_+a)
      superamento_Livello_Buy_            =7;
   return superamento_Livello_Buy_;
  };
//+------------------------------------------------------------------+
//|                           sup_liv_sell                           |
//+------------------------------------------------------------------+
int sup_liv_sell(double prezzoPivot_, double o1_, double c1_, double vendiSotto_, double primoLevSell_, double secondoLevSell_, double terzoLevSell_,
                 double quartoLevSell_,  double quintoLevSell_, bool algebr, int PercLivPerOpenPos_)

  {
   if((c1_ > prezzoPivot_) || (c1_ > o1_))
      return 0;
   double a = (primoLevSell_ - secondoLevSell_) * 0.01 * PercLivPerOpenPos_;
//double b = (primoLevSell_ - secondoLevSell_) * 0.01 * PercLivNoOpenPos_;
   char segno = 1;

   char superamento_Livello_Sell_  = 0 ;
   if(o1_>prezzoPivot_ && c1_<prezzoPivot_-a)
      superamento_Livello_Sell_              =1;
   if(o1_>vendiSotto_ && c1_<vendiSotto_-a)
      superamento_Livello_Sell_              =2;
   if(o1_>primoLevSell_ && c1_<primoLevSell_-a)
      superamento_Livello_Sell_              =3;
   if(o1_>secondoLevSell_ && c1_<secondoLevSell_-a)
      superamento_Livello_Sell_              =4;
   if(o1_>terzoLevSell_ && c1_<terzoLevSell_-a)
      superamento_Livello_Sell_              =5;
   if(o1_>quartoLevSell_ && c1_<quartoLevSell_-a)
      superamento_Livello_Sell_              =6;
   if(o1_>quintoLevSell_ && c1_<quintoLevSell_-a)
      superamento_Livello_Sell_              =7;
   if(algebr == false)
      segno = 1;
   if(algebr == true)
      segno = -1;
   return superamento_Livello_Sell_ * segno;
  }
//--------------- Valore Precedente o successivo in base alla fascia -------------------------

//+------------------------------------------------------------------+
//|                    DaFasciaLev_APrezzo                           |
//+------------------------------------------------------------------+
double DaFasciaLev_APrezzo(bool d, int e, char fascia, const string &sniperStrin[], const double &valoriAr[])   // E = scostamento fascia
  {
   if(d == false)
      return 0;
   char a = 0;
   int h = 0;

//if (e == 0) h = 1;          /////////////////////////******************************
   h = e;         //if (e > 0)  h = e;

   if(d == true)
      if(PositionIsBuy())
         a = -1;
   if(PositionIsSell())
      a = 1;

   int b = (fascia + (h * a));
   double c = 0;
   double g = (SniperDati(valoriAr,sniperStrin,"quintoLevBuy") - (SniperDati(valoriAr,sniperStrin,"quartoLevBuy")));// * 0.01 * (100 - TpPercAlLivello);

   if(PositionIsBuy())
     {
      switch(b)
        {
         case -3:c= SniperDati(valoriAr,sniperStrin,"quartoLevSell") ;break;
         case -2:c= SniperDati(valoriAr,sniperStrin,"terzoLevSell")  ;break;
         case -1:c= SniperDati(valoriAr,sniperStrin,"secondoLevSell");break;
         case  0:c= SniperDati(valoriAr,sniperStrin,"primoLevSell")  ;break;         ////case 0: secondoSell
         case  1:c= SniperDati(valoriAr,sniperStrin,"vendiSotto")    ;break;
         case  2:c= SniperDati(valoriAr,sniperStrin,"compraSopra")   ;break;
         case  3:c= SniperDati(valoriAr,sniperStrin,"primoLevBuy")   ;break;
         case  4:c= SniperDati(valoriAr,sniperStrin,"secondoLevBuy") ;break;
         case  5:c= SniperDati(valoriAr,sniperStrin,"terzoLevBuy")   ;break;
         case  6:c= SniperDati(valoriAr,sniperStrin,"quartoLevBuy")  ;break;
         case  7:c= SniperDati(valoriAr,sniperStrin,"quintoLevBuy")  ;break;
         case  8:c= SniperDati(valoriAr,sniperStrin,"quintoLevBuy")  + g;break;
         case  9:c= SniperDati(valoriAr,sniperStrin,"quintoLevBuy")  + g*2;break;
         case 10:c= SniperDati(valoriAr,sniperStrin,"quintoLevBuy")  + g*3;break;
        }
     }

   if(PositionIsSell())
     {

      switch(b)
        {
         case   3:c= SniperDati(valoriAr,sniperStrin,"quartoLevBuy")   ;break;
         case   2:c= SniperDati(valoriAr,sniperStrin,"terzoLevBuy")    ;break;
         case   1:c= SniperDati(valoriAr,sniperStrin,"secondoLevBuy")  ;break;
         case   0:c= SniperDati(valoriAr,sniperStrin,"primoLevBuy")    ;break;      ///// case 0 =
         case  -1:c= SniperDati(valoriAr,sniperStrin,"compraSopra")    ;break;
         case  -2:c= SniperDati(valoriAr,sniperStrin,"vendiSotto")     ;break;
         case  -3:c= SniperDati(valoriAr,sniperStrin,"primoLevSell")   ;break;
         case  -4:c= SniperDati(valoriAr,sniperStrin,"secondoLevSell") ;break;
         case  -5:c= SniperDati(valoriAr,sniperStrin,"terzoLevSell")   ;break;
         case  -6:c= SniperDati(valoriAr,sniperStrin,"quartoLevSell")  ;break;
         case  -7:c= SniperDati(valoriAr,sniperStrin,"quintoLevSell")  ;break;
         case  -8:c= SniperDati(valoriAr,sniperStrin,"quintoLevSell")+ g;break;
         case  -9:c= SniperDati(valoriAr,sniperStrin,"quintoLevSell")+ g*2;break;
         case -10:c= SniperDati(valoriAr,sniperStrin,"quintoLevSell") + g*3;break;
         default:
            Print("Calcolo Take Profit a Livello successivo Errato");
        }
     }
   return c;
  }
//+------------------------------------------------------------------+
//|                          fasciaDiPrezzoP                         |
//+------------------------------------------------------------------+
char fasciaDiPrezzoP(double c, bool algebrico, const string &sniperString_[], const double &valoriArr_[])
  {
   char l_by_l;
   char z = 1;
   if(algebrico == false)
      (z = 1);
   if(algebrico == true)
      (z = -1);

   if(c>=SniperDati(valoriArr_,sniperString_,"quintoLevBuy")){return l_by_l = 7;}
   if(c>=SniperDati(valoriArr_,sniperString_,"quartoLevBuy") && c< SniperDati(valoriArr_,sniperString_,"quintoLevBuy")){return l_by_l = 6;}
   if(c>=SniperDati(valoriArr_,sniperString_,"terzoLevBuy") && c< SniperDati(valoriArr_,sniperString_,"quartoLevBuy")){return l_by_l = 5;}
   if(c>=SniperDati(valoriArr_,sniperString_,"secondoLevBuy") && c< SniperDati(valoriArr_,sniperString_,"terzoLevBuy")){return l_by_l = 4;}
   if(c>=SniperDati(valoriArr_,sniperString_,"primoLevBuy") && c< SniperDati(valoriArr_,sniperString_,"secondoLevBuy")){return l_by_l = 3;}
   if(c>=SniperDati(valoriArr_,sniperString_,"compraSopra") && c< SniperDati(valoriArr_,sniperString_,"primoLevBuy")){return l_by_l = 2;}
   if(c>=SniperDati(valoriArr_,sniperString_,"prezzoPivot") && c< SniperDati(valoriArr_,sniperString_,"compraSopra")){return l_by_l = 1;}

   if(c<=SniperDati(valoriArr_,sniperString_,"quintoLevSell")){return l_by_l = 7 * z;}
   if(c<=SniperDati(valoriArr_,sniperString_,"quartoLevSell") && c> SniperDati(valoriArr_,sniperString_,"quintoLevSell")){return l_by_l = 6 * z;}
   if(c<=SniperDati(valoriArr_,sniperString_,"terzoLevSell") && c> SniperDati(valoriArr_,sniperString_,"quartoLevSell")){return l_by_l = 5 * z;}
   if(c<=SniperDati(valoriArr_,sniperString_,"secondoLevSell") && c> SniperDati(valoriArr_,sniperString_,"terzoLevSell")){return l_by_l = 4 * z;}
   if(c<=SniperDati(valoriArr_,sniperString_,"primoLevSell") && c> SniperDati(valoriArr_,sniperString_,"secondoLevSell")){return l_by_l = 3 * z;}
   if(c<=SniperDati(valoriArr_,sniperString_,"vendiSotto") && c> SniperDati(valoriArr_,sniperString_,"primoLevSell")){return l_by_l = 2 * z;}
   if(c<=SniperDati(valoriArr_,sniperString_,"prezzoPivot") && c> SniperDati(valoriArr_,sniperString_,"vendiSotto")){return l_by_l = 1 * z;}
   else{return l_by_l = 0;}
   return l_by_l;
  }/*
//+------------------------------------------------------------------+
//|                       valorePercLevByLev_                        |
//+------------------------------------------------------------------+
double valorePercLevByLev_(double valorePrezzo, bool buyOsell, const string &sniperStri[], const int &arrInput__[], const double &valoriArr_[])
  {
   char   a = fasciaDiPrezzoP(valorePrezzo, buyOsell, sniperStri, valoriArr_);
   double b = 0;
   double c = (valoriArr_ [4] - valoriArr_ [3]) * 0.01 * arrInput__[12];
   double d = 0;
   switch(a)
     {
      case   2:b= c + valoriArr_ [2];break;    //uguale distanza
      case   3:b= c + valoriArr_ [3];break;    //uguale distanza
      case   4:b= c + valoriArr_ [4];break;    //uguale distanza
      case   5:b= c + valoriArr_ [5];break;    //uguale distanza
      case   6:b= c + valoriArr_ [6];break;    //uguale distanza
      case   7:b= c + valoriArr_ [7];break;    //uguale distanza
      case  -2:b= valoriArr_ [8] - c;break;    //uguale distanza
      case  -3:b= valoriArr_ [9] - c;break;    //uguale distanza
      case  -4:b= valoriArr_ [10] - c;break;    //uguale distanza
      case  -5:b= valoriArr_ [11] - c;break;    //uguale distanza
      case  -6:b= valoriArr_ [12] - c ;break;    //uguale distanza
      case  -7:b= valoriArr_ [13] - c;break;    //uguale distanza
      default:
         d = -1;
     }
   return d;
  }*/
//+------------------------------------------------------------------+
//|                          fasciaPrezzoInput                       |
//+------------------------------------------------------------------+
int fasciaPrezzoInput(double Input, const double &arrPric_[], bool algebrico)
  {
   double c = Input;
   int l_by_l;
   int z = 1;
   if(algebrico == false)(z = 1);
   if(algebrico == true)(z = -1);

   double pri     =arrPric_[0];
   double R1Pri   =arrPric_[1];
   double R2Pri   =arrPric_[2];
   double R3Pri   =arrPric_[3];
   double R4Pri   =arrPric_[4];
   double R5Pri   =arrPric_[5];

   double S1Pri   =arrPric_[6];
   double S2Pri   =arrPric_[7];
   double S3Pri   =arrPric_[8];
   double S4Pri   =arrPric_[9];
   double S5Pri   =arrPric_[10];
   double BuyAbov  =arrPric_[11];
   double SellBelo =arrPric_[12];

   if(c>R5Pri){return l_by_l = 7;}
   if(c>R4Pri && c< R5Pri){return l_by_l = 6;}
   if(c>R3Pri && c< R4Pri){return l_by_l = 5;}
   if(c>R2Pri && c< R3Pri){return l_by_l = 4;}
   if(c>R1Pri && c< R2Pri){return l_by_l = 3;}
   if(c>=BuyAbov && c< R1Pri){return l_by_l = 2;}
   if(c>=pri && c< BuyAbov){return l_by_l = 1;}

   if(c<S5Pri){return l_by_l = 7 * z;}
   if(c<S4Pri && c> S5Pri){return l_by_l = 6 * z;}
   if(c<S3Pri && c> S4Pri){return l_by_l = 5 * z;}
   if(c<S2Pri && c> S3Pri){return l_by_l = 4 * z;}
   if(c<S1Pri && c> S2Pri){return l_by_l = 3 * z;}
   if(c<SellBelo && c> S1Pri){return l_by_l = 2 * z;}
   if(c<pri && c> SellBelo){return l_by_l = 1 * z;}
   else{return l_by_l = 0;}
   return l_by_l;
  }
//+------------------------------------------------------------------+
//|                          fasciaDiPrezzo                          |
//+------------------------------------------------------------------+
int fasciaDiPrezzo(const double &arrPric_[], bool algebrico)
  {
   double c       = Ask(Symbol());
   int l_by_l;
   int z = 1;
   if(algebrico == false)
      (z = 1);
   if(algebrico == true)
      (z = -1);

   double pri     =arrPric_[0];
   double R1Pri   =arrPric_[1];
   double R2Pri   =arrPric_[2];
   double R3Pri   =arrPric_[3];
   double R4Pri   =arrPric_[4];
   double R5Pri   =arrPric_[5];

   double S1Pri   =arrPric_[6];
   double S2Pri   =arrPric_[7];
   double S3Pri   =arrPric_[8];
   double S4Pri   =arrPric_[9];
   double S5Pri   =arrPric_[10];
   double BuyAbov  =arrPric_[11];
   double SellBelo =arrPric_[12];
   
   if(Ask(Symbol()) > pri)c = Ask(Symbol());
   if(Bid(Symbol()) < pri)c = Bid(Symbol());

   if(c>R5Pri){return l_by_l = 7;}
   if(c>R4Pri && c< R5Pri){return l_by_l = 6;}
   if(c>R3Pri && c< R4Pri){return l_by_l = 5;}
   if(c>R2Pri && c< R3Pri){return l_by_l = 4;}
   if(c>R1Pri && c< R2Pri){return l_by_l = 3;}
   if(c>=BuyAbov && c< R1Pri){return l_by_l = 2;}
   if(c>=pri && c< BuyAbov){return l_by_l = 1;}

   if(c<S5Pri){return l_by_l = 7 * z;}
   if(c<S4Pri && c> S5Pri){return l_by_l = 6 * z;}
   if(c<S3Pri && c> S4Pri){return l_by_l = 5 * z;}
   if(c<S2Pri && c> S3Pri){return l_by_l = 4 * z;}
   if(c<S1Pri && c> S2Pri){return l_by_l = 3 * z;}
   if(c<SellBelo && c> S1Pri){return l_by_l = 2 * z;}
   if(c<pri && c> SellBelo){return l_by_l = 1 * z;}
   else
     {return l_by_l = 0;}//Print(" LevelByLevel: ",l_by_l);
   return l_by_l;
  }

//+------------------------------------------------------------------+
//|                          LevelToString                           |
//+------------------------------------------------------------------+
string LevelToString(int level)
  {
   string nomeLivello;
   if(level == 1){nomeLivello="Pivot";return nomeLivello;}
   if(level == 2){nomeLivello="Buy/Sell";return nomeLivello;}
   if(level == 3){nomeLivello="R1/S1";return nomeLivello;}
   if(level == 4){nomeLivello="R2/S2";return nomeLivello;}
   if(level == 5){nomeLivello="R3/S3";return nomeLivello;}
   if(level == 6){nomeLivello="R4/S4";return nomeLivello;}
   if(level == 7){nomeLivello="R5/S5";return nomeLivello;}
   if(level < 1 || level > 7){nomeLivello="No Limit";return nomeLivello;
     }
   return nomeLivello;
  }
//+------------------------------------------------------------------+
//|                      PrezzoPrecedenteDiFascia                    |
//+------------------------------------------------------------------+
double PrezzoPrecedenteDiFascia(int level, const double &arrPrezzi[])
  {
   double LivelloPrecedente = 0.0;
   if(level == 1){LivelloPrecedente=arrPrezzi[12];}
   if(level == 2){LivelloPrecedente=arrPrezzi[11];}
   if(level == 3){LivelloPrecedente=arrPrezzi[1];}
   if(level == 4){LivelloPrecedente=arrPrezzi[2];}
   if(level == 5){LivelloPrecedente=arrPrezzi[3];}
   if(level == 6){LivelloPrecedente=arrPrezzi[4];}
   if(level == 7){LivelloPrecedente=arrPrezzi[5];}
   if(level  > 7){LivelloPrecedente=arrPrezzi[5];}

   if(level == -1){LivelloPrecedente=arrPrezzi[11];}
   if(level == -2){LivelloPrecedente=arrPrezzi[12];}
   if(level == -3){LivelloPrecedente=arrPrezzi[6];}
   if(level == -4){LivelloPrecedente=arrPrezzi[7];}
   if(level == -5){LivelloPrecedente=arrPrezzi[8];}
   if(level == -6){LivelloPrecedente=arrPrezzi[9];}
   if(level == -7){LivelloPrecedente=arrPrezzi[10];}
   if(level  < -7){LivelloPrecedente=arrPrezzi[10];}
   return LivelloPrecedente;
  }
/* price_     =arrPrezzi[0];
  R1Price_   =arrPrezzi[1];
  R2Price_   =arrPrezzi[2];
  R3Price_   =arrPrezzi[3];
  R4Price_   =arrPrezzi[4];
  R5Price_   =arrPrezzi[5];

  S1Price_   =arrPrezzi[6];
  S2Price_   =arrPrezzi[7];
  S3Price_   =arrPrezzi[8];
  S4Price_   =arrPrezzi[9];
  S5Price_   =arrPrezzi[10];
  BuyAbove_  =arrPrezzi[11];
  SellBelow_ =arrPrezzi[12];
  arrPric[13]=priceDay;
  arrPric[14]=priceWeek;*/
//+------------------------------------------------------------------+
//|                      PrezzoSuccessivoDiFascia                    |
//+------------------------------------------------------------------+
double PrezzoSuccessivoDiFascia(int level, const double &arrPrezzi[])
  {
   double LivelloSuccessivo = 0.0;
   if(level == 1){LivelloSuccessivo=arrPrezzi[11];}
   if(level == 2){LivelloSuccessivo=arrPrezzi[1];}
   if(level == 3){LivelloSuccessivo=arrPrezzi[2];}
   if(level == 4){LivelloSuccessivo=arrPrezzi[3];}
   if(level == 5){LivelloSuccessivo=arrPrezzi[4];}
   if(level == 6){LivelloSuccessivo=arrPrezzi[5];}
   if(level  > 6){LivelloSuccessivo=arrPrezzi[5];}

   if(level == -1){LivelloSuccessivo=arrPrezzi[12];}
   if(level == -2){LivelloSuccessivo=arrPrezzi[6];}
   if(level == -3){LivelloSuccessivo=arrPrezzi[7];}
   if(level == -4){LivelloSuccessivo=arrPrezzi[8];}
   if(level == -5){LivelloSuccessivo=arrPrezzi[9];}
   if(level == -6){LivelloSuccessivo=arrPrezzi[10];}
   if(level <  -6){LivelloSuccessivo=arrPrezzi[10];}
   return LivelloSuccessivo;
  }
//+------------------------------------------------------------------+
//|                FiltroFasciePrezzoConsentito                      |
//+------------------------------------------------------------------+
//Tiene conto di "Dal Livello", "Fino al Livello".
bool FiltroFasciePrezzoConsentito(const double &arrPrezzi[], int ApriOrdineDalLiv_, int ApreNuoviOrdiniFinoAlLivello_)
  {
   bool a = false;
   double pri = arrPrezzi[0];

   if(Ask(Symbol()) > pri)
     {if(fasciaDiPrezzo(arrPrezzi,1) >= ApriOrdineDalLiv_ &&  fasciaDiPrezzo(arrPrezzi,1) <= ApreNuoviOrdiniFinoAlLivello_)return a = true;}
   if(Bid(Symbol()) < pri)
     {if(fasciaDiPrezzo(arrPrezzi,0) >= ApriOrdineDalLiv_ &&  fasciaDiPrezzo(arrPrezzi,0) <= ApreNuoviOrdiniFinoAlLivello_)return a = true;}
   return a;
  }
//+------------------------------------------------------------------+
//|                     FiltroPrezzoOrdineAboveBelowPerc()           |
//+------------------------------------------------------------------+
// Restituisce "1" se il prezzo è compreso tra le soglie consentite.
// Restituisce anche i valori della "sogliaInferiore" e della "sogliaSuperiore"
bool FiltroPrezzoOrdineAboveBelowPerc(double &arrPrezzi[], int PercLivPerOpenPos_, int AbovePercNoOrder_, double &sogliaInfer, double &sogliaSuper)
  {
   bool a = false;
   double prezzoValue     = 0.0;
   double sogliaInferiore = 0.0;
   double sogliaSuperiore = 0.0;
   int  level             = fasciaDiPrezzo(arrPrezzi,1);

   if(AbovePercNoOrder_ == 0) AbovePercNoOrder_ = 100;

   if(Ask(Symbol()) >= arrPrezzi[11])
     {
      prezzoValue = Ask(Symbol());
      sogliaInferiore = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuperiore = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
   if(prezzoValue >= sogliaInferiore && prezzoValue <= sogliaSuperiore)a = true;
     }
   if(Bid(Symbol()) <= arrPrezzi[12])
     {
      prezzoValue = Bid(Symbol());
      sogliaSuperiore = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_);
      sogliaInferiore = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_);

   if(priceCompreso(prezzoValue,sogliaSuperiore,sogliaInferiore))a = true;
     }//Print("Soglia Sup: ",sogliaSuperiore," Soglia inferiore: ",sogliaInferiore);
   arrPrezzi[15] = sogliaSuper = sogliaSuperiore;//Print("sogliaSuper: ",sogliaSuper);
   arrPrezzi[16] = sogliaInfer = sogliaInferiore;//Print("sogliaInfer: ",sogliaInfer);
   return a;
  }
//+------------------------------------------------------------------+
/*   BuyAbove_  = arrPric[11];
   SellBelow_ = arrPric[12];

      arrPric[15]= ThresholdUp_;
   arrPric[16]= ThresholdDw_;*/
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                     MeterPrezzoOrdineAboveBelowPerc()            |
//+------------------------------------------------------------------+
// Restituisce "0" se il prezzo NON è compreso tra le soglie consentite.
// Restituisce "1" se il prezzo è compreso tra le soglie consentite BUY.
// Restituisce "2" se il prezzo è compreso tra le soglie consentite SELL.
// Restituisce anche i valori della "sogliaInferiore" e della "sogliaSuperiore"
int MeterPrezzoOrdineAboveBelowPerc(double &arrPrezzi[], int PercLivPerOpenPos_, int AbovePercNoOrder_, double &sogliaInfer, double &sogliaSuper)
  {
   int a = 0;
   double prezzoValue     = 0.0;
   double sogliaInferiore = 0.0;
   double sogliaSuperiore = 0.0;
   int  level             = fasciaDiPrezzo(arrPrezzi,1);

   if(AbovePercNoOrder_ == 0) AbovePercNoOrder_ = 100;

   if(Ask(Symbol()) >= arrPrezzi[11])
     {
      prezzoValue = Ask(Symbol());
      sogliaInferiore = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuperiore = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
   if(prezzoValue >= sogliaInferiore && prezzoValue <= sogliaSuperiore)
         a = 1;
     }
   if(Bid(Symbol()) <= arrPrezzi[12])
     {
      prezzoValue = Bid(Symbol());
      sogliaSuperiore = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_);
      sogliaInferiore = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_);

   if(priceCompreso(prezzoValue,sogliaSuperiore,sogliaInferiore))
         a = 2;
     }//Print("Soglia Sup: ",sogliaSuperiore," Soglia inferiore: ",sogliaInferiore);
   arrPrezzi[15] = sogliaSuper = sogliaSuperiore;//Print("sogliaSuper: ",sogliaSuper);
   arrPrezzi[16] = sogliaInfer = sogliaInferiore;//Print("sogliaInfer: ",sogliaInfer);
   return a;
  }
//+------------------------------------------------------------------+
//|                   FiltroPrezzoOrdineLevelToLevel()               |
//+------------------------------------------------------------------+
// Restituisce "1" se il prezzo è compreso tra le soglie consentite.
// Restituisce anche i valori della "sogliaInferiore" e della "sogliaSuperiore"
bool FiltroPrezzoOrdineLevelToLevel(double &arrPrezzi[], double &sogliaPrec, double &sogliaSucess)
  {
   bool a = false;
   double prezzoValue      = 0.0;
   double sogliaSuccessiva = 0.0;
   double sogliaPrecedente = 0.0;
   int  level              = fasciaDiPrezzo(arrPrezzi,1);

   if(Ask(Symbol()) >= arrPrezzi[11])      //BuyAbove_
     {
      prezzoValue = Ask(Symbol());
      sogliaSuccessiva = PrezzoSuccessivoDiFascia(level, arrPrezzi);
      sogliaPrecedente = PrezzoPrecedenteDiFascia(level, arrPrezzi);
   if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))a = true;
     }
   if(Bid(Symbol()) <= arrPrezzi[12])      //SellBelow_
     {
      prezzoValue = Bid(Symbol());
      sogliaPrecedente = PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuccessiva = PrezzoSuccessivoDiFascia(level, arrPrezzi);
      if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))a = true;
     }//Print("Soglia Sup: ",sogliaSuperiore," Soglia inferiore: ",sogliaInferiore);
   arrPrezzi[18] = sogliaPrecedente;//Print("sogliaSuper: ",sogliaSuper);
   arrPrezzi[19] = sogliaSuccessiva;//Print("sogliaInfer: ",sogliaInfer);
   return a;
  }
//+------------------------------------------------------------------+
//|                   MeterPrezzoOrdineLevelToLevel()                |
//+------------------------------------------------------------------+
// Restituisce "0" se il prezzo NON è compreso tra le soglie consentite.
// Restituisce "1" se il prezzo è compreso tra le soglie consentite BUY.
// Restituisce "2" se il prezzo è compreso tra le soglie consentite SELL.
// Restituisce anche i valori della "sogliaInferiore" e della "sogliaSuperiore"
int MeterPrezzoOrdineLevelToLevel(double &arrPrezzi[], double &sogliaPrec, double &sogliaSucess)
  {
   int a = false;
   double prezzoValue      = 0.0;
   double sogliaSuccessiva = 0.0;
   double sogliaPrecedente = 0.0;
   int    level            = fasciaDiPrezzo(arrPrezzi,1);

   if(Ask(Symbol()) >= arrPrezzi[11])      //BuyAbove_
     {
      prezzoValue = Ask(Symbol());
      sogliaSuccessiva = PrezzoSuccessivoDiFascia(level, arrPrezzi);
      sogliaPrecedente = PrezzoPrecedenteDiFascia(level, arrPrezzi);
      if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))a = 1;
     }
   if(Bid(Symbol()) <= arrPrezzi[12])      //SellBelow_
     {
      prezzoValue = Bid(Symbol());
      sogliaPrecedente = PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuccessiva = PrezzoSuccessivoDiFascia(level, arrPrezzi);
   if(priceCompreso(prezzoValue,sogliaPrecedente,sogliaSuccessiva))a = 2;
     }//Print("Soglia Sup: ",sogliaSuperiore," Soglia inferiore: ",sogliaInferiore);
   arrPrezzi[18] = sogliaPrecedente;//Print("sogliaSuper: ",sogliaSuper);
   arrPrezzi[19] = sogliaSuccessiva;//Print("sogliaInfer: ",sogliaInfer);
   return a;
  }
//+------------------------------------------------------------------+
//|                    ValoreMedioMultiOrdini                        |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                            GestioneOrdini                        |
//+------------------------------------------------------------------+
void GestioneOrdini(const bool &arrBool[],const int &arrInt_[], double &arrPrez[], int PercLivOpenOrd,
                    int AbovePercNoOrd, int numCandele, int candeleSucc)
  {

   double      sogliaPrecedente;
   double      sogliaSucessiva;
   bool        FasciaLevel;
   bool        FasciaThreshol;
   int         fasciaDiPrezzo;
   double      prezzoLivPrec;
   double      prezzoLivSucc;
   static bool preOrdineBuy     =false;
   static bool preOrdineSell    =false;
   static int  BarrePreOrdBuy;
   static int  BarrePreOrdSell;
   static int  levelPreOrdBuy   = 0;
   static int  levelPreOrdSell  = 0;
   double      c1Buy            = 0;
   double      o1Buy            = 0;
   double      c1Sell           = 0;
   double      o1Sell           = 0;
   double      c1Generico       = iClose(Symbol(),PERIOD_CURRENT,1);
   
   if(intCompreso(fasciaPrezzoInput(c1Generico,arrPrez,1),1,-1))/////Ultima modifica
     {
      preOrdineBuy=preOrdineSell=false;
      levelPreOrdBuy=BarrePreOrdBuy=levelPreOrdSell=BarrePreOrdSell=0;
      return;
     }
//if(!newCandle())return;

   if(!arrBool[14] || !arrBool[15])                            // enable 1° e 2° livello
      return;                          

   int valoreMeter = MeterPrezzoFascie(arrPrez, PercLivOpenOrd, AbovePercNoOrd, prezzoLivPrec, prezzoLivSucc,
                                       sogliaPrecedente, sogliaSucessiva, FasciaLevel, FasciaThreshol, fasciaDiPrezzo);

   if(valoreMeter>0 && arrBool[16])                            // prezzo nella fascia Livelli Buy && enableBuy
     {
      c1Buy = iClose(Symbol(),PERIOD_CURRENT,1);               // C1Buy
      o1Buy = iOpen(Symbol(),PERIOD_CURRENT,1);                // O1Buy

      if(!(c1Buy>=prezzoLivPrec && o1Buy<=prezzoLivPrec)&& !preOrdineBuy)   //C1Buy e O1Buy NON sono a cavallo: azzera variabili
        {
         preOrdineBuy=false;
         levelPreOrdBuy=BarrePreOrdBuy=0;
        }

      if(c1Buy>=prezzoLivPrec && o1Buy<=prezzoLivPrec && !preOrdineBuy)    // c1 a cavallo della soglia precedente e preordine non attivo
        {
         preOrdineBuy   = true;                                 // preordine: true
         BarrePreOrdBuy = iBars(Symbol(),PERIOD_CURRENT);       // numero barre c1Buy.
         levelPreOrdBuy = fasciaPrezzoInput(c1Buy,arrPrez,1);   // Fascia c1Buy.
        }
      if(preOrdineBuy)
         numCandeleConsecutive(arrInt_,preOrdineBuy,BarrePreOrdBuy,levelPreOrdBuy,numCandele,candeleSucc,arrPrez,FasciaThreshol,FasciaLevel,c1Buy);
     }   //   Fine Buy control

   valoreMeter = MeterPrezzoFascie(arrPrez, PercLivOpenOrd, AbovePercNoOrd, prezzoLivPrec, prezzoLivSucc,
                                   sogliaPrecedente, sogliaSucessiva, FasciaLevel, FasciaThreshol, fasciaDiPrezzo);

   if(valoreMeter<0 && arrBool[18])                             //prezzo nella fascia Livelli Sell && enableSell
     {
      c1Sell = iClose(Symbol(),PERIOD_CURRENT,1);               // c1Sell
      o1Sell = iOpen(Symbol(),PERIOD_CURRENT,1);                // o1Sell
     
      if(!(c1Sell<=prezzoLivPrec && o1Sell>=prezzoLivPrec) && !preOrdineSell)//C1Sell e O1Sell NON sono a cavallo: azzera variabili
        {
         preOrdineSell=false;
         levelPreOrdSell=BarrePreOrdSell=0;
        }
      if(c1Sell<=prezzoLivPrec && o1Sell>=prezzoLivPrec && !preOrdineSell)    // c1 a cavallo della soglia precedente e preordine non attivo
        {
         preOrdineSell   = true;
         BarrePreOrdSell = iBars(Symbol(),PERIOD_CURRENT);       // numero barre e fascia: c1Sell.
         levelPreOrdSell = fasciaPrezzoInput(c1Sell,arrPrez,1);
        }

      if(preOrdineSell)numCandeleConsecutive(arrInt_,preOrdineSell,BarrePreOrdSell,levelPreOrdSell,numCandele,candeleSucc,arrPrez,FasciaThreshol,FasciaLevel,c1Sell);
     }   //   Fine Sell control
  }
//+------------------------------------------------------------------+
//|                      numCandeleConsecutive                       | Da finire con Lots, TP e stop loss
//+------------------------------------------------------------------+
bool numCandeleConsecutive(const int &arrInt[],bool &preOrdine,int &BarrePreOrd,int &levelPreOrd,
                           int numCandele,int candeleSucc,double &arrPrez[],bool fasciaThresh,bool FasciaLevel,double c1_)
  {
    //Print(" preOrdine: ",preOrdine);
    bool a = false;
     {
   if(!FasciaLevel || !preOrdine)
        {preOrdine=false; BarrePreOrd=0; levelPreOrd=0; return a;}           // prezzo fuori fascia utile, tra comprasopra e vendi sotto (non compresi)
      
   if(levelPreOrd>1)                                    // inizio Buy control
        {
   if(levelPreOrd!=fasciaPrezzoInput(Ask(Symbol()),arrPrez,1)){preOrdine=false; BarrePreOrd=0; levelPreOrd=0;}    // controllo stessa fascia livello

      int Barre    = iBars(Symbol(),PERIOD_CURRENT);
      int NumBarre = Barre - BarrePreOrd;
      int FasciaC1 = fasciaPrezzoInput(c1_,arrPrez,1);
         
      if((doubleCompreso(NumBarre,0,numCandele-1+candeleSucc)&&!FasciaLevel)){preOrdine=false;BarrePreOrd=levelPreOrd=0;}

      if(doubleCompreso(NumBarre,numCandele-1,numCandele-1+candeleSucc)&&fasciaThresh&&preOrdine)
           {
            SendPosition(Symbol(),ORDER_TYPE_BUY,0.01,Ask(Symbol()),3,Ask(Symbol())-1000,Ask(Symbol())+1000,"",arrInt[14]);{preOrdine=false; BarrePreOrd=levelPreOrd=0;}
           }
        }                                                   // fine Buy Control

      if(levelPreOrd<1)                                     // inizio Sell control
        {
         if(levelPreOrd!=fasciaPrezzoInput(Bid(Symbol()),arrPrez,1))
           {preOrdine=false; BarrePreOrd=0; levelPreOrd=0;}     // controllo stessa fascia livello

         int Barre    = iBars(Symbol(),PERIOD_CURRENT);
         int NumBarre = Barre - BarrePreOrd;

         if((doubleCompreso(NumBarre,0,numCandele-1+candeleSucc)&&!FasciaLevel))
            {preOrdine=false; BarrePreOrd=levelPreOrd=0;}

         if(doubleCompreso(NumBarre,numCandele-1,numCandele-1+candeleSucc) && fasciaThresh && preOrdine)
           {
           SendPosition(Symbol(),ORDER_TYPE_SELL,0.01,Bid(Symbol()),3,Bid(Symbol())+1000,Bid(Symbol())-1000,"",arrInt[14]);
              {preOrdine=BarrePreOrd=levelPreOrd=0;}
           }
        }                                                   // fine Sell Control
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                           numCandeleConsec                       | 
//+------------------------------------------------------------------+
bool numCandeleConsec(bool &semaBuy,bool &semaSell,int &BarreBuy,int &BarreSell,int numCandele, double C1,double &sogliaBuy,double &sogliaSell,bool &signBuy, bool &signSell)
  {
    bool a = false;
     {
   //if(!semaBuy && !semaSell)return a;            
    //Print("semaBuy: ",semaBuy," BarreBuy: ",BarreBuy," numCandele: ",numCandele," sogliaBuy: ",sogliaBuy," signBuy: ",signBuy," C1: ",C1);  
   if(semaBuy)                                         // inizio Buy control
        {
      int Barre    = iBars(Symbol(),PERIOD_CURRENT);
      int DiffBarre = Barre - BarreBuy;
      
      if(doubleCompreso(DiffBarre,0,numCandele-1)&&C1<sogliaBuy){semaBuy=false;BarreBuy=0;
      //sogliaBuy=0;
      }
      if(doubleCompreso(DiffBarre,numCandele-1,numCandele-1) && C1>=sogliaBuy && semaBuy) {signBuy=true;
      semaBuy=false; BarreBuy=0;
      //sogliaBuy=0;
      }
        }                                              // fine Buy Control

      if(semaSell)                                     // inizio Sell control
        {
         int Barre    = iBars(Symbol(),PERIOD_CURRENT);
         int DiffBarre = Barre - BarreSell;

         if(doubleCompreso(DiffBarre,0,numCandele-1)&&C1>sogliaSell){semaSell=false; BarreSell=0;
         //sogliaSell=0;
         }
         if(doubleCompreso(DiffBarre,numCandele-1,numCandele-1) && C1<=sogliaSell && semaSell) {signSell=true;
         semaSell=false;BarreSell=0;
         //sogliaSell=0;
         }
        }                                                   // fine Sell Control
     }
   return a;
  }  
//+------------------------------------------------------------------+
//|                   valoreSuperioreUguale()                        |
//+------------------------------------------------------------------+  
double valoreSuperioreUguale (double a, double b)
{
double c=0;
if (a>=b){c = a;}
if (b>=a){c = b;}
return c;
}  
//+------------------------------------------------------------------+
//|                valoreInferioreUguale()                           |
//+------------------------------------------------------------------+  
double valoreInferioreUguale (double a, double b)
{
double c=0;
if (a<=b){c = a;}
if (b<=a){c = b;}
return c;
}  
//+------------------------------------------------------------------+
//|                         valoreSuperiore()                        |
//+------------------------------------------------------------------+  
double valoreSuperiore (double a, double b)
{
double c=a;
if (a>b){c = a;}
if (b>a){c = b;}
return c;
}
//+------------------------------------------------------------------+
//|                  valoreSuperioreQuattro()                        |
//+------------------------------------------------------------------+  
double valoreSuperioreQuattro (double a, double b, double c=0, double d=0)
{
double z=a;

if(b>z) z=b;
if(c>z && c!=0) z=c;
if(d>z && d!=0) z=d;
return z;
}  
//+------------------------------------------------------------------+
//|                  valoreInferioreQuattro()                        |
//+------------------------------------------------------------------+  
double valoreInferioreQuattro (double a, double b, double c=0, double d=0)
{
double z=a;

if(b<z) z=b;
if(c<z && c!=0) z=c;
if(d<z && d!=0) z=d;
return z;
}  
//+------------------------------------------------------------------+
//|                      valoreInferiore()                           |
//+------------------------------------------------------------------+  
double valoreInferiore (double a, double b)
{
double c=a;
if (a<b){c = a;}
if (b<a){c = b;}
return c;
}  
//+------------------------------------------------------------------+
//|                      ValoreInferiore()                           |
//+------------------------------------------------------------------+  
double ValoreInferiore (double a, double b, double c=0, double d=0)
{
double z=a;
if (a<b){z = a;}
if (b<a){z = b;}
if (c!=0&&c<z){z = c;}
if (d!=0&&d<z){z = d;}
return z;
}  
//+------------------------------------------------------------------+
//|                         ValoreSuperiore()                        |
//+------------------------------------------------------------------+  
double ValoreSuperiore (double a, double b, double c=0, double d=0)
{
double z=a;
if (a>b){z = a;}
if (b>a){z = b;}
if (c!=0&&c>z){z = c;}
if (d!=0&&d>z){z = d;}
return z;
} 
//+------------------------------------------------------------------+
//|                           BreakOut()                             |
//+------------------------------------------------------------------+ 
bool BreakOut(bool BreakOutEnable_,int candPrecedenti,ENUM_TIMEFRAMES periodCan,int deltaPlus,bool &Buy,bool &Sell,int &numCandBreakBuy,int &numCandBreakSell)//int numCandOver =candele consecutive oltre la soglia
{
bool a = false;
Buy    = false;
Sell   = false;
if(!BreakOutEnable_)return a;
static bool semBuy  = false;
static bool semSell = false;
static int candle;
bool impulse=false;
int Bar = iBars(Symbol(),PERIOD_CURRENT);
if(Bar!=candle){impulse = true; candle=Bar;}

if(candPrecedenti<1){Print("Impostazione \"Candele Precedenti\" del \"BreakOut minimo 1");Alert("Impostazione \"Candele Precedenti\" del \"BreakOut minimo 1");return a;}
if(!impulse)return a;

if(iClose(Symbol(),periodCan,1) > iHigh(Symbol(),periodCan, iHighest(Symbol(),periodCan,MODE_HIGH,candPrecedenti,2))+deltaPlus*Point())//semBuy&& dopo if(
   {numCandBreakBuy=iHighest(Symbol(),periodCan,MODE_HIGH,candPrecedenti,2);semBuy=true;a=true;Buy=true;return a;}//semBuy=true;
/*
if(semBuy){
for(int i=0;i<numCandOver;i++)
{
if(iClose(Symbol(),PERIOD_CURRENT,1)>(iHigh(Symbol(),PERIOD_CURRENT,i+2+numCandBreakBuy)+deltaPlus*Point())&&i+1==numCandOver)
}}{semBuy=false;numCandBreakBuy=iHighest(Symbol(),periodCan,MODE_HIGH,candPrecedenti,2);a=true;Buy=true;return a;}
*/
if(iClose(Symbol(),periodCan,1) < iLow(Symbol(),periodCan, iLowest(Symbol(),periodCan,MODE_LOW,candPrecedenti,2))-deltaPlus*Point())
   {numCandBreakSell=iLowest(Symbol(),periodCan,MODE_LOW,candPrecedenti,2);semSell=true;a=true;Sell=true;return a;}//semSell=true;
/*
if(semSell){
for(int i=0;i<numCandOver;i++)
{
if(iClose(Symbol(),PERIOD_CURRENT,1)<(iLow(Symbol(),PERIOD_CURRENT,i+2+numCandBreakSell)-deltaPlus*Point())&&i+1==numCandOver)
}}{semSell=false;numCandBreakSell=iLowest(Symbol(),periodCan,MODE_LOW,candPrecedenti,2);a=true;Sell=true;return a;}
*/
return a;
}
//+------------------------------------------------------------------+Restituisce BuyEnable e SellEnable al breakout della candela chiusa,  
//|                    BreakOutFilterSignal                          |            anche BuySignal e SellSignal alla candela N° successiva al breakout
//+------------------------------------------------------------------+
bool BreakOutFilterSignal(bool BreakOutEnable_,int candPrecedenti,ENUM_TIMEFRAMES periodCan,int numCandConsec, int deltaPlus,bool &BuyEnable,bool &SellEnable,bool &BuySignal,bool &SellSignal,int mode=2)
{
bool    a    = false;
if(!BreakOutEnable_){BuyEnable=true;SellEnable=true;return a;}

BuySignal    = false;
SellSignal   = false;
BuyEnable    = false;
SellEnable   = false;
static bool semBuy  = false;
static bool semSell = false;
static int numCandBreakBuy;
static int numCandBreakSell;
static double sogliaBuy;
static double sogliaSell;
bool impulse=false;
int Bar = iBars(Symbol(),PERIOD_CURRENT);
static int candle;

if(Bar!=candle){impulse = true; candle=Bar;}

if(candPrecedenti<1){Print("Impostazione \"Candele Precedenti\" del \"BreakOut errata");Alert("Impostazione \"Candele Precedenti\" del \"BreakOut errata");return a;}
if(!impulse)return a;

double CloseCanUno = iClose(Symbol(),periodCan,1);
double Delta = deltaPlus*Point();
double HighMax = iHigh(Symbol(),periodCan, iHighest(Symbol(),periodCan,MODE_HIGH,candPrecedenti,2))+Delta;
double LowMin  = iLow(Symbol(),periodCan, iLowest(Symbol(),periodCan,MODE_LOW,candPrecedenti,2))-Delta;
//
if(CloseCanUno > HighMax)
   {a=true;BuyEnable=true; 
   if(!semBuy){semBuy=true;numCandBreakBuy=Bar;sogliaBuy=HighMax;}
   }
if(semBuy)numCandeleConsec(semBuy,semSell,numCandBreakBuy,numCandBreakSell,numCandConsec,CloseCanUno,sogliaBuy,sogliaSell,BuySignal,SellSignal);
if(CloseCanUno>=sogliaBuy&&sogliaBuy)BuyEnable=true;
if(mode==1 && CloseCanUno<sogliaBuy&&sogliaBuy)BuyEnable=false;// "Mode 1" aggiorna le soglie con ritardo
if(mode==2 && CloseCanUno<sogliaBuy&&sogliaBuy)BuyEnable=false;sogliaBuy=HighMax;//Mode "2" aggiorna le soglie quando la candela chiude sotto la soglia
//
if(CloseCanUno < LowMin)
   {a=true;SellEnable=true;  
   if(!semSell){semSell=true;numCandBreakSell=Bar;sogliaSell=LowMin;}
   }
if(semSell)numCandeleConsec(semBuy,semSell,numCandBreakBuy,numCandBreakSell,numCandConsec,CloseCanUno,sogliaBuy,sogliaSell,BuySignal,SellSignal);
if(CloseCanUno<=sogliaSell&&sogliaSell)SellEnable=true;
if(mode==1 && CloseCanUno>sogliaSell&&sogliaSell)SellEnable=false;// "Mode 1"
if(mode==2 && CloseCanUno>sogliaSell&&sogliaSell)SellEnable=false;sogliaSell=LowMin;// Mode "2"
//
//Print(" sogliaBuy: ",sogliaBuy," sogliaSell: ",sogliaSell);
return a;
}
//+------------------------------------------------------------------+
//|                         TrialLicence()                           |
//+------------------------------------------------------------------+
bool TrialLicence(datetime TimeLicen)
  {
   bool a=true;
   if(TimeLicen < TimeCurrent())
     {
      Alert("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Print("EA Libra: Trial period expired! Removed EA Libra from this account!");
      Comment("EA Libra: Trial period expired! Removed EA Libra from this account!");
      a=false;
      ExpertRemove();
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                         controlAccounts()                        |
//+------------------------------------------------------------------+
bool controlAccounts(const long &NumeroAccount[], const datetime &TimeLicen)
  {
   if(!IsConnected())
     {
      Print("No connection");
      return true;
     }
   bool a = false;
   long Account = AccountNumber();

   for(int i=0; i<ArraySize(NumeroAccount); i++)
     {
      if(NumeroAccount[i] == Account && TimeLicen > TimeCurrent())
        {a = true; return a;}
     }
   if(a == true)Print("EA Libra: Account Ok!");
   else
     {
      Print("EA Libra: trial license expired or Account without permission");
      Alert("EA Libra: trial license expired or Account without permission!");
      ExpertRemove();
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                         MarketIsOpen()                           |
//+------------------------------------------------------------------+
bool MarketIsOpen()
  {
   bool a=true;
   if(IsMarketTradeOpen()&&TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))a=true;
   if(!IsMarketTradeOpen()||!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))a=false;
   return a;
  }
//+--------------------------ContaOrdersDay----------------------------+
int ContaPrimiOrdersDay(int magicNum)
  {
   static int a=0;
   static ulong TicketOldBuy=0;
   ulong TickBuy=TicketPrimoOrdineBuy(magicNum);
   if(TickBuy!=TicketOldBuy&&TickBuy!=0){a++; TicketOldBuy=TickBuy;}
   static ulong TicketOldSell=0;
   ulong TickSell=TicketPrimoOrdineSell(magicNum);
   if(TickSell!=TicketOldSell&&TickSell!=0){a++; TicketOldSell=TickSell;}
   if(impulsoNuovoGiorno()) {a=0;TicketOldBuy=TicketOldSell=TickBuy=TickSell=0;}
   return a;
  }
//+------------------------------------------------------------------+
//|          bool       FasciaPrezzoOrdineAboveBelowPerc()           |
//+------------------------------------------------------------------+
// Restituisce "true" se il prezzo è compreso tra le soglie consentite.
// Restituisce anche i valori della "sogliaInferiore" e della "sogliaSuperiore"
bool FasciaPrezzoOrdineAboveBelowPerc(double &arrPrezzi[], int PercLivPerOpenPos_, int AbovePercNoOrder_, double &sogliaInfer, double &sogliaSuper)
  {
   bool a = false;
   double prezzoValue     = 0.0;
   double sogliaInferiore = 0.0;
   double sogliaSuperiore = 0.0;
   int level             = fasciaDiPrezzo(arrPrezzi,1);
   double ASK_ = Ask(Symbol());
   double BID_ = Bid(Symbol());

   if(AbovePercNoOrder_ == 0) AbovePercNoOrder_ = 100;

   if(ASK_ >= arrPrezzi[11])
     {
      prezzoValue = ASK_;
      sogliaInferiore = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      sogliaSuperiore = ((PrezzoSuccessivoDiFascia(level, arrPrezzi) - PrezzoPrecedenteDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_) + PrezzoPrecedenteDiFascia(level, arrPrezzi);
      if(prezzoValue >= sogliaInferiore && prezzoValue <= sogliaSuperiore) a = true;
     }
   if(BID_ <= arrPrezzi[12])
     {
      prezzoValue = BID_;
      sogliaSuperiore = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*AbovePercNoOrder_);
      sogliaInferiore = PrezzoPrecedenteDiFascia(level, arrPrezzi) - ((PrezzoPrecedenteDiFascia(level, arrPrezzi) - PrezzoSuccessivoDiFascia(level, arrPrezzi))/100*PercLivPerOpenPos_);

      if(doubleCompreso(prezzoValue,sogliaSuperiore,sogliaInferiore)) a = true;
     }//Print("Soglia Sup: ",sogliaSuperiore," Soglia inferiore: ",sogliaInferiore);
   arrPrezzi[15] = sogliaSuper = sogliaSuperiore;//Print("sogliaSuper: ",sogliaSuper);
   arrPrezzi[16] = sogliaInfer = sogliaInferiore;//Print("sogliaInfer: ",sogliaInfer);
   return a;
  }
//+------------------------------------------------------------------+
//|                           FiltroPivotD()                         |
//+------------------------------------------------------------------+
bool FiltroPivotD(bool Filtro_Pivot_Daily_,string BuySell_, const double PivotD_)
  {
   bool a = true;
   if(!Filtro_Pivot_Daily_)
     {
      a = true;
      return a;
     }
   if(Filtro_Pivot_Daily_ && BuySell_ == "Buy" && Ask(Symbol()) < PivotD_)a = false;
   if(Filtro_Pivot_Daily_ && BuySell_ == "Sell" && Bid(Symbol()) > PivotD_)a = false;
   return a;
  }  
//+------------------------------------------------------------------+
//|                      enablePivotDaily_Buy()                      |
//+------------------------------------------------------------------+
bool enablePivotDaily_Buy(bool Filtro_Pivot_Daily_, const double PivotD_)
  {
   return FiltroPivotD(Filtro_Pivot_Daily_, "Buy", PivotD_);
  }
//+------------------------------------------------------------------+
//|                      enablePivotDaily_Sell()                     |
//+------------------------------------------------------------------+
bool enablePivotDaily_Sell(bool Filtro_Pivot_Daily_, const double PivotD_)
  {
   return FiltroPivotD(Filtro_Pivot_Daily_, "Sell", PivotD_);
  }
//+------------------------------------------------------------------+
//|                      FiltroNumOrdiniAperti()                     |
//+------------------------------------------------------------------+//Numero Max Orders Open Together (Max 2)
bool FiltroNumOrdiniAperti(int nMaxOrd, int MagicNum)
  {
   bool a = true;
   if(!nMaxOrd)a = false;
   if(NumPrimiOrdini(MagicNum) >= nMaxOrd)a = false;
   return a;
  }
//+------------------------------------------------------------------+
//|                    FiltroNumOrdiniGiornata()                     |
//+------------------------------------------------------------------+FiltroNumOrdiniGiornata(N_max_orders, ContaOrdersDay);//Number Max Orders on same Day
bool FiltroNumOrdiniGiornata(int N_max_ord, int magicNum) //Filtro numero massimo di ordini al giorno
  {
   bool a = true;
   if(ContaPrimiOrdersDay(magicNum) >= N_max_ord)a = false;
   return a;
  }
//+------------------------------------------------------------------+
//|                  FiltroOrdiniSuStessaCandela()                   |
//+------------------------------------------------------------------+
bool FiltroOrdiniSuStessaCandela(bool OrdiniSuStessaCandela_, int MagicNumberrr)  //Filtro per consentire nuovi ordini sulla stessa candela
  {
   bool a = true;
   if(OrdiniSuStessaCandela_){a = true; return true;}
   int magicNum = MagicNumberrr;
   int BarrePrimoOrdBuy = iBarShift(Symbol(),PERIOD_CURRENT,PositionOpenTime(TicketPrimoOrdineBuy(magicNum)));
   int BarrePrimoOrdineSell = iBarShift(Symbol(),PERIOD_CURRENT,PositionOpenTime(TicketPrimoOrdineSell(magicNum)));
   if(!BarrePrimoOrdBuy || !BarrePrimoOrdineSell)a = false;
   return a;
  }
//+------------------------------------------------------------------+
//|                         FiltroTimeSet()                          |
//+------------------------------------------------------------------+
bool FiltroTimeSet(int InpStartHour_,int InpStartMinute_,int InpEndHour_,int InpEndMinute_,char fuso_,bool FusoEnable_,
                   int InpStartHour1_,int InpStartMinute1_,int InpEndHour1_,int InpEndMinute1_)
  {
   return FiltroTimeSetPartial(InpStartHour_,InpStartMinute_,InpEndHour_,InpEndMinute_,fuso_,FusoEnable_) ||
          FiltroTimeSetPartial(InpStartHour1_,InpStartMinute1_,InpEndHour1_,InpEndMinute1_,fuso_,FusoEnable_);
  }
//+------------------------------------------------------------------+
//|                         FiltroTimeSetPartial()                   |
//+------------------------------------------------------------------+
bool FiltroTimeSetPartial(int InpStartHour_,int InpStartMinute_,int InpEndHour_,int InpEndMinute_,char fuso_,bool FusoEnable_)
  {
   if(FusoEnable_)
     {
      datetime Now = 0;
      if(fuso_==0)Now=TimeGMT();
      if(fuso_==1)Now=TimeLocal();
      if(fuso_==2)Now=TimeCurrent();
      MqlDateTime NowStruct;
      TimeToStruct(Now,NowStruct);
      int StartTradingSeconds = (InpStartHour_*3600) + (InpStartMinute_*60);
      int EndTradingSeconds = (InpEndHour_*3600) + (InpEndMinute_*60);
      int runningseconds = (NowStruct.hour*3600) + (NowStruct.min*60);
      ZeroMemory(NowStruct);

      if((runningseconds>StartTradingSeconds)&&(runningseconds<EndTradingSeconds))
        {
         //Comment("\nwithin trading time");
         return(true);
        }
      //if ((runningseconds<StartTradingSeconds)&&(runningseconds>EndTradingSeconds))
        {
         //Comment("\noutside of trading time");
         return(false);
        }
     }
   return(true);
  }
//+---------------------FiltroLivelliOrdiniDelGiorno-------------------+
bool FiltroLivelliOrdiniDelGiorno(bool RipetiLivelliDelGiorno_, const double &arrPri[],int &arrLev[],int magicNum)
  {
   bool a = true;
   int Level=0;
   if(RipetiLivelliDelGiorno_) {a = true;return a;}
   scrivoLivelliPrimiOrdiniDay( magicNum, arrPri, arrLev);  
   if(Ask(Symbol())>=arrPri[11]) {Level=fasciaPrezzoInput(OpenPricePrimoOrdineBuy(magicNum),arrPri,1);}
   if(Bid(Symbol())<=arrPri[12]) {Level=fasciaPrezzoInput(OpenPricePrimoOrdineSell(magicNum),arrPri,1);}
   for(int i=0; i<ArraySize(arrLev); i++) {if(Level==arrLev[i]) {a=false;return a;}}
   return a;
  }
//+--------------------scrivoLivelliPrimiOrdiniDay---------------------+
void scrivoLivelliPrimiOrdiniDay(int magicNum,const double &arrPrezzi[], int &arrLev[])
  {
   double prezzoNow=0;
   static int contaOrdOld=0;
   int ContaOrd=ContaPrimiOrdersDay(magicNum);
   static int LevelOldBuy=0;

   if(ContaOrd!=0 && ContaOrd != contaOrdOld)
     {
      contaOrdOld=ContaOrd;
      if(Ask(Symbol())>=arrPrezzi[11])
        {
         int Level=fasciaPrezzoInput(OpenPricePrimoOrdineBuy(magicNum),arrPrezzi,1);
         arrLev[contaOrdOld-1]=Level;
        }
      if(Bid(Symbol())<=arrPrezzi[12])
        {
         int Level=fasciaPrezzoInput(OpenPricePrimoOrdineSell(magicNum),arrPrezzi,1);
         arrLev[contaOrdOld-1]=Level;
        }
     }
   if(impulsoNuovoGiorno())
     {
      contaOrdOld=ContaOrd=LevelOldBuy=0;
      for(int i=0; i<ArraySize(arrLev); i++) {arrLev[i]=0;}
     }
  } 
//+------------------------------------------------------------------+
//|                         FitroPivotW()                            |
//+------------------------------------------------------------------+
bool FitroPivotW(bool Filtro_Pivot_Weekly_,string BuySell_, const double PivotW_)
  {
   bool a = true;
   if(!Filtro_Pivot_Weekly_) {a = true;return a;}
   if(Filtro_Pivot_Weekly_ && BuySell_ == "Buy" && Ask(Symbol()) < PivotW_) a = false;
   if(Filtro_Pivot_Weekly_ && BuySell_ == "Sell" && Bid(Symbol()) > PivotW_) a = false;
   return a;
  }   
//+------------------------------------------------------------------+
//|                 enablePivotWeekly_Buy()                          |
//+------------------------------------------------------------------+
bool enablePivotWeekly_Buy(bool Filtro_Pivot_Weekly_, const double PivotW_)
{return FitroPivotW(Filtro_Pivot_Weekly_, "Buy", PivotW_);}
//+------------------------------------------------------------------+
//|                 enablePivotWeekly_Sell()                         |
//+------------------------------------------------------------------+
bool enablePivotWeekly_Sell(bool Filtro_Pivot_Weekly_, const double PivotW_)
  {return FitroPivotW(Filtro_Pivot_Weekly_, "Sell", PivotW_);}
//+------------------------------------------------------------------+
//|                      FiltroOnlyBuyOnlySell()                     |
//+------------------------------------------------------------------+
bool FiltroOnlyBuyOnlySell(int Type_Ord,string TypeOrders)
  {
   bool a = true;
   int filtroTypeOrders = Type_Ord;
   if(filtroTypeOrders == 3)a = false;
   if(TypeOrders == "Buy"  && filtroTypeOrders == 2)a = false;
   if(TypeOrders == "Sell" && filtroTypeOrders == 1)a = false;
   return a;
  }
/*
   Buy_Sell    = 0,                       //Orders Buy e Sell
   Buy         = 1,                       //Only Buy Orders
   Sell        = 2,                       //Only Sell Orders
   NoBuyNoSell = 3,                       //No Buy No Sell: Stop News Orders
*/
//+------------------------------------------------------------------+
//|                    enableOnlyBuyOnlySell_Buy()                   |
//+------------------------------------------------------------------+
bool enableOnlyBuyOnlySell_Buy(int Type_Ord)
  {return FiltroOnlyBuyOnlySell(Type_Ord,"Buy");}
//+------------------------------------------------------------------+
//|                    enableOnlyBuyOnlySell_Sell()                  |
//+------------------------------------------------------------------+
bool enableOnlyBuyOnlySell_Sell(int Type_Ord)
  {return FiltroOnlyBuyOnlySell(Type_Ord,"Sell");}
//+------------------------------------------------------------------+
//|             FiltroDirezioneCandela(bool a,string BuySell)        |
//+------------------------------------------------------------------+
//Restituisce "false" quando "a" abilita il filtro e
// la direzione della candela è Verde prima dell'Ordine Buy o
// Rossa prima dell'ordine Sell.
bool FiltroDirezioneCandela(bool a,string BuySell)
  {
   if(!a)return true;
   bool verso=false;
   if(BuySell=="Buy"){if(iOpen(Symbol(),PERIOD_CURRENT,1)<iClose(Symbol(),PERIOD_CURRENT,1))verso=true;}
   if(BuySell=="Sell"){if(iOpen(Symbol(),PERIOD_CURRENT,1)>iClose(Symbol(),PERIOD_CURRENT,1))verso=true;}
   return verso;
  }  
//+------------------------------------------------------------------+
//|             enableDirezioneCandela_Buy(bool a)                   |
//+------------------------------------------------------------------+
bool enableDirezioneCandela_Buy(bool a)
  {return FiltroDirezioneCandela(a,"Buy");}
//+------------------------------------------------------------------+
//|            enableDirezioneCandela_Sell(bool a)                   |
//+------------------------------------------------------------------+
bool enableDirezioneCandela_Sell(bool a)
  {return FiltroDirezioneCandela(a,"Sell");}
//+------------------------------------------------------------------+
//|                        gestioneDDmax                             |
//+------------------------------------------------------------------+
void gestioneDDmax(int maxDDPerc_,int MagicNumber_)
  {if(FiltroDDmax(maxDDPerc_, MagicNumber_))NumOrdini(MagicNumber_);}
//+------------------------------------------------------------------+
//|                        FiltroDDmax                               |
//+------------------------------------------------------------------+
bool FiltroDDmax(int maxDDPerc_,int MagicNumber_)
  {
   if(NumOrdini(MagicNumber_)==0){return false;}
   string SymbolChart=Symbol();
   bool a=false;
   if(maxDDPerc_<0.0 || maxDDPerc_ > 100.0)
     {
      Print("Incorrect Max DD value");
      return a;
     }
   if(maxDDPerc_==0.0) {return a=false;}
//Print("ACCOUNT_EQUITY: ",(double)AccountInfoDouble(ACCOUNT_EQUITY)," ACCOUNT_BALANCE: ",(double)AccountInfoDouble(ACCOUNT_BALANCE));
   long bb = 0;
   int x = NumOrdini(MagicNumber_);
   string arr [100];
   ulong  arrMagic [100];
   int  arrTicket [100];
   double arrProfit [100];
   arrMagic[0] = 0;
   arrProfit[0] = 0;
//--------------------azzera array arr -------------------
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic -------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}

//------------------azzera array Profit ------------------
   for(int aa=0; aa<ArraySize(arrProfit); aa++){arrProfit[aa] = 0;}

//------------------azzera array Ticket ------------------
   for(int aa=0; aa<ArraySize(arrTicket); aa++){arrTicket[aa] = 0;}
//--------------------- controllo posizioni --------------
   for(int i=NumOrdini(MagicNumber_)-1; i>=0; i--)
     {
      PositionSelectByPos(i);

      arr [i] = PositionSymbol();
      arrMagic[i] = PositionMagicNumber();
      arrTicket[i] = NumOrdini(MagicNumber_);;
      arrProfit[i] = PositionProfitFull(arrTicket[i]);
     }
   double Profit = 0;

   for(int i=NumOrdini(MagicNumber_)-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_))
        {
         Profit = Profit+arrProfit[i];
         bb = NumOrdini(MagicNumber_);;
        }
     }
   if((double)AccountInfoDouble(ACCOUNT_BALANCE)+Profit<=(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-maxDDPerc_))
     {a=true;}
//Print(" Balance: ",(double)AccountInfoDouble(ACCOUNT_BALANCE)," Profit: ",Profit," Equity: ",(double)AccountInfoDouble(ACCOUNT_BALANCE)+Profit,
//" Soglia DD: ",(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-maxDDPerc_)," Return: ",a);
   return a;
  } 
//+------------------------------------------------------------------+
//|                        FiltroDDmax_                              |
//+------------------------------------------------------------------+  
bool FiltroDDmax_(int maxDDPerc_,ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal()){return false;}
   if(maxDDPerc_==0.0) {return false;}  
      bool a=false;
      double Profit = 0;   
   if(maxDDPerc_<0.0 || maxDDPerc_ > 100.0){Print("Incorrect Max DD value");return a;}
 
      string SymbolChart=Symbol();
      ulong Ticket=0;
      string segno="";  
      char aa=0;    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
   if(PositionSymbol(Ticket) == SymbolChart && PositionMagicNumber(Ticket) == MagicNumber_ && PositionComment(Ticket) == comm)
      Profit = Profit+PositionProfitFull(Ticket);  
     }
   if((double)AccountInfoDouble(ACCOUNT_BALANCE)+Profit<=(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-maxDDPerc_))a=true;
      return a;  
  }    
//+------------------------------------------------------------------+
//|                         newFascia()                              |
//+------------------------------------------------------------------+  
bool newFascia(const double &arrPri[])
  {
   static int fascia=0;
   bool impulse=false;
   if(fasciaDiPrezzo(arrPri,1)!=fascia)
     {impulse = true; fascia=fasciaDiPrezzo(arrPri,1); //Print("newFascia: ",fasciaDiPrezzo(arrPri,1));
     }
   return impulse;
  }    
                 
//+------------------------------------------------------------------+
//|                          lastPikYesterday()                      |Restituisce l'ultimo picco High o Low di IERI
//+------------------------------------------------------------------+  
double lastPikYesterday()
   {
   double lastPik=0;
   string  DateTScans=(string)iTime(Symbol(),PERIOD_CURRENT,1);
   string  DayShift=StringSubstr((string)TimeDay(1,Symbol()),0,10);
   int BarMax=0;
   int BarMin=2000;
   for(int i=0;i<=1200;i++)
   {
   DateTScans= StringSubstr((string)iTime(Symbol(),PERIOD_CURRENT,i),0,10); 
   if(StringCompare(DateTScans,DayShift)==0)
   {
   if(i>BarMax&&i!=0){BarMax=i;}    
   if(i<BarMin&&i!=0){BarMin=i;}    
   }}   //Print(" BarMax: ",BarMax," BarMin: ",BarMin);
   BarMax=BarMax-BarMin;
   int high_=iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,BarMax,BarMin);//Print(" high: ",high);
   int low_ =iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,BarMax,BarMin);//Print(" low: ",low);
   if(high_<low_)lastPik=iHigh(Symbol(),PERIOD_CURRENT,high_); //Print(" high: ",iHigh(Symbol(),PERIOD_CURRENT,high));Print(" low: ",iLow(Symbol(),PERIOD_CURRENT,low));
   if(low_<high_)lastPik=iLow(Symbol(),PERIOD_CURRENT,low_);//Print(" lastPik: ",lastPik);
   return lastPik;
   }
//+------------------------------------------------------------------+
//|                      PendenzaCandele()                           |
//+------------------------------------------------------------------+
double PendenzaCandele(int dephCand,bool &Ribassista,bool &Rialzista)
{
//Ribassista=false;
//Rialzista=false;
double pendenza=0;
double pendenzaRibassista=0;
double pendenzaRialzista=0;
int candHigh=iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,dephCand,1);
int candLow=iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,dephCand,1);
if(candHigh<candLow){Rialzista=true;Ribassista=false;pendenzaRibassista=(iHigh(Symbol(),PERIOD_CURRENT,candHigh)-iLow(Symbol(),PERIOD_CURRENT,candLow))/(candLow-candHigh);}
if(candHigh>candLow){Ribassista=true;Rialzista=false;pendenzaRialzista=(iHigh(Symbol(),PERIOD_CURRENT,candHigh)-iLow(Symbol(),PERIOD_CURRENT,candLow))/(candHigh-candLow);}
pendenza=valoreSuperiore(pendenzaRibassista,pendenzaRialzista);
//if(Ribassista)Print("RIBASSISTA");if(Rialzista)Print("RIALZISTA");Print(" dephCandele: ",dephCand," pendenza: ",pendenza);   
return pendenza;
} 