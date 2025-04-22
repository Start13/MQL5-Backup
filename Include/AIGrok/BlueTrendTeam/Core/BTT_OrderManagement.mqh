#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

class COrderManager {
private:
   CTrade trade;
   double slPoints;
   double tpPoints;
   double bePoints;
   double tsPoints;
   bool useDynamicSLTP;

public:
   COrderManager() {
      slPoints = 0;
      tpPoints = 0;
      bePoints = 0;
      tsPoints = 0;
      useDynamicSLTP = false;
   }

   void Init(double sl, double tp, double be, double ts, bool dynamicSLTP) {
      slPoints = sl;
      tpPoints = tp;
      bePoints = be;
      tsPoints = ts;
      useDynamicSLTP = dynamicSLTP;
   }

   bool OpenBuy(double lotSize, double price, double dynamicSL = 0, double dynamicTP = 0) {
      double sl = useDynamicSLTP ? dynamicSL : (slPoints > 0 ? price - slPoints * Point() : 0);
      double tp = useDynamicSLTP ? dynamicTP : (tpPoints > 0 ? price + tpPoints * Point() : 0);
      return trade.Buy(lotSize, _Symbol, price, sl, tp, "OmniEA Buy");
   }

   bool OpenSell(double lotSize, double price, double dynamicSL = 0, double dynamicTP = 0) {
      double sl = useDynamicSLTP ? dynamicSL : (slPoints > 0 ? price + slPoints * Point() : 0);
      double tp = useDynamicSLTP ? dynamicTP : (tpPoints > 0 ? price - tpPoints * Point() : 0);
      return trade.Sell(lotSize, _Symbol, price, sl, tp, "OmniEA Sell");
   }

   void CloseAll() {
      for (int i = PositionsTotal() - 1; i >= 0; i--) {
         ulong ticket = PositionGetTicket(i);
         if (PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
            trade.PositionClose(ticket);
         }
      }
   }

   void ManagePositions() {
      for (int i = PositionsTotal() - 1; i >= 0; i--) {
         ulong ticket = PositionGetTicket(i);
         if (PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
            double sl = PositionGetDouble(POSITION_SL);
            long positionType = PositionGetInteger(POSITION_TYPE); // Correzione: int -> long

            if (bePoints > 0) {
               if (positionType == POSITION_TYPE_BUY && currentPrice >= openPrice + bePoints * Point() && (sl < openPrice || sl == 0)) {
                  trade.PositionModify(ticket, openPrice, PositionGetDouble(POSITION_TP));
               }
               if (positionType == POSITION_TYPE_SELL && currentPrice <= openPrice - bePoints * Point() && (sl > openPrice || sl == 0)) {
                  trade.PositionModify(ticket, openPrice, PositionGetDouble(POSITION_TP));
               }
            }

            if (tsPoints > 0) {
               if (positionType == POSITION_TYPE_BUY && currentPrice > openPrice + tsPoints * Point()) {
                  double newSL = currentPrice - tsPoints * Point();
                  if (newSL > sl || sl == 0) {
                     trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
                  }
               }
               if (positionType == POSITION_TYPE_SELL && currentPrice < openPrice - tsPoints * Point()) {
                  double newSL = currentPrice + tsPoints * Point();
                  if (newSL < sl || sl == 0) {
                     trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
                  }
               }
            }
         }
      }
   }
};