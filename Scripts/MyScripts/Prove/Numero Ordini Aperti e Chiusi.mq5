//+------------------------------------------------------------------+
//|                                Numero Ordini Aperti e Chiusi.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <MyLibrary\MyLibrary.mqh>
#include <Trade\Trade.mqh>

bool aaa = true;
string stringToCommentCustom;
//int static cont=0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//Orders();
OrdiniChiusi(7777,"LIBRA GOLD");
   
  }
//+------------------------------------------------------------------+
int OrdiniChiusi(ulong Magic, string Commen)
{
	   HistorySelect(iTime(Symbol(),PERIOD_D1,0),TimeCurrent());	// Funzione necessaria per poter selezionare lo storico su cui analizzare gli ordini e affari
	   
	   int cont=0;
	   for(int i=0;i<HistoryOrdersTotal();i++){
	   	if(HistoryOrderSelectByPos(i)){
	   	if(Magic==HistoryOrderMagic()&&HistoryOrderSymbol()==Symbol()&&HistoryOrderComment()==Commen)cont++;
	   		/*stringToCommentCustom +=	IntegerToString(i)+") "+HistoryOrderSymbol()+
	   											", Ticket: "+			IntegerToString(HistoryOrderTicket(),10)+
	   											", Magic Number:  "+ IntegerToString (HistoryOrderMagic())+
	   											", Comment:       "+ (string) HistoryOrderComment()+
	   											", Order_PositionID: "+IntegerToString(HistoryOrderPositionID(),10)+
	   											", State: "+			EnumToString(HistoryOrderState())+
	   											", TypeIn: "+			EnumToString(HistoryOrderType())+
	   											", TimeO_Setup: "+	TimeToString(HistoryOrderTimeSetup(),TIME_DATE | TIME_SECONDS)+
	   											", TimeO_Done: "+		TimeToString(HistoryOrderTimeDone(),TIME_DATE | TIME_SECONDS)+
	   											", TimeO_SetupMSC: "+IntegerToString(HistoryOrderTimeSetupMSC())+
	   											", TimeO_DoneMSC: "+	IntegerToString(HistoryOrderTimeDoneMSC())+
	   											", OpenPrice: "+		DoubleToString(HistoryOrderOpenPrice(),HistoryOrderDigits())+
	   											", PriceCurrent: "+	DoubleToString(HistoryOrderPriceCurrent(),HistoryOrderDigits())+
	   											", Volume initial: "+DoubleToString(HistoryOrderVolumeInitial(),2)+
	   											", Volume current: "+DoubleToString(HistoryOrderVolumeCurrent(),2)+"\n";*/
	   	}
		}
		
		stringToCommentCustom += "\n------- Affari -------\n";
		for(int i=0;i<HistoryDealsTotal();i++){
	   	if(HistoryDealSelectByPos(i)){
	   		stringToCommentCustom +=	IntegerToString(i)+") "+HistoryDealSymbol()+
	   											", Ticket: "+			IntegerToString(HistoryDealTicket(),10)+
	   											", Order: "+			IntegerToString(HistoryDealOrder())+
	   											", PositionID: "+		IntegerToString(HistoryDealPositionID(),10)+
	   											", TypeIn: "+			EnumToString(HistoryDealType())+
	   											", EntryType: "+		EnumToString(HistoryDealEntry())+
	   											", Time (Open): "+	TimeToString(HistoryDealTimeOpen(),TIME_DATE | TIME_SECONDS)+
	   											", Time (Close): "+	TimeToString(HistoryDealTimeClose(),TIME_DATE | TIME_SECONDS)+
	   											", Price (Close): "+	DoubleToString(HistoryDealPriceClose(),HistoryDealDigits())+
	   											", Price (Open): "+	DoubleToString(HistoryDealPriceOpen(),HistoryDealDigits())+
	   											", Lots: "+				DoubleToString(HistoryDealLots(),2)+
	   											", LotsID: "+			DoubleToString(HistoryOrderLots(HistoryDealPositionID()),2)+
	   											", Profit Full: "+	DoubleToString(HistoryDealProfitFull(),2)+
	   											", Profit Full2: "+	DoubleToString(HistoryDealProfitFull2(),2)+
	   											", Profit (Point): "+IntegerToString(HistoryDealProfitPoint(),2)+
	   											", Commmission: "+	DoubleToString(HistoryDealCommission(),2)+
	   											", CommmissionX2: "+	DoubleToString(HistoryDealCommissionX2(),2)+
	   											", Volume: "+			DoubleToString(HistoryDealVolume(),2)+"\n";
	   	}
		}
		return cont;
   }




void Orders()
{
	   HistorySelect(iTime(Symbol(),PERIOD_D1,0),TimeCurrent());	// Funzione necessaria per poter selezionare lo storico su cui analizzare gli ordini e affari
	   int cont=0;
	   stringToCommentCustom += "\n------- Ordini chiusi -------\n";
	   for(int i=0;i<HistoryOrdersTotal();i++){
	   	if(HistoryOrderSelectByPos(i)){
	   		stringToCommentCustom +=	IntegerToString(i)+") "+HistoryOrderSymbol()+
	   											", Ticket: "+			IntegerToString(HistoryOrderTicket(),10)+
	   											", Magic Number:  "+ IntegerToString (HistoryOrderMagic())+
	   											", Comment:       "+ (string) HistoryOrderComment()+
	   											", Order_PositionID: "+IntegerToString(HistoryOrderPositionID(),10)+
	   											", State: "+			EnumToString(HistoryOrderState())+
	   											", TypeIn: "+			EnumToString(HistoryOrderType())+
	   											", TimeO_Setup: "+	TimeToString(HistoryOrderTimeSetup(),TIME_DATE | TIME_SECONDS)+
	   											", TimeO_Done: "+		TimeToString(HistoryOrderTimeDone(),TIME_DATE | TIME_SECONDS)+
	   											", TimeO_SetupMSC: "+IntegerToString(HistoryOrderTimeSetupMSC())+
	   											", TimeO_DoneMSC: "+	IntegerToString(HistoryOrderTimeDoneMSC())+
	   											", OpenPrice: "+		DoubleToString(HistoryOrderOpenPrice(),HistoryOrderDigits())+
	   											", PriceCurrent: "+	DoubleToString(HistoryOrderPriceCurrent(),HistoryOrderDigits())+
	   											", Volume initial: "+DoubleToString(HistoryOrderVolumeInitial(),2)+
	   											", Volume current: "+DoubleToString(HistoryOrderVolumeCurrent(),2)+"\n";
	   	}
		}
		
		stringToCommentCustom += "\n------- Affari -------\n";
		for(int i=0;i<HistoryDealsTotal();i++){
	   	if(HistoryDealSelectByPos(i)){
	   		stringToCommentCustom +=	IntegerToString(i)+") "+HistoryDealSymbol()+
	   											", Ticket: "+			IntegerToString(HistoryDealTicket(),10)+
	   											", Order: "+			IntegerToString(HistoryDealOrder())+
	   											", PositionID: "+		IntegerToString(HistoryDealPositionID(),10)+
	   											", TypeIn: "+			EnumToString(HistoryDealType())+
	   											", EntryType: "+		EnumToString(HistoryDealEntry())+
	   											", Time (Open): "+	TimeToString(HistoryDealTimeOpen(),TIME_DATE | TIME_SECONDS)+
	   											", Time (Close): "+	TimeToString(HistoryDealTimeClose(),TIME_DATE | TIME_SECONDS)+
	   											", Price (Close): "+	DoubleToString(HistoryDealPriceClose(),HistoryDealDigits())+
	   											", Price (Open): "+	DoubleToString(HistoryDealPriceOpen(),HistoryDealDigits())+
	   											", Lots: "+				DoubleToString(HistoryDealLots(),2)+
	   											", LotsID: "+			DoubleToString(HistoryOrderLots(HistoryDealPositionID()),2)+
	   											", Profit Full: "+	DoubleToString(HistoryDealProfitFull(),2)+
	   											", Profit Full2: "+	DoubleToString(HistoryDealProfitFull2(),2)+
	   											", Profit (Point): "+IntegerToString(HistoryDealProfitPoint(),2)+
	   											", Commmission: "+	DoubleToString(HistoryDealCommission(),2)+
	   											", CommmissionX2: "+	DoubleToString(HistoryDealCommissionX2(),2)+
	   											", Volume: "+			DoubleToString(HistoryDealVolume(),2)+"\n";
	   	}
		}Print("Count: ",cont,"  ",stringToCommentCustom);
   }