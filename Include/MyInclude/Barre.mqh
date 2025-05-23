#include <MyLibrary\MyLibrary.mqh>


enum periodoRicercaNumCand
  {
   giorno                = 0,
   Week                  = 1,
   Mese                  = 2,
   SeiMesi               = 3,
   Anno                  = 4,
  };

//input periodoRicercaCand   periodoRicNumCandele = 0;            //Picchi zigzag nel periodo prima di 1 giorno/1 settimana/1 mese/6 mesi/1 anno
periodoRicercaNumCand   periodoRicNumCandele = 0;            //Picchi zigzag nel periodo prima di 1 giorno/1 settimana/1 mese/6 mesi/1 anno
//input ENUM_TIMEFRAMES      TfPeridoRicCandele   ;
ENUM_TIMEFRAMES      TfPeridoRicCandele   ;


int NumCandelePerPeriodo()
  {
   int numCandele=0;
   if(periodoRicNumCandele==0)numCandele=iBarShift(Symbol(),TfPeridoRicCandele,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCandele,D'19.01.2023');
   if(periodoRicNumCandele==1)numCandele=iBarShift(Symbol(),TfPeridoRicCandele,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCandele,D'24.01.2023');
   if(periodoRicNumCandele==2)numCandele=iBarShift(Symbol(),TfPeridoRicCandele,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCandele,D'17.02.2023');
   if(periodoRicNumCandele==3)numCandele=iBarShift(Symbol(),TfPeridoRicCandele,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCandele,D'17.07.2023');
   if(periodoRicNumCandele==4)numCandele=iBarShift(Symbol(),TfPeridoRicCandele,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCandele,D'17.01.2024');
   return numCandele;
  }
//+------------------------------------------------------------------+
//|             direzioneCanndUno(bool a,string BuySell)             |controllo sulla candela 1
//+------------------------------------------------------------------+
bool direzioneCandUno(bool a,string BuySell) 
{
return versoCandelaPro(a,BuySell);
}
//+------------------------------------------------------------------+
//|             versoCandelaPro(bool a,string BuySell)               |Restituisce true quando la candela 1 è rialzista e BuySell è "Buy",
//+------------------------------------------------------------------+                                       ribassista e BuySell è "Sell"
bool versoCandelaPro(bool a,string BuySell) 
{
if(!a)return true;
bool verso=false;
if(BuySell=="Buy")
{
if(iOpen(Symbol(),PERIOD_CURRENT,1)<iClose(Symbol(),PERIOD_CURRENT,1))
verso=true;
}
if(BuySell=="Sell")
{
if(iOpen(Symbol(),PERIOD_CURRENT,1)>iClose(Symbol(),PERIOD_CURRENT,1))
verso=true;
}
return verso;
}  
/*
enum direzCand
  {
   No                        = 0,  //Flat
   cand1                     = 1,  //Candela 1 congrua con Ordine
   cand1e2                   = 2,  //Candele 1 e 2 congrue con Ordine
   cand1e2conOltrepasso      = 3,  //Candele 1 e 2 congrue e chiusura cand 2 Oltre Apertura cand 3
   cand1e2conOltrepassoShad  = 4,  //Candele 1 e 2 congrue e chiusura cand 2 Oltre Shadow cand 3
  }; */
//+------------------------------------------------------------------+Restituisce true quando TipodirezCand= 1 e BuySell è "Buy" e n° candele sono tutte rialziste 
//|                       candeleAfavore()                           |                                  "Sell" e n° candele sono tutte ribassiste
//+------------------------------------------------------------------+Restituisce true quando TipodirezCand= 2/3 e BuySell è "Buy" e n° candele sono tutte rialziste,chiusura oltre body/shadow 
bool candeleAfavore(int TipodirezCand,string BuySell,int numCand)
{
bool a = false;
if(!TipodirezCand){a=true;return a;}
if(TipodirezCand==1){a=direzioneCandele(true,BuySell,numCand);return a;}
if(TipodirezCand==2)
{
if(BuySell=="Buy" && direzioneCandele(true,BuySell,numCand) && candelaNumIsBuyOSell(numCand+1,"Sell") && iClose(Symbol(),PERIOD_CURRENT,1) > iOpen(Symbol(),PERIOD_CURRENT,numCand+1)){a=true;return a;}
if(BuySell=="Sell" && direzioneCandele(true,BuySell,numCand) && candelaNumIsBuyOSell(numCand+1,"Buy") && iClose(Symbol(),PERIOD_CURRENT,1) < iOpen(Symbol(),PERIOD_CURRENT,numCand+1)){a=true;return a;}
}
if(TipodirezCand==3)
{
if(BuySell=="Buy" && direzioneCandele(true,BuySell,numCand) && candelaNumIsBuyOSell(numCand+1,"Sell") && iClose(Symbol(),PERIOD_CURRENT,1) > iHigh(Symbol(),PERIOD_CURRENT,numCand+1)){a=true;return a;}
if(BuySell=="Sell" && direzioneCandele(true,BuySell,numCand) && candelaNumIsBuyOSell(numCand+1,"Buy") && iClose(Symbol(),PERIOD_CURRENT,1) < iLow(Symbol(),PERIOD_CURRENT,numCand+1)){a=true;return a;}
}
return a;
}
  
//+------------------------------------------------------------------+Restituisce true quando BuySell è "Buy" e n° candele sono tutte rialziste 
//|             direzioneCandele(bool a,string BuySell)              |                                  "Sell" e n° candele sono tutte ribassiste
//+------------------------------------------------------------------+
bool direzioneCandele(bool enable,string BuySell,int numCandele) 
{
if(!enable)return true;
bool a=false;
for(int i=1;i<=numCandele;i++)
{
if(BuySell=="Buy")
{
if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i) && i>=numCandele) {a=true;return a;}
if(iOpen(Symbol(),PERIOD_CURRENT,i)>iClose(Symbol(),PERIOD_CURRENT,i)) {a=false;return a;}
}
if(BuySell=="Sell")
{
if(iOpen(Symbol(),PERIOD_CURRENT,i)>iClose(Symbol(),PERIOD_CURRENT,i) && i>=numCandele) {a=true;return a;}
if(iOpen(Symbol(),PERIOD_CURRENT,i)<iClose(Symbol(),PERIOD_CURRENT,i)) {a=false;return a;}
}}
return a;
}
//---------------------------------- candelaNBuyOsell()----------------------------------------
bool candelaNumIsBuyOSell(int nCandela, string BuySell)
{
bool a = false;

if(BuySell=="Buy" && iOpen(Symbol(),PERIOD_CURRENT,nCandela)<iClose(Symbol(),PERIOD_CURRENT,nCandela)){a=true;return a;}
if(BuySell=="Sell" && iOpen(Symbol(),PERIOD_CURRENT,nCandela)>iClose(Symbol(),PERIOD_CURRENT,nCandela))a=true;
return a;
} 
//---------------------------------- candelaNBuyOsellTF()----------------------------------------
bool candelaNumIsBuyOSellTF(int nCandela, string BuySell,ENUM_TIMEFRAMES timeFrame)
{
bool a = false;

if(BuySell=="Buy" && iOpen(Symbol(),timeFrame,nCandela)<iClose(Symbol(),timeFrame,nCandela)){a=true;return a;}
if(BuySell=="Sell" && iOpen(Symbol(),timeFrame,nCandela)>iClose(Symbol(),timeFrame,nCandela))a=true;
return a;
}   
//+------------------------------------------------------------------+Restituisce true quando TipodirezCand= 1 e BuySell è "Buy" e n° candele sono tutte rialziste 
//|                    numCandeleCongrue()                           |                                  "Sell" e n° candele sono tutte ribassiste
//+------------------------------------------------------------------+Restituisce true quando TipodirezCand= 2/3 e BuySell è "Buy" e n° candele sono tutte rialziste,chiusura oltre body/shadow 
/*
enum direzCand
  {
   No                        = 0,  //Flat
   candN                     = 1,  //N° Candele congrue con l'Ordine
   candNeSuperamBody         = 2,  //N° Candele congrue e superam body cand preced                                // Incollare negli enum
   candNeSuperamShadow       = 3,  //N° Candele congrue e superam shadow cand preced
  }; 

input direzCand  direzCand_    =     1;  //Permette Ordine Cand a favore: No/N°Cand/N°Cand+Body/N°Cand+Shadow     // Incollare negl'input
input int      numCandDirez    =     1;  //Numero Candele a favore. Minimo 1.
input ENUM_TIMEFRAMES timeFrCand =   PERIOD_CURRENT; //Time Frame Candele

numCandeleCongrue(direzCand_,"Buy",numCandDirez,timeFrCand);

*/

bool numCandeleCongrue(int TipodirezCand,string BuySell,int numCand,ENUM_TIMEFRAMES timeframe)
{
bool a = false;
if(!TipodirezCand){a=true;return a;}
if(TipodirezCand==1){a=direzioneNumeroCandele(true,BuySell,numCand,timeframe);return a;}
if(TipodirezCand==2)
{
if(BuySell=="Buy" && direzioneNumeroCandele(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Sell") && iClose(Symbol(),timeframe,1) > iOpen(Symbol(),timeframe,numCand+1)){a=true;return a;}
if(BuySell=="Sell" && direzioneNumeroCandele(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Buy") && iClose(Symbol(),timeframe,1) < iOpen(Symbol(),timeframe,numCand+1)){a=true;return a;}
}
if(TipodirezCand==3)
{
if(BuySell=="Buy" && direzioneNumeroCandele(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Sell") && iClose(Symbol(),timeframe,1) > iHigh(Symbol(),timeframe,numCand+1)){a=true;return a;}
if(BuySell=="Sell" && direzioneNumeroCandele(true,BuySell,numCand,timeframe) && candelaNumIsBuyOSell(numCand+1,"Buy") && iClose(Symbol(),timeframe,1) < iLow(Symbol(),timeframe,numCand+1)){a=true;return a;}
}
return a;
}
//+------------------------------------------------------------------+Restituisce true quando BuySell è "Buy" e n° candele sono tutte rialziste 
//|       direzioneNumeroCandele(bool a,string BuySell)              |                                  "Sell" e n° candele sono tutte ribassiste
//+------------------------------------------------------------------+
bool direzioneNumeroCandele(bool enable,string BuySell,int numCandele,ENUM_TIMEFRAMES timeframe) 
{
if(!enable)return true;
bool a=false;
for(int i=1;i<=numCandele;i++)
{
if(BuySell=="Buy")
{
if(iOpen(Symbol(),timeframe,i)<iClose(Symbol(),timeframe,i) && i>=numCandele) {a=true;return a;}
if(iOpen(Symbol(),timeframe,i)>iClose(Symbol(),timeframe,i)) {a=false;return a;}
}
if(BuySell=="Sell")
{
if(iOpen(Symbol(),timeframe,i)>iClose(Symbol(),timeframe,i) && i>=numCandele) {a=true;return a;}
if(iOpen(Symbol(),timeframe,i)<iClose(Symbol(),timeframe,i)) {a=false;return a;}
}}
return a;
}  

//+---------------------------------------------------------------------------------+
//|  direzioneCandeleConOltrepasso(bool a,string BuySell,int oltrepasso)            |controllo su n° candele e oltrepasso body o shadow (oltrepasso: 0=no,1=body,2=shadow)
//+---------------------------------------------------------------------------------+/////////////////// Controllare direzione candele 
bool direzioneCandeleConOltrepasso(bool enable,string BuySell,int numCandele,int oltrepasso) 
{
if(!enable)return true;
bool a=false;
for(int i=1;i<=numCandele;i++)
{
if(BuySell=="Buy")
{
if(candelaNumIsBuyOSell(i,"Buy") && i>=numCandele && 
  (!oltrepasso 
  || (oltrepasso==1 && iClose(Symbol(),PERIOD_CURRENT,numCandele)>iOpen(Symbol(),PERIOD_CURRENT,numCandele+1)) 
  || (oltrepasso==2 && iClose(Symbol(),PERIOD_CURRENT,numCandele)>iHigh(Symbol(),PERIOD_CURRENT,numCandele+1) && candelaNumIsBuyOSell(numCandele+1,"Sell")))) // && tipoDiCandelaN("Sell")
      {a=true;return a;}
                                                                                                  
if(candelaNumIsBuyOSell(i,"Sell")) {a=false;return a;}
}
if(BuySell=="Sell")
{
if(iOpen(Symbol(),PERIOD_CURRENT,i)>iClose(Symbol(),PERIOD_CURRENT,i) && i>=numCandele && 
   (!oltrepasso
   || (oltrepasso==1 && iClose(Symbol(),PERIOD_CURRENT,numCandele)<iOpen(Symbol(),PERIOD_CURRENT,numCandele+1)) 
   || (oltrepasso==2 && iClose(Symbol(),PERIOD_CURRENT,numCandele)<iLow(Symbol(),PERIOD_CURRENT,numCandele+1) && candelaNumIsBuyOSell(numCandele+1,"Buy")))) 
      {a=true;return a;}
      
if(candelaNumIsBuyOSell(i,"Buy")) {a=false;return a;}
}}
return a;
}  
//---------------------------------- tipoDiCandelaN()----------------------------------------
string tipoDiCandelaN(int candelaNum)
{
string a="";
if(iOpen(Symbol(),PERIOD_CURRENT,candelaNum)<iClose(Symbol(),PERIOD_CURRENT,candelaNum)){a="Buy";return a;}
if(iOpen(Symbol(),PERIOD_CURRENT,candelaNum)>iClose(Symbol(),PERIOD_CURRENT,candelaNum)){a="Sell";return a;}
return a;
}


//+------------------------------------------------------------------+
//|             direzioneCandZero(bool a,string BuySell)             |controllo sulla candela 0
//+------------------------------------------------------------------+
bool direzioneCandZero(bool a,string BuySell) 
{
if(!a)return true;
bool verso=false;
if(BuySell=="Buy")
{
//if(iOpen(Symbol(),PERIOD_CURRENT,0)<iClose(Symbol(),PERIOD_CURRENT,0))
if(Ask(NULL) > iOpen(Symbol(),PERIOD_CURRENT,0))
verso=true;
}
if(BuySell=="Sell")
{
//if(iOpen(Symbol(),PERIOD_CURRENT,0)>iClose(Symbol(),PERIOD_CURRENT,0))
if(Bid(NULL) < iOpen(Symbol(),PERIOD_CURRENT,0))
verso=true;
}
return verso;
}   
//+------------------------------------------------------------------+
//|             direzioneCandZeroeUno(bool a,string BuySell)         |controllo sulla candela 0 e 1
//+------------------------------------------------------------------+
bool direzioneCandZeroeUno(bool a,string BuySell) 
{
if(!a)return true;
bool verso=false;
if(BuySell=="Buy")
{
if(iOpen(Symbol(),PERIOD_CURRENT,0)<iClose(Symbol(),PERIOD_CURRENT,0)&&iOpen(Symbol(),PERIOD_CURRENT,1)<iClose(Symbol(),PERIOD_CURRENT,1))
verso=true;
}
if(BuySell=="Sell")
{
if(iOpen(Symbol(),PERIOD_CURRENT,0)>iClose(Symbol(),PERIOD_CURRENT,0)&&iOpen(Symbol(),PERIOD_CURRENT,1)>iClose(Symbol(),PERIOD_CURRENT,1))
verso=true;
}
return verso;
}    
//+------------------------------------------------------------------+Restituisce 1 e Buy=true, se la candela 1 chiude sopra al top della cand 2, 
//|                candelaOverTopBottCandPrec()                      |           -1 e Sell=true, se la cand 1 chiude sotto al bottom della cand 2
//+------------------------------------------------------------------+            
int candelaOverTopBottCandPrec(bool &Buy,bool &Sell)
{
int a = 0;
Buy = false;
Sell = false;
if(iClose(Symbol(),PERIOD_CURRENT,1)>iHigh(Symbol(),PERIOD_CURRENT,2)){a=1;Buy=true;}
if(iClose(Symbol(),PERIOD_CURRENT,1)<iLow(Symbol(),PERIOD_CURRENT,2)){a=-1;Sell=true;}
return a;
}   
//+------------------------------------------------------------------+Restituisce 1 e Buy=true, se la candela 1 chiude sopra al top delle candele "numCand_ precedenti alla cand 1,
//|             candelaOverTopBottCandelePrec()                      |           -1 e Sell=true, se la cand 1 chiude sotto al bottom delle candele "numCand_ precedenti alla cand 1
//+------------------------------------------------------------------+  
int candelaOverTopBottCandelePrec(bool &Buy,bool &Sell,int numCand_)
{
if(numCand_<=0){Alert("Valore Numero Candele precedenti Top/Bottom deve essere superiore a 0");return 0;}
int a = 0;
Buy = false;
Sell = false;
int Highh = iHighest(Symbol(),PERIOD_CURRENT,MODE_LOW,numCand_,2);
int Loww = iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,numCand_,2);
if(iClose(Symbol(),PERIOD_CURRENT,1)>iHigh(Symbol(),PERIOD_CURRENT,Highh)){a=1;Buy=true;}
if(iClose(Symbol(),PERIOD_CURRENT,1)<iLow(Symbol(),PERIOD_CURRENT,Loww)){a=-1;Sell=true;}
return a;
} 
//+------------------------------------------------------------------+Restituisce 1 e Buy=true, se la candela 1 chiude oltre al body esterno delle candele "numCand_ precedenti alla cand 1,
//|             candelaOverBodyCandelePreced()                       |           -1 e Sell=true, se la cand 1 chiude sotto al body esterno  delle candele "numCand_ precedenti alla cand 1
//+------------------------------------------------------------------+ Testare 
int candelaOverBodyCandelePrec(bool &Buy,bool &Sell,int numCand_)
{
if(numCand_<=0){Alert("Valore Numero Candele precedenti Top/Bottom deve essere superiore a 0");return 0;}
int a = 0;
Buy = false;
Sell = false;
string symbol__=Symbol();
int Highh = iHighest(symbol__,PERIOD_CURRENT,MODE_LOW,numCand_,2);
int Loww = iLowest(symbol__,PERIOD_CURRENT,MODE_LOW,numCand_,2);
double maxCand, minCand;
double openCandH=iOpen(symbol__,PERIOD_CURRENT,Highh);
double closeCandH=iClose(symbol__,PERIOD_CURRENT,Highh);
double openCandL=iOpen(symbol__,PERIOD_CURRENT,Loww);
double closeCandL=iClose(symbol__,PERIOD_CURRENT,Loww);

if(closeCandH>=openCandH)maxCand=closeCandH;
if(closeCandH<=openCandH)maxCand=openCandH;

if(closeCandL>=openCandL)minCand=openCandL;
if(closeCandL<=openCandL)minCand=closeCandL;

if(iClose(symbol__,PERIOD_CURRENT,Loww)>=iOpen(symbol__,PERIOD_CURRENT,Loww))minCand=iOpen(symbol__,PERIOD_CURRENT,Loww);
if(iClose(symbol__,PERIOD_CURRENT,Loww)<=iOpen(symbol__,PERIOD_CURRENT,Loww))minCand=iClose(symbol__,PERIOD_CURRENT,Loww);

if(iClose(Symbol(),PERIOD_CURRENT,1)>iHigh(Symbol(),PERIOD_CURRENT,Highh)){a=1;Buy=true;}
if(iClose(Symbol(),PERIOD_CURRENT,1)<iLow(Symbol(),PERIOD_CURRENT,Loww)){a=-1;Sell=true;}
return a;
}   
//+-------------------------------------------------------------------------------+ 
//| Ottiene il numero di barre che sono visualizzate (visibili) nel chart         | 
//+-------------------------------------------------------------------------------+ 
int numBarreInChart(){return ChartVisibleBars();}

int ChartVisibleBars(const long chart_ID=0) 
  { 
// --- preparara la variabile per ottenere il valore della proprietà 
   long result=-1; 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- ricevere il valore della proprietà 
   if(!ChartGetInteger(chart_ID,CHART_VISIBLE_BARS,0,result)) 
     { 
      //--- visualizza il messaggio di errore nel journal Experts 
      Print(__FUNCTION__+", Error Code = ",GetLastError()); 
     } 
//--- restituisce il valore della proprietà chart 
   return((int)result); 
  }   
  
//+--------------------------------------------------------------------------------+ 
//| Imposta il colore di barra superiore, ombra e bordo (corpo di candela bullish) | 
//+--------------------------------------------------------------------------------+ 
bool ChartUpColorSet(const color clr,const long chart_ID=0) 
  { 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- imposta il colore della barra superiore, la sua ombra ed bordo del corpo di una candela rialzista 
   if(!ChartSetInteger(chart_ID,CHART_COLOR_CHART_UP,clr)) 
     { 
      //--- visualizza il messaggio di errore nel journal Experts 
      Print(__FUNCTION__+", Error Code = ",GetLastError()); 
      return(false); 
     } 
//--- esecuzione avvenuta 
   return(true); 
  }
  
//+-------------------------------------------------------------------------------+ 
//| Imposta il colore di barra inferiore, ombra e bordo (corpo di candela bullish) | 
//+-------------------------------------------------------------------------------+ 
bool ChartDownColorSet(const color clr,const long chart_ID=0) 
  { 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- imposta il colore della barra inferiore, la sua ombra ed il bordo del corpo della candela ribassista 
   if(!ChartSetInteger(chart_ID,CHART_COLOR_CHART_DOWN,clr)) 
     { 
      //--- visualizza il messaggio di errore nel journal Experts 
      Print(__FUNCTION__+", Error Code = ",GetLastError()); 
      return(false); 
     } 
//--- esecuzione avvenuta 
   return(true); 
  }    
  
//*------------------- NumCandPerPeriodo () ------------------------------*
/*
enum periodoRicercaCand                              //Incollare negli enum
  {
   giorno                = 0,
   Week                  = 1,
   Mese                  = 2,
   SeiMesi               = 3,
   Anno                  = 4,
  };
  
                                                     //Incollare negl'input'
input periodoRicercaCand periodoRicNumCand    = 0;              //Picchi zigzag nel periodo prima: 1 giorno/1 settimana/1 mese/6 mesi/1 anno
input ENUM_TIMEFRAMES TfPeridoRicCand    ;
*/

int NumCandPerPeriodo(int periodoRicNumCand,ENUM_TIMEFRAMES TfPeridoRicCand)
  {

   int numCandele=0;
   if(periodoRicNumCand==0)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'19.01.2023');
   if(periodoRicNumCand==1)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'24.01.2023');
   if(periodoRicNumCand==2)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'17.02.2023');
   if(periodoRicNumCand==3)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'17.07.2023');
   if(periodoRicNumCand==4)
      numCandele=iBarShift(Symbol(),TfPeridoRicCand,D'18.01.2023')-iBarShift(Symbol(),TfPeridoRicCand,D'17.01.2024');
   return numCandele;
  }  