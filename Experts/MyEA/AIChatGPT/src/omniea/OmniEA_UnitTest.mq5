//+------------------------------------------------------------------+
//|                                           OmniEA_UnitTest.mq5    |
//|        Script test base per moduli OmniEA                       |
//+------------------------------------------------------------------+
#include <Utils\Assert.mqh>
#include <Logic\SlotLogic.mqh>
#include <Logic\ConditionGenerator.mqh>
#include <Logic\NewsFilter.mqh>

void OnStart()
  {
   Assert(SlotIsTriggered(10, 5, 15), "SlotIsTriggered true");
   Assert(!SlotIsTriggered(4, 5, 15), "SlotIsTriggered false");

   string cond = GetConditionName("ABOVE");
   Assert(cond == "Price Above", "ConditionGenerator ABOVE");

   Assert(IsNewsActive(TimeCurrent()) == false, "NewsFilter default false");

   Print("✅ All OmniEA module tests completed");
  }
