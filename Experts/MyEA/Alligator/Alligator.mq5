//+------------------------------------------------------------------+
//|                                                 Struttura EA.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
//#property link      "https://www.cbalgotrade.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property description "The Expert Advisor is based on the levels of W. D. Gann's Square of nine, adapted to the markets of our time."
string versione = "v1.00";

#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>  

//------------ Controllo Numero Licenze e tempo Trial, Corrado ----------------------
datetime TimeLicens = D'3000.01.01 00:00:00';
int NumeroAccount0 = 27081543;
int NumeroAccount1 = 8918163;
int NumeroAccount2 = 7015565;
int NumeroAccount3 = 7008209;
int NumeroAccount4 = 62039500;
int NumeroAccount5 = 62039500;
int NumeroAccount6 = 62039500;
int NumeroAccount7 = 62039500;
char NumeroAccountMax = 1;
long NumeroAccountOk [10];

enum capitBasePerCompoundingg
  {
   Equity          = 0,
   Margine_libero  = 1,//Free margin
   Balance         = 2,
  };

enum Fuso_
  {
   GMT              = 0,
   Local            = 1,
   Server           = 2
  };
enum Type_Orders
  {
   Buy_Sell         = 0,                       //Orders Buy e Sell
   Buy              = 1,                       //Only Buy Orders
   Sell             = 2                        //Only Sell Orders
  };
enum TStop
  {
   No_TS                          = 0,  //No Trailing Stop
   Pointstop                      = 1,  //Trailing Stop in Points
   TSPointTradiz                  = 2,  //Trailing Stop in Points Traditional
   TsTopBotCandle                 = 3,  //Trailing Stop Previous Candle
  };
enum TypeCandle
  {
   Stesso     = 0,                 //Trailing Stop sul min/max della candela "index"
   Una        = 1,                 //Trailing Stop sul min/max del corpo della candela "index"
   Due        = 2,                 //Trailing Stop sul max/min del corpo della candela "index"
   Tre        = 3,                 //Trailing Stop sul max/min della candela "index"
  };
enum BE
  {
   No_BE                          = 0, //No Breakeven
   BEPoints                       = 1, //Breakeven Points
  };      
enum Tp
  {
   No_Tp                          = 0,    //No Tp
   TpPoints                       = 1,    //Tp in Points
  };
/*
input string   comment_TT =            "--- TRADING TIME SETTINGS ---";   // --- TRADING TIME SETTINGS ---
input bool     FusoEnable = false;                       //Trading Time
input Fuso_    Fuso = 1;                                 //Time Zone Settings
input int      InpStartHour = 0;                         //Session Start Time
input int      InpStartMinute = 59;                      //Session Start Minute
input int      InpEndHour = 23;                          //Hours End of Session
input int      InpEndMinute = 58;                        //Minute End of Session
*/

 
input string   comment_OS =            "--- ORDER SETTINGS ---";   // --- ORDER SETTINGS ---
input Type_Orders            Type_Orders_                    =   0;       //Type of order opening
input double   lotsEA     =            0.1;                             //Lots
input ulong                  magic_number                    = 7777;      //Magic Number
input string                 Commen                          = "EA";//Comment
input int                    Deviazione                      = 3;         //Slippage 

input string   comment_SL =           "--- STOP LOSS ---"; // --- STOP LOSS ---
input int      Sl_n_pips                = 10000;            //Stop loss Points.

input string   comment_BE =           "--- BREAK EVEN ---";   // --- BREAK EVEN ---
input BE       BreakEven                =    1;              //Be Type
input int      Be_Start_pips            = 2500;              //Be Start in Points
input int      Be_Step_pips             =  200;              //Be Step in Points

input string   comment_TS =           "--- TRAILING STOP ---";   // --- TRAILING STOP ---
input TStop    TrailingStop             =    1;              //Ts No/Points da Profit/Points Traditional/Candle
input int      TsStart                  = 3000;              //Ts Start in Points
input int      TsStep                   =  700;              //Ts Step in Points

input string   comment_TSC =           "--- TRAILING STOP CANDLE ---";   // --- TRAILING STOP CANDLE---
input TypeCandle TypeCandle_            =    0;              //Type Trailing Stop Candle
input int       indexCandle_            =    3;              //Index Candle Previous
input ENUM_TIMEFRAMES TFCandle          =    PERIOD_CURRENT; //Time frame Candle Top/Bottom

input string   comment_TP =           "--- TAKE PROFIT ---"; // --- TAKE PROFIT ---
input Tp       TakeProfit               =    1;              //Take Profit Type
input int      TpPoints                 = 1000;              //Take Profit Points

//input string               symbol_="Symbol()";             // simbolo 
input ENUM_TIMEFRAMES      period_=PERIOD_CURRENT;  // timeframe 
input int                  jawPeriod=13;          // periodo della linea Jaw 
input int                  jawShift=8;            // slittamento della linea Jaw 
input int                  teethPeriod=8;         // periodo della linea Teeth 
input int                  teethShift=5;          // slittamento della linea Teeth 
input int                  lipsPeriod=5;          // periodo della linea Lips 
input int                  lipsShift=3;           // slittamento della linea Lips 
input ENUM_MA_METHOD       MAMethod=MODE_SMMA;    // medoto di media delle linee di Alligator 
input ENUM_APPLIED_PRICE   appliedPrice=PRICE_MEDIAN;// tipo di prezzo utilizzato per il calcolo di Alligator 

bool enableTrading=true;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     if(TimeLicens < TimeCurrent()){Alert("EA Libra: Trial period expired! Removed EA from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
   
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
if(TimeLicens < TimeCurrent()){Alert("EA: Trial period expired! Removed EA Libra from this account!");
      Print("EA: Trial period expired! Removed EA from this account!");
      Alert("EA: Trial period expired! Removed EA from this account!");
      ExpertRemove();}
if(!IsMarketTradeOpen(Symbol())) return; 
     
enableTrading=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);   
double ask=Ask(Symbol());
double bid=Bid(Symbol());


gestioneBreakEven();
gestioneTrailStop();
gestioneOrdini();

  }
 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                       controlAccounts                            |
//+------------------------------------------------------------------+
bool controlAccounts()
  {
   if(!IsConnected())
     {
      Print("No connection");
      return true;
     }
   bool a = false;
   if(AccountNumber() == NumeroAccount0 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount1 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount2 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount3 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount4 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount5 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount6 && TimeLicens > TimeCurrent()) a = true;
   if(AccountNumber() == NumeroAccount7 && TimeLicens > TimeCurrent()) a = true;
   if(a == true) Print("EA Libra: Account Ok!");
   else
     {(Print("EA Libra: trial license expired or Account without permission")); ExpertRemove();}
   return a;
  }
  
double calcoloStopLoss(string BuySell,double openPrOrd)
{
double SL=0;
if(BuySell=="Buy")SL=openPrOrd-Sl_n_pips*Point();
if(BuySell=="Sell")SL=openPrOrd+Sl_n_pips*Point();
return SL;
}
double calcoloTakeProf(string BuySell,double openPrOrd)
{
double TP=0;
if(!TakeProfit)return TP;
if(TakeProfit==1)
if(BuySell=="Buy")TP=openPrOrd+TpPoints * Point();
if(BuySell=="Sell")TP=openPrOrd-TpPoints * Point();
return TP;
}
double gestioneBreakEven()
{
double BreakEv=0;
if(BreakEven==0)return BreakEv;
if(BreakEven==1)BrEven(Be_Start_pips, Be_Step_pips, magic_number, Commen);
return BreakEv;
}
double gestioneTrailStop()
{
double TS=0;
if(TrailingStop==0)return TS;
if(TrailingStop==1)TsPoints(TsStart, TsStep, magic_number, Commen);
if(TrailingStop==2)PositionsTrailingStopInStep(TsStart,TsStep,Symbol(),magic_number,0);
if(TrailingStop==3)TrailStopCandle_();
return TS;
}


//+------------------------------------------------------------------+
//|                       TrailStopCandle()                          |
//+------------------------------------------------------------------+
double TrailStopCandle_()
  {
  double TsCandle=0;
   if(TicketPrimoOrdineBuy(magic_number,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineBuy(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
   if(TicketPrimoOrdineSell(magic_number,Commen))
      TsCandle = PositionTrailingStopOnCandle(TicketPrimoOrdineSell(magic_number,Commen),TypeCandle_,indexCandle_,TFCandle,0.0);
  return TsCandle;}
//+------------------------------------------------------------------+
//|                        gestioneOrdini()                          |
//+------------------------------------------------------------------+  
void gestioneOrdini()
{
double ASK=Ask(Symbol());
double BID=Bid(Symbol());
double c1 = iClose(Symbol(),PERIOD_CURRENT,1);
double o1 = iOpen(Symbol(),PERIOD_CURRENT,1);
double primo=iAlligator(Symbol(),period_,jawPeriod,jawShift,teethPeriod,teethShift,lipsPeriod,lipsShift,MAMethod,appliedPrice,1,1);//Print(" primo: ",primo);
double secon=iAlligator(Symbol(),period_,jawPeriod,jawShift,teethPeriod,teethShift,lipsPeriod,lipsShift,MAMethod,appliedPrice,1,2);//Print(" secon: ",secon);
double terzo=iAlligator(Symbol(),period_,jawPeriod,jawShift,teethPeriod,teethShift,lipsPeriod,lipsShift,MAMethod,appliedPrice,1,3);//Print(" terzo: ",terzo);
double valAlto=ValoreSuperiore(primo,secon,terzo);
double valBasso=ValoreInferiore(primo,secon,terzo);
if (!NumOrdini(magic_number)&&c1>valAlto&&o1<valAlto&&Type_Orders_!=2)
      SendPosition(Symbol(),ORDER_TYPE_BUY, lotsEA,0,Deviazione, calcoloStopLoss("Buy",ASK),calcoloTakeProf("Buy",ASK),Commen,magic_number);//////////////   Inserimento ordine buy
if (!NumOrdini(magic_number)&&c1<valBasso&&o1>valBasso&&Type_Orders_!=1)
      SendPosition(Symbol(),ORDER_TYPE_SELL,lotsEA,0,Deviazione, calcoloStopLoss("Sell",BID), calcoloTakeProf("Sell",BID),Commen,magic_number);////// Inserimento ordine sell

//if(direzioneCandUno(true,"Buy")) SendPosition(Symbol(),ORDER_TYPE_BUY, lotsEA,0,Deviazione, calcoloStopLoss("Buy",ASK),calcoloTakeProf("Buy",ASK),Commen,magic_number);//////////////   Inserimento ordine buy

//if(direzioneCandUno(true,"Sell")) SendPosition(Symbol(),ORDER_TYPE_SELL,lotsEA,0,Deviazione, calcoloStopLoss("Sell",BID), calcoloTakeProf("Sell",BID),Commen,magic_number);////// Inserimento ordine sell

//Print(" Ticket: ",TicketPrimoOrdine(magic_number),"TypeOrder: ",TypeOrder(TicketPrimoOrdine(magic_number))," NumPosizioni: ",NumPosizioni(magic_number,Commen));


}
/*
input string               symbol_=" ";             // simbolo 
input ENUM_TIMEFRAMES      period_=PERIOD_CURRENT;  // timeframe 
input int                  jawPeriod=13;          // periodo della linea Jaw 
input int                  jawShift=8;            // slittamento della linea Jaw 
input int                  teethPeriod=8;         // periodo della linea Teeth 
input int                  teethShift=5;          // slittamento della linea Teeth 
input int                  lipsPeriod=5;          // periodo della linea Lips 
input int                  lipsShift=3;           // slittamento della linea Lips 
input ENUM_MA_METHOD       MAMethod=MODE_SMMA;    // medoto di media delle linee di Alligator 
input ENUM_APPLIED_PRICE   appliedPrice=PRICE_MEDIAN;// tipo di prezzo utilizzato per il calcolo di Alligator  */  