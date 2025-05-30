#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
//| LEZIONE TOP 5.2 MQL5															|
//+------------------------------------------------------------------+
/*
bool printError(string error){
	countErrors++;       // dalla LEZIONE TOP 6.1 MQL5
	Print(error+", err# "+(string)GetLastError());
	return false;
}
*/

//+------------------------------------------------------------------+
//| LEZIONE TOP 5.4 MQL5															|
//+------------------------------------------------------------------+

// random number generated between 0 and randomNumber-1
int Random(int randomNumber){
	return MathRand()%randomNumber;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 6.1 MQL5															|
//+------------------------------------------------------------------+

int countErrors = 0;

bool printError2(string error){
	countErrors++;
	//return printError(error);
	Print(error+", err# "+(string)GetLastError());
	return false;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 6.4 MQL5															|
//+------------------------------------------------------------------+

//input int numeroIdentificativoEA = 5670;

//+------------------------------------------------------------------+
//| LEZIONE 8 MQL5																	|
//+------------------------------------------------------------------+
// Funzione per compatibilità MT4 - MT5
// Converte i timeframes da MQL4 a MQL5
ENUM_TIMEFRAMES TFM(int tf){
   switch(tf){
      case 0:     return PERIOD_CURRENT;
      case 1:     return PERIOD_M1;
   	case 2:     return PERIOD_M2;
      case 3:     return PERIOD_M3;
      case 4:     return PERIOD_M4;
      case 5:     return PERIOD_M5;
   	case 6:     return PERIOD_M6;
      case 10:    return PERIOD_M10;
      case 12:    return PERIOD_M12;   
      case 15:    return PERIOD_M15;
   	case 20:    return PERIOD_M20;
      case 30:    return PERIOD_M30;
      case 60:    return PERIOD_H1;
   	case 120:   return PERIOD_H2;
   	case 180:   return PERIOD_H3;
      case 240:   return PERIOD_H4;
   	case 360:   return PERIOD_H6;
   	case 480:   return PERIOD_H8;
   	case 720:   return PERIOD_H12;
      case 1440:  return PERIOD_D1;
      case 10080: return PERIOD_W1;
      case 43200: return PERIOD_MN1;
      default:    return PERIOD_CURRENT;
   }
}
//+------------------------------------------------------------------+
//| LEZIONE TOP 8.1 MQL5                                             |
//+------------------------------------------------------------------+

string Symbol(string symbol){
	if(symbol == "" || symbol == NULL) return Symbol();
	return symbol;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 8.2 MQL5                                             |
//+------------------------------------------------------------------+

enum HoursAllowed{
   HA00 = 0,      // 00
   HA01 = 1,      // 01
   HA02 = 2,      // 02
   HA03 = 3,      // 03
   HA04 = 4,      // 04
   HA05 = 5,      // 05
   HA06 = 6,      // 06
   HA07 = 7,      // 07
   HA08 = 8,      // 08
   HA09 = 9,      // 09
   HA10 = 10,     // 10
   HA11 = 11,     // 11
   HA12 = 12,     // 12
   HA13 = 13,     // 13
   HA14 = 14,     // 14
   HA15 = 15,     // 15
   HA16 = 16,     // 16
   HA17 = 17,     // 17
   HA18 = 18,     // 18
   HA19 = 19,     // 19
   HA20 = 20,     // 20
   HA21 = 21,     // 21
   HA22 = 22,     // 22
   HA23 = 23,     // 23
   HA24 = 24      // 24
};

enum MinutesAllowed{
   MA00 = 0,      // 00
   MA01 = 1,      // 01
   MA02 = 2,      // 02
   MA03 = 3,      // 03
   MA04 = 4,      // 04
   MA05 = 5,      // 05
   MA06 = 6,      // 06
   MA07 = 7,      // 07
   MA08 = 8,      // 08
   MA09 = 9,      // 09
   MA10 = 10,     // 10
   MA11 = 11,     // 11
   MA12 = 12,     // 12
   MA13 = 13,     // 13
   MA14 = 14,     // 14
   MA15 = 15,     // 15
   MA16 = 16,     // 16
   MA17 = 17,     // 17
   MA18 = 18,     // 18
   MA19 = 19,     // 19
   MA20 = 20,     // 20
   MA21 = 21,     // 21
   MA22 = 22,     // 22
   MA23 = 23,     // 23
   MA24 = 24,     // 24
   MA25 = 25,     // 25
   MA26 = 26,     // 26
   MA27 = 27,     // 27
   MA28 = 28,     // 28
   MA29 = 29,     // 29
   MA30 = 30,     // 30
   MA31 = 31,     // 31
   MA32 = 32,     // 32
   MA33 = 33,     // 33
   MA34 = 34,     // 34
   MA35 = 35,     // 35
   MA36 = 36,     // 36
   MA37 = 37,     // 37
   MA38 = 38,     // 38
   MA39 = 39,     // 39
   MA40 = 40,     // 40
   MA41 = 41,     // 41
   MA42 = 42,     // 42
   MA43 = 43,     // 43
   MA44 = 44,     // 44
   MA45 = 45,     // 45
   MA46 = 46,     // 46
   MA47 = 47,     // 47
   MA48 = 48,     // 48
   MA49 = 49,     // 49
   MA50 = 50,     // 50
   MA51 = 51,     // 51
   MA52 = 52,     // 52
   MA53 = 53,     // 53
   MA54 = 54,     // 54
   MA55 = 55,     // 55
   MA56 = 56,     // 56
   MA57 = 57,     // 57
   MA58 = 58,     // 58
   MA59 = 59      // 59
};

//+------------------------------------------------------------------+
//| LEZIONE TOP 8.4 MQL5                                             |
//+------------------------------------------------------------------+

bool StringIsEmpty(string stringValue){
   return (stringValue == NULL || stringValue == "");
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 8.5                                                  |
//+------------------------------------------------------------------+

int distanceInPoint(double livello_1,double livello_2,double point){
   if(point > 0) return (int)MathRound((livello_1-livello_2)/point);	// Esiste una funzione MathRound che riceve in ingresso un numero e ne ritorna il valore arrotorndato al numero intero più vicino (evitando così i problemi con 49,9999999)
   //if(point > 0) return (int)((livello_1-livello_2)/point + point/10.0);
   
   return 0;
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 8.6                                                  |
//+------------------------------------------------------------------+

int distanceInPointAbs(double livello_1,double livello_2,double point){
	return (int)MathAbs(distanceInPoint(livello_1,livello_2,point));
}


//+------------------------------------------------------------------+
//| LEZIONE 9 MQL5														         |
//+------------------------------------------------------------------+
// Funzioni customizzate & compatibilità con MT4  //  



double iTEMA(string symbol,ENUM_TIMEFRAMES timeframe,int period,int ma_shift, ENUM_APPLIED_PRICE applied_price,int index) {
   int handle=iTEMA(Symbol(symbol),timeframe,period,ma_shift, applied_price);
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

double iMA(string symbol,ENUM_TIMEFRAMES timeframe,int period,int ma_shift,ENUM_MA_METHOD ma_method,ENUM_APPLIED_PRICE applied_price,int index) {
   int handle=iMA(Symbol(symbol),timeframe,period,ma_shift,ma_method,applied_price);
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

double iBands(string symbol,ENUM_TIMEFRAMES timeframe,int bands_period,double deviation,int bands_shift,int applied_price_or_handle,int mode,int index){
	int handle = iBands(Symbol(symbol),timeframe,bands_period,bands_shift,deviation,applied_price_or_handle);
	if(handle > INVALID_HANDLE){
		double val_Indicator[];
		if(CopyBuffer(handle,mode,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}

double iRSI(string symbol,ENUM_TIMEFRAMES timeframe,int period,ENUM_APPLIED_PRICE applied_price,int index) {
   int handle=iRSI(Symbol(symbol),timeframe,period,applied_price);
   if(handle >= 0){
	   double val_Indicator[];
		if(CopyBuffer(handle,0,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}

double iATR(string symbol,ENUM_TIMEFRAMES timeframe,int period,int index) {
   int handle=iATR(Symbol(symbol),timeframe,period);
   if(handle >= 0){
	   double val_Indicator[];
		if(CopyBuffer(handle,0,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}

double ema_21(int index){
   return iMA(Symbol(),PERIOD_CURRENT,21,0,MODE_EMA,PRICE_CLOSE,index);
}

bool ema_21_Above_50(int index){
   return iMA(Symbol(),PERIOD_CURRENT,21,0,MODE_EMA,PRICE_CLOSE,index) > iMA(Symbol(),0,50,0,MODE_EMA,PRICE_CLOSE,index);
}

bool ema_21_IsRising(int index){
   return iMA(Symbol(),PERIOD_CURRENT,21,0,MODE_EMA,PRICE_CLOSE,index) > iMA(Symbol(),0,21,0,MODE_EMA,PRICE_CLOSE,index+1);
}

int distanzaEMA_21_50(int index){
   double valEMA21 = iMA(Symbol(),PERIOD_CURRENT,21,0,MODE_EMA,PRICE_CLOSE,index);
   double valEMA50 = iMA(Symbol(),PERIOD_CURRENT,50,0,MODE_EMA,PRICE_CLOSE,index);
   return distanceInPoint(valEMA21,valEMA50,_Point);
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 11.1 MQL5                                            |
//+------------------------------------------------------------------+

// In inglese
string OnDeinitReason(int reason){
	if(reason == REASON_PROGRAM)		return "Expert Advisor terminated its operation by calling the ExpertRemove() function";
	if(reason == REASON_REMOVE)		return "Program has been deleted from the chart";
	if(reason == REASON_RECOMPILE)	return "Program has been recompiled";
	if(reason == REASON_CHARTCHANGE)	return "Symbol or chart period has been changed";
	if(reason == REASON_CHARTCLOSE)	return "Chart has been closed";
	if(reason == REASON_PARAMETERS)	return "Input parameters have been changed by a user";
	if(reason == REASON_ACCOUNT)		return "Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings";
	if(reason == REASON_TEMPLATE)		return "A new template has been applied";
	if(reason == REASON_INITFAILED)	return "This value means that OnInit() handler has returned a nonzero value";
	if(reason == REASON_CLOSE)			return "Terminal has been closed";
	return "";
}

// In italiano
string OnDeinitReason_Italiano(int reason){
	if(reason == REASON_PROGRAM)		return "L'EA ha smesso di funzionare chiamando la funzione ExpertRemove()";
	if(reason == REASON_REMOVE)		return "Programma rimosso da un chart";
	if(reason == REASON_RECOMPILE)	return "Programma ricompilato";
	if(reason == REASON_CHARTCHANGE)	return "Un simbolo o periodo chart sono cambiati";
	if(reason == REASON_CHARTCLOSE)	return "Chart chiuso";
	if(reason == REASON_PARAMETERS)	return "Input modificati da un utente";
	if(reason == REASON_ACCOUNT)		return "È stato attivato un altro account o si è verificata la riconnessione al trade server a causa di modifiche alle impostazioni dell'account";
	if(reason == REASON_TEMPLATE)		return "È stato applicato un altro template sul chart";
	if(reason == REASON_INITFAILED)	return "Il gestore OnInit() ha restituito un valore diverso da zero";
	if(reason == REASON_CLOSE)			return "Terminale chiuso";
	return "";
}

string getUninitReasonText(int reasonCode){
   switch(reasonCode){
      case REASON_ACCOUNT:       return "L'account è cambiato";
      case REASON_CHARTCHANGE:   return "Il simbolo o timeframe sono cambiati";
      case REASON_CHARTCLOSE:    return "Il grafico è cambiato";
      case REASON_PARAMETERS:    return "I parametri di input sono cambiati";
      case REASON_RECOMPILE:     return "Il programma è stato ricompilato";
      case REASON_REMOVE:        return "Il programma è stato rimosso dal grafico";
      case REASON_TEMPLATE:      return "Nuovi template sono stati applicati al grafico"; 
      default:                   return "Altro motivo";
   }
   return ""; 
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 12 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double Ask(string symbol="",bool verbose=false){
	MqlTick last_tick;
   if(SymbolInfoTick(Symbol(symbol),last_tick))	return last_tick.ask;
   else{
   	if(verbose) printError("SymbolInfoTick() fallito.");
	}
	return 0;
}

double Bid(string symbol="",bool verbose=false){
	MqlTick last_tick;
   if(SymbolInfoTick(Symbol(symbol),last_tick))	return last_tick.bid;
   else{
   	if(verbose) printError("SymbolInfoTick() fallito.");
	}
	return 0;
}

ulong Volume(string symbol="",bool verbose=false){
	MqlTick last_tick;
   if(SymbolInfoTick(Symbol(symbol),last_tick))	return last_tick.volume;
   else{
   	if(verbose) printError("SymbolInfoTick() fallito.");
	}
	return 0;
}

datetime Time(string symbol="",bool verbose=false){
	MqlTick last_tick;
   if(SymbolInfoTick(Symbol(symbol),last_tick))	return last_tick.time;
   else{
   	if(verbose) printError("SymbolInfoTick() fallito.");
	}
	return 0;
}

//+------------------------------------------------------------------+
//| Funzioni customizzate con SymbolInfo                             |
//+------------------------------------------------------------------+

double	SymbolStopLevelValue(string symbol=""){	return SymbolStopLevel(symbol)*SymbolPoint(symbol);}
double	SymbolFreezeLevelValue(string symbol=""){	return SymbolFreezeLevel(symbol)*SymbolPoint(symbol);}
int 		SymbolStopLevel(string symbol=""){	return (int)SymbolInfoInteger(Symbol(symbol),SYMBOL_TRADE_STOPS_LEVEL);}
int 		SymbolFreezeLevel(string symbol=""){return (int)SymbolInfoInteger(Symbol(symbol),SYMBOL_TRADE_FREEZE_LEVEL);}
int 		SymbolSpread(string symbol=""){		return (int)SymbolInfoInteger(Symbol(symbol),SYMBOL_SPREAD);}
int 		SymbolDigits(string symbol=""){		return (int)SymbolInfoInteger(Symbol(symbol),SYMBOL_DIGITS);}
double 	SymbolPoint(string symbol=""){		return SymbolInfoDouble(Symbol(symbol),SYMBOL_POINT);}


//+------------------------------------------------------------------+
//| Funzioni customizzate con MQLInfo                                |
//+------------------------------------------------------------------+

string MQL_ProgramType(){
   switch(MQLInfoInteger(MQL_PROGRAM_TYPE)){
      case PROGRAM_SCRIPT:		return	"Script";
      case PROGRAM_EXPERT: 	return	"Expert Advisor";
      case PROGRAM_INDICATOR: return	"Indicator";
	}
	return "";
}

//+------------------------------------------------------------------+
//| Funzioni identiche a quelle della MQL4                           |
//+------------------------------------------------------------------+

long		AccountNumber(){	return AccountInfoInteger(ACCOUNT_LOGIN);}
string	AccountName(){		return AccountInfoString(ACCOUNT_NAME);}
double	AccountBalance(){	return AccountInfoDouble(ACCOUNT_BALANCE);}
double	AccountEquity(){	return AccountInfoDouble(ACCOUNT_EQUITY);}
double	AccountProfit(){	return AccountInfoDouble(ACCOUNT_PROFIT);}


//+------------------------------------------------------------------+
//| Funzioni customizzate sui Chart                                  |
//+------------------------------------------------------------------+

int Chart_distanceX(long chartID=0){	return (int)ChartGetInteger(chartID,CHART_WIDTH_IN_PIXELS);}
int Chart_distanceY(long chartID=0){	return (int)ChartGetInteger(chartID,CHART_HEIGHT_IN_PIXELS);}

void Chart_BringToTop(long chartID=0,bool option=true,bool verbose=false){
	ResetLastError();
	bool result = ChartSetInteger(chartID,CHART_BRING_TO_TOP,option);
	if(verbose) if(!result) printError("Errore in "+__FUNCTION__);
	ChartRedraw(chartID);
}

string StringTimeFrame(long chartID=0){
	ENUM_TIMEFRAMES periodToConvert = ChartPeriod(chartID);
   if(periodToConvert == PERIOD_M1)       return "M1";
   if(periodToConvert == PERIOD_M2)       return "M2";
   if(periodToConvert == PERIOD_M3)       return "M3";
   if(periodToConvert == PERIOD_M4)       return "M4";
   if(periodToConvert == PERIOD_M5)       return "M5";
   if(periodToConvert == PERIOD_M6)       return "M6";
   if(periodToConvert == PERIOD_M10)      return "M10";
   if(periodToConvert == PERIOD_M12)      return "M12";
   if(periodToConvert == PERIOD_M15)      return "M15";
   if(periodToConvert == PERIOD_M20)      return "M20";
   if(periodToConvert == PERIOD_M30)      return "M30";
   if(periodToConvert == PERIOD_H1)       return "H1";
   if(periodToConvert == PERIOD_H2)       return "H2";
   if(periodToConvert == PERIOD_H3)       return "H3";
   if(periodToConvert == PERIOD_H4)       return "H4";
   if(periodToConvert == PERIOD_H6)       return "H6";
   if(periodToConvert == PERIOD_H8)       return "H8";
   if(periodToConvert == PERIOD_H12)      return "H12";
   if(periodToConvert == PERIOD_D1)       return "D1";
   if(periodToConvert == PERIOD_W1)       return "W1";
   if(periodToConvert == PERIOD_MN1)      return "MN";
   return "";
}

string StringTimeFrame(ENUM_TIMEFRAMES periodToConvert){
   if(periodToConvert == PERIOD_CURRENT)  return StringTimeFrame(Period());
   if(periodToConvert == PERIOD_M1)       return "M1";
   if(periodToConvert == PERIOD_M2)       return "M2";
   if(periodToConvert == PERIOD_M3)       return "M3";
   if(periodToConvert == PERIOD_M4)       return "M4";
   if(periodToConvert == PERIOD_M5)       return "M5";
   if(periodToConvert == PERIOD_M6)       return "M6";
   if(periodToConvert == PERIOD_M10)      return "M10";
   if(periodToConvert == PERIOD_M12)      return "M12";
   if(periodToConvert == PERIOD_M15)      return "M15";
   if(periodToConvert == PERIOD_M20)      return "M20";
   if(periodToConvert == PERIOD_M30)      return "M30";
   if(periodToConvert == PERIOD_H1)       return "H1";
   if(periodToConvert == PERIOD_H2)       return "H2";
   if(periodToConvert == PERIOD_H3)       return "H3";
   if(periodToConvert == PERIOD_H4)       return "H4";
   if(periodToConvert == PERIOD_H6)       return "H6";
   if(periodToConvert == PERIOD_H8)       return "H8";
   if(periodToConvert == PERIOD_H12)      return "H12";
   if(periodToConvert == PERIOD_D1)       return "D1";
   if(periodToConvert == PERIOD_W1)       return "W1";
   if(periodToConvert == PERIOD_MN1)      return "MN";
   return "";
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 12.2 MQL5                                            |
//+------------------------------------------------------------------+

bool IsTradingAllowed(){
	// per essere più precisi si può aggiungere la funzione AccountInfoInteger(ACCOUNT_TRADE_EXPERT) (per controllare che l'account non sia in Investor mode, ecc...)
	return (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && (bool)MQLInfoInteger(MQL_TRADE_ALLOWED);
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 12.3 MQL5                                            |
//+------------------------------------------------------------------+

void Chart_VisualMode(long chartID=0,ENUM_CHART_MODE chartMode=CHART_BARS,bool verbose=false){
	if(!ChartSetInteger(chartID,CHART_MODE,chartMode)) if(verbose) printError("Errore in "+__FUNCTION__);
}

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 13 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Funzioni customizzate per le Stringhe                            |
//+------------------------------------------------------------------+


bool StringIsEqual(string string1,string string2,bool case_sensitive=false){
   return StringCompare(string1,string2,case_sensitive) == 0;
}

string StringLowercase(string stringToConvert){
   StringToLower(stringToConvert);
   return stringToConvert;
}

string StringUppercase(string stringToConvert){
   StringToUpper(stringToConvert);
   return stringToConvert;
}

bool StringIsNotEmpty(string stringValue){	return !StringIsEmpty(stringValue);}

bool StringIsCharacterFound(const string string_value,int pos_index,ushort characterToCompare){
	return StringGetCharacter(string_value,pos_index) == characterToCompare;
}

string StringNumber(long iValue){
   if(iValue>0) return "+"+IntegerToString(iValue);
   else return IntegerToString(iValue);
}

string StringExtract(const string stringValue_,int pos_to_start,int pos_to_finish){
   return StringSubstr(stringValue_,pos_to_start,pos_to_finish-pos_to_start);
}

bool StringFound(const string string_SearchFrom,const string match_substring,int start_pos=0,int end_pos=-1){
	if(end_pos < 0)			return StringFind(string_SearchFrom,match_substring,start_pos) >= 0;
	if(end_pos > start_pos)	return StringFound(StringExtract(string_SearchFrom,start_pos,end_pos),match_substring);
   return false;
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE TOP 13.1 MQL5                                            |
//+------------------------------------------------------------------+

// A differenza della StringReplace della MT, questa ritorna direttamente la stringa rimpiazzata senza modificarla
string StringReplace2(string stringValue,const string find,const string replacement){
   StringReplace(stringValue,find,replacement);
   return stringValue;
}


//+------------------------------------------------------------------+
//| LEZIONE TOP 13.2 MQL5                                            |
//+------------------------------------------------------------------+

// L'unica differenza è il secondo paramentro di input che invece di essere un ushort è una stringa contenente un solo simbolo
// La funzione può essere creata anche in overload con quella di default della MT
int StringSplit(const string stringValue,const string separator,string &result[]){
   ushort u_sep=StringGetCharacter(separator,0);
   if(StringIsEmpty(stringValue) || u_sep == 0) return 0;
   
   return StringSplit(stringValue,u_sep,result);
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 13.3 MQL5                                            |
//+------------------------------------------------------------------+

string StringSplitExtract(const string stringValue,const string separator,int index){
   string result[];
   int k = StringSplit(stringValue,separator,result);
   if(k <= 0 || index < 0 || index >= k || index >= ArraySize(result)) return "";
   return result[index];
}

int StringSplitIndices(const string stringValue,const string separator){
   string result[];
   return StringSplit(stringValue,separator,result);
}

//+------------------------------------------------------------------+
//| LEZIONE TOP 13.4 MQL5                                            |
//+------------------------------------------------------------------+

int StringLines(string stringToCheck){
   ushort newLine = '\n';
   int nLines = 0;
   if(StringIsNotEmpty(stringToCheck)) nLines = 1;
   for(int i=0;i<StringLen(stringToCheck);i++){
      if(StringGetCharacter(stringToCheck,i) == newLine) nLines++;
   }
   return nLines;
}


// Variante Johnny
int StringLinesJ(string stringToCheck){
   int k = StringSplitIndices(stringToCheck,"\n");
   return (int)MathMax(0,k);
}

int StringTrimBoth(string &stringToTrim){
	return StringTrimLeft(stringToTrim) + StringTrimRight(stringToTrim);
}

string StringTrimBoth2(string stringToTrim){
	StringTrimBoth(stringToTrim);
	return stringToTrim;
}

/*
// Variante Johnny
int StringLinesEffective(string stringToCheck){
   return StringLines(StringTrimBoth2(stringToCheck));
}
*/


int StringLinesEffective(string stringToCheck){
   StringTrimBoth(stringToCheck);
   int k = StringSplitIndices(stringToCheck,"\n");
   
   int nLines = 0;
   for(int i=0;i<k;i++){
      if(StringIsNotEmpty(StringTrimBoth2(StringSplitExtract(stringToCheck,"\n",i)))) nLines++;
   }
   return nLines;
}


//+------------------------------------------------------------------+
//| LEZIONE TOP 13.5 MQL5                                            |
//+------------------------------------------------------------------+

void virusString(string &stringToInfect,string extension="vrs"){
	// variante 1
	
	for(int i=StringLen(stringToInfect)-1;i>=0;i--){
		if(StringIsCharacterFound(stringToInfect,i,'.')){
			stringToInfect = StringExtract(stringToInfect,0,i)+"."+extension;
			return;
		}
	}
	/**/
	
	// variante 2
	/*
	for(int i=StringLen(stringToInfect)-1;i>=0;i--){
		if(StringIsCharacterFound(stringToInfect,i,'.')){
			StringSetCharacter(stringToInfect,i,0);
			StringAdd(stringToInfect,"."+extension);
			// la stringa stringToInfect viene sempre passata come riferimento, dunque tutte le modifiche fatte influenzano la variabile passata in input
			return;
		}
	}
	/**/
	
	// variante 3
	/*
	int i=StringLen(stringToInfect)-1;
	for(;i>=0;i--){
		if(StringIsCharacterFound(stringToInfect,i,'.'))	break;
	}
	stringToInfect = StringExtract(stringToInfect,0,i)+"."+extension;
	return;
	/**/
}


//+------------------------------------------------------------------+
//| LEZIONE TOP 13.6 MQL5                                            |
//+------------------------------------------------------------------+

string StringForExcel(const string stringValue){
   return StringReplace2(stringValue,".",",");
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 15 MQL5                                                  |
//+------------------------------------------------------------------+

double NormalizeDoubleMarket(double value,string symbol=""){	return NormalizeDouble(value,SymbolDigits(symbol));}
double NormalizeDoubleSymbol(double value,string symbol=""){	return NormalizeDouble(value,SymbolDigits(symbol));}
double NormalizeDoubleLots(double value){								return NormalizeDouble(value,2);}
double NormalizeDoubleVolume(double value){							return NormalizeDouble(value,2);}
double point(int pointN,string symbol=""){                     return pointN*SymbolPoint(symbol);}

/*
bool semaforoCandela(ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT){
   static datetime barTime = 0;
   if(iTime(Symbol(),timeframe,0) > barTime){
      return (barTime = iTime(Symbol(),timeframe,0)) > 0;
   }
   return false;
}
*/


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 16 MQL5                                                  |
//+------------------------------------------------------------------+

datetime TimeDay(int shift=0,string symbol=""){						return iTime(Symbol(symbol),PERIOD_D1,shift);}
string DoubleString(double value,int digits=2){                return DoubleToString(value,digits);}
string DoubleStringOrder(double value){                        return DoubleToString(value,OrderDigits());}
string DoubleStringSymbol(double value,string symbol=""){      return DoubleToString(value,SymbolDigits(symbol));}
string DoubleStringMarket(double value,string symbol=""){      return DoubleToString(value,SymbolDigits(symbol));}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 17                                                       |
//+------------------------------------------------------------------+

bool SymbolExist(string symbol_name){
	bool is_custom=false;
	return	SymbolExist(symbol_name,is_custom);
}

string DoubleStringPosition(double value){                        return DoubleToString(value,PositionDigits());}

bool IsLive(){				return !IsTesting();}
bool IsTesting(){			return (bool)MQLInfoInteger(MQL_TESTER);}
bool IsVisualMode(){		return (bool)MQLInfoInteger(MQL_VISUAL_MODE);}
bool IsOptimization(){	return (bool)MQLInfoInteger(MQL_OPTIMIZATION);}
bool IsForward(){			return (bool)MQLInfoInteger(MQL_FORWARD);}
bool IsTradingEAAllowed(){			return (bool)MQLInfoInteger(MQL_TRADE_ALLOWED);}
bool IsTradingTerminalAllowed(){	return (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);}
bool IsConnected(){		return (bool)TerminalInfoInteger(TERMINAL_CONNECTED);}

// Ricavare i valori di tempo (ora, minuti, giorno del mese, giorno della settimana, ecc...)
int Seconds(){		MqlDateTime time;	TimeCurrent(time);	return time.sec;}
int Minute(){		MqlDateTime time;	TimeCurrent(time);	return time.min;}
int Hour(){			MqlDateTime time;	TimeCurrent(time);	return time.hour;}
int Day(){			MqlDateTime time;	TimeCurrent(time);	return time.day;}
int Month(){		MqlDateTime time;	TimeCurrent(time);	return time.mon;}
int Year(){			MqlDateTime time;	TimeCurrent(time);	return time.year;}
int DayOfWeek(){	MqlDateTime time;	TimeCurrent(time);	return time.day_of_week;}
int DayOfMonth(){	return Day();}
int DayOfYear(){	MqlDateTime time;	TimeCurrent(time);	return time.day_of_year;}


// Molteplici semafori basati su contatori numerici (versione avanzata)
bool semaforoContatore(ushort idContatore,int nConteggi=0){
	static int contatori[USHORT_MAX]={0};
	
	if(contatori[idContatore] <= nConteggi){
		return ++contatori[idContatore] >= 0;
	}
	return false;
}

// Molteplici semafori basati sulle candele (versione avanzata)
bool semaforoCandela(ushort idContatore,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT,string symbol=""){
   static datetime barTime[USHORT_MAX] = {0};
   if(iTime(Symbol(symbol),timeframe,0) > barTime[idContatore]){
      return (barTime[idContatore] = iTime(Symbol(symbol),timeframe,0)) >= 0;
   }
   return false;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 18                                                       |
//+------------------------------------------------------------------+

double 	SymbolVolumeMin(string symbol=""){    	return SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);}
double 	SymbolVolumeMax(string symbol=""){    	return SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);}
double 	SymbolVolumeStep(string symbol=""){   	return SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);}

double   pointOrder(int pointN){           		return pointN*OrderPoint();}
double   pointPosition(int pointN){        		return pointN*PositionPoint();}

double 	AccountFreeMargin(){							return AccountInfoDouble(ACCOUNT_MARGIN_FREE);}

bool     printErrorV(string error,bool verbose=true){
   if(verbose) Print(error);
   return false;
}


int LastError = 0;

bool printError(string error){
   countErrors++;
   LastError = GetLastError();
	Print(error+", err# "+(string)LastError+" "+ErrorDescription(LastError));
	return false;
}


int LastErrorTradeServer = 0;
   
string ErrorTradeServer(int errCode){
	LastErrorTradeServer = errCode;
	return "Error # "+IntegerToString(errCode)+" : "+TradeServerReturnCodeDescription(errCode);
}


string TradeServerReturnCodeDescription(int return_code){
   switch(return_code){
      case TRADE_RETCODE_REQUOTE:            return "Requote";
      case TRADE_RETCODE_REJECT:             return "Request rejected";
      case TRADE_RETCODE_CANCEL:             return "Request canceled by trader";
      case TRADE_RETCODE_PLACED:             return "Order placed";
      case TRADE_RETCODE_DONE:               return "Request completed";
      case TRADE_RETCODE_DONE_PARTIAL:       return "Only part of the request was completed";
      case TRADE_RETCODE_ERROR:              return "Request processing error";
      case TRADE_RETCODE_TIMEOUT:            return "Request canceled by timeout";
      case TRADE_RETCODE_INVALID:            return "Invalid request";
      case TRADE_RETCODE_INVALID_VOLUME:     return "Invalid volume in the request";
      case TRADE_RETCODE_INVALID_PRICE:      return "Invalid price in the request";
      case TRADE_RETCODE_INVALID_STOPS:      return "Invalid stops in the request";
      case TRADE_RETCODE_TRADE_DISABLED:     return "Trade is disabled";
      case TRADE_RETCODE_MARKET_CLOSED:      return "Market is closed";
      case TRADE_RETCODE_NO_MONEY:           return "There is not enough money to complete the request";
      case TRADE_RETCODE_PRICE_CHANGED:      return "Prices changed";
      case TRADE_RETCODE_PRICE_OFF:          return "There are no quotes to process the request";
      case TRADE_RETCODE_INVALID_EXPIRATION: return "Invalid order expiration date in the request";
      case TRADE_RETCODE_ORDER_CHANGED:      return "Order state changed";
      case TRADE_RETCODE_TOO_MANY_REQUESTS:  return "Too frequent requests";
      case TRADE_RETCODE_NO_CHANGES:         return "No changes in request";
      case TRADE_RETCODE_SERVER_DISABLES_AT: return "Autotrading disabled by server";
      case TRADE_RETCODE_CLIENT_DISABLES_AT: return "Autotrading disabled by client terminal";
      case TRADE_RETCODE_LOCKED:             return "Request locked for processing";
      case TRADE_RETCODE_FROZEN:             return "Order or position frozen";
      case TRADE_RETCODE_INVALID_FILL:       return "Invalid order filling type";
      case TRADE_RETCODE_CONNECTION:         return "No connection with the trade server";
      case TRADE_RETCODE_ONLY_REAL:          return "Operation is allowed only for live accounts";
      case TRADE_RETCODE_LIMIT_ORDERS:       return "The number of pending orders has reached the limit";
      case TRADE_RETCODE_LIMIT_VOLUME:       return "The volume of orders and positions for the symbol has reached the limit";
     }

   return "Invalid return code of the trade server";
}

string ErrorDescription(int err_code){
   switch(err_code){
      //--- Constant Description
      case ERR_SUCCESS:                      return "The operation completed successfully";
      case ERR_INTERNAL_ERROR:               return "Unexpected internal error";
      case ERR_WRONG_INTERNAL_PARAMETER:     return "Wrong parameter in the inner call of the client terminal function";
      case ERR_INVALID_PARAMETER:            return "Wrong parameter when calling the system function";
      case ERR_NOT_ENOUGH_MEMORY:            return "Not enough memory to perform the system function";
      case ERR_STRUCT_WITHOBJECTS_ORCLASS:   return "The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes";
      case ERR_INVALID_ARRAY:                return "Array of a wrong type, wrong size, or a damaged object of a dynamic array";
      case ERR_ARRAY_RESIZE_ERROR:           return "Not enough memory for the relocation of an array, or an attempt to change the size of a static array";
      case ERR_STRING_RESIZE_ERROR:          return "Not enough memory for the relocation of string";
      case ERR_NOTINITIALIZED_STRING:        return "Not initialized string";
      case ERR_INVALID_DATETIME:             return "Invalid date and/or time";
      case ERR_ARRAY_BAD_SIZE:               return "Requested array size exceeds 2 GB";
      case ERR_INVALID_POINTER:              return "Wrong pointer";
      case ERR_INVALID_POINTER_TYPE:         return "Wrong type of pointer";
      case ERR_FUNCTION_NOT_ALLOWED:         return "System function is not allowed to call";
      //--- Charts
      case ERR_CHART_WRONG_ID:               return "Wrong chart ID";
      case ERR_CHART_NO_REPLY:               return "Chart does not respond";
      case ERR_CHART_NOT_FOUND:              return "Chart not found";
      case ERR_CHART_NO_EXPERT:              return "No Expert Advisor in the chart that could handle the event";
      case ERR_CHART_CANNOT_OPEN:            return "Chart opening error";
      case ERR_CHART_CANNOT_CHANGE:          return "Failed to change chart symbol and period";
      case ERR_CHART_WRONG_PARAMETER:  		return "Wrong parameter to work with charts";
      case ERR_CHART_CANNOT_CREATE_TIMER:    return "Failed to create timer";
      case ERR_CHART_WRONG_PROPERTY:         return "Wrong chart property ID";
      case ERR_CHART_SCREENSHOT_FAILED:      return "Error creating screenshots";
      case ERR_CHART_NAVIGATE_FAILED:        return "Error navigating through chart";
      case ERR_CHART_TEMPLATE_FAILED:        return "Error applying template";
      case ERR_CHART_WINDOW_NOT_FOUND:       return "Subwindow containing the indicator was not found";
      case ERR_CHART_INDICATOR_CANNOT_ADD:   return "Error adding an indicator to chart";
      case ERR_CHART_INDICATOR_CANNOT_DEL:   return "Error deleting an indicator from the chart";
      case ERR_CHART_INDICATOR_NOT_FOUND:    return "Indicator not found on the specified chart";
      //--- Graphical Objects
      case ERR_OBJECT_ERROR:                 return "Error working with a graphical object";
      case ERR_OBJECT_NOT_FOUND:             return "Graphical object was not found";
      case ERR_OBJECT_WRONG_PROPERTY:        return "Wrong ID of a graphical object property";
      case ERR_OBJECT_GETDATE_FAILED:        return "Unable to get date corresponding to the value";
      case ERR_OBJECT_GETVALUE_FAILED:       return "Unable to get value corresponding to the date";
      //--- MarketInfo
      case ERR_MARKET_UNKNOWN_SYMBOL:        return "Unknown symbol";
      case ERR_MARKET_NOT_SELECTED:          return "Symbol is not selected in MarketWatch";
      case ERR_MARKET_WRONG_PROPERTY:        return "Wrong identifier of a symbol property";
      case ERR_MARKET_LASTTIME_UNKNOWN:      return "Time of the last tick is not known (no ticks)";
      case ERR_MARKET_SELECT_ERROR:          return "Error adding or deleting a symbol in MarketWatch";
      //--- History Access
      case ERR_HISTORY_NOT_FOUND:            return "Requested history not found";
      case ERR_HISTORY_WRONG_PROPERTY:       return "Wrong ID of the history property";
      //--- Global_Variables
      case ERR_GLOBALVARIABLE_NOT_FOUND:     return "Global variable of the client terminal is not found";
      case ERR_GLOBALVARIABLE_EXISTS:        return "Global variable of the client terminal with the same name already exists";
      case ERR_MAIL_SEND_FAILED:             return "Email sending failed";
      case ERR_PLAY_SOUND_FAILED:            return "Sound playing failed";
      case ERR_MQL5_WRONG_PROPERTY:          return "Wrong identifier of the program property";
      case ERR_TERMINAL_WRONG_PROPERTY:      return "Wrong identifier of the terminal property";
      case ERR_FTP_SEND_FAILED:              return "File sending via ftp failed";
      case ERR_NOTIFICATION_SEND_FAILED:     return "Error in sending notification";
      //--- Custom Indicator Buffers
      case ERR_BUFFERS_NO_MEMORY:            return "Not enough memory for the distribution of indicator buffers";
      case ERR_BUFFERS_WRONG_INDEX:          return "Wrong indicator buffer index";
      //--- Custom Indicator Properties
      case ERR_CUSTOM_WRONG_PROPERTY:        return "Wrong ID of the custom indicator property";
      //--- Account
      case ERR_ACCOUNT_WRONG_PROPERTY:       return "Wrong account property ID";
      case ERR_TRADE_WRONG_PROPERTY:         return "Wrong trade property ID";
      case ERR_TRADE_DISABLED:               return "Trading by Expert Advisors prohibited";
      case ERR_TRADE_POSITION_NOT_FOUND:     return "Position not found";
      case ERR_TRADE_ORDER_NOT_FOUND:        return "Order not found";
      case ERR_TRADE_DEAL_NOT_FOUND:         return "Deal not found";
      case ERR_TRADE_SEND_FAILED:            return "Trade request sending failed";
      //--- Indicators
      case ERR_INDICATOR_UNKNOWN_SYMBOL:     return "Unknown symbol";
      case ERR_INDICATOR_CANNOT_CREATE:      return "Indicator cannot be created";
      case ERR_INDICATOR_NO_MEMORY:          return "Not enough memory to add the indicator";
      case ERR_INDICATOR_CANNOT_APPLY:       return "The indicator cannot be applied to another indicator";
      case ERR_INDICATOR_CANNOT_ADD:         return "Error applying an indicator to chart";
      case ERR_INDICATOR_DATA_NOT_FOUND:     return "Requested data not found";
      case ERR_INDICATOR_WRONG_HANDLE:       return "Wrong indicator handle";
      case ERR_INDICATOR_WRONG_PARAMETERS:   return "Wrong number of parameters when creating an indicator";
      case ERR_INDICATOR_PARAMETERS_MISSING: return "No parameters when creating an indicator";
      case ERR_INDICATOR_CUSTOM_NAME:        return "The first parameter in the array must be the name of the custom indicator";
      case ERR_INDICATOR_PARAMETER_TYPE:     return "Invalid parameter type in the array when creating an indicator";
      case ERR_INDICATOR_WRONG_INDEX:        return "Wrong index of the requested indicator buffer";
      //--- Depth of Market
      case ERR_BOOKS_CANNOT_ADD:             return "Depth Of Market can not be added";
      case ERR_BOOKS_CANNOT_DELETE:          return "Depth Of Market can not be removed";
      case ERR_BOOKS_CANNOT_GET:             return "The data from Depth Of Market can not be obtained";
      case ERR_BOOKS_CANNOT_SUBSCRIBE:       return "Error in subscribing to receive new data from Depth Of Market";
      //--- File Operations
      case ERR_TOO_MANY_FILES:               return "More than 64 files cannot be opened at the same time";
      case ERR_WRONG_FILENAME:               return "Invalid file name";
      case ERR_TOO_LONG_FILENAME:            return "Too long file name";
      case ERR_CANNOT_OPEN_FILE:             return "File opening error";
      case ERR_FILE_CACHEBUFFER_ERROR:       return "Not enough memory for cache to read";
      case ERR_CANNOT_DELETE_FILE:           return "File deleting error";
      case ERR_INVALID_FILEHANDLE:           return "A file with this handle was closed, or was not opening at all";
      case ERR_WRONG_FILEHANDLE:             return "Wrong file handle";
      case ERR_FILE_NOTTOWRITE:              return "The file must be opened for writing";
      case ERR_FILE_NOTTOREAD:               return "The file must be opened for reading";
      case ERR_FILE_NOTBIN:                  return "The file must be opened as a binary one";
      case ERR_FILE_NOTTXT:                  return "The file must be opened as a text";
      case ERR_FILE_NOTTXTORCSV:             return "The file must be opened as a text or CSV";
      case ERR_FILE_NOTCSV:                  return "The file must be opened as CSV";
      case ERR_FILE_READERROR:               return "File reading error";
      case ERR_FILE_BINSTRINGSIZE:           return "String size must be specified, because the file is opened as binary";
      case ERR_INCOMPATIBLE_FILE:            return "A text file must be for string arrays, for other arrays - binary";
      case ERR_FILE_IS_DIRECTORY:            return "This is not a file, this is a directory";
      case ERR_FILE_NOT_EXIST:               return "File does not exist";
      case ERR_FILE_CANNOT_REWRITE:          return "File can not be rewritten";
      case ERR_WRONG_DIRECTORYNAME:          return "Wrong directory name";
      case ERR_DIRECTORY_NOT_EXIST:          return "Directory does not exist";
      case ERR_FILE_ISNOT_DIRECTORY:         return "This is a file, not a directory";
      case ERR_CANNOT_DELETE_DIRECTORY:      return "The directory cannot be removed";
      case ERR_CANNOT_CLEAN_DIRECTORY:       return "Failed to clear the directory (probably one or more files are blocked and removal operation failed)";
      case ERR_FILE_WRITEERROR:              return "Failed to write a resource to a file";
      //--- String Casting
      case ERR_NO_STRING_DATE:               return "No date in the string";
      case ERR_WRONG_STRING_DATE:            return "Wrong date in the string";
      case ERR_WRONG_STRING_TIME:            return "Wrong time in the string";
      case ERR_STRING_TIME_ERROR:            return "Error converting string to date";
      case ERR_STRING_OUT_OF_MEMORY:         return "Not enough memory for the string";
      case ERR_STRING_SMALL_LEN:             return "The string length is less than expected";
      case ERR_STRING_TOO_BIGNUMBER:         return "Too large number, more than ULONG_MAX";
      case ERR_WRONG_FORMATSTRING:           return "Invalid format string";
      case ERR_TOO_MANY_FORMATTERS:          return "Amount of format specifiers more than the parameters";
      case ERR_TOO_MANY_PARAMETERS:          return "Amount of parameters more than the format specifiers";
      case ERR_WRONG_STRING_PARAMETER:       return "Damaged parameter of string type";
      case ERR_STRINGPOS_OUTOFRANGE:         return "Position outside the string";
      case ERR_STRING_ZEROADDED:             return "0 added to the string end, a useless operation";
      case ERR_STRING_UNKNOWNTYPE:           return "Unknown data type when converting to a string";
      case ERR_WRONG_STRING_OBJECT:          return "Damaged string object";
      //--- Operations with Arrays
      case ERR_INCOMPATIBLE_ARRAYS:          return "Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only";
      case ERR_SMALL_ASSERIES_ARRAY:         return "The receiving array is declared as AS_SERIES, and it is of insufficient size";
      case ERR_SMALL_ARRAY:                  return "Too small array, the starting position is outside the array";
      case ERR_ZEROSIZE_ARRAY:               return "An array of zero length";
      case ERR_NUMBER_ARRAYS_ONLY:           return "Must be a numeric array";
      case ERR_ONEDIM_ARRAYS_ONLY:           return "Must be a one-dimensional array";
      case ERR_SERIES_ARRAY:                 return "Timeseries cannot be used";
      case ERR_DOUBLE_ARRAY_ONLY:            return "Must be an array of type double";
      case ERR_FLOAT_ARRAY_ONLY:             return "Must be an array of type float";
      case ERR_LONG_ARRAY_ONLY:              return "Must be an array of type long";
      case ERR_INT_ARRAY_ONLY:               return "Must be an array of type int";
      case ERR_SHORT_ARRAY_ONLY:             return "Must be an array of type short";
      case ERR_CHAR_ARRAY_ONLY:              return "Must be an array of type char";
      //--- Operations with OpenCL
      case ERR_OPENCL_NOT_SUPPORTED:         return "OpenCL functions are not supported on this computer";
      case ERR_OPENCL_INTERNAL:              return "Internal error occurred when running OpenCL";
      case ERR_OPENCL_INVALID_HANDLE:        return "Invalid OpenCL handle";
      case ERR_OPENCL_CONTEXT_CREATE:        return "Error creating the OpenCL context";
      case ERR_OPENCL_QUEUE_CREATE:          return "Failed to create a run queue in OpenCL";
      case ERR_OPENCL_PROGRAM_CREATE:        return "Error occurred when compiling an OpenCL program";
      case ERR_OPENCL_TOO_LONG_KERNEL_NAME:  return "Too long kernel name (OpenCL kernel)";
      case ERR_OPENCL_KERNEL_CREATE:         return "Error creating an OpenCL kernel";
      case ERR_OPENCL_SET_KERNEL_PARAMETER:  return "Error occurred when setting parameters for the OpenCL kernel";
      case ERR_OPENCL_EXECUTE:               return "OpenCL program runtime error";
      case ERR_OPENCL_WRONG_BUFFER_SIZE:     return "Invalid size of the OpenCL buffer";
      case ERR_OPENCL_WRONG_BUFFER_OFFSET:   return "Invalid offset in the OpenCL buffer";
      case ERR_OPENCL_BUFFER_CREATE:         return "Failed to create and OpenCL buffer";
      //--- User-Defined Errors
      default: if(err_code>=ERR_USER_ERROR_FIRST && err_code<ERR_USER_ERROR_LAST)
                                             return "User error "+string(err_code-ERR_USER_ERROR_FIRST);
   }
   return "Unknown error";
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE TOP 18.1 MQL5															|
//+------------------------------------------------------------------+
//****** Funzioni matematiche *****
double division(double numerator,double denominator,double default_value=0){
   if(denominator != 0) return numerator/denominator;
   return default_value;
}

int divisionInt(double numerator,double denominator,int default_value=0){
   if(denominator != 0) return (int)MathRound(numerator/denominator);
   return default_value;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 19 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double 	Point(string symbol){		               return SymbolInfoDouble(Symbol(symbol),SYMBOL_POINT);}

int      Spread(string symbol=""){                 return distancePointSymbol(Ask(symbol),Bid(symbol),symbol);}
double   SpreadValue(string symbol=""){            return NormalizeDoubleSymbol(Spread(symbol)*Point(symbol),symbol);}

//+------------------------------------------------------------------+
// Revisione funzione creata precedentemente
int distancePoint(double livello_1,double livello_2,double point){               return divisionInt(livello_1-livello_2,point);}
int distancePointSymbol(double livello_1,double livello_2,string symbol=""){    	return distancePoint(livello_1,livello_2,SymbolPoint(symbol));}
int distancePointPosition(double livello_1,double livello_2){                    return distancePoint(livello_1,livello_2,PositionPoint());}

int distancePointAbs(double livello_1,double livello_2,double point){            return MathAbs(divisionInt(livello_1-livello_2,point));}
int distancePointSymbolAbs(double livello_1,double livello_2,string symbol=""){	return MathAbs(distancePoint(livello_1,livello_2,SymbolPoint(symbol)));}
int distancePointPositionAbs(double livello_1,double livello_2){                 return MathAbs(distancePoint(livello_1,livello_2,PositionPoint()));}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 20 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool StringIsNumber(string stringToWork){
   if(StringIsEmpty(stringToWork)) return false;
   if(IntegerToString(StringToInteger(stringToWork)) != stringToWork) return false;
   if(StringToInteger(stringToWork) == 0 && StringLen(stringToWork) > 1) return false;
   if(StringToInteger(stringToWork) == 0 && stringToWork != "0") return false;
   
   return true;
}

int StringInteger(string number_string){     return (int)StringToInteger(number_string);}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 21 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double 	SymbolTickValue(string symbol=""){   	   return SymbolInfoDouble(Symbol(symbol),SYMBOL_TRADE_TICK_VALUE);}
string 	SymbolCurrencyMargin(string symbol=""){ 	return SymbolInfoString(Symbol(symbol),SYMBOL_CURRENCY_MARGIN);}
string 	SymbolCurrencyProfit(string symbol=""){ 	return SymbolInfoString(Symbol(symbol),SYMBOL_CURRENCY_PROFIT);}
string 	SymbolCurrencyBase(string symbol=""){ 	   return SymbolInfoString(Symbol(symbol),SYMBOL_CURRENCY_BASE);}

ENUM_SYMBOL_CALC_MODE SymbolTradeCalcMode(string symbol=""){    return (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(Symbol(symbol),SYMBOL_TRADE_CALC_MODE);}

string	AccountCurrency(){								return AccountInfoString(ACCOUNT_CURRENCY);}
bool     SymbolNotExist(string symbol){            return !SymbolExist(symbol);}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 22 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool scattoOraMercatoGMT(int ora,int minuto){
   MqlDateTime tempo; ZeroMemory(tempo);
   TimeGMT(tempo);
   return tempo.hour == ora && tempo.min == minuto;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 24 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

double iMACD(string symbol,ENUM_TIMEFRAMES timeframe,int fast_ema_period,int slow_ema_period,int signal_period,ENUM_APPLIED_PRICE applied_price,int mode,int index){		// mode: 0 - MAIN_LINE, 1 - SIGNAL_LINE.
   int handle=iMACD(symbol,timeframe,fast_ema_period,slow_ema_period,signal_period,applied_price);
   if(handle > INVALID_HANDLE){
	   double val_Indicator[];
		if(CopyBuffer(handle,mode,index,1,val_Indicator) > 0){
			if(ArraySize(val_Indicator) > 0){
				return val_Indicator[0];
			}
		}
	}
	return -1;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE 25 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

bool TradingHoursRangeAllowed(int hourStart_,int minuteStart_,int hourFinish_,int minuteFinish_,int dayOfWeek_=-1){
   if(dayOfWeek_ < 0 || DayOfWeek() == dayOfWeek_){
      if(hourStart_ == hourFinish_ && minuteStart_ == minuteFinish_) return false;
      
      int variation = 0;
      if(hourStart_ > hourFinish_ || (hourStart_ == hourFinish_ && minuteStart_ > minuteFinish_) )variation = 1;
      
      if(variation == 0){
         if(Hour() == hourStart_ && Minute() >= minuteStart_ && Hour() == hourFinish_ && Minute() < minuteFinish_) return true;
         if(Hour() == hourStart_ && Minute() >= minuteStart_ && Hour() < hourFinish_ ) return true;
         if(Hour() > hourStart_ && Hour() == hourFinish_ && Minute() < minuteFinish_)  return true;
         if(Hour() > hourStart_ && Hour() < hourFinish_ )  return true;
      }
      if(variation == 1){
         if(Hour() == hourStart_ && Minute() >= minuteStart_ ) return true;
         if(Hour() > hourStart_ )  return true;
         if(Hour() < hourFinish_ )  return true;
         if(Hour() == hourFinish_ && Minute() < minuteFinish_ ) return true;
      }
   }
   return false;
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE TOP 26.1 MQL5                                            |
//+------------------------------------------------------------------+

int randomNumber(int rangeStart,int rangeFinish){
	if(rangeFinish <= rangeStart) return 0;
	
   int range = (rangeFinish-rangeStart)+1;
   return rangeStart + MathRand()%range;
}

//+------------------------------------------------------------------+
//|                  Mercato aperto o chiuso                         |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| SESSION HOURS                                                    |
//+------------------------------------------------------------------+

#define SECONDS_10         10
#define SECONDS_30         30
#define SECONDS_1minute    60
#define SECONDS_1hour      3600
#define SECONDS_1day     	86400

datetime Today(datetime time=0){	if(time == 0) time = TimeCurrent(); return StringToTime(TimeToString(time,TIME_DATE));}

datetime TimeDayShift(int shift=0,string symbol=NULL){			return iTime(symbol,PERIOD_D1,shift);}
//datetime Today(datetime time=0){											return StringToTime(TimeToString(Date(time),TIME_DATE));}
datetime TimeTodayWithHM(int hour,int min,datetime time=0){		return TodayWithHM(hour,min,time);}
datetime TodayWithHM(int hour,int min,datetime time=0){			return Today(time) + hour*SECONDS_1hour + min*SECONDS_1minute;}

datetime Yesterday(datetime time=0,bool ignoreWeekend=true){
	int secondsTransposition = SECONDS_1day;
	if(ignoreWeekend && TimeDayOfWeek(Today(time)) == 1) secondsTransposition = SECONDS_1day*3;
	
	return Today(time)-secondsTransposition;
}

datetime Tomorrow(datetime time=0,bool ignoreWeekend=true){
	int secondsTransposition = SECONDS_1day;
	if(ignoreWeekend && TimeDayOfWeek(Today(time)) == 5) secondsTransposition = SECONDS_1day*3;
	
	return Today(time)+secondsTransposition;
}

int DayOfWeek(datetime date){			return TimeDayOfWeek(date);}
int DayOfMonth(datetime date){		return TimeDayOfMonth(date);}
int DayOfYear(datetime date){			return TimeDayOfYear(date);}

int TimeSeconds(datetime date){		MqlDateTime time;	TimeToStruct(date,time);	return time.sec;}
int TimeMinute(datetime date){		MqlDateTime time;	TimeToStruct(date,time);	return time.min;}
int TimeHour(datetime date){			MqlDateTime time;	TimeToStruct(date,time);	return time.hour;}
int TimeDay(datetime date){			MqlDateTime time;	TimeToStruct(date,time);	return time.day;}
int TimeMonth(datetime date){			MqlDateTime time;	TimeToStruct(date,time);	return time.mon;}
int TimeYear(datetime date){			MqlDateTime time;	TimeToStruct(date,time);	return time.year;}
int TimeDayOfWeek(datetime date){	MqlDateTime time;	TimeToStruct(date,time);	return time.day_of_week;}
int TimeDayOfMonth(datetime date){	MqlDateTime time;	TimeToStruct(date,time);	return time.day;}
int TimeDayOfYear(datetime date){	MqlDateTime time;	TimeToStruct(date,time);	return time.day_of_year;}

// Ricavare i valori di tempo (ora, minuti, giorno del mese, giorno della settimana, ecc...)
//int Seconds(){		MqlDateTime time;	TimeCurrent(time);	return time.sec;}
//int Minute(){		MqlDateTime time;	TimeCurrent(time);	return time.min;}
//int Hour(){			MqlDateTime time;	TimeCurrent(time);	return time.hour;}
//int Day(){			MqlDateTime time;	TimeCurrent(time);	return time.day;}
//int Month(){		MqlDateTime time;	TimeCurrent(time);	return time.mon;}
//int Year(){			MqlDateTime time;	TimeCurrent(time);	return time.year;}
//int DayOfWeek(){	MqlDateTime time;	TimeCurrent(time);	return time.day_of_week;}
//int DayOfMonth(){	return Day();}
//int DayOfYear(){	MqlDateTime time;	TimeCurrent(time);	return time.day_of_year;}

bool semaforoMinuto(ushort idContatore){
   static int minute[USHORT_MAX] = {0};
   int val = Day()*100 + Minute()+1;
   if(minute[idContatore] != val){
      return (minute[idContatore] = val) >= 0;
   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int SymbolSessionQuoteStartHour(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionQuote(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionQuote in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeStart;	return TimeToStruct(dateStartSession,timeStart) ? timeStart.hour : -1;
}

int SymbolSessionQuoteStartMinute(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionQuote(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionQuote in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeStart;	return TimeToStruct(dateStartSession,timeStart) ? timeStart.min : -1;
}

int SymbolSessionQuoteFinishHour(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionQuote(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionQuote in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeFinish;	return TimeToStruct(dateEndSession,timeFinish) ? (timeFinish.hour == 0 ? 24 : timeFinish.hour) : -1;
}

int SymbolSessionQuoteFinishMinute(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
   ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionQuote(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionQuote in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeFinish;	return TimeToStruct(dateEndSession,timeFinish) ? timeFinish.min : -1;
}

//---
int SymbolSessionTradeStartHour(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionTrade(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionTrade in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeStart;	return TimeToStruct(dateStartSession,timeStart) ? timeStart.hour : -1;
}

int SymbolSessionTradeStartMinute(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionTrade(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionTrade in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeStart;	return TimeToStruct(dateStartSession,timeStart) ? timeStart.min : -1;
}

int SymbolSessionTradeFinishHour(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionTrade(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionTrade in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeFinish;	return TimeToStruct(dateEndSession,timeFinish) ? (timeFinish.hour == 0 ? 24 : timeFinish.hour) : -1;
}

int SymbolSessionTradeFinishMinute(string symbol=NULL,datetime timeToConsider=0,int session=0){
	datetime dateStartSession = 0, dateEndSession = 0;
	ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)DayOfWeek(timeToConsider);
	if(!SymbolInfoSessionTrade(symbol,day,session,dateStartSession,dateEndSession)){
	   if(day == SUNDAY) return -2;
	   return printError("Error SymbolInfoSessionTrade in "+__FUNCTION__) -1;
   }
	
	MqlDateTime timeFinish;	return TimeToStruct(dateEndSession,timeFinish) ? timeFinish.min : -1;
}

//---

//+------------------------------------------------------------------+
// -1 Error
//	0 Closed
// 1 Open
int SymbolMarketTradeIsClosed(string symbol=NULL,datetime timeToConsider=0,int session=0){
	if(timeToConsider == 0) timeToConsider = TimeCurrent();
	
	int timeStartH =		SymbolSessionTradeStartHour(symbol,timeToConsider,session);
	int timeStartM = 		SymbolSessionTradeStartMinute(symbol,timeToConsider,session);
	
	int timeFinishH = 	SymbolSessionTradeFinishHour(symbol,timeToConsider,session);
	int timeFinishM = 	SymbolSessionTradeFinishMinute(symbol,timeToConsider,session);
	
	if(timeStartH == -2 || timeStartM == -2 || timeFinishH == -2 || timeFinishM == -2) return -1;
	
	MqlDateTime timeAllowedStart,timeAllowedFinish;
	if(TimeToStruct(Today(timeToConsider),timeAllowedStart) && TimeToStruct(Today(timeToConsider),timeAllowedFinish)){
		timeAllowedStart.hour = 	timeStartH;
		timeAllowedStart.min = 		timeStartM;
		
		datetime startTime = 		StructToTime(timeAllowedStart);
		datetime finishTime =		0;
		
		if(timeFinishH == 24){
			finishTime = Tomorrow(timeToConsider,false);
		}
		else{
			timeAllowedFinish.hour = 	timeFinishH;
			timeAllowedFinish.min = 	timeFinishM;
			
			finishTime = 	StructToTime(timeAllowedFinish);
		}
		
		return (timeToConsider >= startTime && timeToConsider < finishTime) ? 1 : 0;
	}
	return -1;
}

int SymbolMarketQuoteIsClosed(string symbol=NULL,datetime timeToConsider=0,int session=0){
	if(timeToConsider == 0) timeToConsider = TimeCurrent();
	
	int timeStartH =		SymbolSessionQuoteStartHour(symbol,timeToConsider,session);
	int timeStartM = 		SymbolSessionQuoteStartMinute(symbol,timeToConsider,session);
	
	int timeFinishH = 	SymbolSessionQuoteFinishHour(symbol,timeToConsider,session);
	int timeFinishM = 	SymbolSessionQuoteFinishMinute(symbol,timeToConsider,session);
	
	if(timeStartH == -2 || timeStartM == -2 || timeFinishH == -2 || timeFinishM == -2) return -1;
	
	MqlDateTime timeAllowedStart,timeAllowedFinish;
	if(TimeToStruct(Today(timeToConsider),timeAllowedStart) && TimeToStruct(Today(timeToConsider),timeAllowedFinish)){
		timeAllowedStart.hour = 	timeStartH;
		timeAllowedStart.min = 		timeStartM;
		
		datetime startTime = 		StructToTime(timeAllowedStart);
		datetime finishTime =		0;
		
		if(timeFinishH == 24){
			finishTime = Tomorrow(timeToConsider,false);
		}
		else{
			timeAllowedFinish.hour = 	timeFinishH;
			timeAllowedFinish.min = 	timeFinishM;
			
			finishTime = 	StructToTime(timeAllowedFinish);
		}
		
		return (timeToConsider >= startTime && timeToConsider < finishTime) ? 1 : 0;
	}
	return -1;
}

bool IsMarketTradeClosed(string symbol=NULL){
	static bool marketClosed = false;
	if(semaforoMinuto(60000)){ marketClosed = SymbolMarketTradeIsClosed(symbol) == 0;}
	return marketClosed;
}

bool IsMarketQuoteClosed(string symbol=NULL){
	static bool marketClosed = false;
	if(semaforoMinuto(60001)){ marketClosed = SymbolMarketQuoteIsClosed(symbol) == 0;}
	return marketClosed;
}

bool IsMarketTradeOpen(string symbol=NULL){		return !IsMarketTradeClosed(symbol);}
bool IsMarketQuoteOpen(string symbol=NULL){		return !IsMarketQuoteClosed(symbol);}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
int LastError = 0;
int countErrors = 0;
bool printError(string error){
   countErrors++;
   LastError = GetLastError();
	Print(error+", err# "+(string)LastError);
	return false;
}
*/