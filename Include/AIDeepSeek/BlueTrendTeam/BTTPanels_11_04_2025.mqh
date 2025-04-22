//+------------------------------------------------------------------+
//|                  BTTPanels_11_04_2025.mqh                        |
//|               BlueTrendTeam - Pannello Avanzato MT5              |
//|                     Copyright 2024, BlueTrendTeam                |
//+------------------------------------------------------------------+
#property strict
#property version "2.5"

class CBTTPanel
{
private:
   int m_width;
   int m_height;
   color m_color;
   bool m_isMinimized;
   string m_panelName;
   
   struct IndicatorSlot {
      int handle;
      string name;
      double values[];
      datetime last_update;
      bool is_active;
   };
   
   IndicatorSlot m_slots[8];
   
   // Metodi interni
   void DrawPanel();
   void DrawControlButtons();
   void UpdateIndicatorValues();
   void CleanSlots();
   void ProcessClickEvent(const string &sparam);

public:
   // Interface Pubblica
   CBTTPanel() : m_width(300), m_height(500), m_color(clrRoyalBlue), m_isMinimized(false)
   {
      m_panelName = "BTT_Panel_" + IntegerToString(ChartID());
   }
   
   bool Create(color bgColor, int width, int height);
   void Destroy();
   void Update();
   void HandleEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
// In MQL5, the `HandleEvent` function is typically used in the context of handling custom events in an Expert Advisor (EA) or script. This function is not a built-in MQL5 function but rather a user-defined function that you can implement to process events that you post using `EventChartCustom()` or similar functions.
// 
// Here's a basic outline of how you might define and use the `HandleEvent` function:
// 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Initialization code here
   // For example, you might want to set up event listeners or other initial settings
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom event handler function                                    |
//+------------------------------------------------------------------+
void HandleEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   // Handle the event based on the id
   switch(id)
     {
      case 1:
         // Handle event type 1
         Print("Event 1 received with parameters: ", lparam, ", ", dparam, ", ", sparam);
         break;

      case 2:
         // Handle event type 2
         Print("Event 2 received with parameters: ", lparam, ", ", dparam, ", ", sparam);
         break;

      // Add more cases as needed for different event types

      default:
         // Handle unknown event types
         Print("Unknown event received with id: ", id);
         break;
     }
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Cleanup code here
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Main logic of your EA
   // You can post custom events using EventChartCustom() if needed
  }

// 
// ### Explanation:
// 
// - **`HandleEvent` Function**: This function takes four parameters: `id`, `lparam`, `dparam`, and `sparam`. These parameters are typically used to pass information about the event being handled. The `id` parameter is used to identify the type of event, while `lparam`, `dparam`, and `sparam` can carry additional data.
// 
// - **Event Handling**: Inside the `HandleEvent` function, a `switch` statement is used to determine the type of event based on the `id` parameter. You can define different cases for different event types and implement the corresponding logic for each event.
// 
// - **Initialization and Deinitialization**: The `OnInit` and `OnDeinit` functions are used for setting up and cleaning up resources when the EA is started and stopped, respectively.
// 
// - **Main Logic**: The `OnTick` function contains the main logic of your EA, which is executed on every new tick. You can use this function to post custom events if needed.
// 
// This structure allows you to handle custom events in a flexible way, responding to different types of events with specific logic.
// 

   void Resize(int newWidth, int newHeight);
   bool AssignIndicator(int slotIndex, string indicatorName);
   void ToggleViewMode();
};

// Implementazioni ====================================================

bool CBTTPanel::Create(color bgColor, int width, int height)
{
   m_color = bgColor;
   m_width = width;
   m_height = height;
   
   for(int i = 0; i < 8; i++) {
      m_slots[i].handle = INVALID_HANDLE;
      m_slots[i].name = "Slot_" + IntegerToString(i);
      ArrayResize(m_slots[i].values, 1);
      m_slots[i].last_update = 0;
      m_slots[i].is_active = false;
   }
   
   DrawPanel();
   DrawControlButtons();
   return true;
}

void CBTTPanel::Destroy()
{
   CleanSlots();
   ObjectDelete(0, m_panelName);
   ObjectDelete(0, m_panelName + "_MinimizeBtn");
}

void CBTTPanel::Update()
{
   UpdateIndicatorValues();
   DrawPanel();
}

void CBTTPanel::HandleEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   switch(id) {
      case CHARTEVENT_OBJECT_CLICK:
         ProcessClickEvent(sparam);
         break;
   }
}

void CBTTPanel::ProcessClickEvent(const string &sparam)
{
   if(sparam == m_panelName + "_MinimizeBtn") {
      ToggleViewMode();
   }
}

void CBTTPanel::Resize(int newWidth, int newHeight)
{
   m_width = newWidth;
   m_height = newHeight;
   DrawPanel();
}

bool CBTTPanel::AssignIndicator(int slotIndex, string indicatorName)
{
   if(slotIndex < 0 || slotIndex >= 8) return false;
   
   if(m_slots[slotIndex].handle != INVALID_HANDLE) {
      IndicatorRelease(m_slots[slotIndex].handle);
   }
   
   m_slots[slotIndex].handle = iCustom(_Symbol, _Period, indicatorName);
   if(m_slots[slotIndex].handle == INVALID_HANDLE) {
      Print("Failed to load: ", indicatorName);
      return false;
   }
   
   m_slots[slotIndex].name = indicatorName;
   m_slots[slotIndex].is_active = true;
   m_slots[slotIndex].last_update = TimeCurrent();
   return true;
}

void CBTTPanel::ToggleViewMode()
{
   m_isMinimized = !m_isMinimized;
   Resize(m_width, m_isMinimized ? 50 : 500);
   ObjectSetString(0, m_panelName + "_MinimizeBtn", OBJPROP_TEXT, m_isMinimized ? "+" : "-");
}

// Funzioni interne ==================================================

void CBTTPanel::DrawPanel()
{
   ObjectCreate(0, m_panelName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, 10);
   ObjectSetInteger(0, m_panelName, OBJPROP_XSIZE, m_width);
   ObjectSetInteger(0, m_panelName, OBJPROP_YSIZE, m_height);
   ObjectSetInteger(0, m_panelName, OBJPROP_BGCOLOR, m_color);
}

void CBTTPanel::DrawControlButtons()
{
   string btnName = m_panelName + "_MinimizeBtn";
   ObjectCreate(0, btnName, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, btnName, OBJPROP_XDISTANCE, m_width - 25);
   ObjectSetInteger(0, btnName, OBJPROP_YDISTANCE, 5);
   ObjectSetInteger(0, btnName, OBJPROP_XSIZE, 20);
   ObjectSetInteger(0, btnName, OBJPROP_YSIZE, 20);
   ObjectSetString(0, btnName, OBJPROP_TEXT, m_isMinimized ? "+" : "-");
}

void CBTTPanel::UpdateIndicatorValues()
{
   for(int i = 0; i < 8; i++) {
      if(m_slots[i].is_active && m_slots[i].handle != INVALID_HANDLE) {
         double val[];
         if(CopyBuffer(m_slots[i].handle, 0, 0, 1, val) > 0) {
            m_slots[i].values[0] = val[0];
            m_slots[i].last_update = TimeCurrent();
         }
      }
   }
}

void CBTTPanel::CleanSlots()
{
   for(int i = 0; i < 8; i++) {
      if(m_slots[i].handle != INVALID_HANDLE) {
         IndicatorRelease(m_slots[i].handle);
      }
   }
}