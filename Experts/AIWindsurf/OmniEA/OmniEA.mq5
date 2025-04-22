//+------------------------------------------------------------------+
//|                                                      OmniEA.mq5 |
//|        OmniEA Pro v1.0 - Sviluppato da BlueTrendTeam           |
//|        Supervisionato da AI Windsurf                           |
//+------------------------------------------------------------------+
#property copyright   "BlueTrendTeam"
#property link        "https://www.bluetrendteam.com"
#property version     "1.00"
#property description "Sistema di trading avanzato con supporto multi-indicatore e preset configurabili"
#property strict

// Include necessari
#include <Trade\Trade.mqh>
#include "..\..\..\..\Include\AIWindsurf\omniea\SlotManager.mqh"
#include "..\..\..\..\Include\AIWindsurf\ui\PanelManager.mqh"
#include "..\..\..\..\Include\AIWindsurf\common\Localization.mqh"
#include "..\..\..\..\Include\AIWindsurf\common\TimeTrading.mqh"
#include "..\..\..\..\Include\AIWindsurf\common\NewsFilter.mqh"
#include "..\..\..\..\Include\AIWindsurf\common\PresetManager.mqh"
#include "..\..\..\..\Include\AIWindsurf\common\ReportGenerator.mqh"

// Enumerazioni
enum ENUM_OMNIEA_VERSION
{
   OMNIEA_LITE,     // OmniEA Lite
   OMNIEA_PRO,      // OmniEA Pro
   OMNIEA_ULTIMATE  // OmniEA Ultimate
};

// Input globali
input group "=== Impostazioni Generali ==="
input string             EAName = "OmniEA";           // Nome dell'EA
input ENUM_OMNIEA_VERSION Version = OMNIEA_PRO;       // Versione
input string             Language = "it";             // Lingua (it, en, es, ru)
input int                MagicNumber = 12345;         // Numero magico
input string             TradeComment = "OmniEA";     // Commento ordini

input group "=== Gestione Rischio ==="
input double             RiskPercent = 1.0;           // Rischio per operazione (%)
input double             StopLoss = 50.0;             // Stop Loss (punti)
input double             TakeProfit = 100.0;          // Take Profit (punti)
input bool               UseBreakEven = true;         // Usa Break Even
input double             BreakEvenLevel = 30.0;       // Livello Break Even (punti)
input bool               UseTrailingStop = true;      // Usa Trailing Stop
input double             TrailingStop = 20.0;         // Trailing Stop (punti)

input group "=== Filtri di Trading ==="
input bool               UseTimeFilter = false;       // Usa filtro orario
input string             TradingHoursStart = "08:00"; // Inizio orario trading
input string             TradingHoursEnd = "20:00";   // Fine orario trading
input bool               UseNewsFilter = false;       // Usa filtro notizie
input int                NewsImpact = 2;              // Impatto minimo notizie (1-3)
input int                NewsOffsetBefore = 60;       // Minuti prima della notizia
input int                NewsOffsetAfter = 30;        // Minuti dopo la notizia

// Variabili globali
CTrade         trade;                // Oggetto per l'esecuzione degli ordini
CSlotManager   slotManager;          // Gestore degli slot per indicatori
CPanelManager  panelManager;         // Gestore dell'interfaccia utente
CPresetManager presetManager;        // Gestore dei preset
CTimeTrading   timeTrading;          // Gestore del filtro orario
CNewsFilter    newsFilter;           // Gestore del filtro notizie
CReportGenerator reportGenerator;    // Generatore di report
bool           isInitialized = false;// Flag di inizializzazione
bool           isTrading = true;     // Flag di trading
string         g_lang;               // Lingua corrente

//+------------------------------------------------------------------+
//| Funzione di inizializzazione dell'Expert Advisor                 |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializzazione della lingua
   g_lang = Language;
   InitLocalization(g_lang);
   
   // Configurazione dell'oggetto trade
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetMarginMode();
   trade.SetTypeFillingBySymbol(_Symbol);
   trade.SetDeviationInPoints(10);
   
   // Inizializzazione dei gestori
   if(!slotManager.Initialize())
   {
      Print(Translate("INIT_ERROR_SLOT_MANAGER"));
      return INIT_FAILED;
   }
   
   if(!panelManager.Initialize(EAName, Version))
   {
      Print(Translate("INIT_ERROR_PANEL_MANAGER"));
      return INIT_FAILED;
   }
   
   if(!presetManager.Initialize())
   {
      Print(Translate("INIT_ERROR_PRESET_MANAGER"));
      return INIT_FAILED;
   }
   
   // Inizializzazione del generatore di report
   if(!reportGenerator.Initialize(EAName))
   {
      Print("❌ Errore inizializzazione ReportGenerator");
      return INIT_FAILED;
   }
   
   // Configurazione del filtro orario
   timeTrading.SetTradingHours(UseTimeFilter, TradingHoursStart, TradingHoursEnd);
   
   // Configurazione del filtro notizie
   newsFilter.SetNewsFilter(UseNewsFilter, (ENUM_NEWS_IMPACT)NewsImpact, NewsOffsetBefore, NewsOffsetAfter);
   
   // Configurazione dei parametri di rischio
   slotManager.SetRiskParameters(RiskPercent, StopLoss, TakeProfit, 
                                UseBreakEven, BreakEvenLevel, 
                                UseTrailingStop, TrailingStop);
   
   // Collegamento dei gestori
   panelManager.SetSlotManager(&slotManager);
   panelManager.SetPresetManager(&presetManager);
   panelManager.SetReportGenerator(&reportGenerator);
   
   // Inizializzazione del timer
   EventSetTimer(1);
   
   // Aggiornamento del pannello
   panelManager.Update();
   
   Print(Translate("INIT_COMPLETED"), " (", EAName, " ", EnumToString(Version), ")");
   isInitialized = true;
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Funzione di deinizializzazione dell'Expert Advisor               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Rimozione del timer
   EventKillTimer();
   
   // Pulizia dell'interfaccia utente
   panelManager.Cleanup();
   
   // Salvataggio delle impostazioni correnti
   presetManager.SaveCurrentSettings();
   
   Print(Translate("DEINIT_COMPLETED"), ", ", Translate("REASON"), ": ", reason);
}

//+------------------------------------------------------------------+
//| Funzione chiamata ad ogni tick                                   |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!isInitialized) return;
   
   // Aggiornamento del pannello (solo quando necessario)
   static datetime lastUpdate = 0;
   if(TimeCurrent() - lastUpdate >= 1)
   {
      panelManager.Update();
      lastUpdate = TimeCurrent();
   }
   
   // Se il trading non è abilitato, non fare nulla
   if(!isTrading) return;
   
   // Verifica dei filtri
   if((UseTimeFilter && !timeTrading.IsTradingAllowed()) || 
      (UseNewsFilter && !newsFilter.IsNewsAllowed()))
   {
      if(UseTimeFilter && !timeTrading.IsTradingAllowed())
      {
         panelManager.ShowNotification(Translate("TRADING_OUTSIDE_HOURS"), clrOrange);
      }
      if(UseNewsFilter && !newsFilter.IsNewsAllowed())
      {
         panelManager.ShowNotification(Translate("TRADING_NEWS_ACTIVE"), clrOrange);
      }
      return;
   }
   
   // Gestione delle posizioni aperte
   ManageOpenPositions();
   
   // Verifica dei segnali di trading
   CheckTradingSignals();
}

//+------------------------------------------------------------------+
//| Funzione chiamata dal timer                                      |
//+------------------------------------------------------------------+
void OnTimer()
{
   if(!isInitialized) return;
   
   // Aggiornamento del pannello
   panelManager.Update();
}

//+------------------------------------------------------------------+
//| Funzione chiamata ad ogni evento del grafico                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(!isInitialized) return;
   
   // Gestione degli eventi dell'interfaccia utente
   if(id == CHARTEVENT_OBJECT_CLICK || id == CHARTEVENT_OBJECT_DRAG || 
      id == CHARTEVENT_OBJECT_DRAGEND || id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      panelManager.OnChartEvent(id, lparam, dparam, sparam);
   }
}

//+------------------------------------------------------------------+
//| Gestione delle posizioni aperte                                  |
//+------------------------------------------------------------------+
void ManageOpenPositions()
{
   // Gestione del break even
   if(UseBreakEven)
   {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         if(PositionSelectByTicket(PositionGetTicket(i)))
         {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
               PositionGetInteger(POSITION_MAGIC) == MagicNumber)
            {
               double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
               double sl = PositionGetDouble(POSITION_SL);
               double tp = PositionGetDouble(POSITION_TP);
               
               // Implementazione del break even
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
               {
                  if(currentPrice >= openPrice + BreakEvenLevel * _Point && sl < openPrice)
                  {
                     trade.PositionModify(PositionGetTicket(i), openPrice, tp);
                  }
               }
               else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               {
                  if(currentPrice <= openPrice - BreakEvenLevel * _Point && sl > openPrice)
                  {
                     trade.PositionModify(PositionGetTicket(i), openPrice, tp);
                  }
               }
            }
         }
      }
   }
   
   // Gestione del trailing stop
   if(UseTrailingStop)
   {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         if(PositionSelectByTicket(PositionGetTicket(i)))
         {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
               PositionGetInteger(POSITION_MAGIC) == MagicNumber)
            {
               double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
               double sl = PositionGetDouble(POSITION_SL);
               
               // Implementazione del trailing stop
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
               {
                  double newSL = NormalizeDouble(currentPrice - TrailingStop * _Point, _Digits);
                  if(newSL > sl && newSL < currentPrice)
                  {
                     trade.PositionModify(PositionGetTicket(i), newSL, PositionGetDouble(POSITION_TP));
                  }
               }
               else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               {
                  double newSL = NormalizeDouble(currentPrice + TrailingStop * _Point, _Digits);
                  if((newSL < sl || sl == 0) && newSL > currentPrice)
                  {
                     trade.PositionModify(PositionGetTicket(i), newSL, PositionGetDouble(POSITION_TP));
                  }
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Verifica dei segnali di trading                                  |
//+------------------------------------------------------------------+
void CheckTradingSignals()
{
   // Verifica se ci sono già posizioni aperte sul simbolo
   int positionsOnSymbol = 0;
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
            PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            positionsOnSymbol++;
         }
      }
   }
   
   // Se ci sono già troppe posizioni aperte, non aprirne altre
   if(positionsOnSymbol >= 10) // Limite massimo di posizioni
   {
      return;
   }
   
   // Verifica dei segnali di acquisto
   if(slotManager.CheckBuySignal())
   {
      double lotSize = CalculateLotSize(RiskPercent, StopLoss);
      double sl = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) - StopLoss * _Point, _Digits);
      double tp = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) + TakeProfit * _Point, _Digits);
      
      if(trade.Buy(lotSize, _Symbol, 0, sl, tp, TradeComment))
      {
         panelManager.ShowNotification(Translate("SIGNAL_BUY_EXECUTED"), clrLime);
      }
   }
   
   // Verifica dei segnali di vendita
   if(slotManager.CheckSellSignal())
   {
      double lotSize = CalculateLotSize(RiskPercent, StopLoss);
      double sl = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK) + StopLoss * _Point, _Digits);
      double tp = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) - TakeProfit * _Point, _Digits);
      
      if(trade.Sell(lotSize, _Symbol, 0, sl, tp, TradeComment))
      {
         panelManager.ShowNotification(Translate("SIGNAL_SELL_EXECUTED"), clrRed);
      }
   }
}

//+------------------------------------------------------------------+
//| Calcolo del volume in base al rischio                            |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskPercent, double stopLoss)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   double riskAmount = balance * riskPercent / 100;
   double slPoints = stopLoss;
   
   double lotSize = NormalizeDouble(riskAmount / (slPoints * tickValue / tickSize), 2);
   lotSize = MathFloor(lotSize / lotStep) * lotStep;
   
   if(lotSize < minLot) lotSize = minLot;
   if(lotSize > maxLot) lotSize = maxLot;
   
   return lotSize;
}
