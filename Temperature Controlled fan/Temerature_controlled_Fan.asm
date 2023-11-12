
_main:

;Temerature_controlled_Fan.c,33 :: 		void main(){
;Temerature_controlled_Fan.c,35 :: 		TRISC.F0 = TRISC.F1 = TRISC.F2 = 0x00;
	BCF        TRISC+0, 2
	BTFSC      TRISC+0, 2
	GOTO       L__main33
	BCF        TRISC+0, 1
	GOTO       L__main34
L__main33:
	BSF        TRISC+0, 1
L__main34:
	BTFSC      TRISC+0, 1
	GOTO       L__main35
	BCF        TRISC+0, 0
	GOTO       L__main36
L__main35:
	BSF        TRISC+0, 0
L__main36:
;Temerature_controlled_Fan.c,36 :: 		portc.f0 = 1;
	BSF        PORTC+0, 0
;Temerature_controlled_Fan.c,37 :: 		portc.f1 = 0;
	BCF        PORTC+0, 1
;Temerature_controlled_Fan.c,40 :: 		TRISD.F0 = TRISD.F1 = 0xff;
	BSF        TRISD+0, 1
	BTFSC      TRISD+0, 1
	GOTO       L__main37
	BCF        TRISD+0, 0
	GOTO       L__main38
L__main37:
	BSF        TRISD+0, 0
L__main38:
;Temerature_controlled_Fan.c,42 :: 		if(EEPROM_Read(0x02) == 0xff){
	MOVLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_main0
;Temerature_controlled_Fan.c,43 :: 		start = 24; //fan start temperature
	MOVLW      24
	MOVWF      _start+0
;Temerature_controlled_Fan.c,44 :: 		} else start =  EEPROM_Read(0x02);
	GOTO       L_main1
L_main0:
	MOVLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _start+0
L_main1:
;Temerature_controlled_Fan.c,45 :: 		delay_ms(30);
	MOVLW      78
	MOVWF      R12+0
	MOVLW      235
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
;Temerature_controlled_Fan.c,46 :: 		if(EEPROM_Read(0x04) == 0xff){
	MOVLW      4
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;Temerature_controlled_Fan.c,47 :: 		endd = 32;    // fan high speed at
	MOVLW      32
	MOVWF      _endd+0
;Temerature_controlled_Fan.c,48 :: 		} else  endd = EEPROM_Read(0x04);
	GOTO       L_main4
L_main3:
	MOVLW      4
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _endd+0
L_main4:
;Temerature_controlled_Fan.c,49 :: 		delay_ms(30);
	MOVLW      78
	MOVWF      R12+0
	MOVLW      235
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
;Temerature_controlled_Fan.c,51 :: 		set = 0;
	CLRF       _set+0
;Temerature_controlled_Fan.c,52 :: 		duty_speed = 0;   // speed of fan
	CLRF       _duty_speed+0
;Temerature_controlled_Fan.c,53 :: 		PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Temerature_controlled_Fan.c,54 :: 		PWM1_Start();                       // start PWM1
	CALL       _PWM1_Start+0
;Temerature_controlled_Fan.c,55 :: 		PWM1_Set_Duty(duty_speed);        // Set current duty for PWM1
	MOVF       _duty_speed+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Temerature_controlled_Fan.c,58 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Temerature_controlled_Fan.c,59 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temerature_controlled_Fan.c,60 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temerature_controlled_Fan.c,62 :: 		while(1) {
L_main6:
;Temerature_controlled_Fan.c,63 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
;Temerature_controlled_Fan.c,64 :: 		button_interfacing();
	CALL       _button_interfacing+0
;Temerature_controlled_Fan.c,66 :: 		if(set == 1){
	MOVF       _set+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;Temerature_controlled_Fan.c,67 :: 		PWM1_Set_Duty(0);
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Temerature_controlled_Fan.c,68 :: 		Lcd_Out(1,1,txt5);                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt5+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,69 :: 		IntToStr(start, st);
	MOVF       _start+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _st+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Temerature_controlled_Fan.c,70 :: 		Lcd_Out(2,5,st);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _st+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,71 :: 		}
	GOTO       L_main10
L_main9:
;Temerature_controlled_Fan.c,72 :: 		else if(set == 2){
	MOVF       _set+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;Temerature_controlled_Fan.c,73 :: 		PWM1_Set_Duty(0);
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Temerature_controlled_Fan.c,74 :: 		Lcd_Out(1,1,txt4);                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt4+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,75 :: 		IntToStr(endd, st);
	MOVF       _endd+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _st+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Temerature_controlled_Fan.c,76 :: 		Lcd_Out(2,5,st);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _st+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,77 :: 		}
	GOTO       L_main12
L_main11:
;Temerature_controlled_Fan.c,79 :: 		diff = endd-start;
	MOVF       _start+0, 0
	SUBWF      _endd+0, 0
	MOVWF      _diff+0
;Temerature_controlled_Fan.c,81 :: 		value = ADC_Read(0);            // Reading temperature
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _value+0
;Temerature_controlled_Fan.c,82 :: 		if(value <= 0) value = 0;
	MOVF       R0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L_main13
	CLRF       _value+0
L_main13:
;Temerature_controlled_Fan.c,83 :: 		tem = (unsigned short)value*0.488; // converting data into voltage amd voltage into correspoding temperature
	MOVF       _value+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVLW      35
	MOVWF      R4+0
	MOVLW      219
	MOVWF      R4+1
	MOVLW      121
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2byte+0
	MOVF       R0+0, 0
	MOVWF      _tem+0
;Temerature_controlled_Fan.c,84 :: 		IntToStr(tem, cel);          // converting the reading data into string
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _cel+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Temerature_controlled_Fan.c,85 :: 		farhen = ((tem*9)/5) + 32;     // convert temperature into farhenheit
	MOVF       _tem+0, 0
	MOVWF      R0+0
	MOVLW      9
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVLW      32
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _farhen+0
;Temerature_controlled_Fan.c,86 :: 		IntToStr(farhen, far);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _far+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Temerature_controlled_Fan.c,87 :: 		IntToStr(duty_speed , x);     // converting duty as string for virtual terminal
	MOVF       _duty_speed+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _x+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Temerature_controlled_Fan.c,98 :: 		Lcd_Out(1,1,txt1);                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,99 :: 		Lcd_Out(1,11,cel);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _cel+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,100 :: 		Lcd_Out(2,1,txt2);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,101 :: 		Lcd_Out(2,11,far);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _far+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Temerature_controlled_Fan.c,104 :: 		if(tem > start){
	MOVF       _tem+0, 0
	SUBWF      _start+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main14
;Temerature_controlled_Fan.c,105 :: 		speed = tem-start;
	MOVF       _start+0, 0
	SUBWF      _tem+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _speed+0
;Temerature_controlled_Fan.c,106 :: 		if(speed > diff) speed = diff;
	MOVF       R1+0, 0
	SUBWF      _diff+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main15
	MOVF       _diff+0, 0
	MOVWF      _speed+0
L_main15:
;Temerature_controlled_Fan.c,107 :: 		duty_speed = (255/diff)*speed;
	MOVF       _diff+0, 0
	MOVWF      R4+0
	MOVLW      255
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       _speed+0, 0
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      _duty_speed+0
;Temerature_controlled_Fan.c,108 :: 		PWM1_Set_Duty(duty_speed);        // Set current duty for PWM1
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Temerature_controlled_Fan.c,109 :: 		}
	GOTO       L_main16
L_main14:
;Temerature_controlled_Fan.c,111 :: 		duty_speed = 0;
	CLRF       _duty_speed+0
;Temerature_controlled_Fan.c,112 :: 		PWM1_Set_Duty(duty_speed);        // Set current duty for PWM1
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Temerature_controlled_Fan.c,113 :: 		}
L_main16:
;Temerature_controlled_Fan.c,115 :: 		}
L_main12:
L_main10:
;Temerature_controlled_Fan.c,116 :: 		}
	GOTO       L_main6
;Temerature_controlled_Fan.c,117 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_button_interfacing:

;Temerature_controlled_Fan.c,118 :: 		void button_interfacing()
;Temerature_controlled_Fan.c,121 :: 		if(portd.f0 == 0xff){ //INC_DEC Button
	BTFSS      PORTD+0, 0
	GOTO       L_button_interfacing17
;Temerature_controlled_Fan.c,122 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_button_interfacing18:
	DECFSZ     R13+0, 1
	GOTO       L_button_interfacing18
	DECFSZ     R12+0, 1
	GOTO       L_button_interfacing18
	DECFSZ     R11+0, 1
	GOTO       L_button_interfacing18
	NOP
;Temerature_controlled_Fan.c,123 :: 		if(portd.f0 == 0xff){
	BTFSS      PORTD+0, 0
	GOTO       L_button_interfacing19
;Temerature_controlled_Fan.c,124 :: 		if(set == 1){  // set start temperature
	MOVF       _set+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_button_interfacing20
;Temerature_controlled_Fan.c,125 :: 		start++;
	INCF       _start+0, 1
;Temerature_controlled_Fan.c,126 :: 		if(start >= endd) endd = start+1;
	MOVF       _endd+0, 0
	SUBWF      _start+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_button_interfacing21
	INCF       _start+0, 0
	MOVWF      _endd+0
L_button_interfacing21:
;Temerature_controlled_Fan.c,127 :: 		if(start == 35) start = 10;
	MOVF       _start+0, 0
	XORLW      35
	BTFSS      STATUS+0, 2
	GOTO       L_button_interfacing22
	MOVLW      10
	MOVWF      _start+0
L_button_interfacing22:
;Temerature_controlled_Fan.c,128 :: 		EEPROM_Write(0x02,start);
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _start+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Temerature_controlled_Fan.c,129 :: 		}
	GOTO       L_button_interfacing23
L_button_interfacing20:
;Temerature_controlled_Fan.c,130 :: 		else if(set == 2){
	MOVF       _set+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_button_interfacing24
;Temerature_controlled_Fan.c,131 :: 		endd++;
	INCF       _endd+0, 1
;Temerature_controlled_Fan.c,132 :: 		if(endd == 40) endd = start+1;
	MOVF       _endd+0, 0
	XORLW      40
	BTFSS      STATUS+0, 2
	GOTO       L_button_interfacing25
	INCF       _start+0, 0
	MOVWF      _endd+0
L_button_interfacing25:
;Temerature_controlled_Fan.c,133 :: 		EEPROM_Write(0x04,endd);
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _endd+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Temerature_controlled_Fan.c,134 :: 		}
L_button_interfacing24:
L_button_interfacing23:
;Temerature_controlled_Fan.c,135 :: 		}
L_button_interfacing19:
;Temerature_controlled_Fan.c,136 :: 		}
L_button_interfacing17:
;Temerature_controlled_Fan.c,137 :: 		if(portd.f1 == 0xff){  //Mode button
	BTFSS      PORTD+0, 1
	GOTO       L_button_interfacing26
;Temerature_controlled_Fan.c,138 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_button_interfacing27:
	DECFSZ     R13+0, 1
	GOTO       L_button_interfacing27
	DECFSZ     R12+0, 1
	GOTO       L_button_interfacing27
	DECFSZ     R11+0, 1
	GOTO       L_button_interfacing27
	NOP
;Temerature_controlled_Fan.c,139 :: 		if(portd.f1 == 0xff){
	BTFSS      PORTD+0, 1
	GOTO       L_button_interfacing28
;Temerature_controlled_Fan.c,140 :: 		set++;
	INCF       _set+0, 1
;Temerature_controlled_Fan.c,141 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_button_interfacing29:
	DECFSZ     R13+0, 1
	GOTO       L_button_interfacing29
	DECFSZ     R12+0, 1
	GOTO       L_button_interfacing29
	DECFSZ     R11+0, 1
	GOTO       L_button_interfacing29
	NOP
;Temerature_controlled_Fan.c,142 :: 		if(set == 4) set = 1;
	MOVF       _set+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_button_interfacing30
	MOVLW      1
	MOVWF      _set+0
L_button_interfacing30:
;Temerature_controlled_Fan.c,143 :: 		delay_ms(200) ;
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_button_interfacing31:
	DECFSZ     R13+0, 1
	GOTO       L_button_interfacing31
	DECFSZ     R12+0, 1
	GOTO       L_button_interfacing31
	DECFSZ     R11+0, 1
	GOTO       L_button_interfacing31
;Temerature_controlled_Fan.c,144 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Temerature_controlled_Fan.c,145 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temerature_controlled_Fan.c,146 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Temerature_controlled_Fan.c,147 :: 		}
L_button_interfacing28:
;Temerature_controlled_Fan.c,148 :: 		}
L_button_interfacing26:
;Temerature_controlled_Fan.c,149 :: 		}
L_end_button_interfacing:
	RETURN
; end of _button_interfacing
