//+------------------------------------------------------------------+
//|                                                 PanelUI.mqh |
//|        Elementi dell'interfaccia utente per OmniEA           |
//|        AlgoWi Implementation                         |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property strict

#include <AIWindsurf\ui\PanelBase.mqh>
#include <AIWindsurf\omniea\SlotManager.mqh>

//+------------------------------------------------------------------+
//| Classe per gli elementi dell'interfaccia utente di OmniEA        |
//+------------------------------------------------------------------+
class CPanelUI : public CPanelBase
{
protected:
   int               m_maxBuySlots;     // Numero massimo di slot di acquisto
   int               m_maxSellSlots;    // Numero massimo di slot di vendita
   int               m_maxFilterSlots;  // Numero massimo di slot di filtro
   
   // Stato del trading
   bool              m_isTradingEnabled;// Trading abilitato

private:
   // Dati di mercato
   string            m_symbol;          // Simbolo corrente
   string            m_broker;          // Nome del broker
   double            m_balance;         // Saldo del conto
   double            m_equity;          // Equity del conto
   double            m_spread;          // Spread corrente
   string            m_marketStatus;    // Stato del mercato
   
public:
   // Costruttore
   CPanelUI() : CPanelBase()
   {
      m_maxBuySlots = 3;
      m_maxSellSlots = 3;
      m_maxFilterSlots = 2;
      
      m_isTradingEnabled = false;
      
      m_symbol = _Symbol;
      m_broker = AccountInfoString(ACCOUNT_COMPANY);
      m_balance = AccountInfoDouble(ACCOUNT_BALANCE);
      m_equity = AccountInfoDouble(ACCOUNT_EQUITY);
      m_spread = SymbolInfoInteger(m_symbol, SYMBOL_SPREAD) * SymbolInfoDouble(m_symbol, SYMBOL_POINT);
      m_marketStatus = "Aperto";
   }
   
   // Inizializzazione del pannello
   bool Initialize(string name = "OmniEA", int version = 0)
   {
      SetEAInfo(name, version);
      
      // Crea il pannello principale
      CreateRectangle(m_prefix + "Background", m_x, m_y, m_width, m_height, m_bgColor, m_borderColor);
      
      // Crea l'intestazione
      string versionText = "";
      switch(version)
      {
         case 0: versionText = "Lite"; break;
         case 1: versionText = "Pro"; break;
         case 2: versionText = "Ultimate"; break;
         default: versionText = "v" + IntegerToString(version);
      }
      
      string title = name + " " + versionText + " - BlueTrendTeam";
      CreateRectangle(m_prefix + "Header", m_x, m_y, m_width, PANEL_HEADER_HEIGHT, clrRoyalBlue, m_borderColor);
      CreateLabel(m_prefix + "Title", m_x + 10, m_y + 7, title, clrWhite, 10);
      
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
      
      // Aggiorna la notifica se necessario
      if(m_notificationTime > 0 && TimeCurrent() - m_notificationTime > 5)
      {
         // Nascondi la notifica dopo 5 secondi
         m_notificationText = "";
         ObjectSetString(0, m_prefix + "Notification", OBJPROP_TEXT, "");
         m_notificationTime = 0;
      }
   }
   
   // Pulizia del pannello
   void Cleanup()
   {
      DeleteObjectsByPrefix(m_prefix);
      m_isVisible = false;
   }
   
   // Imposta lo stato del trading
   void SetTradingEnabled(bool enabled)
   {
      m_isTradingEnabled = enabled;
      
      // Aggiorna il colore del pulsante di avvio/arresto
      if(m_isVisible)
      {
         color buttonColor = enabled ? clrFireBrick : clrForestGreen;
         string buttonText = enabled ? Translate("UI_STOP") : Translate("UI_START");
         
         ObjectSetInteger(0, m_prefix + "StartStopButton", OBJPROP_BGCOLOR, buttonColor);
         ObjectSetString(0, m_prefix + "StartStopButton", OBJPROP_TEXT, buttonText);
      }
   }
   
   // Aggiorna i dati di mercato
   void UpdateMarketData(string symbol, string broker, double balance, double equity, double spread, string marketStatus)
   {
      m_symbol = symbol;
      m_broker = broker;
      m_balance = balance;
      m_equity = equity;
      m_spread = spread;
      m_marketStatus = marketStatus;
   }
   
private:
   // Crea la sezione informazioni
   void CreateInfoSection()
   {
      int sectionX = m_x + PANEL_MARGIN;
      int sectionY = m_infoY;
      int sectionWidth = m_width - 2 * PANEL_MARGIN;
      int sectionHeight = m_infoHeight;
      
      CreateRectangle(m_prefix + "InfoSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "InfoTitle", sectionX + 10, sectionY + 5, "Informazioni", clrWhite, 10);
      
      // Etichette per le informazioni
      string infoLabels[] = {"Broker:", "Account:", "Balance:", "Equity:", "Symbol:", "Spread:", "Time:", "Market Status:", "Time Trading:", "News Filter:"};
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
      int sectionX = m_x + PANEL_MARGIN;
      int sectionY = m_buyY;
      int sectionWidth = (m_width - 3 * PANEL_MARGIN) / 2;
      int sectionHeight = m_buyHeight;
      
      CreateRectangle(m_prefix + "BuySection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "BuyTitle", sectionX + 10, sectionY + 5, Translate("UI_BUY_SIGNALS"), clrLightGreen, 10);
      
      // Slot per gli indicatori
      for(int i = 0; i < m_maxBuySlots; i++)
      {
         int slotX = sectionX + 10;
         int slotY = sectionY + 25 + i * (PANEL_SLOT_HEIGHT + 5);
         int slotWidth = sectionWidth - 20;
         int slotHeight = PANEL_SLOT_HEIGHT;
         
         CreateRectangle(m_prefix + "BuySlot" + IntegerToString(i), slotX, slotY, slotWidth, slotHeight, clrGray, m_borderColor);
         CreateLabel(m_prefix + "BuySlotText" + IntegerToString(i), slotX + 10, slotY + 5, Translate("UI_DRAG_HERE"), clrWhite, 8);
         
         // Pulsante per rimuovere lo slot
         CreateButton(m_prefix + "BuySlotRemove" + IntegerToString(i), slotX + slotWidth - 20, slotY, 20, slotHeight, "X", clrDarkRed);
      }
   }
   
   // Crea la sezione segnali di vendita
   void CreateSellSection()
   {
      int sectionX = m_x + PANEL_MARGIN * 2 + (m_width - 3 * PANEL_MARGIN) / 2;
      int sectionY = m_sellY;
      int sectionWidth = (m_width - 3 * PANEL_MARGIN) / 2;
      int sectionHeight = m_sellHeight;
      
      CreateRectangle(m_prefix + "SellSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "SellTitle", sectionX + 10, sectionY + 5, Translate("UI_SELL_SIGNALS"), clrLightCoral, 10);
      
      // Slot per gli indicatori
      for(int i = 0; i < m_maxSellSlots; i++)
      {
         int slotX = sectionX + 10;
         int slotY = sectionY + 25 + i * (PANEL_SLOT_HEIGHT + 5);
         int slotWidth = sectionWidth - 20;
         int slotHeight = PANEL_SLOT_HEIGHT;
         
         CreateRectangle(m_prefix + "SellSlot" + IntegerToString(i), slotX, slotY, slotWidth, slotHeight, clrGray, m_borderColor);
         CreateLabel(m_prefix + "SellSlotText" + IntegerToString(i), slotX + 10, slotY + 5, Translate("UI_DRAG_HERE"), clrWhite, 8);
         
         // Pulsante per rimuovere lo slot
         CreateButton(m_prefix + "SellSlotRemove" + IntegerToString(i), slotX + slotWidth - 20, slotY, 20, slotHeight, "X", clrDarkRed);
      }
   }
   
   // Crea la sezione filtri
   void CreateFilterSection()
   {
      int sectionX = m_x + PANEL_MARGIN;
      int sectionY = m_filterY;
      int sectionWidth = m_width - 2 * PANEL_MARGIN;
      int sectionHeight = m_filterHeight;
      
      CreateRectangle(m_prefix + "FilterSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "FilterTitle", sectionX + 10, sectionY + 5, Translate("UI_FILTERS"), clrLightBlue, 10);
      
      // Slot per i filtri
      for(int i = 0; i < m_maxFilterSlots; i++)
      {
         int slotX = sectionX + 10 + i * ((sectionWidth - 20) / m_maxFilterSlots + 5);
         int slotY = sectionY + 25;
         int slotWidth = (sectionWidth - 20 - (m_maxFilterSlots - 1) * 5) / m_maxFilterSlots;
         int slotHeight = PANEL_SLOT_HEIGHT;
         
         CreateRectangle(m_prefix + "FilterSlot" + IntegerToString(i), slotX, slotY, slotWidth, slotHeight, clrGray, m_borderColor);
         CreateLabel(m_prefix + "FilterSlotText" + IntegerToString(i), slotX + 10, slotY + 5, Translate("UI_DRAG_HERE"), clrWhite, 8);
         
         // Pulsante per rimuovere lo slot
         CreateButton(m_prefix + "FilterSlotRemove" + IntegerToString(i), slotX + slotWidth - 20, slotY, 20, slotHeight, "X", clrDarkRed);
      }
   }
   
   // Crea la sezione gestione rischio
   void CreateRiskSection()
   {
      int sectionX = m_x + PANEL_MARGIN;
      int sectionY = m_riskY;
      int sectionWidth = m_width - 2 * PANEL_MARGIN;
      int sectionHeight = m_riskHeight;
      
      CreateRectangle(m_prefix + "RiskSection", sectionX, sectionY, sectionWidth, sectionHeight, clrDarkSlateGray, m_borderColor);
      CreateLabel(m_prefix + "RiskTitle", sectionX + 10, sectionY + 5, Translate("UI_RISK_MANAGEMENT"), clrLightYellow, 10);
      
      // Parametri di rischio
      string riskLabels[] = {"Risk%:", "SL:", "TP:", "BE:", "TS:", "Magic:", "Comment:"};
      for(int i = 0; i < ArraySize(riskLabels); i++)
      {
         int col = i % 7;
         int labelWidth = 40;
         int valueWidth = 40;
         int spacing = 5;
         int totalWidth = labelWidth + valueWidth + spacing;
         
         int startX = sectionX + 10 + col * (totalWidth + 10);
         
         CreateLabel(m_prefix + "RiskLabel" + IntegerToString(i), startX, sectionY + 25, riskLabels[i], clrWhite, 8);
         CreateEdit(m_prefix + "RiskValue" + IntegerToString(i), startX + labelWidth + spacing, sectionY + 23, valueWidth, 18, "---", clrWhite, clrBlack);
      }
   }
   
   // Crea i pulsanti di azione
   void CreateActionButtons()
   {
      int buttonWidth = PANEL_BUTTON_WIDTH;
      int buttonHeight = PANEL_BUTTON_HEIGHT;
      int buttonY = m_actionsY + (m_actionsHeight - buttonHeight) / 2;
      int buttonSpacing = 10;
      
      // Pulsante Avvia/Arresta
      CreateButton(m_prefix + "StartStopButton", m_x + PANEL_MARGIN, buttonY, buttonWidth, buttonHeight, Translate("UI_START"), clrForestGreen);
      
      // Pulsante Reset
      CreateButton(m_prefix + "ResetButton", m_x + PANEL_MARGIN + buttonWidth + buttonSpacing, buttonY, buttonWidth, buttonHeight, Translate("UI_RESET"), clrDarkOrange);
      
      // Pulsante Configurazione
      CreateButton(m_prefix + "ConfigButton", m_x + PANEL_MARGIN + (buttonWidth + buttonSpacing) * 2, buttonY, buttonWidth, buttonHeight, Translate("UI_CONFIG"), clrRoyalBlue);
      
      // Pulsante Salva
      CreateButton(m_prefix + "SaveButton", m_x + PANEL_MARGIN + (buttonWidth + buttonSpacing) * 3, buttonY, buttonWidth, buttonHeight, Translate("UI_SAVE"), clrDodgerBlue);
      
      // Pulsante Carica
      CreateButton(m_prefix + "LoadButton", m_x + PANEL_MARGIN + (buttonWidth + buttonSpacing) * 4, buttonY, buttonWidth, buttonHeight, Translate("UI_LOAD"), clrSlateBlue);
      
      // Pulsante Ottimizza
      CreateButton(m_prefix + "OptimizeButton", m_x + PANEL_MARGIN + (buttonWidth + buttonSpacing) * 5, buttonY, buttonWidth, buttonHeight, Translate("UI_OPTIMIZE"), clrMediumPurple);
      
      // Pulsante Report
      CreateButton(m_prefix + "ReportButton", m_x + PANEL_MARGIN + (buttonWidth + buttonSpacing) * 6, buttonY, buttonWidth, buttonHeight, Translate("UI_REPORT"), clrTeal);
   }
   
   // Aggiorna la sezione informazioni
   void UpdateInfoSection()
   {
      // Aggiorna i valori delle informazioni
      ObjectSetString(0, m_prefix + "InfoValue0", OBJPROP_TEXT, m_broker);
      ObjectSetString(0, m_prefix + "InfoValue1", OBJPROP_TEXT, IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)));
      ObjectSetString(0, m_prefix + "InfoValue2", OBJPROP_TEXT, DoubleToString(m_balance, 2));
      ObjectSetString(0, m_prefix + "InfoValue3", OBJPROP_TEXT, DoubleToString(m_equity, 2));
      ObjectSetString(0, m_prefix + "InfoValue4", OBJPROP_TEXT, m_symbol);
      ObjectSetString(0, m_prefix + "InfoValue5", OBJPROP_TEXT, DoubleToString(m_spread, 1));
      ObjectSetString(0, m_prefix + "InfoValue6", OBJPROP_TEXT, TimeToString(TimeCurrent(), TIME_MINUTES));
      ObjectSetString(0, m_prefix + "InfoValue7", OBJPROP_TEXT, m_marketStatus);
      
      // Stato del trading
      string tradingStatus = m_isTradingEnabled ? "Attivo" : "Inattivo";
      ObjectSetString(0, m_prefix + "InfoValue8", OBJPROP_TEXT, tradingStatus);
      
      // Filtro notizie (da implementare)
      ObjectSetString(0, m_prefix + "InfoValue9", OBJPROP_TEXT, "Inattivo");
   }
   
   // Aggiorna gli stati degli slot
   void UpdateSlotStates()
   {
      // Aggiornamento degli slot da implementare in base ai dati del SlotManager
      // ...
   }
};

