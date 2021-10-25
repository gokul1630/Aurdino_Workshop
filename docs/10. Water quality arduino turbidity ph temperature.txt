#include<LiquidCrystal.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#define ONE_WIRE_BUS 9
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
LiquidCrystal lcd(7,6,5,4,3,2);
int soil = 8;
int ph = A2;
int led_Pin = 13;
int temp = 0, max_sms = 5;
int j = 0;
char mobile_no0[10] = {'\0'};
char mobile_no1[10] = {'\0'};
char mobile_no2[10] = {'\0'};
char mobile_no3[10] = {'\0'};
char mobile_no4[10] = {'\0'};

int call = 0, stops = 0,z = 0, flag = 0;
char a[10] = {'\0'};

void gsm_init()
{
  Serial.print("AT" );
  Serial.print('\r');
  delay(150);
  Serial.print("AT" );
  Serial.print('\r');
  delay(150);
  Serial.print("AT+CMGF=1");
  Serial.print('\r');
  delay(150);
  Serial.print("AT+CNMI=2,2,00");
  Serial.print('\r');
  delay(150);
  Serial.print("ATS0=1");
  Serial.print('\r');
  delay(150);
}

void read_mobile_number_sim()
{
  int number_i = 0;
  int number_j = 0;
  char z[15] = {'\0'};
  int exits = 0, flag = 0;

  lcd.setCursor(0, 0);
  lcd.print("  READ NUMBER   ");
  do
  {
    digitalWrite(led_Pin, HIGH);
    lcd.setCursor(0, 0);
    lcd.print("  READ NUMBER");
    lcd.print(number_j);
    lcd.print("  ");
  
    Serial.print("AT+CPBF=\"NUMBER");
    Serial.print(number_j);
    Serial.print('"');
    Serial.print('\r');
    
    exits = 0;

    for(number_i = 0;number_i < 15;number_i++)
      z[number_i] = '\0';
      
    
    do
    {
      if (Serial.available())
      {
        z[number_i] = Serial.read();
    
        if(z[number_i] == '"' && flag == 0)
        {
          flag = 1;
        }
        
        else if(z[number_i] != '"' && flag == 4)
        {       
          if(number_j == 0) 
            mobile_no0[number_i] = z[number_i];

          else if(number_j == 1) 
            mobile_no1[number_i] = z[number_i];

          else if(number_j == 2) 
            mobile_no2[number_i] = z[number_i];

          else if(number_j == 3) 
            mobile_no3[number_i] = z[number_i];

          else if(number_j == 4) 
            mobile_no4[number_i] = z[number_i];
            
          number_i++;
        }
        else if(z[number_i] == '"' && flag == 4)
        {
          exits = 1;
        }
      }
    }while(exits == 0);
    
    delay(250);
    digitalWrite(led_Pin, LOW);
    delay(250);
    
  lcd.setCursor(0, 1);
  lcd.print("   ");
  if(number_j == 0)       lcd.print(mobile_no0);
  else if(number_j == 1)  lcd.print(mobile_no1);
  else if(number_j == 2)  lcd.print(mobile_no2);
  else if(number_j == 3)  lcd.print(mobile_no3);
  else if(number_j == 4)  lcd.print(mobile_no4);
  lcd.print("   ");
  delay(500);
        
    number_j++;
  }while(number_j < 5);

  max_sms = 0;
  
  if(mobile_no0[0] != '0')
    max_sms++;

  if(mobile_no1[0] != '0')
    max_sms++;

  if(mobile_no2[0] != '0')
    max_sms++;

  if(mobile_no3[0] != '0')
    max_sms++;

  if(mobile_no4[0] != '0')
    max_sms++;
}

int mois_value = 0, sensorvalue = 0, phvalue = 0, t = 0;

void sms(int condition)
{  
  
  int number_i = 0;
  int number_j = 0;
  int lcd_nums = 0;

  for(number_j = 0; number_j < max_sms; number_j++)
  {
    digitalWrite(led_Pin, HIGH);
    lcd_nums = number_j;
    
  
    for(number_i = 0;number_i < 10;number_i++)
    {
      if(number_j == 0)
        Serial.print(mobile_no0[number_i]);

      else if(number_j == 1)
        Serial.print(mobile_no1[number_i]);

      else if(number_j == 2)
        Serial.print(mobile_no2[number_i]);

      else if(number_j == 3)
        Serial.print(mobile_no3[number_i]);

      else if(number_j == 4)
        Serial.print(mobile_no4[number_i]);
    }
    Serial.print('"');
    Serial.print('\r');
    delay(500);
    
    //Serial.println("WATER PARAMETERS");
      
    lcd.setCursor(0, 0);
  
    if(condition == 1)      
    {
      Serial.println("WATER PARAMETERS,\r\n\r\nGood Water !!!\r\n\r\nTemperature : 32C \r\npH : 6.5 \r\nTurbidity :1 NTU \r\nMoisture : Normal");
    }
    else if(condition == 2) Serial.println("WATER PARAMETERS,\r\n\r\nBad Water !!! \r\n\r\nTemperature : 38C \r\npH : 9 \r\nTurbidity :5 NTU \r\nMoisture : Low");
    else if(condition == 3)
    {
      Serial.println("WATER PARAMETERS,\r\n\r\nCurrent State !!! \r\n\r\nTemperature : ");
      Serial.print(t);
      Serial.print("C \r\npH : ");
      Serial.print(phvalue);
      Serial.print("\r\nTurbidity : ");
      Serial.print(sensorvalue);
      Serial.print(" NTU \r\nMoisture : ");
      if(mois_value == 0) Serial.print("Low");
      else  Serial.print("Normal");
    }
    Serial.write(26);
    lcd.clear();
    lcd.setCursor(0, 1);
    lcd.print("SMS:");
    lcd.print(lcd_nums);
    lcd.print(":");
    for(number_i = 0;number_i < 10;number_i++)
    {
      if(lcd_nums == 0)
        lcd.print(mobile_no0[number_i]);

      else if(lcd_nums == 1)
        lcd.print(mobile_no1[number_i]);

      else if(lcd_nums == 2)
        lcd.print(mobile_no2[number_i]);

      else if(lcd_nums == 3)
        lcd.print(mobile_no3[number_i]);

      else if(lcd_nums == 4)
        lcd.print(mobile_no4[number_i]);
    }
    delay(4000); 
    digitalWrite(led_Pin, LOW);
    delay(1000); 
  }
}

void gsm_booting()
{
  lcd.setCursor(0, 0);
  lcd.print("  GSM  BOOTING  ");
  lcd.setCursor(0, 1);
  
  temp = 0;
  do
  {
    if(temp%2 == 0)
    {
      digitalWrite(led_Pin, HIGH);
    }
    else
    {
      digitalWrite(led_Pin, LOW);
    }
    temp++;
    lcd.print('.');
    delay(1000);
  }while(temp < 16);

  lcd.setCursor(0, 1);
  temp = 0;
  do
  {
    if(temp%2 == 0)
    {
      digitalWrite(led_Pin, HIGH);
    }
    else
    {
      digitalWrite(led_Pin, LOW);
    }
    temp++;
    lcd.print('-');
    delay(1000);
  }while(temp < 16);  
  
}

String serialResponse = "";
int starts = 0;
int delay_ms = 0;

void read_new_sms()
{
  if(Serial.available())
  {  
    delay_ms = 0;
    serialResponse = Serial.readStringUntil('\r\n');
  }

  if(serialResponse != "")
  {
    if(serialResponse[0] == '*')
    {
      if(serialResponse.indexOf("*GOOD#") >= 0)      
      {
        starts = 1;
        sms(1);
      }
      else if(serialResponse.indexOf("*BAD#") >= 0)      
      {
        starts = 0;
        sms(2);
      }
    }
    serialResponse = "";
  }
}
void setup()
{
  lcd.begin(16,2);
  Serial.begin(9600);
  pinMode(13,OUTPUT);
  sensors.begin();
  gsm_booting();
  gsm_init();
  read_mobile_number_sim();
  pinMode(soil,INPUT);
  pinMode(A0,INPUT);
  pinMode(ph,INPUT);
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("     WELCOME            ");
  lcd.setCursor(0,1);
  lcd.print("_________________________");
  delay(1000);
}
void loop()
{
  delay_ms = 0;
   do
   {
     read_new_sms();
     delay(1);
     delay_ms++;
   }while(delay_ms < 2000);
   
   sensors.requestTemperatures();
   int readsoil = digitalRead(soil);
   int readph = analogRead(A1);
   sensorvalue = analogRead(A0);
   t = sensors.getTempCByIndex(0);
   phvalue = readph/146;
   lcd.clear();
   lcd.setCursor(0,0);
   lcd.print("TEM:");
   lcd.print(t);
   lcd.print("C pH:");
   lcd.print(phvalue);
   lcd.print("  ");
   
   lcd.print(j);
   
  if(readsoil == LOW)
  {
    mois_value = 1;
    lcd.setCursor(6,1);
    lcd.print("MOI:NORMAL");
  }
  else
  {    
    mois_value = 0;
    lcd.setCursor(6,1);
    lcd.print("MOI: LOW  ");
  }
  
  if(sensorvalue > 1000)
  {
    sensorvalue=0;
    lcd.setCursor(0,1);
    lcd.print("TY:");
    lcd.print(sensorvalue);
  }
  else
  {
    lcd.setCursor(0,1);
    lcd.print("TY:");
    lcd.print(sensorvalue);
  }
  j = j + 1;
  if( j > 30)
  {
      sms(3);
      j = 0;
  }

}