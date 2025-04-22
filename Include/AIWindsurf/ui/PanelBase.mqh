//+------------------------------------------------------------------+
//|                                               PanelBase.mqh |
//|        Funzionalità di base per il pannello di OmniEA        |
//|        Supervisionato da AI Windsurf                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\Edit.mqh>
#include <AIWindsurf\common\Localization.mqh>

// Costanti per il pannello
#define PANEL_MARGIN        10
#define PANEL_HEADER_HEIGHT 30
#define PANEL_BUTTON_HEIGHT 25
#define PANEL_BUTTON_WIDTH  80
#define PANEL_SLOT_HEIGHT   25
#define PANEL_SECTION_MARGIN 5

// Enumerazione per le sezioni del pannello
enum ENUM_PANEL_SECTION
{
   PANEL_SECTION_INFO,      // Sezione informazioni
   PANEL_SECTION_BUY,       // Sezione segnali di acquisto
   PANEL_SECTION_SELL,      // Sezione segnali di vendita
   PANEL_SECTION_FILTER,    // Sezione filtri
   PANEL_SECTION_RISK,      // Sezione gestione rischio
   PANEL_SECTION_ACTIONS    // Sezione pulsanti di azione
};

//+------------------------------------------------------------------+
//| Classe base per il pannello di OmniEA                            |
//+------------------------------------------------------------------+
class CPanelBase
{
protected:
   string            m_prefix;          // Prefisso per gli oggetti del pannello
   int               m_x;               // Posizione X del pannello
   int               m_y;               // Posizione Y del pannello
   int               m_width;           // Larghezza del pannello
   int               m_height;          // Altezza del pannello
   color             m_bgColor;         // Colore di sfondo
   color             m_borderColor;     // Colore del bordo
   bool              m_isVisible;       // Visibilità del pannello
   string            m_eaName;          // Nome dell'EA
   int               m_version;         // Versione dell'EA
   
   // Colori per gli stati degli slot
   color             m_waitingColor;    // Colore per slot in attesa
   color             m_assignedColor;   // Colore per slot assegnati
   color             m_activeColor;     // Colore per slot attivi
   color             m_errorColor;      // Colore per slot con errori
   
   // Dimensioni delle sezioni
   int               m_infoHeight;      // Altezza sezione informazioni
   int               m_buyHeight;       // Altezza sezione segnali di acquisto
   int               m_sellHeight;      // Altezza sezione segnali di vendita
   int               m_filterHeight;    // Altezza sezione filtri
   int               m_riskHeight;      // Altezza sezione gestione rischio
   int               m_actionsHeight;   // Altezza sezione pulsanti di azione
   
   // Posizioni Y delle sezioni
   int               m_infoY;           // Posizione Y sezione informazioni
   int               m_buyY;            // Posizione Y sezione segnali di acquisto
   int               m_sellY;           // Posizione Y sezione segnali di vendita
   int               m_filterY;         // Posizione Y sezione filtri
   int               m_riskY;           // Posizione Y sezione gestione rischio
   int               m_actionsY;        // Posizione Y sezione pulsanti di azione
   
   // Notifica
   string            m_notificationText;// Testo della notifica
   color             m_notificationColor;// Colore della notifica
   datetime          m_notificationTime;// Timestamp della notifica
   
public:
   // Costruttore
   CPanelBase()
   {
      m_prefix = "BTT_Panel_";
      m_x = 20;
      m_y = 20;
      m_width = 700;
      m_height = 400;
      m_bgColor = clrDarkSlateGray;
      m_borderColor = clrBlack;
      m_isVisible = false;
      m_eaName = "OmniEA";
      m_version = 0;
      
      m_waitingColor = clrGold;         // Giallo per slot in attesa
      m_assignedColor = clrSteelBlue;   // Blu per slot assegnati
      m_activeColor = clrLimeGreen;     // Verde per slot attivi
      m_errorColor = clrCrimson;        // Rosso per slot con errori
      
      m_infoHeight = 80;
      m_buyHeight = 120;
      m_sellHeight = 120;
      m_filterHeight = 70;
      m_riskHeight = 50;
      m_actionsHeight = 35;
      
      m_notificationText = "";
      m_notificationColor = clrWhite;
      m_notificationTime = 0;
      
      CalculateSectionPositions();
   }
   
   // Calcola le posizioni Y delle sezioni
   void CalculateSectionPositions()
   {
      m_infoY = m_y + PANEL_HEADER_HEIGHT + PANEL_MARGIN;
      m_buyY = m_infoY + m_infoHeight + PANEL_SECTION_MARGIN;
      m_sellY = m_buyY + m_buyHeight + PANEL_SECTION_MARGIN;
      m_filterY = m_sellY + m_sellHeight + PANEL_SECTION_MARGIN;
      m_riskY = m_filterY + m_filterHeight + PANEL_SECTION_MARGIN;
      m_actionsY = m_riskY + m_riskHeight + PANEL_SECTION_MARGIN;
      
      // Aggiorna l'altezza totale del pannello
      m_height = m_actionsY + m_actionsHeight + PANEL_MARGIN;
   }
   
   // Crea un oggetto rettangolo
   void CreateRectangle(string name, int x, int y, int width, int height, color bgColor, color borderColor)
   {
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, borderColor);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   
   // Crea un'etichetta di testo
   void CreateLabel(string name, int x, int y, string text, color textColor = clrWhite, int fontSize = 8, string font = "Arial")
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
      ObjectSetString(0, name, OBJPROP_FONT, font);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   }
   
   // Crea un pulsante
   void CreateButton(string name, int x, int y, int width, int height, string text, color bgColor = clrSteelBlue, color textColor = clrWhite)
   {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
   }
   
   // Crea un campo di testo modificabile
   void CreateEdit(string name, int x, int y, int width, int height, string text, color bgColor = clrLightGray, color textColor = clrBlack)
   {
      ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
   }
   
   // Elimina tutti gli oggetti con un prefisso specifico
   void DeleteObjectsByPrefix(string prefix)
   {
      for(int i = ObjectsTotal(0) - 1; i >= 0; i--)
      {
         string name = ObjectName(0, i);
         if(StringSubstr(name, 0, StringLen(prefix)) == prefix)
         {
            ObjectDelete(0, name);
         }
      }
   }
   
   // Mostra una notifica
   void ShowNotification(string text, color textColor = clrWhite)
   {
      m_notificationText = text;
      m_notificationColor = textColor;
      m_notificationTime = TimeCurrent();
      
      // Aggiorna la visualizzazione della notifica
      if(m_isVisible)
      {
         string notificationName = m_prefix + "Notification";
         if(ObjectFind(0, notificationName) >= 0)
         {
            ObjectSetString(0, notificationName, OBJPROP_TEXT, text);
            ObjectSetInteger(0, notificationName, OBJPROP_COLOR, textColor);
         }
         else
         {
            CreateLabel(notificationName, m_x + m_width - 200, m_y + 7, text, textColor, 10);
         }
      }
   }
   
   // Ottiene la posizione Y di una sezione
   int GetSectionY(ENUM_PANEL_SECTION section)
   {
      switch(section)
      {
         case PANEL_SECTION_INFO:    return m_infoY;
         case PANEL_SECTION_BUY:     return m_buyY;
         case PANEL_SECTION_SELL:    return m_sellY;
         case PANEL_SECTION_FILTER:  return m_filterY;
         case PANEL_SECTION_RISK:    return m_riskY;
         case PANEL_SECTION_ACTIONS: return m_actionsY;
         default:                    return m_y;
      }
   }
   
   // Ottiene l'altezza di una sezione
   int GetSectionHeight(ENUM_PANEL_SECTION section)
   {
      switch(section)
      {
         case PANEL_SECTION_INFO:    return m_infoHeight;
         case PANEL_SECTION_BUY:     return m_buyHeight;
         case PANEL_SECTION_SELL:    return m_sellHeight;
         case PANEL_SECTION_FILTER:  return m_filterHeight;
         case PANEL_SECTION_RISK:    return m_riskHeight;
         case PANEL_SECTION_ACTIONS: return m_actionsHeight;
         default:                    return 0;
      }
   }
   
   // Imposta il nome dell'EA e la versione
   void SetEAInfo(string name, int version)
   {
      m_eaName = name;
      m_version = version;
   }
   
   // Verifica se il pannello è visibile
   bool IsVisible() const
   {
      return m_isVisible;
   }
};
