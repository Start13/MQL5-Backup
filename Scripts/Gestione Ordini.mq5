#include <MyLibrary\Enum Day Week.mqh>
#include <MyInclude\Patterns_Sq9.mqh>
#include <MyLibrary\MyLibrary.mqh>
#include <MyInclude\PosizioniTicket.mqh>

void OnStart()
  {
//---
   
  }
//+------------------------------------------------------------------+
void GestioneOrdini()
{
   if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)&&IsMarketTradeOpen()&&SpreadMax()&&PrimiOrdiniSuStessaCandela()&&InTradingTime12()&&N_max_orders()&&ApriOrdineDalLiv()&&ApreNuoviOrdiniFinoAlLivello()
      &&Filtro_Pivot_Weekly()&&N_CandleConsecutive()&&Repet_orders_stesso_level()&&EnablePosSuStessiLivDaily()&&InibithGrid()&&InibithHedge())
      {return true;}




}

bool SpreadMax(){return true;}
bool PrimiOrdiniSuStessaCandela(){return true;}
bool InTradingTime12(){return true;}