
_printf:

;_.c,36 :: 		void printf(unsigned char msg[])
;_.c,38 :: 		UART1_Write_Text(msg);
	MOVF       FARG_printf_msg+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;_.c,39 :: 		}
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

;_.c,44 :: 		void interrupt(void)
;_.c,46 :: 		INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
	BCF        INTCON+0, 7
;_.c,47 :: 		if (INTCON.T0IF == 1 ) // se chequea si el timer 0 fue el causante
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;_.c,49 :: 		INTCON.T0IF = 0;   //se baja la bandera del timer0
	BCF        INTCON+0, 2
;_.c,50 :: 		ctrl++;            // se lleva control del numero de interrupciones
	INCF       _ctrl+0, 1
;_.c,51 :: 		}
L_interrupt0:
;_.c,52 :: 		INTCON.GIE = 1;        //se Habilitan todas las interrupciones
	BSF        INTCON+0, 7
;_.c,53 :: 		}
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

;_.c,56 :: 		int main(void)
;_.c,59 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;_.c,60 :: 		PORTC = 0x00;         //se inicializa el puerto c e 0
	CLRF       PORTC+0
;_.c,61 :: 		OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
	MOVLW      36
	MOVWF      OPTION_REG+0
;_.c,62 :: 		T1CON  = 0x03;        //configurando timer1 como contador
	MOVLW      3
	MOVWF      T1CON+0
;_.c,63 :: 		TMR0   = 0;           //inicializando timer0 en 0 para segurar que este limpio
	CLRF       TMR0+0
;_.c,64 :: 		OPTION_REG.T0CS = 0;  //se habilita el timer 0
	BCF        OPTION_REG+0, 5
;_.c,65 :: 		INTCON =   0xE0;      //habilitando las interrupciones del timer0
	MOVLW      224
	MOVWF      INTCON+0
;_.c,66 :: 		TMR1H  = 0x00;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
	CLRF       TMR1H+0
;_.c,67 :: 		TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1
	CLRF       TMR1L+0
;_.c,69 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;_.c,70 :: 		UART1_Write_Text("FRECUENCIA:\n\r");
	MOVLW      70
	MOVWF      ?lstr1__+0
	MOVLW      82
	MOVWF      ?lstr1__+1
	MOVLW      69
	MOVWF      ?lstr1__+2
	MOVLW      67
	MOVWF      ?lstr1__+3
	MOVLW      85
	MOVWF      ?lstr1__+4
	MOVLW      69
	MOVWF      ?lstr1__+5
	MOVLW      78
	MOVWF      ?lstr1__+6
	MOVLW      67
	MOVWF      ?lstr1__+7
	MOVLW      73
	MOVWF      ?lstr1__+8
	MOVLW      65
	MOVWF      ?lstr1__+9
	MOVLW      58
	MOVWF      ?lstr1__+10
	MOVLW      10
	MOVWF      ?lstr1__+11
	MOVLW      13
	MOVWF      ?lstr1__+12
	CLRF       ?lstr1__+13
	MOVLW      ?lstr1__+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;_.c,72 :: 		while(1)
L_main1:
;_.c,81 :: 		if (ctrl==123)
	MOVF       _ctrl+0, 0
	XORLW      123
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;_.c,83 :: 		print=1;
	MOVLW      1
	MOVWF      _print+0
;_.c,84 :: 		}
L_main3:
;_.c,86 :: 		if (print==1)
	MOVF       _print+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;_.c,88 :: 		frecuency= (TMR1H<<8) + (TMR1L);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _frecuency+0
	MOVF       R0+1, 0
	MOVWF      _frecuency+1
;_.c,89 :: 		IntToStr(frecuency, text); //imprimimos el valor acumulado en TIM1L
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _text+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;_.c,90 :: 		printf(text);
	MOVLW      _text+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,91 :: 		printf("HZ\r\n");
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
;_.c,92 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_main
;_.c,93 :: 		}
L_main4:
;_.c,94 :: 		}
	GOTO       L_main1
;_.c,95 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
