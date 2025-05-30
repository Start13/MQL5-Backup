//+------------------------------------------------------------------+
//|                                                   MainWindow.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp"
//---
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Создаёт графический интерфейс программы                          |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
//--- Создание формы для элементов управления
   if(!CWndCreate::CreateWindow(m_window,"EXPERT PANEL",1,1,518,600,true,true,true,true))
      return(false);
//--- Статусная строка
   string text_items[2];
   text_items[0]="For Help, press F1";
   text_items[1]="Disconnected...";
   int width_items[]={0,130};
   if(!CWndCreate::CreateStatusBar(m_status_bar,m_window,1,23,22,text_items,width_items))
      return(false);
   else
     {
      //--- Установка картинок
      int item_index=1;
      m_status_bar.GetItemPointer(item_index).LabelXGap(25);
      m_status_bar.GetItemPointer(item_index).AddImagesGroup(5,3);
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp");
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp");
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp");
      m_status_bar.GetItemPointer(item_index).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp");
     }
//--- Элементы управления графиком
   if(!CWndCreate::CreateTextEdit(m_a_inc,"a:",m_window,0,false,7,25,90,70,1000,1,0.01,2,2))
      return(false);
   if(!CWndCreate::CreateTextEdit(m_b_inc,"b:",m_window,0,false,7,50,90,70,1000,1,0.01,2,0))
      return(false);
   if(!CWndCreate::CreateTextEdit(m_t_inc,"t:",m_window,0,false,7,75,90,70,1000,1,0.01,2,1))
      return(false);
//--- Разделительная линия
   if(!CWndCreate::CreateSepLine(m_sep_line1,m_window,0,110,25,2,72,C'150,150,150',clrWhite,V_SEP_LINE))
      return(false);
   if(!CWndCreate::CreateSepLine(m_sep_line1,m_window,0,280,25,2,72,C'150,150,150',clrWhite,V_SEP_LINE))
      return(false);
//---
   if(!CWndCreate::CreateTextEdit(m_animate,"Animate:",m_window,0,true,125,25,140,70,1,0,0.01,2,0))
      return(false);
   if(!CWndCreate::CreateTextEdit(m_array_size,"Array size:",m_window,0,false,125,50,140,70,10000,3,1,0,100))
      return(false);
   if(!CWndCreate::CreateButton(m_random,"Random",m_window,0,125,75,140))
      return(false);
//---
   if(!CWndCreate::CreateCheckbox(m_line_smooth,"Line smooth",m_window,0,295,29,90,false,false,false))
      return(false);
//---
   string items1[]={"CURVE_POINTS","CURVE_LINES","CURVE_POINTS_AND_LINES","CURVE_STEPS","CURVE_HISTOGRAM"};
   if(!CWndCreate::CreateCombobox(m_curve_type,"Curve type:",m_window,0,false,295,50,215,150,items1,93,1))
      return(false);
   string items2[]=
     {
      "POINT_CIRCLE","POINT_SQUARE","POINT_DIAMOND","POINT_TRIANGLE","POINT_TRIANGLE_DOWN",
      "POINT_X_CROSS","POINT_PLUS","POINT_STAR","POINT_HORIZONTAL_DASH","POINT_VERTICAL_DASH"
     };
   if(!CWndCreate::CreateCombobox(m_point_type,"Point type:",m_window,0,false,295,75,215,150,items2,183,0))
      return(false);
//--- График
   if(!CreateGraph1(2,100))
      return(false);
//--- Завершение создания GUI
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт график 1                                                 |
//+------------------------------------------------------------------+
bool CProgram::CreateGraph1(const int x_gap,const int y_gap)
  {
//--- Сохраним указатель на главный элемент
   m_graph1.MainPointer(m_window);
//--- Свойства элемента
   m_graph1.AutoXResizeMode(true);
   m_graph1.AutoYResizeMode(true);
   m_graph1.AutoXResizeRightOffset(2);
   m_graph1.AutoYResizeBottomOffset(23);
//--- Создание элемента
   if(!m_graph1.CreateGraph(x_gap,y_gap))
      return(false);
//--- Свойства графика
   CGraphic *graph=m_graph1.GetGraphicPointer();
   graph.BackgroundColor(::ColorToARGB(clrWhiteSmoke));
   graph.HistoryNameWidth(0);
//--- Свойства X-оси
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.DefaultStep(0.5);
   x_axis.Max(3.5);
   x_axis.Min(-3.5);
//--- Свойства Y-оси
   CAxis *y_axis=graph.YAxis();
   y_axis.ValuesWidth(30);
   y_axis.AutoScale(false);
   y_axis.DefaultStep(0.5);
   y_axis.Max(3.5);
   y_axis.Min(-3.5);
//--- Инициализировать массивы
   InitArrays();
//--- Создать кривую
   CCurve *curve1=graph.CurveAdd(x_norm,y_norm,::ColorToARGB(clrCornflowerBlue),CURVE_LINES);
//--- Нарисовать данные на графике
   graph.CurvePlotAll();
//--- Вывести текст
   TextAdd();
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_graph1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Изменяет размер массивов                                         |
//+------------------------------------------------------------------+
void CProgram::ResizeArrays(void)
  {
   int array_size =::ArraySize(x_norm);
   int new_size   =(int)m_array_size.GetValue();
//--- Выйти, если размер не изменился
   if(array_size==new_size)
      return;
//--- Установить новый размер
   ::ArrayResize(a_inc,new_size);
   ::ArrayResize(b_inc,new_size);
   ::ArrayResize(t_inc,new_size);
   ::ArrayResize(x_source,new_size);
   ::ArrayResize(y_source,new_size);
   ::ArrayResize(x_norm,new_size);
   ::ArrayResize(y_norm,new_size);
  }
//+------------------------------------------------------------------+
//| Инициализация массивов                                           |
//+------------------------------------------------------------------+
void CProgram::InitArrays(void)
  {
//--- Изменить размеры массивов
   ResizeArrays();
//--- Рассчитаем значения по формулам
   int total=(int)m_array_size.GetValue();
   for(int i=0; i<total; i++)
     {
      if(i<1)
        {
         a_inc[i] =1+(double)m_animate.GetValue();
         b_inc[i] =1+(double)m_animate.GetValue();
         t_inc[i] =1+(double)m_animate.GetValue();
        }
      else
        {
         a_inc[i] =a_inc[i-1]+(double)m_a_inc.GetValue();
         b_inc[i] =b_inc[i-1]+(double)m_b_inc.GetValue();
         t_inc[i] =t_inc[i-1]+(double)m_t_inc.GetValue();
        }
      //---
      double a=a_inc[i];
      double b=b_inc[i];
      double t=t_inc[i];
      //---
      x_source[i] =(a-b)*cos(t)+b*cos((a/b-1)*t);
      y_source[i] =(a-b)*sin(t)+b*sin((a/b-1)*t);
     }
//--- Рассчитаем среднее
   x_mean=MathMean(x_source);
   y_mean=MathMean(y_source);
//--- Рассчитаем стандартное отклонение
   x_sdev=MathStandardDeviation(x_source);
   y_sdev=MathStandardDeviation(y_source);
//--- Корректировка для предотвращения деления на ноль
   x_sdev =(x_sdev==0)? 1 : x_sdev;
   y_sdev =(y_sdev==0)? 1 : y_sdev;
//--- Нормализуем данные
   for(int i=0; i<total; i++)
     {
      x_norm[i] =(x_source[i]-x_mean)/x_sdev;
      y_norm[i] =(y_source[i]-y_mean)/y_sdev;
     }
  }
//+------------------------------------------------------------------+
//| Устанавливает и обновляет серии на графике                       |
//+------------------------------------------------------------------+
void CProgram::UpdateSeries(void)
  {
//--- Получим указатель графика
   CGraphic *graph=m_graph1.GetGraphicPointer();
//--- Обновим все серии графика новыми данными
   int total=graph.CurvesTotal();
   if(total>0)
     {
      //--- Получим указатель кривой
      CCurve *curve=graph.CurveGetByIndex(0);
      //--- Установить массивы данных
      curve.Update(x_norm,y_norm);
      //--- Получим значения свойств кривой
      ENUM_CURVE_TYPE curve_type =(ENUM_CURVE_TYPE)m_curve_type.GetListViewPointer().SelectedItemIndex();
      ENUM_POINT_TYPE point_type =(ENUM_POINT_TYPE)m_point_type.GetListViewPointer().SelectedItemIndex();
      //--- Установить свойства
      curve.LinesSmooth(m_line_smooth.IsPressed());
      curve.PointsType(point_type);
      curve.Type(curve_type);
     }
//--- Применить 
   graph.Redraw(true);
//--- Вывести текст
   TextAdd();
//--- Обновить график
   graph.Update();
  }
//+------------------------------------------------------------------+
//| Перерасчёт серий на графике                                      |
//+------------------------------------------------------------------+
void CProgram::RecalculatingSeries(void)
  {
//--- Рассчитаем значения и инициализируем массивы
   InitArrays();
//--- Обновим серии
   UpdateSeries();
  }
//+------------------------------------------------------------------+
//| Добавляет текст на график                                        |
//+------------------------------------------------------------------+
void CProgram::TextAdd(void)
  {
//--- Получим указатель графика
   CGraphic *graph=m_graph1.GetGraphicPointer();
//---  
   int  x     =graph.ScaleX(graph.XAxis().Min())+50;
   int  y     =graph.ScaleY(graph.YAxis().Max())+10;
   int  y2    =y+20;
   uint clr   =::ColorToARGB(clrBlack);
   uint align =TA_RIGHT;
//---
   string str[8];
   str[0] ="x mean:";
   str[1] ="y mean:";
   str[2] =::DoubleToString(x_mean,2);
   str[3] =::DoubleToString(y_mean,2);
   str[4] ="x sdev:";
   str[5] ="y sdev:";
   str[6] =::DoubleToString(x_sdev,2);
   str[7] =::DoubleToString(y_sdev,2);
//--- Рассчитываем координаты и выводим текст на график
   int l_x=0,l_y=0;
   for(int i=0; i<8; i++)
     {
      if(i<2)
         l_x=x;
      else if(i<6)
         l_x=(i%2==0)? l_x+50 : l_x;
      else
         l_x=(i%2==0)? l_x+60 : l_x;
      //---
      l_y=(i%2==0)? y : y2;
      //---
      graph.TextAdd(l_x,l_y,str[i],clr,align);
     }
  }
//+------------------------------------------------------------------+
//| Обновление графика по таймеру                                    |
//+------------------------------------------------------------------+
void CProgram::UpdateGraphByTimer(void)
  {
//--- Выйти, если (1) форма свёрнута или (2) отключена анимация
   if(m_window.IsMinimized() || !m_animate.IsPressed())
      return;
//--- Анимация серий графика
   AnimateGraphSeries();
//--- Обновить массивы и серии на графике
   RecalculatingSeries();
  }
//+------------------------------------------------------------------+
//| Анимация серий графика                                           |
//+------------------------------------------------------------------+
void CProgram::AnimateGraphSeries(void)
  {
//--- Для указания направления изменения размера массивов
   static bool counter_direction=false;
//--- Переключим направление, если дошли до минимума
   if((double)m_animate.GetValue()<=(double)m_animate.MinValue())
      counter_direction=false;
//--- Переключим направление, если дошли до максимума
   if((double)m_animate.GetValue()>=(double)m_animate.MaxValue())
      counter_direction=true;
//--- Изменяем размер массива по направлению
   string value="";
   if(!counter_direction)
      value=string((double)m_animate.GetValue()+m_animate.StepValue());
   else
      value=string((double)m_animate.GetValue()-m_animate.StepValue());
//--- Установить новое значение и обновить поле ввода
   m_animate.SetValue(value,false);
   m_animate.GetTextBoxPointer().Update(true);
  }
//+------------------------------------------------------------------+
