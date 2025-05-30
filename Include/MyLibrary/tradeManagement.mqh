#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 14	MQL5 	                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Funzioni customizzate per gli ordini con un approccio alla MT4   |
//+------------------------------------------------------------------+
/*
ulong SendPosition(string symbol,ENUM_ORDER_TYPE type,double volume,double price,int deviation,double sl,double tp,string comment,ulong magic){
   MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
   MqlTradeResult    positionResult;	ZeroMemory(positionResult);
   
   
   positionRequest.action =         TRADE_ACTION_DEAL;
   positionRequest.type =           type;
   positionRequest.type_filling =   ORDER_FILLING_IOC;
   positionRequest.deviation =      deviation;
   positionRequest.symbol =         Symbol(symbol);
   positionRequest.volume =         NormalizeDouble(volume,2);
   positionRequest.price =          NormalizeDouble(price,SymbolDigits(symbol));
   positionRequest.sl =             NormalizeDouble(sl,SymbolDigits(symbol));;
   positionRequest.tp =             NormalizeDouble(tp,SymbolDigits(symbol));;
   positionRequest.comment =        StringExtract(comment,0,31);
   positionRequest.magic =          magic;
   
   //if(OrderSend(positionRequest,positionResult))	return positionResult.deal;	// Ritorna il ticket dell'affare chiuso
   if(OrderSend(positionRequest,positionResult))	return positionResult.order; 	// Ritorna il ticket dell'ordine inviato a mercato
   
   return printError("Error to send Position, #"+IntegerToString(positionResult.retcode));
}

ulong SendOrder(string symbol,ENUM_ORDER_TYPE type,double volume,double price,double stoplimit,int deviation,double sl,double tp,string comment,ulong magic,datetime expiration=0){
   MqlTradeRequest   orderRequest;	ZeroMemory(orderRequest);
   MqlTradeResult    orderResult;	ZeroMemory(orderResult);
   
   orderRequest.action =         TRADE_ACTION_PENDING;
   orderRequest.type =           type;
   orderRequest.type_filling =   ORDER_FILLING_IOC;
   orderRequest.deviation =      deviation;
   orderRequest.symbol =     		Symbol(symbol);
   orderRequest.volume =         NormalizeDouble(volume,2);
   if(type == ORDER_TYPE_BUY_STOP_LIMIT || type == ORDER_TYPE_SELL_STOP_LIMIT)
   	orderRequest.stoplimit =	NormalizeDouble(stoplimit,SymbolDigits(symbol));
	orderRequest.price =          NormalizeDouble(price,SymbolDigits(symbol));
   orderRequest.sl =             NormalizeDouble(sl,SymbolDigits(symbol));
   orderRequest.tp =             NormalizeDouble(tp,SymbolDigits(symbol));
   orderRequest.comment =        StringExtract(comment,0,31);
   orderRequest.magic =          magic;
   orderRequest.type_time =		ORDER_TIME_GTC;
   if(expiration > 0){
   	orderRequest.type_time =	ORDER_TIME_SPECIFIED;
   	orderRequest.expiration =	expiration;
	}
   
   if(OrderSend(orderRequest,orderResult)) return orderResult.order;
   
   return printError("Error to send Order, #"+IntegerToString(orderResult.retcode));
}
*/

ulong SendTrade(string symbol,ENUM_ORDER_TYPE type,double volume,double price,double stoplimit,int deviation,double sl,double tp,string comment,ulong magic,datetime expiration=0,bool verbose=true){
	if(type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL)
		return SendPosition(symbol,type,volume,price,deviation,sl,tp,comment,magic,verbose);
	
	if(type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_BUY_STOP_LIMIT   ||   type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_SELL_STOP_LIMIT)
		return SendOrder(symbol,type,volume,price,stoplimit,deviation,sl,tp,comment,magic,expiration,verbose);
	
	return 0;
}


////////////////////////////////////
//+------------------------------------------------------------------+
//| Funzioni customizzate per gli ordini e le posizioni              |
//+------------------------------------------------------------------+

bool OrderSelectByIndex(int index){			return OrderGetTicket(index) > 0;}
bool OrderSelectByPos(int index){			return OrderSelectByIndex(index);}

long     OrderTicket(){          return OrderGetInteger(ORDER_TICKET);}
ENUM_ORDER_TYPE	OrderType(){ 	return (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);}
ENUM_ORDER_STATE	OrderState(){ 	return (ENUM_ORDER_STATE)OrderGetInteger(ORDER_STATE);}
datetime OrderExpiration(){      return (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);}
datetime OrderTimeExpiration(){  return OrderExpiration();}
datetime OrderTimeSetup(){      	return (datetime)OrderGetInteger(ORDER_TIME_SETUP);}
datetime OrderTimeDone(){      	return (datetime)OrderGetInteger(ORDER_TIME_DONE);}
long		OrderTimeSetupMSC(){    return OrderGetInteger(ORDER_TIME_SETUP_MSC);}
long		OrderTimeDoneMSC(){     return OrderGetInteger(ORDER_TIME_DONE_MSC);}
long     OrderMagicNumber(){     return OrderGetInteger(ORDER_MAGIC);}
double   OrderOpenPrice(){       return OrderGetDouble(ORDER_PRICE_OPEN);}
double   OrderClosePrice(){      return OrderGetDouble(ORDER_PRICE_CURRENT);}
double   OrderVolume(){          return OrderGetDouble(ORDER_VOLUME_CURRENT);}
double   OrderLots(){            return OrderGetDouble(ORDER_VOLUME_CURRENT);}
double   OrderTakeProfit(){      return OrderGetDouble(ORDER_TP);}
double   OrderStopLoss(){        return OrderGetDouble(ORDER_SL);}
string   OrderComment(){         return OrderGetString(ORDER_COMMENT);}
string   OrderSymbol(){          return OrderGetString(ORDER_SYMBOL);}

bool OrderIsSymbol(string symbol="ALL"){
   if(StringIsEqual(symbol,"ALL")) return true;
   return StringIsEqual(OrderSymbol(),Symbol(symbol));
}
bool 		OrderIsSymbolExact(string symbol){		return StringIsEqual(OrderSymbol(),symbol);}
bool 		OrderIsSymbolCurrent(){						return StringIsEqual(OrderSymbol(),Symbol());}

bool 		OrderIsBuyPending(){     	return OrderIsBuyStop() || OrderIsBuyLimit();}
bool 		OrderIsSellPending(){    	return OrderIsSellStop() || OrderIsSellLimit();}
bool 		OrderIsBuyStop(){       	return OrderType() == ORDER_TYPE_BUY_STOP;}
bool 		OrderIsBuyLimit(){      	return OrderType() == ORDER_TYPE_BUY_LIMIT;}
bool 		OrderIsSellStop(){       	return OrderType() == ORDER_TYPE_SELL_STOP;}
bool 		OrderIsSellLimit(){			return OrderType() == ORDER_TYPE_SELL_LIMIT;}

int      OrderStopLevel(){       	return SymbolStopLevel(OrderSymbol());}
double   OrderStopLevelValue(){  	return SymbolStopLevelValue(OrderSymbol());}

double   NormalizeDoubleOrder(double value){		return NormalizeDouble(value,OrderDigits());}
int 		OrderDigits(){				return SymbolDigits(OrderSymbol());}

//+------------------------------------------------------------------+

bool PositionSelectByIndex(int index){		return PositionGetTicket(index) > 0;}
bool PositionSelectByPos(int index){		return PositionSelectByIndex(index);}

long		PositionTicket(){          	return PositionGetInteger(POSITION_TICKET);}
ENUM_POSITION_TYPE  	PositionType(){	return (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);}
ENUM_POSITION_REASON PositionReason(){	return (ENUM_POSITION_REASON)PositionGetInteger(POSITION_REASON);}
long     PositionMagicNumber(){     	return PositionGetInteger(POSITION_MAGIC);}
double   PositionOpenPrice(){       	return PositionGetDouble(POSITION_PRICE_OPEN);}
double   PositionCurrentPrice(){      	return PositionGetDouble(POSITION_PRICE_CURRENT);}
datetime	PositionTime(){					return (datetime)PositionGetInteger(POSITION_TIME);}
datetime	PositionOpenTime(){				return PositionTime();}
datetime	PositionTimeUpdate(){			return (datetime)PositionGetInteger(POSITION_TIME_UPDATE);}
long		PositionTimeMSC(){				return PositionGetInteger(POSITION_TIME_MSC);}
long		PositionTimeUpdateMSC(){		return PositionGetInteger(POSITION_TIME_UPDATE_MSC);}
double   PositionVolume(){          	return PositionGetDouble(POSITION_VOLUME);}
double   PositionLots(){           		return PositionVolume();}
double   PositionTakeProfit(){      	return PositionGetDouble(POSITION_TP);}
double   PositionStopLoss(){        	return PositionGetDouble(POSITION_SL);}
double   PositionSwap(){            	return PositionGetDouble(POSITION_SWAP);}
double   PositionCommission(){      	return PositionGetDouble(POSITION_COMMISSION);}
double 	PositionProfit(){					return PositionGetDouble(POSITION_PROFIT);}
string   PositionComment(){         	return PositionGetString(POSITION_COMMENT);}
string   PositionSymbol(){          	return PositionGetString(POSITION_SYMBOL);}

bool PositionIsSymbol(string symbol="ALL"){
   if(StringIsEqual(symbol,"ALL")) return true;
   return StringIsEqual(PositionSymbol(),Symbol(symbol));
}
bool 		PositionIsSymbolExact(string symbol){	return StringIsEqual(PositionSymbol(),symbol);}
bool 		PositionIsSymbolCurrent(){					return StringIsEqual(PositionSymbol(),Symbol());}

double   PositionAsk(){             return NormalizeDoublePosition(Ask(PositionSymbol()));}
double   PositionBid(){             return NormalizeDoublePosition(Bid(PositionSymbol()));}

double   PositionPoint(){      		return SymbolPoint(PositionSymbol());}
int      PositionDigits(){          return SymbolDigits(PositionSymbol());}
int      PositionStopLevel(){       return SymbolStopLevel(PositionSymbol());}
double   PositionStopLevelValue(){  return SymbolStopLevelValue(PositionSymbol());}

bool 		PositionIsType(ENUM_POSITION_TYPE type){	return PositionType() == type;}

bool 		PositionIsBuy(){   			return PositionType() == POSITION_TYPE_BUY;}
bool 		PositionIsSell(){  			return PositionType() == POSITION_TYPE_SELL;}

double 	PositionProfitFull(){		return PositionProfit()+PositionSwap()+PositionCommission();}

int PositionProfitPoint(){
   double pointValue = PositionPoint();
	if(pointValue > 0){
	   if(PositionIsBuy())  return (int)(MathRound((PositionCurrentPrice()-PositionOpenPrice())/pointValue));
	   if(PositionIsSell()) return (int)(MathRound((PositionOpenPrice()-PositionCurrentPrice())/pointValue));
	}
   return 0;
}

double   NormalizeDoublePosition(double value){	return NormalizeDouble(value,PositionDigits());}

//+------------------------------------------------------------------+
//| Funzioni customizzate per gli ordini nello storico e gli affari  |
//+------------------------------------------------------------------+

ulong ticketOrderToWork = 0;
bool HistoryOrderSelectByPos(int index){	ticketOrderToWork = HistoryOrderGetTicket(index);	return ticketOrderToWork > 0;}
bool HistoryOrderSelectByIndex(int index){return HistoryOrderSelectByPos(index);}

long     HistoryOrderTicket(ulong ticket){   		return HistoryOrderGetInteger(ticket,ORDER_TICKET);}
ENUM_ORDER_TYPE	HistoryOrderType(ulong ticket){  return (ENUM_ORDER_TYPE)HistoryOrderGetInteger(ticket,ORDER_TYPE);}
ENUM_ORDER_STATE	HistoryOrderState(ulong ticket){	return (ENUM_ORDER_STATE)HistoryOrderGetInteger(ticket,ORDER_STATE);}
datetime HistoryOrderExpiration(ulong ticket){ 		return (datetime)HistoryOrderGetInteger(ticket,ORDER_TIME_EXPIRATION);}
datetime HistoryOrderTimeExpiration(ulong ticket){ return HistoryOrderExpiration(ticket);}
datetime	HistoryOrderTimeSetup(ulong ticket){   	return (datetime)HistoryOrderGetInteger(ticket,ORDER_TIME_SETUP);}
datetime HistoryOrderTimeDone(ulong ticket){     	return (datetime)HistoryOrderGetInteger(ticket,ORDER_TIME_DONE);}
long		HistoryOrderTimeSetupMSC(ulong ticket){   return HistoryOrderGetInteger(ticket,ORDER_TIME_SETUP_MSC);}
long		HistoryOrderTimeDoneMSC(ulong ticket){		return HistoryOrderGetInteger(ticket,ORDER_TIME_DONE_MSC);}
ENUM_ORDER_TYPE_FILLING HistoryOrderTypeFilling(ulong ticket){	return (ENUM_ORDER_TYPE_FILLING)HistoryOrderGetInteger(ticket,ORDER_TYPE_FILLING);}
ENUM_ORDER_TYPE_TIME		HistoryOrderTypeTime(ulong ticket){		return (ENUM_ORDER_TYPE_TIME)HistoryOrderGetInteger(ticket,ORDER_TYPE_TIME);}
long     HistoryOrderMagic(ulong ticket){     		return (int)HistoryOrderGetInteger(ticket,ORDER_MAGIC);}
ENUM_ORDER_REASON 		HistoryOrderReason(ulong ticket){  		return (ENUM_ORDER_REASON)HistoryOrderGetInteger(ticket,ORDER_REASON);}
long     HistoryOrderPositionID(ulong ticket){ 		return HistoryOrderGetInteger(ticket,ORDER_POSITION_ID);}
long     HistoryOrderPositionByID(ulong ticket){ 	return HistoryOrderGetInteger(ticket,ORDER_POSITION_BY_ID);}
double   HistoryOrderOpenPrice(ulong ticket){ 	  	return HistoryOrderGetDouble(ticket,ORDER_PRICE_OPEN);}
double   HistoryOrderPriceOpen(ulong ticket){ 	  	return HistoryOrderOpenPrice(ticket);}
double   HistoryOrderPriceCurrent(ulong ticket){	return HistoryOrderGetDouble(ticket,ORDER_PRICE_CURRENT);}
double   HistoryOrderPriceStopLimit(ulong ticket){	return HistoryOrderGetDouble(ticket,ORDER_PRICE_STOPLIMIT);}
double   HistoryOrderStopLoss(ulong ticket){    	return HistoryOrderGetDouble(ticket,ORDER_SL);}
double   HistoryOrderTakeProfit(ulong ticket){  	return HistoryOrderGetDouble(ticket,ORDER_TP);}
double   HistoryOrderVolumeCurrent(ulong ticket){  return HistoryOrderGetDouble(ticket,ORDER_VOLUME_CURRENT);}
double   HistoryOrderVolume(ulong ticket){  			return HistoryOrderGetDouble(ticket,ORDER_VOLUME_INITIAL);}
double   HistoryOrderVolumeInitial(ulong ticket){  return HistoryOrderGetDouble(ticket,ORDER_VOLUME_INITIAL);}
double   HistoryOrderLots(ulong ticket){  			return HistoryOrderVolumeInitial(ticket);}
string 	HistoryOrderSymbol(ulong ticket){			return HistoryOrderGetString(ticket,ORDER_SYMBOL);}
string 	HistoryOrderComment(ulong ticket){			return HistoryOrderGetString(ticket,ORDER_COMMENT);}
string 	HistoryOrderExternalID(ulong ticket){		return HistoryOrderGetString(ticket,ORDER_EXTERNAL_ID);}

long     HistoryOrderTicket(){   		return HistoryOrderTicket(ticketOrderToWork);}
ENUM_ORDER_TYPE	HistoryOrderType(){ 	return HistoryOrderType(ticketOrderToWork);}
ENUM_ORDER_STATE	HistoryOrderState(){	return HistoryOrderState(ticketOrderToWork);}
datetime HistoryOrderTimeExpiration(){ return HistoryOrderTimeExpiration(ticketOrderToWork);}
datetime	HistoryOrderTimeSetup(){   	return HistoryOrderTimeSetup(ticketOrderToWork);}
datetime HistoryOrderTimeDone(){     	return HistoryOrderTimeDone(ticketOrderToWork);}
long		HistoryOrderTimeSetupMSC(){   return HistoryOrderTimeSetupMSC(ticketOrderToWork);}
long		HistoryOrderTimeDoneMSC(){		return HistoryOrderTimeDoneMSC(ticketOrderToWork);}
ENUM_ORDER_TYPE_FILLING HistoryOrderTypeFilling(){	return HistoryOrderTypeFilling(ticketOrderToWork);}
ENUM_ORDER_TYPE_TIME		HistoryOrderTypeTime(){		return HistoryOrderTypeTime(ticketOrderToWork);}
long     HistoryOrderMagic(){     		return HistoryOrderMagic(ticketOrderToWork);}
ENUM_ORDER_REASON 		HistoryOrderReason(){   	return HistoryOrderReason(ticketOrderToWork);}
long     HistoryOrderPositionID(){ 		return HistoryOrderPositionID(ticketOrderToWork);}
long     HistoryOrderPositionByID(){ 	return HistoryOrderPositionByID(ticketOrderToWork);}
double   HistoryOrderOpenPrice(){ 	  	return HistoryOrderOpenPrice(ticketOrderToWork);}
double   HistoryOrderPriceOpen(){ 	  	return HistoryOrderOpenPrice();}
double   HistoryOrderPriceCurrent(){	return HistoryOrderPriceCurrent(ticketOrderToWork);}
double   HistoryOrderPriceStopLimit(){	return HistoryOrderPriceStopLimit(ticketOrderToWork);}
double   HistoryOrderStopLoss(){    	return HistoryOrderStopLoss(ticketOrderToWork);}
double   HistoryOrderTakeProfit(){  	return HistoryOrderTakeProfit(ticketOrderToWork);}
double   HistoryOrderVolumeCurrent(){  return HistoryOrderVolumeCurrent(ticketOrderToWork);}
double   HistoryOrderVolume(){  			return HistoryOrderVolume(ticketOrderToWork);}
double   HistoryOrderVolumeInitial(){  return HistoryOrderVolumeInitial(ticketOrderToWork);}
double   HistoryOrderLots(){  			return HistoryOrderVolumeInitial();}
string 	HistoryOrderSymbol(){			return HistoryOrderSymbol(ticketOrderToWork);}
string 	HistoryOrderComment(){			return HistoryOrderComment(ticketOrderToWork);}
string 	HistoryOrderExternalID(){		return HistoryOrderExternalID(ticketOrderToWork);}


int      HistoryOrderDigits(){          	return SymbolDigits(HistoryOrderSymbol());}
int      HistoryOrderDigits(ulong ticket){return SymbolDigits(HistoryOrderSymbol(ticket));}
double 	HistoryOrderPoint(){					return SymbolPoint(HistoryOrderSymbol());}
double 	HistoryOrderPoint(ulong ticket){	return SymbolPoint(HistoryOrderSymbol(ticket));}

//+------------------------------------------------------------------+

ulong ticketDealToWork = 0;
bool HistoryDealSelectByPos(int index){	ticketDealToWork = HistoryDealGetTicket(index);	return ticketDealToWork > 0;}
bool HistoryDealSelectByIndex(int index){	return HistoryDealSelectByPos(index);}

long     HistoryDealTicket(ulong ticket){   		return HistoryDealGetInteger(ticket,DEAL_TICKET);}
long     HistoryDealOrder(ulong ticket){   		return HistoryDealGetInteger(ticket,DEAL_ORDER);}
ENUM_DEAL_TYPE  	HistoryDealType(ulong ticket){       	return (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket,DEAL_TYPE);}
ENUM_DEAL_TYPE    HistoryDealTypeOrigin(ulong ticket){ 	if(HistoryDealType(ticket) == DEAL_TYPE_BUY) return DEAL_TYPE_SELL; if(HistoryDealType(ticket) == DEAL_TYPE_SELL) return DEAL_TYPE_BUY; return 0;}
ENUM_DEAL_ENTRY	HistoryDealEntry(ulong ticket){     	return (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket,DEAL_ENTRY);}
ENUM_DEAL_REASON	HistoryDealReason(ulong ticket){       return (ENUM_DEAL_REASON)HistoryDealGetInteger(ticket,DEAL_REASON);}
long     HistoryDealPositionID(ulong ticket){ 	return HistoryDealGetInteger(ticket,DEAL_POSITION_ID);}
long     HistoryDealMagic(ulong ticket){     	return HistoryDealGetInteger(ticket,DEAL_MAGIC);}
long     HistoryDealMagicID(ulong ticket){     	return HistoryOrderMagic(HistoryDealPositionID(ticket));}
datetime HistoryDealTime(ulong ticket){     		return (datetime)HistoryDealGetInteger(ticket,DEAL_TIME);}
long 		HistoryDealTimeMSC(ulong ticket){    	return HistoryDealGetInteger(ticket,DEAL_TIME_MSC);}
datetime HistoryDealTimeClose(ulong ticket){  	return HistoryDealTime(ticket);}
long 		HistoryDealTimeCloseMSC(ulong ticket){	return HistoryDealTimeCloseMSC(ticket);}
datetime HistoryDealTimeOpen(ulong ticket){   	return HistoryOrderTimeDone(HistoryDealPositionID(ticket));}
long 		HistoryDealTimeOpenMSC(ulong ticket){  return HistoryOrderTimeDoneMSC(HistoryDealPositionID(ticket));}
double   HistoryDealPrice(ulong ticket){     	return HistoryDealGetDouble(ticket,DEAL_PRICE);}
double   HistoryDealPriceClose(ulong ticket){ 	return HistoryDealPrice(ticket);}
double   HistoryDealPriceOpen(ulong ticket){   	return HistoryOrderPriceCurrent(HistoryDealPositionID(ticket));}
double   HistoryDealVolume(ulong ticket){     	return HistoryDealGetDouble(ticket,DEAL_VOLUME);}
double   HistoryDealLots(ulong ticket){     		return HistoryDealVolume(ticket);}
double   HistoryDealCommission(ulong ticket){   return HistoryDealGetDouble(ticket,DEAL_COMMISSION);}
double   HistoryDealCommissionX2(ulong ticket){ return HistoryDealCommission(ticket)*2.0;}
double   HistoryDealSwap(ulong ticket){     		return HistoryDealGetDouble(ticket,DEAL_SWAP);}
double   HistoryDealProfit(ulong ticket){     	return HistoryDealGetDouble(ticket,DEAL_PROFIT);}
double   HistoryDealFee(ulong ticket){     		return HistoryDealGetDouble(ticket,DEAL_FEE);}
double   HistoryDealProfitFull(ulong ticket){   return HistoryDealProfit(ticket)+HistoryDealSwap(ticket)+HistoryDealCommission(ticket)+HistoryDealFee(ticket);}
double   HistoryDealProfitFull2(ulong ticket){  return HistoryDealProfit(ticket)+HistoryDealSwap(ticket)+HistoryDealCommissionX2(ticket)+HistoryDealFee(ticket);}
string 	HistoryDealSymbol(ulong ticket){			return HistoryDealGetString(ticket,DEAL_SYMBOL);}
string 	HistoryDealComment(ulong ticket){		return HistoryDealGetString(ticket,DEAL_COMMENT);}
string 	HistoryDealExternalID(ulong ticket){	return HistoryDealGetString(ticket,DEAL_EXTERNAL_ID);}

long     HistoryDealTicket(){   						return HistoryDealTicket(ticketDealToWork);}
long     HistoryDealOrder(){   						return HistoryDealOrder(ticketDealToWork);}
ENUM_DEAL_TYPE    HistoryDealType(){    			return HistoryDealType(ticketDealToWork);}
ENUM_DEAL_TYPE    HistoryDealTypeOrigin(){    	return HistoryDealTypeOrigin(ticketDealToWork);}
ENUM_DEAL_ENTRY 	HistoryDealEntry(){				return HistoryDealEntry(ticketDealToWork);}
ENUM_DEAL_REASON	HistoryDealReason(){       	return HistoryDealReason(ticketDealToWork);}
string 	HistoryDealEntryString(){					return HistoryDealEntryString(ticketDealToWork);}
string 	HistoryDealTypeString(){					return HistoryDealTypeString(ticketDealToWork);}
string   HistoryDealReasonString(){       		return HistoryDealReasonString(ticketDealToWork);}
long     HistoryDealPositionID(){ 					return HistoryDealPositionID(ticketDealToWork);}
long     HistoryDealMagic(){     					return HistoryDealMagic(ticketDealToWork);}
long     HistoryDealMagicID(){     					return HistoryDealMagicID(ticketDealToWork);}
datetime HistoryDealTime(){     						return HistoryDealTime(ticketDealToWork);}
long 		HistoryDealTimeMSC(){    					return HistoryDealTimeMSC(ticketDealToWork);}
datetime HistoryDealTimeClose(){     				return HistoryDealTime();}
long 		HistoryDealTimeCloseMSC(){    			return HistoryDealTimeMSC();}
datetime HistoryDealTimeOpen(){     				return HistoryDealTimeOpen(ticketDealToWork);}
long 		HistoryDealTimeOpenMSC(){    				return HistoryDealTimeOpenMSC(ticketDealToWork);}
double   HistoryDealPrice(){     					return HistoryDealPrice(ticketDealToWork);}
double   HistoryDealPriceClose(){     				return HistoryDealPrice();}
double   HistoryDealPriceOpen(){     				return HistoryDealPriceOpen(ticketDealToWork);}
double   HistoryDealVolume(){     					return HistoryDealVolume(ticketDealToWork);}
double   HistoryDealLots(){     						return HistoryDealVolume();}
double   HistoryDealCommission(){   				return HistoryDealCommission(ticketDealToWork);}
double   HistoryDealCommissionX2(){   				return HistoryDealCommissionX2(ticketDealToWork);}
double   HistoryDealSwap(){     						return HistoryDealSwap(ticketDealToWork);}
double   HistoryDealProfit(){     					return HistoryDealProfit(ticketDealToWork);}
double   HistoryDealFee(){     						return HistoryDealFee(ticketDealToWork);}
double   HistoryDealProfitFull(){   				return HistoryDealProfitFull(ticketDealToWork);}
double   HistoryDealProfitFull2(){   				return HistoryDealProfitFull2(ticketDealToWork);}
string 	HistoryDealSymbol(){							return HistoryDealSymbol(ticketDealToWork);}
string 	HistoryDealComment(){						return HistoryDealComment(ticketDealToWork);}
string 	HistoryDealExternalID(){					return HistoryDealExternalID(ticketDealToWork);}


//+------------------------------------------------------------------+
string 	HistoryDealTypeString(ulong ticket){
	switch(HistoryDealType(ticket)){
	   case DEAL_TYPE_BUY: 								return "BUY";               				// 0
	   case DEAL_TYPE_SELL: 							return "SELL";             				// 1
	   case DEAL_TYPE_BALANCE: 						return "BALANCE";       					// 2
	   case DEAL_TYPE_CREDIT: 							return "CREDIT";         					// 3
	   case DEAL_TYPE_CHARGE: 							return "CHARGE";         					// 4
	   case DEAL_TYPE_CORRECTION: 					return "CORRECTION";         				// 5
	   case DEAL_TYPE_BONUS: 							return "BONUS";         					// 6
	   case DEAL_TYPE_COMMISSION: 					return "COMMISSION";         				// 7
	   case DEAL_TYPE_COMMISSION_DAILY: 			return "DAILY COMMISSION";         		// 8
	   case DEAL_TYPE_COMMISSION_MONTHLY: 			return "MONTHLY COMMISSION";         	// 9
	   case DEAL_TYPE_COMMISSION_AGENT_DAILY: 	return "DAILY AGENT COMMISSION";     	// 10
	   case DEAL_TYPE_COMMISSION_AGENT_MONTHLY: 	return "MONTHLY AGENT COMMISSION";  	// 11
	   case DEAL_TYPE_INTEREST: 						return "INTEREST RATE";         			// 12
	   case DEAL_TYPE_BUY_CANCELED: 					return "CANCELED BUY DEAL";         	// 13
	   case DEAL_TYPE_SELL_CANCELED: 				return "CANCELED SELL DEAL";         	// 14
	   case DEAL_DIVIDEND: 								return "DIVIDEND OPERATIONS";         	// 15
	   case DEAL_DIVIDEND_FRANKED: 					return "FRANKED DIVIDEND OPERATIONS";	// 16
	   case DEAL_TAX: 									return "TAX CHARGES";         			// 17
	}
   return "";
}

string 	HistoryDealEntryString(ulong ticket){
	switch(HistoryDealEntry(ticket)){
	   case DEAL_ENTRY_IN:								return "Entry in";               					// 0
	   case DEAL_ENTRY_OUT:					 			return "Entry out";             						// 1
	   case DEAL_ENTRY_INOUT: 							return "Reverse";       								// 2
	   case DEAL_ENTRY_OUT_BY: 						return "Close a position by an opposite one";	// 3
	}
   return "";
}

string 	HistoryDealReasonString(ulong ticket){
	switch(HistoryDealReason(ticket)){
	   case DEAL_REASON_CLIENT: 						return "Deal executed from a Desktop Terminal";  				// 0
	   case DEAL_REASON_MOBILE: 						return "Deal executed from a Mobile Application";				// 1
	   case DEAL_REASON_WEB: 							return "Deal executed from a Web Platform";    					// 2
	   case DEAL_REASON_EXPERT: 						return "Deal executed from an EA";									// 3
	   case DEAL_REASON_SL: 							return "Deal executed from a Stop Loss";							// 4
	   case DEAL_REASON_TP: 							return "Deal executed from a Take Profit";						// 5
	   case DEAL_REASON_SO: 							return "Deal executed from a StopOut Event";						// 6
	   case DEAL_REASON_ROLLOVER: 					return "Deal executed due to a Rollover";							// 7
	   case DEAL_REASON_VMARGIN: 						return "Deal executed after changing the Variation Margin";	// 8
	   case DEAL_REASON_SPLIT: 						return "Deal executed after the Split";							// 9
	}
   return "";
}

string 	HistoryOrderReasonString(ulong ticket){
	switch(HistoryOrderReason(ticket)){
	   case ORDER_REASON_CLIENT: 						return "Order executed from a Desktop Terminal";  				// 0
	   case ORDER_REASON_MOBILE: 						return "Order executed from a Mobile Application";				// 1
	   case ORDER_REASON_WEB: 							return "Order executed from a Web Platform";    				// 2
	   case ORDER_REASON_EXPERT: 						return "Order executed from an EA";									// 3
	   case ORDER_REASON_SL: 							return "Order executed from a Stop Loss";							// 4
	   case ORDER_REASON_TP: 							return "Order executed from a Take Profit";						// 5
	   case ORDER_REASON_SO: 							return "Order executed from a StopOut Event";					// 6
	}
   return "";
}

int      HistoryDealDigits(){          	return SymbolDigits(HistoryDealSymbol());}
int      HistoryDealDigits(ulong ticket){	return SymbolDigits(HistoryDealSymbol(ticket));}
double 	HistoryDealPoint(){					return SymbolPoint(HistoryDealSymbol());}
double 	HistoryDealPoint(ulong ticket){	return SymbolPoint(HistoryDealSymbol(ticket));}

int HistoryDealProfitPoint(){					return HistoryDealProfitPoint(ticketDealToWork);}
int HistoryDealProfitPoint(ulong ticket){
   double pointValue = HistoryDealPoint(ticket);
   if(pointValue > 0){
   	ENUM_DEAL_TYPE type = HistoryDealTypeOrigin(ticket);
	   if(type == DEAL_TYPE_BUY)  return (int)(MathRound((HistoryDealPriceClose(ticket)-HistoryDealPriceOpen(ticket))/pointValue));
	   if(type == DEAL_TYPE_SELL) return (int)(MathRound((HistoryDealPriceOpen(ticket)-HistoryDealPriceClose(ticket))/pointValue));
	}
   return 0;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 15	MQL5 	                                                |
//+------------------------------------------------------------------+

ulong SendTradeBuy(string symbol,double volume,int deviation,double sl,double tp,string comment,ulong magic,bool verbose=true){
	return SendTrade(symbol,ORDER_TYPE_BUY,volume,Ask(symbol),0,deviation,sl,tp,comment,magic,verbose);
}

ulong SendTradeSell(string symbol,double volume,int deviation,double sl,double tp,string comment,ulong magic,bool verbose=true){
	return SendTrade(symbol,ORDER_TYPE_SELL,volume,Bid(symbol),0,deviation,sl,tp,comment,magic,verbose);
}

//+------------------------------------------------------------------+
//| Funzioni customizzate per la chiusura delle posizioni				|
//+------------------------------------------------------------------+
bool PositionClose(ulong ticket,double volume,int deviation=5,bool verbose=true){
	if(PositionSelectByTicket(ticket))	return PositionClose(volume,deviation,verbose);
	return false;
}

bool PositionClose(int deviation=5,bool verbose=true){
   return PositionClose(PositionVolume(),deviation,verbose);
}
/*
bool PositionClose(double volume,int deviation=5){
   MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
   MqlTradeResult    positionResult;	ZeroMemory(positionResult);
   
   positionRequest.action =         TRADE_ACTION_DEAL;
   positionRequest.type_filling =	ORDER_FILLING_IOC;
   positionRequest.position =       PositionTicket();
   positionRequest.deviation=       deviation;
   positionRequest.symbol   =       PositionSymbol();
   positionRequest.comment =			PositionComment();
   positionRequest.magic    =       PositionMagicNumber();
   
   if(volume <= 0 || volume > PositionVolume()) volume = PositionVolume();	// Una mia scelta personale, dove se il volume in ingresso è <= 0 (che è impossibile) si considera l'intero volume del trade
   positionRequest.volume   =       NormalizeDoubleLots(volume);
   
   if(PositionIsBuy()){
      positionRequest.price=NormalizeDoublePosition(PositionBid());
      positionRequest.type =ORDER_TYPE_SELL;
   }
   else{
      positionRequest.price=NormalizeDoublePosition(PositionAsk());
      positionRequest.type =ORDER_TYPE_BUY;
   }
   
   if(!OrderSend(positionRequest,positionResult)) return printError("Errore chiusura posizione, #"+IntegerToString(positionResult.retcode));
   return true;
}
*/
//+------------------------------------------------------------------+
//| Funzione customizzata per la chiusura in hedging						|
//+------------------------------------------------------------------+
/*
bool PositionCloseBy(ulong ticket,ulong ticketOpposto,int deviation=5){
	MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
   MqlTradeResult    positionResult;	ZeroMemory(positionResult);
   
   if(!PositionSelectByTicket(ticket)) return printError("Errore nel riconoscimento ticket primario");
   string commentOriginal =	PositionComment();
   ulong magicOriginal = 		PositionMagicNumber();
   
   if(!PositionSelectByTicket(ticketOpposto)) return printError("Errore nel riconoscimento ticket secondario");
   
   
   positionRequest.action =         TRADE_ACTION_CLOSE_BY;
   positionRequest.position =       ticket;
   positionRequest.position_by =    ticketOpposto;
   positionRequest.comment =			commentOriginal;
   positionRequest.magic    =       magicOriginal;
   
   if(!OrderSend(positionRequest,positionResult)) return printError("Errore nella chiusura del trade in hedging");
   return true;
}
*/

//+------------------------------------------------------------------+
//| Funzioni customizzate per la cancellazione ordine 			      |
//+------------------------------------------------------------------+
bool OrderDelete(ulong ticket,bool verbose=true){
	if(OrderSelect(ticket))	return OrderDelete(verbose);
	return false;
}

/*
// Questa funzione suppone che sia stato appena fatto un OrderSelect
bool OrderDelete(){
   MqlTradeRequest	orderRequest;	ZeroMemory(orderRequest);
   MqlTradeResult    orderResult;	ZeroMemory(orderResult);
   
   orderRequest.order =    OrderTicket();
   orderRequest.action =   TRADE_ACTION_REMOVE;
   
   if(!OrderSend(orderRequest,orderResult)) return printError("Errore cancellazione ordine pendente, #"+IntegerToString(orderResult.retcode));
   return true;
}
*/
//+------------------------------------------------------------------+
//| Funzioni customizzate per la chiusura parziale					      |
//+------------------------------------------------------------------+
// Chiusura dei in percentuale tra [0 e 100]%
bool PositionClosePartial(ulong ticket_,double percentualeChiusura,bool verbose=true){
   if(PositionSelectByTicket(ticket_)){
      return PositionClosePartial(percentualeChiusura,verbose);
   }
   return false;
}

bool PositionClosePartial(double percentualeChiusura,bool verbose=true){
   return PositionClose(PositionLots()*percentualeChiusura/100.0,verbose);
}

//+------------------------------------------------------------------+
//| Funzioni customizzate per la modifica delle posizioni            |
//+------------------------------------------------------------------+
bool PositionModify(ulong ticket,double stoploss,double takeprofit,bool verbose=true){
   if(PositionSelectByTicket(ticket))	return PositionModify(stoploss,takeprofit,verbose);
   return false;
}

/*
bool PositionModify(double stoploss,double takeprofit){

	// Da implementare controlli ulteriori
	
	
	MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
	MqlTradeResult    positionResult;	ZeroMemory(positionResult);
	
	positionRequest.action  =  TRADE_ACTION_SLTP;
	positionRequest.position=  PositionTicket();
	positionRequest.symbol  =  PositionSymbol();
	positionRequest.sl      =  NormalizeDoublePosition(stoploss);
	positionRequest.tp      =  NormalizeDoublePosition(takeprofit);
	
	if(!OrderSend(positionRequest,positionResult)) printError("Errore nel modificare la posizione, #"+IntegerToString(positionResult.retcode));
	return true;
}
*/
//+------------------------------------------------------------------+
//| Funzioni customizzate per la modifica degli ordini pendenti      |
//+------------------------------------------------------------------+
bool OrderModify(ulong ticket,double price,double stoploss,double takeprofit,double slimit,datetime expiration,bool verbose=true){
   if(OrderSelect(ticket))	return OrderModify(price,stoploss,takeprofit,slimit,expiration,verbose);
   return false;
}

/*
bool OrderModify(double price,double stoploss,double takeprofit,datetime expiration){

	// Da implementare controlli ulteriori
	
	
	MqlTradeRequest   orderRequest;	ZeroMemory(orderRequest);
	MqlTradeResult    orderResult;	ZeroMemory(orderResult);
	
	orderRequest.action = 	TRADE_ACTION_MODIFY;
   orderRequest.order =		OrderTicket();
   orderRequest.symbol = 	OrderSymbol();
   orderRequest.price =		NormalizeDoubleOrder(price);
   orderRequest.sl =			NormalizeDoubleOrder(stoploss);
   orderRequest.tp =			NormalizeDoubleOrder(takeprofit);
   
   if(expiration != OrderExpiration()){
   	if(expiration == 0){
		   orderRequest.type_time = 	ORDER_TIME_GTC;
		   orderRequest.expiration = 	0;
	   }
	   
	   if(expiration > 0){
	   	orderRequest.type_time =	ORDER_TIME_SPECIFIED;
	   	orderRequest.expiration =	expiration;
		}
	} 
   
   // Variante Johnny lo spaccone!
   return !OrderSend(orderRequest,orderResult) ? printError("Errore nella modifica dell'ordine pendente, #"+IntegerToString(orderResult.retcode)) : true;
}
*/


//+------------------------------------------------------------------+
//| LEZIONE  TOP 15.1 MQL5                                           |
//+------------------------------------------------------------------+
/*
void OCO_Order(ulong ticketT,ulong orderC){
   if(PositionSelectByTicket(ticketT)){
      if(!OrderDelete(orderC)) printError("Errore cancellazione ordine OCO");
   }
}
*/

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 16 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Funzioni customizzate 1 (utili per la scansione nei cicli for)   |
//+------------------------------------------------------------------+
bool PositionIsMagicNumber(ulong magic,bool magicExact=false){
   if(magicExact) return PositionMagicNumber() == magic;
   if(magic > 0) return PositionMagicNumber() == magic;
   return true;
}

bool OrderIsMagicNumber(ulong magic,bool magicExact=false){
   if(magicExact) return OrderMagicNumber() == magic;
   if(magic > 0) return OrderMagicNumber() == magic;
   return true;
}

//---
bool HistoryDealIsMagicNumber(ulong ticket,ulong magic,bool magicExact=false){
	if(magicExact) return HistoryDealMagicID(ticket) == magic;
   if(magic > 0)	return HistoryDealMagicID(ticket) == magic;
   return true;
}
bool HistoryDealIsMagicNumber(ulong magic,bool magicExact=false){
	return HistoryDealIsMagicNumber(ticketDealToWork,magic,magicExact);
}

bool HistoryDealIsSymbol(ulong ticket,string symbol="ALL"){
   if(StringIsEqual(symbol,"ALL")) return true;
   return StringIsEqual(HistoryDealSymbol(ticket),Symbol(symbol));
}
bool HistoryDealIsSymbol(string symbol="ALL"){
   return HistoryDealIsSymbol(ticketDealToWork,symbol);
}

//---
bool HistoryOrderIsMagicNumber(ulong ticket,ulong magic,bool magicExact=false){
	if(magicExact) return HistoryOrderMagic(ticket) == magic;
   if(magic > 0)	return HistoryOrderMagic(ticket) == magic;
   return true;
}
bool HistoryOrderIsMagicNumber(ulong magic,bool magicExact=false){
	return HistoryOrderIsMagicNumber(ticketOrderToWork,magic,magicExact);
}

bool HistoryOrderIsSymbol(ulong ticket,string symbol="ALL"){
   if(StringIsEqual(symbol,"ALL")) return true;
   return StringIsEqual(HistoryOrderSymbol(ticket),Symbol(symbol));
}
bool HistoryOrderIsSymbol(string symbol="ALL"){
   return HistoryOrderIsSymbol(ticketOrderToWork,symbol);
}

//---


//+------------------------------------------------------------------+
//| Funzioni customizzate 1 (ricavo valori conoscendo solo il ticket)|
//+------------------------------------------------------------------+

bool 		OrderSelectByTicket(ulong ticket){	return OrderSelect(ticket);}
double   OrderLots(ulong ticket){       return OrderSelectByTicket(ticket) ? OrderLots()        : 0;}
double   OrderTakeProfit(ulong ticket){ return OrderSelectByTicket(ticket) ? OrderTakeProfit()  : 0;}
double   OrderStopLoss(ulong ticket){   return OrderSelectByTicket(ticket) ? OrderStopLoss()    : 0;}
double   OrderOpenPrice(ulong ticket){  return OrderSelectByTicket(ticket) ? OrderOpenPrice()   : 0;}
ENUM_ORDER_TYPE OrderType(ulong ticket){
	if(OrderSelectByTicket(ticket)) return OrderType();
	return -1;
}
ulong    OrderMagicNumber(ulong ticket){return OrderSelectByTicket(ticket) ? OrderMagicNumber() : 0;}
string   OrderComment(ulong ticket){    return OrderSelectByTicket(ticket) ? OrderComment()     : "";}
datetime OrderTimeDone(ulong ticket){   return OrderSelectByTicket(ticket) ? OrderTimeDone()    : 0;}
datetime OrderTimeSetup(ulong ticket){   return OrderSelectByTicket(ticket) ? OrderTimeSetup()    : 0;}

double   PositionProfitFull(ulong ticket){		return PositionSelectByTicket(ticket) ? PositionProfitFull()  : 0;}
double   PositionLots(ulong ticket){       		return PositionSelectByTicket(ticket) ? PositionLots()        : 0;}
double   PositionTakeProfit(ulong ticket){	 	return PositionSelectByTicket(ticket) ? PositionTakeProfit()  : 0;}
double   PositionStopLoss(ulong ticket){   		return PositionSelectByTicket(ticket) ? PositionStopLoss()    : 0;}
double   PositionOpenPrice(ulong ticket){  		return PositionSelectByTicket(ticket) ? PositionOpenPrice()   : 0;}
ENUM_POSITION_TYPE PositionType(ulong ticket){
	if(PositionSelectByTicket(ticket)) return PositionType();
	return -1;
}
ulong    PositionMagicNumber(ulong ticket){		return PositionSelectByTicket(ticket) ? PositionMagicNumber() : 0;}
string   PositionComment(ulong ticket){    		return PositionSelectByTicket(ticket) ? PositionComment()     : "";}
datetime PositionOpenTime(ulong ticket){   		return PositionSelectByTicket(ticket) ? PositionOpenTime()    : 0;}



//+------------------------------------------------------------------+
//| Funzioni customizzate 2 (calcolo degli ordini totali di un EA)   |
//+------------------------------------------------------------------+
int PositionsTotalBuy(string symbol="ALL",ulong magic=0){
   int numberPositions = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()) numberPositions++;
   }
   return numberPositions;
}

int PositionsTotalSell(string symbol="ALL",ulong magic=0){
   int numberPositions = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()) numberPositions++;
   }
   return numberPositions;
}

int PositionsTotalAll(string symbol="ALL",ulong magic=0){
   return PositionsTotalBuy(symbol,magic) + PositionsTotalSell(symbol,magic);
}

//---
int OrdersTotalBuy(string symbol="ALL",ulong magic=0){
   int numberOrders = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsBuyPending()) numberOrders++;
   }
   return numberOrders;
}

int OrdersTotalSell(string symbol="ALL",ulong magic=0){
   int numberOrders = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsSellPending()) numberOrders++;
   }
   return numberOrders;
}

int OrdersTotalAll(string symbol="ALL",ulong magic=0){
   return OrdersTotalBuy(symbol,magic) + OrdersTotalSell(symbol,magic);
}

//---
int TradesTotalAll(string symbol="ALL",ulong magic=0){
	return PositionsTotalAll(symbol,magic) + OrdersTotalAll(symbol,magic);
}


//+------------------------------------------------------------------+
//| Funzioni customizzate 2 (calcolo dei lotti generati da un EA)    |
//+------------------------------------------------------------------+
double PositionsTotalLotsBuy(string symbol="ALL",ulong magic=0){
   double totalLots = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()) totalLots += PositionLots();
   }
   return totalLots;
}

double PositionsTotalLotsSell(string symbol="ALL",ulong magic=0){
   double totalLots = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()) totalLots += PositionLots();
   }
   return totalLots;
}

//---
double OrdersTotalLotsBuy(string symbol="ALL",ulong magic=0){
   double totalLots = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsBuyPending()) totalLots += OrderLots();
   }
   return totalLots;
}

double OrdersTotalLotsSell(string symbol="ALL",ulong magic=0){
   double totalLots = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsSellPending()) totalLots += OrderLots();
   }
   return totalLots;
}




//+------------------------------------------------------------------+
//| Funzioni complesse 1 per ricavo determinati valori               |
//+------------------------------------------------------------------+
double PositionsTotalProfitFullRunning(string symbol="ALL",ulong magic=0,ENUM_POSITION_TYPE type=-1){
   double totalProfits = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         if(type < 0 || PositionType() == type) totalProfits += PositionProfitFull();
      }
   }
   return totalProfits;
}

//---
double PositionOpenPriceHighestBuy(string symbol,ulong magic=0){       return PositionOpenPrice(ticketHighestBuyPosition(symbol,magic));}
double PositionOpenPriceLowestBuy(string symbol,ulong magic=0){        return PositionOpenPrice(ticketLowestBuyPosition(symbol,magic));}
double PositionOpenPriceHighestSell(string symbol,ulong magic=0){      return PositionOpenPrice(ticketHighestSellPosition(symbol,magic));}
double PositionOpenPriceLowestSell(string symbol,ulong magic=0){       return PositionOpenPrice(ticketLowestSellPosition(symbol,magic));}

ulong ticketHighestBuyPosition(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()){
         if(PositionOpenPrice() > openPriceTmp){
            openPriceTmp = PositionOpenPrice();
            ticket = PositionTicket();
         }
      }
   }
   return ticket;
}

ulong ticketLowestBuyPosition(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()){
         if(openPriceTmp == 0 || PositionOpenPrice() < openPriceTmp){
            openPriceTmp = PositionOpenPrice();
            ticket = PositionTicket();
         }
      }
   }
   return ticket;
}

ulong ticketHighestSellPosition(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()){
         if(PositionOpenPrice() > openPriceTmp){
            openPriceTmp = PositionOpenPrice();
            ticket = PositionTicket();
         }
      }
   }
   return ticket;
}

ulong ticketLowestSellPosition(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()){
         if(openPriceTmp == 0 || PositionOpenPrice() < openPriceTmp){
            openPriceTmp = PositionOpenPrice();
            ticket = PositionTicket();
         }
      }
   }
   return ticket;
}

//---
double OrderOpenPriceHighestBuy(string symbol,ulong magic=0){       return OrderOpenPrice(ticketHighestBuyOrder(symbol,magic));}
double OrderOpenPriceLowestBuy(string symbol,ulong magic=0){        return OrderOpenPrice(ticketLowestBuyOrder(symbol,magic));}
double OrderOpenPriceHighestSell(string symbol,ulong magic=0){      return OrderOpenPrice(ticketHighestSellOrder(symbol,magic));}
double OrderOpenPriceLowestSell(string symbol,ulong magic=0){       return OrderOpenPrice(ticketLowestSellOrder(symbol,magic));}

ulong ticketHighestBuyOrder(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsBuyPending()){
         if(OrderOpenPrice() > openPriceTmp){
            openPriceTmp = OrderOpenPrice();
            ticket = OrderTicket();
         }
      }
   }
   return ticket;
}

ulong ticketLowestBuyOrder(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsBuyPending()){
         if(openPriceTmp == 0 || OrderOpenPrice() < openPriceTmp){
            openPriceTmp = OrderOpenPrice();
            ticket = OrderTicket();
         }
      }
   }
   return ticket;
}

ulong ticketHighestSellOrder(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsSellPending()){
         if(OrderOpenPrice() > openPriceTmp){
            openPriceTmp = OrderOpenPrice();
            ticket = OrderTicket();
         }
      }
   }
   return ticket;
}

ulong ticketLowestSellOrder(string symbol,ulong magic=0){
   ulong ticket = 0;
   double openPriceTmp = 0;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsSellPending()){
         if(openPriceTmp == 0 || OrderOpenPrice() < openPriceTmp){
            openPriceTmp = OrderOpenPrice();
            ticket = OrderTicket();
         }
      }
   }
   return ticket;
}


//+------------------------------------------------------------------+
//| Funzioni complesse 2 (gestione di molteplici ordini)             |
//+------------------------------------------------------------------+
// Questa funzione chiude o cancella un trade, a prescindere che sia una posizione a mercato o un ordine pendente
void TradeClose(int ticket){
   if(PositionSelectByTicket(ticket))  PositionClose();
   if(OrderSelectByTicket(ticket))  	OrderDelete();
}

void brutalCloseTotal(string symbol="",ulong magic=0){
   brutalCloseBuyTrades(symbol,magic);
   brutalCloseSellTrades(symbol,magic);
}

void brutalCloseBuyTrades(string symbol="",ulong magic=0){
   brutalCloseBuyPositions(symbol,magic);
   brutalCloseBuyOrders(symbol,magic);
}

void brutalCloseBuyPositions(string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()){
			PositionClose();
      }
   }
}

void brutalCloseBuyOrders(string symbol="",ulong magic=0){
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsBuyPending()){
			OrderDelete();
      }
   }
}

void brutalCloseSellTrades(string symbol="",ulong magic=0){
   brutalCloseSellPositions(symbol,magic);
   brutalCloseSellOrders(symbol,magic);
}

void brutalCloseSellPositions(string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()){
			PositionClose();
      }
   }
}

void brutalCloseSellOrders(string symbol="",ulong magic=0){
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic) && OrderIsSellPending()){
			OrderDelete();
      }
   }
}
void brutalCloseAllProfitableTrades(string symbol="",ulong magic=0){	brutalCloseAllProfitablePositions(symbol,magic);}
void brutalCloseAllProfitablePositions(string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         if(PositionProfitFull() > 0){
            PositionClose();
         }
      }
   }
}

void brutalCloseAllLosingTrades(string symbol="",ulong magic=0){	brutalCloseAllLosingPositions(symbol,magic);}
void brutalCloseAllLosingPositions(string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         if(PositionProfitFull() < 0){
            PositionClose();
         }
      }
   }
}

//+------------------------------------------------------------------+
// Percentuale compresa tra [0 e 100]%
void PositionsCloseAllPartial(double percentualeChiusura,string symbol="",ulong magic=0){
   PositionsCloseBuyPartial(percentualeChiusura,symbol,magic);
   PositionsCloseSellPartial(percentualeChiusura,symbol,magic);
}

void PositionsCloseBuyPartial(double percentualeChiusura,string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()){
         PositionClosePartial(percentualeChiusura);
      }
   }
}

void PositionsCloseSellPartial(double percentualeChiusura,string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()){
         PositionClosePartial(percentualeChiusura);
      }
   }
}

// Variante di due funzioni in un'unica soluzione
void PositionsClosePartial(double percentualeChiusura,ENUM_POSITION_TYPE type=-1,string symbol="",ulong magic=0){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         if(type < 0 || PositionType() == type){
            PositionClosePartial(percentualeChiusura);
         }
      }
   }
}

//+------------------------------------------------------------------+
// Funzioni utili per gestire molteplici ordini in uno stesso mercato (esempio sistemi a griglia o con piramidazione)
// Funzione per il calcolo del punto medio (pesato in base ai lotti di ogni operazione)
double PositionsCalculateMediumPoint(string symbol,ulong magic,int type){
   double calcOfMediumPoint = 0;
   double totalLots_ = 0;
   for(int a=0;a<PositionsTotal();a++){
      if(PositionSelectByPos(a) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic,true)){
         if(type == POSITION_TYPE_BUY && PositionIsBuy()){
            calcOfMediumPoint += PositionOpenPrice()*PositionLots();  // Non consideriamo le commissioni e lo swap per il calcolo preciso del punto medio (lo vedremo in seguito)
            //calcOfMediumPoint += PositionOpenPrice()*PositionLots() + PositionCommission()*PositionPoint() - PositionSwap()*PositionPoint(); // Idea approssimativa per conteggiare anche le Commissioni e lo Swap
            totalLots_ += PositionLots();
         }
         if(type == POSITION_TYPE_SELL && PositionIsSell()){
            calcOfMediumPoint += PositionOpenPrice()*PositionLots();
            //calcOfMediumPoint += PositionOpenPrice()*PositionLots() - PositionCommission()*PositionPoint() + PositionSwap()*PositionPoint();
            totalLots_ += PositionLots();
         }
      }
   }
   
   double MediumPoint = 0;
   if(totalLots_ > 0)  MediumPoint = calcOfMediumPoint/totalLots_;
   
   return MediumPoint;
}

double OrdersCalculateMediumPoint(string symbol,ulong magic,ENUM_ORDER_TYPE type){
   double calcOfMediumPoint = 0;
   double totalLots_ = 0;
   for(int a=0;a<OrdersTotal();a++){
      if(OrderSelectByPos(a) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic,true)){
         if((type == ORDER_TYPE_BUY_LIMIT && OrderIsBuyLimit()) || (type == ORDER_TYPE_BUY_STOP && OrderIsBuyStop()) || (type == ORDER_TYPE_SELL_LIMIT && OrderIsSellLimit()) || (type == ORDER_TYPE_SELL_STOP && OrderIsSellStop())){
            calcOfMediumPoint += OrderOpenPrice()*OrderLots();
            totalLots_ += OrderLots();
         }
      }
   }
   
   double MediumPoint = 0;
   if(totalLots_ > 0)  MediumPoint = calcOfMediumPoint/totalLots_;
   
   return MediumPoint;
}


// Funzione per il calcolo del punto mediano (solo in base ai prezzi di apertura)
double PositionsCalculateAvgMedianPoint(string symbol,ulong magic,ENUM_POSITION_TYPE type){
   double calcOfMedianPoint = 0;
   double totalOrders_ = 0;
   for(int a=0;a<PositionsTotal();a++){
      if(PositionSelectByPos(a) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic,true)){
         if(type == POSITION_TYPE_BUY && PositionIsBuy()){
            calcOfMedianPoint += PositionOpenPrice();
            totalOrders_++;
         }
         if(type == POSITION_TYPE_SELL && PositionIsSell()){
            calcOfMedianPoint += PositionOpenPrice();
            totalOrders_++;
         }
      }
   }
   
   double MedianPoint = 0;
   if(totalOrders_ > 0)  MedianPoint = calcOfMedianPoint/totalOrders_;
   
   return MedianPoint;
}

double OrdersCalculateAvgMedianPoint(string symbol,ulong magic,ENUM_ORDER_TYPE type){
   double calcOfMedianPoint = 0;
   double totalOrders_ = 0;
   for(int a=0;a<OrdersTotal();a++){
      if(OrderSelectByPos(a) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic,true)){
         if((type == ORDER_TYPE_BUY_LIMIT && OrderIsBuyLimit()) || (type == ORDER_TYPE_BUY_STOP && OrderIsBuyStop()) || (type == ORDER_TYPE_SELL_LIMIT && OrderIsSellLimit()) || (type == ORDER_TYPE_SELL_STOP && OrderIsSellStop())){
            calcOfMedianPoint += OrderOpenPrice();
            totalOrders_++;
         }
      }
   }
   
   double MedianPoint = 0;
   if(totalOrders_ > 0)  MedianPoint = calcOfMedianPoint/totalOrders_;
   
   return MedianPoint;
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 18 MQL5                                                  |
//+------------------------------------------------------------------+

double   OrderAsk(){             return NormalizeDoubleOrder(Ask(OrderSymbol()));}
double   OrderBid(){             return NormalizeDoubleOrder(Bid(OrderSymbol()));}

double   OrderPoint(){      			return SymbolPoint(OrderSymbol());}
int      OrderFreezeLevel(){     	return SymbolFreezeLevel(OrderSymbol());}
double   OrderFreezeLevelValue(){	return SymbolFreezeLevelValue(OrderSymbol());}

string 	PositionSymbol(ulong ticket){				return PositionSelectByTicket(ticket) ? PositionSymbol()     : "";}

int      PositionFreezeLevel(){       return SymbolFreezeLevel(PositionSymbol());}
double   PositionFreezeLevelValue(){  return SymbolFreezeLevelValue(PositionSymbol());}

double   OrderStopLimit(){       return OrderGetDouble(ORDER_PRICE_STOPLIMIT);}

ENUM_ORDER_TYPE  	PositionInOrderType(){	return PositionIsBuy() ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;}

int 		TradesTotal(){				return PositionsTotal() + OrdersTotal();}


//+------------------------------------------------------------------+
//| Funzioni customizzate per la gestione degli errori               |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool IsSymbolCloseByAllowed(string symbol){  return (SymbolInfoInteger(symbol,SYMBOL_ORDER_MODE) & SYMBOL_ORDER_CLOSEBY) == SYMBOL_ORDER_CLOSEBY;} // Faccio un & a livello di bit per vedere se il flag SYMBOL_ORDER_CLOSEBY è attivato/consentito
bool IsTradeCloseByAllowed(int ticket){      return PositionSelectByTicket(ticket) ? IsTradeCloseByAllowed() : false;}
bool IsTradeCloseByAllowed(){                return IsSymbolCloseByAllowed(PositionSymbol());}

//+------------------------------------------------------------------+
double adjustVolume(double volume,string symbol=""){
   double volume_step = SymbolVolumeStep(symbol);
   if(volume_step == 0){
      printError("SYMBOL_VOLUME_STEP : 0 in "+__FUNCTION__);
      return adjustVolumeLimits(volume,symbol);
   }
   volume = MathRound(volume/volume_step)*volume_step;
   
   return adjustVolumeLimits(volume,symbol);
}

double adjustVolumeLimits(double volume,string symbol=""){
   if(volume < SymbolVolumeMin(symbol)) volume = SymbolVolumeMin(symbol);
   if(volume > SymbolVolumeMax(symbol)) volume = SymbolVolumeMax(symbol);
   return NormalizeDoubleVolume(volume);
}

double adjustVolumeOrder(double volume){        return adjustVolume(volume,OrderSymbol());}
double adjustVolumeLimitsOrder(double volume){  return adjustVolumeLimits(volume,OrderSymbol());}

double adjustVolumePosition(double volume){        return adjustVolume(volume,PositionSymbol());}
double adjustVolumeLimitsPosition(double volume){  return adjustVolumeLimits(volume,PositionSymbol());}

//+------------------------------------------------------------------+
bool IsExpirationValid(datetime expiration){
   return expiration == 0 || (expiration >= TimeCurrent() + 2*60);
}

bool IsOrderExpirationChanged(datetime expiration){
   return MathAbs(OrderExpiration()-expiration) >= 60;
}

bool IsOrderExpirationChangeAllowed(datetime expiration){
   return IsOrderExpirationChanged(expiration) && IsExpirationValid(expiration);
}

//+------------------------------------------------------------------+
void OrderDeleteExpiration(int ticket,int secondsExpiration){
   if(OrderSelectByTicket(ticket)){
      if(TimeCurrent() >= OrderTimeSetup() + secondsExpiration) OrderDelete();
   }
}

void OrderDeleteExpiration(int secondsExpiration,string symbol="ALL",ulong magic=0){
   if(secondsExpiration <= 0) return;
   for(int i=0;i<OrdersTotal();i++){
      if(OrderSelectByPos(i) && OrderIsSymbol(symbol) && OrderIsMagicNumber(magic)){
         if(TimeCurrent() >= OrderTimeSetup() + secondsExpiration) OrderDelete();
      }
   }
}

//+------------------------------------------------------------------+

bool IsNewOrderAllowed(){
   int max_allowed_orders=(int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   if(max_allowed_orders==0) return true;
   return OrdersTotal() < max_allowed_orders;
}

// Chiedere info al broker
// Funzione particolare che prende in considerazione il massimo numero di ordini per il calcolo massimo delle posizioni (molti brokers hanno una limitazione uguale)
bool IsNewPositionAllowed(){
	int max_allowed_positions=(int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   if(max_allowed_positions==0) return true;
   return PositionsTotal() < max_allowed_positions;
}

//+------------------------------------------------------------------+
bool OrderModifyCheck(int ticket,double newPrice,double newSL,double newTP,double newSLimit,datetime expiration,bool verbose=true){
   return OrderSelectByTicket(ticket) ? OrderModifyCheck(newPrice,newSL,newTP,newSLimit,expiration,verbose) : false;
}

bool OrderModifyCheck(double newPrice,double newSL,double newTP,double newSLimit,datetime expiration,bool verbose=true){
   double   point = 	NormalizeDoubleOrder(OrderPoint()),
            price =  NormalizeDoubleOrder(OrderOpenPrice()),
            sl =     NormalizeDoubleOrder(OrderStopLoss()),
            tp =     NormalizeDoubleOrder(OrderTakeProfit()),
            slimit =	NormalizeDoubleOrder(OrderStopLimit());
   
   newPrice =  NormalizeDoubleOrder(newPrice);
   newSL =     NormalizeDoubleOrder(newSL);
   newTP =     NormalizeDoubleOrder(newTP);
   newSLimit =	NormalizeDoubleOrder(newSLimit);
   
   if(newPrice < 0 || newSL < 0 || newTP < 0 || newSLimit < 0) return printErrorV("Errore valore negativi",verbose);
   
   bool  SL_changed =    		MathAbs(sl-newSL) >= point,
         TP_changed =    		MathAbs(tp-newTP) >= point,
         price_changed = 		MathAbs(price-newPrice) >= point,
         StopLimit_changed = 	MathAbs(slimit-newSLimit) >= point,
         expiration_changed = IsOrderExpirationChangeAllowed(expiration);
	
   if(SL_changed || TP_changed || StopLimit_changed || price_changed || expiration_changed) return true;

   return printErrorV("I nuovi livelli di prezzo non comportano nessuna modifica o la scadenza non è valida",verbose);       // nessuna modifica è necessaria
}

//+------------------------------------------------------------------+
bool PositionModifyCheck(int ticket,double newSL,double newTP,bool verbose=true){
   return PositionSelectByTicket(ticket) ? PositionModifyCheck(newSL,newTP,verbose) : false;
}

bool PositionModifyCheck(double newSL,double newTP,bool verbose=true){
   double   point = 	NormalizeDoublePosition(PositionPoint()),
            sl =     NormalizeDoublePosition(PositionStopLoss()),
            tp =     NormalizeDoublePosition(PositionTakeProfit());
   
   newSL =     NormalizeDoublePosition(newSL);
   newTP =     NormalizeDoublePosition(newTP);
   
   if(newSL < 0 || newTP < 0) return false;
   
   bool  SL_changed =    MathAbs(sl-newSL) >= point,
         TP_changed =    MathAbs(tp-newTP) >= point;
   
   if(SL_changed || TP_changed) return true;
   
   if(verbose)	Print("I nuovi livelli di SL/TP non comportano nessuna modifica");
   
   return false;       // nessuna modifica è necessaria
}

//+------------------------------------------------------------------+
bool IsPriceLevelsAllowed(ENUM_ORDER_TYPE type,double price,double sl,double tp,double slimit,string symbol="",bool verbose=true){
   double   stopL =  NormalizeDoubleSymbol(SymbolStopLevelValue(symbol),symbol),
            bid =    NormalizeDoubleSymbol(Bid(symbol),symbol),
            ask =    NormalizeDoubleSymbol(Ask(symbol),symbol);
   price =  NormalizeDoubleSymbol(price,symbol);
   sl =     NormalizeDoubleSymbol(sl,symbol);
   tp =     NormalizeDoubleSymbol(tp,symbol);
   slimit =	NormalizeDoubleSymbol(slimit,symbol);
   
   if(price < 0 || sl < 0 || tp < 0 || slimit < 0)	return printErrorV("Valori di prezzo negativi in "+__FUNCTION__,verbose);
   
   switch(type){
      case ORDER_TYPE_BUY:         		return (sl == 0 || sl <= bid) && (tp == 0 || tp >= bid);
      case ORDER_TYPE_SELL:        		return (sl == 0 || sl >= ask) && (tp == 0 || tp <= ask);
      case ORDER_TYPE_BUY_STOP:     	return (price > 0 && price >= ask) && (sl == 0 || sl <= price) && (tp == 0 || tp >= price);
      case ORDER_TYPE_BUY_LIMIT:    	return (price > 0 && price <= ask) && (sl == 0 || sl <= price) && (tp == 0 || tp >= price);
      case ORDER_TYPE_SELL_STOP:    	return (price > 0 && price <= bid) && (sl == 0 || sl >= price) && (tp == 0 || tp <= price);
      case ORDER_TYPE_SELL_LIMIT:		return (price > 0 && price >= bid) && (sl == 0 || sl >= price) && (tp == 0 || tp <= price);
      case ORDER_TYPE_BUY_STOP_LIMIT:	return (price > 0 && price >= ask) && (slimit > 0 && slimit <=price) && (sl == 0 || sl <= slimit) && (tp == 0 || tp >= slimit);
      case ORDER_TYPE_SELL_STOP_LIMIT:	return (price > 0 && price <= bid) && (slimit > 0 && slimit >=price) && (sl == 0 || sl >= slimit) && (tp == 0 || tp <= slimit);
   }
   return printErrorV("Livelli di prezzo non consentiti in "+__FUNCTION__,verbose);
}

//+------------------------------------------------------------------+
bool IsStopLevelsOrderAllowed(int ticket,double newPrice,double newSL,double newTP,double newSLimit,bool verbose=true){
   return OrderSelectByTicket(ticket) ? IsStopLevelsOrderAllowed(newPrice,newSL,newTP,newSLimit,verbose) : false;
}

bool IsStopLevelsOrderAllowed(double newPrice,double newSL,double newTP,double newSLimit,bool verbose=true){
   return IsStopLevelsAllowed(OrderType(),newPrice,newSL,newTP,newSLimit,OrderSymbol(),verbose);
}

//---
bool IsStopLevelsPositionAllowed(int ticket,double newSL,double newTP,bool verbose=true){
   return PositionSelectByTicket(ticket) ? IsStopLevelsPositionAllowed(newSL,newTP,verbose) : false;
}

bool IsStopLevelsPositionAllowed(double newSL,double newTP,bool verbose=true){
   return IsStopLevelsAllowed(PositionInOrderType(),0,newSL,newTP,0,PositionSymbol(),verbose);
}

bool IsStopLevelsAllowed(ENUM_ORDER_TYPE type,double price,double sl,double tp,double slimit,string symbol,bool verbose=true){
   double   stopL =  NormalizeDoubleSymbol(SymbolStopLevelValue(symbol),symbol),
            bid =    NormalizeDoubleSymbol(Bid(symbol),symbol),
            ask =    NormalizeDoubleSymbol(Ask(symbol),symbol);
   price =  NormalizeDoubleSymbol(price,symbol);
   sl =     NormalizeDoubleSymbol(sl,symbol);
   tp =     NormalizeDoubleSymbol(tp,symbol);
   slimit =	NormalizeDoubleSymbol(slimit,symbol);
   
   if(price < 0 || sl < 0 || tp < 0 || slimit < 0)	return printErrorV("Valori di prezzo negativi in "+__FUNCTION__,verbose);
   
   switch(type){
      case ORDER_TYPE_BUY:         		return (sl == 0 || sl <= bid - stopL) && (tp == 0 || tp >= bid + stopL);
      case ORDER_TYPE_SELL:				return (sl == 0 || sl >= ask + stopL) && (tp == 0 || tp <= ask - stopL);
      case ORDER_TYPE_BUY_STOP:     	return (price > 0 && price >= ask + stopL) && (sl == 0 || sl <= price - stopL) && (tp == 0 || tp >= price + stopL);
      case ORDER_TYPE_BUY_LIMIT:    	return (price > 0 && price <= ask - stopL) && (sl == 0 || sl <= price - stopL) && (tp == 0 || tp >= price + stopL);
      case ORDER_TYPE_SELL_STOP:    	return (price > 0 && price <= bid - stopL) && (sl == 0 || sl >= price + stopL) && (tp == 0 || tp <= price - stopL);
      case ORDER_TYPE_SELL_LIMIT:   	return (price > 0 && price >= bid + stopL) && (sl == 0 || sl >= price + stopL) && (tp == 0 || tp <= price - stopL);
      case ORDER_TYPE_BUY_STOP_LIMIT:	return (price > 0 && price >= ask + stopL) && (slimit > 0 && slimit <= price - stopL) && (sl == 0 || sl <= slimit - stopL) && (tp == 0 || tp >= slimit + stopL);
      case ORDER_TYPE_SELL_STOP_LIMIT:	return (price > 0 && price <= bid - stopL) && (slimit > 0 && slimit >= price + stopL) && (sl == 0 || sl >= slimit + stopL) && (tp == 0 || tp <= slimit - stopL);
   }
   return printErrorV("Livelli di prezzo non consentiti in "+__FUNCTION__,verbose);
}


//+------------------------------------------------------------------+
bool IsFreezeLevelsOrderAllowed(int ticket,double newPrice,double newSL,double newTP,double newSLimit,int typeModification=0,bool verbose=true){
   return OrderSelectByTicket(ticket) ? IsFreezeLevelsOrderAllowed(newPrice,newSL,newTP,newSLimit,typeModification,verbose) : false;
}

bool IsFreezeLevelsModificationOrderAllowed(double newPrice,double newSL,double newTP,double newSLimit,bool verbose=true){ 		return IsFreezeLevelsOrderAllowed(newPrice,newSL,newTP,newSLimit,0,verbose);}
bool IsFreezeLevelsDeleteOrderAllowed(bool verbose=true){                                                 								return IsFreezeLevelsOrderAllowed(OrderOpenPrice(),OrderStopLoss(),OrderTakeProfit(),OrderStopLimit(),1,verbose);}

bool IsFreezeLevelsPositionAllowed(int ticket,double newSL,double newTP,int typeModification=0,bool verbose=true){					return PositionSelectByTicket(ticket) ? IsFreezeLevelsPositionAllowed(newSL,newTP,typeModification,verbose) : false;}
bool IsFreezeLevelsModificationPositionAllowed(double newSL,double newTP,bool verbose=true){ 												return IsFreezeLevelsPositionAllowed(newSL,newTP,0,verbose);}
bool IsFreezeLevelsClosePositionAllowed(bool verbose=true){                                                  							return IsFreezeLevelsPositionAllowed(OrderStopLoss(),OrderTakeProfit(),1,verbose);}

// typeModification == 0   modifica dei livelli di prezzo entrata, SL, TP o StopLimit
// typeModification == 1   cancellazione ordine
bool IsFreezeLevelsOrderAllowed(double newPrice,double newSL,double newTP,double newSLimit,int typeModification=0,bool verbose=true){
   double   freeze = NormalizeDoubleOrder(OrderFreezeLevelValue()),
            point =  NormalizeDoubleOrder(OrderPoint()),
            price =  NormalizeDoubleOrder(OrderOpenPrice()),
            sl =     NormalizeDoubleOrder(OrderStopLoss()),
            tp =     NormalizeDoubleOrder(OrderTakeProfit()),
            slimit =	NormalizeDoubleOrder(OrderStopLimit()),
            ask =    OrderAsk(),
            bid =    OrderBid();
   
   newPrice =  NormalizeDoubleOrder(newPrice);
   newSL =     NormalizeDoubleOrder(newSL);
   newTP =     NormalizeDoubleOrder(newTP);
   newSLimit =	NormalizeDoubleOrder(newSLimit);
   
   if(freeze == 0) return true;
   if(typeModification == 0 && (newPrice < 0 || newSL < 0 || newTP < 0 || newSLimit < 0))	return printErrorV("Valori di prezzo negativi in "+__FUNCTION__,verbose);
   
   bool  SL_changed =      	MathAbs(sl-newSL) >= point,
         TP_changed =      	MathAbs(tp-newTP) >= point,
         price_changed =   	MathAbs(price-newPrice) >= point,
         StopLimit_changed = 	MathAbs(slimit-newSLimit) >= point;
         
   bool  ask_price_freezed =  MathAbs(ask-price) <= freeze,
         bid_price_freezed =  MathAbs(bid-price) <= freeze;
   
   bool  PriceOpenFreezed =    false;
         
   bool  valueToReturn = false;
   
   if(OrderIsBuyPending()){
      PriceOpenFreezed = ask_price_freezed && (price_changed || SL_changed || TP_changed || StopLimit_changed);
      
      if(typeModification == 1)  valueToReturn = !ask_price_freezed;
      else                       valueToReturn = !PriceOpenFreezed;
      
   }
   if(OrderIsSellPending()){
      PriceOpenFreezed = bid_price_freezed && (price_changed || SL_changed || TP_changed || StopLimit_changed);
      
      if(typeModification == 1)  valueToReturn = !bid_price_freezed;
      else                       valueToReturn = !PriceOpenFreezed;
   }
   
   if(valueToReturn) return true;
   
   return printErrorV("I livelli sono congelati e l'esecuzione è bloccata in "+__FUNCTION__+". La zona di FreezeLevel è di "+IntegerToString(SymbolFreezeLevel(OrderSymbol()))+" Point",verbose);
}

// typeModification == 0   modifica dei livelli di SL o TP
// typeModification == 1   chiusura ordine
bool IsFreezeLevelsPositionAllowed(double newSL,double newTP,int typeModification=0,bool verbose=true){
   double   freeze = NormalizeDoublePosition(PositionFreezeLevelValue()),
            point =  NormalizeDoublePosition(PositionPoint()),
            sl =     NormalizeDoublePosition(PositionStopLoss()),
            tp =     NormalizeDoublePosition(PositionTakeProfit()),
            ask =    PositionAsk(),
            bid =    PositionBid();
   
   newSL =     NormalizeDoublePosition(newSL);
   newTP =     NormalizeDoublePosition(newTP);
   
   if(freeze == 0) return true;
   
   if(typeModification == 0 && (newSL < 0 || newTP < 0))	return printErrorV("Valori di prezzo negativi in "+__FUNCTION__,verbose);
   
   bool  SL_changed =      MathAbs(sl-newSL) >= point,
         TP_changed =      MathAbs(tp-newTP) >= point;
   
   bool  bid_sl_freezed =     sl > 0 && bid <= sl + freeze,
         bid_tp_freezed =     tp > 0 && bid <= tp - freeze,
         ask_sl_freezed =     sl > 0 && ask >= sl - freeze,
         ask_tp_freezed =     tp > 0 && ask <= tp + freeze;
   
   bool  StopLossFreezed =     false,
         TakeProfitFreezed =   false;
         
   bool  valueToReturn = false;
   
   if(PositionIsBuy()){
      StopLossFreezed =     SL_changed && bid_sl_freezed;
      TakeProfitFreezed =   TP_changed && bid_tp_freezed;
      
      if(typeModification == 1)  valueToReturn = !bid_sl_freezed && !bid_tp_freezed;
      else                       valueToReturn = !StopLossFreezed && !TakeProfitFreezed;
   }
   
   if(PositionIsSell()){
      StopLossFreezed =     SL_changed && ask_sl_freezed;
      TakeProfitFreezed =   TP_changed && ask_tp_freezed;
      
      if(typeModification == 1)  valueToReturn = !ask_sl_freezed && !ask_tp_freezed;
      else                       valueToReturn = !StopLossFreezed && !TakeProfitFreezed;
   }
   
   if(valueToReturn) return true;
   
   return printErrorV("I livelli sono congelati e l'esecuzione è bloccata in "+__FUNCTION__+". La zona di FreezeLevel è di "+IntegerToString(SymbolFreezeLevel(PositionSymbol()))+" Point",verbose);
}



//+------------------------------------------------------------------+
//| Integrazione funzioni per la gestione degli errori               |
//+------------------------------------------------------------------+

ulong SendPosition(string symbol,ENUM_ORDER_TYPE type,double volume,double price,int slippage,double sl,double tp,string comment,ulong magic,bool verbose=true){
   MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
   MqlTradeResult    positionResult;	ZeroMemory(positionResult);
   
	positionRequest.action =         TRADE_ACTION_DEAL;
   positionRequest.type =           type;
   positionRequest.type_filling =   ORDER_FILLING_IOC;
   positionRequest.deviation =      slippage;
   positionRequest.symbol =         Symbol(symbol);
   positionRequest.volume =         adjustVolume(volume,symbol);
   positionRequest.price =          NormalizeDoubleSymbol(price,symbol);
   positionRequest.sl =             NormalizeDoubleSymbol(sl,symbol);
   positionRequest.tp =             NormalizeDoubleSymbol(tp,symbol);
   positionRequest.comment =        StringExtract(comment,0,31);
   positionRequest.magic =          magic;
   
   // Controllo eventuali errori
   if(!checkMoneyForTrade(positionRequest.volume,positionRequest.symbol,positionRequest.type,positionRequest.price))		return printErrorV("Non c'è abbastanza denaro per aprire "+DoubleString(volume)+ " lotti su "+symbol,verbose);
   if(!IsNewPositionAllowed())                           																					return printErrorV("Raggiunto il massimo numero di ordini/posizioni. Non è possibile aprire altre posizioni",verbose);
   if(!IsStopLevelsAllowed(positionRequest.type,0,positionRequest.sl,positionRequest.tp,0,positionRequest.symbol))  		return printErrorV("Livelli di prezzo non consentiti per l'invio della posizione",verbose);
   
   
   //if(OrderSend(positionRequest,positionResult))	return positionResult.deal;	// Ritorna il ticket dell'affare chiuso
   if(OrderSend(positionRequest,positionResult))	return positionResult.order; 	// Ritorna il ticket dell'ordine inviato a mercato
   
   return printError(ErrorTradeServer(positionResult.retcode)+". Error to send Position");
}


ulong SendOrder(string symbol,ENUM_ORDER_TYPE type,double volume,double price,double stoplimit,int slippage,double sl,double tp,string comment,ulong magic,datetime expiration=0,bool verbose=true){
   MqlTradeRequest   orderRequest;	ZeroMemory(orderRequest);
   MqlTradeResult    orderResult;	ZeroMemory(orderResult);
   
   orderRequest.action =         TRADE_ACTION_PENDING;
   orderRequest.type =           type;
   orderRequest.type_filling =   ORDER_FILLING_IOC;
   orderRequest.deviation =      slippage;
   orderRequest.symbol =     		Symbol(symbol);
   orderRequest.volume =         adjustVolume(volume,symbol);
   if(type == ORDER_TYPE_BUY_STOP_LIMIT || type == ORDER_TYPE_SELL_STOP_LIMIT)
   	orderRequest.stoplimit =	NormalizeDoubleSymbol(stoplimit,symbol);
	orderRequest.price =          NormalizeDoubleSymbol(price,symbol);
   orderRequest.sl =             NormalizeDoubleSymbol(sl,symbol);
   orderRequest.tp =             NormalizeDoubleSymbol(tp,symbol);
   orderRequest.comment =        StringExtract(comment,0,31);
   orderRequest.magic =          magic;
   orderRequest.type_time =		ORDER_TIME_GTC;
   if(expiration > 0){
   	orderRequest.type_time =	ORDER_TIME_SPECIFIED;
   	
   	if(!IsExpirationValid(expiration)){
         Print("La scadenza dell'ordine non è valida, essa verrà impostata a 0 e l'ordine verrà inviato comunque. Fare un controllo manuale."); // Fare un controllo manuale oppure gestire in maniera opportuna il codice con OrderDeleteExpiration
         orderRequest.type_time =	ORDER_TIME_GTC;
         expiration = 0;
      }
   	orderRequest.expiration =	expiration;
	}
	
	// Controllo eventuali errori
   if(!checkMoneyForTrade(orderRequest.volume,orderRequest.symbol,orderRequest.type,orderRequest.price))						return printErrorV("Non c'è abbastanza denaro per aprire "+DoubleString(volume)+ " lotti su "+symbol,verbose);
   if(!IsNewOrderAllowed())                           																							return printErrorV("Raggiunto il massimo numero di ordini/posizioni. Non è possibile aprire altri ordini",verbose);
   if(!IsStopLevelsAllowed(orderRequest.type,orderRequest.price,orderRequest.sl,orderRequest.tp,orderRequest.stoplimit,orderRequest.symbol))  		return printErrorV("Livelli di prezzo non consentiti per l'invio dell'ordine",verbose);
   
   
   if(OrderSend(orderRequest,orderResult)) return orderResult.order;
   
   return printError(ErrorTradeServer(orderResult.retcode)+". Error to send Order");
}


bool PositionClose(double volume,int deviation=5,bool verbose=true){

	if(!IsFreezeLevelsClosePositionAllowed(verbose)) return false;
	
   MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
   MqlTradeResult    positionResult;	ZeroMemory(positionResult);
   
   positionRequest.action =         TRADE_ACTION_DEAL;
   positionRequest.type_filling =	ORDER_FILLING_IOC;
   positionRequest.position =       PositionTicket();
   positionRequest.deviation=       deviation;
   positionRequest.symbol   =       PositionSymbol();
   positionRequest.comment =			PositionComment();
   positionRequest.magic    =       PositionMagicNumber();
   
   positionRequest.volume   =       adjustVolumePosition(volume);	// Scelta arbitraria per la gestione dei lotti negativi
   if(volume > PositionVolume()) 	volume = PositionVolume();	
   
   if(PositionIsBuy()){
      positionRequest.price=PositionBid();
      positionRequest.type =ORDER_TYPE_SELL;
   }
   else{
      positionRequest.price=PositionAsk();
      positionRequest.type =ORDER_TYPE_BUY;
   }
   
   if(!OrderSend(positionRequest,positionResult)) return printError(ErrorTradeServer(positionResult.retcode)+". Errore chiusura posizione");
   return true;
}


bool PositionCloseBy(ulong ticket,ulong ticketOpposto,int deviation=5,bool verbose=true){
	
	if(!PositionSelectByTicket(ticket)) return printErrorV("Errore nel riconoscimento ticket primario",verbose);
   string commentOriginal =	PositionComment();
   ulong magicOriginal = 		PositionMagicNumber();
   
   if(!PositionSelectByTicket(ticketOpposto)) return printErrorV("Errore nel riconoscimento ticket secondario",verbose);
   
	if(!ticketAreSameMarket(ticket,ticketOpposto,verbose))	return printErrorV("Operazione CloseBy non consentita",verbose);
	if(!ticketAreOpposite(ticket,ticketOpposto,verbose))    	return printErrorV("Operazione CloseBy non consentita",verbose);
	
	string symbol = PositionSymbol(ticket);
	if(!IsSymbolCloseByAllowed(symbol))                  		return printErrorV("Chiusura opposta con CloseBy non consentita sul mercato "+symbol,verbose);
	
	
	MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
   MqlTradeResult    positionResult;	ZeroMemory(positionResult);
   
   positionRequest.action =         TRADE_ACTION_CLOSE_BY;
   positionRequest.position =       ticket;
   positionRequest.position_by =    ticketOpposto;
   positionRequest.comment =			commentOriginal;
   positionRequest.magic    =       magicOriginal;
   
   if(!OrderSend(positionRequest,positionResult)) return printError(ErrorTradeServer(positionResult.retcode)+". Errore nella chiusura del trade in hedging");
   return true;
}

bool OrderDelete(bool verbose=true){
	if(!IsFreezeLevelsDeleteOrderAllowed(verbose)) return false;
	
   MqlTradeRequest	orderRequest;	ZeroMemory(orderRequest);
   MqlTradeResult    orderResult;	ZeroMemory(orderResult);
   
   orderRequest.order =    OrderTicket();
   orderRequest.action =   TRADE_ACTION_REMOVE;
   
   if(!OrderSend(orderRequest,orderResult)) return printError(ErrorTradeServer(orderResult.retcode)+". Errore cancellazione ordine pendente");
   return true;
}


bool PositionModify(double stoploss,double takeprofit,bool verbose=true){
	
	if(!IsFreezeLevelsModificationPositionAllowed(stoploss,takeprofit,verbose)) 	return printErrorV("Modifica non consentita per il FreezeLevel",verbose);
   if(!IsStopLevelsPositionAllowed(stoploss,takeprofit,verbose))                	return printErrorV("Modifica non consentita per lo StopLevel",verbose);
   if(!PositionModifyCheck(stoploss,takeprofit,verbose))                			return printErrorV("Nessuna reale modifica da fare sulla posizione",verbose);
	
	MqlTradeRequest   positionRequest;	ZeroMemory(positionRequest);
	MqlTradeResult    positionResult;	ZeroMemory(positionResult);
	
	positionRequest.action  =  TRADE_ACTION_SLTP;
	positionRequest.position=  PositionTicket();
	positionRequest.symbol  =  PositionSymbol();
	positionRequest.sl      =  NormalizeDoublePosition(stoploss);
	positionRequest.tp      =  NormalizeDoublePosition(takeprofit);
	
	if(!OrderSend(positionRequest,positionResult)) printError(ErrorTradeServer(positionResult.retcode)+". Errore nel modificare la posizione");
	return true;
}

//+------------------------------------------------------------------+
//| Funzioni customizzate per la modifica degli ordini pendenti      |
//+------------------------------------------------------------------+

bool OrderModify(double price,double stoploss,double takeprofit,double slimit,datetime expiration,bool verbose=true){
	if(!IsFreezeLevelsModificationOrderAllowed(price,stoploss,takeprofit,slimit,verbose))	return printErrorV("Modifica non consentita per il FreezeLevel",verbose);
   if(!IsStopLevelsOrderAllowed(price,stoploss,takeprofit,slimit,verbose))             	return printErrorV("Modifica non consentita per lo StopLevel",verbose);
   if(OrderExpiration() != expiration && !IsExpirationValid(expiration))      				return printErrorV("Nuova scadenza ordine non valida",verbose);
   
   if(!OrderModifyCheck(price,stoploss,takeprofit,slimit,expiration,verbose))					return printErrorV("Nessuna reale modifica da fare sull'ordine",verbose);
	
	MqlTradeRequest   orderRequest;	ZeroMemory(orderRequest);
	MqlTradeResult    orderResult;	ZeroMemory(orderResult);
	
	orderRequest.action = 	TRADE_ACTION_MODIFY;
   orderRequest.order =		OrderTicket();
   orderRequest.symbol = 	OrderSymbol();
   orderRequest.price =		NormalizeDoubleOrder(price);
   orderRequest.sl =			NormalizeDoubleOrder(stoploss);
   orderRequest.tp =			NormalizeDoubleOrder(takeprofit);
   orderRequest.stoplimit =NormalizeDoubleOrder(slimit);
   
   if(expiration != OrderExpiration()){
   	if(expiration == 0){
		   orderRequest.type_time = 	ORDER_TIME_GTC;
		   orderRequest.expiration = 	0;
	   }
	   
	   if(expiration > 0){
	   	orderRequest.type_time =	ORDER_TIME_SPECIFIED;
	   	orderRequest.expiration =	expiration;
	   	
	   	if(!IsExpirationValid(expiration)){
	   		// Fare un controllo manuale oppure gestire in maniera opportuna il codice con OrderDeleteExpiration
	         printErrorV("La scadenza dell'ordine non è valida, essa verrà impostata a 0 e l'ordine verrà inviato comunque. Fare un controllo manuale.",verbose);
	         orderRequest.type_time =	ORDER_TIME_GTC;
	         expiration = 0;
	      }
		}
	} 
   
   // Variante Johnny lo spaccone!
   return !OrderSend(orderRequest,orderResult) ? printError(ErrorTradeServer(orderResult.retcode)+". Errore nella modifica dell'ordine pendente") : true;
}

void OCO_Order(ulong ticketT,ulong orderC,bool verbose=true){
   if(PositionSelectByTicket(ticketT)){
   	if(OrderSelectByTicket(orderC)) OrderDelete();
   	else printErrorV("Errore cancellazione ordine OCO",verbose);
   }
}

bool OCO_Order_Singolo(ulong ticketTrigger,ulong orderToCancel,bool verbose=true){
   if(PositionSelectByTicket(ticketTrigger)){
      if(OrderSelectByTicket(orderToCancel))   return OrderDelete(verbose);
      return printErrorV("Errore cancellazione ordine OCO",verbose);
   }
   return false;
}

bool OCO_Order_Totale(ulong ticket1,ulong ticket2,bool verbose=true){
   bool oco1 = OCO_Order_Singolo(ticket1,ticket2,verbose);
   bool oco2 = OCO_Order_Singolo(ticket2,ticket1,verbose);
   return oco1 || oco2;
}


//+------------------------------------------------------------------+
bool ticketAreOpposite(ulong ticket1,ulong ticket2,bool verbose=true){
   ENUM_POSITION_TYPE type_1 =	PositionType(ticket1);
   ENUM_POSITION_TYPE type_2 =	PositionType(ticket2);
   
   if(type_1 != type_2) return true;
   
   return printErrorV("I due ticket selezionati corrispondono a due ordini non opposti",verbose);
}

bool ticketAreSameMarket(ulong ticket1,ulong ticket2,bool verbose=true){
   if(StringIsEqual(PositionSymbol(ticket1),PositionSymbol(ticket2))) return true;
   
   return printErrorV("I due ticket selezionati corrispondono ad ordini di due mercati diversi",verbose);
}


//+------------------------------------------------------------------+
bool checkMoneyForTrade(double volume,string symbol="",ENUM_ORDER_TYPE type=ORDER_TYPE_BUY,double price=0){
   return AccountFreeMarginCheck(symbol,type,volume,price) > 0;
}

double AccountFreeMarginCheck(string symbol,ENUM_ORDER_TYPE type,double volume,double price=0){
	if(price == 0) price = Bid(symbol);
	double margin = 0;
	if(!OrderCalcMargin(type,Symbol(symbol),volume,price,margin)) return WRONG_VALUE;
	
	return AccountFreeMargin() - margin;
}




//+------------------------------------------------------------------+
//| LEZIONE TOP 18.2 MQL5															|
//+------------------------------------------------------------------+
ulong SendTradeInPoint(string symbol,ENUM_ORDER_TYPE type,double volume,int distPrice,int stoplimit,int slippage,int distSL,int distTP,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
   if(distPrice < 0 || stoplimit < 0 || distSL < 0 || distTP < 0) return printErrorV("Errore, valori negativi nei parametri di "+__FUNCTION__,verbose);
   
   double   entryPrice = 0,
   			slimitPrice = 0,
            slPrice = 0,
            tpPrice = 0,
            ask = Ask(symbol),
            bid = Bid(symbol);
   
   if(type == ORDER_TYPE_BUY || type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_BUY_LIMIT){
      if(type == ORDER_TYPE_BUY)      	entryPrice = ask; // operazione a mercato, ignora il distPrice
      if(type == ORDER_TYPE_BUY_STOP)  entryPrice = ask + point(distPrice,symbol);
      if(type == ORDER_TYPE_BUY_LIMIT)	entryPrice = ask - point(distPrice,symbol);
      
      if(distSL > 0) slPrice =   entryPrice-point(distSL,symbol);
      if(distTP > 0) tpPrice =   entryPrice+point(distTP,symbol);
   }
   
   if(type == ORDER_TYPE_BUY_STOP_LIMIT){
   	entryPrice = ask + point(distPrice,symbol);
   	slimitPrice = entryPrice - point(stoplimit,symbol);
   	if(distSL > 0) slPrice =   slimitPrice-point(distSL,symbol);
   	if(distTP > 0) tpPrice =   slimitPrice+point(distTP,symbol);
	}
   
   if(type == ORDER_TYPE_SELL || type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_SELL_LIMIT){
      if(type == ORDER_TYPE_SELL)    	 entryPrice = bid; // operazione a mercato, ignora il distPrice
      if(type == ORDER_TYPE_SELL_STOP)  entryPrice = bid - point(distPrice,symbol);
      if(type == ORDER_TYPE_SELL_LIMIT) entryPrice = bid + point(distPrice,symbol);
   
      if(distSL > 0) slPrice =   entryPrice+point(distSL,symbol);
      if(distTP > 0) tpPrice =   entryPrice-point(distTP,symbol);
   }
   
   if(type == ORDER_TYPE_SELL_STOP_LIMIT){
   	entryPrice = bid - point(distPrice,symbol);
   	slimitPrice = entryPrice + point(stoplimit,symbol);
   	if(distSL > 0) slPrice =   slimitPrice+point(distSL,symbol);
   	if(distTP > 0) tpPrice =   slimitPrice-point(distTP,symbol);
	}
   
   return SendTrade(symbol,type,volume,entryPrice,slimitPrice,slippage,slPrice,tpPrice,comment,magic,expiration,verbose);
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 19 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double PositionPriceToOpen(){
   if(PositionIsBuy())  return PositionAsk();
   if(PositionIsSell()) return PositionBid();
   return 0;
}

double PositionPriceToClose(){
   if(PositionIsBuy())  return PositionBid();
   if(PositionIsSell()) return PositionAsk();
   return 0;
}

int 		PositionSpread(){									return Spread(PositionSymbol());}
double	PositionSpreadValue(){							return SpreadValue(PositionSymbol());}


ulong SendTradeBuyInPoint(string symbol,double volume,int deviation,int sl_point,int tp_point,string comment,ulong magic,bool verbose=true){
	return SendTradeInPoint(symbol,ORDER_TYPE_BUY,volume,0,0,deviation,sl_point,tp_point,comment,magic,0,verbose);
}

ulong SendTradeSellInPoint(string symbol,double volume,int deviation,int sl_point,int tp_point,string comment,ulong magic,bool verbose=true){
	return SendTradeInPoint(symbol,ORDER_TYPE_SELL,volume,0,0,deviation,sl_point,tp_point,comment,magic,0,verbose);
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| TrailingStop normale (o fino a livelli predefiniti)              |
//+------------------------------------------------------------------+
bool PositionTrailingStop(ulong ticket,int distTS,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStop(distTS,priceToReach);
   return false;
}

bool PositionTrailingStop(int distTS,double priceToReach=0){
   if(distTS < 0) return printErrorV("Errore valore per la distanza TrailingStop in "+__FUNCTION__);
   
   priceToReach = NormalizeDoublePosition(priceToReach);
   
   if(PositionIsBuy()){
      double   price =  PositionBid(),
               sl =     NormalizeDoublePosition(PositionStopLoss()),
               slTmp =  NormalizeDoublePosition(price - pointPosition(distTS));
      
      if(slTmp >= sl + PositionPoint()){
         if(priceToReach > 0){
            if(sl >= priceToReach || MathAbs(sl-priceToReach) < PositionPoint()) return false;
            if(slTmp > priceToReach) slTmp = priceToReach;
         }
         return PositionModify(slTmp,PositionTakeProfit());
      }
   }
   
   if(PositionIsSell()){
      double   price =  PositionAsk(),
               sl =     NormalizeDoublePosition(PositionStopLoss()),
               slTmp =  NormalizeDoublePosition(price + pointPosition(distTS));
      
      if(sl == 0 || slTmp <= sl - PositionPoint()){
         if(priceToReach > 0){
            if(sl > 0 && (sl <= priceToReach || MathAbs(sl-priceToReach) < PositionPoint())) return false;
            if(slTmp < priceToReach) slTmp = priceToReach;
         }
         return PositionModify(slTmp,PositionTakeProfit());
      }
   }
   return false;
}


//+------------------------------------------------------------------+
//| TrailingStop fino a breakeven                                    |
//+------------------------------------------------------------------+
// BE > 0 vuol dire uno StopLoss in positivo oltre il prezzo di apertura, "StopProfit".
// BE < 0 vuol dire uno StopLoss in al di sotto del prezzo di apertura
// Il buffer è misurato in Point

bool PositionTrailingStopToBE(ulong ticket,int distTS,int bufferPointBE){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopToBE(distTS,bufferPointBE);
   return false;
}

bool PositionTrailingStopToBE(int distTS,int bufferPointBE){
   double priceToReach = 0;
   if(PositionIsBuy())  priceToReach = PositionOpenPrice() + pointPosition(bufferPointBE);
   if(PositionIsSell()) priceToReach = PositionOpenPrice() - pointPosition(bufferPointBE);
   
   return PositionTrailingStop(distTS,priceToReach);
}


//+------------------------------------------------------------------+
//| TrailingStop a partire dal breakeven                             |
//+------------------------------------------------------------------+
bool PositionTrailingStopFromBE(ulong ticket,int distTS,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopFromBE(distTS,priceToReach);
   return false;
}

bool PositionTrailingStopFromBE(int distTS,double priceToReach=0){
   if(distTS < 0) return printErrorV("Errore valore per la distanza TrailingStop in "+__FUNCTION__);
   
   if(PositionProfitPoint() >= distTS) return PositionTrailingStop(distTS,priceToReach);

   return false;
}


//+------------------------------------------------------------------+
//| TrailingStop con scatto tramite trigger                          |
//+------------------------------------------------------------------+
bool PositionTrailingStopTriggerPrice(ulong ticket,int distTS,double triggerPrice,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopTriggerPrice(distTS,triggerPrice,priceToReach);
   return false;
}

bool PositionTrailingStopTriggerPrice(int distTS,double triggerPrice,double priceToReach=0){
   if(triggerPrice <= 0)   return printErrorV("Errore valore per triggerPrice in "+__FUNCTION__);
   
   if((PositionIsBuy() && PositionBid() >= triggerPrice)  ||  (PositionIsSell() && PositionAsk() <= triggerPrice)) return PositionTrailingStop(distTS,priceToReach);
   return false;
}


//+------------------------------------------------------------------+
//| TrailingStop con avanzamento a step                              |
//+------------------------------------------------------------------+
// Questa tipologia di TrailingStop prevede un distTS maggiore di distStep

bool PositionTrailingStopInStep(ulong ticket,int distTS,int distStep,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopInStep(distTS,distStep,priceToReach);
   return false;
}

bool PositionTrailingStopInStep(int distTS,int distStep,double priceToReach=0){
   if(distTS < 0 || distStep <= 0) return printErrorV("Errore valori negativi in "+__FUNCTION__);
   if(distTS <= distStep)           return PositionTrailingStop(distTS,priceToReach); // Scelta personale
   
   if(PositionStopLoss() == 0 || distancePointPositionAbs(PositionPriceToClose(),PositionStopLoss()) >= distTS) return PositionTrailingStop(distStep,priceToReach);
   
   return false;
}


//+------------------------------------------------------------------+
//| TrailingStop basato sulle candele                                |
//+------------------------------------------------------------------+
// typeCandle == 0 il TrailingStop è basato sul min/max della candela "index" (rispettivamente per un'operazione di Buy/Sell)
// typeCandle == 1 il TrailingStop è basato sul min/max del corpo della candela "index" (rispettivamente per un'operazione di Buy/Sell)
// typeCandle == 2 il TrailingStop è basato sul max/min del corpo della candela "index" (rispettivamente per un'operazione di Buy/Sell)
// typeCandle == 3 il TrailingStop è basato sul max/min della candela "index" (rispettivamente per un'operazione di Buy/Sell) [fare attenzione all'indice della candela]

bool PositionTrailingStopOnCandle(ulong ticket,int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopOnCandle(typeCandle,indexCandle,timeframe,priceToReach);
   return false;
}

bool PositionTrailingStopOnCandle(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,double priceToReach=0){
   if(indexCandle < 0 || indexCandle > iBars(PositionSymbol(),timeframe)) return printErrorV("Errore valore indice candela in "+__FUNCTION__);
   
   
   double priceTS = 0;
   double sl = NormalizeDoublePosition(PositionStopLoss());
   
   priceToReach =    NormalizeDoublePosition(priceToReach);
   
   if(PositionIsBuy()){
      if(typeCandle == 0)  priceTS = candleLow(indexCandle,timeframe,PositionSymbol());
      if(typeCandle == 1)  priceTS = candleBodyMin(indexCandle,timeframe,PositionSymbol());
      if(typeCandle == 2)  priceTS = candleBodyMax(indexCandle,timeframe,PositionSymbol());
      if(typeCandle == 3)  priceTS = candleHigh(indexCandle,timeframe,PositionSymbol());
      
      priceTS = NormalizeDoublePosition(priceTS);
      
      if(priceToReach > 0) priceTS = MathMin(priceTS,priceToReach);
      
      bool conditionTS_1 = priceTS > 0 && priceTS <= PositionBid()-PositionStopLevelValue();
      bool conditionTS_2 = MathAbs(sl-priceTS) >= PositionPoint();
      
      // variante 1 con movimento SL all'indietro
      //if(conditionTS_1 && conditionTS_2) return PositionModify(priceTS,PositionTakeProfit());
      if(conditionTS_1 && conditionTS_2) return PositionTrailingStop(0,priceTS);
   }
   
   if(PositionIsSell()){
      if(typeCandle == 0)  priceTS = candleHigh(indexCandle,timeframe,PositionSymbol());
      if(typeCandle == 1)  priceTS = candleBodyMax(indexCandle,timeframe,PositionSymbol());
      if(typeCandle == 2)  priceTS = candleBodyMin(indexCandle,timeframe,PositionSymbol());
      if(typeCandle == 3)  priceTS = candleLow(indexCandle,timeframe,PositionSymbol());
      
      priceTS = NormalizeDoublePosition(priceTS);
      
      if(priceToReach > 0) priceTS = MathMax(priceTS,priceToReach);
      
      bool conditionTS_1 = priceTS > 0 && priceTS >= PositionAsk()+PositionStopLevelValue();
      bool conditionTS_2 = MathAbs(sl-priceTS) >= PositionPoint();
      
      //if(conditionTS_1 && conditionTS_2) return PositionModify(priceTS,PositionTakeProfit());
      if(conditionTS_1 && conditionTS_2) return PositionTrailingStop(0,priceTS);
   }
   
   return false;
}


//+------------------------------------------------------------------+
//| TrailingStop basato su patterns di indicatori                    |
//+------------------------------------------------------------------+

bool PositionTrailingStopIndicator(ulong ticket,int distTS,double priceIndicator,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopIndicator(distTS,priceIndicator,priceToReach);
   return false;
}

bool PositionTrailingStopIndicator(int distTS,double priceIndicator,double priceToReach=0){
   if(distTS < 0)         return printErrorV("Errore valore per la distanza TrailingStop in "+__FUNCTION__);
   if(priceIndicator <= 0) return printErrorV("Errore valore per il livello di prezzo dell'indicatore in "+__FUNCTION__);
   
   priceIndicator =  NormalizeDoublePosition(priceIndicator);
   priceToReach =    NormalizeDoublePosition(priceToReach);
   
   double priceTmp = priceIndicator;
   
   if(priceToReach > 0){
      if(PositionIsBuy())  priceTmp = MathMin(priceIndicator,priceToReach);
      if(PositionIsSell()) priceTmp = MathMax(priceIndicator,priceToReach);
   }
   
   return PositionTrailingStop(distTS,priceTmp);
}

//+------------------------------------------------------------------+
bool PositionTrailingStopMA(ulong ticket,int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopMA(periodMA,index,timeframe,ma_method,applied_price,ma_method,priceToReach);
   return false;
}

bool PositionTrailingStopMA(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,double priceToReach=0){
   double myMA = iMA(PositionSymbol(),timeframe,periodMA,ma_shift,ma_method,applied_price,index);
   if(myMA <= 0) return printErrorV("Errore nel calcolo della Media Mobile in "+__FUNCTION__);
   
   myMA = NormalizeDoublePosition(myMA);
   
   double sl = NormalizeDoublePosition(PositionStopLoss());
   
   if(PositionIsBuy()){
      // Queste condizioni non sono necessarie! Possono anche essere omesse, perché ulteriori controlli vengono comunque fatti nelle funzioni interne/customizzate
      bool conditionTS_1 = myMA <= PositionBid()-PositionStopLevelValue();
      bool conditionTS_2 = MathAbs(sl-myMA) >= PositionPoint();
      
      if(conditionTS_1 && conditionTS_2) return PositionTrailingStopIndicator(0,myMA,priceToReach);
   }
   
   if(PositionIsSell()){
      bool conditionTS_1 = myMA >= PositionAsk()+PositionStopLevelValue();
      bool conditionTS_2 = MathAbs(sl-myMA) >= PositionPoint();
      
      if(conditionTS_1 && conditionTS_2) return PositionTrailingStopIndicator(0,myMA,priceToReach);
   }
   
   return false;
}


//+------------------------------------------------------------------+
//| TrailingStop con avanzamento ad uno step definito in Point       |
//+------------------------------------------------------------------+
// Questa tipologia di TrailingStop prevede uno step "trigger" in Point che il prezzo deve raggiungere e una distanza in Point dove verrà spostato il TrailingStop "una tantum" (solo con andamento ascendente/discendente in base a un Buy/Sell)

bool PositionTrailingStopInStepSpecific(ulong ticket,int distTriggerFromEntryPrice,int distNewSLFromEntryPrice,double priceToReach=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopInStepSpecific(distTriggerFromEntryPrice,distNewSLFromEntryPrice,priceToReach);
   return false;
}

bool PositionTrailingStopInStepSpecific(int distTriggerFromEntryPrice,int distNewSLFromEntryPrice,double priceToReach=0){
   if(distTriggerFromEntryPrice <= 0)  return printErrorV("Errore valore per il Trigger in "+__FUNCTION__);
   
   double priceToMoveSL = PositionOpenPrice();
   if(PositionIsBuy()) priceToMoveSL +=   pointPosition(distNewSLFromEntryPrice);
   if(PositionIsSell()) priceToMoveSL -=  pointPosition(distNewSLFromEntryPrice);
   
   if(PositionProfitPoint() >= distTriggerFromEntryPrice) return PositionTrailingStopIndicator(0,priceToMoveSL,priceToReach);
   
   return false;
}


//+------------------------------------------------------------------+
//| Funzioni di TrailingStop per più ordini                          |
//+------------------------------------------------------------------+

// Vista la presenza del parametro priceToReach, è buona norma effettuare gli spostamenti con TrailingStop solo su un mercato alla volta, dunque richiamare la funzione PositionsTrailingStop una per ogni mercato
int PositionsTrailingStop(int distTS,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         nTS_effettuati += PositionTrailingStop(distTS,priceToReach); // Versione spaccone, in modo tale che il risultato booleano viene considerato come intero da aggiungere a nTS_effettuati
      }
   }
   return nTS_effettuati;
}

int PositionsTrailingStopToBE(int distTS,int bufferPointBE,string symbol="",ulong magic=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopToBE(distTS,bufferPointBE);
   return nTS_effettuati;
}

int PositionsTrailingStopFromBE(int distTS,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopFromBE(distTS,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopTriggerPrice(int distTS,double triggerPrice,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopTriggerPrice(distTS,triggerPrice,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopInStep(int distTS,int distStep,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopInStep(distTS,distStep,priceToReach);
   return nTS_effettuati;
}

//+------------------------------------------------------------------+
int PositionsTrailingStopOnCandle(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopOnCandle(typeCandle,indexCandle,timeframe,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopOnCandleBuy(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()) nTS_effettuati += PositionTrailingStopOnCandle(typeCandle,indexCandle,timeframe,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopOnCandleSell(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()) nTS_effettuati += PositionTrailingStopOnCandle(typeCandle,indexCandle,timeframe,priceToReach);
   return nTS_effettuati;
}

//+------------------------------------------------------------------+
int PositionsTrailingStopIndicator(int distTS,double priceIndicator,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopIndicator(distTS,priceIndicator,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopIndicatorBuy(int distTS,double priceIndicator,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()) nTS_effettuati += PositionTrailingStopIndicator(distTS,priceIndicator,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopIndicatorSell(int distTS,double priceIndicator,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()) nTS_effettuati += PositionTrailingStopIndicator(distTS,priceIndicator,priceToReach);
   return nTS_effettuati;
}

//+------------------------------------------------------------------+
int PositionsTrailingStopMA(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopMA(periodMA,index,timeframe,ma_method,applied_price,ma_shift,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopMABuy(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()) nTS_effettuati += PositionTrailingStopMA(periodMA,index,timeframe,ma_method,applied_price,ma_shift,priceToReach);
   return nTS_effettuati;
}

int PositionsTrailingStopMASell(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()) nTS_effettuati += PositionTrailingStopMA(periodMA,index,timeframe,ma_method,applied_price,ma_shift,priceToReach);
   return nTS_effettuati;
}

//+------------------------------------------------------------------+
int PositionsTrailingStopInStepSpecific(int distTriggerFromEntryPrice,int distNewSLFromEntryPrice,string symbol="",ulong magic=0,double priceToReach=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopInStepSpecific(distTriggerFromEntryPrice,distNewSLFromEntryPrice,priceToReach);
   return nTS_effettuati;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 20 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

bool HistoryDealSelectByTicket(ulong ticket){	ticketDealToWork = 	HistoryDealTicket(ticket);		return ticketDealToWork > 0;}
bool HistoryOrderSelectByTicket(ulong ticket){	ticketOrderToWork = 	HistoryOrderTicket(ticket);	return ticketOrderToWork > 0;}


//+------------------------------------------------------------------+
//| Funzioni ausiliarie per le chiusure parziali                     |
//+------------------------------------------------------------------+
bool DealIsPartialProfit(ulong dealTicket){
   if(HistoryDealSelectByTicket(dealTicket)) return DealIsPartialProfit();
   return false;
}

bool DealIsPartialProfit(){
	double volumeDeal = 	HistoryDealVolume();
	double volumeOrder = HistoryOrderVolume(HistoryDealPositionID());
	
	return volumeDeal != volumeOrder;
}


int PositionPartialProfitCount(ulong ticket){
   if(PositionSelectByTicket(ticket))	return PositionPartialProfitCount();
   return -1;
}

int PositionPartialProfitCount(){
   ulong ticketOriginalID = PositionTicket();
   int nPartial = 0;
   HistorySelect(PositionOpenTime(),TimeCurrent()); // Attenzione la selezione dello storico è stata cambiata; essere accorti quando si implementa il codice su questo elemento
   for(int i=0;i<HistoryDealsTotal();i++){
      if(HistoryDealSelectByPos(i) && HistoryDealEntry() == DEAL_ENTRY_OUT && HistoryDealPositionID() == ticketOriginalID){
         nPartial++;
      }
   }
   return nPartial;
}


//+------------------------------------------------------------------+
//| Funzioni principali per le chiusure parziali                     |
//+------------------------------------------------------------------+
// Il pointTrigger può essere sia positivo che negativo per chiusure parziali in perdita
// Il counter inizia da 1 in poi (ad esempio se counterPP è 3 vuol dire che il terzo target per i profitti parziali è impostato con i parametri passati in ingresso nella funzione)
bool PositionTakePartialProfits(ulong ticket,int pointTriggerPP,double lots_valuePP,int counterPP){
   if(PositionSelectByTicket(ticket)) return PositionTakePartialProfits(pointTriggerPP,lots_valuePP,counterPP);
   return false;
}

bool PositionTakePartialProfits(int pointTriggerPP,double lots_valuePP,int counterPP){
   int profitInPoint = PositionProfitPoint();
   if((pointTriggerPP > 0 && profitInPoint >= pointTriggerPP)  ||  (pointTriggerPP < 0 && profitInPoint <= pointTriggerPP))
      if(counterPP > PositionPartialProfitCount())  return PositionClose(lots_valuePP);
	
   return false;
}

bool PositionTakePartialProfitsPerc(ulong ticket,double rangePercPP,double profitPercPP,int counterPP){
   if(PositionSelectByTicket(ticket)) return PositionTakePartialProfitsPerc(rangePercPP,profitPercPP,counterPP);
   return false;
}
bool PositionTakePartialProfitsPerc(double rangePercPP,double profitPercPP,int counterPP){   
   if(rangePercPP <= 0 || rangePercPP >= 100 || PositionTakeProfit() == 0) return false;
   
   int distance_EntryTP =  distancePointPositionAbs(PositionOpenPrice(),PositionTakeProfit());
   int currentDistance =   PositionProfitPoint();
   
   if(currentDistance >= distance_EntryTP*rangePercPP/100.0)
      if(counterPP > PositionPartialProfitCount())  return PositionClosePartial(profitPercPP);
	
   return false;
}



//+------------------------------------------------------------------+
//| Funzioni di chiusura parziale per più posizioni (trades)         |
//+------------------------------------------------------------------+
// Ritorna il numero di chiusure parziali effettuate correttamente
int PositionsTakePartialProfits(int pointTriggerPP,double lots_valuePP,int counterPP,string symbol="ALL",ulong magic=0){
   int nChiusureParziali = 0;
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         nChiusureParziali += PositionTakePartialProfits(pointTriggerPP,lots_valuePP,counterPP) > 0; // Versione spaccone, in modo tale che il risultato booleano viene considerato come intero da aggiungere a nChiusureParziali
      }
   }
   return nChiusureParziali;
}

int PositionsTakePartialProfitsPerc(double rangePercPP,double profitPercPP,int counterPP,string symbol="ALL",ulong magic=0){
   int nChiusureParziali = 0;
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         nChiusureParziali += PositionTakePartialProfitsPerc(rangePercPP,profitPercPP,counterPP) > 0;
      }
   }
   return nChiusureParziali;
}

bool InTradingTime(int InpStartHour_,int InpStartMinute_,int InpEndHour_,int InpEndMinute_,char Fuso_,bool FusoEnable_)
  {
   if(FusoEnable_)
     {
      datetime Now = 0;
      if(Fuso_==0)
         Now=TimeGMT();
      if(Fuso_==1)
         Now=TimeLocal();
      if(Fuso_==2)
         Now=TimeTradeServer();
      MqlDateTime NowStruct;
      TimeToStruct(Now,NowStruct);
      int StartTradingSeconds = (InpStartHour_*3600) + (InpStartMinute_*60);
      int EndTradingSeconds = (InpEndHour_*3600) + (InpEndMinute_*60);
      int runningseconds = (NowStruct.hour*3600) + (NowStruct.min*60);
      ZeroMemory(NowStruct);
      //Print("FusoEnable: ",FusoEnable_," runningseconds ",runningseconds," StartTradingSeconds ",StartTradingSeconds," runningseconds ",runningseconds," EndTradingSeconds ",EndTradingSeconds);
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
  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 22 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

ulong SendOrderBuyStop(string symbol,double volume,double price,double sl,double tp,string comment,ulong magic,datetime expiration=0,bool verbose=true){
   return SendOrder(symbol,ORDER_TYPE_BUY_STOP,volume,price,0,0,sl,tp,comment,magic,expiration,verbose);
}
ulong SendOrderBuyLimit(string symbol,double volume,double price,double sl,double tp,string comment,ulong magic,datetime expiration=0,bool verbose=true){
   return SendOrder(symbol,ORDER_TYPE_BUY_LIMIT,volume,price,0,0,sl,tp,comment,magic,expiration,verbose);
}
ulong SendOrderSellStop(string symbol,double volume,double price,double sl,double tp,string comment,ulong magic,datetime expiration=0,bool verbose=true){
   return SendOrder(symbol,ORDER_TYPE_SELL_STOP,volume,price,0,0,sl,tp,comment,magic,expiration,verbose);
}
ulong SendOrderSellLimit(string symbol,double volume,double price,double sl,double tp,string comment,ulong magic,datetime expiration=0,bool verbose=true){
   return SendOrder(symbol,ORDER_TYPE_SELL_LIMIT,volume,price,0,0,sl,tp,comment,magic,expiration,verbose);
}

ulong SendOrderBuyStopInPoint(string symbol,double volume,int distPrice,int sl_point,int tp_point,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
	return SendTradeInPoint(symbol,ORDER_TYPE_BUY_STOP,volume,distPrice,0,0,sl_point,tp_point,comment,magic,expiration,verbose);
}
ulong SendOrderBuyLimitInPoint(string symbol,double volume,int distPrice,int sl_point,int tp_point,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
   return SendTradeInPoint(symbol,ORDER_TYPE_BUY_LIMIT,volume,distPrice,0,0,sl_point,tp_point,comment,magic,expiration,verbose);
}
ulong SendOrderBuyStopLimitInPoint(string symbol,double volume,int distPrice,int stoplimit,int sl_point,int tp_point,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
	return SendTradeInPoint(symbol,ORDER_TYPE_BUY_STOP_LIMIT,volume,distPrice,stoplimit,0,sl_point,tp_point,comment,magic,expiration,verbose);
}

ulong SendOrderSellStopInPoint(string symbol,double volume,int distPrice,int sl_point,int tp_point,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
   return SendTradeInPoint(symbol,ORDER_TYPE_SELL_STOP,volume,distPrice,0,0,sl_point,tp_point,comment,magic,expiration,verbose);
}
ulong SendOrderSellLimitInPoint(string symbol,double volume,int distPrice,int sl_point,int tp_point,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
   return SendTradeInPoint(symbol,ORDER_TYPE_SELL_LIMIT,volume,distPrice,0,0,sl_point,tp_point,comment,magic,expiration,verbose);
}
ulong SendOrderSellStopLimitInPoint(string symbol,double volume,int distPrice,int stoplimit,int sl_point,int tp_point,string comment="",ulong magic=0,datetime expiration=0,bool verbose=true){
   return SendTradeInPoint(symbol,ORDER_TYPE_SELL_STOP_LIMIT,volume,distPrice,stoplimit,0,sl_point,tp_point,comment,magic,expiration,verbose);
}


//+------------------------------------------------------------------+
bool IsStopLevelsAllowedBuyStop(double price,double sl,double tp,string symbol="",bool verbose=true){    							return IsStopLevelsAllowed(ORDER_TYPE_BUY_STOP,price,sl,tp,0,symbol,verbose);}
bool IsStopLevelsAllowedBuyLimit(double price,double sl,double tp,string symbol="",bool verbose=true){   							return IsStopLevelsAllowed(ORDER_TYPE_BUY_LIMIT,price,sl,tp,0,symbol,verbose);}
bool IsStopLevelsAllowedBuyStopLimit(double price,double sl,double tp,double slimit,string symbol="",bool verbose=true){   	return IsStopLevelsAllowed(ORDER_TYPE_BUY_STOP_LIMIT,price,sl,tp,slimit,symbol,verbose);}

bool IsStopLevelsAllowedSellStop(double price,double sl,double tp,string symbol="",bool verbose=true){   							return IsStopLevelsAllowed(ORDER_TYPE_SELL_STOP,price,sl,tp,0,symbol,verbose);}
bool IsStopLevelsAllowedSellLimit(double price,double sl,double tp,string symbol="",bool verbose=true){  							return IsStopLevelsAllowed(ORDER_TYPE_SELL_LIMIT,price,sl,tp,0,symbol,verbose);}
bool IsStopLevelsAllowedSellStopLimit(double price,double sl,double tp,double slimit,string symbol="",bool verbose=true){   	return IsStopLevelsAllowed(ORDER_TYPE_SELL_STOP_LIMIT,price,sl,tp,slimit,symbol,verbose);}


//+------------------------------------------------------------------+
int TradesTotalActive(string symbol="ALL",ulong magic=0){   return PositionsTotalAll(symbol,magic);}

int TradesTotalBuy(string symbol="ALL",ulong magic=0){    	return PositionsTotalBuy(symbol,magic);}
int TradesTotalSell(string symbol="ALL",ulong magic=0){   	return PositionsTotalSell(symbol,magic);}

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trailing Stops                                                   |
//+------------------------------------------------------------------+
bool TradeTrailingStop(ulong ticket,int distTS,double priceToReach=0){             return PositionTrailingStop(ticket,distTS,priceToReach);}
bool TradeTrailingStop(int distTS,double priceToReach=0){                        return PositionTrailingStop(distTS,priceToReach);}

bool TradeTrailingStopToBE(ulong ticket,int distTS,int bufferPointBE){             return PositionTrailingStopToBE(ticket,distTS,bufferPointBE);}
bool TradeTrailingStopToBE(int distTS,int bufferPointBE){                        return PositionTrailingStopToBE(distTS,bufferPointBE);}

bool TradeTrailingStopFromBE(ulong ticket,int distTS,double priceToReach=0){       return PositionTrailingStopFromBE(ticket,distTS,priceToReach);}
bool TradeTrailingStopFromBE(int distTS,double priceToReach=0){                  return PositionTrailingStopFromBE(distTS,priceToReach);}

bool TradeTrailingStopTriggerPrice(ulong ticket,int distTS,double triggerPrice,double priceToReach=0){  return PositionTrailingStopTriggerPrice(ticket,distTS,triggerPrice,priceToReach);}
bool TradeTrailingStopTriggerPrice(int distTS,double triggerPrice,double priceToReach=0){             return PositionTrailingStopTriggerPrice(distTS,triggerPrice,priceToReach);}

bool TradeTrailingStopInStep(ulong ticket,int distTS,int distStep,double priceToReach=0){               return PositionTrailingStopInStep(ticket,distTS,distStep,priceToReach);}
bool TradeTrailingStopInStep(int distTS,int distStep,double priceToReach=0){                          return PositionTrailingStopInStep(distTS,distStep,priceToReach);}

bool TradeTrailingStopOnCandle(ulong ticket,int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,double priceToReach=0){   return PositionTrailingStopOnCandle(ticket,typeCandle,indexCandle,timeframe,priceToReach);}
bool TradeTrailingStopOnCandle(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,double priceToReach=0){              return PositionTrailingStopOnCandle(typeCandle,indexCandle,timeframe,priceToReach);}


bool TradeTrailingStopIndicator(ulong ticket,int distTS,double priceIndicator,double priceToReach=0){   return PositionTrailingStopIndicator(ticket,distTS,priceIndicator,priceToReach);}
bool TradeTrailingStopIndicator(int distTS,double priceIndicator,double priceToReach=0){              return PositionTrailingStopIndicator(distTS,priceIndicator,priceToReach);}

bool TradeTrailingStopMA(ulong ticket,int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,double priceToReach=0){
   return PositionTrailingStopMA(ticket,periodMA,index,timeframe,ma_method,applied_price,ma_method,priceToReach);
}
bool TradeTrailingStopMA(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,double priceToReach=0){
   return PositionTrailingStopMA(periodMA,index,timeframe,ma_method,applied_price,ma_method,priceToReach);
}

bool TradeTrailingStopInStepSpecific(ulong ticket,int distTriggerFromEntryPrice,int distNewSLFromEntryPrice,double priceToReach=0){      return PositionTrailingStopInStepSpecific(ticket,distTriggerFromEntryPrice,distNewSLFromEntryPrice,priceToReach);}
bool TradeTrailingStopInStepSpecific(int distTriggerFromEntryPrice,int distNewSLFromEntryPrice,double priceToReach=0){                 return PositionTrailingStopInStepSpecific(distTriggerFromEntryPrice,distNewSLFromEntryPrice,priceToReach);}

//+------------------------------------------------------------------+
int TradesTrailingStop(int distTS,string symbol="",ulong magic=0,double priceToReach=0){       return PositionsTrailingStop(distTS,symbol,magic,priceToReach);}
int TradesTrailingStopToBE(int distTS,int bufferPointBE,string symbol="",ulong magic=0){       return PositionsTrailingStopToBE(distTS,bufferPointBE,symbol,magic);}
int TradesTrailingStopFromBE(int distTS,string symbol="",ulong magic=0,double priceToReach=0){ return PositionsTrailingStopFromBE(distTS,symbol,magic,priceToReach);}
int TradesTrailingStopTriggerPrice(int distTS,double triggerPrice,string symbol="",ulong magic=0,double priceToReach=0){     return PositionsTrailingStopTriggerPrice(distTS,triggerPrice,symbol,magic,priceToReach);}
int TradesTrailingStopInStep(int distTS,int distStep,string symbol="",ulong magic=0,double priceToReach=0){                  return PositionsTrailingStopInStep(distTS,distStep,symbol,magic,priceToReach);}

int TradesTrailingStopOnCandle(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,double priceToReach=0){      return PositionsTrailingStopOnCandle(typeCandle,indexCandle,timeframe,symbol,magic,priceToReach);}
int TradesTrailingStopOnCandleBuy(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,double priceToReach=0){   return PositionsTrailingStopOnCandleBuy(typeCandle,indexCandle,timeframe,symbol,magic,priceToReach);}
int TradesTrailingStopOnCandleSell(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,double priceToReach=0){  return PositionsTrailingStopOnCandleSell(typeCandle,indexCandle,timeframe,symbol,magic,priceToReach);}

int TradesTrailingStopIndicator(int distTS,double priceIndicator,string symbol="",ulong magic=0,double priceToReach=0){      return PositionsTrailingStopIndicator(distTS,priceIndicator,symbol,magic,priceToReach);}
int TradesTrailingStopIndicatorBuy(int distTS,double priceIndicator,string symbol="",ulong magic=0,double priceToReach=0){   return PositionsTrailingStopIndicatorBuy(distTS,priceIndicator,symbol,magic,priceToReach);}
int TradesTrailingStopIndicatorSell(int distTS,double priceIndicator,string symbol="",ulong magic=0,double priceToReach=0){  return PositionsTrailingStopIndicatorSell(distTS,priceIndicator,symbol,magic,priceToReach);}

int TradesTrailingStopMA(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,string symbol="",ulong magic=0,double priceToReach=0){
   return PositionsTrailingStopMA(periodMA,index,timeframe,ma_method,applied_price,ma_shift,symbol,magic,priceToReach);
}
int TradesTrailingStopMABuy(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,string symbol="",ulong magic=0,double priceToReach=0){
   return PositionsTrailingStopMABuy(periodMA,index,timeframe,ma_method,applied_price,ma_shift,symbol,magic,priceToReach);
}
int TradesTrailingStopMASell(int periodMA,int index,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,ENUM_MA_METHOD ma_method=MODE_EMA,ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE,int ma_shift=0,string symbol="",ulong magic=0,double priceToReach=0){
   return PositionsTrailingStopMASell(periodMA,index,timeframe,ma_method,applied_price,ma_shift,symbol,magic,priceToReach);
}

int TradesTrailingStopInStepSpecific(int distTriggerFromEntryPrice,int distNewSLFromEntryPrice,string symbol="",ulong magic=0,double priceToReach=0){      return PositionsTrailingStopInStepSpecific(distTriggerFromEntryPrice,distNewSLFromEntryPrice,symbol,magic,priceToReach);}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Chiusure parziali                                                |
//+------------------------------------------------------------------+
int TradePartialProfitCount(ulong ticket){	return PositionPartialProfitCount(ticket);}
int TradePartialProfitCount(){            	return PositionPartialProfitCount();}

int TradeTakePartialProfits(ulong ticket,int pointTriggerPP,double lots_valuePP,int counterPP){     	return PositionTakePartialProfits(ticket,pointTriggerPP,lots_valuePP,counterPP);}
int TradeTakePartialProfits(int pointTriggerPP,double lots_valuePP,int counterPP){                		return PositionTakePartialProfits(pointTriggerPP,lots_valuePP,counterPP);}

int TradeTakePartialProfitsPerc(ulong ticket,double rangePercPP,double profitPercPP,int counterPP){ 	return PositionTakePartialProfitsPerc(ticket,rangePercPP,profitPercPP,counterPP);}
int TradeTakePartialProfitsPerc(double rangePercPP,double profitPercPP,int counterPP){            		return PositionTakePartialProfitsPerc(rangePercPP,profitPercPP,counterPP);}

int TradesTakePartialProfits(int pointTriggerPP,double lots_valuePP,int counterPP,string symbol="ALL",ulong magic=0){   	return PositionsTakePartialProfits(pointTriggerPP,lots_valuePP,counterPP,symbol,magic);}
int TradesTakePartialProfitsPerc(double rangePercPP,double profitPercPP,int counterPP,string symbol="ALL",ulong magic=0){	return PositionsTakePartialProfitsPerc(rangePercPP,profitPercPP,counterPP,symbol,magic);}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 23 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| TrailingStop basato sulle candele fino a BE                      |
//+------------------------------------------------------------------+
bool PositionTrailingStopOnCandleToBE(ulong ticket,int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,int bufferPointBE=0){
   if(PositionSelectByTicket(ticket)) return PositionTrailingStopOnCandleToBE(typeCandle,indexCandle,timeframe,bufferPointBE);
   return false;
}

bool PositionTrailingStopOnCandleToBE(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,int bufferPointBE=0){
	double priceToReach = 0;
   if(PositionIsBuy())  priceToReach = PositionOpenPrice() + pointPosition(bufferPointBE);
   if(PositionIsSell()) priceToReach = PositionOpenPrice() - pointPosition(bufferPointBE);
   
   return PositionTrailingStopOnCandle(typeCandle,indexCandle,timeframe,priceToReach);

}

//+------------------------------------------------------------------+
int PositionsTrailingStopOnCandleToBE(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,int bufferPointBE=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)) nTS_effettuati += PositionTrailingStopOnCandleToBE(typeCandle,indexCandle,timeframe,bufferPointBE);
   return nTS_effettuati;
}

int PositionsTrailingStopOnCandleToBEBuy(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,int bufferPointBE=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsBuy()) nTS_effettuati += PositionTrailingStopOnCandleToBE(typeCandle,indexCandle,timeframe,bufferPointBE);
   return nTS_effettuati;
}

int PositionsTrailingStopOnCandleToBESell(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,int bufferPointBE=0){
   int nTS_effettuati = 0;
   for(int i=0;i<PositionsTotal();i++) if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic) && PositionIsSell()) nTS_effettuati += PositionTrailingStopOnCandleToBE(typeCandle,indexCandle,timeframe,bufferPointBE);
   return nTS_effettuati;
}

//+------------------------------------------------------------------+
int TradesTrailingStopOnCandleToBE(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,int bufferPointBE=0){      return PositionsTrailingStopOnCandleToBE(typeCandle,indexCandle,timeframe,symbol,magic,bufferPointBE);}
int TradesTrailingStopOnCandleToBEBuy(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,int bufferPointBE=0){   return PositionsTrailingStopOnCandleToBEBuy(typeCandle,indexCandle,timeframe,symbol,magic,bufferPointBE);}
int TradesTrailingStopOnCandleToBESell(int typeCandle=0,int indexCandle=1,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol="",ulong magic=0,int bufferPointBE=0){  return PositionsTrailingStopOnCandleToBESell(typeCandle,indexCandle,timeframe,symbol,magic,bufferPointBE);}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 24 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Funzioni di chiusura brutale rese compatili per MQL4/MQL5        |
//+------------------------------------------------------------------+
void brutalCloseTradesActiveBuy(string symbol="",ulong magic=0){		brutalCloseBuyPositions(symbol,magic);}
void brutalCloseTradesActiveSell(string symbol="",ulong magic=0){		brutalCloseSellPositions(symbol,magic);}
void brutalCloseTradesPendingBuy(string symbol="",ulong magic=0){		brutalCloseBuyOrders(symbol,magic);}
void brutalCloseTradesPendingSell(string symbol="",ulong magic=0){	brutalCloseSellOrders(symbol,magic);}
void brutalCloseTradesActive(string symbol="",ulong magic=0){			brutalCloseTradesActiveBuy(symbol,magic);  brutalCloseTradesActiveSell(symbol,magic);}
void brutalCloseTradesPending(string symbol="",ulong magic=0){			brutalCloseTradesPendingBuy(symbol,magic); brutalCloseTradesPendingSell(symbol,magic);}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 25 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool HistoryDealIsSymbolCurrent(ulong ticket){
   return StringIsEqual(HistoryDealSymbol(ticket),Symbol());
}
bool HistoryDealIsSymbolCurrent(){
   return HistoryDealIsSymbolCurrent(ticketDealToWork);
}

bool HistoryOrderIsSymbolCurrent(ulong ticket){
   return StringIsEqual(HistoryOrderSymbol(ticket),Symbol());
}
bool HistoryOrderIsSymbolCurrent(){
   return HistoryOrderIsSymbolCurrent(ticketOrderToWork);
}


//+------------------------------------------------------------------+
datetime timeEarliestTradeActive(string symbol="",ulong magic=0){
   datetime openTimeTmp = 0;
   
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         if(openTimeTmp == 0 || PositionOpenTime() < openTimeTmp)	openTimeTmp = PositionOpenTime();
      }
   }
   return openTimeTmp;
}

datetime timeEarliestTradeHistory(string symbol="",ulong magic=0){
   datetime openTimeTmp = 0;
   
   for(int i=0;i<HistoryDealsTotal();i++){
   	if(HistoryDealSelectByPos(i) && HistoryDealIsSymbol(symbol) && HistoryDealIsMagicNumber(magic)){
         if(openTimeTmp == 0 || HistoryDealTimeOpen() < openTimeTmp)	openTimeTmp = HistoryDealTimeOpen();
      }
   }
   return openTimeTmp;
}

datetime timeLatestTradeActive(string symbol="",ulong magic=0){
   datetime openTimeTmp = 0;
   
   for(int i=0;i<PositionsTotal();i++){
      if(PositionSelectByPos(i) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic)){
         if(PositionOpenTime() > openTimeTmp)	openTimeTmp = PositionOpenTime();
      }
   }
   return openTimeTmp;
}

datetime timeLatestTradeHistory(string symbol="",ulong magic=0){
   datetime openTimeTmp = 0;
   
   for(int i=0;i<HistoryDealsTotal();i++){
   	if(HistoryDealSelectByPos(i) && HistoryDealIsSymbol(symbol) && HistoryDealIsMagicNumber(magic)){
         if(HistoryDealTimeOpen() > openTimeTmp)	openTimeTmp = HistoryDealTimeOpen();
      }
   }
   return openTimeTmp;
}


//+------------------------------------------------------------------+
double TradeHighestOpenPrice(string symbol="",ulong magic=0){
   return PositionOpenPrice(ticketHighestBuyPosition(symbol,magic));
}

double TradeLowestOpenPrice(string symbol="",ulong magic=0){
   return PositionOpenPrice(ticketLowestSellPosition(symbol,magic));
}  