
_printf:

;_.c,1 :: 		void printf(unsigned char msg[])
;_.c,3 :: 		UART1_Write_Text(msg);
	MOVF       FARG_printf_msg+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;_.c,4 :: 		}
L_end_printf:
	RETURN
; end of _printf

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;_.c,11 :: 		void interrupt(void)
;_.c,13 :: 		INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
	BCF        INTCON+0, 7
;_.c,14 :: 		if (INTCON.T0IF == 1 ) // se chequea si el timer 0 fue el causante
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;_.c,16 :: 		INTCON.T0IF = 0;   //se baja la bandera del timer0
	BCF        INTCON+0, 2
;_.c,17 :: 		ctrl++;            // se lleva control del numero de interrupciones
	INCF       _ctrl+0, 1
;_.c,18 :: 		}
L_interrupt0:
;_.c,19 :: 		INTCON.GIE = 1;        //se Habilitan todas las interrupciones
	BSF        INTCON+0, 7
;_.c,20 :: 		}
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

;_.c,23 :: 		int main(void)
;_.c,26 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;_.c,27 :: 		PORTC = 0x00;         //se inicializa el puerto c e 0
	CLRF       PORTC+0
;_.c,28 :: 		OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
	MOVLW      36
	MOVWF      OPTION_REG+0
;_.c,29 :: 		T1CON  = 0x03;        //configurando timer1 como contador
	MOVLW      3
	MOVWF      T1CON+0
;_.c,30 :: 		TMR0   = 0;           //inicializando timer0 en 0 para segurar que este limpio
	CLRF       TMR0+0
;_.c,31 :: 		OPTION_REG.T0CS = 0;  //se habilita el timer 0
	BCF        OPTION_REG+0, 5
;_.c,32 :: 		INTCON =   0xE0;      //habilitando las interrupciones del timer0
	MOVLW      224
	MOVWF      INTCON+0
;_.c,33 :: 		TMR1H  = 0xFF;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
	MOVLW      255
	MOVWF      TMR1H+0
;_.c,34 :: 		TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1
	CLRF       TMR1L+0
;_.c,36 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;_.c,37 :: 		UART1_Write_Text("se arreglo esta mierda");
	MOVLW      115
	MOVWF      ?lstr1__+0
	MOVLW      101
	MOVWF      ?lstr1__+1
	MOVLW      32
	MOVWF      ?lstr1__+2
	MOVLW      97
	MOVWF      ?lstr1__+3
	MOVLW      114
	MOVWF      ?lstr1__+4
	MOVLW      114
	MOVWF      ?lstr1__+5
	MOVLW      101
	MOVWF      ?lstr1__+6
	MOVLW      103
	MOVWF      ?lstr1__+7
	MOVLW      108
	MOVWF      ?lstr1__+8
	MOVLW      111
	MOVWF      ?lstr1__+9
	MOVLW      32
	MOVWF      ?lstr1__+10
	MOVLW      101
	MOVWF      ?lstr1__+11
	MOVLW      115
	MOVWF      ?lstr1__+12
	MOVLW      116
	MOVWF      ?lstr1__+13
	MOVLW      97
	MOVWF      ?lstr1__+14
	MOVLW      32
	MOVWF      ?lstr1__+15
	MOVLW      109
	MOVWF      ?lstr1__+16
	MOVLW      105
	MOVWF      ?lstr1__+17
	MOVLW      101
	MOVWF      ?lstr1__+18
	MOVLW      114
	MOVWF      ?lstr1__+19
	MOVLW      100
	MOVWF      ?lstr1__+20
	MOVLW      97
	MOVWF      ?lstr1__+21
	CLRF       ?lstr1__+22
	MOVLW      ?lstr1__+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;_.c,39 :: 		while(1)
L_main1:
;_.c,48 :: 		if (ctrl==123)
	MOVF       _ctrl+0, 0
	XORLW      123
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;_.c,50 :: 		print=1;
	MOVLW      1
	MOVWF      _print+0
;_.c,51 :: 		}
L_main3:
;_.c,52 :: 		if (print==1)
	MOVF       _print+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;_.c,54 :: 		IntToStr(TMR1L, text); //imprimimos el valor acumulado en TIM1L
	MOVF       TMR1L+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _text+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;_.c,55 :: 		printf(text);
	MOVLW      _text+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,56 :: 		printf("HZ\r\n");
	MOVLW      72
	MOVWF      ?lstr2__+0
	MOVLW      90
	MOVWF      ?lstr2__+1
	MOVLW      13
	MOVWF      ?lstr2__+2
	MOVLW      10
	MOVWF      ?lstr2__+3
	CLRF       ?lstr2__+4
	MOVLW      ?lstr2__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,57 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_main
;_.c,58 :: 		}
L_main4:
;_.c,59 :: 		}
	GOTO       L_main1
;_.c,60 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
