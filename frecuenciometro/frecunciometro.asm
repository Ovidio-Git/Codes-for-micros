
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;frecunciometro.c,21 :: 		void interrupt(void)
;frecunciometro.c,23 :: 		INTCON.GIE = 0;       // Se deshabilitan todas las interrupciones
	BCF        INTCON+0, 7
;frecunciometro.c,24 :: 		if(INTCON.T0IF == 1 ) // se chequea si el timer 1 fue el causante
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;frecunciometro.c,26 :: 		INTCON.T0IF = 0;   //se baja la bandera del timer 1
	BCF        INTCON+0, 2
;frecunciometro.c,27 :: 		ctrl++;            // se lleva control del numero de interrupciones
	INCF       _ctrl+0, 1
;frecunciometro.c,28 :: 		}
L_interrupt0:
;frecunciometro.c,29 :: 		INTCON.GIE = 1;       //se Habilitan todas las interrupciones
	BSF        INTCON+0, 7
;frecunciometro.c,30 :: 		}
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

;frecunciometro.c,33 :: 		int main(void)
;frecunciometro.c,36 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;frecunciometro.c,37 :: 		PORTC = 0x00;         //se inicializa el puerto c e 0
	CLRF       PORTC+0
;frecunciometro.c,38 :: 		OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
	MOVLW      36
	MOVWF      OPTION_REG+0
;frecunciometro.c,39 :: 		T1CON  = 0x03;           //configurando timer1 como contador
	MOVLW      3
	MOVWF      T1CON+0
;frecunciometro.c,40 :: 		TMR0   = 0;           //inicializando timer0 en 0 para segurar que este limpio
	CLRF       TMR0+0
;frecunciometro.c,41 :: 		OPTION_REG.T0CS = 0;  //se habilita el timer 0
	BCF        OPTION_REG+0, 5
;frecunciometro.c,42 :: 		INTCON =   0xE0;      //habilitando las interrupciones del timer0
	MOVLW      224
	MOVWF      INTCON+0
;frecunciometro.c,43 :: 		TMR1H  = 0xFF;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
	MOVLW      255
	MOVWF      TMR1H+0
;frecunciometro.c,44 :: 		TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1
	CLRF       TMR1L+0
;frecunciometro.c,48 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;frecunciometro.c,49 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,50 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,51 :: 		Lcd_Out(2,5,"FRECUENCIA:");        // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
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
	MOVLW      65
	MOVWF      ?lstr1_frecunciometro+9
	MOVLW      58
	MOVWF      ?lstr1_frecunciometro+10
	CLRF       ?lstr1_frecunciometro+11
	MOVLW      ?lstr1_frecunciometro+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,53 :: 		while(1)
L_main1:
;frecunciometro.c,62 :: 		if (ctrl==123)
	MOVF       _ctrl+0, 0
	XORLW      123
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;frecunciometro.c,64 :: 		printf=1;
	MOVLW      1
	MOVWF      _printf+0
;frecunciometro.c,65 :: 		}
L_main3:
;frecunciometro.c,66 :: 		if (printf==1)
	MOVF       _printf+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;frecunciometro.c,68 :: 		IntToStr(TMR1L, text); //imprimimos el valor acumulado en TIM1L
	MOVF       TMR1L+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _text+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;frecunciometro.c,69 :: 		Lcd_Out(3,5,text);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _text+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,70 :: 		Lcd_Out_CP("HZ");
	MOVLW      72
	MOVWF      ?lstr2_frecunciometro+0
	MOVLW      90
	MOVWF      ?lstr2_frecunciometro+1
	CLRF       ?lstr2_frecunciometro+2
	MOVLW      ?lstr2_frecunciometro+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;frecunciometro.c,71 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_main
;frecunciometro.c,72 :: 		}
L_main4:
;frecunciometro.c,74 :: 		}
	GOTO       L_main1
;frecunciometro.c,75 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
