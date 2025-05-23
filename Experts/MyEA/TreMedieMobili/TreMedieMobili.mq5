#property copyright "Corrado Bruni, Copyright ©"
#property link      ""
#property version   "1.00"
#property strict
//---

input int magicNumber =				1234;				// Magic Number
input string Comment  =""; 
input int 	nCandles = 					10;				// Candele trend

input int PeriodEMA_1 =					46;				// Periodo EMA 1
input int PeriodEMA_2 =					92;				// Periodo EMA 2
input int PeriodEMA_3 =					180;				// Periodo EMA 3
input ENUM_TIMEFRAMES PeriodPattern1 = PERIOD_CURRENT;              // TF Pattern 1
input ENUM_TIMEFRAMES PeriodPattern2 = PERIOD_CURRENT;              // TF Pattern 2

input int DistanzaPoints =            50;            // Distanza Points da EMA 1

input int trailStop      =           200;          // Distanza Points Trail Stop
input int trailStep      =            50;          // Distanza Points Trail Step

input int BrStart        =           150;          // Distanza BreakEven Start
input int BrStep_        =            15;          // Distanza BreakEven Step

bool 	candeleInTrend;

string symbol_ = Symbol();
//---
#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
int OnInit(){
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
resetIndicators();   
}

void OnTick(){
      TsPoints(trailStop,trailStep,magicNumber,Comment);
      BEPips(BrStart,BrStep_,magicNumber,Comment);
      closeOrders();

   if(semaforoCandela(0))EA_Strategia(magicNumber);
   Indicators();

}

void EA_Strategia(int magic,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
   double c1 = iClose(Symbol(),PERIOD_CURRENT,1);  
   double o1 = iOpen(Symbol(),PERIOD_CURRENT,1);  

	candeleInTrend = 	patternEMACongruent_TrendBuy(nCandles,1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3)||patternEMACongruent_TrendSell(nCandles,1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	int 	n_Candele_Trend = patternEMACongruent_TrendBuy_nCandles(1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3)+patternEMACongruent_TrendSell_nCandles(1,timeframe,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	

	Print("Nelle ultime ",nCandles," candele vi è una formazione in trend? -> ",candeleInTrend);
	Print("Numero candele in trend: ",n_Candele_Trend);
	
	// BUY
	bool patternBuy1 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern1,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternBuy2 = patternEMACongruent_TrendBuy(nCandles,1,PeriodPattern2,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternBuy3 = Ask(symbol) >= ema(PeriodEMA_1,0,timeframe,symbol)+DistanzaPoints*Point();
	
	if(patternBuy1 && patternBuy2 && patternBuy3 && NumOrdBuy(magic)==0 
	//&& c1>patternBuy3 
	//&& c1>=EMA1+DistanzaPoints*Point()
	)
	{SendTradeBuyInPoint(symbol,1,0,10000,0,Comment,magic);}
	
	// SELL
	bool patternSell1 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern1,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternSell2 = patternEMACongruent_TrendSell(nCandles,1,PeriodPattern2,symbol,PeriodEMA_1,PeriodEMA_2,PeriodEMA_3);
	bool patternSell3 = Bid(symbol) <= ema(PeriodEMA_1,0,timeframe,symbol)-DistanzaPoints*Point();
	
	if(patternSell1 && patternSell2 && patternSell3 && NumOrdSell(magic)==0 
	//&& c1<patternSell3 
	//&& c1<=EMA1+DistanzaPoints*Point()
	)
	{SendTradeSellInPoint(symbol,1,0,10000,0,Comment,magic);}
	
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool patternEMACongruent(string type,int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=NULL,int periodEMA_1=0,int periodEMA_2=0,int periodEMA_3=0,int periodEMA_4=0,int periodEMA_5=0,int periodEMA_6=0){
   double ema1 = periodEMA_1 > 0 ? ema(periodEMA_1,index,timeframe,symbol) : 0;
   double ema2 = periodEMA_2 > 0 ? ema(periodEMA_2,index,timeframe,symbol) : 0;
   double ema3 = periodEMA_3 > 0 ? ema(periodEMA_3,index,timeframe,symbol) : 0;
   double ema4 = periodEMA_4 > 0 ? ema(periodEMA_4,index,timeframe,symbol) : 0;
   double ema5 = periodEMA_5 > 0 ? ema(periodEMA_5,index,timeframe,symbol) : 0;
   double ema6 = periodEMA_6 > 0 ? ema(periodEMA_6,index,timeframe,symbol) : 0;
   
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

void closeOrders()
{
if(candeleInTrend==0 && NumOrdBuy(magicNumber))brutalCloseBuyTrades();
if(candeleInTrend==0 && NumOrdSell(magicNumber))brutalCloseSellTrades();
}

//+------------------------------------------------------------------+
//|                           Indicators                             |
//+------------------------------------------------------------------+
void Indicators()
  {
   char index=0;
     {
      
      
      ChartIndicatorAdd(0,0,iMA(symbol_,PERIOD_CURRENT,PeriodEMA_1,0,MODE_EMA,PRICE_CLOSE));  //  iMA(Symbol(symbol),timeframe,period,ma_shift,ma_method,applied_price);

      ChartIndicatorAdd(0,0,iMA(symbol_,PERIOD_CURRENT,PeriodEMA_2,0,MODE_EMA,PRICE_CLOSE));

      ChartIndicatorAdd(0,0,iMA(symbol_,PERIOD_CURRENT,PeriodEMA_3,0,MODE_EMA,PRICE_CLOSE));

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