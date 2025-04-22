//+------------------------------------------------------------------+
//| BTT_OrderManager.mqh - Order management for OmniEA               |
//| Copyright 2025, BlueTrendTeam                                    |
//| https://www.mql5.com                                             |
//+------------------------------------------------------------------+
#property strict

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| CBTT_OrderManager class                                          |
//+------------------------------------------------------------------+
class CBTT_OrderManager
{
private:
   CTrade   m_trade;            // Trading object
   int      m_magicNumber;      // EA's magic number
   int      m_slippage;         // Allowed slippage
   string   m_tradeComment;     // Trade comment
   
   double   m_riskPercent;      // Risk percentage per trade
   bool     m_useCompounding;   // Use compounding?
   double   m_currentCapital;   // Current trading capital
   double   m_initialCapital;   // Initial capital for compounding

public:
   // Constructor
   CBTT_OrderManager() : m_magicNumber(0), m_slippage(3), m_tradeComment(""),
                         m_riskPercent(1.0), m_useCompounding(false), 
                         m_currentCapital(0.0), m_initialCapital(0.0)
   {
   }
   
   // Initialization
   bool Init(int magic, int slippage, string comment)
   {
      m_magicNumber = magic;
      m_slippage = slippage;
      m_tradeComment = comment;
      
      m_trade.SetExpertMagicNumber(m_magicNumber);
      m_trade.SetDeviationInPoints(m_slippage);
      
      m_currentCapital = AccountInfoDouble(ACCOUNT_BALANCE);
      if(m_initialCapital <= 0)
         m_initialCapital = m_currentCapital;
      
      return true;
   }
   
   // Set risk parameters
   void SetRiskParameters(double riskPercent, bool useCompounding, double initialCapital = 0.0)
   {
      m_riskPercent = riskPercent;
      m_useCompounding = useCompounding;
      
      if(initialCapital > 0)
         m_initialCapital = initialCapital;
      else
         m_initialCapital = AccountInfoDouble(ACCOUNT_BALANCE);
      
      m_currentCapital = m_useCompounding ? AccountInfoDouble(ACCOUNT_EQUITY) : m_initialCapital;
   }
   
   // Calculate lot size based on risk
   double CalculateLotSize(string symbol)
   {
      double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
      double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
      double lotSize = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
      
      if(tickSize > 0 && tickValue > 0)
      {
         double riskAmount = m_currentCapital * m_riskPercent / 100.0;
         double stopLoss = GetStopLossInPips(); // Should be implemented based on your strategy
         double moneyRiskPerLot = stopLoss * tickValue / tickSize;
         
         if(moneyRiskPerLot > 0)
            lotSize = MathFloor(riskAmount / moneyRiskPerLot / SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP)) * SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
      }
      
      // Ensure lot size is within allowed limits
      lotSize = MathMax(lotSize, SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN));
      lotSize = MathMin(lotSize, SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX));
      
      return lotSize;
   }
   
   // Open buy order
   bool OpenBuyOrder(string symbol, double volume)
   {
      double price = SymbolInfoDouble(symbol, SYMBOL_ASK);
      double sl = CalculateStopLoss(symbol, ORDER_TYPE_BUY);
      double tp = CalculateTakeProfit(symbol, ORDER_TYPE_BUY);
      
      return m_trade.Buy(volume, symbol, price, sl, tp, m_tradeComment);
   }
   
   // Open sell order
   bool OpenSellOrder(string symbol, double volume)
   {
      double price = SymbolInfoDouble(symbol, SYMBOL_BID);
      double sl = CalculateStopLoss(symbol, ORDER_TYPE_SELL);
      double tp = CalculateTakeProfit(symbol, ORDER_TYPE_SELL);
      
      return m_trade.Sell(volume, symbol, price, sl, tp, m_tradeComment);
   }
   
   // Check if there's an open buy order
   bool HasOpenBuyOrder(string symbol = NULL)
   {
      if(symbol == NULL)
         symbol = Symbol();
      
      for(int i = 0; i < PositionsTotal(); i++)
      {
         if(PositionGetSymbol(i) == symbol && 
            PositionGetInteger(POSITION_MAGIC) == m_magicNumber &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         {
            return true;
         }
      }
      
      return false;
   }
   
   // Check if there's an open sell order
   bool HasOpenSellOrder(string symbol = NULL)
   {
      if(symbol == NULL)
         symbol = Symbol();
      
      for(int i = 0; i < PositionsTotal(); i++)
      {
         if(PositionGetSymbol(i) == symbol && 
            PositionGetInteger(POSITION_MAGIC) == m_magicNumber &&
            PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
         {
            return true;
         }
      }
      
      return false;
   }
   
   // Manage open positions
   void ManageOpenPositions()
   {
      // TODO: Implement trailing stop, breakeven, etc.
   }

private:
   // Calculate stop loss
   double CalculateStopLoss(string symbol, ENUM_ORDER_TYPE orderType)
   {
      // TODO: Implement your stop loss calculation
      return 0; // 0 means no stop loss
   }
   
   // Calculate take profit
   double CalculateTakeProfit(string symbol, ENUM_ORDER_TYPE orderType)
   {
      // TODO: Implement your take profit calculation
      return 0; // 0 means no take profit
   }
   
   // Get stop loss in pips
   double GetStopLossInPips()
   {
      // TODO: Implement based on your strategy
      return 50; // Default to 50 pips for example
   }
};