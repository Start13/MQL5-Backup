/*
//--------------------- Ts level by level -----------------------  
void TsLevByLev (const string &sniperStringg[],const double &valoriArrr[], const int&arrInpu[])
{
//arrInpu[2] compraSopra, valoriArr [3]  = primoLevBuy; valoriArr [4]  = secondoLevBuy; valoriArr [5]  = terzoLevBuy; valoriArr [6]  = quartoLevBuy; valoriArr [7]  = quintoLevBuy;
double a = (valoriArrr[3] - valoriArrr [2]);
if (PositionIsBuy())
{
if (PositionCurrentPrice() > PositionOpenPrice() && PositionCurrentPrice() > valoriArrr[3])
{
for (int i=1; i<=10; i++)
{
Print((NormalizeDouble ((valoriArrr[8] + (a * (i - 1))),Digits())));                                                //(NormalizeDouble ((arrInpu[2] - (a * (i - 1))),Digits()));

if (PositionCurrentPrice() > valoriArrr[2] + (a * i))continue;
if (PositionCurrentPrice() < valoriArrr[2] + (a * i) && PositionStopLoss() < valoriArrr[2] + (a * (i-1)))  
{PositionModify(PositionTicket(),(NormalizeDouble ((valoriArrr[2] + (a * (i - 1 - arrInpu[4]))),Digits())),PositionTakeProfit());return;}
}}}

 
if (PositionIsSell())
{
if (PositionCurrentPrice() < PositionOpenPrice() && PositionCurrentPrice() < valoriArrr[9])
{
for (int i=1; i<=10; i++)
{
Print((NormalizeDouble ((valoriArrr[8] - (a * (i - 1))),Digits())));

if (PositionCurrentPrice() < valoriArrr[8] - (a * i))continue;
if (PositionCurrentPrice() > valoriArrr[8] - (a * i) && PositionStopLoss() > valoriArrr[8] - (a * (i-1)))   
{PositionModify(PositionTicket(),(NormalizeDouble ((valoriArrr[8] - (a * (i -1 - arrInpu[4]))),Digits())),PositionTakeProfit());return;}
}
}
} 
}

/*
//--------------------- Ts level by level -----------------------  
void TsLevByLev (const string &sniperStringg[],const double &valoriArrr[], const int&arrInpu[])
{

char a = 0;
static char old_a = 0;

if (PositionIsBuy())
{
char a = (fasciaDiPrezzoP(PositionCurrentPrice(), true, sniperStringg, valoriArrr));
if (a != old_a)
old_a = a;
char b = fasciaDiPrezzoP(PositionCurrentPrice(), true, sniperStringg, valoriArrr);
int c = arrInpu [4];
Print(" b ",b);
double sl = (NormalizeDouble(DaFasciaLev_APrezzo (true, c , b , sniperStringg,valoriArrr),Digits()));
Print("sl: ",sl, " PositionTakeProfit(): ",PositionTakeProfit());
if (sl != 0 || sl > PositionStopLoss())

PositionModify(PositionTicket(),(NormalizeDouble(DaFasciaLev_APrezzo (true, c , b , sniperStringg,valoriArrr),Digits())),PositionTakeProfit()); return;  //////////////*********************
}

if (PositionIsSell())
{
char a = (fasciaDiPrezzoP(PositionCurrentPrice(), true, sniperStringg, valoriArrr));
if (a != old_a)
old_a = a;
char b = fasciaDiPrezzoP(PositionCurrentPrice(), true, sniperStringg, valoriArrr);
int c = arrInpu [4];
Print(" b ",b);
double sl = (NormalizeDouble(DaFasciaLev_APrezzo (true, c , b , sniperStringg,valoriArrr),Digits()));
Print("sl: ",sl, " PositionTakeProfit(): ",PositionTakeProfit());
if (sl != 0 || sl > PositionStopLoss())

PositionModify(PositionTicket(),(NormalizeDouble(DaFasciaLev_APrezzo (true, c , b , sniperStringg,valoriArrr),Digits())),PositionTakeProfit()); return;  //////////////*********************
}}
*/
