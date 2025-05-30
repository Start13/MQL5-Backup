//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                    Copyright 2020, Corrado Bruni |
//|                                       http://www.cbalgotrade.com |
//+------------------------------------------------------------------+

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>
#include <MyLibrary\tradeManagement.mqh>
//#include <Trade\Trade.mqh>

//TicketPrimoOrdine(string BuySell, ulong MagicNumber_);//restituisce il numero Ticket del primo ordine Buy o Sell
//ulong TicketPrimoOrdineBuy(ulong MagicNumber_);  //restituisce il numero Ticket del primo ordine Buy

//+------------------------------------------------------------------+
//|                       TicketPrimoOrdine()                        |restituisce il numero Ticket del primo ordine Buy o Sell
//+------------------------------------------------------------------+
ulong TicketPrimoOrdine(ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;     
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
      PosTic=PositionTicket();
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_)  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket>PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  } 

//+------------------------------------------------------------------+
//|                       TicketPrimoOrdine_()                       |restituisce il numero Ticket del primo ordine Buy o Sell
//+------------------------------------------------------------------+
ulong TicketPrimoOrdine(string BuySell, ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";}
   if(PositionIsSell()){segno="Sell";}
      PosTic=PositionTicket();
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno)  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket>PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  }  
//+------------------------------------------------------------------+
//|                       TicketPrimoOrdine()                        |restituisce il numero Ticket del primo ordine Buy o Sell
//+------------------------------------------------------------------+
ulong TicketPrimoOrdine(string BuySell, ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";PosTic=PositionTicket();}
   if(PositionIsSell()){segno="Sell";PosTic=PositionTicket();}
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno && comm==PositionComment(PosTic))  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket>PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  } 
//+------------------------------------------------------------------+
//|                       TicketPrimoOrdineBuy                       |restituisce il Ticket del primo ordine Buy
//+------------------------------------------------------------------+
ulong TicketPrimoOrdineBuy(ulong MagicNumber_)
  {return TicketPrimoOrdine("Buy",MagicNumber_);}

//+------------------------------------------------------------------+
//|                       TicketPrimoOrdineSell                       |restituisce il numero Ticket del primo ordine Sell
//+------------------------------------------------------------------+
ulong TicketPrimoOrdineSell(ulong MagicNumber_)
  {return TicketPrimoOrdine("Sell",MagicNumber_);}  
//+------------------------------------------------------------------+
//|                       TicketPrimoOrdineBuy()                     |restituisce il numero Ticket del primo ordine Buy
//+------------------------------------------------------------------+
ulong TicketPrimoOrdineBuy(ulong MagicNumber_,string comm)
  {
      string BuySell="Buy";
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";PosTic=PositionTicket();}
   //if(PositionIsSell()){segno="Sell";}
   if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno && comm==PositionComment(PosTic))  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket>PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  } 
//+------------------------------------------------------------------+
//|                       TicketPrimoOrdineSell()                    |restituisce il numero Ticket del primo ordine Sell
//+------------------------------------------------------------------+
ulong TicketPrimoOrdineSell(ulong MagicNumber_,string comm)
  {
      string BuySell="Sell";
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   //if(PositionIsBuy()){segno="Buy";}
   if(PositionIsSell()){segno="Sell";PosTic=PositionTicket();}
   if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno && comm==PositionComment(PosTic))  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket>PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  } 
//+------------------------------------------------------------------+
//|                       TicketUltimoOrdineBuy()                    |restituisce il numero Ticket dell'ultimo ordine Buy o Sell
//+------------------------------------------------------------------+
ulong TicketUltimoOrdineBuy(ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";}
      PosTic=PositionTicket();
   if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_ && "Buy"==segno)  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket<PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  }   
//+------------------------------------------------------------------+
//|                       TicketUltimoOrdineSell()                   |restituisce il numero Ticket dell'ultimo ordineo Sell
//+------------------------------------------------------------------+
ulong TicketUltimoOrdineSell(ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsSell()){segno="Sell";}
      PosTic=PositionTicket();
   if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_ && "Sell"==segno)  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket<PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  }       
//+------------------------------------------------------------------+
//|                       TicketUltimoOrdine()                       |restituisce il numero Ticket dell'ultimo ordine Buy o Sell
//+------------------------------------------------------------------+
ulong TicketUltimoOrdine(ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;   
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
      PosTic=PositionTicket();
   if(PositionSymbol(PosTic) == SymbolChart && PositionMagicNumber(PosTic) == MagicNumber_)  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket<PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  } 
//+------------------------------------------------------------------+
//|                       TicketUltimoOrdine()                       |restituisce il numero Ticket dell'ultimo ordine Buy o Sell
//+------------------------------------------------------------------+
ulong TicketUltimoOrdine(string BuySell, ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";PosTic=PositionTicket();}
   if(PositionIsSell()){segno="Sell";PosTic=PositionTicket();}
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno && comm==PositionComment(PosTic))  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket<PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  }  
//+------------------------------------------------------------------+
//|                       TicketUltimoOrdineBuy()                    |restituisce il numero Ticket dell'ultimo ordine Buy
//+------------------------------------------------------------------+
ulong TicketUltimoOrdineBuy(ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";PosTic=PositionTicket();}
   //if(PositionIsSell()){segno="Sell";PosTic=PositionTicket();}
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && "Buy"==segno && comm==PositionComment(PosTic))  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket<PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  }
//+------------------------------------------------------------------+
//|                       TicketUltimoOrdineSell()                   |restituisce il numero Ticket dell'ultimo ordine Sell DA PROVARE
//+------------------------------------------------------------------+
ulong TicketUltimoOrdineSell(ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      string segno="";      
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(PositionIsSell()){segno="Sell";PosTic=PositionTicket();}
   //if(PositionIsSell()){segno="Sell";PosTic=PositionTicket();}
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && "Sell"==segno && comm==PositionComment(PosTic))  // Controllo Symbol e Number Magi
      {
   if(Ticket==0){Ticket=PosTic;}
   if(Ticket!=0 && Ticket<PosTic) {Ticket=PosTic;}
      }
      }
   return Ticket;
  }  
//+------------------------------------------------------------------+
//|                       LotsPrimoOrdineBuy()                       | restituisce i Lots del primo ordine Buy
//+------------------------------------------------------------------+
double LotsPrimoOrdineBuy(ulong MagicNumber_)
  {return PositionLots(TicketPrimoOrdineBuy(MagicNumber_));}
//+------------------------------------------------------------------+
//|                      LotsPrimoOrdineSell()                       | restituisce i Lots del primo ordine Sell
//+------------------------------------------------------------------+
double LotsPrimoOrdineSell(ulong MagicNumber_)
  {return PositionLots(TicketPrimoOrdineSell(MagicNumber_));}
//+------------------------------------------------------------------+
//|                       LotsUltimoOrdineBuy()                      | restituisce i Lots dell'ultimo ordine Buy
//+------------------------------------------------------------------+
double LotsUltimoOrdineBuy(ulong MagicNumber_)
  {return PositionLots(TicketUltimoOrdineBuy(MagicNumber_));}
//+------------------------------------------------------------------+
//|                      LotsUltimoOrdineSell()                      | restituisce i Lots dell'ultimo ordine Sell
//+------------------------------------------------------------------+
double LotsUltimoOrdineSell(ulong MagicNumber_)
  {return PositionLots(TicketUltimoOrdineSell(MagicNumber_));}
//+------------------------------------------------------------------+
//|                       LotUltimoOrdineBuy()                       |restituisce il Lot dell'ultimo ordine Buy DA PROVARE
//+------------------------------------------------------------------+
double LotUltimoOrdineBuy(ulong MagicNumber_,string comm)
  {return PositionLots(TicketUltimoOrdineBuy(MagicNumber_,comm));}
//+------------------------------------------------------------------+
//|                       LotUltimoOrdineSell()                      |restituisce il Lot dell'ultimo ordine Sell DA PROVARE
//+------------------------------------------------------------------+
double LotUltimoOrdineSell(ulong MagicNumber_,string comm)
  {return PositionLots(TicketUltimoOrdineSell(MagicNumber_,comm));} 
  
//+------------------------------------------------------------------+
//|                     OpenPricePrimoOrdine()                       | restituisce il Prezzo di apertura  del primo ordine Buy o Sell
//+------------------------------------------------------------------+
double OpenPricePrimoOrdine(string BuySell, ulong MagicNumber_)
  {return PositionOpenPrice(TicketPrimoOrdine(BuySell,MagicNumber_));}   
//+------------------------------------------------------------------+
//|                     OpenPricePrimoOrdine()                       | restituisce il Prezzo di apertura  del primo ordine Buy o Sell
//+------------------------------------------------------------------+
double OpenPricePrimoOrdine(string BuySell, ulong MagicNumber_,string Comm)
  {return PositionOpenPrice(TicketPrimoOrdine(BuySell,MagicNumber_,Comm));} 
   
//+------------------------------------------------------------------+
//|                     OpenPricePrimoOrdineBuy()                    | restituisce il Prezzo di apertura  del primo ordine Buy
//+------------------------------------------------------------------+
double OpenPricePrimoOrdineBuy(ulong MagicNumber_)
  {return PositionOpenPrice(TicketPrimoOrdineBuy(MagicNumber_));}  
//+------------------------------------------------------------------+
//|                     OpenPricePrimoOrdineBuy()                    | restituisce il Prezzo di apertura  del primo ordine Buy
//+------------------------------------------------------------------+
double OpenPricePrimoOrdineBuy(ulong MagicNumber_,string Comm)
  {return PositionOpenPrice(TicketPrimoOrdineBuy(MagicNumber_,Comm));}
//+------------------------------------------------------------------+
//|                     OpenPricePrimoOrdineSell()                   | restituisce il Prezzo di apertura  del primo ordine Sell
//+------------------------------------------------------------------+
double OpenPricePrimoOrdineSell(ulong MagicNumber_)
  {return PositionOpenPrice(TicketPrimoOrdineSell(MagicNumber_));}      
//+------------------------------------------------------------------+
//|                     OpenPricePrimoOrdineSell()                   | restituisce il Prezzo di apertura  del primo ordine Sell
//+------------------------------------------------------------------+
double OpenPricePrimoOrdineSell(ulong MagicNumber_,string Comm)
  {return PositionOpenPrice(TicketPrimoOrdineSell(MagicNumber_,Comm));}

//+------------------------------------------------------------------+
//|                           NumOrdini()                            |restituisce il numero Ticket del primo ordine Buy o Sell /////////OK
//+------------------------------------------------------------------+
char NumOrdini(string BuySell, ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      string segno=""; 
      char aa=0;     
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";}
   if(PositionIsSell()){segno="Sell";}
      Ticket=PositionTicket();
   if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno) aa++; // Controllo Symbol e Number Magi
      }
   return aa;
  }  
//+------------------------------------------------------------------+
//|                           NumOrdini()                            |restituisce il numero Ordini Totali   /////OK
//+------------------------------------------------------------------+
int NumOrdini(ulong Magic,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      char aa=0;    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
      Ticket=PositionTicket();
   if(PositionSymbol(Ticket) == SymbolChart && PositionMagicNumber(Ticket) == Magic && comm==PositionComment(Ticket))  // Controllo Symbol e Number Magi
      {if(Ticket!=0) aa++;}
      }
   return aa;
  }    
//+------------------------------------------------------------------+
//|                           NumOrdini()                            |restituisce il numero Ordini Buy o Sell   /////OK
//+------------------------------------------------------------------+
char NumOrdini(string BuySell, ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      string segno="";  
      char aa=0;    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
   if(PositionIsBuy()){segno="Buy";Ticket=PositionTicket();}
   if(PositionIsSell()){segno="Sell";Ticket=PositionTicket();}
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && BuySell==segno && comm==PositionComment(Ticket))  // Controllo Symbol e Number Magi
      {if(Ticket!=0) aa++;}
      }
   return aa;
  }  

//+------------------------------------------------------------------+
//|                        Numero Ordini o Buy o Sell                |restituisce il numero di ordini aperti Buy o Sell con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdBuy_O_Sell_(string BuySell, ulong MagicNumber_)
  {return NumOrdini(BuySell,MagicNumber_);}
//+------------------------------------------------------------------+
//|                              NumOrdBuy                           |restituisce il numero di ordini aperti Buy con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdBuy_(ulong MagicNumber_)
  {return NumOrdini("Buy",MagicNumber_);}
//+------------------------------------------------------------------+
//|                           Numero Ordini Sell                     |restituisce il numero di ordini aperti Sell con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdSell_(ulong MagicNumber_)
  {return NumOrdini("Sell",MagicNumber_);}  
//+------------------------------------------------------------------+
//|                           NumOrdini()                            |restituisce il numero Ticket del primo ordine Buy o Sell
//+------------------------------------------------------------------+
char NumOrdini(ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0;
      char aa=0;     
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
      PosTic=PositionTicket();
   if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_){aa++;}  // Controllo Symbol e Number Magi
      }
   return aa;
  }         
//+------------------------------------------------------------------+
//|                        Numero Ordini o Buy o Sell                |restituisce il numero di ordini aperti Buy o Sell con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdBuy_O_Sell(string BuySell, ulong MagicNumber_)
  {return NumOrdini(BuySell,MagicNumber_);}/*
   if(PositionsTotal()==0)
     {
      return 0;
     }
   string SymbolChart=Symbol();
   ulong bb = 0;
   int x = PositionsTotal();
   string arr [100];
   string arrPositionSymbol [100];
   ulong arrMagic [100];
   string arrBuySell [100];
//------------------------azzera array ------------------ Simbolo
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }

//------------------azzera array Magic ------------------  Numero magico
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }

//------------------azzera array arrPositionSymbol ------------------   Posizione
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++)
     {
      arrPositionSymbol[aa] = " ";
     }

//------------------azzera array arrBuySell ------------------   BuySell
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++)
     {
      arrBuySell[aa] = " ";
     }

//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      arr [i]      = PositionSymbol() ;                    //Symbolo
      arrMagic[i]  = PositionMagicNumber();                //Magic number
      //arrTicket[i] = PositionTicket();                     //Ticket

      if(PositionIsBuy()){arrBuySell[i]="Buy";}
      if(PositionIsSell()){arrBuySell[i]="Sell";}
     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_) && arrBuySell[i] == BuySell)
        {aa++;bb = PositionTicket();}
     }
   return aa;
  }
*/
//+------------------------------------------------------------------+
//|                             NumOrdBuy                            |restituisce il numero di ordini aperti Buy con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdBuy(ulong MagicNumber_)
  {return NumOrdini("Buy",MagicNumber_);}/*
   if(PositionsTotal()==0)
     {
      return 0;
     }
   string SymbolChart=Symbol();
   string BuySell = "Buy";
   ulong bb = 0;
   int x = PositionsTotal();
   string arr [100];
   string arrPositionSymbol [100];
   ulong arrMagic [100];
   string arrBuySell [100];
//------------------------azzera array ------------------ Simbolo
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------  Numero magico
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}

//------------------azzera array arrPositionSymbol ------------------   Posizione
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++){arrPositionSymbol[aa] = " ";}

//------------------azzera array arrBuySell ------------------   BuySell
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++){arrBuySell[aa] = " ";}

//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      arr [i]      = PositionSymbol() ;                    //Symbolo
      arrMagic[i]  = PositionMagicNumber();                //Magic number
      //arrTicket[i] = PositionTicket();                     //Ticket

      if(PositionIsBuy()){arrBuySell[i]="Buy";}
     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_) && arrBuySell[i] == BuySell)
        {
         aa++;
         bb = PositionTicket();
        }
     }
   return aa;
  }*/
//+------------------------------------------------------------------+
//|                             NumOrdBuy                            |restituisce il numero di ordini aperti Buy con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdBuy(ulong Magic,string comm)
  {
   if(PositionsTotal()==0){return 0;}
   string SymbolChart=Symbol();

   ulong bb = 0;
   int x = PositionsTotal();
//--------------------- controllo posizioni -------------
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
        PositionSelectByPos(i);
      if(PositionSymbol() == SymbolChart && PositionMagicNumber() == Magic && PositionIsBuy() && PositionComment() == comm)
        {
         aa++;
         bb = PositionTicket();
        }
     }
   return aa;
  }
//+------------------------------------------------------------------+
//|                           Numero Ordini Sell                     |restituisce il numero di ordini aperti Sell con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdSell(ulong MagicNumber_)
  {return NumOrdSell_(MagicNumber_);}/*
   if(PositionsTotal()==0)
     {
      return 0;
     }
   string SymbolChart=Symbol();
   string BuySell="Sell";
   ulong bb = 0;
   int x = PositionsTotal();
   string arr [100];
   string arrPositionSymbol [100];
   ulong arrMagic [100];
   string arrBuySell [100];
//------------------------azzera array ------------------ Simbolo
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }
//------------------azzera array Magic ------------------  Numero magico
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }
//------------------azzera array arrPositionSymbol ------------------   Posizione
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++)
     {
      arrPositionSymbol[aa] = " ";
     }
//------------------azzera array arrBuySell ------------------   BuySell
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++)
     {
      arrBuySell[aa] = " ";
     }
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      arr [i]      = PositionSymbol() ;                    //Symbolo
      arrMagic[i]  = PositionMagicNumber();                //Magic number
      //arrTicket[i] = PositionTicket();                     //Ticket
      if(PositionIsSell())
        {arrBuySell[i]="Sell";}
     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_) && arrBuySell[i] == BuySell)
        {
         aa++;
         bb = PositionTicket();
        }
     }
   return aa;
  }*/
//+------------------------------------------------------------------+
//|                             NumOrdSell                           |restituisce il numero di ordini aperti Buy con "aa" (o il ticket con "bb")
//+------------------------------------------------------------------+
char NumOrdSell(ulong Magic,string comm)
  {
   if(PositionsTotal()==0){return 0;}
   string SymbolChart=Symbol();
   ulong Tick=0;
   ulong bb = 0;
   int x = PositionsTotal();
//--------------------- controllo posizioni -------------
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
        PositionSelectByPos(i);
        Tick=PositionTicket();
      if(PositionSymbol(Tick) == SymbolChart && PositionMagicNumber(Tick) == Magic && PositionIsSell() && PositionComment(Tick) == comm)
        {aa++;bb = PositionTicket();}
     }
   return aa;
  }
//+------------------------------------------------------------------+
//|                            NumPosizioni                          |restituisce il numero Totale di ordini aperti
//+------------------------------------------------------------------+
int NumPosizioni(ulong MagicNumber_)
  {return NumOrdini(MagicNumber_);}
//+------------------------------------------------------------------+
//|                            NumPosizioni                          |restituisce il numero Totale di ordini aperti
//+------------------------------------------------------------------+
int NumPosizioni(ulong MagicNumber_, string comm)
  {
   if(PositionsTotal()==0){return 0;}
   string SymbolChart=Symbol();
   long bb = 0;
   int x = PositionsTotal();
//--------------------- controllo posizioni -------------
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if(PositionSymbol() == SymbolChart && PositionMagicNumber() == MagicNumber_ && PositionComment() == comm)
        {
         aa++;
         bb = PositionTicket();
        }
     }
   return aa;
  }
//+------------------------------------------------------------------+
//|                        ProfitOrdini()                            |restituisce il profitto Complessivo degli Ordini 
//+------------------------------------------------------------------+
double ProfitOrdini(ulong MagicNumber_)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      ulong PosTic=0; 
      double profit=0;    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
      Ticket=PositionTicket();
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_) profit+=PositionProfitFull(Ticket); // Controllo Symbol e Number Magi
      }
   return profit;
  }        
//+------------------------------------------------------------------+
//|                        ProfitOrdini()                            |restituisce il profitto dei Primi Ordini ESCLUSI Ordini Grid e Hedge 
//+------------------------------------------------------------------+     
double ProfitOrdini(ulong MagicNumber_,string comm)
  {
   if(!PositionsTotal())return 0;
      string SymbolChart=Symbol();
      ulong Ticket=0;
      double profit=0;    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {  
      PositionSelectByPos(i);
      Ticket=PositionTicket();
   if(PositionSymbol() == (string)SymbolChart && PositionMagicNumber() == MagicNumber_ && comm==PositionComment(Ticket)) profit+=PositionProfitFull(Ticket); // Controllo Symbol e Number Magi
      }
   return profit;
  } 
//+------------------------------------------------------------------+
//|                     int NumOrdHedgeBuy                           |Restituisce il numero di ordini buy primo ordine compreso.
//+------------------------------------------------------------------+

int NumOrdHedgeBuy(const ulong &TicketHedgeBuy_[])
  {
   int count=0;
   for(int aa=0; aa<ArraySize(TicketHedgeBuy_); aa++)
     {
      if(TicketHedgeBuy_[aa] != 0)
        {
         count++;
        };
     }
   return count;
  }
//+------------------------------------------------------------------+
//|                     int NumOrdHedgeSell                          |Restituisce il numero di ordini sell primo ordine compreso.
//+------------------------------------------------------------------+

int NumOrdHedgeSell(const ulong &TicketHedgeSell_[])
  {
   int count=0;
   for(int aa=0; aa<ArraySize(TicketHedgeSell_); aa++)
     {
      if(TicketHedgeSell_[aa] != 0)
        {
         count++;
        };
     }
   return count;
  }
//+------------------------------------------------------------------+
//|                 double PositionsProfitTotal                      |
//+------------------------------------------------------------------+  
double PositionsProfitTotal(const ulong MagicNumber_)
  {
   if(PositionsTotal()==0){return 0;}
   string SymbolChart=Symbol();
   long bb = 0;
   int x = PositionsTotal();
   string arr [100];
   ulong arrMagic [100];
   ulong arrTicket [100];
   double profit=0;
//------------------------azzera array ------------------
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}

//------------------azzera array Ticket ------------------
   for(int aa=0; aa<ArraySize(arrTicket); aa++){arrTicket[aa] = 0;}
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByIndex(i);
      arr [i] = PositionSymbol() ;
      arrMagic[i] = PositionMagicNumber();
      arrTicket[i] = PositionTicket();
     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_))
        {
         aa++;
         bb = PositionTicket();
   if(PositionProfitFull(bb) != 0)
        {profit+=PositionProfitFull(bb);};
        }
     }
   return profit;
 } 
//+------------------------------------------------------------------+
//|                     double ProfitHedgeBuy                        |
//+------------------------------------------------------------------+
double ProfitHedgeBuy(const ulong &TicketHedgeBuy_[])
  {
   double profit=0;
 
   for(int aa=0; aa<ArraySize(TicketHedgeBuy_); aa++)
     {
      if(TicketHedgeBuy_[aa] != 0)
        {profit+=PositionProfitFull(TicketHedgeBuy_[aa]);};
     }
   return profit;
  }
//+------------------------------------------------------------------+
//|                     double ProfitHedgeSell                       |
//+------------------------------------------------------------------+

double ProfitHedgeSell(const ulong &TicketHedgeSell_[])
  {
   double profit=0;
   for(int aa=0; aa<ArraySize(TicketHedgeSell_); aa++)
     {
      if(TicketHedgeSell_[aa] != 0)
        {profit+=PositionProfitFull(TicketHedgeSell_[aa]);};
     }
   return profit;
  }

//+------------------------------------------------------------------+
//|                     double LotUltimoHedgeBuy                     |
//+------------------------------------------------------------------+

double LotUltimoHedgeBuy(const ulong &TicketHedgeBuy_[])
  {
   double Lot=0;
   ulong  Ticket=0;
   for(int aa=0; aa<ArraySize(TicketHedgeBuy_); aa++)
     {
      if(TicketHedgeBuy_[aa] != 0 && TicketHedgeBuy_[aa]>Ticket)
        {Ticket=TicketHedgeBuy_[aa]; Lot=PositionLots(TicketHedgeBuy_[aa]);};
     }
   return Lot;
  }
//+------------------------------------------------------------------+
//|                     double LotUltimoHedgeSell                    |
//+------------------------------------------------------------------+

double LotUltimoHedgeSell(const ulong &TicketHedgeSell_[])
  {
   double Lot=0;
   ulong  Ticket=0;
   for(int aa=0; aa<ArraySize(TicketHedgeSell_); aa++)
     {
      if(TicketHedgeSell_[aa] != 0 && TicketHedgeSell_[aa]>Ticket)
        {Ticket=TicketHedgeSell_[aa]; Lot=PositionLots(TicketHedgeSell_[aa]);};
     }
   return Lot;
  }
  

//+------------------------------------------------------------------+
//|                     double UltimoLotHedge()                      |
//+------------------------------------------------------------------+  
  
double UltimoLotHedge(ulong MagicNumber_)
  {
   if(PositionsTotal()==0)
     {
      return 0.0;
     }
   string SymbolChart=Symbol();
   char  aa = 0;
   ulong bb = 0;
   ulong cc = 0;

   string arr [100];
   ulong arrMagic [100];
   ulong arrTicket [100];
   ulong arrTicketControllati [100];
   string arrBuySellControllati [100];
   string arrBuySell [100];
   ulong arrPrimoOrdine [100];
//------------------------azzera arrTicketControllati ------------------    simbolo
   for(int aa=0; aa<ArraySize(arrTicketControllati); aa++){arrTicketControllati[aa] = 0;}

//------------------------azzera arrBuySellControllati ------------------    simbolo
   for(int aa=0; aa<ArraySize(arrBuySellControllati); aa++){arrBuySellControllati[aa] = " ";}

//------------------------azzera array ------------------    simbolo
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------    magic number
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}

//------------------azzera array Ticket ------------------    ticket
   for(int aa=0; aa<ArraySize(arrTicket); aa++){arrTicket[aa] = 0;}

//------------------azzera array BuySell ------------------    Buy o Sell
   for(int aa=0; aa<ArraySize(arrBuySell); aa++){arrBuySell[aa] = " ";}

//------------------azzera array arrPrimoOrdine -----------    arrPrimoOrdine
   for(int aa=0; aa<ArraySize(arrPrimoOrdine); aa++){arrPrimoOrdine[aa] = 0;}
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      //arr [i] =(string) Symbol((string)PositionSelectByPos(i));
      PositionSelectByPos(i);
        {
         arr [i]      = PositionSymbol() ;                    //Symbolo
         arrMagic[i]  = PositionMagicNumber();                //Magic number
         arrTicket[i] = PositionTicket();                     //Ticket
        }
     }
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_))  // Controllo Symbol e Magic Number
        {
         if(bb==0){bb=arrTicket[i];}
         PositionSelectByTicket(bb);
           {if(bb!=0 && bb<arrTicket[i]) bb=arrTicket[i]; 
        }}}
   return PositionLots(bb);
  }  
  
//+------------------------------------------------------------------+
//|                     double TicketUltimoHedgeBuy                  |
//+------------------------------------------------------------------+

ulong TicketUltimoHedgeBuy(const ulong &TicketHedgeBuy_[])
  {

   ulong  Ticket=0;
   for(int aa=0; aa<ArraySize(TicketHedgeBuy_); aa++)
     {
      if(TicketHedgeBuy_[aa] != 0 && TicketHedgeBuy_[aa]>Ticket)
        {Ticket=TicketHedgeBuy_[aa];}
     }
   return Ticket;
  }

//+------------------------------------------------------------------+
//|                     double TicketUltimoHedgeSell                 |
//+------------------------------------------------------------------+

ulong TicketUltimoHedgeSell(const ulong &TicketHedgeSell_[])
  {

   ulong  Ticket=0;
   for(int aa=0; aa<ArraySize(TicketHedgeSell_); aa++)
     {
      if(TicketHedgeSell_[aa] != 0 && TicketHedgeSell_[aa]>Ticket)
        {Ticket=TicketHedgeSell_[aa];}
     }
   return Ticket;
  }

//+------------------------------------------------------------------+
//|                     void ClosePositionsHedgeBUY                  |
//+------------------------------------------------------------------+

void ClosePositionsHedgeBUY(const ulong &TicketHedgeBuy_[])
  {
   for(int aa=0; aa<ArraySize(TicketHedgeBuy_); aa++)
     {
      if(TicketHedgeBuy_[aa] != 0)
        {PositionClosePartial(TicketHedgeBuy_[aa],100,true);}
     }
  }

//+------------------------------------------------------------------+
//|                     void ClosePositionsHedgeSell                 |
//+------------------------------------------------------------------+

void ClosePositionsHedgeSell(const ulong &TicketHedgeSell_[])
  {
   for(int aa=0; aa<ArraySize(TicketHedgeSell_); aa++)
     {
      if(TicketHedgeSell_[aa] != 0)
        {PositionClosePartial(TicketHedgeSell_[aa],100,true);}
     }
  }
  
//+------------------------------------------------------------------+
//|                      NumPrimiOrdini()                            |
//+------------------------------------------------------------------+

int NumPrimiOrdini(ulong magic)
{
if(PositionsTotal()==0)return 0;
int a=0;
int b=0;
if(TicketPrimoOrdineBuy(magic)!=0.0) {a=1;}
if(TicketPrimoOrdineSell(magic)!=0.0){b=1;}
return a+b;
}
//+------------------------------------------------------------------+
//|                      ContaPrimiOrdini()                          |
//+------------------------------------------------------------------+

int ContaPrimiOrdini(ulong magic)
{
static int count=0;
static ulong TikBuy=0;
static ulong Tiksell=0;
//if(PositionsTotal()==0)return 0;
if(TicketPrimoOrdineBuy(magic)!=0.0&&TicketPrimoOrdineBuy(magic)!=TikBuy) {TikBuy=TicketPrimoOrdineBuy(magic);count++;}
if(TicketPrimoOrdineSell(magic)!=0.0&&TicketPrimoOrdineSell(magic)!=Tiksell){Tiksell=TicketPrimoOrdineSell(magic);count++;}
return count;
}
//+------------------------------------------------------------------+
//|                         ContaGrid()                              |
//+------------------------------------------------------------------+

int ContaGrid(int GridBuyActiv,int GridSellActiv)
{
static int count=0;
static bool semafBuy=true;
static bool semafSell=true;
if(GridBuyActiv==0)semafBuy=true;
if(GridSellActiv==0)semafSell=true;
if(GridBuyActiv!=0.0&&semafBuy)  {semafBuy=false;count++;}
if(GridSellActiv!=0.0&&semafSell){semafSell=false;count++;}
return count;
}
/*

//+------------------------------------------------------------------+
//|                    NumOrdiniAlGiorno()                           |
//+------------------------------------------------------------------+

int NumOrdiniAlGiorno()
{
static ulong ordBuy =0;
static ulong ordSell=0;
static int contaOrdiniDay=0;
static int BarDay=Bars(Symbol(),PERIOD_D1);
int    Barre=Bars(Symbol(),PERIOD_D1);
if(BarDay!=Barre)
{
contaOrdiniDay=0;BarDay=Barre;
}
if(BarDay==Barre)
{
if(TicketPrimoOrdineBuy()!=0 && TicketPrimoOrdineBuy()!=ordBuy)    {contaOrdiniDay++;ordBuy=TicketPrimoOrdineBuy();}
if(TicketPrimoOrdineSell()!=0 && TicketPrimoOrdineSell()!=ordSell) {contaOrdiniDay++;ordSell=TicketPrimoOrdineSell();}
}
return contaOrdiniDay;
}
*/
//-----------------------
/*
int giornoDellAnno()
  {
//---
   datetime date1=TimeCurrent();
   MqlDateTime str1;
   TimeToStruct(date1,str1);

   printf("%02d.%02d.%4d, day of year = %d",str1.day,str1.mon,
          str1.year,str1.day_of_year);

  return str1.day;str1.mon;
          str1.year;str1.day_of_year;
  }
/*  Risultato:
   01.03.2008, day of year = 60

*/
/*
//+------------------------------------------------------------------+
//|                           TicketPresente                         |restituisce vero falso se il ticket è presente nelle posizioni aperte 
//+------------------------------------------------------------------+
bool TicketPresente(ulong ticket, ulong MagicNumber_)
  {
   if(PositionsTotal()==0)
     {
      return false;
     }
   string SymbolChart=Symbol();
   char aa=0;
   bool bb=false;
   ulong cc = 0;
   string BuySell= "Sell";

//int x = PositionsTotal();
   string arr [100];
   ulong arrMagic [100];
   ulong arrTicket [100];
   ulong arrTicketControllati [100];
   string arrBuySellControllati [100];
   string arrBuySell [100];
   ulong arrPrimoOrdine [100];
//------------------------azzera arrTicketControllati ------------------    simbolo
   for(int aa=0; aa<ArraySize(arrTicketControllati); aa++)
     {
      arrTicketControllati[aa] = 0;
     }

//------------------------azzera arrBuySellControllati ------------------    simbolo
   for(int aa=0; aa<ArraySize(arrBuySellControllati); aa++)
     {
      arrBuySellControllati[aa] = " ";
     }

//------------------------azzera array ------------------    simbolo
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }

//------------------azzera array Magic ------------------    magic number
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }

//------------------azzera array Ticket ------------------    ticket
   for(int aa=0; aa<ArraySize(arrTicket); aa++)
     {
      arrTicket[aa] = 0;
     }

//------------------azzera array BuySell ------------------    Buy o Sell
   for(int aa=0; aa<ArraySize(arrBuySell); aa++)
     {
      arrBuySell[aa] = " ";
     }

//------------------azzera array arrPrimoOrdine -----------    arrPrimoOrdine
   for(int aa=0; aa<ArraySize(arrPrimoOrdine); aa++)
     {
      arrPrimoOrdine[aa] = 0;
     }
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      //arr [i] =(string) Symbol((string)PositionSelectByPos(i));
      PositionSelectByPos(i);
        {
         arr [i]      = PositionSymbol() ;                    //Symbolo
         arrMagic[i]  = PositionMagicNumber();                //Magic number
         arrTicket[i] = PositionTicket();                     //Ticket
        }
     }
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_) && ticket==arrTicket[i])  // Controllo Symbol, Number Magic e ticket
        {bb=true;}
     }
   return  bb;
  }

*/
//+------------------------------------------------------------------+
//|                       TypeUltimoOrdine()                         | restituisce il "segno" dell'ultimo ordine 
//+------------------------------------------------------------------+
string TypeUltimoOrdine(ulong MagicNumber_)
  {
   if(PositionsTotal()==0){return "";}
   string SymbolChart=Symbol();
   char  aa = 0;
   ulong bb = 0;
   ulong cc = 0;
   string Type="";

   string arr [100];
   ulong arrMagic [100];
   ulong arrTicket [100];
   ulong arrTicketControllati [100];
   string arrBuySellControllati [100];
   string arrBuySell [100];
   ulong arrPrimoOrdine [100];
//------------------------azzera arrTicketControllati ------------------    simbolo
   for(int aa=0; aa<ArraySize(arrTicketControllati); aa++){arrTicketControllati[aa] = 0;}

//------------------------azzera arrBuySellControllati ------------------    simbolo
   for(int aa=0; aa<ArraySize(arrBuySellControllati); aa++){arrBuySellControllati[aa] = " ";}

//------------------------azzera array ------------------    simbolo
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------    magic number
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}

//------------------azzera array Ticket ------------------    ticket
   for(int aa=0; aa<ArraySize(arrTicket); aa++){arrTicket[aa] = 0;}

//------------------azzera array BuySell ------------------    Buy o Sell
   for(int aa=0; aa<ArraySize(arrBuySell); aa++){arrBuySell[aa] = " ";}

//------------------azzera array arrPrimoOrdine -----------    arrPrimoOrdine
   for(int aa=0; aa<ArraySize(arrPrimoOrdine); aa++){arrPrimoOrdine[aa] = 0;}
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
        {
         arr [i]      = PositionSymbol() ;                    //Symbolo
         arrMagic[i]  = PositionMagicNumber();                //Magic number
         arrTicket[i] = PositionTicket();                     //Ticket
        }
     }
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_))  // Controllo Symbol e Magic Number

        {
         if(bb==0) {bb=arrTicket[i];}
         PositionSelectByTicket(bb);
           {if(bb!=0 && bb<arrTicket[i]) bb=arrTicket[i]; if(PositionIsBuy()){Type="Buy";}if(PositionIsSell()){Type="Sell";}}
        }
     }
   return  Type;
  }
  
  
//+------------------------------------------------------------------+
//|                         TypeOrdine()                             | restituisce il "segno" dell'ordine 
//+------------------------------------------------------------------+  
string TypeOrdine(ulong Ticket)
{
string a="";
if(PositionType(Ticket)==0)a="Buy";
if(PositionType(Ticket)==1)a="Sell";
return a;
}
//+------------------------------------------------------------------+
//|               ChiudiOrdDopoNumCand()                             | 
//+------------------------------------------------------------------+  
void ChiudiOrdDopoNumCand(int CloseOrdine,string Symb,ulong magic,string Comm)
{
if(!CloseOrdine || NumOrdini(magic,Comm)==0)return;
 
   bool profitBuy  = false;
   bool profitSell = false; 
   ulong TicketBuy = 0;
   ulong TicketSell = 0;
   int barreOrdineBuy =0;
   int barreOrdineSell = 0;
   double openBuy = 0;
   double openSell = 0;


      if(NumOrdBuy(magic,Comm)==1)
      {
      TicketBuy=TicketPrimoOrdineBuy(magic,Comm);
      openBuy=OpenPricePrimoOrdineBuy(magic,Comm);
      barreOrdineBuy=iBarShift(Symbol(),PERIOD_CURRENT,PositionOpenTime(TicketBuy));
      //Print(" TicketBuy: ",TicketBuy," openBuy: ",openBuy," PositionStopLoss(TicketBuy): ",PositionStopLoss(TicketBuy)," barreOrdineBuy: ",barreOrdineBuy);
      if(barreOrdineBuy<0)barreOrdineBuy=0;
      if(PositionStopLoss(TicketBuy)<openBuy && barreOrdineBuy>=CloseOrdine
         && Ask(Symbol())>=openBuy){brutalCloseBuyTrades(Symb,magic);}
      }      
      
      if(NumOrdSell(magic,Comm)==1)
      {
      TicketSell=TicketPrimoOrdineSell(magic,Comm);
      openSell=OpenPricePrimoOrdineSell(magic,Comm);
      barreOrdineSell=iBarShift(Symbol(),PERIOD_CURRENT,PositionOpenTime(TicketSell));
      
      if(barreOrdineSell<0)barreOrdineSell=0;
      if(PositionStopLoss(TicketSell)>openSell && barreOrdineSell>=CloseOrdine
         && Bid(Symbol())<=openSell)brutalCloseSellTrades(Symb,magic);
      } 

}
//+------------------------------------------------------------------+
//|                      CloseOrderDopoNumCand                       |
//+------------------------------------------------------------------+
void CloseOrderDopoNumCand(int CloseOrdDopoNumCandDalPrimoOrdine__, ulong MagicNum)
  {
   bool a=false;
   if(!CloseOrdDopoNumCandDalPrimoOrdine__) {return;}
   if(SemaforoCandPrimoOrdine(CloseOrdDopoNumCandDalPrimoOrdine__,MagicNum)) {brutalCloseTotal(Symbol(),MagicNum);}
  }
  
//+------------------------------------------------------------------+
//|                    SemaforoCandPrimoOrdine                       |
//+------------------------------------------------------------------+
bool SemaforoCandPrimoOrdine(int CloseOrdDopoNumCandDalPrimoOrdine__, ulong magicNum)
  {
   bool a=false;
   if(!CloseOrdDopoNumCandDalPrimoOrdine__) {return a;}
   bool Slprofit=false;
   bool profit  =false; 
   ulong Ticket=0; 
   if(NumPosizioni(magicNum)==0||NumPosizioni(magicNum)>1){return false;}
   if(NumPosizioni(magicNum)==1)
     {
      if(PositionIsBuy())  Ticket=TicketPrimoOrdine("Buy",magicNum);
      if(PositionIsSell()) Ticket=TicketPrimoOrdine("Sell",magicNum);
      int barreOrdine=iBarShift(Symbol(),PERIOD_CURRENT,PositionOpenTime(Ticket));
      if(barreOrdine<0)barreOrdine=0;
      
      if(TypeOrdine(Ticket)=="Buy" &&PositionStopLoss(Ticket)>OpenPricePrimoOrdineBuy(magicNum)) Slprofit=true;
      if(TypeOrdine(Ticket)=="Sell" && PositionStopLoss(Ticket)!=0 && PositionStopLoss(Ticket)<OpenPricePrimoOrdineSell(magicNum)) Slprofit=true;
      
      if(TypeOrdine(Ticket)=="Buy" &&Ask(Symbol())>OpenPricePrimoOrdineBuy(magicNum))profit=true;
      if(TypeOrdine(Ticket)=="Sell"&&Bid(Symbol())<OpenPricePrimoOrdineSell(magicNum))profit=true;
            
      //Print(" Ticket :",Ticket," PositionStopLoss(Ticket): ",PositionStopLoss(Ticket)," barreOrdine: ",barreOrdine," Slprofit: ",Slprofit," profit: ",profit );
      if(barreOrdine>=CloseOrdDopoNumCandDalPrimoOrdine__&&!Slprofit&&profit)a=true;
     }
   return a;
  }  
  
//+------------------------------------------------------------------+
//|                        slMultiOrdine()                           |
//+------------------------------------------------------------------+  
double slMultiOrdine(ulong Magic, int type,double prof,int DDMaxPerc)
{
double slMultOrd=0;
slMultOrd = PositionsCalculateDDMax(Symbol(),Magic,type,prof,DDMaxPerc);

return slMultOrd;
}   
//+------------------------------------------------------------------+
//|                PositionsCalculateDDMax()                         |
//+------------------------------------------------------------------+ 
double PositionsCalculateDDMax(string symbol,ulong magic,int type,double prof,int DDMaxPerc){
   double calcOfMediumPoint = 0;
   double totalLots_ = 0;
   double slDDMax = 0;
   double valDDMax =(double)AccountInfoDouble(ACCOUNT_BALANCE)-(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-DDMaxPerc);
   for(int a=0;a<PositionsTotal();a++){
      if(PositionSelectByPos(a) && PositionIsSymbol(symbol) && PositionIsMagicNumber(magic,true)){
         if(type == POSITION_TYPE_BUY && PositionIsBuy()){
            //calcOfMediumPoint += PositionOpenPrice()*PositionLots();  // Non consideriamo le commissioni e lo swap per il calcolo preciso del punto medio (lo vedremo in seguito)
            calcOfMediumPoint += PositionOpenPrice()*PositionLots() + PositionCommission()*PositionPoint() - PositionSwap()*PositionPoint(); // Idea approssimativa per conteggiare anche le Commissioni e lo Swap
            totalLots_ += PositionLots();
         }
         if(type == POSITION_TYPE_SELL && PositionIsSell()){
            //calcOfMediumPoint += PositionOpenPrice()*PositionLots();
            calcOfMediumPoint += PositionOpenPrice()*PositionLots() - PositionCommission()*PositionPoint() + PositionSwap()*PositionPoint();
            totalLots_ += PositionLots();
         }
      }
   }
   double MediumPoint = 0;
   if(totalLots_ > 0) { MediumPoint = calcOfMediumPoint/totalLots_;
  // calcOfMediumPoint = prof
  // slDDMax =  
}   
   return slDDMax;
}
//+------------------------------------------------------------------+
//|                PositionsCalculateDDMax()                         |
//+------------------------------------------------------------------+ 
double PositionDDMax(int DDMaxPerc,ulong Magic)
 {
 double valDDMax =(double)AccountInfoDouble(ACCOUNT_BALANCE)-(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-DDMaxPerc);
 //Print(" ValDDMax*Position: ",valDDMax*PositionPoint());
 return valDDMax;
 }
//+------------------------------------------------------------------+
//|                        GestioneGriglia()                         |
//+------------------------------------------------------------------+
void GestioneGriglia(int typeGrid,ulong magic_num,bool TpSeDueOrd,double profitGrid_,bool &GridBuyActiv,bool &GridSellActiv,bool BEPointConGridOHedgeActiv,
      int NumMaxGrid_,double MoltipliNumGrid_,double MoltiplLotStep_,int StartGrid_,int StepGrid_,double moltStepGrid_,int Deviazione_,string Commen_)
   {
   if(typeGrid!=1)return;
     
      PositionSelectByIndex(0);

      double Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
      double Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      static double arrayGridLossBuy[50];
      static double arraysGridLossSell[50];

      static char  NumOrdBuyGrid=0;
      static char  NumOrdSellGrid=0;
      double LotGridBuy=0;
      double LotGridSell=0;

      static int indexBuy ;
      static int indexSell;

      ulong TicketPrimoOrdineBuy_ = TicketPrimoOrdineBuy(magic_num);
      ulong TicketPrimoOrdineSell_ = TicketPrimoOrdineSell(magic_num);
      /////////////////////////////////
      if(PositionTakeProfit(TicketPrimoOrdineBuy_)>0.0&&TpSeDueOrd&&(GridBuyActiv||GridSellActiv))
        {
         PositionModify(TicketPrimoOrdineBuy_,0,0,true);
        }
      if(PositionTakeProfit(TicketPrimoOrdineSell_)>0.0&&TpSeDueOrd&&(GridBuyActiv||GridSellActiv))
        {
         PositionModify(TicketPrimoOrdineSell_,0,0,true);
        }

      /////////////////////////////////////

      if(!TicketPrimoOrdineBuy_ && !TicketPrimoOrdineSell_){return;}

      if(NumOrdBuy(magic_num)>1&&NumOrdSell(magic_num)==1&&PositionTakeProfit(TicketPrimoOrdineSell_)!=0.0){PositionModify(TicketPrimoOrdineSell_,0,0,true);}
        
      if(NumOrdSell(magic_num)>1&&NumOrdBuy(magic_num)==1&&PositionTakeProfit(TicketPrimoOrdineBuy_!=0.0)){PositionModify(TicketPrimoOrdineBuy_,0,0,true);}

      if(GridBuyActiv && PositionsTotalProfitFullRunning(Symbol(),magic_num,POSITION_TYPE_BUY)>= profitGrid_)
        {
         brutalCloseBuyPositions(Symbol(),magic_num);
         indexBuy=0;
         GridBuyActiv=false;
         NumOrdBuyGrid=0;
        }

      if(GridSellActiv && PositionsTotalProfitFullRunning(Symbol(),magic_num,POSITION_TYPE_SELL)>= profitGrid_)
        {
         brutalCloseSellPositions(Symbol(),magic_num);
         indexSell=0;
         GridSellActiv=false;
         NumOrdSellGrid=0;
        }

      if(((GridBuyActiv || GridSellActiv) && (PositionsTotalProfitFullRunning(Symbol(),magic_num,POSITION_TYPE_BUY)
         + PositionsTotalProfitFullRunning(Symbol(),magic_num,POSITION_TYPE_SELL)) >= profitGrid_) 
        )
        {
         brutalCloseTotal(Symbol(),magic_num);
         indexBuy=0;
         GridBuyActiv=false;
         NumOrdBuyGrid=0;
         indexSell=0;
         GridSellActiv=false;
         NumOrdSellGrid=0;
         return;
        }
      
      if(typeGrid!=0 && !NumOrdBuy(magic_num))
        {
         indexBuy=0;
         GridBuyActiv=false;
         NumOrdBuyGrid=0;
        }

      if(typeGrid!=0 && !NumOrdSell(magic_num))
        {
         indexSell=0;
         GridSellActiv=false;
         NumOrdSellGrid=0;

         if(!BEPointConGridOHedgeActiv && (GridBuyActiv || GridSellActiv))
           {
            if(PositionStopLoss(TicketPrimoOrdineBuy_)){PositionModify(TicketPrimoOrdineBuy_,0,0,true);}
            
            if(PositionStopLoss(TicketPrimoOrdineSell_)){PositionModify(TicketPrimoOrdineSell_,0,0,true);}
           }
        }
         if(!NumOrdBuy(magic_num))
           {
            indexBuy=0;
            GridBuyActiv=false;
            NumOrdBuyGrid=0;
           }
      if((NumOrdBuy(magic_num)||NumOrdSell(magic_num)) && typeGrid!=0)
        {
         if(NumOrdBuy(magic_num) && Bid<OpenPricePrimoOrdineBuy(magic_num))
           {
            if(NumOrdBuy(magic_num))
              {
              if(newUlongBuy(TicketPrimoOrdineBuy_))
              {
               for(int aa=0; aa<ArraySize(arrayGridLossBuy); aa++){arrayGridLossBuy[aa] = 0.0;}
               for(int i=0; i<=NumMaxGrid_; i++)
                 {
                  if(i==0){arrayGridLossBuy[i]=OpenPricePrimoOrdineBuy(magic_num)-((StartGrid_)*Point());}
                  
                  if(i>0){arrayGridLossBuy[i]=arrayGridLossBuy[i-1]-(((MathPow(moltStepGrid_,i-1)*StepGrid_))*Point());}
                 }
                 }
               for(int i=indexBuy; i<NumMaxGrid_; i++)

                 {
                  if(MoltipliNumGrid_<=(NumOrdBuy(magic_num)-1) && MoltipliNumGrid_ >= 0)
                    {
                     if(typeGrid == 0){LotGridBuy=LotsPrimoOrdineBuy(magic_num)*MoltiplLotStep_;}
                     
                     if(typeGrid == 1){LotGridBuy=NormalizeDoubleLots(LotsUltimoOrdineBuy(magic_num)*MoltiplLotStep_);}
                    }
                  if(MoltipliNumGrid_> (NumOrdBuy(magic_num)-1) && MoltipliNumGrid_ >= 0){LotGridBuy=LotsPrimoOrdineBuy(magic_num);}

                  if(SymbolInfoDouble(Symbol(),SYMBOL_ASK)<=arrayGridLossBuy[indexBuy])

                    {
                     SendPosition(Symbol(),ORDER_TYPE_BUY, LotGridBuy,0,Deviazione_, 0,0,Commen_,magic_num);
                     indexBuy=i+1;
                     GridBuyActiv=true;
                     NumOrdBuyGrid++;
                     
                     if(PositionTakeProfit(TicketPrimoOrdineBuy_)>0.0){PositionModify(TicketPrimoOrdineBuy_,0,0,true);}
                       
                     if(PositionTakeProfit(TicketPrimoOrdineSell_)>0.0&&TpSeDueOrd){PositionModify(TicketPrimoOrdineSell_,0,0,true);}
                    }
                 }
              }
           }

         if(!TicketPrimoOrdineSell_)
           {
            indexSell=0;
            GridSellActiv=false;
            NumOrdSellGrid=0;
           }         
         if(TicketPrimoOrdineSell_ && Ask>OpenPricePrimoOrdineSell(magic_num))
           {
            if(NumOrdSell(magic_num))
              {
               if(newUlongSell(TicketPrimoOrdineSell_)) 
               {
               for(int aa=0; aa<ArraySize(arraysGridLossSell); aa++){arraysGridLossSell[aa] = 0.0;}
               for(int i=0; i<=NumMaxGrid_; i++)
                 {
                  if(i==0){arraysGridLossSell[i]=OpenPricePrimoOrdineSell(magic_num)+(StartGrid_)*Point();}
                  
                  if(i>0){arraysGridLossSell[i]=arraysGridLossSell[i-1]+(((MathPow(moltStepGrid_,i-1)*StepGrid_))*Point());}
                 }
              }}
            for(int i=indexSell; i<NumMaxGrid_; i++)

              {
               if(MoltipliNumGrid_<=(NumOrdSell(magic_num)-1) && MoltipliNumGrid_ >= 0)
                 {
                  if(typeGrid == 0)
                    {LotGridSell=LotsPrimoOrdineSell(magic_num)*MoltiplLotStep_;}
                  if(typeGrid == 1){LotGridSell=NormalizeDoubleLots(LotsUltimoOrdineSell(magic_num)*MoltiplLotStep_);}
                 }
               if(MoltipliNumGrid_> (NumOrdSell(magic_num)-1) && MoltipliNumGrid_ >= 0){LotGridSell=LotsPrimoOrdineSell(magic_num);}

               if(SymbolInfoDouble(Symbol(),SYMBOL_BID)>=arraysGridLossSell[indexSell])

                 {
                  SendPosition(Symbol(),ORDER_TYPE_SELL, LotGridSell,0,Deviazione_, 0,0,Commen_,magic_num);
                  indexSell=i+1;
                  GridSellActiv=true;
                  NumOrdSellGrid++;
                  if(PositionTakeProfit(TicketPrimoOrdineSell_)>0.0){PositionModify(TicketPrimoOrdineSell_,0,0,true);}
                  if(PositionTakeProfit(TicketPrimoOrdineBuy_)>0.0&&TpSeDueOrd){PositionModify(TicketPrimoOrdineBuy_,0,0,true);}
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                         NumOrdHedge                              |restituisce il numero di ordini aperti Hedge
//+------------------------------------------------------------------+
char NumOrdHedge(ulong MagicNumber_,string comment_)
  {
   if(PositionsTotal()==0)
     {
      return 0;
     }
   string SymbolChart=Symbol();
   string BuySell = "Buy";
   ulong bb = 0;
   int x = PositionsTotal();
   string arr [100];
   string arrPositionSymbol [100];
   ulong arrMagic [100];
   ulong arrTicket[100];
//------------------------azzera array ------------------ Simbolo
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------  Numero magico
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }

//------------------azzera array arrPositionSymbol ------------------   Posizione
   for(int aa=0; aa<ArraySize(arrPositionSymbol); aa++)
     {
      arrPositionSymbol[aa] = " ";
     }
//--------------------- controllo posizioni ------------- 
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      arr [i]      = PositionSymbol() ;                    //Symbolo
      arrMagic[i]  = PositionMagicNumber();                //Magic number
      arrTicket[i] = PositionTicket();                     //Ticket
     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if((string)arr[i] == (string)SymbolChart && arrMagic[i] == MagicNumber_ && StringFind(PositionComment(arrTicket[i]),comment_,0) != -1)
        {
         aa++;
         bb = PositionTicket();
        }
     }
   return aa;
  }
//+------------------------------------------------------------------+
//|                            OrdHedge                              |restituisce true se sono presenti ordini Hedge
//+------------------------------------------------------------------+
bool OrdHedge(ulong MagicNumber_) 
{return (bool)NumOrdHedge(MagicNumber_,"Hedge");} 
//+------------------------------------------------------------------+
//|                         NumOrdHedgeBuy_                          |restituisce il numero di ordini aperti Hedge Buy
//+------------------------------------------------------------------+
char NumOrdHedgeBuy_(ulong MagicNumber_)  
{return NumOrdHedge(MagicNumber_,"HedgeBuy");}  

//+------------------------------------------------------------------+
//|                         NumOrdHedgeSell_                          |restituisce il numero di ordini aperti Hedge Sell
//+------------------------------------------------------------------+
char NumOrdHedgeSell_(ulong MagicNumber_)  
{return NumOrdHedge(MagicNumber_,"HedgeSell");}  
//+------------------------------------------------------------------+
//|                         HedgeBuyActive                           |restituisce true se sono presenti ordini Hedge Buy
//+------------------------------------------------------------------+
bool HedgeBuyActive(ulong MagicNumber_)  
{return (bool)NumOrdHedge(MagicNumber_,"HedgeBuy");}    
//+------------------------------------------------------------------+
//|                         HedgeSellActive                           |restituisce true se sono presenti ordini Hedge Sell
//+------------------------------------------------------------------+
bool HedgeSellActive(ulong MagicNumber_)  
{return (bool)NumOrdHedge(MagicNumber_,"HedgeSell");} 


//+------------------------------------------------------------------+
//|                            OrderType()                           |restituisce il Tipo di ordine "Buy" o "Sell"
//+------------------------------------------------------------------+
string TypeOrder(ulong Ticket)
  {
      string BuySell="";
   if(!PositionsTotal())return "";    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {   
      PositionSelectByPos(i);
   if(Ticket==PositionTicket())
   {
   if(PositionIsBuy()){BuySell="Buy";}
   if(PositionIsSell()){BuySell="Sell";}
   }}
   return BuySell;
  }
//+------------------------------------------------------------------+
//|                          TicketPresente()                        |restituisce true se il ticket è presente negli ordini aperti
//+------------------------------------------------------------------+      
bool TicketPresente(ulong Ticket)
   {
      bool a=false;
   if(!PositionsTotal())return false;    
   for(int i=PositionsTotal()-1; i>=0; i--)
     {PositionSelectByPos(i); if(Ticket==PositionTicket()){a=true;}
   }
   return a;
   }
   
//+------------------------------------------------------------------+
//|                    maxOrd_BuySellBuy ()                          |
//+------------------------------------------------------------------+  
bool maxOrd_BuySellBuy(int maxOrd,int typeOrd,ulong magic,string comment)
{
bool a = true;
if(NumOrdini(magic,comment)>=maxOrd){a=false;return a;}
if(NumOrdBuy(magic,comment)){a=false;return a;}
if(typeOrd==2){a=false;return a;}
return a;
}

bool maxOrd_BuySellSell(int maxOrd,int typeOrd,ulong magic,string comment)
{
bool a = true;
if(NumOrdini(magic,comment)>=maxOrd){a=false;return a;}
if(NumOrdSell(magic,comment)){a=false;return a;}
if(typeOrd==1){a=false;return a;}
return a;
} 

//+------------------------------------------------------------------+
//|                           StopNewsOrders                         |
//+------------------------------------------------------------------+
bool StopNewsOrders(bool StopNewsOrder,ulong magic,string comment)
  {
   bool a=false;
   static char xxx=0;
   if(!StopNewsOrder)
     {
      xxx=0;
      a = false;
      return a;
     }
   if(StopNewsOrder&&NumPosizioni(magic,comment)==0&&xxx==0)
     {
      Print("Auto Stop News Orders EA ",Symbol());
      Comment("Auto Stop News Orders EA ",Symbol());
      Alert("Auto Stop News Orders EA ",Symbol());
      xxx++;
     }
   if(StopNewsOrder&&NumPosizioni(magic,comment)==0)
      a = true;
   return a;
  }  
//+------------------------------------------------------------------+
//|                            spreadMax                             |
//+------------------------------------------------------------------+
//input int maxSpread                                          =    0;        //Spread Max consentito
bool spreadMax(int maxSpread)
  {
   bool a=false;
   if(maxSpread==0 || ((Spread(Symbol()) < maxSpread) && maxSpread!=0))
     {
      a=true;
     }
   return a;
  }     