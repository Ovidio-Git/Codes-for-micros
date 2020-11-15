
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;frecunciometro.c,25 :: 		void interrupt(void)  //ist
;frecunciometro.c,27 :: 		INTCON.GIE = 0; //Deshabilito todas las interrupciones
	BCF        INTCON+0, 7
;frecunciometro.c,28 :: 		if(INTCON.T0IF == 1 )
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;frecunciometro.c,30 :: 		INTCON.T0IF = 0; //Bajar la bandera
	BCF        INTCON+0, 2
;frecunciometro.c,31 :: 		ctrl[0]++;
	INCF       _ctrl+0, 1
;frecunciometro.c,32 :: 		}
L_interrupt0:
;frecunciometro.c,33 :: 		INTCON.GIE = 1;//Habilito todas las interrupciones
	BSF        INTCON+0, 7
;frecunciometro.c,35 :: 		INTCON.GIE = 0; //Deshabilito todas las interrupciones
	BCF        INTCON+0, 7
;frecunciometro.c,36 :: 		if (TMR1IF_bit==1){
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt1
;frecunciometro.c,37 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;frecunciometro.c,38 :: 		TMR1H	 = 0xFF;
	MOVLW      255
	MOVWF      TMR1H+0
;frecunciometro.c,39 :: 		TMR1L	 = 0x00;
	CLRF       TMR1L+0
;frecunciometro.c,40 :: 		frecuencia++;
	INCF       _frecuencia+0, 1
	BTFSC      STATUS+0, 2
	INCF       _frecuencia+1, 1
;frecunciometro.c,42 :: 		}
L_interrupt1:
;frecunciometro.c,43 :: 		INTCON.GIE = 1;//Habilito todas las interrupciones
	BSF        INTCON+0, 7
;frecunciometro.c,44 :: 		}
L_end_interrupt:
L__interrupt7:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;frecunciometro.c,47 :: 		int main(void)
;frecunciometro.c,50 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;frecunciometro.c,51 :: 		PORTC=0x00;
	CLRF       PORTC+0
;frecunciometro.c,52 :: 		OPTION_REG = 0x27;    //configurando timer0 como temporizador
	MOVLW      39
	MOVWF      OPTION_REG+0
;frecunciometro.c,53 :: 		T1CON=0x07;           //configurando timer1 como contador
	MOVLW      7
	MOVWF      T1CON+0
;frecunciometro.c,54 :: 		TMR0   = 0;          // inicializando timer 0 en 0
	CLRF       TMR0+0
;frecunciometro.c,55 :: 		OPTION_REG.T0CS = 0; //HABILITO EL TIMER
	BCF        OPTION_REG+0, 5
;frecunciometro.c,56 :: 		INTCON =   0xE0;     //habilitando las interrupciones del timer0
	MOVLW      224
	MOVWF      INTCON+0
;frecunciometro.c,57 :: 		PIE1=0x01;            //hablitanfo las interrupciones del timer 1
	MOVLW      1
	MOVWF      PIE1+0
;frecunciometro.c,58 :: 		TMR1H	 = 0xFF; //timer de los primeros 8 bits
	MOVLW      255
	MOVWF      TMR1H+0
;frecunciometro.c,59 :: 		TMR1L	 = 0x00; //timer de ls segundos 8 bits
	CLRF       TMR1L+0
;frecunciometro.c,60 :: 		TMR1IF_bit=0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;frecunciometro.c,64 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;frecunciometro.c,65 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,66 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;frecunciometro.c,67 :: 		Lcd_Out(2,5,"FRECUENCIA:");                 // Write text in second row
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
;frecunciometro.c,69 :: 		while(1)
L_main2:
;frecunciometro.c,71 :: 		if (ctrl[0]==16)
	MOVF       _ctrl+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;frecunciometro.c,73 :: 		ctrl[0]=0;
	CLRF       _ctrl+0
;frecunciometro.c,74 :: 		printf=1;
	MOVLW      1
	MOVWF      _printf+0
;frecunciometro.c,75 :: 		}
L_main4:
;frecunciometro.c,77 :: 		if (printf==1)
	MOVF       _printf+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;frecunciometro.c,79 :: 		IntToStr(TMR1L, text);
	MOVF       TMR1L+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _text+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;frecunciometro.c,80 :: 		Lcd_Out(3,5,text);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _text+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;frecunciometro.c,81 :: 		Lcd_Out_CP("HZ");
	MOVLW      72
	MOVWF      ?lstr2_frecunciometro+0
	MOVLW      90
	MOVWF      ?lstr2_frecunciometro+1
	CLRF       ?lstr2_frecunciometro+2
	MOVLW      ?lstr2_frecunciometro+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;frecunciometro.c,82 :: 		return -1;
	MOVLW      255
	MOVWF      R0+0
	MOVLW      255
	MOVWF      R0+1
	GOTO       L_end_main
;frecunciometro.c,83 :: 		}
L_main5:
;frecunciometro.c,85 :: 		}
	GOTO       L_main2
;frecunciometro.c,86 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
