//+------------------------------------------------------------------+
//|                                       protezione con licenza.mq4 |
//|                                   Corrado Bruni, Copyright ©2023 |
//|                                  https://www.cbalgotrade.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni, Copyright ©2023"
#property link      "https://www.cbalgotrade.com"
#property version   "1.02"
#property strict
#include <MyLibrary\MyLibrary.mqh>

string versione = "v1.02";

string EAname0 =                       "SquareGann";
string EAname =                        EAname0+" "+versione;
string nameText =                      EAname+" ";
string nameTextCopy;

int ClientsAccountNumber[10000] ={
27081543,
0
};
string ClientsAccountName[1000] ={
"Corrado Bruni"
};

string cbalgotrade_url = "http://www.cbalgotrade.com/";
string license_url = "wp-content/uploads/clientiSquareGann.txt";
string version_url = "wp-content/uploads/versioneSquareGann.txt";


datetime controlloAggiornamenti = 0;
datetime controlloLicenza = 0;
int controlloLicenzaDay;
bool commentTrialExpired = true;
bool commentLicenseExpired = true;

datetime TimeLicense = 0;
int numeroAccountLicense = 0;
string nomeAccount = "";
int timeoutConnection = 5000;


bool ultraLock =                       false;
bool copyRight =                       false;
bool onlyBacktest =                    false;
datetime dateOnlyBacktest =            D'2023.12.20 00:00:00';

bool License =                         false;
datetime dateLicense =                 D'2023.12.20 00:00:00';
bool Trial =                           false;
datetime dateTrial =                   D'2018.12.20 00:00:00';




int OnInit(){
   if(!InitialLicenseControl()){
      return INIT_FAILED;
   }
   
   return INIT_SUCCEEDED;
   
}

void OnDeinit(const int reason){}

void OnTick(){

   if(ultraLock){
      if(!Trial || (TimeCurrent() < dateTrial)){
         if(!copyRight || !License || (TimeCurrent() < dateLicense)){
            if(!copyRight || !onlyBacktest || (TimeCurrent() < dateOnlyBacktest)){
               if(checkTime()) checkTimeRimozione();
               
               
               // esecuzione strategia e gestione
               
               
            }
         }
         else{
            if(commentLicenseExpired){
               Print("License expired, contact cbalgotrade@gmail.com for info. Thanks!");
               commentLicenseExpired = false;
            }
         }
      }
      else{
         if(commentTrialExpired){
            Print("Trial expired, contact cbalgotrade@gmail.com for info. Thanks!");
            commentTrialExpired = false;
         }
      }
   }
}





// #### License Management ####

bool InitialLicenseControl(){

   if(checkTime()){
      checkTimeRimozione();
      return false;
   }
   
   commentTrialExpired = true;
   commentLicenseExpired = true;

   controlloAggiornamenti = controlloLicenza = TimeCurrent();
   controlloLicenzaDay = DayOfWeek()+1;
   if(DayOfWeek() == 5 || DayOfWeek() == 6 || DayOfWeek() == 0) controlloLicenzaDay = 1;
   
   if(IsTesting()){
      onlyBacktest = true;
      StringAdd(nameText,"\nTesting mode!");
   }
   else{
      if(onlyBacktest){
         StringAdd(nameText," \nOnly Backtest mode! EA "+EAname+" removed.");
         nameTextCopy = nameText;
         Print(nameText);
         ExpertRemove();
         return false;
      }
   }
   
   infoAccount();
   if(onlyBacktest) ultraLock = true;
   
   if(!ultraLock){
      StringAdd(nameText," \nContact cbalgotrade@gmail.com for info. Thanks!");
      nameTextCopy = nameText;
      Print(nameText);
      ExpertRemove();
      return false;
   }
   else{
      if(copyRight && !onlyBacktest && Trial) StringAdd(nameText,"\nTrial mode! Expiration: "+TimeToString(dateTrial));
      if(copyRight && !onlyBacktest && License){
         if(dateLicense >= D'3000.01.01 00:00:00') StringAdd(nameText,"\nLIFETIME License activated!");
         else{
            if(TimeCurrent() > dateLicense){
               StringAdd(nameText,"\nLicense expired on "+TimeToString(dateLicense)+". \nContact cbalgotrade@gmail.com for info. Thanks!");
            }
            else StringAdd(nameText,"\nLicense activated! Expiration: "+TimeToString(dateLicense));
         }
      }
      if(onlyBacktest) StringAdd(nameText,"\nBacktest mode!");
      if(!copyRight) StringAdd(nameText,"\nCopyRight released!");
   }
   
   if(!IsTesting() && checkVersion()){ StringAdd(nameText," \nNew Version!\n Download it from "+cbalgotrade_url+"profilo/");}
   
   nameTextCopy = nameText;
   Print(nameText,false);

   return true;
}

void infoAccount(){
   
   if(!copyRight){ ultraLock = true; return;}
   
   for(int Ccount=0;Ccount<1000;Ccount++){
      if(StringCompare(ClientsAccountName[Ccount],AccountName(),false) == 0){
         StringAdd(nameText,"\nAccount by name locked! OK! ");
         ultraLock = true;
         dateOnlyBacktest = dateLicense = D'3000.01.01 00:00:00';
         return;
      }
   }
   
   for(int Ccount=0;Ccount<10000;Ccount++){
      if(ClientsAccountNumber[Ccount] == AccountNumber()){
         StringAdd(nameText,"\nAccount by number locked! OK! ");
         ultraLock = true;
         dateOnlyBacktest = dateLicense = D'3000.01.01 00:00:00';
         return;
      }
   }
   
   if(!IsConnected()){
      StringAdd(nameText,"\nNo connection, impossible to check license! ");
      ultraLock = false;
      return;
   }
   
   if(licenseResearch()){
      StringAdd(nameText,"\nAccount by license locked! OK! ");
      ultraLock = true;
      dateOnlyBacktest = dateLicense;
   }
   else{
      StringAdd(nameText,"\nLicense not found! ");
      ultraLock = false;
   }
}

void checkTimeRimozione(){
   StringAdd(nameText," \nFatal Error in Time. Contact cbalgotrade@gmail.com for info. Thanks!");
   nameTextCopy = nameText;
   Print(nameText,false);
   ExpertRemove();
}

bool checkTime(){

   datetime scartoTempo = MathAbs(TimeCurrent() - TimeGMT());
   if(scartoTempo > 172800) return true;
   return false;
}

bool checkVersion(){

   ResetLastError();
   
   char post[],result[];
   string headers;
   string requestVersion_url = cbalgotrade_url+version_url;
   
   int res = WebRequest("GET",requestVersion_url,NULL,NULL,timeoutConnection,post,0,result,headers);
   if(res==-1){ 
      Print("Error in WebRequest. Error code  =",GetLastError()); 
      Print("Add the address '"+cbalgotrade_url+"' in the list of allowed URLs on tab 'Expert Advisors' in 'Options'");
      return false;
   }
   else{ 
      string newVersion = "";
      for(int a1=0;a1<ArraySize(result);a1++){
         StringAdd(newVersion,CharToString(result[a1]));
         if(result[a1] == '\n') break;
      }
      if(StringCompare(newVersion,versione,false) != 0){
         Print("New Version ("+newVersion+")!\nDownload it from "+cbalgotrade_url+"profilo/");
         Alert("New Version! EA "+EAname0+" "+newVersion+"\nDownload it from "+cbalgotrade_url+"profilo/");
         return true;
      }
   }
   return false;
}

bool licenseResearch(){

   Print("Connection for license activation...");
   ResetLastError();
   
   char post[],result[];
   string headers;
   string requestLicense_url = cbalgotrade_url+license_url;
   
   int res = WebRequest("GET",requestLicense_url,NULL,NULL,timeoutConnection,post,0,result,headers);
   if(res==-1){ 
      Print("Error in WebRequest. Error code  =",GetLastError()); 
      MessageBox("Add the address '"+cbalgotrade_url+"' in the list of allowed URLs on tab 'Expert Advisors' in 'Options'","Error",MB_ICONINFORMATION); 
      ExpertRemove();
      return false;
   }
   else{ 
      Print("Connected! Search for user license...");
      string usersLicenses[10000] = {};
      int d=0;
      for(int a1=0;a1<ArraySize(result);a1++){
         StringAdd(usersLicenses[d],CharToString(result[a1]));
         if(result[a1] == '\n') d++;
      }
      
      for(int n=0;n<d+1;n++){
         if(estrapolazioneStringa(usersLicenses[n])){
            if(numeroAccountLicense == AccountNumber()){
               if(TimeLicense >= D'3000.01.01 00:00:00') Print("User license found! License FOREVER!");
               else Print("User license found! Expiration license: "+TimeToString(TimeLicense));
               dateLicense = TimeLicense;
               return true;
            }
         }
      }
      return false;
   }
   return false;
}

bool estrapolazioneStringa(string estrapolazione){
   string result[];
   ushort u_sep = StringGetCharacter(",",0);
   int k=StringSplit(estrapolazione,u_sep,result); 
   
   if(k >= 3){
      TimeLicense = StringToTime(result[0]);
      numeroAccountLicense = (int)StringToInteger(result[1]);
      nomeAccount = result[2];
      return true;
   }
   return false;
}