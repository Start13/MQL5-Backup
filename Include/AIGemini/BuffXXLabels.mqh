//+------------------------------------------------------------------+
//|                                                BuffXXLabels.mqh |
//|                                       Copyright 2025, BlueTrendTeam |
//|                                       https://github.com/Start13/OmniEA-Lite-Gemini |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://github.com/Start13/OmniEA-Lite-Gemini"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Classe per la gestione delle etichette visive dei buffer          |
//+------------------------------------------------------------------+
class CBuffXXLabels
{
private:
   string            m_prefix;           // Prefisso per i nomi degli oggetti
   int               m_corner;           // Angolo del grafico per posizionare le etichette
   int               m_x_offset;         // Offset X iniziale
   int               m_y_offset;         // Offset Y iniziale
   int               m_y_step;           // Passo verticale tra le etichette
   int               m_font_size;        // Dimensione del font
   string            m_font_name;        // Nome del font
   color             m_default_color;    // Colore predefinito
   
   // Array di colori per diversi tipi di buffer
   color             m_buffer_colors[10];
   
   // Mappa dei nomi dei buffer
   string            m_buffer_names[10];
   
   // Contatore delle etichette create
   int               m_label_count;
   
public:
                     CBuffXXLabels();
                    ~CBuffXXLabels();
   
   // Inizializzazione
   void              Init(string prefix="BuffXX_", int corner=CORNER_RIGHT_UPPER, 
                         int x_offset=10, int y_offset=20, int y_step=20, 
                         int font_size=10, string font_name="Arial", 
                         color default_color=clrWhite);
   
   // Configurazione dei buffer
   void              SetBufferName(int buffer_index, string name);
   void              SetBufferColor(int buffer_index, color buffer_color);
   
   // Creazione e aggiornamento delle etichette
   bool              CreateLabel(int buffer_index, double value, string suffix="");
   bool              UpdateLabel(int buffer_index, double value, string suffix="");
   
   // Rimozione delle etichette
   void              RemoveAllLabels();
   bool              RemoveLabel(int buffer_index, string suffix="");
   
   // Formattazione del valore
   string            FormatValue(double value, int digits=2);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CBuffXXLabels::CBuffXXLabels()
{
   m_label_count = 0;
   
   // Inizializzazione dei colori predefiniti per i buffer
   m_buffer_colors[0] = clrBlue;       // Buffer principale
   m_buffer_colors[1] = clrRed;        // Segnale di vendita
   m_buffer_colors[2] = clrGreen;      // Segnale di acquisto
   m_buffer_colors[3] = clrYellow;     // Livello di supporto
   m_buffer_colors[4] = clrMagenta;    // Livello di resistenza
   m_buffer_colors[5] = clrCyan;       // Media mobile
   m_buffer_colors[6] = clrOrange;     // Oscillatore
   m_buffer_colors[7] = clrPurple;     // Volatilità
   m_buffer_colors[8] = clrBrown;      // Volume
   m_buffer_colors[9] = clrGray;       // Altri
   
   // Inizializzazione dei nomi predefiniti per i buffer
   m_buffer_names[0] = "Main";
   m_buffer_names[1] = "Sell";
   m_buffer_names[2] = "Buy";
   m_buffer_names[3] = "Support";
   m_buffer_names[4] = "Resistance";
   m_buffer_names[5] = "MA";
   m_buffer_names[6] = "Osc";
   m_buffer_names[7] = "Vol";
   m_buffer_names[8] = "Volume";
   m_buffer_names[9] = "Other";
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CBuffXXLabels::~CBuffXXLabels()
{
   RemoveAllLabels();
}

//+------------------------------------------------------------------+
//| Inizializzazione della classe                                    |
//+------------------------------------------------------------------+
void CBuffXXLabels::Init(string prefix="BuffXX_", int corner=CORNER_RIGHT_UPPER, 
                      int x_offset=10, int y_offset=20, int y_step=20, 
                      int font_size=10, string font_name="Arial", 
                      color default_color=clrWhite)
{
   m_prefix = prefix;
   m_corner = corner;
   m_x_offset = x_offset;
   m_y_offset = y_offset;
   m_y_step = y_step;
   m_font_size = font_size;
   m_font_name = font_name;
   m_default_color = default_color;
}

//+------------------------------------------------------------------+
//| Imposta il nome di un buffer                                     |
//+------------------------------------------------------------------+
void CBuffXXLabels::SetBufferName(int buffer_index, string name)
{
   if(buffer_index >= 0 && buffer_index < 10)
      m_buffer_names[buffer_index] = name;
}

//+------------------------------------------------------------------+
//| Imposta il colore di un buffer                                   |
//+------------------------------------------------------------------+
void CBuffXXLabels::SetBufferColor(int buffer_index, color buffer_color)
{
   if(buffer_index >= 0 && buffer_index < 10)
      m_buffer_colors[buffer_index] = buffer_color;
}

//+------------------------------------------------------------------+
//| Crea un'etichetta per un buffer                                  |
//+------------------------------------------------------------------+
bool CBuffXXLabels::CreateLabel(int buffer_index, double value, string suffix="")
{
   if(buffer_index < 0 || buffer_index >= 10)
      return false;
      
   string name = m_buffer_names[buffer_index];
   color clr = m_buffer_colors[buffer_index];
   
   string obj_name = m_prefix + IntegerToString(buffer_index) + "_" + name;
   if(suffix != "")
      obj_name += "_" + suffix;
   
   // Verifica se l'oggetto esiste già
   if(ObjectFind(0, obj_name) >= 0)
      return UpdateLabel(buffer_index, value, suffix);
   
   // Creazione dell'oggetto etichetta
   if(!ObjectCreate(0, obj_name, OBJ_LABEL, 0, 0, 0))
   {
      Print("Errore nella creazione dell'etichetta: ", GetLastError());
      return false;
   }
   
   // Calcolo della posizione Y
   int y_pos = m_y_offset + m_label_count * m_y_step;
   
   // Impostazione delle proprietà
   ObjectSetInteger(0, obj_name, OBJPROP_CORNER, m_corner);
   ObjectSetInteger(0, obj_name, OBJPROP_XDISTANCE, m_x_offset);
   ObjectSetInteger(0, obj_name, OBJPROP_YDISTANCE, y_pos);
   ObjectSetInteger(0, obj_name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, obj_name, OBJPROP_FONTSIZE, m_font_size);
   ObjectSetString(0, obj_name, OBJPROP_FONT, m_font_name);
   ObjectSetString(0, obj_name, OBJPROP_TEXT, "Buff " + IntegerToString(buffer_index) + " [" + name + "]: " + FormatValue(value));
   ObjectSetInteger(0, obj_name, OBJPROP_SELECTABLE, false);
   
   m_label_count++;
   return true;
}

//+------------------------------------------------------------------+
//| Aggiorna un'etichetta esistente                                  |
//+------------------------------------------------------------------+
bool CBuffXXLabels::UpdateLabel(int buffer_index, double value, string suffix="")
{
   if(buffer_index < 0 || buffer_index >= 10)
      return false;
      
   string name = m_buffer_names[buffer_index];
   
   string obj_name = m_prefix + IntegerToString(buffer_index) + "_" + name;
   if(suffix != "")
      obj_name += "_" + suffix;
   
   // Verifica se l'oggetto esiste
   if(ObjectFind(0, obj_name) < 0)
      return CreateLabel(buffer_index, value, suffix);
   
   // Aggiornamento del testo
   ObjectSetString(0, obj_name, OBJPROP_TEXT, "Buff " + IntegerToString(buffer_index) + " [" + name + "]: " + FormatValue(value));
   
   return true;
}

//+------------------------------------------------------------------+
//| Rimuove tutte le etichette                                       |
//+------------------------------------------------------------------+
void CBuffXXLabels::RemoveAllLabels()
{
   for(int i=ObjectsTotal(0, 0, OBJ_LABEL)-1; i>=0; i--)
   {
      string obj_name = ObjectName(0, i, 0, OBJ_LABEL);
      if(StringFind(obj_name, m_prefix) == 0)
         ObjectDelete(0, obj_name);
   }
   
   m_label_count = 0;
}

//+------------------------------------------------------------------+
//| Rimuove un'etichetta specifica                                   |
//+------------------------------------------------------------------+
bool CBuffXXLabels::RemoveLabel(int buffer_index, string suffix="")
{
   if(buffer_index < 0 || buffer_index >= 10)
      return false;
      
   string name = m_buffer_names[buffer_index];
   
   string obj_name = m_prefix + IntegerToString(buffer_index) + "_" + name;
   if(suffix != "")
      obj_name += "_" + suffix;
   
   // Verifica se l'oggetto esiste
   if(ObjectFind(0, obj_name) < 0)
      return false;
   
   // Rimozione dell'oggetto
   bool result = ObjectDelete(0, obj_name);
   if(result)
      m_label_count--;
      
   return result;
}

//+------------------------------------------------------------------+
//| Formatta un valore numerico                                      |
//+------------------------------------------------------------------+
string CBuffXXLabels::FormatValue(double value, int digits=2)
{
   return DoubleToString(value, digits);
}
