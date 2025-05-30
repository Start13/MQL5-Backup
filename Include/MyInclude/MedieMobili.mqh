#include <MyLibrary\MyLibrary.mqh>

//+------------------------------------------------------------------+
//|                        chiudeOrdineMA()                          |
//+------------------------------------------------------------------+
void chiudeOrdineMA(double valMA,ulong magic,string comment)
{
if(NumOrdBuy(magic,comment) && Ask(Symbol()) >= valMA) brutalCloseBuyTrades(Symbol(),magic);
if(NumOrdSell(magic,comment) && Bid(Symbol()) <= valMA) brutalCloseSellTrades(Symbol(),magic);
}


/*
enum pendMAcongrua
  {
   No                        = 0,  //No
   tutte                     = 1,  //Congruità pend MA/ordini: Su tutte le candele 
   primaultima               = 2   //Congruità pend MA/ordini: Su prima/ultima candele
  };  
  

input string   comment_Me   =       "--- PENDENZA MA CONGRUA ---";   // --- PENDENZA MA CONGRUA ---
input pendMAcongrua pendMAcongrua       =   0;              //Pend congrua MA/Ord: NO/Tutte le cand/Solo prima/ultima (Min 2)
input int      numcandmacongrue         =   2;              //Numero di candele MA per determinare la pendenza
*/
//+------------------------------------------------------------------+Restituisce true se pendMAcongrua == 0
//|                    pendenzacongruamabuy()                        |Restituisce true se pendMAcongrua == 1 e le pendenze MA di TUTTE le "numcandmacongrue" sono rialziste
//+------------------------------------------------------------------+Restituisce true se pendMAcongrua == 2 e la pendenza MA della prima e dell'ultima "numcandmacongrue" è rialzista
bool pendenzacongruamabuy(int handle_iCustomMa,int pendMAcongrua,int numcandmacongrue)
{
bool a = true;

if(numcandmacongrue<2){Alert("Impostazione \"numero candele x pendenza congrua\" ERRATA. Minimo \"2\"!");return a;}
if(pendMAcongrua==0)return a;

double LAbelBuffer1[];

ArrayInitialize(LAbelBuffer1,0);ArraySetAsSeries(LAbelBuffer1,true);
int COpy1=CopyBuffer(handle_iCustomMa,0,1,numcandmacongrue,LAbelBuffer1);if(COpy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");
/*
for(int i=0;i<ArraySize(LAbelBuffer1);i++)
{
Print(i," ",LAbelBuffer1[i]);}
*/
if(pendMAcongrua==1)
{
for(int i=0;i<numcandmacongrue-1;i++)
{Print(" LAbelBuffer1 BUY ",i ," ",LAbelBuffer1[i]," LAbelBuffer1 BUY ",i+1," ", LAbelBuffer1[i+1]);
if(LAbelBuffer1[i]>LAbelBuffer1[i+1] && i>=numcandmacongrue-2) {a = true;return a;}
if(LAbelBuffer1[i]<LAbelBuffer1[i+1]) {a = false;return a;}
}
}
if(pendMAcongrua==2)
{
//if(LAbelBuffer1[0]>LAbelBuffer1[numcandmacongrue-1]) {a = true;return a;}
if(LAbelBuffer1[0]<LAbelBuffer1[numcandmacongrue-1]) {a = false;return a;}
}
return a;
}
//+------------------------------------------------------------------+Restituisce true se pendMAcongrua == 0
//|                    pendenzacongruamasell()                       |Restituisce true se pendMAcongrua == 1 e le pendenze MA di TUTTE le "numcandmacongrue" sono ribassiste
//+------------------------------------------------------------------+Restituisce true se pendMAcongrua == 2 e la pendenza MA della prima e dell'ultima "numcandmacongrue" è ribassista
bool pendenzacongruamasell(int handle_iCustomMa,int pendMAcongrua,int numcandmacongrue)
{
bool a = true;
if(numcandmacongrue<2){Alert("Impostazione \"numero candele x pendenza congrua\" ERRATA. Minimo \"2\"!");return a;}
if(pendMAcongrua==0)return a;

double LAbelBuffer1[];

ArrayInitialize(LAbelBuffer1,1);ArraySetAsSeries(LAbelBuffer1,true);
int COpy1=CopyBuffer(handle_iCustomMa,0,1,numcandmacongrue,LAbelBuffer1);if(COpy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");

if(pendMAcongrua==1)
{
for(int i=0;i<numcandmacongrue-1;i++)
{
Print(" LAbelBuffer1 SELL ",i ," ",LAbelBuffer1[i]," LAbelBuffer1 SELL ",i+1," ",LAbelBuffer1[i+1]);
if(LAbelBuffer1[i]<LAbelBuffer1[i+1] && i>=numcandmacongrue-2) {a = true;return a;}
if(LAbelBuffer1[i]>LAbelBuffer1[i+1]) {a = false;return a;}
}
}
if(pendMAcongrua==2)
{
//if(LAbelBuffer1[0]<LAbelBuffer1[numcandmacongrue-1]) {a = true;return a;}
if(LAbelBuffer1[0]>LAbelBuffer1[numcandmacongrue-1]) {a = false;return a;}
}
return a;
}