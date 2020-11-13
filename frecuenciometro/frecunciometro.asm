
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;frecunciometro.c,4 :: 		void interrupt(void)  //ist
;frecunciometro.c,6 :: 		INTCON.GIE = 0; //Deshabilito todas las interrupciones
	BCF        INTCON+0, 7
;frecunciometro.c,7 :: 		if(INTCON.T0IF == 1)
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;frecunciometro.c,9 :: 		INTCON.T0IF = 0; //Bajar la bandera
	BCF        INTCON+0, 2
;frecunciometro.c,10 :: 		frecuencia++; //codigo a ehecuta
	INCF       _frecuencia+0, 1
	BTFSC      STATUS+0, 2
	INCF       _frecuencia+1, 1
;frecunciometro.c,12 :: 		}
L_interrupt0:
;frecunciometro.c,13 :: 		INTCON.GIE = 1;//Habilito todas las interrupciones
	BSF        INTCON+0, 7
;frecunciometro.c,14 :: 		}
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

;frecunciometro.c,17 :: 		void main(void) {
;frecunciometro.c,19 :: 		TRISA = 0X00;
	CLRF       TRISA+0
;frecunciometro.c,20 :: 		ANSELH = 0X00;
	CLRF       ANSELH+0
;frecunciometro.c,21 :: 		TRISD = 0X00;
	CLRF       TRISD+0
;frecunciometro.c,22 :: 		PORTD = 0X00;
	CLRF       PORTD+0
;frecunciometro.c,23 :: 		OPTION_REG = 0x3F;
	MOVLW      63
	MOVWF      OPTION_REG+0
;frecunciometro.c,24 :: 		INTCON =   0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;frecunciometro.c,25 :: 		TMR0 = 0x00;
	CLRF       TMR0+0
;frecunciometro.c,26 :: 		OPTION_REG.T0CS = 0; //HABILITO EL TIMER
	BCF        OPTION_REG+0, 5
;frecunciometro.c,28 :: 		UART1_Init(9600);
	MOVLW      6
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;frecunciometro.c,29 :: 		UART1_Write_Text("frecenciometro");
	MOVLW      102
	MOVWF      ?lstr1_frecunciometro+0
	MOVLW      114
	MOVWF      ?lstr1_frecunciometro+1
	MOVLW      101
	MOVWF      ?lstr1_frecunciometro+2
	MOVLW      99
	MOVWF      ?lstr1_frecunciometro+3
	MOVLW      101
	MOVWF      ?lstr1_frecunciometro+4
	MOVLW      110
	MOVWF      ?lstr1_frecunciometro+5
	MOVLW      99
	MOVWF      ?lstr1_frecunciometro+6
	MOVLW      105
	MOVWF      ?lstr1_frecunciometro+7
	MOVLW      111
	MOVWF      ?lstr1_frecunciometro+8
	MOVLW      109
	MOVWF      ?lstr1_frecunciometro+9
	MOVLW      101
	MOVWF      ?lstr1_frecunciometro+10
	MOVLW      116
	MOVWF      ?lstr1_frecunciometro+11
	MOVLW      114
	MOVWF      ?lstr1_frecunciometro+12
	MOVLW      111
	MOVWF      ?lstr1_frecunciometro+13
	CLRF       ?lstr1_frecunciometro+14
	MOVLW      ?lstr1_frecunciometro+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;frecunciometro.c,31 :: 		while(1)
L_main1:
;frecunciometro.c,33 :: 		PORTD=~PORTD;
	COMF       PORTD+0, 1
;frecunciometro.c,34 :: 		Delay_ms(100);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	NOP
;frecunciometro.c,35 :: 		}
	GOTO       L_main1
;frecunciometro.c,37 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
