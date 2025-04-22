#include <MyLibrary\MyLibrary.mqh>

//+------------------------------------------------------------------+
//|                               BePerc()                           |
//+------------------------------------------------------------------+
/*
enum BE
  {
   No_BE                     = 0,  //No Breakeven
   BEPoints                  = 1,  //Breakeven Points
   PercOpenTP                = 2,  //Breakeven Percentuale OpenPrice/Take Profit
  };   

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      BeStartPoints            = 2500;              //Be Start in Points
input int      BeStepPoints             =  200;              //Be Step in Points
input double   BePercStart              = 61.8;              //Be % Start
input double   BePercStep               = 32.8;              //Be % Step

//------------------------------ gestioneBreakEven()--------------------------------------------- 
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(BeStartPoints, BeStepPoints, magic_number, Commen);
if(BreakEven==2)BePerc(BePercStart,BePercStep,magic_number,Commen);
return BreakEv;
}

*/

void BePerc(double BEPercStart,double BEPercStep,ulong mag,string comm)
{
ulong tikbuy=TicketPrimoOrdineBuy(mag,comm);
ulong tiksell=TicketPrimoOrdineSell(mag,comm);
if(tikbuy)
{
double openbuy = PositionOpenPrice(tikbuy);
double TPbuy   = PositionTakeProfit(tikbuy);
if(TPbuy)
{
//Print(" Buy start ",(TPbuy-openbuy)/100*BEPercStart +openbuy," Buy step ",((TPbuy-openbuy)/100*BEPercStep )+openbuy);

if(Ask(Symbol()) >= (TPbuy-openbuy)/100*BEPercStart +openbuy && PositionStopLoss(tikbuy)*1.001 <  ((TPbuy-openbuy)/100*BEPercStep )+openbuy) 
            PositionModify(tikbuy,((TPbuy-openbuy)/100*BEPercStep )+openbuy,TPbuy);
}}

if(tiksell)
{
double opensell = PositionOpenPrice(tiksell);
double TPsell   = PositionTakeProfit(tiksell);
if(TPsell)
{
//Print(" Sell start ",opensell - ((opensell-TPsell)/100*BEPercStart)," Sell step ",opensell - ((opensell-TPsell)/100*BEPercStep));

if(Bid(Symbol()) <= opensell - ((opensell-TPsell)/100*BEPercStart) && PositionStopLoss(tiksell)*0.99 > opensell - ((opensell-TPsell)/100*BEPercStep)) 
            PositionModify(tiksell,((TPsell-opensell)/100*BEPercStep )+opensell,TPsell);
}}
}
//+------------------------------------------------------------------+
//|                        TrailStopPerc()                           |
//+------------------------------------------------------------------+
/*
enum TStop
  {
   No_TS                     = 0,  //No Trailing Stop
   Pointstop                 = 1,  //Trailing Stop in Points
   TSPointTradiz             = 2,  //Trailing Stop in Points Traditional
   TsTopBotCandle            = 3,  //Trailing Stop Previous Candle
   PercOpenTP                = 4,  //Trailing Stop Percentuale OpenPrice/Take Profit
  };
  
input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points
input double   TsPercStart              = 61.8;              //Ts % Start
input double   TsPercStep               = 32.8;              //Ts % Step

//------------------------------ gestioneTrailStop()--------------------------------------------- 
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magic_number, Commen);
if(TrailingStop==2)PositionsTrailingStopInStep(TsStart,TsStep,Symbol(),magic_number,0);
if(TrailingStop==3)TrailStopCandle_();
if(TrailingStop==4)TrailStopPerc(TsPercStart,TsPercStep,magic_number,Commen);
return TS;
}
*/

void TrailStopPerc(double TSPercStart,double TSPercStep,ulong mag,string comm)
{
ulong tikbuy=TicketPrimoOrdineBuy(mag,comm);
ulong tiksell=TicketPrimoOrdineSell(mag,comm);
if(tikbuy)
{
double openbuy = PositionOpenPrice(tikbuy);
double TPbuy   = PositionTakeProfit(tikbuy);
double SLbuy   = PositionStopLoss(tikbuy);
double livelloSlbuy=0;
if(TPbuy)
{
//Print(" Buy start ",(TPbuy-openbuy)/100*BEPercStart +openbuy," Buy step ",((TPbuy-openbuy)/100*BEPercStep )+openbuy);
if(SLbuy<openbuy && Ask(Symbol()) >= (TPbuy-openbuy)/100*TSPercStart +openbuy && SLbuy < NormalizeDouble(((TPbuy-openbuy)/100*TSPercStep )+openbuy,Digits())) 
   PositionModify(tikbuy,((TPbuy-openbuy)/100*TSPercStep )+openbuy,TPbuy);
 
     
if(SLbuy>=openbuy)
{
livelloSlbuy=SLbuy;           
if(Ask(Symbol()) >= (TPbuy-openbuy)/100*TSPercStart +livelloSlbuy && SLbuy < NormalizeDouble(((TPbuy-openbuy)/100*TSPercStep )+livelloSlbuy,Digits())) 
   PositionModify(tikbuy,((TPbuy-openbuy)/100*TSPercStep )+livelloSlbuy,TPbuy); 
}           
}
}

if(tiksell)
{
double opensell = PositionOpenPrice(tiksell);
double TPsell   = PositionTakeProfit(tiksell);
double SLsell   = PositionStopLoss(tiksell);
double livelloSlsell=0;
if(TPsell)
{
//Print(" Sell start ",opensell - ((opensell-TPsell)/100*BEPercStart)," Sell step ",opensell - ((opensell-TPsell)/100*BEPercStep));

if(Bid(Symbol()) <= opensell - ((opensell-TPsell)/100*TSPercStart) && PositionStopLoss(tiksell) > NormalizeDouble(opensell - ((opensell-TPsell)/100*TSPercStep),Digits())) 
   PositionModify(tiksell,((TPsell-opensell)/100*TSPercStep )+opensell,TPsell);
   
if(SLsell<=opensell)
{
livelloSlsell=SLsell;           
if(Bid(Symbol()) <= livelloSlsell - ((opensell-TPsell)/100*TSPercStart) && SLsell > NormalizeDouble(livelloSlsell - ((opensell-TPsell)/100*TSPercStep),Digits()))
   PositionModify(tiksell,((TPsell-opensell)/100*TSPercStep )+livelloSlsell,TPsell); 
}   
}
}
}
//+------------------------------------------------------------------+
//|                            BrEven                                |
//+------------------------------------------------------------------+
double BrEven(int start, int step, ulong magic, string comm)
{
double BrEv=0;
double ask = Ask(Symbol());
double bid = Bid(Symbol());
ulong tikBuy=TicketPrimoOrdineBuy(magic,comm);
ulong tikSell=TicketPrimoOrdineSell(magic,comm);
double stLossBuy=PositionStopLoss(tikBuy);
double stLossSell=PositionStopLoss(tikSell);

if(tikBuy&&ask>OpenPricePrimoOrdineBuy(magic,comm)+start*Point(Symbol())&&stLossBuy<OpenPricePrimoOrdineBuy(magic,comm)+step*Point(Symbol())) 
   {BrEv=OpenPricePrimoOrdineBuy(magic,comm)+step*Point(Symbol());BrEv=NormalizeDouble(BrEv,Digits());
   PositionModify(tikBuy,BrEv,PositionTakeProfit(tikBuy));
   }

if(tikSell&&bid<OpenPricePrimoOrdineSell(magic,comm)-start*Point(Symbol())&&stLossSell>OpenPricePrimoOrdineSell(magic,comm)-step*Point(Symbol())) 
   {BrEv=OpenPricePrimoOrdineSell(magic,comm)-step*Point(Symbol());BrEv=NormalizeDouble(BrEv,Digits());
   PositionModify(tikSell,BrEv,PositionTakeProfit(tikSell));
   }
return BrEv;
}
//+------------------------------------------------------------------+
//|                       TrailingPoints                             |
//+------------------------------------------------------------------+
void TrailingPoints(int start, int step,ulong magic, string comm)
  {
//PositionSelectByIndex();
   if(start==0)return;
   double ask=Ask(Symbol());
   double bid=Bid(Symbol());
   ulong  TicketPrOrd=TicketPrimoOrdineBuy(magic,comm);
   double tSto   = Point()* start;
   double tStep  = Point()* step;
   double prezzo = ask;
   double stoploss = PositionStopLoss(TicketPrOrd);
   double openOrder = PositionOpenPrice(TicketPrOrd);
   double priceStep = 0;

   double OpenStopL = 0.0;

   if(TicketPrOrd)
     {
      if(stoploss < openOrder) {OpenStopL = openOrder;}
      if(stoploss > openOrder) {OpenStopL = stoploss;}
      if(prezzo > (openOrder + (tSto)))
        {
      priceStep = NormalizeDouble((OpenStopL + tStep),Digits());
         for(int i=1; i<=30; i++)
           {
            if(prezzo > (OpenStopL + (tSto * (i))) && stoploss < priceStep) {PositionModify(TicketPrOrd,priceStep,PositionTakeProfit());}
           }
        }
     }

   TicketPrOrd=TicketPrimoOrdineSell(magic,comm);
   stoploss  = PositionStopLoss(TicketPrOrd);
   openOrder = PositionOpenPrice(TicketPrOrd);
   OpenStopL = 0.0;
   prezzo    = bid;

   if(TicketPrOrd)
     {
      if(stoploss > openOrder) {OpenStopL = openOrder;}
      if(stoploss < openOrder) {OpenStopL =  stoploss;}
      if(stoploss <= 0.0) {OpenStopL = openOrder;}

      if(prezzo < (OpenStopL - (tSto)))
        {
      priceStep = NormalizeDouble((OpenStopL - tStep),Digits());
         for(int i=1; i<=30; i++)
           {
            if(prezzo < (OpenStopL - (tSto * (i))) && stoploss > priceStep) {PositionModify(TicketPrOrd,priceStep,PositionTakeProfit());}
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                             TsPoints                             |
//+------------------------------------------------------------------+
void TsPoints(int start, int step,ulong magic, string comm)
  {
//PositionSelectByIndex();
   if(start==0)return;
   double ask=Ask(Symbol());
   double bid=Bid(Symbol());
   ulong  TicketPrOrd=TicketPrimoOrdineBuy(magic,comm);
   double tSto   = Point()* start;
   double tStep  = Point()* step;
   double prezzo = ask;
   double stoploss = PositionStopLoss(TicketPrOrd);
   double openOrder = PositionOpenPrice(TicketPrOrd);
   double OpenStopL = 0.0;

   if(TicketPrOrd)
     {
      if(stoploss < openOrder) {OpenStopL = openOrder;}
      if(stoploss > openOrder) {OpenStopL = stoploss;}
      if(prezzo > (openOrder + (tSto)))
        {
         for(int i=1; i<=30; i++)
           {
            if(prezzo > (OpenStopL + (tSto * (i))) && stoploss < (NormalizeDouble((OpenStopL + tStep),Digits()))) //if(prezzo > (OpenStopL + (tSto * (i))))
            {PositionModify(TicketPrOrd,(NormalizeDouble((OpenStopL + tStep),Digits())),PositionTakeProfit());}
           }
        }
     }

   TicketPrOrd=TicketPrimoOrdineSell(magic,comm);
   stoploss  = PositionStopLoss(TicketPrOrd);
   openOrder = PositionOpenPrice(TicketPrOrd);
   OpenStopL = 0.0;
   prezzo    = bid;

   if(TicketPrOrd)
     {
      if(stoploss > openOrder) {OpenStopL = openOrder;}
      if(stoploss < openOrder) {OpenStopL =  stoploss;}
      if(stoploss <= 0.0) {OpenStopL = openOrder;}

      if(prezzo < (OpenStopL - (tSto)))
        {
         for(int i=1; i<=30; i++)
           {
            if(prezzo < (OpenStopL - (tSto * (i))) && stoploss > (NormalizeDouble(OpenStopL - tStep,Digits()))) //if(prezzo < (OpenStopL - (tSto * (i)))) 
            {PositionModify(TicketPrOrd,(NormalizeDouble(OpenStopL - tStep,Digits())),PositionTakeProfit());}
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                            BEPoints                              |
//+------------------------------------------------------------------+  
void BEPoints(const int BrStop, const int BrStep, const ulong MagicNumber_, const string Comm)
{BEPips(BrStop, BrStep, MagicNumber_, Comm);}

void BEPips(const int BrStop, const int BrStep, const ulong MagicNumber_, const string Comm)
  {
   if(BrStop==0)return;
   ulong TicketPrOrdBUY=TicketPrimoOrdineBuy(MagicNumber_,Comm);
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
   
   if(!TicketPrOrdBUY){a=0;}
   if(TicketPrOrdBUY)//Primo ordine Buy presente e nessuna griglia o hedge attiva
     {
      if(a != TicketPrOrdBUY)
        {
         if(stoplossBuy==0.0){y=true;};   
         if((ask >= openOrderBuy + Point()*BrStop) && (stoplossBuy < (openOrderBuy+Point()*BrStep)|| y) && m)
           {
            if(NormalizeDouble((openOrderBuy+Point()*BrStep),Digits())!=stoplossBuy)
            {
            PositionModify(TicketPrOrdBUY,(NormalizeDouble((openOrderBuy+Point()*BrStep),Digits())),PositionTakeProfit());
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
   if(TicketPrOrdSELL)
     {

      if(b != TicketPrOrdSELL)
        {
         if(stoplossSell==0.0){z=true;};

         if((bid <= openOrderSell - Point()*BrStop) && (stoplossSell > (openOrderSell-Point()*BrStep)|| z) && n)
           {
            if(NormalizeDouble((openOrderSell-Point()*BrStep),Digits())!=stoplossSell)
            {
            PositionModify(TicketPrOrdSELL,(NormalizeDouble((openOrderSell-Point()*BrStep),Digits())),PositionTakeProfit());
            b = TicketPrOrdSELL;
             }
           }
        }
     }
  }  
//+------------------------------------------------------------------+BReakEven per sistemi con griglia 
//|                              BePoints                            |
//+------------------------------------------------------------------+      
void BePoints(string BuySell,ulong Ticket,bool BEGridActiv,bool GridBuyActiv,bool GridSellActiv,int BeStartPoint,int BeStepPoint)
  {
   double ask=Ask(Symbol());
   double bid=Bid(Symbol());
   bool GridActive=GridBuyActiv||GridSellActiv;  
   bool enableBe = BEGridActiv; //enable Be with Orders Grid Hedge Activated

   if(BuySell=="Buy")
   {
   static ulong TickBuy = 0;    
   double stoplossBuy=OrderStopLoss(Ticket);
   double openOrderBuy=OrderOpenPrice(Ticket);

   if(!BEGridActiv && GridActive)//enable BE disable e griglia o hedge attiva
      {
   if(TickBuy != Ticket)
      {
   if(Ticket != 0)
      {   
       TickBuy = Ticket;
      {
      if((ask >= openOrderBuy + Point()*BeStartPoint) && (stoplossBuy < (openOrderBuy+Point()*BeStepPoint)))
      {
      if((NormalizeDouble((openOrderBuy+BeStepPoint*Point()),Digits())>stoplossBuy))
         {PositionModify(TickBuy,(NormalizeDouble((openOrderBuy+BeStepPoint*Point()),Digits())),OrderTakeProfit(TickBuy));}
      }}}}}}
        
   if(BuySell=="Sell")
   {
   static ulong TickSell = 0; 
   double stoplossSell = OrderStopLoss(Ticket);
   double openOrderSell = OrderOpenPrice(Ticket);   
   stoplossSell=OrderStopLoss(Ticket);openOrderSell=OrderOpenPrice(Ticket);
    
   if(!BEGridActiv && GridActive)
     {
      if(TickSell != Ticket && stoplossSell == 0.0)
        {
         TickSell = Ticket;
         {
         if((bid <= openOrderSell - Point()*BeStartPoint) && (stoplossSell > (openOrderSell-Point()*BeStepPoint)))
           {
            if(NormalizeDouble((openOrderSell-Point()*BeStepPoint),Digits())!=stoplossSell)
            {PositionModify(TickSell,(NormalizeDouble((openOrderSell-BeStepPoint*Point()),Digits())),OrderTakeProfit(TickSell));}
           }}}}}}

int gestioneStopLoss(int TipoSl,int STLPoints)
{
int a=0;
if(TipoSl==0){a=0;return a;}
if(TipoSl==1){a=STLPoints;return a;}
return a;
}
int gestioneTakeProf(int TAkeProfit=0,int TPPoints=0)
{
int TP=0;
if(!TAkeProfit)return TP;
if(TAkeProfit==1)TP=TPPoints;
return TP;
}



double gestioneBreakEven(int BReakEven,int BEStartPoints,int BEStepPoints,ulong magic,string commen)
{
double BreakEv=0;
if(BReakEven==0)return BreakEv;
if(BReakEven==1)BrEven(BEStartPoints, BEStepPoints, magic, commen);
return BreakEv;
}
double gestioneTrailStop(int TRailingStop,int TSStart,int TSStep,int TipoDiCandela,int indexCandela,ENUM_TIMEFRAMES TFCandela,ulong magic,string commen)
{
double TS=0;
if(TRailingStop==0)return TS;
if(TRailingStop==1)TsPoints(TSStart, TSStep, magic, commen);
if(TRailingStop==2)PositionsTrailingStopInStep(TSStart,TSStep,Symbol(),magic,0);
if(TRailingStop==3)TrailStopCandle_(TipoDiCandela,indexCandela,TFCandela,magic,commen);
return TS;
}

//------------------------------ gestioneBreakEven()--------------------------------------------- 
double gestioneBreakEven(int BreakEven_,int BeStartPoints_,int BeStepPoints_,double BePercStart_,double BePercStep_,ulong magicNumber_,string Commen_)
{
double BreakEv=0;
if(BreakEven_==0)return BreakEv;
if(BreakEven_==1)BrEven(BeStartPoints_, BeStepPoints_, magicNumber_, Commen_);
if(BreakEven_==2)BePerc(BePercStart_,BePercStep_,magicNumber_,Commen_);
return BreakEv;
}
//------------------------------ gestioneTrailStop()--------------------------------------------- 
double gestioneTrailStop(int TrailingStop_,int TsStart_,int TsStep_,double TsPercStart_,double TsPercStep_,int TipoDiCandela,int indexCandela,ENUM_TIMEFRAMES TFCandela,string symb,ulong mag,string Comm)
{
double TS=0;
if(TrailingStop_==0)return TS;
if(TrailingStop_==1)TsPoints(TsStart_, TsStep_, mag, Comm);
if(TrailingStop_==2)PositionsTrailingStopInStep(TsStart_,TsStep_,symb,mag,0);///PositionTrailingStopInStep
//if(TrailingStop_==2){PositionTrailingStopInStep(TicketPrimoOrdineBuy(magic_number),TsStart,TsStep);PositionTrailingStopInStep(TicketPrimoOrdineSell(magic_number),TsStart,TsStep);}
if(TrailingStop_==3)TrailStopCandle_(TipoDiCandela,indexCandela,TFCandela,mag,Comm);
if(TrailingStop_==4)TrailStopPerc(TsPercStart_,TsPercStep_,mag,Comm);
return TS;
}
//+------------------------------------------------------------------+
//|                       TrailStopCandle()                          |
//+------------------------------------------------------------------+
double TrailStopCandle_(int TipoDiCandela,int indexCandela,ENUM_TIMEFRAMES TFCandela,ulong magic,string commen)
  {
  double TsCandle=0;
   if(TicketPrimoOrdineBuy(magic,commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magic,commen),TipoDiCandela,indexCandela,TFCandela,0.0);
   if(TicketPrimoOrdineSell(magic,commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magic,commen),TipoDiCandela,indexCandela,TFCandela,0.0);
  return TsCandle;}  
