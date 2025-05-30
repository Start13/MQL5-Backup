//--- descrizione
#property description "Lo script disegna l'oggetto grafico \"Trend Line\"."
#property description "Le coordinate del punto di ancoraggio sono impostate in percentuale"
#property description " della grandezza della finestra chart."
//--- mostra la finestra dei parametri di input durante il lancio dello script
#property script_show_inputs
//--- parametri di input dello script
input string          InpName="Trend";     // Nome della linea
input int             InpDate1=35;         // Data del 1mo punto, in %
input int             InpPrice1=60;        // Prezzo del 1mo punto, in%
input int             InpDate2=65;         // data del 2ndo punto, %
input int             InpPrice2=40;        // Prezzo del 2ndo punto, in %
input color           InpColor=clrRed;     // Colore della Linea
input ENUM_LINE_STYLE InpStyle=STYLE_DASH; // Stile della linea
input int             InpWidth=2;          // Spessore linea
input bool            InpBack=false;       // Sottofondo linea
input bool            InpSelection=true;   // Evdenzia movimento
input bool            InpRayLeft=false;    // Continuazione della linea a sinistra
input bool            InpRayRight=false;   // Continuazione della linea a destra
input bool            InpHidden=true;      // Nascosto nella lista oggetti
input long            InpZOrder=0;         // Priorità per il click del mouse
//+--------------------------------------------------------------------------------+
//| Crea la trendline dalle coordinate fornite                                     |
//+--------------------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,        // ID del chart
                 const string          name="TrendLine",  // nome della linea
                 const int             sub_window=0,      // indice sottofinestra
                 datetime              time1=0,           // orario del primo punto
                 double                price1=0,          // prezzo del primo punto
                 datetime              time2=0,           // orario del secondo punto
                 double                price2=0,          // prezzo del secondo punto
                 const color           clr=clrRed,        // colore della linea
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // stile della linea
                 const int             width=1,           // spessore della linea
                 const bool            back=false,        // in sottofondo
                 const bool            selection=true,    // evidenzia movimento
                 const bool            ray_left=false,    // continuazione della linea sulla sinistra
                 const bool            ray_right=false,   // continuazione della linea sulla destra
                 const bool            hidden=true,       // nascosto nella lista oggetti
                 const long            z_order=0)         // priorità per il click del mouse
  {
//--- imposta coordinate punto di ancoraggio se non sono impostate
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
//--- resetta il valore dell' errore
   ResetLastError();
//--- crea una trend line delle coordinate fornite
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": fallimento nel creare una trend line! Error code = ",GetLastError());
      return(false);
     }
//--- imposta colore della linea
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- imposta lo stile della linea
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- larghezza della linea
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- mostra in primo piano (false) o sottofondo (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- abilitare (true) o disabilitare (false) il modo di spostare la linea con freccia, con il mouse
//--- quando si crea un oggetto grafico utilizzando la funzione ObjectCreate, l'oggetto non può esser
//--- evidenziato e mosso, per default. All'interno di questo metodo, la selezione dei parametri
//--- è true per default, il che consente di evidenziare e spostare l'oggetto
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- abilita (true) o disabilita (false) la modalità di continuazione della visualizzazione della linea sulla sinistra
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left);
//--- abilita (true) o disabilita (false) la modalità di continuazione della visualizzazione della linea sulla destra
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- nascondi (true) o mostra (falso) il nome di oggetto grafico nella lista degli oggetti
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- imposta la priorità per ricevere l'evento di un clic del mouse nel grafico
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- esecuzione avvenuta
   return(true);
  }
//+--------------------------------------------------------------------------------+
//| Sposta il punto di ancoraggio della trend line                                 |
//+--------------------------------------------------------------------------------+
bool TrendPointChange(const long   chart_ID=0,       // ID del chart
                      const string name="TrendLine", // nome dellal linea
                      const int    point_index=0,    // indice del punto di ancoraggio
                  datetime     time=0,          // coordinate tempo, del punto di ancoraggio 
                   double       price=0)          // coordinate prezzo, del punto di ancoraggio
  {
//--- se il punto della posizione non è impostato, spostarlo nella barra corrente che ha il prezzo Bid
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- resetta il valore dell' errore
   ResetLastError();
//--- sposta il punto di ancoraggio della trendline
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": fallimento nello spostare il punto di ancoraggio! Error code = ",GetLastError());
      return(false);
     }
//--- esecuzione avvenuta
   return(true);
  }
//+--------------------------------------------------------------------------------+
//| La funzione rimuove la trendline dal chart.                                    |
//+--------------------------------------------------------------------------------+
bool TrendDelete(const long   chart_ID=0,       // ID del chart
                 const string name="TrendLine") // nome della linea
  {
//--- resetta il valore dell' errore
   ResetLastError();
//--- elimina una trendline
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": fallimento nell'eliminare una trendline! Error code = ",GetLastError());
      return(false);
     }
//--- esecuzione avvenuta
   return(true);
  }
//+--------------------------------------------------------------------------------+
//| Controlla i valori dei punti di ancoraggio della trendline ed imposta i        |
//| valori di default per quelli vuoti                                             |
//+--------------------------------------------------------------------------------+
void ChangeTrendEmptyPoints(datetime &time1,double &price1,
                            datetime &time2,double &price2)
  {
//--- se l'orario del primo punto non è impostato, sarà sulla barra corrente
   if(!time1)
      time1=TimeCurrent();
//--- se il prezzo del punto non è impostato, avrà un valore Bid
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- se l'orario del secondo punto non è impostato, è posizionato 9 barre meno dalla seconda
   if(!time2)
     {
      //--- array per la ricezione dell'orario di apertura delle ultime 10 barre
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- imposta il secondo punto, 9 barre in meno dalla prima
      time2=temp[0];
     }
//--- se il prezzo del secondo punto non è impostato, è uguale a quello del primo punto
   if(!price2)
      price2=price1;
  }
//+--------------------------------------------------------------------------------+
//| Funzione di avvio del programma Script                                         |
//+--------------------------------------------------------------------------------+
void OnStart()
  {
//--- imposta la correttezza dei parametri di input
   if(InpDate1<0 || InpDate1>100 || InpPrice1<0 || InpPrice1>100 || 
      InpDate2<0 || InpDate2>100 || InpPrice2<0 || InpPrice2>100)
     {
      Print("Error! Valori non corretti dei parametri di input!");
      return;
     }
//--- Numero di barre visibili nella finestra del chart
   int bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);
//--- grandezza dell'array prezzo
   int accuracy=1000;
//--- array per la memorizzazione dei valori di data e prezzo da essere usati
//--- per impostare e cambiare i punti delle coordinate di ancoraggio della linea
   datetime date[];
   double   price[];
//--- allocazione della memoria
   ArrayResize(date,bars);
   ArrayResize(price,accuracy);
//--- riempie l'array delle date
   ResetLastError();
   if(CopyTime(Symbol(),Period(),0,bars,date)==-1)
     {
      Print("Fallimento nella copia dei valori tempo! Error code = ",GetLastError());
      return;
     }
//--- riempie l'array dei prezzi
//--- trova i valori più alti e più bassi del chart
   double max_price=ChartGetDouble(0,CHART_PRICE_MAX);
   double min_price=ChartGetDouble(0,CHART_PRICE_MIN);
//--- definisce un cambio di step del prezzo e riempie l'array
   double step=(max_price-min_price)/accuracy;
   for(int i=0;i<accuracy;i++)
      price[i]=min_price+i*step;
//--- definisce i punti per disegnare la linea
   int d1=InpDate1*(bars-1)/100;
   int d2=InpDate2*(bars-1)/100;
   int p1=InpPrice1*(accuracy-1)/100;
   int p2=InpPrice2*(accuracy-1)/100;
//--- crea una trend line
   if(!TrendCreate(0,InpName,0,date[d1],price[p1],date[d2],price[p2],InpColor,InpStyle,
      InpWidth,InpBack,InpSelection,InpRayLeft,InpRayRight,InpHidden,InpZOrder))
     {
      return;
     }
//--- redisegna il chart ed attende per 1 secondo
   ChartRedraw();
   Sleep(1000);
//--- ora, sposta i punti di ancoraggio della linea
//---contatore del ciclo
   int v_steps=accuracy/5;
//--- sposta il primo punto di ancoraggio, verticalmente
   for(int i=0;i<v_steps;i++)
     {
      //--- usa il seguente valore
      if(p1>1)
         p1-=1;
      //--- sposta il punto
      if(!TrendPointChange(0,InpName,0,date[d1],price[p1]))
         return;
      //--- controlla se l'operazione dello script è stata disabilitata per forza
      if(IsStopped())
         return;
      //--- ridisegna il chart
      ChartRedraw();
     }
//--- sposta il secondo punto di ancoraggio, verticalmente
   for(int i=0;i<v_steps;i++)
     {
      //--- usa il seguente valore
      if(p2<accuracy-1)
         p2+=1;
      //--- sposta il punto
      if(!TrendPointChange(0,InpName,1,date[d2],price[p2]))
         return;
      //--- controlla se l'operazione dello script è stata disabilitata per forza
      if(IsStopped())
         return;
      //--- ridisegna il chart
      ChartRedraw();
     }
//--- ritardo di mezzo secondo
   Sleep(500);
//---contatore del ciclo
   int h_steps=bars/2;
//--- sposta entrambi i punti di ancoraggio, orizzontalmente allo stesso orario
   for(int i=0;i<h_steps;i++)
     {
      //--- usa i seguenti valori
      if(d1<bars-1)
         d1+=1;
      if(d2>1)
         d2-=1;
      //--- slitta i punti
      if(!TrendPointChange(0,InpName,0,date[d1],price[p1]))
         return;
      if(!TrendPointChange(0,InpName,1,date[d2],price[p2]))
         return;
      //--- controlla se l'operazione dello script è stata disabilitata per forza
      if(IsStopped())
         return;
      //--- ridisegna il chart
      ChartRedraw();
      // 0.03 secondi di ritardo
      Sleep(30);
     }
//--- 1 secondo di ritardo
   Sleep(1000);
//--- elimina una trendline
   TrendDelete(0,InpName);
   ChartRedraw();
//--- 1 secondo di ritardo
   Sleep(1000);
//---
  }