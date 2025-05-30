//--- descrizione 
#property description "Lo script disegna l'oggetto grafico \"Linea di Gann\" ." 
#property description "Le coordinate del punto di ancoraggio sono impostate in percentuale" 
#property description " della grandezza della finestra chart." 
//--- mostra la finestra dei parametri di input durante il lancio dello script 
#property script_show_inputs 
//--- parametri di input dello script 
input string          InpName="GannLine";        // Nome della Linea 
input int             InpDate1=20;               // data del 1mo punto, % 
input int             InpPrice1=75;              // prezzo del 1mo punto, % 
input int             InpDate2=80;               // data del 2ndo punto, % 
input double          InpAngle=0.0;              // Angolo di Gann 
input double          InpScale=1.0;              // Scala 
input color           InpColor=clrRed;           // Colore della linea 
input ENUM_LINE_STYLE InpStyle=STYLE_DASHDOTDOT; // Stile della linea 
input int             InpWidth=2;                // Spessore della linea 
input bool            InpBack=false;             // Linea di sottofondo 
input bool            InpSelection=true;         // Evidenzia movimento 
input bool            InpRayLeft=false;          // Continuazione del canale a sinistra 
input bool            InpRayRight=true;          // Continuazione del canale a destra 
input bool            InpHidden=true;            // Nascosto nella lista oggetti 
input long            InpZOrder=0;               // Priorità per il click del mouse 
//+--------------------------------------------------------------------------------+ 
//| Crea la Linea di Gann dalle coordinate fornite | 
//+--------------------------------------------------------------------------------+ 
bool GannLineCreate(const long            chart_ID=0,        // ID del chart 
                    const string          name="GannLine",   // nome della linea 
                    const int             sub_window=0,      // indice sottofinestra 
                    datetime              time1=0,           // orario del primo punto 
                    double                price1=0,          // prezzo del primo punto 
                    datetime              time2=0,           // orario del secondo punto 
                    const double          angle=1.0,         // Angolo di Gann 
                    const double          scale=1.0,         // scala 
                    const color           clr=clrRed,        // Colore della linea 
                    const ENUM_LINE_STYLE style=STYLE_SOLID, // stile della linea 
                    const int             width=1,           // spessore della linea 
                    const bool            back=false,        // in sottofondo 
                    const bool            selection=true,    // evidenzia movimento 
                    const bool            ray_left=false,    // continuazione della linea a sinistra 
                    const bool            ray_right=false,   // continuazione della linea a destra 
                    const bool            hidden=true,       // nascosta nella lista oggetti 
                    const long            z_order=0)         // priorità per il click del mouse 
  { 
//--- imposta coordinate punto di ancoraggio se non sono impostate 
   ChangeGannLineEmptyPoints(time1,price1,time2); 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- crea la Linea di Gann dalle coordinate date 
//--- le giuste coordinate del secondo punto di ancoraggio vengono ridefinite 
//--- automaticamente dopo l'angolo di Gann e/o i cambiamenti della scala, 
   if(!ObjectCreate(chart_ID,name,OBJ_GANNLINE,sub_window,time1,price1,time2,0)) 
     { 
      Print(__FUNCTION__, 
            ": fallimento nel creare la \"Linea di Gann\"! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- cambia l'angolo di Gann 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
//--- cambia la scala (numero di pips per barra) 
   ObjectSetDouble(chart_ID,name,OBJPROP_SCALE,scale); 
//--- imposta colore della linea 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- imposta lo stile della linea 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- larghezza della linea 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- mostra in primo piano (false) o sottofondo (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- abilita (true) o disabilita (false) la modalità di evidenziazione delle linee per il loro spostamento 
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
//| Sposta i punti di ancoraggio della Linea di Gann                               | 
//+--------------------------------------------------------------------------------+ 
bool GannLinePointChange(const long   chart_ID=0,      // ID del chart 
                       const string name="GannLine", // nome della linea 
                       const int    point_index=0, // indice del punto di ancoraggio 
                  datetime     time=0,          // coordinate tempo, del punto di ancoraggio 
                         double       price=0)           // coordinate di prezzo del punto di ancoraggio 
  { 
//--- se il punto della posizione non è impostato, spostarlo nella barra corrente che ha il prezzo Bid 
   if(!time) 
      time=TimeCurrent(); 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- sposta il punto di ancoraggio della linea 
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
//| Cambia l'angolo di Gann                                                        | 
//+--------------------------------------------------------------------------------+ 
bool GannLineAngleChange(const long   chart_ID=0,      // ID del chart 
                       const string name="GannLine", // nome della linea 
                         const double angle=1.0)       // Angolo di Gann 
  { 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- cambia l'angolo di Gann 
   if(!ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle)) 
     { 
      Print(__FUNCTION__, 
            ": fallimento nel cambiare l'angolo di Gann! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- esecuzione avvenuta 
   return(true); 
  } 
//+--------------------------------------------------------------------------------+ 
//| Cambia la scala della Linea di Gann                                            | 
//+--------------------------------------------------------------------------------+ 
bool GannLineScaleChange(const long   chart_ID=0,      // ID del chart 
                       const string name="GannLine", // nome della linea 
                         const double scale=1.0)       // scala 
  { 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- cambia la scala (numero di pips per barra) 
   if(!ObjectSetDouble(chart_ID,name,OBJPROP_SCALE,scale)) 
     { 
      Print(__FUNCTION__, 
            ": fallimento nel cambiare la scala! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- esecuzione avvenuta 
   return(true); 
  } 
//+--------------------------------------------------------------------------------+ 
//| La funzione rimuove La Linea di Gann dal chart                                 | 
//+--------------------------------------------------------------------------------+ 
bool GannLineDelete(const long   chart_ID=0,      // ID del chart 
                    const string name="GannLine") // nome della linea 
  { 
//--- resetta il valore dell' errore 
   ResetLastError(); 
//--- elimina la linea di Gann 
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": fallimento nell'eliminare la \"Linea di Gann\"! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- esecuzione avvenuta 
   return(true); 
  } 
//+--------------------------------------------------------------------------------+ 
//| Controlla i valori dei punti di ancoraggio della Griglia di Gann ed imposta i  | 
//| valori di default per quelli vuoti                                             | 
//+--------------------------------------------------------------------------------+ 
void ChangeGannLineEmptyPoints(datetime &time1,double &price1,datetime &time2) 
  { 
//--- se l'orario del secondo punto non è impostato, sarà sulla barra corrente 
   if(!time2) 
      time2=TimeCurrent(); 
//--- se l'orario del primo punto non è impostato, è posizionato 9 barre meno dalla seconda 
   if(!time1) 
     { 
      //--- array per la ricezione dell'orario di apertura delle ultime 10 barre 
      datetime temp[10]; 
      CopyTime(Symbol(),Period(),time2,10,temp); 
      //--- imposta il primo punto 9 barre a sinistra dalla seconda 
      time1=temp[0]; 
     } 
//--- se il prezzo del punto non è impostato, avrà un valore Bid 
   if(!price1) 
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
  } 
//+--------------------------------------------------------------------------------+ 
//| Funzione di avvio del programma Script                                         | 
//+--------------------------------------------------------------------------------+ 
void OnStart() 
  { 
//--- imposta la correttezza dei parametri di input 
   if(InpDate1<0 || InpDate1>100 || InpPrice1<0 || InpPrice1>100 ||  
      InpDate2<0 || InpDate2>100) 
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
//--- definisce i punti per disegnare la Linea di Gann 
   int d1=InpDate1*(bars-1)/100; 
   int d2=InpDate2*(bars-1)/100; 
   int p1=InpPrice1*(accuracy-1)/100; 
//--- crea la Linea di Gann 
   if(!GannLineCreate(0,InpName,0,date[d1],price[p1],date[d2],InpAngle,InpScale,InpColor, 
      InpStyle,InpWidth,InpBack,InpSelection,InpRayLeft,InpRayRight,InpHidden,InpZOrder)) 
     { 
      return; 
     } 
//--- redisegna il chart ed attende per 1 secondo 
   ChartRedraw(); 
   Sleep(1000); 
//--- ora, sposta il punto di ancoraggio della linea e cambia l'angolo 
//---contatore del ciclo 
   int v_steps=accuracy/2; 
//--- sposta il primo punto di ancoraggio, verticalmente 
   for(int i=0;i<v_steps;i++) 
     { 
      //--- usa il seguente valore 
      if(p1>1) 
         p1-=1; 
      //--- sposta il punto 
      if(!GannLinePointChange(0,InpName,0,date[d1],price[p1])) 
         return; 
      //--- controlla se l'operazione dello script è stata disabilitata per forza 
      if(IsStopped()) 
         return; 
      //--- ridisegna il chart 
      ChartRedraw(); 
     } 
//--- ritardo di mezzo secondo 
   Sleep(500); 
//--- definisce il corrente valore dell'angolo di Gann (cambiato 
//--- dopo aver spostato il primo punto di ancoraggio) 
   double curr_angle; 
   if(!ObjectGetDouble(0,InpName,OBJPROP_ANGLE,0,curr_angle)) 
      return; 
//---contatore del ciclo 
   v_steps=accuracy/8; 
//--- cambia l'angolo di Gann 
   for(int i=0;i<v_steps;i++) 
     { 
      if(!GannLineAngleChange(0,InpName,curr_angle-0.05*i)) 
         return; 
      //--- controlla se l'operazione dello script è stata disabilitata per forza 
      if(IsStopped()) 
         return; 
      //--- ridisegna il chart 
      ChartRedraw(); 
     } 
//--- 1 secondo di ritardo 
   Sleep(1000); 
//--- elimina la linea dal chart 
   GannLineDelete(0,InpName); 
   ChartRedraw(); 
//--- 1 secondo di ritardo 
   Sleep(1000); 
//--- 
  }