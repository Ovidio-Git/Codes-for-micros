
_printf:

;_.c,37 :: 		void printf(unsigned char msg[])
;_.c,39 :: 		UART1_Write_Text(msg);
	MOVF       FARG_printf_msg+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;_.c,40 :: 		}
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

;_.c,45 :: 		void interrupt(void)
;_.c,47 :: 		INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
	BCF        INTCON+0, 7
;_.c,48 :: 		if (INTCON.T0IF == 1 ) // se chequea si el timer 0 fue el causante
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;_.c,50 :: 		INTCON.T0IF = 0;   //se baja la bandera del timer0
	BCF        INTCON+0, 2
;_.c,51 :: 		ctrl++;            // se lleva control del numero de interrupciones
	INCF       _ctrl+0, 1
;_.c,52 :: 		}
L_interrupt0:
;_.c,53 :: 		INTCON.GIE = 1;        //se Habilitan todas las interrupciones
	BSF        INTCON+0, 7
;_.c,54 :: 		}
L_end_interrupt:
L__interrupt22:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;_.c,57 :: 		int main(void)
;_.c,59 :: 		TRISA = 0x01;
	MOVLW      1
	MOVWF      TRISA+0
;_.c,60 :: 		PORTA = 0x01;
	MOVLW      1
	MOVWF      PORTA+0
;_.c,61 :: 		ANSEL = 0x01;         //RA0 Analoga
	MOVLW      1
	MOVWF      ANSEL+0
;_.c,62 :: 		TRISD=0x01;
	MOVLW      1
	MOVWF      TRISD+0
;_.c,63 :: 		PORTD=0x01;
	MOVLW      1
	MOVWF      PORTD+0
;_.c,64 :: 		ADCON0= 0x01;        //configurando el ADC a la maxima velocidad por el canal 0
	MOVLW      1
	MOVWF      ADCON0+0
;_.c,65 :: 		ADCON1= 0x80;        //los justificamos a la derecha y usamos vdd y vss como los vref
	MOVLW      128
	MOVWF      ADCON1+0
;_.c,66 :: 		OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
	MOVLW      36
	MOVWF      OPTION_REG+0
;_.c,67 :: 		T1CON = 0x03;        //configurando timer1 como contador
	MOVLW      3
	MOVWF      T1CON+0
;_.c,68 :: 		TMR0  = 0;           //inicializando timer0 en 0 para segurar que este limpio
	CLRF       TMR0+0
;_.c,70 :: 		INTCON =   0xE0;      //habilitando las interrupciones del timer0
	MOVLW      224
	MOVWF      INTCON+0
;_.c,71 :: 		TMR1H  = 0x00;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
	CLRF       TMR1H+0
;_.c,72 :: 		TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1
	CLRF       TMR1L+0
;_.c,74 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;_.c,75 :: 		printf("FRECUENCIA:\n\r");
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
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,77 :: 		while(1)
L_main1:
;_.c,80 :: 		ADCON0.GO=1;//inicia conversion
	BSF        ADCON0+0, 1
;_.c,81 :: 		while(ADCON0.GO);
L_main3:
	BTFSS      ADCON0+0, 1
	GOTO       L_main4
	GOTO       L_main3
L_main4:
;_.c,82 :: 		registro1=ADRESH & 0x03; //extraemos los bits del registro adresh
	MOVLW      3
	ANDWF      ADRESH+0, 0
	MOVWF      _registro1+0
;_.c,83 :: 		registro2=ADRESL;        //extraemos los bits del registro adresl
	MOVF       ADRESL+0, 0
	MOVWF      _registro2+0
;_.c,85 :: 		while(RD0_bit==1);
L_main5:
	BTFSS      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main6
	GOTO       L_main5
L_main6:
;_.c,86 :: 		OPTION_REG.T0CS=0;
	BCF        OPTION_REG+0, 5
;_.c,87 :: 		while(RD0_bit==0);
L_main7:
	BTFSC      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main8
	GOTO       L_main7
L_main8:
;_.c,88 :: 		OPTION_REG.T0CS=1;
	BSF        OPTION_REG+0, 5
;_.c,91 :: 		if (RD0_bit==1 && ctrl2==0){frecuency++;ctrl2=1;}
	BTFSS      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main11
	MOVF       _ctrl2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main11
L__main19:
	INCF       _frecuency+0, 1
	BTFSC      STATUS+0, 2
	INCF       _frecuency+1, 1
	MOVLW      1
	MOVWF      _ctrl2+0
	GOTO       L_main12
L_main11:
;_.c,92 :: 		else if (RD0_bit==0 && ctrl2==1){ctrl2=0;}
	BTFSC      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main15
	MOVF       _ctrl2+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main15
L__main18:
	CLRF       _ctrl2+0
L_main15:
L_main12:
;_.c,94 :: 		if (ctrl==123)
	MOVF       _ctrl+0, 0
	XORLW      123
	BTFSS      STATUS+0, 2
	GOTO       L_main16
;_.c,96 :: 		print=1;
	MOVLW      1
	MOVWF      _print+0
;_.c,97 :: 		}
L_main16:
;_.c,100 :: 		if (print==1)
	MOVF       _print+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;_.c,102 :: 		pasos= (registro1<<8)+registro2; //calculamos el numero de pasos
	MOVF       _registro1+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       _registro2+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _pasos+0
	MOVF       R0+1, 0
	MOVWF      _pasos+1
;_.c,103 :: 		resultado=pasos*resolucion;      //realizamos la conversion a voltaje
	CALL       _word2double+0
	MOVF       _resolucion+0, 0
	MOVWF      R4+0
	MOVF       _resolucion+1, 0
	MOVWF      R4+1
	MOVF       _resolucion+2, 0
	MOVWF      R4+2
	MOVF       _resolucion+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _resultado+0
	MOVF       R0+1, 0
	MOVWF      _resultado+1
	MOVF       R0+2, 0
	MOVWF      _resultado+2
	MOVF       R0+3, 0
	MOVWF      _resultado+3
;_.c,104 :: 		IntToStr(frecuency, text);       //imprimimos el valor acumulado en TIM1L
	MOVF       _frecuency+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _frecuency+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _text+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;_.c,105 :: 		printf(text);
	MOVLW      _text+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,106 :: 		printf("HZ\r\n");
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
;_.c,107 :: 		printf("AMPLITUD:\n\r   ");
	MOVLW      65
	MOVWF      ?lstr3__+0
	MOVLW      77
	MOVWF      ?lstr3__+1
	MOVLW      80
	MOVWF      ?lstr3__+2
	MOVLW      76
	MOVWF      ?lstr3__+3
	MOVLW      73
	MOVWF      ?lstr3__+4
	MOVLW      84
	MOVWF      ?lstr3__+5
	MOVLW      85
	MOVWF      ?lstr3__+6
	MOVLW      68
	MOVWF      ?lstr3__+7
	MOVLW      58
	MOVWF      ?lstr3__+8
	MOVLW      10
	MOVWF      ?lstr3__+9
	MOVLW      13
	MOVWF      ?lstr3__+10
	MOVLW      32
	MOVWF      ?lstr3__+11
	MOVLW      32
	MOVWF      ?lstr3__+12
	MOVLW      32
	MOVWF      ?lstr3__+13
	CLRF       ?lstr3__+14
	MOVLW      ?lstr3__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,108 :: 		floatToStr_FixLen(resultado, text,5);
	MOVF       _resultado+0, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+0
	MOVF       _resultado+1, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+1
	MOVF       _resultado+2, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+2
	MOVF       _resultado+3, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+3
	MOVLW      _text+0
	MOVWF      FARG_FloatToStr_FixLen_str+0
	MOVLW      5
	MOVWF      FARG_FloatToStr_FixLen_len+0
	CALL       _FloatToStr_FixLen+0
;_.c,109 :: 		printf(text);
	MOVLW      _text+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,110 :: 		printf("V");
	MOVLW      86
	MOVWF      ?lstr4__+0
	CLRF       ?lstr4__+1
	MOVLW      ?lstr4__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,111 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_main
;_.c,112 :: 		}
L_main17:
;_.c,113 :: 		}
	GOTO       L_main1
;_.c,114 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
