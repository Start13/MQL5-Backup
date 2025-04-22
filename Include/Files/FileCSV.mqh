//+------------------------------------------------------------------+
//|                                                   FileCSV.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Files\File.mqh>

//+------------------------------------------------------------------+
//| Classe per la gestione di file CSV                                |
//+------------------------------------------------------------------+
class CFileCSV : public CFile
{
private:
   string            m_delimiter;       // Delimitatore di campo
   string            m_line_ending;     // Terminatore di riga
   
public:
   // Costruttore
   CFileCSV(const string delimiter = ",", const string line_ending = "\n")
   {
      m_delimiter = delimiter;
      m_line_ending = line_ending;
   }
   
   // Distruttore
   ~CFileCSV()
   {
      Close();
   }
   
   // Apre un file CSV
   bool Open(const string file_name, const int flags)
   {
      return CFile::Open(file_name, flags) != INVALID_HANDLE;
   }
   
   // Scrive una riga di dati CSV
   bool WriteRow(const string &data[])
   {
      if(!IsFileWritable()) return false;
      
      string line = "";
      for(int i = 0; i < ArraySize(data); i++)
      {
         if(i > 0) line += m_delimiter;
         
         // Gestisce le virgolette se necessario
         string field = data[i];
         if(StringFind(field, m_delimiter) >= 0 || StringFind(field, "\"") >= 0 || StringFind(field, "\n") >= 0)
         {
            StringReplace(field, "\"", "\"\"");
            field = "\"" + field + "\"";
         }
         
         line += field;
      }
      
      line += m_line_ending;
      return FileWriteString(m_handle, line) > 0;
   }
   
   // Legge una riga di dati CSV
   bool ReadRow(string &data[])
   {
      if(!IsFileReadable()) return false;
      
      string line = FileReadString(m_handle);
      if(line == "") return false;
      
      // Rimuove il terminatore di riga se presente
      int len = StringLen(line);
      if(len > 0 && StringSubstr(line, len-1, 1) == "\n")
      {
         line = StringSubstr(line, 0, len-1);
      }
      
      // Analizza i campi
      int count = 0;
      int pos = 0;
      int start = 0;
      bool in_quotes = false;
      
      ArrayResize(data, 0);
      
      while(pos <= len)
      {
         string ch = (pos < len) ? StringSubstr(line, pos, 1) : m_delimiter;
         
         if(ch == "\"")
         {
            in_quotes = !in_quotes;
         }
         else if(ch == m_delimiter && !in_quotes)
         {
            string field = StringSubstr(line, start, pos - start);
            
            // Rimuove le virgolette se presenti
            if(StringLen(field) >= 2 && StringSubstr(field, 0, 1) == "\"" && StringSubstr(field, StringLen(field)-1, 1) == "\"")
            {
               field = StringSubstr(field, 1, StringLen(field)-2);
               StringReplace(field, "\"\"", "\"");
            }
            
            ArrayResize(data, count + 1);
            data[count] = field;
            count++;
            
            start = pos + 1;
         }
         
         pos++;
      }
      
      return true;
   }
   
   // Verifica se il file è scrivibile
   bool IsFileWritable()
   {
      return (m_handle != INVALID_HANDLE && (m_flags & FILE_WRITE) != 0);
   }
   
   // Verifica se il file è leggibile
   bool IsFileReadable()
   {
      return (m_handle != INVALID_HANDLE && (m_flags & FILE_READ) != 0);
   }
};
