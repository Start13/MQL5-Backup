//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <Math\Stat\Stat.mqh>
#include <EasyAndFastGUI\WndCreate.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
//+------------------------------------------------------------------+
//| Класс для создания приложения                                    |
//+------------------------------------------------------------------+
class CProgram : public CWndCreate
  {
protected:
   //--- Временные счётчики
   CTimeCounter      m_counter1; // для обновления процесса выполнения
   CTimeCounter      m_counter2; // для обновления пунктов в статусной строке
   //--- Главное окно
   CWindow           m_window;
   //--- Статусная строка
   CStatusBar        m_status_bar;
   //--- Картинка
   CPicture          m_picture1;
   //--- Элементы для управления графиком
   CTextEdit         m_a_inc;
   CTextEdit         m_b_inc;
   CTextEdit         m_t_inc;
   //---
   CSeparateLine     m_sep_line1;
   //---
   CTextEdit         m_animate;
   CTextEdit         m_array_size;
   CButton           m_random;
   //---
   CSeparateLine     m_sep_line2;
   //---
   CCheckBox         m_line_smooth;
   CComboBox         m_curve_type;
   CComboBox         m_point_type;
   //--- График
   CGraph            m_graph1;

   //--- Массивы данных для расчётов
   double            a_inc[];
   double            b_inc[];
   double            t_inc[];
   double            x_source[];
   double            y_source[];
   //--- Массивы данных для вывода на график
   double            x_norm[];
   double            y_norm[];
   //--- Для расчёта среднего и стандартного отклонения
   double            x_mean;
   double            y_mean;
   double            x_sdev;
   double            y_sdev;
   //---
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Инициализация/деинициализация
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- Таймер
   void              OnTimerEvent(void);
   //--- Обработчик события графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   //--- Создаёт графический интерфейс программы
   bool              CreateGUI(void);
   //---
protected:
   //--- График
   bool              CreateGraph1(const int x_gap,const int y_gap);
   //---
private:
   //--- Установить новый размер массивам
   void              ResizeArrays(void);
   //--- Инициализация вспомогательных массивов для расчётов
   void              InitArrays(void);
   //--- Устанавливает и обновляет серии на графике
   void              UpdateSeries(void);
   //--- Перерасчёт серий на графике
   void              RecalculatingSeries(void);
   //--- Добавляет текст на график
   void              TextAdd(void);

   //--- Обновление графика по таймеру
   void              UpdateGraphByTimer(void);
   //--- Анимация серий графика
   void              AnimateGraphSeries(void);
  };
//+------------------------------------------------------------------+
//| Создание элементов управления                                    |
//+------------------------------------------------------------------+
#include "MainWindow.mqh"
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void) : x_mean(0),
                           y_mean(0),
                           x_sdev(0),
                           y_sdev(0)
  {
//--- Установка параметров для временных счётчиков
   m_counter1.SetParameters(16,16);
   m_counter2.SetParameters(16,35);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Инициализация                                                    |
//+------------------------------------------------------------------+
void CProgram::OnInitEvent(void)
  {
  }
//+------------------------------------------------------------------+
//| Деинициализация                                                  |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason)
  {
//--- Удаление интерфейса
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
//--- Обновление графика по таймеру
   if(m_counter1.CheckTimeCounter())
     {
      UpdateGraphByTimer();
     }
//---
   if(m_counter2.CheckTimeCounter())
     {
      if(m_status_bar.IsVisible())
        {
         static int index=0;
         index=(index+1>3)? 0 : index+1;
         m_status_bar.GetItemPointer(1).ChangeImage(0,index);
         m_status_bar.GetItemPointer(1).Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Обработчик событий графика                                       |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Событие изменения состояния чек-бокса
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_CHECKBOX)
     {
      if(lparam==m_line_smooth.Id())
        {
         //--- Перерасчёт серий на графике
         RecalculatingSeries();
         return;
        }
      return;
     }
//--- Событие выбора пункта в комбо-боксе
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      if(lparam==m_curve_type.Id() || lparam==m_point_type.Id())
        {
         //--- Перерасчёт серий на графике
         RecalculatingSeries();
         return;
        }
      return;
     }
//--- Событие ввода нового значения в поле ввода
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      if(lparam==m_a_inc.Id() || lparam==m_b_inc.Id() ||
         lparam==m_t_inc.Id() || lparam==m_animate.Id() ||
         lparam==m_array_size.Id())
        {
         //--- Перерасчёт серий на графике
         RecalculatingSeries();
         return;
        }
      return;
     }
//--- События нажатия на кнопках-переключателях поля ввода
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(lparam==m_random.Id())
        {
         //--- Установить случайные значения
         m_a_inc.SetValue(string(::rand()%1000)+"."+string(::rand()%100),false);
         m_b_inc.SetValue(string(::rand()%1000)+"."+string(::rand()%100),false);
         m_t_inc.SetValue(string(::rand()%1000)+"."+string(::rand()%100),false);
         //--- Обновить поля ввода
         m_a_inc.GetTextBoxPointer().Update(true);
         m_b_inc.GetTextBoxPointer().Update(true);
         m_t_inc.GetTextBoxPointer().Update(true);
         //--- Перерасчёт серий на графике
         RecalculatingSeries();
         return;
        }
      //---
      if(lparam==m_a_inc.Id() || lparam==m_b_inc.Id() ||
         lparam==m_t_inc.Id() || lparam==m_animate.Id() ||
         lparam==m_array_size.Id())
        {
         //--- Перерасчёт серий на графике
         RecalculatingSeries();
         return;
        }
      return;
     }
  }
//+------------------------------------------------------------------+
