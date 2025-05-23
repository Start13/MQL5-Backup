#property copyright "Corrado Bruni, Copyright ©"
#property link      ""
#property version   "1.00"
#property strict
//---
enum pendImpLiv
{
impulso     =   1,
livello     =   2,
}; 
enum pattImpLiv
{
impulso     =   1,
livello     =   2,
};  
 
input string   comment_im =            "--- DISTANZE EMA 1---";   // --- DISTANZE EMA 1 ---

input int DistanzaPoints     =            1000;             //Distanza Points da EMA 1 per apertura Ordini
input int DistanzaMaxPoints  =           10000;             //Distanza Points da EMA 1 Max per apertura Ordini

input string   comment_PEND  =       "--- PATTERN PENDENZE ---";    // --- PATTERN PENDENZE ---
input bool     pendenze      =       true;                          //Quando le pendenze delle MA sono uguali: apre ordine
//input pendImpLiv pendImpLiv_ =          1;                          //Apertura Ordine ad impulso o a livello
//input int 	   nCandlesPend  = 	      10;			    	           //Candele Pendenza uguali per apertura Ordine
input bool     closeOrdPend  =       false;                         //Quando le pendenze MA sono discordi: chiude ordine

input string   comment_PATT    =       "--- PATTERN MEDIE MOBILI ---";     // --- PATTERN MEDIE MOBILI ---
//input bool     patternMA       =     true;                          //Quando si presenta il Pattern Medie: apre Ordine
//input pattImpLiv pattImpLiv_ =          1;                          //Apertura Ordine ad impulso o a livello
input int 	   nCandles        = 	   10;			    	           //Candele trend per apertura Ordine
input bool     closeOrdNoPatt  =     true;                          //Quando il Pattern Medie non è allineato: chiude ordine

input string   comment_OS=            "--- ORDER SETTINGS ---";    // --- ORDER SETTINGS ---
input double lotsEA   =               0.1;            //Lots
input int magicNumber =				    1234;				// Magic Number
input string Comment  =             "TreMedieMobili iCustom"; 

input string   comment_SL=           "--- STOP LOSS ---"; // --- STOP LOSS ---
input int SlPoints    =             10000;            //Stop loss Points

input string   comment_TS=           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input int trailStop      =          4000;          // Distanza Points Trail Stop
input int trailStep      =           700;          // Distanza Points Trail Step

input string   comment_BE=           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input int BrStart        =          2500;          // Distanza BreakEven Start
input int BrStep_        =           200;          // Distanza BreakEven Step

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input int      TpPoints  = 1000;              //Take Profit Points

input int PeriodEMA_1 =					46;				// Periodo EMA 1
input ENUM_MA_METHOD InpMAMethod1   =  MODE_SMMA;  // Method 1
input color          InpColor1      =  clrGold;    // Color 1
input int PeriodEMA_2 =					92;				// Periodo EMA 2
input ENUM_MA_METHOD InpMAMethod2   =  MODE_SMMA;  // Method 1
input color          InpColor2      =  clrLime;    // Color 2
input int PeriodEMA_3 =					180;				// Periodo EMA 3
input ENUM_MA_METHOD InpMAMethod3   =  MODE_SMMA;  // Method 1
input color          InpColor3      =  clrAzure;   // Color 3
input ENUM_TIMEFRAMES PeriodPattern1 = PERIOD_CURRENT; // TF Pattern 1
input ENUM_TIMEFRAMES PeriodPattern2 = PERIOD_CURRENT; // TF Pattern 2

bool 	candeleInTrend;

string symbol_ = Symbol();

int handle1,handle2,handle3,handle4,handle5,handle6,shift1,shift2,shift3;
double LabelBuffer1[];
double LabelBuffer2[];
double LabelBuffer3[];

int    copy1;
int    copy2;
int    copy3;

double iCust1;
double iCust2;
double iCust3;

double ASK,BID;

int pendenzaMA1 = 0;int pendenzaMA2 = 0;int pendenzaMA3 = 0;
//---
#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
int OnInit(){
handle1 = iCustom(symbol_,0,"MyIndicators\\MA\\Custom Moving Average Input Color",PeriodEMA_1,0,InpMAMethod1 ,InpColor1);
handle2 = iCustom(symbol_,0,"MyIndicators\\MA\\Custom Moving Average Input Color",PeriodEMA_2,0,InpMAMethod2 ,InpColor2); 
handle3 = iCustom(symbol_,0,"MyIndicators\\MA\\Custom Moving Average Input Color",PeriodEMA_3,0,InpMAMethod3 ,InpColor3);    
if(nCandles<1)Alert("Numero candele trend: Minimo 1");
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
resetIndicators();   
}

void OnTick(){
      TsPoints(trailStop,trailStep,magicNumber,Comment);
      BEPips(BrStart,BrStep_,magicNumber,Comment);
      NoPattcloseOrders();


   if(semaforoCandela(0))EA_Strategia(magicNumber);
   Indicators();
   ASK = Ask(symbol_);
   BID = Bid(symbol_);
}

void EA_Strategia(int magic,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
   double c1 = iClose(Symbol(),PERIOD_CURRENT,1);  
   double o1 = iOpen(Symbol(),PERIOD_CURRENT,1);  


copy1=CopyBuffer(handle1,0,0,3,LabelBuffer1);iCust1=LabelBuffer1[0];if(copy1<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy2=CopyBuffer(handle2,0,0,3,LabelBuffer2);iCust2=LabelBuffer2[0];if(copy2<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito");  
copy3=CopyBuffer(handle3,0,0,3,LabelBuffer3);iCust3=LabelBuffer3[0];if(copy3<=0)Print("Il tentativo di ottenere i valori di Custom Moving Average è fallito"); 
string med1,med2,med3,medCongr;
if(LabelBuffer1[1] > LabelBuffer1[2]){pendenzaMA1=-1;
//Print("MA fast Rossa");
} 
if(LabelBuffer1[1] < LabelBuffer1[2]){pendenzaMA1=1;
//Print("MA fast Blu");
} 
if(pendenzaMA1==1)med1="Rialzista";if(pendenzaMA1==-1)med1="Ribassista";
if(LabelBuffer2[1] > LabelBuffer2[2]){pendenzaMA2=-1;
//Print("MA media Rossa");
} if(LabelBuffer2[1] < LabelBuffer2[2]){pendenzaMA2=1;
//Print("MA media Blu");
} 
if(pendenzaMA2==1)med2="Rialzista";if(pendenzaMA2==-1)med2="Ribassista";
if(LabelBuffer3[1] > LabelBuffer3[2]){pendenzaMA3=-1;
//Print("MA slow Rossa");
} if(LabelBuffer3[1] < LabelBuffer3[2]){pendenzaMA3=1;
//Print("MA slow Blu");
} 
if(pendenzaMA3==1)med3="Rialzista";if(pendenzaMA3==-1)med3="Ribassista";

if(pendenzaMA1==1 && pendenzaMA2==1 && pendenzaMA3==1)medCongr="Medie Mobili Rialziste";
if(pendenzaMA1==-1 && pendenzaMA2==-1 && pendenzaMA3==-1)medCongr="Medie Mobili Ribassiste";
if(pendenzaMA1!=pendenzaMA2 || pendenzaMA2!=pendenzaMA3 || pendenzaMA1!=pendenzaMA3)medCongr="Medie Mobili con PENDENZE DIVERSE";

   pendenzeDiscordi(pendenzaMA1,pendenzaMA2,pendenzaMA3);
	
	candeleInTrend = 	patternEMACongruent_TrendBuy(nCandles,1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3)||patternEMACongruent_TrendSell(nCandles,1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	int 	n_Candele_Trend = patternEMACongruent_TrendBuy_nCandles(1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3)+patternEMACongruent_TrendSell_nCandles(1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	
   Comment(medCongr,"\nPendenza Media Mobile Fast  ",med1,"\nPendenza Media Mobile Med  ",med2,"\nPendenza Media Mobile Slow ",med3,"\n\nNelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend,
           "\nNumero candele in trend: ",n_Candele_Trend );
	Print("Nelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend);
	Print("Numero candele in trend: ",n_Candele_Trend);
	
	// BUY
	bool patternBuy1 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern1,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternBuy2 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern2,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternBuy3 = ASK >= MaCustom(handle1,0)+DistanzaPoints*Point();
	bool patternBuy4 = ASK <  MaCustom(handle1,0)+DistanzaMaxPoints*Point();
	
	if(patternBuy1 && patternBuy2 && patternBuy3 && patternBuy4 && NumOrdBuy(magic,Comment)==0 && OpenOrdPendenzeBuy(pendenzaMA1,pendenzaMA2,pendenzaMA3)
	//&& c1>patternBuy3 
	//&& c1>=EMA1+DistanzaPoints*Point()
	)
	{SendTradeBuyInPoint(symbol,lotsEA,0,SlPoints,TpPoints,Comment,magic);}
	
	// SELL
	bool patternSell1 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern1,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternSell2 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern2,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternSell3 = BID <= MaCustom(handle1,0)-DistanzaPoints*Point();
	bool patternSell4 = BID >  MaCustom(handle1,0)-DistanzaMaxPoints*Point();
	
	if(patternSell1 && patternSell2 && patternSell3 && patternBuy4 && NumOrdSell(magic,Comment)==0 && OpenOrdPendenzeSell(pendenzaMA1,pendenzaMA2,pendenzaMA3)
	//&& c1<patternSell3 
	//&& c1<=EMA1+DistanzaPoints*Point()
	)
	{SendTradeSellInPoint(symbol,lotsEA,0,SlPoints,TpPoints,Comment,magic);}
	
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool patternEMACongruent(string type,int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   double ema1 = periodEMA_1 > 0 ? MaCustom(handle1,index) : 0;    
   double ema2 = periodEMA_2 > 0 ? MaCustom(handle2,index) : 0;
   double ema3 = periodEMA_3 > 0 ? MaCustom(handle3,index) : 0;
   double ema4 = periodEMA_4 > 0 ? MaCustom(handle4,index) : 0;
   double ema5 = periodEMA_5 > 0 ? MaCustom(handle5,index) : 0;
   double ema6 = periodEMA_6 > 0 ? MaCustom(handle6,index) : 0;

   if(ema1 > 0 && ema2 > 0){
      if(type == "OP_BUY"){
         if(ema3 == 0) return ema1 > ema2;
         if(ema4 == 0) return ema1 > ema2 && ema2 > ema3;
         if(ema5 == 0) return ema1 > ema2 && ema2 > ema3 && ema3 > ema4;
         if(ema6 == 0) return ema1 > ema2 && ema2 > ema3 && ema3 > ema4 && ema4 > ema5;
         return ema1 > ema2 && ema2 > ema3 && ema3 > ema4 && ema4 > ema5 && ema5 > ema6;
      }
      if(type == "OP_SELL"){
         if(ema3 == 0) return ema1 < ema2;
         if(ema4 == 0) return ema1 < ema2 && ema2 < ema3;
         if(ema5 == 0) return ema1 < ema2 && ema2 < ema3 && ema3 < ema4;
         if(ema6 == 0) return ema1 < ema2 && ema2 < ema3 && ema3 < ema4 && ema4 < ema5;
         return ema1 < ema2 && ema2 < ema3 && ema3 < ema4 && ema4 < ema5 && ema5 < ema6;
      }
   }
   return false;
}

bool patternEMACongruent_Buy (int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	return patternEMACongruent("OP_BUY",index,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6);
}
bool patternEMACongruent_Sell(int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	return patternEMACongruent("OP_SELL",index,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6);
}

bool patternEMACongruent_TrendBuy(int nCandlesToAnalyze,int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   for(int i=0;i<nCandlesToAnalyze;i++)	if(!patternEMACongruent_Buy(indexStart+i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) return false;
   return true;
}

bool patternEMACongruent_TrendSell(int nCandlesToAnalyze,int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   for(int i=0;i<nCandlesToAnalyze;i++)	if(!patternEMACongruent_Sell(indexStart+i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) return false;
   return true;
}

int patternEMACongruent_TrendBuy_nCandles(int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	int nCount = 0;
	for(int i=indexStart;i<iBars(Symbol(symbol),timeframe)-1;i++)	if(patternEMACongruent_Buy(i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) nCount++; else break;
   return nCount;
}

int patternEMACongruent_TrendSell_nCandles(int indexStart=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
	int nCount = 0;
	for(int i=indexStart;i<iBars(Symbol(symbol),timeframe)-1;i++)	if(patternEMACongruent_Sell(i,timeframe,symbol,periodEMA_1,periodEMA_2,periodEMA_3,periodEMA_4,periodEMA_5,periodEMA_6)) nCount++; else break;
   return nCount;
}

void NoPattcloseOrders()
{
if(closeOrdNoPatt && candeleInTrend==0 && NumOrdBuy(magicNumber))brutalCloseBuyTrades();
if(closeOrdNoPatt && candeleInTrend==0 && NumOrdSell(magicNumber))brutalCloseSellTrades();
}
//+------------------------------------------------------------------+
//|                           Indicators                             |
//+------------------------------------------------------------------+
void Indicators()
  {
   char index=0;
     {
      ChartIndicatorAdd(0,0,handle1);  

      ChartIndicatorAdd(0,0,handle2);

      ChartIndicatorAdd(0,0,handle3);

      //if(OnChart_ATR){index ++;int indicator_handleATR=iATR(Symbol(),periodATR,ATR_period);ChartIndicatorAdd(0,index,indicator_handleATR);}        
     }
  } 
//+------------------------------------------------------------------+
void resetIndicators()

  {
   int num_windows = (int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);

   for(int window = num_windows - 1; window > -1; window--)
     {
      int numIndicators = ChartIndicatorsTotal(0, window);

      for(int index = numIndicators; index >= 0; index--)
        {
         ResetLastError();

         string name = ChartIndicatorName(0, window, index);

         if(GetLastError() != 0)
           {
            //PrintFormat("ChartIndicatorName error: %d", GetLastError());
            ResetLastError();
           }

         if(!ChartIndicatorDelete(0, window, name))
           {
            if(GetLastError() != 0)
              {
               //  PrintFormat("Delete indicator error: %d", GetLastError());
               ResetLastError();
              }
           }
         else
           {
            Print("Delete indicator with handle:", name);
           }
        }
     }
  } 
  
double MaCustom(int handle,int index)
{
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,0,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}   

bool OpenOrdPendenzeBuy(int pend1,int pend2,int pend3)
{
bool a = false;
if(!pendenze) {a = true; return a;}
if(pendenze && pend1==1 && pend2==1 && pend3==1) {a= true; return a;} 

return a;
}

bool OpenOrdPendenzeSell(int pend1,int pend2,int pend3)
{
bool a = false;
if(!pendenze) {a = true; return a;}
if(pendenze && pend1==-1 && pend2==-1 && pend3==-1) {a= true; return a;}

return a;
}

void pendenzeDiscordi(int pend1,int pend2,int pend3)
{
bool a = false;
if(!closeOrdPend || NumOrdini(magicNumber,Comment)==0)return;
if(NumOrdini(magicNumber,Comment)>0) 
{
if(closeOrdPend && (pend1 != pend2 || pend2 != pend3 || pend1 != pend3)) brutalCloseTotal(symbol_,magicNumber); 
}}

