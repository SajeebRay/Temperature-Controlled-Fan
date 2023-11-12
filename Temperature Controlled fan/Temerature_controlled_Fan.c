/**************JoyGuru***************
 *                                  *
 *     Author: Sajeeb Kumar Ray     *
 * Contact: sajeebbro2002@gmail.com *
 *                                  *
 ************************************/

// LCD module connections
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;
// End LCD module connections

unsigned short tem, farhen, duty_speed, diff, start, endd, speed, value, set;
char txt1[] = "CELCIUS: ";
char txt2[] = "FARHEN: ";
char txt5[] = "FAN ON AT: ";
char txt4[] = "HIGH SPEED AT: ";
char cel[20], far[20], x[20];
char st[20], endstr[20];
 // temperature 25 is the starting of fan and 32 is the high speed
void button_interfacing();
void main(){
  // Initiallizing the connection of Motor driver
  TRISC.F0 = TRISC.F1 = TRISC.F2 = 0x00;
  portc.f0 = 1;
  portc.f1 = 0;
  // End
  //Button Declareation
  TRISD.F0 = TRISD.F1 = 0xff;

  if(EEPROM_Read(0x02) == 0xff){
     start = 24; //fan start temperature
  } else start =  EEPROM_Read(0x02);
  delay_ms(30);
  if(EEPROM_Read(0x04) == 0xff){
     endd = 32;    // fan high speed at
  } else  endd = EEPROM_Read(0x04);
  delay_ms(30);
  
  set = 0;
  duty_speed = 0;   // speed of fan
  PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
  PWM1_Start();                       // start PWM1
  PWM1_Set_Duty(duty_speed);        // Set current duty for PWM1

//  UART1_Init(9600);
  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  
  while(1) {
    delay_ms(100);
    button_interfacing();

    if(set == 1){
       PWM1_Set_Duty(0);
       Lcd_Out(1,1,txt5);                 // Write text in first row
       IntToStr(start, st);
       Lcd_Out(2,5,st);                 // Write text in second row
    }
    else if(set == 2){
       PWM1_Set_Duty(0);
       Lcd_Out(1,1,txt4);                 // Write text in first row
       IntToStr(endd, st);
       Lcd_Out(2,5,st);                 // Write text in second row
    }
    else{
      diff = endd-start;
      //Button section end. Reading and conversion start
      value = ADC_Read(0);            // Reading temperature
      if(value <= 0) value = 0;
      tem = (unsigned short)value*0.488; // converting data into voltage amd voltage into correspoding temperature
      IntToStr(tem, cel);          // converting the reading data into string
      farhen = ((tem*9)/5) + 32;     // convert temperature into farhenheit
      IntToStr(farhen, far);
      IntToStr(duty_speed , x);     // converting duty as string for virtual terminal
      // reading end. Virtual terminal start

//      UART1_Write_Text("Temperature: ");
//      UART1_Write_Text(cel);
//      UART1_Write(13);  // add line break in vertual terminal
//      UART1_Write_Text("PWM Duty at: ");
//      UART1_Write_Text(x);
//      UART1_Write(13);  // add line break in vertual terminal
      // Virtual terminal end. LCD writting start

      Lcd_Out(1,1,txt1);                 // Write text in first row
      Lcd_Out(1,11,cel);
      Lcd_Out(2,1,txt2);                 // Write text in second row
      Lcd_Out(2,11,far);
      // LCD end. PWM fan Start

      if(tem > start){
         speed = tem-start;
         if(speed > diff) speed = diff;
         duty_speed = (255/diff)*speed;
         PWM1_Set_Duty(duty_speed);        // Set current duty for PWM1
      }
      else{
         duty_speed = 0;
         PWM1_Set_Duty(duty_speed);        // Set current duty for PWM1
      }
      //PWM end
    }
  }
}
void button_interfacing()
{
    //Button interfacting for set start and end temperature;
    if(portd.f0 == 0xff){ //INC_DEC Button
       delay_ms(100);
       if(portd.f0 == 0xff){
          if(set == 1){  // set start temperature
             start++;
             if(start >= endd) endd = start+1;
             if(start == 35) start = 10;
             EEPROM_Write(0x02,start);
          }
          else if(set == 2){
             endd++;
             if(endd == 40) endd = start+1;
             EEPROM_Write(0x04,endd);
          }
       }
    }
    if(portd.f1 == 0xff){  //Mode button
       delay_ms(100);
       if(portd.f1 == 0xff){
          set++;
          delay_ms(100);
          if(set == 4) set = 1;
          delay_ms(200) ;
          Lcd_Init();                        // Initialize LCD
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
       }
    }
}