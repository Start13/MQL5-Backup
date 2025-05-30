#include <MyLibrary\basic.mqh>
//+------------------------------------------------------------------+
//| LEZIONE TOP 9.1 MQL5                                             |
//+------------------------------------------------------------------+

double ema(int period,int shift =0,	ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){			return iMA(symbol,timeframe,period,0,MODE_EMA,PRICE_CLOSE,shift);}
double ema9(int shift =0,	ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){             	return iMA(symbol,timeframe,9,0,MODE_EMA,PRICE_CLOSE,shift);}
double ema50(int shift =0,	ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){             	return iMA(symbol,timeframe,50,0,MODE_EMA,PRICE_CLOSE,shift);}
double ema200(int shift =0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){             	return iMA(symbol,timeframe,200,0,MODE_EMA,PRICE_CLOSE,shift);}


//+------------------------------------------------------------------+
//| LEZIONE TOP 9.2 MQL5                                             |
//+------------------------------------------------------------------+

double   PointMarket(string symbol){       			return SymbolInfoDouble(symbol,SYMBOL_POINT);}

int ATRPoint(int period,int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
	double point_market = PointMarket(symbol);
	if(point_market > 0)	return (int)(iATR(symbol,timeframe,period,shift)/point_market + point_market/10.0);		// variante 1
	if(point_market > 0)	return (int)MathRound(iATR(symbol,timeframe,period,shift)/point_market);					// variante 2
	return 0;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 9.3 MQL5                                             |
//+------------------------------------------------------------------+

bool incrocioEMA_Rialzo(int periodEMA_Fast,int periodEMA_Slow,int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   return (ema(periodEMA_Fast,shift,timeframe,symbol) >= ema(periodEMA_Slow,shift,timeframe,symbol)) && (ema(periodEMA_Fast,shift+1,timeframe,symbol) < ema(periodEMA_Slow,shift+1,timeframe,symbol));
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 9.4 MQL5                                             |
//+------------------------------------------------------------------+

int emaCross(int periodEMA_Fast,int periodEMA_Slow,int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   if((ema(periodEMA_Fast,shift,timeframe,symbol) >= ema(periodEMA_Slow,shift,timeframe,symbol)) && (ema(periodEMA_Fast,shift+1,timeframe,symbol) < ema(periodEMA_Slow,shift+1,timeframe,symbol))) return 1;
   if((ema(periodEMA_Fast,shift,timeframe,symbol) <= ema(periodEMA_Slow,shift,timeframe,symbol)) && (ema(periodEMA_Fast,shift+1,timeframe,symbol) > ema(periodEMA_Slow,shift+1,timeframe,symbol))) return -1;
   return 0;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 9.5 MQL5                                             |
//+------------------------------------------------------------------+

double iAlligator(string symbol, ENUM_TIMEFRAMES timeframe, int jaw_period, int jaw_shift, int teeth_period, int teeth_shift, int lips_period, int lips_shift, ENUM_MA_METHOD ma_method, ENUM_APPLIED_PRICE applied_price, int mode, int index) {
   int handle=iAlligator(symbol,timeframe,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,ma_method,applied_price);
   if(handle >= 0){
	   double val_Indicator[];
		if(CopyBuffer(handle,mode-1,index,1,val_Indicator) > 0){ // (mode-1) usando i valori costanti di MT4, altrimenti basta mettere semplicemente (mode)
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 10.1 MQL5                                            |
//+------------------------------------------------------------------+

double	candleOpen(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){		return iOpen(symbol,timeframe,shift);}
double 	candleClose(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){		return iClose(symbol,timeframe,shift);}
double	candleHigh(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){		return iHigh(symbol,timeframe,shift);}
double	candleLow(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){		return iLow(symbol,timeframe,shift);}
long		candleVolume(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){	return iVolume(symbol,timeframe,shift);}
datetime	candleTime(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){		return iTime(symbol,timeframe,shift);}


//+------------------------------------------------------------------+
//| LEZIONE TOP 10.2 MQL5                                            |
//+------------------------------------------------------------------+

bool candleIsBullish(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){ return candleClose(shift,timeframe,symbol) > candleOpen(shift,timeframe,symbol);}
bool candleIsBearish(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){ return candleClose(shift,timeframe,symbol) < candleOpen(shift,timeframe,symbol);}

//+------------------------------------------------------------------+
//| LEZIONE TOP 10.3 MQL5                                            |
//+------------------------------------------------------------------+

bool candleIsInside(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
	return candleHigh(shift,timeframe,symbol) < candleHigh(shift+1,timeframe,symbol) && candleLow(shift,timeframe,symbol) > candleLow(shift+1,timeframe,symbol);
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 15.2 MQL5                                            |
//+------------------------------------------------------------------+
int candleBody(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   double point = SymbolPoint(symbol);
   if(point > 0) return (int)MathAbs(MathRound((candleClose(shift,timeframe,symbol)-candleOpen(shift,timeframe,symbol))/point));
   return 0;
}

double candleBodyValue(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   return candleBody(shift,timeframe,symbol)*SymbolPoint(symbol);
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 19 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double candleBodyMin(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){ return MathMin(candleOpen(shift,timeframe,symbol),candleClose(shift,timeframe,symbol));}
double candleBodyMax(int shift=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){ return MathMax(candleOpen(shift,timeframe,symbol),candleClose(shift,timeframe,symbol));}

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 22 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double maxCanale(int nCandele,string symbol="",ENUM_TIMEFRAMES timerame=PERIOD_CURRENT,int startCandle=1){     return iHigh(Symbol(symbol),timerame,iHighest(Symbol(symbol),timerame,MODE_HIGH,nCandele,startCandle));}
double minCanale(int nCandele,string symbol="",ENUM_TIMEFRAMES timerame=PERIOD_CURRENT,int startCandle=1){     return iLow(Symbol(symbol),timerame,iLowest(Symbol(symbol),timerame,MODE_LOW,nCandele,startCandle));}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 24 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Incrocio medie mobili (generico)                                 |
//+------------------------------------------------------------------+
int maCross(int maFast_Period,int maFast_InternalShift,ENUM_MA_METHOD maFast_Method,ENUM_APPLIED_PRICE maFast_ApplPrice,int maSlow_Period,int maSlow_InternalShift,ENUM_MA_METHOD maSlow_Method,ENUM_APPLIED_PRICE maSlow_ApplPrice,int index=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   double maFast_0 = iMA(Symbol(symbol),timeframe,maFast_Period,maFast_InternalShift,maFast_Method,maFast_ApplPrice,index);
   double maFast_1 = iMA(Symbol(symbol),timeframe,maFast_Period,maFast_InternalShift,maFast_Method,maFast_ApplPrice,index+1);
   double maSlow_0 = iMA(Symbol(symbol),timeframe,maSlow_Period,maSlow_InternalShift,maSlow_Method,maSlow_ApplPrice,index);
   double maSlow_1 = iMA(Symbol(symbol),timeframe,maSlow_Period,maSlow_InternalShift,maSlow_Method,maSlow_ApplPrice,index+1);
   
   if(maFast_0 > maSlow_0 && maFast_1 <= maSlow_1) return 1;   // In questo caso l'incrocio avviene soltanto quando la media veloce "supera" quella lenta (non toccandola solamente)
   if(maFast_0 < maSlow_0 && maFast_1 >= maSlow_1) return -1;
   return 0;
}