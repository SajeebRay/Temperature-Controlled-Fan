#line 1 "D:/Books/5th Semester/Temperature Controlled fan/Temerature_controlled_Fan.c"
#line 9 "D:/Books/5th Semester/Temperature Controlled fan/Temerature_controlled_Fan.c"
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


unsigned short tem, farhen, duty_speed, diff, start, endd, speed, value, set;
char txt1[] = "CELCIUS: ";
char txt2[] = "FARHEN: ";
char txt5[] = "FAN ON AT: ";
char txt4[] = "HIGH SPEED AT: ";
char cel[20], far[20], x[20];
char st[20], endstr[20];

void button_interfacing();
void main(){

 TRISC.F0 = TRISC.F1 = TRISC.F2 = 0x00;
 portc.f0 = 1;
 portc.f1 = 0;


 TRISD.F0 = TRISD.F1 = 0xff;

 if(EEPROM_Read(0x02) == 0xff){
 start = 24;
 } else start = EEPROM_Read(0x02);
 delay_ms(30);
 if(EEPROM_Read(0x04) == 0xff){
 endd = 32;
 } else endd = EEPROM_Read(0x04);
 delay_ms(30);

 set = 0;
 duty_speed = 0;
 PWM1_Init(5000);
 PWM1_Start();
 PWM1_Set_Duty(duty_speed);


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 while(1) {
 delay_ms(100);
 button_interfacing();

 if(set == 1){
 PWM1_Set_Duty(0);
 Lcd_Out(1,1,txt5);
 IntToStr(start, st);
 Lcd_Out(2,5,st);
 }
 else if(set == 2){
 PWM1_Set_Duty(0);
 Lcd_Out(1,1,txt4);
 IntToStr(endd, st);
 Lcd_Out(2,5,st);
 }
 else{
 diff = endd-start;

 value = ADC_Read(0);
 if(value <= 0) value = 0;
 tem = (unsigned short)value*0.488;
 IntToStr(tem, cel);
 farhen = ((tem*9)/5) + 32;
 IntToStr(farhen, far);
 IntToStr(duty_speed , x);










 Lcd_Out(1,1,txt1);
 Lcd_Out(1,11,cel);
 Lcd_Out(2,1,txt2);
 Lcd_Out(2,11,far);


 if(tem > start){
 speed = tem-start;
 if(speed > diff) speed = diff;
 duty_speed = (255/diff)*speed;
 PWM1_Set_Duty(duty_speed);
 }
 else{
 duty_speed = 0;
 PWM1_Set_Duty(duty_speed);
 }

 }
 }
}
void button_interfacing()
{

 if(portd.f0 == 0xff){
 delay_ms(100);
 if(portd.f0 == 0xff){
 if(set == 1){
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
 if(portd.f1 == 0xff){
 delay_ms(100);
 if(portd.f1 == 0xff){
 set++;
 delay_ms(100);
 if(set == 4) set = 1;
 delay_ms(200) ;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 }
 }
}
