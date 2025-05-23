
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


// per includere questo file e le relative funzioni, usare la macro #include nel file del Expert Advisor

string webstiteOfReference = "https://nfs.faireconomy.media";//https://cdn-nfs.forexfactory.net/ff_calendar_thisweek.xml
int timeoutConnectionNews = 5000;

void OnStart()
  {

checkNewsFromWeb("span class=\"date\">");ExpertRemove();
   
  }
/******
   dateNewsToExtract is the name of the news, for example "ECB Press Conference" or "Crude Oil Inventories" 
   The function return the date in this format yyyy.mm.dd hh:mm:ss
   This function analyze the news date for the week, so it needs to be checked every week
******/
void checkNewsFromWeb(string dateNewsToExtract){
   Print("Connection for date news update...");
   ResetLastError();
   
   char post[],result[];
   string headers;
   
   int res = WebRequest("GET",webstiteOfReference,NULL,NULL,timeoutConnectionNews,post,0,result,headers);
   if(res==-1){ 
      Print("Error in WebRequest. Error code  =",GetLastError()); 
      MessageBox("Add the address '"+webstiteOfReference+"' in the list of allowed URLs on tab 'Expert Advisors' in 'Options'","Error",MB_ICONINFORMATION); 
      ExpertRemove();
      //return "";
   }
   else{ 
      Print("Connected! Search for next news...");
      string news = "";
      for(int a1=0;a1<ArraySize(result);a1++){
         StringAdd(news,CharToString(result[a1]));
      }//Print("news:" ,(string)news);
      // news -->> pagina di forex factory
      
      int positionInString = 0;
      
      // il ciclo while serve per monitorare le differenti posizioni della stringa all'interno del file
      //while(positionInString >= 0)
      {
      
         // fa le ricerche della stringa ad ogni posizione successiva da quella trovata in precedenza
         positionInString = StringFind(news,dateNewsToExtract,positionInString);
        // if(positionInString < 0) return "";
         Print("positionInString: ",positionInString);
         if(StringGetCharacter(news,positionInString-1) == '<'){
            int positionInString2 = StringFind(news,"<td class=\"calendar__cell calendar__time\">",positionInString);
           Print("positionInString2: ",positionInString2); 
            int positionInString3 = StringFind(news,"<td class=\"calendar__cell calendar__currency\">",positionInString2);
           Print("positionInString3: ",positionInString3); 
            int positionInString4 = StringFind(news,"<td class=\"calendar__cell calendar__impact\"><span class=\"icon icon--ff-impact-",positionInString2);
           Print("positionInString4: ",positionInString4); 
            int positionInString5 = StringFind(news,"<span class=\"calendar__event-title\">",positionInString2);
           Print("positionInString5: ",positionInString5); 
            int positionInString6 = StringFind(news,"<li class=\"more\"><a><span>More</span><span class=\"loader\"></span>",positionInString2);
           Print("Fine dati data oggi, positionInString6: ",positionInString6); 
           
            
            string interestedDate = StringSubstr(news,positionInString2,10);
            string interestedHour = StringSubstr(news,positionInString3,7);
            
            // per convertire una stringa in una variabile datetime basta usare la funzione StringToTime(string value)
            // assicurandosi di immettere come input una stringa con questo formato yyyy.mm.dd hh:mm
            
            //return conversionDateFormat(interestedDate)+" "+conversionHourFormat(interestedHour);
         }
      }
   }
   //return "";
}

string conversionDateFormat(string interestedDateIN){
   string interestedYear = StringSubstr(interestedDateIN,6);
   string interestedMonth = StringSubstr(interestedDateIN,0,2);
   string interestedDay = StringSubstr(interestedDateIN,3,2);
   string finalInterestedDate = interestedYear+"."+interestedMonth+"."+interestedDay;
   
   return finalInterestedDate;
}

string conversionHourFormat(string interestedHourIN){
   
   string interestedHourToExtract[];
   ushort u_sep = StringGetCharacter(":",0); 
   int k=StringSplit(interestedHourIN,u_sep,interestedHourToExtract); 
   
   string interestedHourW = interestedHourToExtract[0];
   int hourToWork = (int)StringToInteger(interestedHourW);
   string interestedMinuteW = StringSubstr(interestedHourToExtract[1],0,2);
   string interestedSecondsW = "00";
   string interestedAmOrPm = StringSubstr(interestedHourToExtract[1],2,2);
   
   if(StringCompare(interestedAmOrPm,"am",false) == 0 && hourToWork == 12) hourToWork = 0;
   if(StringCompare(interestedAmOrPm,"pm",false) == 0 && hourToWork != 12) hourToWork += 12;
   interestedHourW = IntegerToString(hourToWork,2,'0');
   
   string finalInterestedHour = interestedHourW+":"+interestedMinuteW+":"+interestedSecondsW;
   
   return finalInterestedHour;
}