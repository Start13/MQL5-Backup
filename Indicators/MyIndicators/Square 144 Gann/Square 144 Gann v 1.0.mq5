// Conversione dell'indicatore "Gann Square of 144" da Pine Script a MQL5
// Autore: [Tuo Nome]
// Versione: 1.0

#property indicator_chart_window

#include <ChartObjects/ChartObjectsTxtControls.mqh>
#include <ChartObjects/ChartObjectsLines.mqh>
#include <ChartObjects/ChartObjectsShapes.mqh>

input datetime startDate = D'2022.11.01 00:00';
input double maxPrice = 69198.0;
input double minPrice = 17595.0;
input bool autoPricesAndBar = true;
input bool updateNewBar = true;
input int candlesPerDivision = 1;
input bool showTopXAxis = false;
input bool showBottomXAxis = true;
input bool showLeftYAxis = false;
input bool showRightYAxis = true;
input bool showPrices = true;
input bool showDivisions = true;
input bool showExtraLines = true;
input bool showGrid = true;
input bool showBackground = true;

// Variabili globali
int squares = 144;
double lowerPrice, upperPrice, middlePrice, onethirdPrice;
int startBarIndex, endBarIndex, middleBarIndex;

// Funzione per inizializzare il Gann Square
void InitGannSquare()
{
    int totalBars = iBars(Symbol(), 0);
    startBarIndex = autoPricesAndBar ? totalBars - (squares * candlesPerDivision / 2) : 0;
    endBarIndex = startBarIndex + squares * candlesPerDivision;
    middleBarIndex = startBarIndex + (squares * candlesPerDivision / 2);

    lowerPrice = autoPricesAndBar ? iLow(Symbol(), 0, totalBars-1) : minPrice;
    upperPrice = autoPricesAndBar ? iHigh(Symbol(), 0, totalBars-1) : maxPrice;
    middlePrice = lowerPrice + (upperPrice - lowerPrice) / 2;
    onethirdPrice = (upperPrice - lowerPrice) / 3;
}

// Funzione per disegnare il Gann Square
void DrawGannSquare()
{
    for (int i = 0; i < squares; i += 6)
    {
        int x = startBarIndex + (i * candlesPerDivision);
        double y = upperPrice - ((upperPrice - lowerPrice) / squares) * i;

        if (showGrid)
        {
            ObjectCreate(0, "Grid_Vertical_"+IntegerToString(i), OBJ_VLINE, 0, x, 0);
            ObjectCreate(0, "Grid_Horizontal_"+IntegerToString(i), OBJ_HLINE, 0, 0, y);
        }
    }
}

// Funzione OnCalculate per aggiornare l'indicatore
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &time[],
                const double &volume[],
                const long &spread[])
{
    if (updateNewBar)
    {
        InitGannSquare();
        DrawGannSquare();
    }
    return rates_total;
}

// Funzione OnInit per avviare l'indicatore
int OnInit()
{
    InitGannSquare();
    DrawGannSquare();
    return INIT_SUCCEEDED;
}
