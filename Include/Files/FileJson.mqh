//+------------------------------------------------------------------+
//|                                                  FileJson.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Object.mqh>
#include <Arrays\ArrayObj.mqh>

//+------------------------------------------------------------------+
//| Classe per la gestione di file JSON                               |
//+------------------------------------------------------------------+
class CJAVal : public CObject
{
public:
   string            m_key;             // Chiave
   string            m_value;           // Valore come stringa
   bool              m_bool;            // Valore come booleano
   long              m_long;            // Valore come intero
   double            m_double;          // Valore come double
   CArrayObj         m_children;        // Array di figli
   bool              m_is_array;        // Flag per indicare se è un array
   
public:
   // Costruttore
   CJAVal(const string key = "", const string value = "")
   {
      m_key = key;
      m_value = value;
      m_bool = false;
      m_long = 0;
      m_double = 0.0;
      m_is_array = false;
   }
   
   // Distruttore
   ~CJAVal()
   {
      Clear();
   }
   
   // Pulisce l'oggetto
   void Clear()
   {
      m_key = "";
      m_value = "";
      m_bool = false;
      m_long = 0;
      m_double = 0.0;
      m_is_array = false;
      m_children.Clear();
   }
   
   // Imposta il valore come stringa
   void Set(const string value)
   {
      m_value = value;
      m_bool = (StringToInteger(value) != 0);
      m_long = StringToInteger(value);
      m_double = StringToDouble(value);
   }
   
   // Imposta il valore come booleano
   void Set(const bool value)
   {
      m_value = (value) ? "true" : "false";
      m_bool = value;
      m_long = (value) ? 1 : 0;
      m_double = (value) ? 1.0 : 0.0;
   }
   
   // Imposta il valore come intero
   void Set(const long value)
   {
      m_value = IntegerToString(value);
      m_bool = (value != 0);
      m_long = value;
      m_double = (double)value;
   }
   
   // Imposta il valore come double
   void Set(const double value)
   {
      m_value = DoubleToString(value, 8);
      m_bool = (value != 0.0);
      m_long = (long)value;
      m_double = value;
   }
   
   // Aggiunge un figlio
   CJAVal *Add(const string key)
   {
      CJAVal *child = new CJAVal(key);
      if(child != NULL)
      {
         m_children.Add(child);
      }
      return child;
   }
   
   // Aggiunge un figlio con valore
   CJAVal *Add(const string key, const string value)
   {
      CJAVal *child = Add(key);
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un figlio con valore booleano
   CJAVal *Add(const string key, const bool value)
   {
      CJAVal *child = Add(key);
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un figlio con valore intero
   CJAVal *Add(const string key, const long value)
   {
      CJAVal *child = Add(key);
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un figlio con valore double
   CJAVal *Add(const string key, const double value)
   {
      CJAVal *child = Add(key);
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un elemento all'array
   CJAVal *AddArray(const string key)
   {
      CJAVal *child = Add(key);
      if(child != NULL)
      {
         child.m_is_array = true;
      }
      return child;
   }
   
   // Aggiunge un elemento all'array con valore
   CJAVal *AddArrayItem(const string value)
   {
      CJAVal *child = Add("");
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un elemento all'array con valore booleano
   CJAVal *AddArrayItem(const bool value)
   {
      CJAVal *child = Add("");
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un elemento all'array con valore intero
   CJAVal *AddArrayItem(const long value)
   {
      CJAVal *child = Add("");
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Aggiunge un elemento all'array con valore double
   CJAVal *AddArrayItem(const double value)
   {
      CJAVal *child = Add("");
      if(child != NULL)
      {
         child.Set(value);
      }
      return child;
   }
   
   // Ottiene un figlio per chiave
   CJAVal *GetObjectByKey(const string key)
   {
      for(int i = 0; i < m_children.Total(); i++)
      {
         CJAVal *child = m_children.At(i);
         if(child != NULL && child.m_key == key)
         {
            return child;
         }
      }
      return NULL;
   }
   
   // Ottiene un figlio per indice
   CJAVal *GetObjectByIndex(const int index)
   {
      if(index >= 0 && index < m_children.Total())
      {
         return m_children.At(index);
      }
      return NULL;
   }
   
   // Operatore di accesso per chiave
   CJAVal *operator[](const string key)
   {
      return GetObjectByKey(key);
   }
   
   // Operatore di accesso per indice
   CJAVal *operator[](const int index)
   {
      return GetObjectByIndex(index);
   }
   
   // Salva in un file JSON
   bool SaveToFile(const string file_name)
   {
      int file_handle = FileOpen(file_name, FILE_WRITE|FILE_TXT);
      if(file_handle == INVALID_HANDLE)
      {
         return false;
      }
      
      string json = Serialize();
      FileWriteString(file_handle, json);
      FileClose(file_handle);
      
      return true;
   }
   
   // Carica da un file JSON
   bool LoadFromFile(const string file_name)
   {
      Clear();
      
      int file_handle = FileOpen(file_name, FILE_READ|FILE_TXT);
      if(file_handle == INVALID_HANDLE)
      {
         return false;
      }
      
      string json = "";
      while(!FileIsEnding(file_handle))
      {
         json += FileReadString(file_handle);
      }
      
      FileClose(file_handle);
      
      return Parse(json);
   }
   
   // Serializza in JSON
   string Serialize()
   {
      string json = "";
      
      if(m_is_array)
      {
         json = "[";
         for(int i = 0; i < m_children.Total(); i++)
         {
            CJAVal *child = m_children.At(i);
            if(child != NULL)
            {
               if(i > 0) json += ",";
               json += child.Serialize();
            }
         }
         json += "]";
      }
      else if(m_children.Total() > 0)
      {
         json = "{";
         for(int i = 0; i < m_children.Total(); i++)
         {
            CJAVal *child = m_children.At(i);
            if(child != NULL)
            {
               if(i > 0) json += ",";
               json += "\"" + child.m_key + "\":" + child.Serialize();
            }
         }
         json += "}";
      }
      else
      {
         if(m_value == "")
         {
            json = "null";
         }
         else if(m_value == "true" || m_value == "false")
         {
            json = m_value;
         }
         else if(StringToDouble(m_value) != 0.0 || m_value == "0")
         {
            json = m_value;
         }
         else
         {
            json = "\"" + m_value + "\"";
         }
      }
      
      return json;
   }
   
   // Analizza una stringa JSON
   bool Parse(const string json)
   {
      Clear();
      
      // Implementazione semplificata per la versione Lite
      // Questa è una versione base che supporta solo le operazioni essenziali
      
      if(json == "") return false;
      
      // Rimuovi spazi bianchi all'inizio e alla fine
      string trimmed = json;
      StringTrimLeft(trimmed);
      StringTrimRight(trimmed);
      
      // Caso oggetto
      if(StringGetCharacter(trimmed, 0) == '{' && StringGetCharacter(trimmed, StringLen(trimmed) - 1) == '}')
      {
         // Implementazione minima per la versione Lite
         return true;
      }
      // Caso array
      else if(StringGetCharacter(trimmed, 0) == '[' && StringGetCharacter(trimmed, StringLen(trimmed) - 1) == ']')
      {
         m_is_array = true;
         // Implementazione minima per la versione Lite
         return true;
      }
      // Caso valore semplice
      else
      {
         m_value = trimmed;
         return true;
      }
      
      return true;
   }
};
