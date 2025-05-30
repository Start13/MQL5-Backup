//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                    Copyright 2023, Corrado Bruni |
//|                                        http://www.cbalgotrade.com|
//+------------------------------------------------------------------+
#include <MyLibrary\tradeManagement.mqh>
#include <MyInclude\PosizioniTicket.mqh>
#include <MyLibrary\MyLibrary.mqh>


//+------------------------------------------------------------------+
//|                  Moltiplicazione per eliminare virgola           |
//+------------------------------------------------------------------+
double rende_intero(int a)
  {
   double b = 1;
   switch(a)
     {
      case 0:
         b=1;
         break;
      case 1:
         b=10;
         break;
      case 2:
         b=100;
         break;
      case 3:
         b=1000;
         break;
      case 4:
         b=10000;
         break;
      case 5:
         b=100000;
         break;
      case 6:
         b=1000000;
         break;
      case 7:
         b=10000000;
         break;
      case 8:
         b=100000000;
         break;
      case 9:
         b=1000000000;
         break;
      case 10:
         b=1000000000;
         break;
     }
   return b;
  }
//+------------------------------------------------------------------+
//|                       virgola_increm_                            |
//+------------------------------------------------------------------+
double virgola_increm_(int a)
  {
   double b = 1;
   switch(a)
     {
      case 0:
         b=1;
         break;
      case 1:
         b=0.1;
         break;
      case 2:
         b=0.01;
         break;
      case 3:
         b=0.001;
         break;
      case 4:
         b=0.0001;
         break;
      case 5:
         b=0.00001;
         break;
      case 6:
         b=10;
         break;
      case 7:
         b=100;
         break;
      case 8:
         b=1000;
         break;
      case 9:
         b=10000;
         break;
      case 10:
         b=10000;
         break;
     }
   return b;
  }


//+------------------------------------------------------------------+
//|                       Input e variabili export                   |////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
double SniperDati(const double &valoriArr_[], const string &sniperString_[], string nomeRicerca)
  {
   double a = 0;
   for(int i=ArraySize(valoriArr_)-1; i>=0; i--)
     {
      if(nomeRicerca == sniperString_[i])
        {
         a = valoriArr_[i];
         i = -1;
        }
     }
   return a;
  }
  /*                                 arrInput [0] = TS_pips;
                              arrInput [1] = Ts_Step_pips;
                              arrInput [2] = Sl_n_livelli_prima;
                              arrInput [3] = (int) segno_ordine;
                              arrInput [4] = TsLevPrec_;
                              arrInput [5] = Type_Orders_;
                              arrInput [6] = BreakEven;                             //Modalità Be: No/Pips/Livello successivo
                              arrInput [7] = Be_Start_pips;                         //Be in pips
                              arrInput [8] = Be_Step_pips;                          //Be step in pips
                              arrInput [9] = BE_PercLevelbylevel;                   //Se l'ordine apre sopra questa % al livello successivo...
                              //  arrInput [10]= Be_start_lev;                      //A questa % LelByLev interviene il Be
                              arrInput [11]= PosizAperLiv;                          //Consente l'apertura di altre posizioni sullo stesso livello
                              arrInput [12]= PercLivPerOpenPos;
                              arrInput [13]= Filter_Moving_Average;                 //Abilita/Disabilita Moving Average
                              arrInput [14]= Filter_ATR;
                              arrInput [15]= Filter_RSI;
                              arrInput [16]= Filter_RSIstok;
                              arrInput [17]= FilterMACD;
                              arrInput [18]= Filter_TEMA;
                              arrInput [19]= TpSlInProfit;
                              arrInput [3] = (int) segno_ordine;
                              arrInput [20]= GridBuyActive;
                              arrInput [21]= GridSellActive;
                              arrInput [22]= OrdiniSuStessaCandela;
                              //arrInput [23]= PercLivNoOpenPos;
                              arrInput [24]= NumOrdHedgeBuy(TicketHedgeBuy);
                              arrInput [25]= NumOrdHedgeSell(TicketHedgeSell);
                              //arrInput [30]= BEPointConGridOHedgeActive;
                              //arrInput [31]= TypeCandle_; */
//+------------------------------------------------------------------+
//|                         Trailing Stop                            |
//+------------------------------------------------------------------+

void switcTs(char TrailingStop_, const string &sniperString_[], const int &arrInput_[], const double &valoriArr_[], const ulong MagicNumber_)
  {
   if((bool)arrInput_[20] || (bool)arrInput_[21] || arrInput_[24]>1 || arrInput_[25]>1)// GridBuyActive  GridSellActive  NumOrdHedgeBuy  NumOrdHedgeSell
      return;
   switch(TrailingStop_)
     {
      case 0:
         return;
      case 1:
         NumPosiz(1, sniperString_, arrInput_, valoriArr_, MagicNumber_);
         return; //Ts Pips
      case 2:
         NumPosiz(2, sniperString_, arrInput_, valoriArr_, MagicNumber_);
         return; //Ts Lev By Lev
      case 3:
         NumPosiz(3, sniperString_, arrInput_, valoriArr_, MagicNumber_);
         return; //Ts Tradizionale in punti       
      case 4: 
         //TrailStopCandle(arrInput_, valoriArr_, MagicNumber_);
         return; 
     }
  }

//+------------------------------------------------------------------+
//|              Numero Posizioni con indice                         |
//+------------------------------------------------------------------+
void NumPosiz(char indice, const string &sniperStri[], const int &arrInput__[], const double &valoriA[],const ulong MagicNumber_)  //Gestisce posizioni Buy/Sell, magic, e fornisce i dati alle due funzioni TsPips e TsLevByLev
  {
   long bb = 0;
   int x = PositionsTotal();
   string arr [100];
   long arrMagic [100];
//------------------------azzera array ------------------
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      //arr [i] =(string) Symbol((string)PositionSelectByPos(i));
      PositionSelectByPos(i);

      arr [i] = PositionSymbol() ;
      arrMagic[i] = PositionMagicNumber();

     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)Symbol())) && (arrMagic[i] == PositionMagicNumber()))
        {
         aa++;
         bb = PositionTicket();

         switch(indice)
           {
            case 1:
               TrailStPips(sniperStri, valoriA, arrInput__, MagicNumber_);
               break; //Ts Pips
            case 2:
               TsLevByLev(sniperStri, valoriA, arrInput__);
               break;
            case 3:
               //TsTradiz(sniperStri, valoriA, arrInput__, MagicNumber_);
               PositionsTrailingStopInStep(arrInput__[0],arrInput__[1],Symbol(),MagicNumber_,0);
               break;   
           }
        }
     }
  }
  /*
   arrInput [0] = TS_pips;
   arrInput [1] = Ts_Step_pips;
  
  /*
  arrInput [3] = (int) segno_ordine;
               arrInput [20]= GridBuyActive;
               arrInput [21]= GridSellActive;
               //arrInput [23]= PercLivNoOpenPos;
               arrInput [24]= NumOrdHedgeBuy(TicketHedgeBuy);
               arrInput [25]= NumOrdHedgeSell(TicketHedgeSell);
  */
//+------------------------------------------------------------------+
//|                            TsTradiz                              |
//+------------------------------------------------------------------+
void TsTradiz(const string &sniperStri[], const double &valoriA[], const int &arrInput_[], const ulong MagicNumber_)
   {   
   double ask=Ask(Symbol());
   double bid=Bid(Symbol());
   double tSto =Point()* arrInput_[0];
   double tStep =Point()* arrInput_[1];
   
   static double StartBuy = 0.0;
   static double StartSell = 0.0;
   
   ulong TicketPrOrdBuy = TicketPrimoOrdineBuy(MagicNumber_);
   double stoplossBuy   = PositionStopLoss(TicketPrOrdBuy);
   ulong TicketPrOrdSell= TicketPrimoOrdineSell(MagicNumber_);
   double stoplossSell  = PositionStopLoss(TicketPrOrdSell);

   double openOrderBuy  = OpenPricePrimoOrdineBuy(MagicNumber_);
   double openOrderSell = OpenPricePrimoOrdineSell(MagicNumber_);
   double prezzoBuy     = ask;
   double prezzoSell    = bid;  
   
   if((NumOrdBuy(MagicNumber_)==0)  && !arrInput_[20] && !arrInput_[21])StartBuy=0.0; 
   if((NumOrdSell(MagicNumber_)==0) && !arrInput_[20] && !arrInput_[21])StartSell=0.0;
   if((NumOrdBuy(MagicNumber_)==0 && NumOrdSell(MagicNumber_)==0) || (arrInput_[20]>0 || arrInput_[21]>0))
      {StartBuy=0.0;StartSell=0.0;return;}   

   if(!TicketPrOrdBuy || arrInput_[20]>0 || arrInput_[25]>=2)
   {
    StartBuy=0.0;
   }
   if(!TicketPrOrdSell || arrInput_[21]>0 || arrInput_[24]>=2)
   {
    StartSell=0.0;
   }
   if(TicketPrOrdBuy && !arrInput_[20] && arrInput_[25]<2)
     {  
      if(StartBuy== 0.0){StartBuy=OpenPricePrimoOrdineBuy(MagicNumber_);}
      //Print(" StartBuy: ",StartBuy," TicketPrOrdBuy: ",TicketPrOrdBuy, " openOrderBuy: ",openOrderBuy," openOrderSell: ",openOrderSell);   
      if(StartBuy!=0.0)StartBuy=stoplossBuy;              
      if(ask > (stoplossBuy + (tSto)))
        {
         for(int i=1; i<=30; i++)
           {
            if(ask > (StartBuy))
              {
               PositionModify(TicketPrOrdBuy,(NormalizeDouble((ask - tStep),Digits())),PositionTakeProfit(TicketPrOrdBuy));
               StartBuy=ask + (tSto);
              }
           }
        }
     }

   if(TicketPrOrdSell && !arrInput_[21] && arrInput_[24]<2)
     { 
      if(StartSell== 0.0){StartSell=OpenPricePrimoOrdineSell(MagicNumber_);}  
      if(StartSell!=0.0)StartSell=stoplossSell;   
        Print(" NumOrdSell(MagicNumber_): ",NumOrdSell(MagicNumber_)," TicketPrimoOrdineSell(MagicNumber_): ",TicketPrimoOrdineSell(MagicNumber_)," arrInput_[20]: ",arrInput_[20]," arrInput_[21]: ",arrInput_[21]);
      Print(" StartSell: ",StartSell," TicketPrOrdSell: ",TicketPrOrdSell, " prezzoSell: ",prezzoSell," stoplossSell: ",stoplossSell);
      if(bid < (stoplossSell - (tSto)))
        {
         for(int i=1; i<=30; i++)
           {
            if(bid < (StartSell))  
              Print(" bid: ",bid," tSto: ",tSto);
            //Print(" tSto * (i): ",tSto * (i));  // if (PositionCurrentPrice() < (openOrder - (tSto * (i))))
              {
               PositionModify(TicketPrOrdSell,(NormalizeDouble(bid + tStep,Digits())),PositionTakeProfit(TicketPrOrdSell));
               StartSell=bid - (tSto);
            
           }
        }
     }
  }
}
   
//+------------------------------------------------------------------+
//|                             Ts Pips                              |
//+------------------------------------------------------------------+
void TrailStPips(const string &sniperStrin[], const double &valoriArr_[],const int &arrInput_[], const ulong MagicNumber_)
  {
//PositionSelectByIndex();

   double ask=Ask(Symbol());
   double bid=Bid(Symbol());
   ulong TicketPrOrd=TicketPrimoOrdineBuy(MagicNumber_);
   double tSto =Point()* arrInput_[0];
   double tStep =Point()* arrInput_[1];
   double prezzo = ask;
   double stoploss = PositionStopLoss(TicketPrOrd);
   double openOrder = PositionOpenPrice(TicketPrOrd);
   double OpenStopL = 0.0;

   if(TicketPrOrd && !arrInput_[20] && arrInput_[25]<2)
     {
      if(stoploss < openOrder){OpenStopL = openOrder;}
      if(stoploss > openOrder){OpenStopL = stoploss;}//Print("stoploss Buy: ",stoploss);
      if(prezzo > (openOrder + (tSto)))
        {
         for(int i=1; i<=30; i++)
           {
            if(prezzo > (OpenStopL + (tSto * (i)))){PositionModify(TicketPrOrd,(NormalizeDouble((OpenStopL + tStep),Digits())),PositionTakeProfit());}
           }
        }
     }

   TicketPrOrd=TicketPrimoOrdineSell(MagicNumber_);
   stoploss = PositionStopLoss(TicketPrOrd);
   openOrder = PositionOpenPrice(TicketPrOrd);
   OpenStopL = 0.0;
   prezzo    = bid;

   if(TicketPrOrd && !arrInput_[21] && arrInput_[24]<2)
     {
      if(stoploss > openOrder){OpenStopL = openOrder;}
      if(stoploss < openOrder){OpenStopL =  stoploss;}
      if(stoploss <= 0.0){OpenStopL = openOrder;}
      //Print(" Ticket Sell: ",TicketPrOrd," PositionStopLoss(TicketPrOrd): ",PositionStopLoss(TicketPrOrd)," OpenStopL Sell: ",OpenStopL);Print("openOrder: ",openOrder);
      if(prezzo < (OpenStopL - (tSto)))
        {
         for(int i=1; i<=30; i++)
           {
            if(prezzo < (OpenStopL - (tSto * (i)))){PositionModify(TicketPrOrd,(NormalizeDouble(OpenStopL - tStep,Digits())),PositionTakeProfit());}
           }
        }
     }
  }

//--------------------- Ts level by level -----------------------
void TsLevByLev(const string &sniperStringg[],const double &valoriArrr[], const int&arrInpu[])
  {

   char a = fasciaDiPrezzoP(PositionCurrentPrice(), true, sniperStringg, valoriArrr);   /// Prezzo corrente fascia
   char x = fasciaDiPrezzoP(PositionOpenPrice(), true, sniperStringg, valoriArrr);    //// Open Price fascia
   char y = 0;
   double sl_ = 0;

   if(PositionIsBuy() && !arrInpu[20] && arrInpu[25]<2)
     {
      if(a > x)  //fascia prezzo > fascia Open Ordine
        {
         sl_ = DaFasciaLev_APrezzo(true, arrInpu[4], a, sniperStringg, valoriArrr);   //fascia dello stop loss nuovo
           {
            if(fasciaDiPrezzoP(PositionStopLoss(), true, sniperStringg, valoriArrr) < (fasciaDiPrezzoP(sl_, true, sniperStringg, valoriArrr)) || PositionStopLoss() == 0)
              {
               if(NormalizeDouble(sl_,Digits() > PositionStopLoss()) || PositionStopLoss() == 0)
                 {
                  PositionModify(PositionTicket(),(NormalizeDouble(sl_,Digits())),PositionTakeProfit());
                  return;  //////////////*********************
                 }
              }
           }
        }
     }

   if(PositionIsSell() && !arrInpu[21] && arrInpu[24]<2)
     {
      if(a < x)  /////////////************* controllare
        {
         sl_ = DaFasciaLev_APrezzo(true, arrInpu[4], a, sniperStringg, valoriArrr);
           {
            if(fasciaDiPrezzoP(PositionStopLoss(), true, sniperStringg, valoriArrr) > (fasciaDiPrezzoP(sl_, true, sniperStringg, valoriArrr)) || PositionStopLoss() == 0)
              {
               if(NormalizeDouble(sl_,Digits() < PositionStopLoss()) || PositionStopLoss() == 0)
                 {
                  PositionModify(PositionTicket(),(NormalizeDouble(sl_,Digits())),PositionTakeProfit());
                  return;  //////////////*********************
                 }
              }
           }
        }
     }
  }

/*arrInput [3] = (int) segno_ordine;
               arrInput [20]= GridBuyActive;
               arrInput [21]= GridSellActive;
               //arrInput [23]= PercLivNoOpenPos;
               arrInput [24]= NumOrdHedgeBuy(TicketHedgeBuy);
               arrInput [25]= NumOrdHedgeSell(TicketHedgeSell);
               arrInput [7] = Be_Start_pips;                         //Be in pips
               arrInput [8] = Be_Step_pips;                          //Be step in pips
*/               
//*------------------------ Be in Pips -----------------------------
void BePips(const string &sniper_String[], const int&arr_Input[], const double &valori_Arr[], const ulong MagicNumber_)
  {
   ulong TicketPrOrdBUY=TicketPrimoOrdineBuy(MagicNumber_);
   double ask=Ask(Symbol());
   double bid=Bid(Symbol());
   double stoplossBuy = PositionStopLoss(TicketPrOrdBUY);
   double openOrderBuy = PositionOpenPrice(TicketPrOrdBUY);
   //double OpenStopL = 0.0;

   bool y=false;
   bool z=false;
   bool m=true;
   bool n=true;
   static ulong a = 0;
   
   bool enableBe = arr_Input[30]; //enable Be with Orders Grid Hedge Activated
   
   if(!TicketPrOrdBUY){a=0;}
   if(TicketPrOrdBUY && !arr_Input[20] && arr_Input[25]<2)//Primo ordine Buy presente e nessuna griglia o hedge attiva
     {
     if(!arr_Input[30] && (arr_Input[21]>0 || arr_Input[24]>1)){m=false;}//enable BE disable e griglia o hedge attiva
     // if(a == TicketPrOrdBUY)
      //   return;
      if(a != TicketPrOrdBUY)
        {
         if(stoplossBuy==0.0){y=true;};   
         if((ask >= openOrderBuy + Point()*arr_Input[7]) && (stoplossBuy < (openOrderBuy+Point()*arr_Input[8])|| y) && m)
           {
            if(NormalizeDouble((openOrderBuy+Point()*arr_Input[8]),Digits())!=stoplossBuy)
            {
            PositionModify(TicketPrOrdBUY,(NormalizeDouble((openOrderBuy+Point()*arr_Input[8]),Digits())),PositionTakeProfit());
            a = TicketPrOrdBUY;
             }
           }
        }
     }

   ulong TicketPrOrdSELL=TicketPrimoOrdineSell(MagicNumber_);
   static ulong b = 0;

   double stoplossSell = PositionStopLoss(TicketPrOrdSELL);
   double openOrderSell = PositionOpenPrice(TicketPrOrdSELL);
   //OpenStopL = 0.0;
   if(!TicketPrOrdSELL){b=0;}
   if(TicketPrOrdSELL && !arr_Input[21] && arr_Input[24]<2)
     {
     if(!arr_Input[30] && (arr_Input[20]>0 || arr_Input[25]>1)){n=false;}
      //if(b == TicketPrOrdSELL)
       //  return;
      if(b != TicketPrOrdSELL)
        {
         if(stoplossSell==0.0){z=true;};

         if((bid <= openOrderSell - Point()*arr_Input[7]) && (stoplossSell > (openOrderSell-Point()*arr_Input[8])|| z) && n)
           {
            if(NormalizeDouble((openOrderSell-Point()*arr_Input[8]),Digits())!=stoplossSell)
            {
            PositionModify(TicketPrOrdSELL,(NormalizeDouble((openOrderSell-Point()*arr_Input[8]),Digits())),PositionTakeProfit());
            b = TicketPrOrdSELL;
             }
           }
        }
     }
  }

//*------------------------ Be in Level -----------------------------
void BeLev(const string &sniper_String[], const int&arr_Input[], const double &valori_Arr[], const ulong MagicNumber_)
  {
   static long a = 0;
   char b = 0;
   double c = 0;
   double d = 0;
   if(PositionIsBuy() && !arr_Input[20] && arr_Input[25]<2)
     {
      //Print (PositionTicket());
      if(a == PositionTicket())
         return;
      if(a != PositionTicket())
        {
         b = fasciaDiPrezzoP(PositionCurrentPrice(),true,sniper_String,valori_Arr);                                                                                                     // Fascia di prezzo del prezzo corrente
         c = ((DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr) - DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr)) / 100 * arr_Input[9])+ DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr);//Soglia per passare a pips
         d = ((DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr) - DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr)))+ DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr);//Soglia Be LevByLev per attivare Be
         //Print ("Prezzo 0: ", DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr), " Prezzo -1: ",DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr), " c: ",c, " d: ",d);
         if((PositionOpenPrice() < c) && (PositionCurrentPrice() >= d && PositionStopLoss() < (NormalizeDouble((PositionOpenPrice()+Point()*arr_Input[8]),Digits()))))
           {
            PositionModify(PositionTicket(),(NormalizeDouble((PositionOpenPrice()+Point()*arr_Input[8]),Digits())),PositionTakeProfit());
            a = PositionTicket();
            return;
           }
         if((PositionOpenPrice() >= c) && (PositionCurrentPrice() >= PositionOpenPrice() + Point()*arr_Input[7]) && PositionStopLoss() < (NormalizeDouble((PositionOpenPrice()+Point()*arr_Input[8]),Digits())))
           {
            BePips(sniper_String, arr_Input, valori_Arr, MagicNumber_);
            return;
           }
        }
     }
   if(PositionIsSell() && !arr_Input[21] && arr_Input[24]<2)
     {
     // Print("Position Sell: ",PositionTicket());
      if(a == PositionTicket())
         return;
      if(a != PositionTicket())
        {
         b = fasciaDiPrezzoP(PositionCurrentPrice(),true,sniper_String,valori_Arr);  // Fascia di prezzo del prezzo corrente
         c = ((DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr) - DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr))/ 100 * arr_Input[9]) + DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr);//Prezzo soglia
         d = ((DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr) - DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr))) + DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr);//Soglia Be LevByLev per attivare Be

         //Print ("Prezzo 0: ", DaFasciaLev_APrezzo(true,0,b,sniper_String, valori_Arr), " Prezzo -1: ",DaFasciaLev_APrezzo(true,-1,b,sniper_String, valori_Arr), " c: ",c, " d: ",d);
         if((PositionOpenPrice() > c) &&(PositionCurrentPrice() <= d) && PositionStopLoss() > (NormalizeDouble((PositionOpenPrice()-Point()*arr_Input[8]),Digits())))
           {
            PositionModify(PositionTicket(),(NormalizeDouble((PositionOpenPrice()+Point()*arr_Input[7]),Digits())),PositionTakeProfit());
            a = PositionTicket();
            return;
           }
         if((PositionOpenPrice() <= c) && (PositionCurrentPrice() <= PositionOpenPrice() - Point()*arr_Input[7]) && PositionStopLoss() > (NormalizeDouble((PositionOpenPrice()-Point()*arr_Input[8]),Digits())))
           {
            BePips(sniper_String, arr_Input, valori_Arr, MagicNumber_);
            return;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                               switchBeB                          |
//+------------------------------------------------------------------+
void switchBeB(const string &sniperString_[], const int &arrInput_[], const double &valoriArr_[],const ulong MagicNumber_)
  {
   switch(arrInput_[6])
     {
      case 0:
         return;
      case 1:
         NumPosizBe(1, sniperString_, arrInput_, valoriArr_, MagicNumber_);
         return; //BE Pips
      case 2:
         NumPosizBe(2, sniperString_, arrInput_, valoriArr_, MagicNumber_);
         return; //Be Lev By Lev

     }
  }

//+------------------------------------------------------------------+
//|                            NumPosizBe                            |//Gestisce posizioni Buy/Sell, magic, e fornisce i dati alle due funzioni TsPips e TsLevByLev
//+------------------------------------------------------------------+
void NumPosizBe(char indice, const string &sniperStri[], const int &arrInput__[], const double &arrInput_[], const ulong MagicNumber_)  
  {
   long bb = 0;
   int x = PositionsTotal();
   string arr [100];
   long arrMagic [100];
//------------------------azzera array ------------------
   for(int aa=0; aa<ArraySize(arr); aa++){arr[aa] = " ";}

//------------------azzera array Magic ------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++){arrMagic[aa] = 0;}
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      arr [i] = PositionSymbol() ;
      arrMagic[i] = PositionMagicNumber();
     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)Symbol())) && (arrMagic[i] == PositionMagicNumber()))
        {
         aa++;
         bb = PositionTicket();

         switch(indice)
           {
            case 1:
               BePips(sniperStri, arrInput__, arrInput_, MagicNumber_);
               break; //Be Pips
            case 2:
               BeLev(sniperStri, arrInput__, arrInput_, MagicNumber_);
               break; //Be LevByLev
           }
        }
     }
  }




//+------------------------------------------------------------------+
//|                        Numero posizioni                          |//Trova il numero di posizioni aperte di ogni mercato per numero magico  symbolo
//+------------------------------------------------------------------+
char NumPosiz(const string &sniperStri[], const int &arrInput__[], const double &valoriArr_[]) 
  {
   long bb = 0;
   int x = PositionsTotal();
   string arr [100];
   long arrMagic [100];
//------------------------azzera array ------------------
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }

//------------------azzera array Magic ------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      //arr [i] =(string) Symbol((string)PositionSelectByPos(i));
      PositionSelectByPos(i);

      arr [i] = PositionSymbol() ;
      arrMagic[i] = PositionMagicNumber();

     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)Symbol())) && (arrMagic[i] == PositionMagicNumber()))
        {
         aa++;
         bb = PositionTicket();
        }
     }
   return aa;
  }



//+------------------------------------------------------------------------------------------------------------------------+
//|                                        Funzione che rileva se ci sono posizioni aperte su livello                      |
//+------------------------------------------------------------------------------------------------------------------------+
bool EnablePosSuStessiLiv(const string &sniperStri[], const int &arrInput__[], const double &valoriArr_[]) //Trova il numero di posizioni aperte di ogni mercato
  {
   if(arrInput__[11] == true)
      return true;
   bool cc = true;
   long bb = 0;
   double dd = 0;
   int x = PositionsTotal();
   string arr [100];
   long arrMagic [100];
//------------------------azzera array ------------------
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }

//------------------azzera array Magic ------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }
//--------------------- controllo posizioni -------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      //arr [i] =(string) Symbol((string)PositionSelectByPos(i));
      PositionSelectByPos(i);

      arr [i] = PositionSymbol() ;
      arrMagic[i] = PositionMagicNumber();

     }
   char aa = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)Symbol())) && (arrMagic[i] == PositionMagicNumber()))
        {
         if(arrInput__[11] == false)
           {
            if(PositionIsBuy()==true)
              {
               dd = Ask(Symbol());
              }
            if(PositionIsSell()==true)
              {
               dd = Bid(Symbol());
              }
            //Print ("fascia prezzo: ",fasciaDiPrezzoP(dd,true,sniperStri,valoriArr_), " fascia Position: ",  fasciaDiPrezzoP(PositionOpenPrice(),true,sniperStri,valoriArr_));

            if(fasciaDiPrezzoP(dd,true,sniperStri,valoriArr_) == fasciaDiPrezzoP(PositionOpenPrice(),true,sniperStri,valoriArr_))
               cc = false;
            return cc;
           }
         aa++;
         bb = PositionTicket();

        }
     }
   return cc;
  }
//+------------------------------------------------------------------+
//|                 trasforma distanza points in ticks               |
//+------------------------------------------------------------------+
double DistanzaSL(double alto, double basso)
  {

   int a=0;
   double b=0;
   if(_Digits==0){a = 1;}
   if(_Digits==1){a = 10;}
   if(_Digits==2){a = 100;}
   if(_Digits==3){a = 1000;}
   if(_Digits==4){a = 10000;}
   if(_Digits==5){a = 100000;}
   if(_Digits==6){a = 1000000;}
   b = (alto - basso)*a;

   if(_Digits<0 || _Digits > 6)
     {
      Print("Errore DistanzaSL");
      return 1;
     }
   return b;
  }

//+------------------------------------------------------------------+
//|                      valorePercLevByLev_                         |
//+------------------------------------------------------------------+
double valorePercLevByLev_(double valorePrezzo, bool buyOsell, const string &sniperStri[], const int &arrInput__[], const double &valoriArr_[])
  {
   char   a = fasciaDiPrezzoP(valorePrezzo, buyOsell, sniperStri, valoriArr_);
   double b = 0;
   double c = (valoriArr_ [4] - valoriArr_ [3]) * 0.01 * arrInput__[12];
   double d = 0;
   switch(a)
     {
      case   2:b= c + valoriArr_ [2];break;    //uguale distanza
      case   3:b= c + valoriArr_ [3];break;    //uguale distanza
      case   4:b= c + valoriArr_ [4];break;    //uguale distanza
      case   5:b= c + valoriArr_ [5];break;    //uguale distanza
      case   6:b= c + valoriArr_ [6];break;    //uguale distanza
      case   7:b= c + valoriArr_ [7];break;    //uguale distanza
      case  -2:b= valoriArr_ [8] - c;break;    //uguale distanza
      case  -3:b= valoriArr_ [9] - c;break;    //uguale distanza
      case  -4:b= valoriArr_ [10] - c;break;    //uguale distanza
      case  -5:b= valoriArr_ [11] - c;break;    //uguale distanza
      case  -6:b= valoriArr_ [12] - c ;break;    //uguale distanza
      case  -7:b= valoriArr_ [13] - c;break;    //uguale distanza
      default:
         d = -1;
     }
   return d;
  }



//+------------------------------------------------------------------+
//|                        NoTpIfBeTsProfit                          |Cancella il Take Profit quando TrailSt o BreakEven portano lo Stop loss in profitto
//+------------------------------------------------------------------+
void NoTpIfBeTsProfit(const string &sniperStri[], const int &arrInput__[], const double &valoriArr_[], const ulong MagicNumber_)
  {
   if((bool)arrInput__[19] && (TicketPrimoOrdineBuy(MagicNumber_)||TicketPrimoOrdineSell(MagicNumber_)))
     {
      ulong Ticket=0;
      //Print("19: ",arrInput__[19]," TicketBuy: ",TicketPrimoOrdineBuy()," TicketSell: ",TicketPrimoOrdineSell());
      if(TicketPrimoOrdineBuy(MagicNumber_))
        {
         Ticket=TicketPrimoOrdineBuy(MagicNumber_);
         //Print(" TPBuy: ",PositionTakeProfit(Ticket)," SlBuy: ",PositionStopLoss(Ticket)," OpenPriceBuy: ",PositionOpenPrice(Ticket), " PositionTotal: ",PositionsTotalSell(Symbol(),0));
         if(Ticket!=0 && PositionTakeProfit(Ticket)!=0.0 && PositionStopLoss(Ticket)>PositionOpenPrice(Ticket))
           {PositionModify(Ticket,PositionStopLoss(Ticket),0.0,true);}
        }
      if(TicketPrimoOrdineSell(MagicNumber_))
        {
         Ticket=TicketPrimoOrdineSell(MagicNumber_);
         //Print(" TPSell: ",PositionTakeProfit(Ticket)," SlSell: ",PositionStopLoss(Ticket)," OpenPriceSell: ",PositionOpenPrice(Ticket));
         if(Ticket!=0 && PositionTakeProfit(Ticket)!=0.0 && PositionStopLoss(Ticket)<PositionOpenPrice(Ticket) && PositionStopLoss(Ticket)!=0.0)
           {PositionModify(Ticket,PositionStopLoss(Ticket),0.0,true);}
        }
     }
  }

//+------------------------------------------------------------------+
//|                           changePivot()                          |
//+------------------------------------------------------------------+
bool changePivot(double Pivot)
{
static double a;
bool b = false;
if(Pivot == a) {b = false;}
if(Pivot != a) {a = Pivot; b = true;}
return b;
}
//+------------------------------------------------------------------+
//|                      double valueDDmax()                         |  
//+------------------------------------------------------------------+
double valueDDmax(double maxDDPerc_,ulong MagicNumber_)
  {
   double a=(double)AccountInfoDouble(ACCOUNT_BALANCE)-(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-maxDDPerc_);
   return a;
  }
//+------------------------------------------------------------------+
//|                          void DDmax()                            |  
//+------------------------------------------------------------------+
void DDmax(double maxDDPerc_,ulong MagicNumber_)
  {
               if(valueDDmax(maxDDPerc_,MagicNumber_))
                 {
                  brutalCloseTotal(Symbol(),MagicNumber_);
                  return;
                  Print("DD Max raggiunto");
                  //Alert("DD Max raggiunto");
  }}  
/*
               if(DDMax(maxDDPerc,magic_number))
                 {
                  brutalCloseTotal(Symbol(),magic_number);
                  return;
                  Print("DD Max raggiunto");
                  //Alert("DD Max raggiunto");
                 }*/  
//+------------------------------------------------------------------+
//|                      bool DDMax()                                |
//+------------------------------------------------------------------+

bool DDMax(double maxDDPerc_,ulong MagicNumber_)
  {
   if(PositionsTotal()==0){return false;}
   string SymbolChart=Symbol();
   bool a=false;
   if(maxDDPerc_<0.0 || maxDDPerc_ > 100.0){Print("Incorrect Max DD value");return a;}
   if(maxDDPerc_==0.0){return a=false;}
//Print("ACCOUNT_EQUITY: ",(double)AccountInfoDouble(ACCOUNT_EQUITY)," ACCOUNT_BALANCE: ",(double)AccountInfoDouble(ACCOUNT_BALANCE));

   long bb = 0;
   int x = PositionsTotal();
   string arr [100];
   ulong  arrMagic [100];
   ulong  arrTicket [100];
   double arrProfit [100];
//--------------------azzera array arr -------------------
   for(int aa=0; aa<ArraySize(arr); aa++)
     {
      arr[aa] = " ";
     }

//------------------azzera array Magic -------------------
   for(int aa=0; aa<ArraySize(arrMagic); aa++)
     {
      arrMagic[aa] = 0;
     }

//------------------azzera array Profit ------------------
   for(int aa=0; aa<ArraySize(arrProfit); aa++)
     {
      arrProfit[aa] = 0;
     }

//------------------azzera array Ticket ------------------
   for(int aa=0; aa<ArraySize(arrTicket); aa++)
     {
      arrTicket[aa] = 0;
     }
//--------------------- controllo posizioni --------------
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByIndex(i);

      arr [i] = PositionSymbol();
      arrMagic[i] = PositionMagicNumber();
      arrTicket[i] = PositionTicket();
      arrProfit[i] = PositionProfitFull(arrTicket[i]);
     }
   double Profit = 0;

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      PositionSelectByPos(i);
      if((((string)arr[i] == (string)SymbolChart)) && (arrMagic[i] == MagicNumber_))
        {
         Profit = Profit+arrProfit[i];
         bb = PositionTicket();
        }
     }
   if((double)AccountInfoDouble(ACCOUNT_BALANCE)+Profit<=(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-maxDDPerc_))
     {
      a=true;
     }
//Print(" Balance: ",(double)AccountInfoDouble(ACCOUNT_BALANCE)," Profit: ",Profit," Equity: ",(double)AccountInfoDouble(ACCOUNT_BALANCE)+Profit,
//" Soglia DD: ",(double)AccountInfoDouble(ACCOUNT_BALANCE)*0.01*(100-maxDDPerc_)," Return: ",a);
   return a;
  }

//+------------------------------------------------------------------+
//|                      semaforominuto()                            |
//+------------------------------------------------------------------+

   bool semaforominuto()
   {
   bool a=false;
   static int minuto;
   if(minuto!=Minute()){minuto=Minute();a=true;}
   return a;   
   }
//+------------------------------------------------------------------+
//|                        semaforoOra()                             |
//+------------------------------------------------------------------+

   bool semaforoOra()
   {
   bool a=false;
   static int ora;
   if(ora!=Hour()){ora=Hour();a=true;}
   return a;   
   }  
//+------------------------------------------------------------------+
//|                        PivotWeekly()                             | 1= HL:2   2= HL:3
//+------------------------------------------------------------------+    
double PivotWeekly(char TypePivW_)
{
return pricePivotW(TypePivW_);
}  
//+------------------------------------------------------------------+
//|                        pricePivotW()                             | 1= HL:2   2= HL:3
//+------------------------------------------------------------------+   
double pricePivotW(char TypePivW_)
  {
   double a=0.0;
   if(TypePivW_==0)return a;
   double ilow = iLow(Symbol(),PERIOD_W1,1);
   double ihigh = iHigh(Symbol(),PERIOD_W1,1);
   if(TypePivW_ == 1)
      a = (ilow+ihigh)/2;
   if(TypePivW_ == 2)
      a = (ilow+ihigh+iClose(Symbol(),PERIOD_W1,1))/3;
   return a;
  }
//+------------------------------------------------------------------+
//|                         PivotDaily()                             | 2= HL:2   3= HL:3
//+------------------------------------------------------------------+  
double PivotDaily(char TypePivotD_)
{
return pricePivotD(TypePivotD_);
}

//+------------------------------------------------------------------+
//|                        pricePivotD()                             | 2= HL:2   3= HL:3
//+------------------------------------------------------------------+
double pricePivotD(char TypePivotD_)
  {
   double a=0.0;
   if(TypePivotD_==0)return a;
   double ilow = iLow(Symbol(),PERIOD_D1,1);
   double ihigh = iHigh(Symbol(),PERIOD_D1,1);
   if(TypePivotD_ == 2)
      a = (ilow+ihigh)/2;
   if(TypePivotD_ == 3)
      a = (ilow+ihigh+iClose(Symbol(),PERIOD_D1,1))/3;
   return a;
  }
//+------------------------------------------------------------------+Sposta la virgola a sx con Divis_ negativo del numero corrispondente (Divisione)
//|                     Divisione / Moltiplicazione                  |                e a dx con Divis_ positivo (moltiplicazione)
//+------------------------------------------------------------------+Restituisce "1" con Divis_ a Zero             
double Div_(int divMolt)
  {
   double a = 0.0;
   switch(divMolt)
     {
      case -4 :a = 0.0001;break;
      case -3 :a =  0.001;break;
      case -2 :a =   0.01;break;
      case -1 :a =    0.1;break;
      case  0 :a =      1;break;
      case  1 :a =     10;break;
      case  2 :a =    100;break;
      case  3 :a =   1000;break;
      case  4 :a =  10000;break;
      case  5 :a = 100000;break;
      default :
         Alert("Divisione Input Gann ERRATA!");
     }
   return a;
  }  


//+------------------------------------------------------------------+
//|                        newsHour()                                |
//+------------------------------------------------------------------+
bool newsHour()
{
static datetime ora=0;
bool impulse=false;
if(Hour()!=ora)
   
   {impulse=true;ora=Hour();Print("Hour(): ",Hour());}
return impulse;
}
//+------------------------------------------------------------------+
//|                        newsDay()                                |
//+------------------------------------------------------------------+
bool newDay()
{
static int giorno;
bool impulse=false;
if(Day()!=giorno) {impulse=true;giorno=Day();}//Print("Day(): ",Day());
return impulse;
}
//+------------------------------------------------------------------+
//|                        newCandle()                               |
//+------------------------------------------------------------------+
bool newCandle()
  {
   static int candle;
   bool impulse=false;
   int a = iBars(Symbol(),PERIOD_CURRENT);
   if(a!=candle){impulse = true; candle=a;}//Print(" a: ",a," candle: ",candle," impulse: ",impulse);
   return impulse;
  }
//+------------------------------------------------------------------+
//|                         semaforoDay()                            |
//+------------------------------------------------------------------+
bool semaforoDay()
  {
   bool a=false;
   int  barraGiorno=iBars(Symbol(),PERIOD_D1);
   static int day=0;
   if(barraGiorno!=day)
     {day=barraGiorno; a=true;}
   return a;
  }
//+------------------------------------------------------------------+
//|                    impulsoNuovoGiorno()                          |
//+------------------------------------------------------------------+
bool impulsoNuovoGiorno()
  {
   return semaforoDay();
  }
//+------------------------------------------------------------------+
//|                        semaforoMinuto()                          |
//+------------------------------------------------------------------+
bool semaforoMinuto()
  {
   bool a=false;
   int  barraMinuto=iBars(Symbol(),PERIOD_M1);
   static int Minuto=0;
   if(barraMinuto!=Minuto)
     {
      Minuto=barraMinuto;
      a=true;
     }
   return a;
  }
//+------------------------------------------------------------------+
//|                              newPrice()                          |
//+------------------------------------------------------------------+
bool newPrice(const double price)
  {
   bool a = false;
   static double prezzo;
   if(price != prezzo)
     {prezzo = price; a = true;}
   return a;
  }
//+------------------------------------------------------------------+
//|                              newInt()                            |
//+------------------------------------------------------------------+
bool newInt(const int price)
  {
   bool a = false;
   static int prezzo;
   if(price != prezzo)
     {prezzo = price; a = true;}
   return a;
  }  
//+------------------------------------------------------------------+
//|                              newUlong()                          |
//+------------------------------------------------------------------+
bool newUlong(const ulong ticket)
  {
   bool a = false;
   static ulong ticket_;
   if(ticket != ticket_){ticket_ = ticket; a = true;}
   return a;
  } 
//+------------------------------------------------------------------+
//|                              newUlongBuy()                       |
//+------------------------------------------------------------------+
bool newUlongBuy(const ulong ticket)
  {
   bool a = false;
   static ulong ticket_;
   if(ticket != ticket_)
     {ticket_ = ticket; a = true;}
   return a;
  } 
//+------------------------------------------------------------------+
//|                              newUlongSell()                      |
//+------------------------------------------------------------------+
bool newUlongSell(const ulong ticket)
  {
   bool a = false;
   static ulong ticket_;
   if(ticket != ticket_)
     {ticket_ = ticket; a = true;}
   return a;
  }      
//+------------------------------------------------------------------+
//|                              newUlongZero()                      |Restituisce true quando ticket passa a zero
//+------------------------------------------------------------------+  
bool newUlongZero(const ulong ticket)
{
      static ulong ticket_;
      bool a = false;   
   if(ticket != ticket_)
   {ticket_ = ticket;
   if(!ticket){a=true;}
      }
      return a;
}        