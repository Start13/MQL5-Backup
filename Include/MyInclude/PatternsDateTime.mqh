#include <MyLibrary\MyLibrary.mqh>

//+------------------------------------------------------------------+
//|                      giornoDellAnno()                            | secondo, minuto, ora, giorno della settimana/mese/anno
//+------------------------------------------------------------------+
int numGiornoDellAnno()
  {
//---
   datetime date1=TimeCurrent();
   MqlDateTime str1;
   TimeToStruct(date1,str1);

   printf("%02d.%02d.%4d, day of year = %d",str1.day,str1.mon,
          str1.year,str1.day_of_year);
Print("Giorno: ",str1.year*365+str1.mon*12+str1.day);
   return 
   //str1.day;
   //str1.mon;
   //str1.year;
str1.day_of_year;
  }
/*  Risultato:
   01.03.2008, day of year = 60

*/

//+------------------------------------------------------------------+
//|                        ContaGiorni()                             | restituisce un numero univo di giorni da confrontare 
//+------------------------------------------------------------------+
int ContaGiorni()
  {
//---
   datetime date1=TimeCurrent();
   MqlDateTime str1;
   TimeToStruct(date1,str1);
   return 
str1.year*365+str1.mon*12+str1.day;
  }
//+------------------------------------------------------------------+
//|                    OrdiniChiusiNeiGiorni()                       | Restituisce il numero di Ordni Chiusi (Aperti ?) nei giorni impostati (Day). Day == 0 ---> Oggi.
//+------------------------------------------------------------------+

int OrdiniChiusiNeiGiorni(ulong Magic, string Commen_, int Day)
{
	   HistorySelect(iTime(Symbol(),PERIOD_D1,Day),TimeCurrent());	// Funzione necessaria per poter selezionare lo storico su cui analizzare gli ordini e affari
	   string stringToCommentCustom;
	   int cont=0;
	   int cont_=0;
	   for(int i=0;i<HistoryOrdersTotal();i++){
	   	if(HistoryOrderSelectByPos(i)){
	   	if(Magic==HistoryOrderMagic()&&Symbol()==HistoryOrderSymbol()&&Commen_==HistoryOrderComment())cont++;
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
	   	if(Magic==HistoryDealMagic()&&Symbol()==HistoryDealSymbol()&&Commen_==HistoryDealComment())cont_++;
	   		/*stringToCommentCustom +=	IntegerToString(i)+") "+HistoryDealSymbol()+
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
	   											", Volume: "+			DoubleToString(HistoryDealVolume(),2)+"\n";*/
	   	}
		}
		//Print(" Ordini Chiusi: ",cont," Deal: ",cont_);
		return cont;
   }  
  



  
  
  