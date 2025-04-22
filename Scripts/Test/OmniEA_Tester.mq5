//+------------------------------------------------------------------+
//|                     OmniEA_Tester.mq5                            |
//|               BlueTrendTeam - Test Integrazione                  |
//|                     Copyright 2024, BlueTrendTeam                |
//+------------------------------------------------------------------+
#property strict
#property script_show_inputs

#include <AIDeepSeek\BlueTrendTeam\BTTPanels_11_04_2025.mqh>

input int TestDuration = 60;  // Durata test in secondi

//+------------------------------------------------------------------+
//| Script start function                                            |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("=== TEST INIZIATO ===");
   
   if(!TestCreation()) {
      Alert("Test creazione FALLITO!");
      return;
   }
   
   TestPerformance();
   
   Print("=== TEST COMPLETATO ===");
}

bool TestCreation()
{
   CBTTPanel testPanel;
   
   // Test 1: Creazione base
   if(!testPanel.Create(clrNavy, 300, 500)) {
      Print("Errore creazione iniziale");
      return false;
   }
   
   // Test 2: Ricreazione dinamica
   for(int i = 0; i < 3; i++) {
      testPanel.Destroy();
      if(!testPanel.Create(clrBlue, 300 + i*50, 500 + i*50)) {
         Print("Errore ricreazione ", i+1);
         return false;
      }
      Sleep(200);
   }
   
   testPanel.Destroy();
   Print("Test creazione SUPERATO");
   return true;
}

void TestPerformance()
{
   CBTTPanel perfPanel;
   
   if(!perfPanel.Create(clrGray, 350, 550)) {
      Alert("Init fallito");
      return;
   }
   
   // Crea pulsante di test reale
   string testBtn = "TestButton_123";
   ObjectCreate(0, testBtn, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, testBtn, OBJPROP_XDISTANCE, 100);
   ObjectSetInteger(0, testBtn, OBJPROP_YDISTANCE, 100);
   ObjectSetInteger(0, testBtn, OBJPROP_XSIZE, 100);
   ObjectSetInteger(0, testBtn, OBJPROP_YSIZE, 30);
   ObjectSetString(0, testBtn, OBJPROP_TEXT, "Test");
   
   uint start = GetTickCount();
   uint ops = 0;
   
   while((int)(GetTickCount() - start) < TestDuration * 1000) {
      perfPanel.Update();
      ops++;
      
      if(ops % 15 == 0) {
         string btnName = testBtn;  // Usa variabile invece di literal
         perfPanel.HandleEvent(CHARTEVENT_OBJECT_CLICK, 0, 0.0, btnName);
      }
      Sleep(20);
   }
   
   ObjectDelete(0, testBtn);
   perfPanel.Destroy();
   
   Print("Performance: ", ops, " ops (", DoubleToString(ops/(double)TestDuration,1), " ops/sec)");
}