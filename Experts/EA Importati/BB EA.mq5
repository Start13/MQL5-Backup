//+------------------------------------------------------------------+
//|                                                   B BANDS EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade obj_Trade;

int handleBB;
double upperBand[];
double middleBand[];
double lowerBand[];

datetime openTimeBuy = 0;
datetime openTimeSell = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   handleBB = iBands(_Symbol,_Period,20,0,2,PRICE_CLOSE);
   if (handleBB == INVALID_HANDLE) return (INIT_FAILED);
   Print("Handle BB = ",handleBB);
   
   ArraySetAsSeries(upperBand,true);
   ArraySetAsSeries(middleBand,true);
   ArraySetAsSeries(lowerBand,true);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if (totalPos(POSITION_TYPE_BUY) > 0 && Bid >= middleBand[0]){
      //close all the buy positions
      closePos(POSITION_TYPE_BUY);
   }
   if (totalPos(POSITION_TYPE_SELL) > 0 && Ask <= middleBand[0]){
      //close all the buy positions
      closePos(POSITION_TYPE_SELL);
   }

   int currentbars = iBars(_Symbol,_Period);
   static int prevbars = 0;
   if (prevbars == currentbars) return;
   prevbars = currentbars;
   
   if (!CopyBuffer(handleBB,UPPER_BAND,0,2,upperBand)) return;
   if (!CopyBuffer(handleBB,BASE_LINE,0,2,middleBand)) return;
   if (!CopyBuffer(handleBB,LOWER_BAND,0,2,lowerBand)) return;

   //ArrayPrint(upperBand,6," ,");
   //ArrayPrint(middleBand,6," ,");
   //ArrayPrint(lowerBand,6," ,");
   
   if (totalPos(POSITION_TYPE_BUY)==0 && Ask <= lowerBand[0] &&
      openTimeBuy != iTime(_Symbol,_Period,0)
   ){
      //Print("BUY SIGNAL");
      double sl = Bid - 1000*_Point;
      double tp = Bid + 500*_Point;
      openTimeBuy = iTime(_Symbol,_Period,0);
      obj_Trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,0.1,Ask,sl,tp);
   }
   else if (totalPos(POSITION_TYPE_SELL)==0 && Bid >= upperBand[0]){
      //Print("SELL SIGNAL");
      double sl = Ask + 1000*_Point;
      double tp = Ask - 500*_Point;
      obj_Trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,0.1,Bid,sl,tp);
   }
   
  }
//+------------------------------------------------------------------+

int totalPos(ENUM_POSITION_TYPE pos_type){
   int totalType_pos = 0;
   for (int i = PositionsTotal()-1; i>=0; i--){
      ulong ticket = PositionGetTicket(i);
      if (ticket > 0){
         if (PositionSelectByTicket(ticket)){
            if (PositionGetString(POSITION_SYMBOL)==_Symbol){
               if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY &&
                  pos_type==POSITION_TYPE_BUY){
                  totalType_pos++;
               }
               else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL &&
                  pos_type==POSITION_TYPE_SELL){
                  totalType_pos++;
               }
            }
         }
      }
   }
   return (totalType_pos);
}

void closePos(ENUM_POSITION_TYPE pos_type){
   for (int i = PositionsTotal()-1; i>=0; i--){
      ulong ticket = PositionGetTicket(i);
      if (ticket > 0){
         if (PositionSelectByTicket(ticket)){
            if (PositionGetString(POSITION_SYMBOL)==_Symbol){
               if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY &&
                  pos_type==POSITION_TYPE_BUY){
                  obj_Trade.PositionClose(ticket);
               }
               else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL &&
                  pos_type==POSITION_TYPE_SELL){
                  obj_Trade.PositionClose(ticket);
               }
            }
         }
      }
   }
}