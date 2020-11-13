
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;frecunciometro.c,23 :: 		void interrupt(void)  //ist
;frecunciometro.c,25 :: 		INTCON.GIE = 0; //Deshabilito todas las interrupciones
	BCF        INTCON+0, 7
;frecunciometro.c,26 :: 		if(INTCON.T0IF == 1)
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;frecunciometro.c,28 :: 		INTCON.T0IF = 0; //Bajar la bandera
	BCF        INTCON+0, 2
;frecunciometro.c,29 :: 		frecuencia++; //codigo a ehecuta
	INCF       _frecuencia+0, 1
	BTFSC      STATUS+0, 2
	INCF       _frecuencia+1, 1
;frecunciometro.c,31 :: 		}
L_interrupt0:
;frecunciometro.c,32 :: 		INTCON.GIE = 1;//Habilito todas las interrupciones
	BSF        INTCON+0, 7
;frecunciometro.c,33 :: 		}
L_end_interrupt:
L__interrupt6:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;frecunciometro.c,36 :: 		void main(void) {
;frecunciometro.c,38 :: 		TRISA = 0X00;
	CLRF       TRISA+0
;frecunciometro.c,39 :: 		ANSELH = 0X00;
	CLRF       ANSELH+0
;frecunciometro.c,40 :: 		TRISD = 0X00;
	CLRF       TRISD+0
;frecunciometro.c,41 :: 		PORTD = 0X00;
	CLRF       PORTD+0
;frecunciometro.c,42 :: 		OPTION_REG = 0x3F;
	MOVLW      63
	MOVWF      OPTION_REG+0
;frecunciometro.c,43 :: 		INTCON =   0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;frecunciometro.c,44 :: 		TMR0 = 0x00;
	CLRF       TMR0+0
;frecunciometro.c,45 :: 		OPTION_REG.T0CS = 0; //HABILITO EL TIMER
	BCF        OPTION_REG+0, 5
;frecunciometro.c,47 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;frecunciometro.c,49 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,50 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,51 :: 		Lcd_Out(1,6,"HOLA PERRA");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      72
	MOVWF      ?lstr1_frecunciometro+0
	MOVLW      79
	MOVWF      ?lstr1_frecunciometro+1
	MOVLW      76
	MOVWF      ?lstr1_frecunciometro+2
	MOVLW      65
	MOVWF      ?lstr1_frecunciometro+3
	MOVLW      32
	MOVWF      ?lstr1_frecunciometro+4
	MOVLW      80
	MOVWF      ?lstr1_frecunciometro+5
	MOVLW      69
	MOVWF      ?lstr1_frecunciometro+6
	MOVLW      82
	MOVWF      ?lstr1_frecunciometro+7
	MOVLW      82
	MOVWF      ?lstr1_frecunciometro+8
	MOVLW      65
	MOVWF      ?lstr1_frecunciometro+9
	CLRF       ?lstr1_frecunciometro+10
	MOVLW      ?lstr1_frecunciometro+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,53 :: 		Lcd_Out(2,6,"PERRISIMA");                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      80
	MOVWF      ?lstr2_frecunciometro+0
	MOVLW      69
	MOVWF      ?lstr2_frecunciometro+1
	MOVLW      82
	MOVWF      ?lstr2_frecunciometro+2
	MOVLW      82
	MOVWF      ?lstr2_frecunciometro+3
	MOVLW      73
	MOVWF      ?lstr2_frecunciometro+4
	MOVLW      83
	MOVWF      ?lstr2_frecunciometro+5
	MOVLW      73
	MOVWF      ?lstr2_frecunciometro+6
	MOVLW      77
	MOVWF      ?lstr2_frecunciometro+7
	MOVLW      65
	MOVWF      ?lstr2_frecunciometro+8
	CLRF       ?lstr2_frecunciometro+9
	MOVLW      ?lstr2_frecunciometro+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,54 :: 		Delay_ms(2000);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main1:
	DECFSZ     R13+0, 1
	GOTO       L_main1
	DECFSZ     R12+0, 1
	GOTO       L_main1
	DECFSZ     R11+0, 1
	GOTO       L_main1
	NOP
	NOP
;frecunciometro.c,55 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,57 :: 		Lcd_Out(1,1,"AHORA");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      65
	MOVWF      ?lstr3_frecunciometro+0
	MOVLW      72
	MOVWF      ?lstr3_frecunciometro+1
	MOVLW      79
	MOVWF      ?lstr3_frecunciometro+2
	MOVLW      82
	MOVWF      ?lstr3_frecunciometro+3
	MOVLW      65
	MOVWF      ?lstr3_frecunciometro+4
	CLRF       ?lstr3_frecunciometro+5
	MOVLW      ?lstr3_frecunciometro+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,58 :: 		Lcd_Out(2,5,"PUEDE QUE SI");                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      80
	MOVWF      ?lstr4_frecunciometro+0
	MOVLW      85
	MOVWF      ?lstr4_frecunciometro+1
	MOVLW      69
	MOVWF      ?lstr4_frecunciometro+2
	MOVLW      68
	MOVWF      ?lstr4_frecunciometro+3
	MOVLW      69
	MOVWF      ?lstr4_frecunciometro+4
	MOVLW      32
	MOVWF      ?lstr4_frecunciometro+5
	MOVLW      81
	MOVWF      ?lstr4_frecunciometro+6
	MOVLW      85
	MOVWF      ?lstr4_frecunciometro+7
	MOVLW      69
	MOVWF      ?lstr4_frecunciometro+8
	MOVLW      32
	MOVWF      ?lstr4_frecunciometro+9
	MOVLW      83
	MOVWF      ?lstr4_frecunciometro+10
	MOVLW      73
	MOVWF      ?lstr4_frecunciometro+11
	CLRF       ?lstr4_frecunciometro+12
	MOVLW      ?lstr4_frecunciometro+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,60 :: 		while(1)
L_main2:
;frecunciometro.c,62 :: 		PORTD=~PORTD;
	COMF       PORTD+0, 1
;frecunciometro.c,63 :: 		Delay_ms(100);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
;frecunciometro.c,64 :: 		ByteToStr(frecuencia, text);
	MOVF       _frecuencia+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _text+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;frecunciometro.c,66 :: 		}
	GOTO       L_main2
;frecunciometro.c,68 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
