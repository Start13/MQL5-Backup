#property copyright "Roberto La Bella, Copyright ©"
#property link      ""
#property version   "1.00"
#property strict
//---

// Lezione sull'allocazione di capitale per sviluppare algoritmi di Risk & Money Management

//---

input string		commentEA_ =						"=== EA ===";								//=========
input int     		magic_number   =               1234;                  					// Magic Number
input string     	commentTrade =               	"lezione allocazione";     			// Commento Trade

input string 		commentSP_ = 						"=== PARAMETRI STRATEGIA ===";		//=========
input int         DistSL =                      630;                						// SL (in Points)
input int         DistTP =                      1090;                					// TP (in Points)

input	string 		commentMM_ =                	"=== MONEY MANAGEMENT ===";			//=========
input double     	lotsEA =                  		0.1;               						// Lotti

input bool     	compounding =                 true;               						// Compounding
//---

//+------------------------------------------------------------------+
//| ALLOCAZIONE CAPITALE                                             |
//+------------------------------------------------------------------+
input	string 		commentALL_ =                	"=== ALLOCAZIONE ===";					//=========
input double   	capitalToAllocateEA =  			0;												// Capitale da allocare per l'EA (0 = intero capitale)
input string      Commen              = "EA";

double capitalToAllocate = 		0;
bool autoTradingOnOff = 			true;
string symbol_=Symbol();
//+------------------------------------------------------------------+

//---
#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+

int OnInit(){
	
	Allocazione_Init();
	
   TesterHideIndicators(true);
   return(INIT_SUCCEEDED);
}

void OnTick(){
	
	if(!autoTradingOnOff) return;
	
	Allocazione_Check(magic_number);
   
   // Strategia
   if(semaforoCandela(0)){
   	EA_Strategia(magic_number);
   }
}





// STEP 1: 	Inserire codice delle variabili globali
// STEP 2:	Inserire Allocazione_Init() nella funzione OnInit
// STEP 3:	Inserire Allocazione_Check() + controllo "autoTradingOnOff" nella funzione OnTick
// STEP 4: 	Inserire funzione Money Management (compounding) per il calcolo lotti, prima dell'apertura trade



//+------------------------------------------------------------------+
//| ALLOCAZIONE CAPITALE                                             |
//+------------------------------------------------------------------+

void Allocazione_Init(){
	capitalToAllocate = 	capitalToAllocateEA > 0 ? capitalToAllocateEA : AccountBalance();
}








// Controllo Allocazione Capitale
void Allocazione_Check(int magic,string symbol=NULL){
	
	if(!semaforoSecondi(0,2)) return;
	
	if(EquityEA(magic,symbol_) <= 0){
   	Print("Raggiunta soglia massima per Allocazione Capitale ("+currencySymbolAccount()+DoubleString(capitalToAllocate)+"), Chiusura totale ordini!");
   	brutalCloseTotal(symbol_,magic);
   	autoTradingOnOff = false;
	}
}

double EquityEA(int magic,string symbol=NULL){
	return capitalToAllocate + profittiEA(magic,symbol_);
}

double compEA(int magic,string symbol=NULL){
	if(compounding && capitalToAllocate > 0) return (EquityEA(magic,symbol_))/capitalToAllocate;
	return 1;
}


double profittiEA(int magic,string symbol=NULL){
	static double profitHistory = 0;
	double profitFloating = 0;
	
	static int i = 0;
	
	#ifdef __MQL5__
	HistorySelect(0,D'3000.01.01');
	for(;i<HistoryDealsTotal();i++){
      if(HistoryDealSelectByPos(i) && HistoryDealIsSymbol(symbol_) && HistoryDealIsMagicNumber(magic)){
         profitHistory += HistoryDealProfitFull();
      }
   }
   
   for(int j=0;j<PositionsTotal();j++){
      if(PositionSelectByPos(j) && PositionIsSymbol(symbol_) && PositionIsMagicNumber(magic)){
         profitFloating += PositionProfitFull();
      }
   }
   #endif 
   
   #ifdef __MQL4__
   for(;i<OrdersHistoryTotal();i++){
   	if(OrderSelectByPos(i,MODE_HISTORY) && OrderIsSymbol(symbol_) && OrderIsMagicNumber(magic)){
         profitHistory += OrderProfitFull();
      }
	}
	
	for(int j=0;j<OrdersTotal();j++){
      if(OrderSelectByPos(j) && OrderIsSymbol(symbol_) && OrderIsMagicNumber(magic)){
         profitFloating += OrderProfitFull();
      }
   }
   #endif 
   
   
   return profitHistory + profitFloating;
}







































//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| FUNZIONI AUSILIARIE                                              |
//+------------------------------------------------------------------+
bool semaforoSecondi(ushort idContatore,int secondiPerSemaforo=10){
   static datetime contatoreSecondi[USHORT_MAX] = {0};
   if(TimeCurrent() >= contatoreSecondi[idContatore]+secondiPerSemaforo){
      return (contatoreSecondi[idContatore] = TimeCurrent()) >= 0;
   }
   return false;
}

//+------------------------------------------------------------------+
//| STRATEGIA                                                        |
//+------------------------------------------------------------------+

void EA_Strategia(int magic,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
	// Entry
	if(Pattern_Entry("Buy",symbol_,timeframe) && NumOrdBuy(magic_number,Commen) == 0){
		double lots = myVolume(magic,symbol_);
		SendTradeBuyInPoint(symbol_,lots,0,DistSL,DistTP,commentTrade,magic);
		return;
	}
	
	if(Pattern_Entry("Sell",symbol_,timeframe) && NumOrdSell(magic_number,Commen) == 0){
		double lots = myVolume(magic,symbol_);
		SendTradeSellInPoint(symbol_,lots,0,DistSL,DistTP,commentTrade,magic);
		return;
	}
	
	// Exit
	if(Pattern_Exit("Buy",symbol_,timeframe) && NumOrdBuy(magic_number,Commen) > 0){
		brutalCloseBuyTrades(symbol_,magic);
	}
	
	if(Pattern_Exit("Sell",symbol_,timeframe) && NumOrdSell(magic_number,Commen) > 0){
		brutalCloseSellTrades(symbol_,magic);
	}
}

const double sigma =					0.000001;

bool Pattern_Entry(string type,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
	// MACD (Close, 50, 200, 10)
	// RVI (54), Level: -0.04
   double ind_MACD  = 		iMACD(symbol_,timeframe,50,200,10,PRICE_CLOSE,0,1);
   double ind_RVI1 =			iRVI(symbol_,timeframe,54,0,1);
   double ind_RVI2 = 		iRVI(symbol_,timeframe,54,0,2);
   
   bool   patternBuy1 =		ind_MACD > 0 + sigma;
   bool   patternBuy2 = 	ind_RVI1 < -0.04 - sigma && ind_RVI2 > -0.04 + sigma;
   
   bool   patternSell1 =	ind_MACD < 0 - sigma;
   bool   patternSell2 = 	ind_RVI1 > 0.04 + sigma && ind_RVI2 < 0.04 - sigma;
   
   if(type == "Buy")	return patternBuy1 && patternBuy2;
   if(type == "Sell")	return patternSell1 && patternSell2;
   
   return false;
   
}

bool Pattern_Exit(string type,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
	double ind_MA =		iMA(NULL,timeframe, 24,0,MODE_SMA,PRICE_CLOSE,1);
	double CandleOpen = 	candleOpen(0,timeframe,symbol_);
	
   bool   patternBuy  =	CandleOpen > ind_MA + sigma;
   bool   patternSell = CandleOpen < ind_MA - sigma;

	if(type == "Buy") 	return patternBuy;
   if(type == "Sell")	return patternSell;
   
   return false;
}

#ifdef __MQL5__
double iRVI(string symbol,ENUM_TIMEFRAMES timeframe,int period,int mode,int index){
   int handle=iRVI(Symbol(symbol_),timeframe,period); // "mode" non necessario in MQL5
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
#endif 

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double myVolume(int magic,string symbol=NULL){
	double lots = lotsEA*compEA(magic,symbol_);
	
	lots = NormalizeDouble(lots,2);
	
	return lots;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifdef __MQL4__
void brutalCloseBuyTrades(string symbol="",int magic=0,color arrow_color=clrNONE){     brutalCloseBuy(symbol_,magic,arrow_color);}
void brutalCloseSellTrades(string symbol="",int magic=0,color arrow_color=clrNONE){    brutalCloseSell(symbol_,magic,arrow_color);}
#endif 


