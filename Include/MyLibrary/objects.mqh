#include <MyLibrary\MyLibrary.mqh>
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Lezione 26 MQL5                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Funzioni customizzate per gli oggetti                            |
//+------------------------------------------------------------------+

void createBlackBoard(long chartID,const string object_name,int positionXin,int positionYin,int xSize,int ySize,color object_BGcolor=clrBlack,int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_RECTANGLE_LABEL,sub_window,0,0)){ printError("Errore nel creare la blackBoard"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(chartID,object_name,OBJPROP_XDISTANCE,positionXin);
   ObjectSetInteger(chartID,object_name,OBJPROP_YDISTANCE,positionYin);
   ObjectSetInteger(chartID,object_name,OBJPROP_XSIZE,xSize);
   ObjectSetInteger(chartID,object_name,OBJPROP_YSIZE,ySize);
   ObjectSetInteger(chartID,object_name,OBJPROP_BGCOLOR,object_BGcolor);
   ObjectSetInteger(chartID,object_name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
}

string obj_BlackBoard = "Blackboard";

void createBlackBoard(long chartID,int positionXin,int positionYin,int xSize,int ySize,color object_BGcolor=clrBlack,int sub_window=0){
   createBlackBoard(chartID,obj_BlackBoard,positionXin,positionYin,xSize,ySize,object_BGcolor,sub_window);
}

void createButton(long chartID,const string object_name,const string objText,int xDistance,int yDistance,int xSize,int ySize,color object_BGcolor,color object_TextColor,int fontSize=8,string fontStyle="Arial",int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_BUTTON,sub_window,0,0)){ printError("Errore nel creare l'oggetto pulsante"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(chartID,object_name,OBJPROP_XDISTANCE,xDistance);
   ObjectSetInteger(chartID,object_name,OBJPROP_YDISTANCE,yDistance); 
   ObjectSetInteger(chartID,object_name,OBJPROP_XSIZE,xSize); 
   ObjectSetInteger(chartID,object_name,OBJPROP_YSIZE,ySize);
   ObjectSetInteger(chartID,object_name,OBJPROP_FONTSIZE,fontSize);
   ObjectSetInteger(chartID,object_name,OBJPROP_BGCOLOR,object_BGcolor);
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_TextColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_BORDER_COLOR,clrDarkGreen);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_STATE,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
   ObjectSetString(chartID,object_name,OBJPROP_FONT,fontStyle); 
}

void createEdit(long chartID,const string object_name,const string objText,int xDistance,int yDistance,int xSize,int ySize,color object_BGcolor,color object_TextColor,int fontSize=8,string fontStyle="Arial",int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_EDIT,sub_window,0,0)){ printError("Errore nel creare l'edit"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(chartID,object_name,OBJPROP_XDISTANCE,xDistance); 
   ObjectSetInteger(chartID,object_name,OBJPROP_YDISTANCE,yDistance);
   ObjectSetInteger(chartID,object_name,OBJPROP_XSIZE,xSize); 
   ObjectSetInteger(chartID,object_name,OBJPROP_YSIZE,ySize);
   ObjectSetInteger(chartID,object_name,OBJPROP_FONTSIZE,fontSize);
   ObjectSetInteger(chartID,object_name,OBJPROP_READONLY,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_BGCOLOR,object_BGcolor);
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_TextColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_BORDER_COLOR,clrDarkGreen);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_STATE,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
   ObjectSetString(chartID,object_name,OBJPROP_FONT,fontStyle);
}

void createLabel(long chartID,const string object_name,const string objText,int xDistance,int yDistance,int fontSize,color object_TextColor,string fontStyle="Arial",int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_LABEL,sub_window,0,0)){ printError("Errore nel creare il label "+object_name); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(chartID,object_name,OBJPROP_XDISTANCE,xDistance); 
   ObjectSetInteger(chartID,object_name,OBJPROP_YDISTANCE,yDistance);
   ObjectSetInteger(chartID,object_name,OBJPROP_FONTSIZE,fontSize);
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_TextColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
   ObjectSetString(chartID,object_name,OBJPROP_FONT,fontStyle); 
}

void createImageLabel(long chartID,const string object_name,int xDistance,int yDistance,int xSize,int ySize,string imageOnMode,string imageOffMode="",int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_BITMAP_LABEL,sub_window,0,0)){ printError("Errore nel creare l'immagine label"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(chartID,object_name,OBJPROP_XDISTANCE,xDistance); 
   ObjectSetInteger(chartID,object_name,OBJPROP_YDISTANCE,yDistance);
   ObjectSetInteger(chartID,object_name,OBJPROP_XSIZE,xSize); 
   ObjectSetInteger(chartID,object_name,OBJPROP_YSIZE,ySize);
   
   if(!ObjectSetString(chartID,object_name,OBJPROP_BMPFILE,0,imageOnMode)){ 
      printError("Caricamento immagine fallito per la modalità On");
      ObjectDelete(chartID,object_name);
      return;
   }
   if(StringIsEmpty(imageOffMode)) imageOffMode = imageOnMode;
   if(!ObjectSetString(chartID,object_name,OBJPROP_BMPFILE,1,imageOffMode)){ 
      printError("Caricamento immagine fallito per la modalità Off");
      ObjectDelete(chartID,object_name);
      return;
   }
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
}

void createHLine(long chartID,const string object_name,const string objText,double linePrice,color object_LineColor,int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_HLINE,sub_window,0,linePrice)){ printError("Errore nel creare la linea orizzontale"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_LineColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
}

void createVLine(long chartID,const string object_name,const string objText,datetime locationVLine,color object_LineColor,int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_VLINE,sub_window,locationVLine,0)){ printError("Errore nel creare la linea verticale"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_LineColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
}

void createTrendLine(long chartID,const string object_name,const string objText,datetime time1,double price1,datetime time2,double price2,bool ray_right,int style,color object_LineColor,int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_TREND,sub_window,time1,price1,time2,price2)){ printError("Errore nel creare la trend-line"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_LineColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_STYLE,style); 
   ObjectSetInteger(chartID,object_name,OBJPROP_RAY_RIGHT,ray_right); 
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
}

void createGannLine(long chartID,const string object_name,const string objText,datetime time1,double price1,datetime time2,double price2,double angle,double scale,bool ray_right,int style,color object_LineColor,int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_GANNLINE,sub_window,time1,price1,time2,price2,angle,scale)){ printError("Errore nel creare la Gann-line"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,object_LineColor);
   ObjectSetInteger(chartID,object_name,OBJPROP_STYLE,style); 
   ObjectSetInteger(chartID,object_name,OBJPROP_RAY_RIGHT,ray_right); 
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
}
void createArrow(long chartID,const string object_name,const string objText,datetime time1,double price1,int size,int arrowCode,color colorArrow,int sub_window=0){
   if(!ObjectCreate(chartID,object_name,OBJ_ARROW,sub_window,time1,price1)){ printError("Errore nel creare la freccia"); return;}
   ObjectSetInteger(chartID,object_name,OBJPROP_WIDTH,size);
   ObjectSetInteger(chartID,object_name,OBJPROP_ARROWCODE,arrowCode);
   ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,colorArrow);
   ObjectSetInteger(chartID,object_name,OBJPROP_BACK,false); 
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chartID,object_name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chartID,object_name,OBJPROP_HIDDEN,false);
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,objText);
}

bool ObjectSetPrice(long chartID,const string object_name,double price){   return ObjectSetDouble(chartID,object_name,OBJPROP_PRICE,price);}
bool ObjectExist(long chartID,string object_name){                     		return ObjectFind(chartID,object_name) >= 0;}

void drawLine(long chartID,string nameLine,double price,string text="",color colorLine=clrBlue){
   if(ObjectExist(chartID,nameLine)){
      ObjectSetDouble(chartID,nameLine,OBJPROP_PRICE,price);
      if(!StringIsEmpty(text)) ObjectSetText(chartID,nameLine,text);
   }
   else{
      createHLine(0,nameLine,text,price,colorLine);
   }
}

void drawVLine(long chartID,string nameLine,datetime dateLocationLine,string text="",color colorLine=clrBlue){
   if(ObjectExist(chartID,nameLine)){
      ObjectSetInteger(chartID,nameLine,OBJPROP_TIME,dateLocationLine);
      if(!StringIsEmpty(text)) ObjectSetText(chartID,nameLine,text);
   }
   else{
      createVLine(chartID,nameLine,text,dateLocationLine,colorLine);
   }
}

void drawArrow(long chartID,string arrowName,datetime dateLocation,double priceLocation,int sizeArrow,int arrowCode,string text="",color colorArrow=clrBlue){
   if(ObjectExist(chartID,arrowName)){
      ObjectSetInteger(chartID,arrowName,OBJPROP_TIME,dateLocation);
      ObjectSetDouble(chartID,arrowName,OBJPROP_PRICE,priceLocation);
      if(!StringIsEmpty(text)) ObjectSetText(chartID,arrowName,text);
   }
   else{
      createArrow(chartID,arrowName,text,dateLocation,priceLocation,sizeArrow,arrowCode,colorArrow);
   }
}

void ObjectsDeleteTradeArrows(long chartID=0,int sub_window=0){
   ObjectsDeleteAll(chartID,sub_window,OBJ_ARROW);
   ObjectsDeleteAll(chartID,"#",sub_window,OBJ_TREND);
   ChartRedraw();
}
void  cleanChartFromTradeArrows(){
   ObjectsDeleteTradeArrows();
}

void ObjectsDelete(long chartID,string &nameObjects[]){
   for(int i=0;i<ArraySize(nameObjects);i++)
      if(ObjectExist(chartID,nameObjects[i]))
         if(!ObjectDelete(chartID,nameObjects[i])) printError("Errore nell'eliminare l'oggetto");
   ChartRedraw();
}

void ObjectSetText(long chartID,string object_name,string textToSet,color BGcolorToSet=clrNONE,color textColorToSet=clrNONE,color borderColorToSet=clrNONE){
   ObjectSetString(chartID,object_name,OBJPROP_TEXT,textToSet);
   if(BGcolorToSet != clrNONE)      ObjectSetInteger(chartID,object_name,OBJPROP_BGCOLOR,BGcolorToSet);
   if(textColorToSet != clrNONE)    ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,textColorToSet);
   if(borderColorToSet != clrNONE)  ObjectSetInteger(chartID,object_name,OBJPROP_BORDER_COLOR,borderColorToSet);
}

string ObjectGetText(long chartID,string object_name){                return ObjectGetString(chartID,object_name,OBJPROP_TEXT);}
bool   ObjectGetState(long chartID,string object_name){               return (bool)ObjectGetInteger(chartID,object_name,OBJPROP_STATE);}
bool   ObjectIsSelected(long chartID,string object_name){             return (bool)ObjectGetInteger(chartID,object_name,OBJPROP_SELECTED);}
bool   ObjectSetState(long chartID,string object_name,bool newState){ return ObjectSetInteger(chartID,object_name,OBJPROP_STATE,newState);}

void ObjectSetColor(long chartID,string object_name,color BGcolorToSet,color textColorToSet=clrNONE,color borderColorToSet=clrNONE){
   if(BGcolorToSet != clrNONE)      ObjectSetInteger(chartID,object_name,OBJPROP_BGCOLOR,BGcolorToSet);
   if(textColorToSet != clrNONE)    ObjectSetInteger(chartID,object_name,OBJPROP_COLOR,textColorToSet);
   if(borderColorToSet != clrNONE)  ObjectSetInteger(chartID,object_name,OBJPROP_BORDER_COLOR,borderColorToSet);
}