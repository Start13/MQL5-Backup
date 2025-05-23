//+------------------------------------------------------------------+
//|                                              RSI14_MACD_EA.mq5   |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.meta.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.meta.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Input parameters                                                |
//+------------------------------------------------------------------+
input int      RSI_Period = 14;            // Periodo RSI
input int      RSI_Overbought = 70;        // Livello ipercomprato RSI
input int      RSI_Oversold = 30;          // Livello ipervenduto RSI
input int      MACD_Fast = 12;             // Periodo veloce MACD
input int      MACD_Slow = 26;             // Periodo lento MACD
input int      MACD_Signal = 9;            // Periodo segnale MACD
input double   LotSize = 0.1;              // Dimensione lotto
input double   StopLossPercent = 2.0;      // Stop Loss percentuale (2%)
input double   TakeProfitPercent = 4.0;    // Take Profit percentuale (4%)
input ulong    MagicNumber = 123456;       // Magic Number per identificare gli ordini dell'EA

//+------------------------------------------------------------------+
//| Variabili globali                                                |
//+------------------------------------------------------------------+
int rsiHandle;                            // Handle per l'indicatore RSI
int macdHandle;                           // Handle per l'indicatore MACD
double rsiBuffer[];                       // Buffer per i valori RSI
double macdBuffer[];                      // Buffer per i valori MACD
double signalBuffer[];                    // Buffer per i valori del segnale MACD
MqlTick lastTick;                         // Ultimo tick ricevuto
datetime lastBarTime;                     // Tempo dell'ultima barra elaborata

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializza gli indicatori
   rsiHandle = iRSI(_Symbol, _Period, RSI_Period, PRICE_CLOSE);
   macdHandle = iMACD(_Symbol, _Period, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE);
   
   if(rsiHandle == INVALID_HANDLE || macdHandle == INVALID_HANDLE)
   {
      Print("Errore nell'inizializzazione degli indicatori");
      return(INIT_FAILED);
   }
   
   // Imposta i buffer
   ArraySetAsSeries(rsiBuffer, true);
   ArraySetAsSeries(macdBuffer, true);
   ArraySetAsSeries(signalBuffer, true);
   
   // Inizializza l'ultimo tempo della barra
   lastBarTime = 0;
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Rilascia gli handle degli indicatori
   if(rsiHandle != INVALID_HANDLE)
      IndicatorRelease(rsiHandle);
   if(macdHandle != INVALID_HANDLE)
      IndicatorRelease(macdHandle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Ottieni l'ultimo tick
   if(!SymbolInfoTick(_Symbol, lastTick))
   {
      Print("Errore nel recupero del tick");
      return;
   }
   
   // Controlla se è una nuova barra
   datetime currentBarTime = iTime(_Symbol, _Period, 0);
   if(currentBarTime == lastBarTime)
      return; // Non è una nuova barra, esci
   
   lastBarTime = currentBarTime;
   
   // Prepara i dati per la strategia
   if(!PrepareData())
   {
      Print("Errore nella preparazione dei dati");
      return;
   }
   
   // Controlla le condizioni di trading
   CheckForTrade();
   
   // Gestione degli ordini aperti
   ManageOpenPositions();
}

//+------------------------------------------------------------------+
//| Prepara i dati per la strategia                                  |
//+------------------------------------------------------------------+
bool PrepareData()
{
   // Copia i valori RSI
   if(CopyBuffer(rsiHandle, 0, 0, 3, rsiBuffer) != 3)
   {
      Print("Errore nel copiare i dati RSI");
      return false;
   }
   
   // Copia i valori MACD e Signal
   if(CopyBuffer(macdHandle, 0, 0, 3, macdBuffer) != 3 ||
      CopyBuffer(macdHandle, 1, 0, 3, signalBuffer) != 3)
   {
      Print("Errore nel copiare i dati MACD");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Controlla le condizioni di trading                               |
//+------------------------------------------------------------------+
void CheckForTrade()
{
   // Controlla se ci sono posizioni aperte
   if(PositionsTotal() > 0)
      return;
   
   // Condizioni per un BUY:
   // 1. RSI sotto il livello di ipervenduto (30)
   // 2. MACD sopra la linea di segnale e entrambi sotto lo zero
   bool buyCondition = (rsiBuffer[0] < RSI_Oversold) && 
                      (macdBuffer[0] > signalBuffer[0]) && 
                      (macdBuffer[0] < 0) && 
                      (signalBuffer[0] < 0);
   
   // Condizioni per un SELL:
   // 1. RSI sopra il livello di ipercomprato (70)
   // 2. MACD sotto la linea di segnale e entrambi sopra lo zero
   bool sellCondition = (rsiBuffer[0] > RSI_Overbought) && 
                       (macdBuffer[0] < signalBuffer[0]) && 
                       (macdBuffer[0] > 0) && 
                       (signalBuffer[0] > 0);
   
   // Calcola Stop Loss e Take Profit in punti
   double stopLossPoints = CalculateStopLoss();
   double takeProfitPoints = CalculateTakeProfit();
   
   if(buyCondition)
   {
      OpenTrade(ORDER_TYPE_BUY, stopLossPoints, takeProfitPoints);
   }
   else if(sellCondition)
   {
      OpenTrade(ORDER_TYPE_SELL, stopLossPoints, takeProfitPoints);
   }
}

//+------------------------------------------------------------------+
//| Apre una nuova posizione                                         |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE orderType, double slPoints, double tpPoints)
{
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = LotSize;
   request.type = orderType;
   request.price = (orderType == ORDER_TYPE_BUY) ? lastTick.ask : lastTick.bid;
   request.deviation = 10;
   request.magic = MagicNumber;
   
   // Imposta Stop Loss e Take Profit
   if(slPoints > 0)
   {
      request.sl = (orderType == ORDER_TYPE_BUY) ? request.price - slPoints : request.price + slPoints;
   }
   if(tpPoints > 0)
   {
      request.tp = (orderType == ORDER_TYPE_BUY) ? request.price + tpPoints : request.price - tpPoints;
   }
   
   // Invia l'ordine
   if(!OrderSend(request, result))
   {
      Print("Errore nell'invio dell'ordine: ", GetLastError());
      return;
   }
   
   if(result.retcode != TRADE_RETCODE_DONE)
   {
      Print("Ordine non eseguito: ", result.retcode);
   }
}

//+------------------------------------------------------------------+
//| Gestisce le posizioni aperte                                     |
//+------------------------------------------------------------------+
void ManageOpenPositions()
{
   // In questa semplice strategia, la gestione è affidata agli SL/TP
   // Potresti aggiungere logiche aggiuntive qui se necessario
}

//+------------------------------------------------------------------+
//| Calcola lo Stop Loss in punti                                    |
//+------------------------------------------------------------------+
double CalculateStopLoss()
{
   // Calcola il valore in punti del 2% del saldo
   double riskAmount = AccountInfoDouble(ACCOUNT_BALANCE) * (StopLossPercent / 100.0);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double pointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   if(tickValue == 0 || pointValue == 0)
   {
      Print("Errore nel calcolo del valore del tick/punto");
      return 0;
   }
   
   double points = riskAmount / (LotSize * tickValue) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) / pointValue;
   return points;
}

//+------------------------------------------------------------------+
//| Calcola il Take Profit in punti                                  |
//+------------------------------------------------------------------+
double CalculateTakeProfit()
{
   // Calcola il valore in punti del 4% del saldo
   double profitAmount = AccountInfoDouble(ACCOUNT_BALANCE) * (TakeProfitPercent / 100.0);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double pointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   if(tickValue == 0 || pointValue == 0)
   {
      Print("Errore nel calcolo del valore del tick/punto");
      return 0;
   }
   
   double points = profitAmount / (LotSize * tickValue) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) / pointValue;
   return points;
}

//+------------------------------------------------------------------+