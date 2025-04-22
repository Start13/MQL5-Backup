//+------------------------------------------------------------------+
//|                                                  usa e getta.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
  }
//+------------------------------------------------------------------+
void GestioneGrid()
  {
   if(Grid)
     {
      PositionSelectByIndex(0);
      double Ask,Bid;
      Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
      Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      static double arrayGridLossBuy[50];
      static double arraysGridLossSell[50];

      static char  NumOrdBuyGrid=0;
      static char  NumOrdSellGrid=0;
      double LotGridBuy=0;
      double LotGridSell=0;

      static int indexBuy ;
      static int indexSell;

      if(!NumOrdHedgeBuy(TicketHedgeBuy) && !NumOrdHedgeSell(TicketHedgeSell))
        {
         //------------------azzera array TicketHedgeBuy -----------
         for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
           {
            TicketHedgeBuy[aa] = 0;
           }
          //------------------azzera array TicketHedgeSell -----------
         for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
           {
            TicketHedgeSell[aa] = 0;
           } 
         return;
        }
      if(((NumOrdHedgeBuy(TicketHedgeBuy)>1 || NumOrdHedgeSell(TicketHedgeSell)>1) && (ProfitHedgeBuy(TicketHedgeBuy)
            +ProfitHedgeSell(TicketHedgeSell))>= profitGrid) || DDMax(maxDDPerc,magic_number))
        {
         brutalCloseTotal(Symbol(),magic_number);
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;
         //------------------azzera array TicketHedgeBuy -----------
         for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
           {
            TicketHedgeBuy[aa] = 0;
           }
          //------------------azzera array TicketHedgeSell -----------
         for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
           {
            TicketHedgeSell[aa] = 0;
           } 
         return;
        }
      
            if(NumOrdHedgeBuy(TicketHedgeBuy)>1 && ProfitHedgeBuy(TicketHedgeBuy)>= profitGrid)
              {
               brutalCloseBuyPositions(Symbol(),magic_number);
               indexBuy=0;
               GridBuyActive=false;
               NumOrdBuyGrid=0;
               for(int aa=0; aa<ArraySize(TicketHedgeBuy); aa++)
           {
            TicketHedgeBuy[aa] = 0;
           }
              }

            if(NumOrdHedgeSell(TicketHedgeSell)>1 && ProfitHedgeSell(TicketHedgeSell)>= profitGrid)
              {
               brutalCloseSellPositions(Symbol(),magic_number);
               indexSell=0;
               GridSellActive=false;
               NumOrdSellGrid=0;
               for(int aa=0; aa<ArraySize(TicketHedgeSell); aa++)
           {
            TicketHedgeSell[aa] = 0;
           } 
              }
      if(Grid && !NumOrdHedgeBuy(TicketHedgeBuy))
        {
         indexBuy=0;
         GridBuyActive=false;
         NumOrdBuyGrid=0;
         //------------------azzera array arrayGridLossBuy -----------
         for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++)
           {
            arrayGridLossBuy[aa] = 0.0;
           }
        }

      if(Grid && !NumOrdHedgeSell(TicketHedgeSell))
        {
         indexSell=0;
         GridSellActive=false;
         NumOrdSellGrid=0;
         //------------------azzera array arraysGridLossSell -----------
         for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++)
           {
            arraysGridLossSell[aa] = 0.0;
           }
        }

      if((NumOrdHedgeBuy(TicketHedgeBuy)||NumOrdHedgeSell(TicketHedgeSell)) && Grid)
        {
         if(!NumOrdHedgeBuy(TicketHedgeBuy))
           {
            indexBuy=0;
            GridBuyActive=false;
            NumOrdBuyGrid=0;
           }
         if(NumOrdHedgeBuy(TicketHedgeBuy) && Bid<PositionOpenPrice(TicketHedgeBuy[0]))
           {
            if(NumOrdHedgeBuy(TicketHedgeBuy))
              {
               for(int i=0; i<=NumMaxGrid; i++)
                 {
                  if(i==0)
                    {
                     arrayGridLossBuy[i]=PositionOpenPrice(TicketHedgeBuy[0])-((StartGrid)*Point());
                    }
                  if(i>0)
                    {
                     arrayGridLossBuy[i]=PositionOpenPrice(TicketHedgeBuy[0])-((i)*StepGrid+(StartGrid))*Point();
                    }
                 }

               for(int i=indexBuy; i<NumMaxGrid; i++)

                 {
                  if(MoltipliNumGrid<=(NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                    {
                     if(TypeGrid == 0)
                       {
                        LotGridBuy=PositionLots(TicketHedgeBuy[0])*MoltiplLotStep;
                       }
                     if(TypeGrid == 1)
                       {
                        LotGridBuy=NormalizeDoubleLots(LotUltimoHedgeBuy(TicketHedgeBuy)*MoltiplLotStep);
                       }
                    }
                  if(MoltipliNumGrid> (NumOrdHedgeBuy(TicketHedgeBuy)-1) && MoltipliNumGrid >= 0)
                    {
                     LotGridBuy=PositionLots(TicketHedgeBuy[0]);
                    }

                  if(SymbolInfoDouble(Symbol(),SYMBOL_BID)<=arrayGridLossBuy[indexBuy])

                    {
                     SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridBuy,0,Deviazione, 0,0,Commen,magic_number);
                     indexBuy=i+1;
                     GridBuyActive=true;
                     NumOrdBuyGrid++;
                     if(PositionTakeProfit(TicketHedgeBuy[0])>0.0)
                       {
                        PositionModify(TicketHedgeBuy[0],0,0,true);
                       }
                    }
                 }
              }
           }

         if(!NumOrdHedgeSell(TicketHedgeSell))
           {
            indexSell=0;
            GridSellActive=false;
            NumOrdSellGrid=0;
           }

         if(NumOrdHedgeBuy(TicketHedgeBuy) && Ask>PositionOpenPrice(TicketHedgeSell[0]))
           {
            if(NumOrdHedgeSell(TicketHedgeSell))
              {

               for(int i=0; i<=NumMaxGrid; i++)
                 {
                  if(i==0)
                    {
                     arraysGridLossSell[i]=PositionOpenPrice(TicketHedgeSell[0])+(StartGrid)*Point();
                    }
                  if(i>0)
                    {
                     arraysGridLossSell[i]=PositionOpenPrice(TicketHedgeSell[0])+((i)*StepGrid+(StartGrid))*Point();
                    }

                 }
              }
            for(int i=indexSell; i<NumMaxGrid; i++)

              {
               if(MoltipliNumGrid<=(NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                 {
                  if(TypeGrid == 0)
                    {
                     LotGridSell=PositionLots(TicketHedgeSell[0])*MoltiplLotStep;
                    }
                  if(TypeGrid == 1)
                    {
                     LotGridSell=NormalizeDoubleLots(LotUltimoHedgeSell (TicketHedgeSell)*MoltiplLotStep);
                    }
                 }
               if(MoltipliNumGrid> (NumOrdHedgeSell(TicketHedgeSell)-1) && MoltipliNumGrid >= 0)
                 {
                  LotGridSell=PositionLots(TicketHedgeSell[0]);
                 }
Print("arraysGridLossSell[indexSell]: ",arraysGridLossSell[indexSell]);
               if(SymbolInfoDouble(Symbol(),SYMBOL_ASK)>=arraysGridLossSell[indexSell])

                 {
                  SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridSell,0,Deviazione, 0,0,Commen,magic_number);
                  indexSell=i+1;
                  GridSellActive=true;
                  NumOrdSellGrid++;
                  if(PositionTakeProfit(TicketHedgeSell[0])>0.0)
                    {
                     PositionModify(TicketHedgeSell[0],0,0,true);
                    }
                 }
              }
           }
        }
     }
  }