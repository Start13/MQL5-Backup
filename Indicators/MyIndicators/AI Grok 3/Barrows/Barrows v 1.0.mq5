//+------------------------------------------------------------------+
//|                                                 Barros Swing.mq5 |
//|                                    Copyright © 2009, Walter Choy |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Walter Choy"
#property link      ""
#property version   "1.00"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   3

//--- Plot settings for d1_swing
#property indicator_label1  "1-period Swing"
#property indicator_type1   DRAW_SECTION
#property indicator_color1  clrOrangeRed
#property indicator_width1  1

//--- Plot settings for dn_swing
#property indicator_label2  "n-period Swing"
#property indicator_type2   DRAW_SECTION
#property indicator_color2  clrMediumPurple
#property indicator_width2  1

//--- Plot settings for XABC
#property indicator_label3  "XABC"
#property indicator_type3   DRAW_SECTION
#property indicator_color3  clrRed
#property indicator_width3  1

//---- Input parameters
input int       period = 18;               // Period for swing calculation
input bool      show_d1_swing = false;     // Show 1-period swing

input string    XABC_setting = "<<-- XABC Settings -->>";
input bool      XABC_enabled = true;       // Enable XABC
input datetime  XABC_spec_time = 0;        // Specific time for XABC (e.g., D'2008.12.1 00:00')
input string    XABC_font = "Arial";       // Font for XABC labels
input int       XABC_font_size = 16;       // Font size for XABC labels
input color     XABC_font_color = clrWhite;// Font color for XABC labels
input color     XABC_ME_line_color = clrYellow; // Line color for XABC ME

//---- Constants
#define LINE_DIRECT_UP  1
#define LINE_DIRECT_DN  -1
#define LINE_NO_DIRECT  -2

#define XABC_A             0
#define XABC_A_BAR         1
#define XABC_B             2
#define XABC_B_BAR         3
#define XABC_C             4
#define XABC_C_BAR         5
#define XABC_UPPER_ME      6
#define XABC_LOWER_ME      7
#define XABC_PBZ           8
#define XABC_PSZ           9
#define XABC_SWING_COUNT   10

//---- Indicator buffers
double d1_swing[];
double dn_swing[];
double XABC[];
double imean[];
double signals[];
double d1_line_direct[];
double dn_line_direct[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Allocate buffers
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);

   SetIndexBuffer(0, d1_swing, INDICATOR_DATA);
   if(!show_d1_swing)
      PlotIndexSetInteger(0, PLOT_DRAW_TYPE, DRAW_NONE);
   PlotIndexSetString(0, PLOT_LABEL, "1-period Swing");
   ArraySetAsSeries(d1_swing, true);

   SetIndexBuffer(1, dn_swing, INDICATOR_DATA);
   PlotIndexSetString(1, PLOT_LABEL, IntegerToString(period) + "-period Swing");
   ArraySetAsSeries(dn_swing, true);

   SetIndexBuffer(2, XABC, INDICATOR_DATA);
   PlotIndexSetString(2, PLOT_LABEL, "XABC");
   ArraySetAsSeries(XABC, true);

   SetIndexBuffer(3, imean, INDICATOR_CALCULATIONS);
   ArraySetAsSeries(imean, true);

   SetIndexBuffer(4, signals, INDICATOR_CALCULATIONS);
   ArraySetAsSeries(signals, true);

   SetIndexBuffer(5, d1_line_direct, INDICATOR_CALCULATIONS);
   ArraySetAsSeries(d1_line_direct, true);

   SetIndexBuffer(6, dn_line_direct, INDICATOR_CALCULATIONS);
   ArraySetAsSeries(dn_line_direct, true);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   clear_label();
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int i, j, n;
   double shd_h, shd_l;
   int direct;
   static double impulse_mean = 0, impulse_count = 0, last_val_1 = 0, last_val_2 = 0, last_val_3 = 0;
   double val_0, val_1, val_2, val_3;

   n = rates_total - prev_calculated;
   if(n <= 0) n = rates_total - 1;
   i = n - 1;

   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(time, true);

   // Calculate 1-period swings
   while(i >= 0)
   {
      if(i == rates_total - 1) // Ultima barra
      {
         shd_h = high[i] - (i > 0 ? high[i - 1] : high[i]); // Correzione: i - 1 invece di i + 1
         shd_l = low[i] - (i > 0 ? low[i - 1] : low[i]);   // Correzione: i - 1 invece di i + 1
         if(shd_h > shd_l)
         {
            d1_swing[i] = high[i];
            d1_line_direct[i] = LINE_DIRECT_UP;
         }
         else
         {
            d1_swing[i] = low[i];
            d1_line_direct[i] = LINE_DIRECT_DN;
         }
      }
      else
      {
         direct = d1_direct(i, high, low, rates_total);
         switch(direct)
         {
            case LINE_DIRECT_UP:
               d1_swing[i] = high[i];
               d1_line_direct[i] = LINE_DIRECT_UP;
               if(i + 1 < rates_total && d1_line_direct[i + 1] == LINE_DIRECT_UP) d1_swing[i + 1] = 0;
               if(i + 1 < rates_total && d1_line_direct[i + 1] == LINE_NO_DIRECT)
               {
                  j = i + 1;
                  while(j < rates_total && d1_line_direct[j] == LINE_NO_DIRECT) j++;
                  if(j < rates_total && d1_line_direct[j] == LINE_DIRECT_UP)
                  {
                     if(high[j] < high[i])
                        d1_swing[j] = 0;
                     else
                     {
                        d1_swing[i] = 0;
                        d1_line_direct[i] = LINE_NO_DIRECT;
                     }
                  }
               }
               break;

            case LINE_DIRECT_DN:
               d1_swing[i] = low[i];
               d1_line_direct[i] = LINE_DIRECT_DN;
               if(i + 1 < rates_total && d1_line_direct[i + 1] == LINE_DIRECT_DN) d1_swing[i + 1] = 0;
               if(i + 1 < rates_total && d1_line_direct[i + 1] == LINE_NO_DIRECT)
               {
                  j = i + 1;
                  while(j < rates_total && d1_line_direct[j] == LINE_NO_DIRECT) j++;
                  if(j < rates_total && d1_line_direct[j] == LINE_DIRECT_DN)
                  {
                     if(low[j] > low[i])
                        d1_swing[j] = 0;
                     else
                     {
                        d1_swing[i] = 0;
                        d1_line_direct[i] = LINE_NO_DIRECT;
                     }
                  }
               }
               break;

            case LINE_NO_DIRECT:
               d1_swing[i] = 0;
               d1_line_direct[i] = LINE_NO_DIRECT;
               break;
         }
      }
      i--;
   }

   // Calculate n-period swings
   i = n - 1;
   while(i >= 0)
   {
      if(i == rates_total - 1)
      {
         shd_h = high[i] - (i > 0 ? high[i - 1] : high[i]); // Correzione simile
         shd_l = low[i] - (i > 0 ? low[i - 1] : low[i]);   // Correzione simile
         if(shd_h > shd_l)
         {
            dn_swing[i] = high[i];
            dn_line_direct[i] = LINE_DIRECT_UP;
         }
         else
         {
            dn_swing[i] = low[i];
            dn_line_direct[i] = LINE_DIRECT_DN;
         }
      }
      else
      {
         direct = dn_direct(i, period, high, low, rates_total);
         switch(direct)
         {
            case LINE_DIRECT_UP:
               dn_swing[i] = high[i];
               dn_line_direct[i] = LINE_DIRECT_UP;
               if(i + 1 < rates_total && dn_line_direct[i + 1] == LINE_DIRECT_UP) dn_swing[i + 1] = 0;
               if(i + 1 < rates_total && dn_line_direct[i + 1] == LINE_NO_DIRECT)
               {
                  j = i + 1;
                  while(j < rates_total && dn_line_direct[j] == LINE_NO_DIRECT) j++;
                  if(j < rates_total && dn_line_direct[j] == LINE_DIRECT_UP)
                  {
                     if(high[j] < high[i])
                        dn_swing[j] = 0;
                     else
                     {
                        dn_swing[i] = 0;
                        dn_line_direct[i] = LINE_NO_DIRECT;
                     }
                  }
               }
               break;

            case LINE_DIRECT_DN:
               dn_swing[i] = low[i];
               dn_line_direct[i] = LINE_DIRECT_DN;
               if(i + 1 < rates_total && dn_line_direct[i + 1] == LINE_DIRECT_DN) dn_swing[i + 1] = 0;
               if(i + 1 < rates_total && dn_line_direct[i + 1] == LINE_NO_DIRECT)
               {
                  j = i + 1;
                  while(j < rates_total && dn_line_direct[j] == LINE_NO_DIRECT) j++;
                  if(j < rates_total && dn_line_direct[j] == LINE_DIRECT_DN)
                  {
                     if(low[j] > low[i])
                        dn_swing[j] = 0;
                     else
                     {
                        dn_swing[i] = 0;
                        dn_line_direct[i] = LINE_NO_DIRECT;
                     }
                  }
               }
               break;

            case LINE_NO_DIRECT:
               dn_swing[i] = 0;
               dn_line_direct[i] = LINE_NO_DIRECT;
               break;
         }
      }

      // Calculate impulse means
      val_0 = 0; val_1 = 0; val_2 = 0; val_3 = 0; j = i;
      while(val_3 == 0 && j < rates_total)
      {
         if(dn_swing[j] > 0)
         {
            if(val_0 == 0)
               val_0 = dn_swing[j];
            else if(val_1 == 0)
               val_1 = dn_swing[j];
            else if(val_2 == 0)
               val_2 = dn_swing[j];
            else
               val_3 = dn_swing[j];
         }
         j++;
      }

      bool isimpulse = false;
      if(val_2 > val_1)
      {
         if(val_3 > val_1) isimpulse = true;
      }
      else
      {
         if(val_3 < val_1) isimpulse = true;
      }

      if((last_val_1 != val_1 || last_val_2 != val_2 || last_val_3 != val_3) ||
         (last_val_1 == 0 && last_val_2 == 0 && last_val_3 == 0))
      {
         last_val_1 = val_1; last_val_2 = val_2; last_val_3 = val_3;
         if(val_1 > 0 && val_2 > 0 && val_3 > 0 && isimpulse)
         {
            if(impulse_mean > 0)
            {
               if(MathAbs(val_1 - val_2) <= (impulse_mean * 5.0))
               {
                  impulse_mean = impulse_mean * impulse_count + MathAbs(val_1 - val_2);
                  impulse_count++;
                  impulse_mean /= impulse_count;
               }
            }
            else
            {
               impulse_mean = MathAbs(val_1 - val_2);
               impulse_count = 1;
            }
         }
      }

      GlobalVariableSet(period + "d_Impluse_Mean", impulse_mean);
      GlobalVariableSet(period + "d_Impluse_Count", impulse_count);

      imean[i] = impulse_mean;

      i--;
   }

   if(XABC_enabled) identify_XABC(time, rates_total);

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Helper functions                                                 |
//+------------------------------------------------------------------+
int d1_direct(int idx, const double &high[], const double &low[], int rates_total)
{
   double shd_h, shd_l;

   shd_h = high[idx] - (idx + 1 < rates_total ? high[idx + 1] : high[idx]);
   shd_l = (idx + 1 < rates_total ? low[idx + 1] : low[idx]) - low[idx];

   if(shd_h > shd_l && shd_h > 0)
      return LINE_DIRECT_UP;

   if(shd_h < shd_l && shd_l > 0)
      return LINE_DIRECT_DN;

   return LINE_NO_DIRECT;
}

int dn_direct(int idx, int n, const double &high[], const double &low[], int rates_total)
{
   double shd_h, shd_l, nHigh, nLow, ten_pc;
   double val_1, val_2;
   int i, j;

   nHigh = (idx + 1 < rates_total) ? high[idx + 1] : high[idx];
   nLow = (idx + 1 < rates_total) ? low[idx + 1] : low[idx];
   for(i = 1; i <= n && idx + i < rates_total; i++)
   {
      nHigh = MathMax(nHigh, high[idx + i]);
      nLow = MathMin(nLow, low[idx + i]);
   }

   j = idx + 1; val_1 = 0; val_2 = 0;
   while(val_2 == 0 && j < rates_total)
   {
      if(d1_swing[j] > 0)
      {
         if(val_1 <= 0)
            val_1 = d1_swing[j];
         else
            val_2 = d1_swing[j];
      }
      j++;
   }
   ten_pc = (val_1 > 0 && val_2 > 0) ? MathAbs(val_1 - val_2) * 0.1 : 0;

   nHigh += ten_pc;
   nLow -= ten_pc;

   shd_h = high[idx] - nHigh;
   shd_l = nLow - low[idx];

   if(shd_h > shd_l && shd_h > 0)
      return LINE_DIRECT_UP;

   if(shd_h < shd_l && shd_l > 0)
      return LINE_DIRECT_DN;

   return LINE_NO_DIRECT;
}

// XABC-related variables
int num_label = 0;
int total_swing_pt = 0;
datetime sDateTime[];
double swing_point[];

int total_XABC_swing_pt = 0;
datetime XABC_DateTime[];
double XABC_swing_point[];

void identify_XABC(const datetime &time[], int rates_total)
{
   clear_label();
   clear_swing_pts();
   if(XABC_spec_time > 0)
      catch_swing_pt_ex(time, rates_total);
   else
      catch_swing_pt(time, rates_total);
   catch_XABC(time, rates_total);
   show_XABC(time, rates_total);
}

void catch_XABC(const datetime &time[], int rates_total)
{
   double X_pt, A_pt, B_pt, ME, XA_10pc, AB_20pc, A_Max, A_Min, B_Max, B_Min, imp_mean;
   datetime X_dt, A_dt, B_dt, sp_dt;
   int i, j, A_pos, B_pos;
   bool is_A_Vtop, is_B_Vtop;

   clear_XABC_swing_pts();

   if(XABC_spec_time > 0)
   {
      sp_dt = XABC_spec_time;
      int bar = custom_iBarShift(_Symbol, PERIOD_CURRENT, sp_dt);
      imp_mean = imean[bar];
   }
   else
   {
      sp_dt = TimeCurrent();
      imp_mean = imean[0];
   }

   X_pt = swing_point[total_swing_pt - 1];
   X_dt = sDateTime[total_swing_pt - 1];

   A_pt = swing_point[total_swing_pt - 2];
   A_dt = sDateTime[total_swing_pt - 2];
   A_pos = 2;

   B_pt = swing_point[total_swing_pt - 3];
   B_dt = sDateTime[total_swing_pt - 3];
   B_pos = 3;

   XA_10pc = MathAbs(A_pt - X_pt) * 0.1;
   AB_20pc = MathAbs(B_pt - A_pt) * 0.2;

   ME = MathMax(XA_10pc, AB_20pc);

   is_A_Vtop = (A_pt > X_pt);
   is_B_Vtop = (B_pt > A_pt);

   A_Max = A_pt; A_Min = A_pt;

   for(i = 4; i < total_swing_pt - 1; i += 2)
   {
      if(is_A_Vtop)
      {
         A_Max = MathMax(A_Max, swing_point[total_swing_pt - i]);
         if(swing_point[total_swing_pt - i] >= A_pt && swing_point[total_swing_pt - i] <= A_pt + ME
            && swing_point[total_swing_pt - i] >= A_Max && sDateTime[total_swing_pt - i] < sp_dt)
         {
            A_pt = swing_point[total_swing_pt - i];
            A_dt = sDateTime[total_swing_pt - i];

            for(j = i - 1; j >= 0; j -= 2)
            {
               if(MathAbs(swing_point[total_swing_pt - j] - A_pt) >= imp_mean)
               {
                  X_pt = swing_point[total_swing_pt - j];
                  X_dt = sDateTime[total_swing_pt - j];
                  break;
               }
            }

            XA_10pc = MathAbs(A_pt - X_pt) * 0.1;
            ME = MathMax(XA_10pc, AB_20pc);
            is_A_Vtop = (A_pt > X_pt);
            A_pos = i;
         }
         if(total_swing_pt - i - 1 >= 0 && swing_point[total_swing_pt - i - 1] < A_pt
            && swing_point[total_swing_pt - i] > A_pt + ME
            && swing_point[total_swing_pt - i] >= A_Max && sDateTime[total_swing_pt - i] < sp_dt)
         {
            A_pt = swing_point[total_swing_pt - i];
            A_dt = sDateTime[total_swing_pt - i];

            for(j = i - 1; j >= 0; j -= 2)
            {
               if(MathAbs(swing_point[total_swing_pt - j] - A_pt) >= imp_mean)
               {
                  X_pt = swing_point[total_swing_pt - j];
                  X_dt = sDateTime[total_swing_pt - j];
                  break;
               }
            }

            XA_10pc = MathAbs(A_pt - X_pt) * 0.1;
            ME = MathMax(XA_10pc, AB_20pc);
            is_A_Vtop = (A_pt > X_pt);
            A_pos = i;
         }
      }
      else
      {
         A_Min = MathMin(A_Min, swing_point[total_swing_pt - i]);
         if(swing_point[total_swing_pt - i] <= A_pt && swing_point[total_swing_pt - i] >= A_pt - ME
            && swing_point[total_swing_pt - i] <= A_Min && sDateTime[total_swing_pt - i] < sp_dt)
         {
            A_pt = swing_point[total_swing_pt - i];
            A_dt = sDateTime[total_swing_pt - i];

            for(j = i - 1; j >= 0; j -= 2)
            {
               if(MathAbs(swing_point[total_swing_pt - j] - A_pt) >= imp_mean)
               {
                  X_pt = swing_point[total_swing_pt - j];
                  X_dt = sDateTime[total_swing_pt - j];
                  break;
               }
            }

            XA_10pc = MathAbs(A_pt - X_pt) * 0.1;
            ME = MathMax(XA_10pc, AB_20pc);
            is_A_Vtop = (A_pt > X_pt);
            A_pos = i;
         }
         if(total_swing_pt - i - 1 >= 0 && swing_point[total_swing_pt - i - 1] > A_pt
            && swing_point[total_swing_pt - i] < A_pt - ME
            && swing_point[total_swing_pt - i] <= A_Min && sDateTime[total_swing_pt - i] < sp_dt)
         {
            A_pt = swing_point[total_swing_pt - i];
            A_dt = sDateTime[total_swing_pt - i];

            for(j = i - 1; j >= 0; j -= 2)
            {
               if(MathAbs(swing_point[total_swing_pt - j] - A_pt) >= imp_mean)
               {
                  X_pt = swing_point[total_swing_pt - j];
                  X_dt = sDateTime[total_swing_pt - j];
                  break;
               }
            }

            XA_10pc = MathAbs(A_pt - X_pt) * 0.1;
            ME = MathMax(XA_10pc, AB_20pc);
            is_A_Vtop = (A_pt > X_pt);
            A_pos = i;
         }
      }
   }

   add_XABC_swing_pt(X_pt, X_dt);
   add_XABC_swing_pt(A_pt, A_dt);

   if(A_pos != 2)
   {
      B_pt = swing_point[total_swing_pt - (A_pos + 1)];
      B_dt = sDateTime[total_swing_pt - (A_pos + 1)];
      B_pos = A_pos + 1;

      AB_20pc = MathAbs(B_pt - A_pt) * 0.2;
      ME = MathMax(XA_10pc, AB_20pc);
      is_B_Vtop = (B_pt > A_pt);
   }

   B_Max = B_pt; B_Min = B_pt;

   for(i = B_pos + 2; i < total_swing_pt; i += 2)
   {
      if(is_B_Vtop)
      {
         B_Max = MathMax(B_Max, swing_point[total_swing_pt - i]);
         if(swing_point[total_swing_pt - i] >= B_pt && swing_point[total_swing_pt - i] <= B_pt + ME
            && swing_point[total_swing_pt - i] >= B_Max && sDateTime[total_swing_pt - i] < sp_dt)
         {
            B_pt = swing_point[total_swing_pt - i];
            B_dt = sDateTime[total_swing_pt - i];
            B_pos = i;

            AB_20pc = MathAbs(B_pt - A_pt) * 0.2;
            ME = MathMax(XA_10pc, AB_20pc);
            is_B_Vtop = (B_pt > A_pt);
         }
         if(total_swing_pt - i - 1 >= 0 && swing_point[total_swing_pt - i - 1] < B_pt
            && swing_point[total_swing_pt - i] > B_pt + ME
            && swing_point[total_swing_pt - i] >= B_Max && sDateTime[total_swing_pt - i] < sp_dt)
         {
            B_pt = swing_point[total_swing_pt - i];
            B_dt = sDateTime[total_swing_pt - i];
            B_pos = i;

            AB_20pc = MathAbs(B_pt - A_pt) * 0.2;
            ME = MathMax(XA_10pc, AB_20pc);
            is_B_Vtop = (B_pt > A_pt);
         }
      }
      else
      {
         B_Min = MathMin(B_Min, swing_point[total_swing_pt - i]);
         if(swing_point[total_swing_pt - i] <= B_pt && swing_point[total_swing_pt - i] >= B_pt - ME
            && swing_point[total_swing_pt - i] <= B_Min && sDateTime[total_swing_pt - i] < sp_dt)
         {
            B_pt = swing_point[total_swing_pt - i];
            B_dt = sDateTime[total_swing_pt - i];
            B_pos = i;

            AB_20pc = MathAbs(B_pt - A_pt) * 0.2;
            ME = MathMax(XA_10pc, AB_20pc);
            is_B_Vtop = (B_pt > A_pt);
         }
         if(total_swing_pt - i - 1 >= 0 && swing_point[total_swing_pt - i - 1] > B_pt
            && swing_point[total_swing_pt - i] < B_pt - ME
            && swing_point[total_swing_pt - i] <= B_Min && sDateTime[total_swing_pt - i] < sp_dt)
         {
            B_pt = swing_point[total_swing_pt - i];
            B_dt = sDateTime[total_swing_pt - i];
            B_pos = i;

            AB_20pc = MathAbs(B_pt - A_pt) * 0.2;
            ME = MathMax(XA_10pc, AB_20pc);
            is_B_Vtop = (B_pt > A_pt);
         }
      }
   }

   add_XABC_swing_pt(B_pt, B_dt);

   for(i = B_pos + 1; i <= total_swing_pt; i++)
      add_XABC_swing_pt(swing_point[total_swing_pt - i], sDateTime[total_swing_pt - i]);
}

string get_XABC_label(int num)
{
   string str = "";
   string labels_1[] = {"X", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                        "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
   string labels[] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                      "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

   if(num < 27)
      str = labels_1[num];
   else
   {
      int n = num - 1, m, r;
      while(n > 0)
      {
         m = n;
         n = m / 26;
         r = m % 26;
         if(n == 0)
            str = labels[r - 1] + str;
         else
            str = labels[r] + str;
      }
   }
   return str;
}

void show_XABC(const datetime &time[], int rates_total)
{
   string strlabel;
   double sp, pos, X_pt, A_pt, B_pt, C_pt, ME, XA_10pc, AB_20pc, ABdiv8;
   datetime A_dt, B_dt, C_dt;
   int A_bar, B_bar, C_bar;
   int i, align;

   ArrayInitialize(XABC, 0);

   clear_XABC_signals();

   for(i = 0; i < total_XABC_swing_pt; i++)
   {
      strlabel = "XABC_label_" + IntegerToString(i);

      if(i == total_XABC_swing_pt - 1)
         sp = (XABC_swing_point[i] > XABC_swing_point[i - 1]) ? imean[0] * 0.2 : -(imean[0] * 0.1);
      else
         sp = (XABC_swing_point[i] > XABC_swing_point[i + 1]) ? imean[0] * 0.2 : -(imean[0] * 0.1);

      pos = XABC_swing_point[i] + sp;

      ObjectCreate(0, strlabel, OBJ_TEXT, 0, XABC_DateTime[i], pos);
      ObjectSetString(0, strlabel, OBJPROP_TEXT, get_XABC_label(i));
      ObjectSetInteger(0, strlabel, OBJPROP_FONTSIZE, XABC_font_size);
      ObjectSetString(0, strlabel, OBJPROP_FONT, XABC_font);
      ObjectSetInteger(0, strlabel, OBJPROP_COLOR, XABC_font_color);
      num_label++;

      int n = custom_iBarShift(_Symbol, PERIOD_CURRENT, XABC_DateTime[i]);
      if(n >= 0 && n < rates_total) XABC[n] = XABC_swing_point[i];
   }

   X_pt = XABC_swing_point[0];
   A_pt = XABC_swing_point[1];
   A_dt = XABC_DateTime[1];
   B_pt = XABC_swing_point[2];
   B_dt = XABC_DateTime[2];
   C_pt = XABC_swing_point[3];
   C_dt = XABC_DateTime[3];

   A_bar = custom_iBarShift(_Symbol, PERIOD_CURRENT, A_dt);
   B_bar = custom_iBarShift(_Symbol, PERIOD_CURRENT, B_dt);
   C_bar = custom_iBarShift(_Symbol, PERIOD_CURRENT, C_dt);

   XA_10pc = MathAbs(A_pt - X_pt) * 0.1;
   AB_20pc = MathAbs(B_pt - A_pt) * 0.2;
   ABdiv8 = MathAbs(A_pt - B_pt) / 8;

   align = (int)(rates_total * 0.1);

   if(X_pt < A_pt)
   {
      ME = MathMax(XA_10pc, AB_20pc);
      ObjectCreate(0, "XABC_PSZ", OBJ_TREND, 0, A_dt, A_pt - ABdiv8, time[0], A_pt - ABdiv8);
      ObjectCreate(0, "XABC_PSZ_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, A_pt - ABdiv8);
      ObjectCreate(0, "XABC_PBZ", OBJ_TREND, 0, B_dt, B_pt + ABdiv8, time[0], B_pt + ABdiv8);
      ObjectCreate(0, "XABC_PBZ_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, B_pt + ABdiv8);
      ObjectSetString(0, "XABC_PSZ_Label", OBJPROP_TEXT, "Primary Sell Zone @" + DoubleToString(A_pt - ABdiv8, _Digits));
      ObjectSetString(0, "XABC_PBZ_Label", OBJPROP_TEXT, "Primary Buy Zone @" + DoubleToString(B_pt + ABdiv8, _Digits));
      pop_XABC_signals(X_pt, A_pt, A_bar, B_pt, B_bar, C_pt, C_bar, A_pt + ME, B_pt - ME, B_pt + ABdiv8, A_pt - ABdiv8, total_XABC_swing_pt);
   }
   else
   {
      ME = -MathMax(XA_10pc, AB_20pc);
      ObjectCreate(0, "XABC_PBZ", OBJ_TREND, 0, A_dt, A_pt + ABdiv8, time[0], A_pt + ABdiv8);
      ObjectCreate(0, "XABC_PBZ_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, A_pt + ABdiv8);
      ObjectCreate(0, "XABC_PSZ", OBJ_TREND, 0, B_dt, B_pt - ABdiv8, time[0], B_pt - ABdiv8);
      ObjectCreate(0, "XABC_PSZ_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, B_pt - ABdiv8);
      ObjectSetString(0, "XABC_PSZ_Label", OBJPROP_TEXT, "Primary Sell Zone @" + DoubleToString(B_pt - ABdiv8, _Digits));
      ObjectSetString(0, "XABC_PBZ_Label", OBJPROP_TEXT, "Primary Buy Zone @" + DoubleToString(A_pt + ABdiv8, _Digits));
      pop_XABC_signals(X_pt, A_pt, A_bar, B_pt, B_bar, C_pt, C_bar, B_pt - ME, A_pt + ME, A_pt + ABdiv8, B_pt - ABdiv8, total_XABC_swing_pt);
   }

   ObjectCreate(0, "XABC_A", OBJ_TREND, 0, A_dt, A_pt, time[0], A_pt);
   ObjectCreate(0, "XABC_A_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, A_pt);
   ObjectSetString(0, "XABC_A_Label", OBJPROP_TEXT, "A Boundary @" + DoubleToString(A_pt, _Digits));

   ObjectCreate(0, "XABC_A_ME", OBJ_TREND, 0, A_dt, A_pt + ME, time[0], A_pt + ME);
   ObjectCreate(0, "XABC_A_ME_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, A_pt + ME);
   ObjectSetString(0, "XABC_A_ME_Label", OBJPROP_TEXT, "Maximum Extension @" + DoubleToString(A_pt + ME, _Digits));

   ObjectCreate(0, "XABC_B", OBJ_TREND, 0, B_dt, B_pt, time[0], B_pt);
   ObjectCreate(0, "XABC_B_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, B_pt);
   ObjectSetString(0, "XABC_B_Label", OBJPROP_TEXT, "B Boundary @" + DoubleToString(B_pt, _Digits));

   ObjectCreate(0, "XABC_B_ME", OBJ_TREND, 0, B_dt, B_pt - ME, time[0], B_pt - ME);
   ObjectCreate(0, "XABC_B_ME_Label", OBJ_TEXT, 0, time[0] + PeriodSeconds() * align, B_pt - ME);
   ObjectSetString(0, "XABC_B_ME_Label", OBJPROP_TEXT, "Maximum Extension @" + DoubleToString(B_pt - ME, _Digits));

   // Set object properties
   string objects[] = {"XABC_PSZ", "XABC_PBZ", "XABC_A", "XABC_B", "XABC_A_ME", "XABC_B_ME"};
   for(int k = 0; k < ArraySize(objects); k++)
   {
      ObjectSetInteger(0, objects[k], OBJPROP_COLOR, XABC_ME_line_color);
      ObjectSetInteger(0, objects[k], OBJPROP_STYLE, STYLE_DOT);
   }

   string labels[] = {"XABC_PSZ_Label", "XABC_PBZ_Label", "XABC_A_Label", "XABC_A_ME_Label", "XABC_B_Label", "XABC_B_ME_Label"};
   for(int k = 0; k < ArraySize(labels); k++)
   {
      ObjectSetInteger(0, labels[k], OBJPROP_COLOR, XABC_ME_line_color);
      ObjectSetInteger(0, labels[k], OBJPROP_FONTSIZE, 8);
      ObjectSetString(0, labels[k], OBJPROP_FONT, XABC_font);
   }
}

void pop_XABC_signals(double X_pt, double A_pt, int A_pt_bar, double B_pt, int B_pt_bar, double C_pt, int C_pt_bar,
                      double upper_me, double lower_me, double pbz, double psz, int count)
{
   double XA_height = MathAbs(X_pt - A_pt);
   double AB_height = MathAbs(A_pt - B_pt);

   if(AB_height > XA_height)
   {
      ArrayInitialize(signals, 0);
   }
   else
   {
      signals[XABC_A] = A_pt;
      signals[XABC_B] = B_pt;
      signals[XABC_C] = C_pt;
      signals[XABC_A_BAR] = A_pt_bar;
      signals[XABC_B_BAR] = B_pt_bar;
      signals[XABC_C_BAR] = C_pt_bar;
      signals[XABC_UPPER_ME] = upper_me;
      signals[XABC_LOWER_ME] = lower_me;
      signals[XABC_PBZ] = pbz;
      signals[XABC_PSZ] = psz;
      signals[XABC_SWING_COUNT] = count;
   }
}

void clear_XABC_signals()
{
   ArrayInitialize(signals, 0);
}

void catch_swing_pt(const datetime &time[], int rates_total)
{
   double imp_mean = imean[0];
   double sw_pt_1 = 0, sw_pt_2 = 0;
   int count = 0, i = 0;

   while((count <= 3 || MathAbs(sw_pt_1 - sw_pt_2) < imp_mean) && i < rates_total)
   {
      if(dn_swing[i] > 0)
      {
         if(sw_pt_1 == 0)
         {
            sw_pt_1 = sw_pt_2 = dn_swing[i];
            add_swing_pt(sw_pt_1, time[i]);
            count++;
         }
         else
         {
            sw_pt_2 = sw_pt_1;
            sw_pt_1 = dn_swing[i];
            add_swing_pt(sw_pt_1, time[i]);
            count++;
         }
      }
      i++;
   }
}

void catch_swing_pt_ex(const datetime &time[], int rates_total)
{
   int spt = custom_iBarShift(_Symbol, PERIOD_CURRENT, XABC_spec_time);
   double imp_mean = imean[spt];
   double sw_pt_1 = 0, sw_pt_2 = 0;
   datetime pt_1_dt = 0, pt_2_dt = 0; // Inizializzazione delle variabili
   int count = 0, i = 0;
   bool imp_mean_hit = false;

   while(!imp_mean_hit && i < rates_total)
   {
      if(dn_swing[i] > 0)
      {
         if(sw_pt_1 == 0)
         {
            sw_pt_1 = sw_pt_2 = dn_swing[i];
            pt_1_dt = pt_2_dt = time[i];
            add_swing_pt(sw_pt_1, pt_1_dt);
            if(i > spt) count++;
         }
         else
         {
            sw_pt_2 = sw_pt_1;
            pt_2_dt = pt_1_dt;
            sw_pt_1 = dn_swing[i];
            pt_1_dt = time[i];
            add_swing_pt(sw_pt_1, pt_1_dt);
            if(i > spt) count++;
         }
      }
      if(MathAbs(sw_pt_1 - sw_pt_2) >= imp_mean && pt_2_dt < XABC_spec_time) imp_mean_hit = true;
      i++;
   }
}

void clear_label()
{
   for(int i = 0; i <= num_label; i++)
      ObjectDelete(0, "XABC_label_" + IntegerToString(i));

   string objects[] = {"XABC_A", "XABC_A_ME", "XABC_B", "XABC_B_ME", "XABC_PBZ", "XABC_PSZ",
                       "XABC_A_Label", "XABC_B_Label", "XABC_A_ME_Label", "XABC_B_ME_Label",
                       "XABC_PBZ_Label", "XABC_PSZ_Label"};
   for(int i = 0; i < ArraySize(objects); i++)
      ObjectDelete(0, objects[i]);
}

int add_swing_pt(double pt, datetime dt)
{
   total_swing_pt++;
   if(ArrayResize(sDateTime, total_swing_pt) == -1 || ArrayResize(swing_point, total_swing_pt) == -1)
      return -1;
   sDateTime[total_swing_pt - 1] = dt;
   swing_point[total_swing_pt - 1] = pt;
   return 0;
}

int clear_swing_pts()
{
   total_swing_pt = 0;
   if(ArrayResize(sDateTime, 0) == -1 || ArrayResize(swing_point, 0) == -1)
      return -1;
   return 0;
}

int add_XABC_swing_pt(double pt, datetime dt)
{
   total_XABC_swing_pt++;
   if(ArrayResize(XABC_DateTime, total_XABC_swing_pt) == -1 || ArrayResize(XABC_swing_point, total_XABC_swing_pt) == -1)
      return -1;
   XABC_DateTime[total_XABC_swing_pt - 1] = dt;
   XABC_swing_point[total_XABC_swing_pt - 1] = pt;
   return 0;
}

int clear_XABC_swing_pts()
{
   total_XABC_swing_pt = 0;
   if(ArrayResize(XABC_DateTime, 0) == -1 || ArrayResize(XABC_swing_point, 0) == -1)
      return -1;
   return 0;
}

// Helper function for bar shift in MT5
int custom_iBarShift(string symbol, ENUM_TIMEFRAMES timeframe, datetime time)
{
   int shift = 0;
   datetime times[];
   if(CopyTime(symbol, timeframe, 0, Bars(symbol, timeframe), times) > 0)
   {
      ArraySetAsSeries(times, true);
      for(int i = 0; i < ArraySize(times); i++)
      {
         if(times[i] <= time)
         {
            shift = i;
            break;
         }
      }
   }
   return shift;
}
//+------------------------------------------------------------------+