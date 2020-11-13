
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
;frecunciometro.c,31 :: 		}
L_interrupt0:
;frecunciometro.c,32 :: 		INTCON.GIE = 1;//Habilito todas las interrupciones
	BSF        INTCON+0, 7
;frecunciometro.c,33 :: 		}
L_end_interrupt:
L__interrupt5:
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
;frecunciometro.c,52 :: 		Lcd_Out(2,4,"FRECUENCIOMETRO:");                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      70
	MOVWF      ?lstr1_frecunciometro+0
	MOVLW      82
	MOVWF      ?lstr1_frecunciometro+1
	MOVLW      69
	MOVWF      ?lstr1_frecunciometro+2
	MOVLW      67
	MOVWF      ?lstr1_frecunciometro+3
	MOVLW      85
	MOVWF      ?lstr1_frecunciometro+4
	MOVLW      69
	MOVWF      ?lstr1_frecunciometro+5
	MOVLW      78
	MOVWF      ?lstr1_frecunciometro+6
	MOVLW      67
	MOVWF      ?lstr1_frecunciometro+7
	MOVLW      73
	MOVWF      ?lstr1_frecunciometro+8
	MOVLW      79
	MOVWF      ?lstr1_frecunciometro+9
	MOVLW      77
	MOVWF      ?lstr1_frecunciometro+10
	MOVLW      69
	MOVWF      ?lstr1_frecunciometro+11
	MOVLW      84
	MOVWF      ?lstr1_frecunciometro+12
	MOVLW      82
	MOVWF      ?lstr1_frecunciometro+13
	MOVLW      79
	MOVWF      ?lstr1_frecunciometro+14
	MOVLW      58
	MOVWF      ?lstr1_frecunciometro+15
	CLRF       ?lstr1_frecunciometro+16
	MOVLW      ?lstr1_frecunciometro+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,54 :: 		while(1)
L_main1:
;frecunciometro.c,56 :: 		ByteToStr(frecuencia, text);
	MOVF       _frecuencia+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _text+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;frecunciometro.c,57 :: 		Lcd_Out(3,7,text);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _text+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,58 :: 		Lcd_Out_CP("HZ");
	MOVLW      72
	MOVWF      ?lstr2_frecunciometro+0
	MOVLW      90
	MOVWF      ?lstr2_frecunciometro+1
	CLRF       ?lstr2_frecunciometro+2
	MOVLW      ?lstr2_frecunciometro+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;frecunciometro.c,59 :: 		frecuencia++;
	INCF       _frecuencia+0, 1
	BTFSC      STATUS+0, 2
	INCF       _frecuencia+1, 1
;frecunciometro.c,60 :: 		Delay_ms(500);
	MOVLW      163
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
;frecunciometro.c,61 :: 		}
	GOTO       L_main1
;frecunciometro.c,63 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
