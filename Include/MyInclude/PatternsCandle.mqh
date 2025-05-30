#include <MyLibrary\MyLibrary.mqh>

//input ENUM_TIMEFRAMES periodCandle = PERIOD_CURRENT;      //Timeframe

bool candlePatterns (string &BuySell, int overTopOpenMorEv,int overTopOpenEng,ENUM_TIMEFRAMES periodCandle,bool &morningStarBuy,bool &eveningStarSell,bool &engulfingBuy,bool &engulfingSell)//overTopOpen == 1-->levelFinalCandle1=Top, overTopOpen == 2-->levelFinalCandle1=Close, 
{
//if(!overTopOpen)return false;
bool a=false;
morningStarBuy=false;
eveningStarSell=false;
engulfingBuy=false;
engulfingSell=false;
double Alto=0;
double Basso=0;
double AltoEng=0;
double BassoEng=0;
BuySell="";

//bool overTop,overOpen=false;
//if(overTopOpen==1) overTop=true;
//if(overTopOpen==2) overOpen=true;

//int barre = iBars(Symbol(),periodCandle);

double top3=iHigh(Symbol(),periodCandle,3);
double bottom3=iLow(Symbol(),periodCandle,3);
double open3=iOpen(Symbol(),periodCandle,3);
double close3=iClose(Symbol(),periodCandle,3);
double bodyH3=valoreSuperiore(open3,close3);
double bodyL3=valoreInferiore(open3,close3);

double top2=iHigh(Symbol(),periodCandle,2);
double bottom2=iLow(Symbol(),periodCandle,2);
double open2=iOpen(Symbol(),periodCandle,2);
double close2=iClose(Symbol(),periodCandle,2);
double bodyH2=valoreSuperiore(open2,close2);
double bodyL2=valoreInferiore(open2,close2);

double top1=iHigh(Symbol(),periodCandle,1);
double bottom1=iLow(Symbol(),periodCandle,1);
double open1=iOpen(Symbol(),periodCandle,1);
double close1=iClose(Symbol(),periodCandle,1);
double bodyH1=valoreSuperiore(open1,close1);
double bodyL1=valoreInferiore(open1,close1);

if(overTopOpenMorEv==1) //Top e Bottom Morning/Evening candela 2 e 3
   {Alto=valoreSuperiore(top3,top2);Basso=valoreInferiore(bottom2,bottom3);}
if(overTopOpenEng==1)   //Top e Bottom Engulfing candela 2 e 3
   {AltoEng=top2;BassoEng=bottom2;}   
   
if(overTopOpenMorEv==2) //Alto Basso Body Morning/Evening candela 2
   {Alto=valoreSuperiore(bodyH3,bodyH2);Basso=valoreInferiore(bodyL3,bodyL3);}
if(overTopOpenEng==2)   //Alto Basso Body Engulfing candela 2 
   {AltoEng=bodyH2;BassoEng=bodyL2;}   
   
 //MorningStarBuy   
if(
   //open3>close3&&                                //candela 3 ribassista
   open1<close1&&                                //candela 1 rialzista
   bottom2<valoreInferiore(bottom1,bottom3)&&    //bottom 2 più basso del bottom 1 e 3
   //top2<valoreSuperiore(top1,top3)&&             //top 2 più basso dei top 1 e 3
   open2<=close3&&                               //apertura 2 più bassa o uguale alla chiusura 3
   //close2<=open3&&                               //chiusura 2 più bassa o uguale all'apertura 3
   open1>=valoreSuperiore(open2,close2)&&        //apertura 1 più alta dell'apertura 2 e della chiusura 2
   open1<close1&&                                //apertura 1 più bassa della chiusura 1
   close1>Alto)                                  //chiusura 1 più alta di Alto (Body o Top)
   {BuySell="Buy";morningStarBuy=true;a=true;return a;}
   
  //EveningStarSell 
if(
  // open3<close3&&                                //candela 3 rialzista
   open1>close1&&                                //candela 1 ribassista
   top2>valoreSuperiore(top1,top3)&&             //top 2 più alto del top 1 e 3
   //bottom2>valoreInferiore(bottom1,bottom3)&&    //bottom 2 più alto dei bottom 1 e 3
   open2>=close3&&                               //apertura 2 più alta o uguale alla chiusura 3
   //close2>=open3&&                               //chiusura 2 più alta o uguale all'apertura 3
   open1<=valoreInferiore(open2,close2)&&        //apertura 1 più bassa dell'apertura 2 e della chiusura 2
   open1>close1&&                                //apertura 1 più alta della chiusura 1
   close1<Basso)                                 //chiusura 1 più bassa di Basso (Body o Top)
   {BuySell="Sell";eveningStarSell=true;a=true;return a;} 
     
 //engulfingBuy  
if(open2>close2&&open1<close1&&close1>AltoEng){BuySell="Buy";engulfingBuy=true;a=true;return a;}

 //engulfingSell
if(open2<close2&&open1>close1&&close1<BassoEng){BuySell="Sell";engulfingSell=true;a=true;return a;}
   
return a;   
}
/*      candlePatterns(BuySellCandPatt,candPatt,periodCandles,MorningStarBuy,EveningStarSell,EngulfingBuy,EngulfingSell);
enum candlePattern
  {
   TopCandle1           =  1, //Top candle 1 
   OpenCandle1          =  2, //Open candle 1
  }; */
  
  
//+------------------------------------------------------------------+Restituisce il valore dell'ultimo High oppure Low del giorno precedente e
//|             ultimoshadow_bodygiornoprecedente()                  | se shadow_body==0 : restituisce il picco shadow
//+------------------------------------------------------------------+ se shadow_body==1 : restituisce il picco body 
double ultimoshadow_bodygiornoprecedente(int shadow_body)
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
   int high=iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,BarMax,BarMin);//Print(" high: ",high);
   int low =iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,BarMax,BarMin);//Print(" low: ",low);
   if(shadow_body == 0 && high<low)lastPik=iHigh(Symbol(),PERIOD_CURRENT,high); //Print(" high: ",iHigh(Symbol(),PERIOD_CURRENT,high));Print(" low: ",iLow(Symbol(),PERIOD_CURRENT,low));
   if(shadow_body == 0 && low<high)lastPik=iLow(Symbol(),PERIOD_CURRENT,low);//Print(" lastPik: ",lastPik);
   
   if(shadow_body == 1 && high<low)
      {
       if(tipoDiCandelaN(high)=="Buy")  lastPik=iClose(Symbol(),PERIOD_CURRENT,high);
       if(tipoDiCandelaN(high)=="Sell") lastPik=iOpen(Symbol(),PERIOD_CURRENT,high);
       } //Print(" high: ",iHigh(Symbol(),PERIOD_CURRENT,high));Print(" low: ",iLow(Symbol(),PERIOD_CURRENT,low));
   if(shadow_body == 1 && low<high)
   {
   if(tipoDiCandelaN(low)=="Buy")  lastPik=iOpen(Symbol(),PERIOD_CURRENT,low);//Print(" lastPik: ",lastPik); 
   if(tipoDiCandelaN(low)=="Sell") lastPik=iClose(Symbol(),PERIOD_CURRENT,low);//Print(" lastPik: ",lastPik);   
   }
   return lastPik;
   }   