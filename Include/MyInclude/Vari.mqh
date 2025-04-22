#include <MyLibrary\MyLibrary.mqh>



string spreadComment()
{
return "Spread " + ((string)(int)((Ask(Symbol()) - Bid(Symbol()))/Point()));
}

int spreadInt()
{
return (int)((Ask(Symbol()) - Bid(Symbol()))/Point());
}

double spread()
{
return (Ask(Symbol()) - Bid(Symbol()))/Point();
}

double swaplong()
{
return SymbolInfoDouble(Symbol(),SYMBOL_SWAP_LONG);
}

double swapshort()
{
return SymbolInfoDouble(Symbol(),SYMBOL_SWAP_SHORT);
}
string swaplongshortComment()
{
string symb = Symbol(); 
return ("Swap long " + (string)SymbolInfoDouble(Symbol(),SYMBOL_SWAP_LONG) + " Swap short " + (string)SymbolInfoDouble(Symbol(),SYMBOL_SWAP_SHORT));
}

//+------------------------------------------------------------------+
//|                     ordinilivellicrescenti()                     |Da testare il reset livelli
//+------------------------------------------------------------------+
/*
enum tipolivellidasuperare_  
  {
   No                        = 0,  //Flat
   open                      = 1,  //L'ultimo OpenOrder
   openclose                 = 2   //L'ultimo OpenOrder/CloseOrder Superiore
  };
  
input tipolivellidasuperare_ tipolivellidasuperare =     0;       //Permette nuovi Ordini se il prezzo supera: Open o Open/Close  
  
   */
bool ordinisulivellicrescenti(int enable,int tipolivellidasuperare,string BuySell,string symbol,ulong magic,string comm,bool resetsoglie,double livelloresetbuy=0,double livelloresetsell=0) // Da testare
{
   bool a = false;

   static double sogliaBuy = 0;
   static ulong tikbuymem = 0;
   static double sogliaSell = 0;
   static ulong tiksellmem = 0;


   if(resetsoglie || (livelloresetbuy!=0 && Bid(symbol) <= livelloresetbuy) || (livelloresetsell!=0 && Ask(symbol) >= livelloresetsell))
      
   {
      tikbuymem=0;   
      sogliaBuy=0;
      tiksellmem=0;
      sogliaSell=0;
   }

   if(tipolivellidasuperare==1) {
      if(BuySell == "Buy") {
         ulong TikBuy = TicketPrimoOrdineBuy(magic,comm);

         if(TikBuy) {
            tikbuymem = TikBuy;
            sogliaBuy = PositionOpenPrice(tikbuymem);
         }
         if(Ask(symbol) > sogliaBuy) {
            a=true;
            return a;
         }
      }

      if(BuySell == "Sell") {
         ulong TikSell = TicketPrimoOrdineSell(magic,comm);

         if(TikSell) {
            tiksellmem = TikSell;
            sogliaSell = PositionOpenPrice(tiksellmem);
         }

         if(Bid(symbol) < sogliaSell && sogliaSell != 0) {
            a=true;
            return a;
         }
         if((Bid(symbol) < sogliaSell && sogliaSell != 0) || (sogliaSell==0)) {
            a=true;
            return a;
         }
      }
   }

   if(tipolivellidasuperare==2) {
      if(BuySell == "Buy") {
         ulong TikBuy = TicketPrimoOrdineBuy(magic,comm);

         if(TikBuy) {
            tikbuymem = TikBuy;
            sogliaBuy = PositionOpenPrice(tikbuymem);
         }
         if(!TikBuy && tikbuymem) sogliaBuy = ValoreSuperiore(HistoryDealPriceClose(tikbuymem+1),HistoryDealPriceOpen(tikbuymem));

         if(Ask(symbol) > sogliaBuy) {
            a=true;
            return a;
         }
      }

      if(BuySell == "Sell") {
         ulong TikSell = TicketPrimoOrdineSell(magic,comm);

         if(TikSell) {
            tiksellmem = TikSell;
            sogliaSell = PositionOpenPrice(tiksellmem);
         }
         if(!TikSell && tiksellmem) sogliaSell = ValoreInferiore(HistoryDealPriceClose(tiksellmem+1),HistoryDealPriceOpen(tiksellmem));

         if(Bid(symbol) < sogliaSell && sogliaSell != 0) {
            a=true;
            return a;
         }
         if((Bid(symbol) < sogliaSell && sogliaSell != 0) || (sogliaSell==0)) {
            a=true;
            return a;
         }
      }
   }
   return a;
}