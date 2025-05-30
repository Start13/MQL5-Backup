#include <MyLibrary\MyLibrary.mqh>

//+------------------------------------------------------------------+
//| LEZIONE 21 MQL5                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Moltiplicatore Compounding                                       |
//+------------------------------------------------------------------+
//double capitaleBasePerCompounding =  AccountInfoDouble(ACCOUNT_BALANCE);

double coefficienteCompounding(bool compoundingOnOff,double AccountBalanceAttuale,double AccountBalancePartenza){
   return compoundingOnOff ? division(AccountBalanceAttuale,AccountBalancePartenza) : 1;
}

//+------------------------------------------------------------------+
//| Funzioni per il calcolo preciso in base al mercato               |
//+------------------------------------------------------------------+
double SymbolMultiplier(string symbolForex=""){
   if(SymbolExist(symbolForex)) return Bid(symbolForex);
   
   string symbolForexInverted = StringSubstr(symbolForex,3,3)+StringSubstr(symbolForex,0,3)+StringSubstr(symbolForex,6); // Quest'ultima in caso di suffisso alla valuta
   if(SymbolExist(symbolForexInverted)) return division(1,Bid(symbolForexInverted));
   
   return 1;
}

double SymbolTickValueReal(string symbol=""){
   double symbolTick_Multiplier = 1;
   
   // per mercati che hanno il Profit Calculation Mode su Futures, il TickValue è di default su 0.01 (in base ai digits del mercato), dunque è necessaria questo blocco di codice:
   if(SymbolTradeCalcMode(symbol) == SYMBOL_CALC_MODE_FUTURES || SymbolTradeCalcMode(symbol) == SYMBOL_CALC_MODE_CFDINDEX){ // Oppure SYMBOL_CALC_MODE_EXCH_FUTURES ...
      symbolTick_Multiplier *= SymbolMultiplier( SymbolCurrencyMargin() + AccountCurrency() );
   }
   
   return SymbolTickValue(symbol)*symbolTick_Multiplier;
}

//+------------------------------------------------------------------+
//| Calcolo valori: lotti, rischio, distanza                         |
//+------------------------------------------------------------------+

// LOTTI = RISCHIO_€ / (DISTANZA_POINT + COMMISSIONI_PER_LOTTO)

// RISCHIO_€ = LOTTI * DISTANZA_POINT + LOTTI * COMMISSIONI_PER_LOTTO

// DISTANZA_POINT = (RISCHIO_€ - LOTTI * COMMISSIONI_PER_LOTTO) / LOTTI

double calcoloLottiDaRischioPerc(double rischioPerc,int distanzaPointSL,double commissioniPerLotto=0,string symbol=""){
   double rischioDenaro = AccountBalance()*rischioPerc/100.0;     // Percentuale di rischio basata sul Bilancio, a scelta del programmatore/trader
   return calcoloLottiDaRischio(rischioDenaro,distanzaPointSL,commissioniPerLotto,symbol);
}

double calcoloLottiDaRischio(double rischio,int distanzaPointSL,double commissioniPerLotto=0,string symbol=""){
   if(distanzaPointSL <= 0) return 0;
   return division(rischio,distanzaPointSL*SymbolTickValueReal(symbol)+MathAbs(commissioniPerLotto));
}


double calcoloRischio(double totaleLotti,int distanzaPointSL,double commissioniPerLotto=0,string symbol=""){
   return totaleLotti*(distanzaPointSL*SymbolTickValueReal(symbol) + MathAbs(commissioniPerLotto));
}

int	calcoloDistanzaPoint(double totaleLotti,double rischio,double commissioniPerLotto=0,string symbol=""){
   if(totaleLotti <= 0) return 0;
   return divisionInt(rischio - totaleLotti*MathAbs(commissioniPerLotto),totaleLotti*SymbolTickValueReal(symbol));
}




double myLotSize(bool compounding_,double capitaleAttualePerCompounding_,double capitaleBasePerCompounding_,double lottiBase_,double rischioPerc_,double rischioDenaro_,int distanzaSL_,double commissioni_){
   double lotti = lottiBase_;
   if(lottiBase_ <= 0){
      if(rischioPerc_ <= 0)   lotti =  calcoloLottiDaRischio(rischioDenaro_,distanzaSL_,commissioni_);      // L'implementazione dell'effetto compounding sul rischio in denaro può essere implementato o meno, è una scelta del programmatore/trader.
      else{
         lotti =  calcoloLottiDaRischioPerc(rischioPerc_,distanzaSL_,commissioni_);                        // Il calcolo dei lotti in base al rischio % è già una forma di compounding, dunque basta ritornare il valore ricavato.
         lotti = adjustVolume(lotti);
         return lotti;
      }
   }
   
   lotti *= coefficienteCompounding(compounding_,capitaleAttualePerCompounding_,capitaleBasePerCompounding_);    // Il vero effetto compounding si basa sulla Equity, ma dipende dalla scelta del programmatore/trader, poiché possono esserci diverse varianti.
   lotti = adjustVolume(lotti);
   
   return lotti;
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string currencySymbol(string nameCurrency){
   if(StringIsEqual(nameCurrency,"USD")) return "$";
   if(StringIsEqual(nameCurrency,"EUR")) return "€";
   if(StringIsEqual(nameCurrency,"GBP")) return "£";
   if(StringIsEqual(nameCurrency,"JPY")) return "¥";
   if(StringIsEqual(nameCurrency,"CAD")) return "$C";
   if(StringIsEqual(nameCurrency,"AUD")) return "$A";
   if(StringIsEqual(nameCurrency,"NZD")) return "$N";
   return nameCurrency;
}

string currencySymbolAccount(){
   return currencySymbol(AccountCurrency());
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| LEZIONE TOP 21.1 MQL5                                            |
//+------------------------------------------------------------------+

// P -> Probabilità di successo (WinRatio) [0-1]
// R -> Reward/Risk (avgWin/avgLoss)
double calcoloKellyFormula(double P_K,double R_K){
   //P_K /= 100.0; // se in ingresso abbiamo il Win Ratio espresso con un valore in % tra [0 e 100]
   double kelly = 0;
   if(R_K >= 1){
      kelly = P_K-((1-P_K)/R_K);
   }
   else{
      kelly = (P_K*(R_K+1))-1;
   }
   return kelly*100.0; // valore % [0-100]
}

double   calcoloLottiDaKellyFormula(int distanzaPointSL,double WinRatioPerc,double AvgRR_,double commissioniPerLotto=0,string symbol=""){
   double rischioPerc = calcoloKellyFormula(WinRatioPerc/100.0,AvgRR_);
   return calcoloLottiDaRischioPerc(rischioPerc,distanzaPointSL,commissioniPerLotto,symbol);
}

void printSymbolsList(){
   string symbol = "";
   for(int i=0;i<SymbolsTotal(false);i++){
      symbol = SymbolName(i,false);
      Print(IntegerToString(i)+") "+symbol+", Calc_Mode: "+	IntegerToString(SymbolTradeCalcMode(symbol))+", TickValue: "+DoubleString(SymbolTickValue(symbol),10)+
            " "+SymbolCurrencyMargin(symbol)+", "+SymbolCurrencyProfit(symbol)+", "+SymbolCurrencyBase(symbol));
      Sleep(50);
   }
}