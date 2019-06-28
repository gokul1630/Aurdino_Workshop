//const int ledpin=13; 
int recValue;
// include the library code:
void setup() 
{ 
Serial.begin(9600); 
pinMode(13, OUTPUT); 
}

void loop() 
{ 
  if(Serial.available()>0) 
  { 
    recValue=Serial.read();

    if (recValue == 100) // If use will send value 100 from MATLAB then LED will turn ON 
     { 
       digitalWrite(13, HIGH); 
  
       } 
        if(recValue == 101) // If use will send value 101 from MATLAB then LED will turn OFF 
         { 
          digitalWrite(13, LOW); 
  
         } 
      } 
    }
