//+------------------------------------------------------------------+ 
//|                                            AutoGannAutoTrend.mq5 | 
//|                                         Copyright © 2016, zzuegg | 
//|                                       when-money-makes-money.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright © 2016, zzuegg"
#property link "when-money-makes-money.com" 
//---- íîìåð âåðñèè èíäèêàòîðà
#property version   "1.00"
//+------------------------------------------------+ 
//|  Ïàðàìåòðû îòðèñîâêè èíäèêàòîðà                |
//+------------------------------------------------+ 
//---- îòðèñîâêà èíäèêàòîðà â ãëàâíîì îêíå
#property indicator_chart_window 
#property indicator_buffers 0
#property indicator_plots   0
//+------------------------------------------------+ 
//|  Îáúÿâëåíèå êîíñòàíò                           |
//+------------------------------------------------+
#define RESET               0                   // Êîíñòàíòà äëÿ âîçâðàòà òåðìèíàëó êîìàíäû íà ïåðåñ÷åò èíäèêàòîðà
//+------------------------------------------------+ 
//|  Âõîäíûå ïàðàìåòðû èíäèêàòîðà                  |
//+------------------------------------------------+ 
//---- Âõîäíûå ïàðàìåòðû Çèãçàãà
input ENUM_TIMEFRAMES Timeframe=PERIOD_H6;             // Òàéìôðåéì Çèãçàãà äëÿ ðàñ÷åòà èíäèêàòîðà
input int ExtDepth=12;
input int ExtDeviation=5;
input int ExtBackstep=3;
//---- íàñòðîéêè âèçóàëüíîãî îòîáðàæåíèÿ èíäèêàòîðà
input string Sirname="AutoGannAutoTrend";  // Íàçâàíèå äëÿ ìåòîê èíäèêàòîðà
input bool ShowFib=true;
input color FibColor=clrRed;
input uint   FibSize=1;
//----
input bool ShowGannFan=true;
input color GannFanColor=clrDarkViolet;
input uint GannFanSize=1;
//----
input bool ShowTrend=true;
input color TrendColor=clrBlue;
input uint TrendSize=5;
//+-----------------------------------+
//---- îáúÿâëåíèå öåëî÷èñëåííûõ ïåðåìåííûõ äëÿ õåíäëîâ èíäèêàòîðîâ
int Ind_Handle;
//---- îáúÿâëåíèå öåëî÷èñëåííûõ ïåðåìåííûõ íà÷àëà îòñ÷åòà äàííûõ
int min_rates_total;
string fib1="";
string trend="";
string gann1="";
//+------------------------------------------------------------------+
//| Ïîëó÷åíèå òàéìôðåéìà â âèäå ñòðîêè                               |
//+------------------------------------------------------------------+
string GetStringTimeframe(ENUM_TIMEFRAMES timeframe)
  {return(StringSubstr(EnumToString(timeframe),7,-1));}
//+------------------------------------------------------------------+    
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+  
int OnInit()
  {
//---- Èíèöèàëèçàöèÿ ïåðåìåííûõ íà÷àëà îòñ÷åòà äàííûõ   
   min_rates_total=100;

//---- èíèöèàëèçàöèÿ ïåðåìåííûõ
   fib1=Sirname+" fib1 "+GetStringTimeframe(Timeframe);
   trend=Sirname+" trend1 "+GetStringTimeframe(Timeframe);
   gann1=Sirname+" gann1 "+GetStringTimeframe(Timeframe);

//---- ïîëó÷åíèå õåíäëà èíäèêàòîðà ZigZag_NK_Color
   Ind_Handle=iCustom(Symbol(),Timeframe,"zigzag_nk_color",ExtDepth,ExtDeviation,ExtBackstep);
   if(Ind_Handle==INVALID_HANDLE)
     {
      Print(" Íå óäàëîñü ïîëó÷èòü õåíäë èíäèêàòîðà ZigZag_NK_Color");
      return(INIT_FAILED);
     }

//---- èìÿ äëÿ îêîí äàííûõ è ëýéáà äëÿ ñóáúîêîí 
   string shortname;
   StringConcatenate(shortname,"ZigZag (ExtDepth=",ExtDepth,"ExtDeviation = ",ExtDeviation,"ExtBackstep = ",ExtBackstep,")");
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
//--- îïðåäåëåíèå òî÷íîñòè îòîáðàæåíèÿ çíà÷åíèé èíäèêàòîðà
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- çàâåðøåíèå èíèöèàëèçàöèè
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+    
void OnDeinit(const int reason)
  {
//----
   ObjectDelete(0,fib1);
   ObjectDelete(0,trend);
   ObjectDelete(0,gann1);
//----
   ChartRedraw(0);
  }
//+------------------------------------------------------------------+  
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+  
int OnCalculate(const int rates_total,    // êîëè÷åñòâî èñòîðèè â áàðàõ íà òåêóùåì òèêå
                const int prev_calculated,// êîëè÷åñòâî èñòîðèè â áàðàõ íà ïðåäûäóùåì òèêå
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---- ïðîâåðêà êîëè÷åñòâà áàðîâ íà äîñòàòî÷íîñòü äëÿ ðàñ÷åòà
   if(BarsCalculated(Ind_Handle)<min_rates_total) return(RESET);
   if(BarsCalculated(Ind_Handle)<Bars(Symbol(),Timeframe)) return(prev_calculated);
//---- îáúÿâëåíèå ëîêàëüíûõ ïåðåìåííûõ
   double UpSign[],DnSign[];
   static datetime TIME[];

//---- êîïèðóåì âíîâü ïîÿâèâøèåñÿ äàííûå â ìàññèâû
   if(CopyBuffer(Ind_Handle,0,0,rates_total,DnSign)<=0) return(RESET);
   if(CopyBuffer(Ind_Handle,1,0,rates_total,UpSign)<=0) return(RESET);
   if(CopyTime(Symbol(),Timeframe,0,rates_total,TIME)<=0) return(RESET);

//---- èíäåêñàöèÿ ýëåìåíòîâ â ìàññèâàõ, êàê â òàéìñåðèÿõ  
   ArraySetAsSeries(DnSign,true);
   ArraySetAsSeries(UpSign,true);
   ArraySetAsSeries(TIME,true);

   static datetime curr=NULL;
   if(curr!=TIME[0])
     {
      curr=TIME[0];
      double swing_value[4]={0,0,0,0};
      datetime swing_date[4]={0,0,0,0};
      int found=NULL;
      double tmp=NULL;
      int bar=NULL;
      while(found<4 && bar<rates_total)
        {
         if(UpSign[bar])
           {
            swing_value[found]=UpSign[bar];
            swing_date[found]=TIME[bar];
            found++;
           }
         if(DnSign[bar])
           {
            swing_value[found]=DnSign[bar];
            swing_date[found]=TIME[bar];
            found++;
           }
         bar++;
        }

      if(ShowTrend) SetChannel(0,trend,0,swing_date[3],swing_value[3],swing_date[1],swing_value[1],swing_date[2],swing_value[2],TrendColor,0,TrendSize,true,trend);
      if(ShowFib) SetFibo(0,fib1,0,swing_date[2],swing_value[2],swing_date[1],swing_value[1],FibColor,0,FibSize,true,fib1);
      if(ShowGannFan)
        {
         double Scale=(swing_value[1]-swing_value[2])/(_Point*(swing_date[1]-swing_date[2])/PeriodSeconds());
         SetGannFan(0,gann1,0,swing_date[2],swing_value[2],swing_date[1],Scale,GannFanColor,0,GannFanSize,gann1);
        }
     }
//----
   ChartRedraw(0);
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|  Ñîçäàíèå Ôèáî                                                   |
//+------------------------------------------------------------------+
void CreateFibo
(
 long     chart_id,      // èäåíòèôèêàòîð ãðàôèêà
 string   name,          // èìÿ îáúåêòà
 int      nwin,          // èíäåêñ îêíà
 datetime time1,         // âðåìÿ 1 öåíîâîãî óðîâíÿ
 double   price1,        // 1 öåíîâîé óðîâåíü
 datetime time2,         // âðåìÿ 2 öåíîâîãî óðîâíÿ
 double   price2,        // 2 öåíîâîé óðîâåíü
 color    Color,         // öâåò ëèíèè
 int      style,         // ñòèëü ëèíèè
 int      width,         // òîëùèíà ëèíèè
 int      ray,           // íàïðàâëåíèå ëó÷à: -1 - âëåâî, +1 - âïðàâî, îñòàëüíûå çíà÷åíèÿ - íåò ëó÷à
 string   text           // òåêñò
 )
//---- 
  {
//----
   ObjectCreate(chart_id,name,OBJ_FIBO,nwin,time1,price1,time2,price2);
   ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
   ObjectSetInteger(chart_id,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_id,name,OBJPROP_WIDTH,width);

   if(ray>0)ObjectSetInteger(chart_id,name,OBJPROP_RAY_RIGHT,true);
   if(ray<0)ObjectSetInteger(chart_id,name,OBJPROP_RAY_LEFT,true);

   if(ray==0)
     {
      ObjectSetInteger(chart_id,name,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(chart_id,name,OBJPROP_RAY_LEFT,false);
     }

   ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_id,name,OBJPROP_BACK,true);

   for(int numb=0; numb<10; numb++)
     {
      ObjectSetInteger(chart_id,name,OBJPROP_LEVELCOLOR,numb,Color);
      ObjectSetInteger(chart_id,name,OBJPROP_LEVELSTYLE,numb,style);
      ObjectSetInteger(chart_id,name,OBJPROP_LEVELWIDTH,numb,width);
     }
//----
  }
//+------------------------------------------------------------------+
//|  Ïåðåóñòàíîâêà Ôèáî                                              |
//+------------------------------------------------------------------+
void SetFibo
(
 long     chart_id,      // èäåíòèôèêàòîð ãðàôèêà
 string   name,          // èìÿ îáúåêòà
 int      nwin,          // èíäåêñ îêíà
 datetime time1,         // âðåìÿ 1 öåíîâîãî óðîâíÿ
 double   price1,        // 1 öåíîâîé óðîâåíü
 datetime time2,         // âðåìÿ 2 öåíîâîãî óðîâíÿ
 double   price2,        // 2 öåíîâîé óðîâåíü
 color    Color,         // öâåò ëèíèè
 int      style,         // ñòèëü ëèíèè
 int      width,         // òîëùèíà ëèíèè
 int      ray,           // íàïðàâëåíèå ëó÷à: -1 - âëåâî, 0 - íåò ëó÷à, +1 - âïðàâî
 string   text           // òåêñò
 )
//---- 
  {
//----
   if(ObjectFind(chart_id,name)==-1) CreateFibo(chart_id,name,nwin,time1,price1,time2,price2,Color,style,width,ray,text);
   else
     {
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectMove(chart_id,name,0,time1,price1);
      ObjectMove(chart_id,name,1,time2,price2);
     }
//----
  }
//+------------------------------------------------------------------+
//|  Ñîçäàíèå Âååðà Ãàííà                                            |
//+------------------------------------------------------------------+
void CreateGannFan
(
 long     chart_id,      // èäåíòèôèêàòîð ãðàôèêà
 string   name,          // èìÿ îáúåêòà
 int      nwin,          // èíäåêñ îêíà
 datetime time1,         // âðåìÿ 1 öåíîâîãî óðîâíÿ
 double   price1,        // 1 öåíîâîé óðîâåíü
 datetime time2,         // âðåìÿ 2 öåíîâîãî óðîâíÿ
 double   scale,         // Ìàñøòàá (êîëè÷åñòâî ïèïñîâ íà áàð) 
 color    Color,         // öâåò ëèíèè
 int      style,         // ñòèëü ëèíèè
 int      width,         // òîëùèíà ëèíèè
 string   text           // òåêñò
 )
//---- 
  {
//----
   ObjectCreate(chart_id,name,OBJ_GANNFAN,nwin,time1,price1,time2,0);
   ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
   ObjectSetInteger(chart_id,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_id,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_id,name,OBJPROP_DIRECTION,true);
   ObjectSetDouble(chart_id,name,OBJPROP_SCALE,scale);
   ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_id,name,OBJPROP_BACK,true);
   ObjectSetInteger(chart_id,name,OBJPROP_DIRECTION,false);
//----
  }
//+------------------------------------------------------------------+
//|  Ïåðåóñòàíîâêà Âååðà Ãàííà                                       |
//+------------------------------------------------------------------+
void SetGannFan
(
 long     chart_id,      // èäåíòèôèêàòîð ãðàôèêà
 string   name,          // èìÿ îáúåêòà
 int      nwin,          // èíäåêñ îêíà
 datetime time1,         // âðåìÿ 1 öåíîâîãî óðîâíÿ
 double   price1,        // 1 öåíîâîé óðîâåíü
 datetime time2,         // âðåìÿ 2 öåíîâîãî óðîâíÿ
 double   scale,         // Ìàñøòàá (êîëè÷åñòâî ïèïñîâ íà áàð) 
 color    Color,         // öâåò ëèíèè
 int      style,         // ñòèëü ëèíèè
 int      width,         // òîëùèíà ëèíèè
 string   text           // òåêñò
 )
//---- 
  {
//----
   if(ObjectFind(chart_id,name)==-1) CreateGannFan(chart_id,name,nwin,time1,price1,time2,scale,Color,style,width,text);
   else
     {
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectMove(chart_id,name,0,time1,price1);
      ObjectMove(chart_id,name,1,time2,0.0);
      ObjectSetDouble(chart_id,name,OBJPROP_SCALE,scale);
     }
//----
  }
//+------------------------------------------------------------------+
//|  Ñîçäàíèå êàíàëà                                                 |
//+------------------------------------------------------------------+
void CreateChannel
(
 long     chart_id,      // èäåíòèôèêàòîð ãðàôèêà
 string   name,          // èìÿ îáúåêòà
 int      nwin,          // èíäåêñ îêíà
 datetime time1,         // âðåìÿ 1 öåíîâîãî óðîâíÿ
 double   price1,        // 1 öåíîâîé óðîâåíü
 datetime time2,         // âðåìÿ 2 öåíîâîãî óðîâíÿ
 double   price2,        // 2 öåíîâîé óðîâåíü
 datetime time3,         // âðåìÿ 3 öåíîâîãî óðîâíÿ
 double   price3,        // 3 öåíîâîé óðîâåíü
 color    Color,         // öâåò ëèíèè
 int      style,         // ñòèëü ëèíèè
 int      width,         // òîëùèíà ëèíèè
 int      ray,           // íàïðàâëåíèå ëó÷à: -1 - âëåâî, +1 - âïðàâî, îñòàëüíûå çíà÷åíèÿ - íåò ëó÷à
 string   text           // òåêñò
 )
//---- 
  {
//----
   ObjectCreate(chart_id,name,OBJ_CHANNEL,nwin,time1,price1,time2,price2,time3,price3);
   ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
   ObjectSetInteger(chart_id,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_id,name,OBJPROP_WIDTH,width);

   if(ray>0)ObjectSetInteger(chart_id,name,OBJPROP_RAY_RIGHT,true);
   if(ray<0)ObjectSetInteger(chart_id,name,OBJPROP_RAY_LEFT,true);

   if(ray==0)
     {
      ObjectSetInteger(chart_id,name,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(chart_id,name,OBJPROP_RAY_LEFT,false);
     }

   ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_id,name,OBJPROP_BACK,true);

   for(int numb=0; numb<10; numb++)
     {
      ObjectSetInteger(chart_id,name,OBJPROP_LEVELCOLOR,numb,Color);
      ObjectSetInteger(chart_id,name,OBJPROP_LEVELSTYLE,numb,style);
      ObjectSetInteger(chart_id,name,OBJPROP_LEVELWIDTH,numb,width);
     }
//----
  }
//+------------------------------------------------------------------+
//|  Ïåðåóñòàíîâêà êàíàëà                                            |
//+------------------------------------------------------------------+
void SetChannel
(
 long     chart_id,      // èäåíòèôèêàòîð ãðàôèêà
 string   name,          // èìÿ îáúåêòà
 int      nwin,          // èíäåêñ îêíà
 datetime time1,         // âðåìÿ 1 öåíîâîãî óðîâíÿ
 double   price1,        // 1 öåíîâîé óðîâåíü
 datetime time2,         // âðåìÿ 2 öåíîâîãî óðîâíÿ
 double   price2,        // 2 öåíîâîé óðîâåíü
 datetime time3,         // âðåìÿ 3 öåíîâîãî óðîâíÿ
 double   price3,        // 3 öåíîâîé óðîâåíü
 color    Color,         // öâåò ëèíèè
 int      style,         // ñòèëü ëèíèè
 int      width,         // òîëùèíà ëèíèè
 int      ray,           // íàïðàâëåíèå ëó÷à: -1 - âëåâî, 0 - íåò ëó÷à, +1 - âïðàâî
 string   text           // òåêñò
 )
//---- 
  {
//----
   if(ObjectFind(chart_id,name)==-1) CreateChannel(chart_id,name,nwin,time1,price1,time2,price2,time3,price3,Color,style,width,ray,text);
   else
     {
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectMove(chart_id,name,0,time1,price1);
      ObjectMove(chart_id,name,1,time2,price2);
      ObjectMove(chart_id,name,2,time3,price3);
     }
//----
  }
//+------------------------------------------------------------------+
