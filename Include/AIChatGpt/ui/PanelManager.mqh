// PanelManager.mqh
// Gestione dei pannelli dell'interfaccia utente
// Copyright 2025, BlueTrendTeam
#pragma once

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\Edit.mqh>
#include "..\common\UIUtils.mqh"

//+------------------------------------------------------------------+
//| Classe per la gestione del pannello principale                   |
//+------------------------------------------------------------------+
class CPanelManager
{
private:
   string            m_prefix;          // Prefisso per gli oggetti del pannello
   int               m_x;               // Posizione X del pannello
   int               m_y;               // Posizione Y del pannello
   int               m_width;           // Larghezza del pannello
   int               m_height;          // Altezza del pannello
   color             m_bgColor;         // Colore di sfondo
   color             m_borderColor;     // Colore del bordo
   bool              m_isVisible;       // Visibilità del pannello
   
   // Colori per gli stati degli slot
   color             m_waitingColor;    // Colore per slot in attesa
   color             m_assignedColor;   // Colore per slot assegnati
   color             m_errorColor;      // Colore per slot con errori
   
public:
   // Costruttore
   CPanelManager()
   {
      m_prefix = "BTT_Panel_";
      m_x = 20;
      m_y = 20;
      m_width = 700;
      m_height = 400;
      m_bgColor = clrDarkSlateGray;
      m_borderColor = clrBlack;
      m_isVisible = false;
      
      m_waitingColor = clrGold;         // Giallo per slot in attesa
      m_assignedColor = clrSteelBlue;   // Blu per slot assegnati
      m_errorColor = clrCrimson;        // Rosso per slot con errori
   }
   
   // Inizializzazione del pannello
   bool Initialize(string name = "OmniEA")
   {
      // Crea il pannello principale
      CreateRectangle(m_prefix + "Background", m_x, m_y, m_width, m_height, m_bgColor, m_borderColor);
      
      // Crea l'intestazione
      string title = name + " v1.0 by BTT";
      CreateRectangle(m_prefix + "Header", m_x, m_y, m_width, 30, clrRoyalBlue, m_borderColor);
      CreateLabel(m_prefix + "Title", m_x + 10, m_y + 7, title, clrWhite, 12);
      
      // Crea le sezioni
      CreateInfoSection();
      CreateBuySection();
      CreateSellSection();
      CreateFilterSection();
      CreateRiskSection();
      CreateActionButtons();
      
      m_isVisible = true;
      return true;
   }
   
   // Aggiornamento del pannello
   void Update()
   {
      if(!m_isVisible) return;
      
      // Aggiorna le informazioni
      UpdateInfoSection();
      
      // Aggiorna gli stati degli slot
      UpdateSlotStates();
   }
   
   // Pulizia del pannello
   void Cleanup()
   {
      DeleteObjectsByPrefix(m_prefix);
      m_isVisible = false;
   }
   
   // Gestione degli eventi del grafico
   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      // Gestione dei clic sui pulsanti
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         if(StringSubstr(sparam, 0, StringLen(m_prefix)) == m_prefix)
         {
            HandleButtonClick(sparam);
         }
      }
   }
   
private:
   // Crea la sezione informazioni
   void CreateInfoSection()
   {
      int sectionX = m_x + 10;
      int sectionY = m_y + 40;
      int sectionWidth = m_width - 20;
      int sectionHeight = 80;
      
      CreateRectangle(m_prefix + "InfoSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "InfoTitle", sectionX + 10, sectionY + 5, "Informazioni", clrWhite, 10);
      
      // Etichette per le informazioni
      string infoLabels[] = {"Broker:", "Account:", "Balance:", "Market:", "Spread:", "Time:", "Market Status:", "Time Trading:", "News Filter:"};
      for(int i = 0; i < ArraySize(infoLabels); i++)
      {
         int row = i / 3;
         int col = i % 3;
         CreateLabel(m_prefix + "InfoLabel" + IntegerToString(i), sectionX + 10 + col * 180, sectionY + 25 + row * 20, infoLabels[i], clrWhite, 8);
         CreateLabel(m_prefix + "InfoValue" + IntegerToString(i), sectionX + 70 + col * 180, sectionY + 25 + row * 20, "---", clrLightGray, 8);
      }
   }
   
   // Crea la sezione segnali di acquisto
   void CreateBuySection()
   {
      int sectionX = m_x + 10;
      int sectionY = m_y + 130;
      int sectionWidth = (m_width - 30) / 2;
      int sectionHeight = 120;
      
      CreateRectangle(m_prefix + "BuySection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "BuyTitle", sectionX + 10, sectionY + 5, "Segnali di Acquisto", clrLightGreen, 10);
      
      // Slot per gli indicatori
      for(int i = 0; i < 3; i++)
      {
         int slotX = sectionX + 10;
         int slotY = sectionY + 25 + i * 30;
         int slotWidth = sectionWidth - 20;
         int slotHeight = 25;
         
         CreateRectangle(m_prefix + "BuySlot" + IntegerToString(i), slotX, slotY, slotWidth, slotHeight, clrGray, m_borderColor);
         CreateLabel(m_prefix + "BuySlotText" + IntegerToString(i), slotX + 10, slotY + 5, "Trascina qui", clrWhite, 8);
      }
   }
   
   // Crea la sezione segnali di vendita
   void CreateSellSection()
   {
      int sectionX = m_x + m_width / 2 + 5;
      int sectionY = m_y + 130;
      int sectionWidth = (m_width - 30) / 2;
      int sectionHeight = 120;
      
      CreateRectangle(m_prefix + "SellSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "SellTitle", sectionX + 10, sectionY + 5, "Segnali di Vendita", clrLightCoral, 10);
      
      // Slot per gli indicatori
      for(int i = 0; i < 3; i++)
      {
         int slotX = sectionX + 10;
         int slotY = sectionY + 25 + i * 30;
         int slotWidth = sectionWidth - 20;
         int slotHeight = 25;
         
         CreateRectangle(m_prefix + "SellSlot" + IntegerToString(i), slotX, slotY, slotWidth, slotHeight, clrGray, m_borderColor);
         CreateLabel(m_prefix + "SellSlotText" + IntegerToString(i), slotX + 10, slotY + 5, "Trascina qui", clrWhite, 8);
      }
   }
   
   // Crea la sezione filtri
   void CreateFilterSection()
   {
      int sectionX = m_x + 10;
      int sectionY = m_y + 260;
      int sectionWidth = m_width - 20;
      int sectionHeight = 70;
      
      CreateRectangle(m_prefix + "FilterSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "FilterTitle", sectionX + 10, sectionY + 5, "Filtri", clrLightBlue, 10);
      
      // Slot per i filtri
      for(int i = 0; i < 2; i++)
      {
         int slotX = sectionX + 10 + i * (sectionWidth / 2 + 5);
         int slotY = sectionY + 25;
         int slotWidth = (sectionWidth - 30) / 2;
         int slotHeight = 25;
         
         CreateRectangle(m_prefix + "FilterSlot" + IntegerToString(i), slotX, slotY, slotWidth, slotHeight, clrGray, m_borderColor);
         CreateLabel(m_prefix + "FilterSlotText" + IntegerToString(i), slotX + 10, slotY + 5, "Trascina qui", clrWhite, 8);
      }
   }
   
   // Crea la sezione gestione rischio
   void CreateRiskSection()
   {
      int sectionX = m_x + 10;
      int sectionY = m_y + 340;
      int sectionWidth = m_width - 20;
      int sectionHeight = 50;
      
      CreateRectangle(m_prefix + "RiskSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "RiskTitle", sectionX + 10, sectionY + 5, "Gestione Rischio", clrLightYellow, 10);
      
      // Parametri di rischio
      string riskLabels[] = {"Risk%:", "TP:", "SL:", "BE:", "TS:", "Magic:", "Comment:", "Version:"};
      for(int i = 0; i < ArraySize(riskLabels); i++)
      {
         int col = i % 8;
         CreateLabel(m_prefix + "RiskLabel" + IntegerToString(i), sectionX + 10 + col * 85, sectionY + 25, riskLabels[i], clrWhite, 8);
         CreateLabel(m_prefix + "RiskValue" + IntegerToString(i), sectionX + 50 + col * 85, sectionY + 25, "---", clrLightGray, 8);
      }
   }
   
   // Crea i pulsanti di azione
   void CreateActionButtons()
   {
      int buttonWidth = 80;
      int buttonHeight = 25;
      int buttonY = m_y + m_height - buttonHeight - 5;
      
      CreateButton(m_prefix + "StartButton", m_x + 10, buttonY, buttonWidth, buttonHeight, "Avvia", clrForestGreen);
      CreateButton(m_prefix + "StopButton", m_x + 10 + buttonWidth + 10, buttonY, buttonWidth, buttonHeight, "Stop", clrFireBrick);
      CreateButton(m_prefix + "ResetButton", m_x + 10 + (buttonWidth + 10) * 2, buttonY, buttonWidth, buttonHeight, "Reset", clrDarkOrange);
      CreateButton(m_prefix + "ConfigButton", m_x + 10 + (buttonWidth + 10) * 3, buttonY, buttonWidth, buttonHeight, "Config", clrRoyalBlue);
   }
   
   // Aggiorna la sezione informazioni
   void UpdateInfoSection()
   {
      // Aggiorna i valori delle informazioni
      // ...
   }
   
   // Aggiorna gli stati degli slot
   void UpdateSlotStates()
   {
      // Aggiorna gli stati degli slot di acquisto, vendita e filtri
      // ...
   }
   
   // Gestisce i clic sui pulsanti
   void HandleButtonClick(string buttonName)
   {
      if(buttonName == m_prefix + "StartButton")
      {
         // Avvia l'EA
         // ...
      }
      else if(buttonName == m_prefix + "StopButton")
      {
         // Ferma l'EA
         // ...
      }
      else if(buttonName == m_prefix + "ResetButton")
      {
         // Resetta l'EA
         // ...
      }
      else if(buttonName == m_prefix + "ConfigButton")
      {
         // Apri la configurazione
         // ...
      }
   }
};
