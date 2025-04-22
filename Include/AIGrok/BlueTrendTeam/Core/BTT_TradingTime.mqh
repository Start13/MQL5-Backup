#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.mql5.com"
#property version   "1.00"

class CTradingTime {
private:
   bool tradingAllowed;
   int startHour, endHour;

public:
   CTradingTime() : startHour(9), endHour(17), tradingAllowed(true) {}

   void Init(int start = 9, int end = 17) {
      startHour = start;
      endHour = end;
   }

   bool IsTradingAllowed() {
      MqlDateTime time;
      TimeToStruct(TimeCurrent(), time);
      tradingAllowed = (time.hour >= startHour && time.hour < endHour);
      return tradingAllowed;
   }
};