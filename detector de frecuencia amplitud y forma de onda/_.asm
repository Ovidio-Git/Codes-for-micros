
_printf:

;_.c,7 :: 		void printf(unsigned char msg[])
;_.c,9 :: 		UART1_Write_Text(msg);
	MOVF       FARG_printf_msg+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;_.c,10 :: 		}
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

;_.c,15 :: 		void interrupt(void)
;_.c,17 :: 		INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
	BCF        INTCON+0, 7
;_.c,18 :: 		if (INTCON.T0IF == 1 ) // se chequea si el timer 0 fue el causante
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;_.c,20 :: 		INTCON.T0IF = 0;   //se baja la bandera del timer0
	BCF        INTCON+0, 2
;_.c,21 :: 		ctrl++;            // se lleva control del numero de interrupciones
	INCF       _ctrl+0, 1
;_.c,22 :: 		}
L_interrupt0:
;_.c,23 :: 		INTCON.GIE = 1;        //se Habilitan todas las interrupciones
	BSF        INTCON+0, 7
;_.c,24 :: 		}
L_end_interrupt:
L__interrupt31:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;_.c,27 :: 		int main(void)
;_.c,29 :: 		TRISA = 0x01;
	MOVLW      1
	MOVWF      TRISA+0
;_.c,30 :: 		PORTA = 0x01;
	MOVLW      1
	MOVWF      PORTA+0
;_.c,31 :: 		ANSEL = 0x01;         //RA0 Analoga
	MOVLW      1
	MOVWF      ANSEL+0
;_.c,32 :: 		TRISD=0x01;
	MOVLW      1
	MOVWF      TRISD+0
;_.c,33 :: 		PORTD=0x01;
	MOVLW      1
	MOVWF      PORTD+0
;_.c,34 :: 		ADCON0= 0x01;        //configurando el ADC a la maxima velocidad por el canal 0
	MOVLW      1
	MOVWF      ADCON0+0
;_.c,35 :: 		ADCON1= 0x80;        //los justificamos a la derecha y usamos vdd y vss como los vref
	MOVLW      128
	MOVWF      ADCON1+0
;_.c,36 :: 		OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
	MOVLW      36
	MOVWF      OPTION_REG+0
;_.c,37 :: 		T1CON = 0x03;        //configurando timer1 como contador
	MOVLW      3
	MOVWF      T1CON+0
;_.c,38 :: 		TMR0  = 0;           //inicializando timer0 en 0 para segurar que este limpio
	CLRF       TMR0+0
;_.c,39 :: 		OPTION_REG.T0CS = 0;  //se habilita el timer 0
	BCF        OPTION_REG+0, 5
;_.c,40 :: 		INTCON =   0xE0;      //habilitando las interrupciones del timer0
	MOVLW      224
	MOVWF      INTCON+0
;_.c,41 :: 		TMR1H  = 0x00;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
	CLRF       TMR1H+0
;_.c,42 :: 		TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1
	CLRF       TMR1L+0
;_.c,44 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;_.c,47 :: 		while(1)
L_main1:
;_.c,50 :: 		ADCON0.GO=1;//inicia conversion
	BSF        ADCON0+0, 1
;_.c,51 :: 		while(ADCON0.GO);
L_main3:
	BTFSS      ADCON0+0, 1
	GOTO       L_main4
	GOTO       L_main3
L_main4:
;_.c,52 :: 		registro1=ADRESH & 0x03; //extraemos los bits del registro adresh
	MOVLW      3
	ANDWF      ADRESH+0, 0
	MOVWF      R3+0
	MOVF       R3+0, 0
	MOVWF      _registro1+0
;_.c,53 :: 		registro2=ADRESL;        //extraemos los bits del registro adresl
	MOVF       ADRESL+0, 0
	MOVWF      _registro2+0
;_.c,54 :: 		pasos= (registro1<<8)+registro2; //calculamos el numero de pasos
	MOVF       R3+0, 0
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
;_.c,55 :: 		resultado=pasos*resolucion;      //realizamos la conversion a voltaje
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
;_.c,58 :: 		memor[i]=resultado;
	MOVF       _i+0, 0
	MOVWF      R4+0
	RLF        R4+0, 1
	BCF        R4+0, 0
	RLF        R4+0, 1
	BCF        R4+0, 0
	MOVF       R4+0, 0
	ADDLW      _memor+0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       R0+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       R0+2, 0
	INCF       FSR, 1
	MOVWF      INDF+0
	MOVF       R0+3, 0
	INCF       FSR, 1
	MOVWF      INDF+0
;_.c,59 :: 		if (i<3){i++;}
	MOVLW      3
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main5
	INCF       _i+0, 1
L_main5:
;_.c,63 :: 		if (RD0_bit && ctrl2==0){frecuency++;ctrl2=1;}
	BTFSS      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main8
	MOVF       _ctrl2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main8
L__main28:
	INCF       _frecuency+0, 1
	BTFSC      STATUS+0, 2
	INCF       _frecuency+1, 1
	MOVLW      1
	MOVWF      _ctrl2+0
	GOTO       L_main9
L_main8:
;_.c,64 :: 		else if (RD0_bit==0 && ctrl2==1){ctrl2=0;aux++;}
	BTFSC      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main12
	MOVF       _ctrl2+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main12
L__main27:
	CLRF       _ctrl2+0
	INCF       _aux+0, 1
	BTFSC      STATUS+0, 2
	INCF       _aux+1, 1
L_main12:
L_main9:
;_.c,65 :: 		if (ctrl2==1 && aux==0 && resultado<memor[4] && fi<3){memor[5]+=1;}
	MOVF       _ctrl2+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVLW      0
	XORWF      _aux+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main33
	MOVLW      0
	XORWF      _aux+0, 0
L__main33:
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVF       _memor+16, 0
	MOVWF      R4+0
	MOVF       _memor+17, 0
	MOVWF      R4+1
	MOVF       _memor+18, 0
	MOVWF      R4+2
	MOVF       _memor+19, 0
	MOVWF      R4+3
	MOVF       _resultado+0, 0
	MOVWF      R0+0
	MOVF       _resultado+1, 0
	MOVWF      R0+1
	MOVF       _resultado+2, 0
	MOVWF      R0+2
	MOVF       _resultado+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main15
	MOVLW      3
	SUBWF      _fi+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main15
L__main26:
	MOVF       _memor+20, 0
	MOVWF      R0+0
	MOVF       _memor+21, 0
	MOVWF      R0+1
	MOVF       _memor+22, 0
	MOVWF      R0+2
	MOVF       _memor+23, 0
	MOVWF      R0+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _memor+20
	MOVF       R0+1, 0
	MOVWF      _memor+21
	MOVF       R0+2, 0
	MOVWF      _memor+22
	MOVF       R0+3, 0
	MOVWF      _memor+23
L_main15:
;_.c,66 :: 		memor[4]=resultado;
	MOVF       _resultado+0, 0
	MOVWF      _memor+16
	MOVF       _resultado+1, 0
	MOVWF      _memor+17
	MOVF       _resultado+2, 0
	MOVWF      _memor+18
	MOVF       _resultado+3, 0
	MOVWF      _memor+19
;_.c,67 :: 		fi++;
	INCF       _fi+0, 1
;_.c,68 :: 		if (resultado>value && resultado <=5)
	MOVF       _resultado+0, 0
	MOVWF      R4+0
	MOVF       _resultado+1, 0
	MOVWF      R4+1
	MOVF       _resultado+2, 0
	MOVWF      R4+2
	MOVF       _resultado+3, 0
	MOVWF      R4+3
	MOVF       _value+0, 0
	MOVWF      R0+0
	MOVF       _value+1, 0
	MOVWF      R0+1
	MOVF       _value+2, 0
	MOVWF      R0+2
	MOVF       _value+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       _resultado+0, 0
	MOVWF      R4+0
	MOVF       _resultado+1, 0
	MOVWF      R4+1
	MOVF       _resultado+2, 0
	MOVWF      R4+2
	MOVF       _resultado+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      129
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main18
L__main25:
;_.c,70 :: 		value=resultado;
	MOVF       _resultado+0, 0
	MOVWF      _value+0
	MOVF       _resultado+1, 0
	MOVWF      _value+1
	MOVF       _resultado+2, 0
	MOVWF      _value+2
	MOVF       _resultado+3, 0
	MOVWF      _value+3
;_.c,71 :: 		}
L_main18:
;_.c,74 :: 		if (ctrl==123)
	MOVF       _ctrl+0, 0
	XORLW      123
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;_.c,76 :: 		INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
	BCF        INTCON+0, 7
;_.c,77 :: 		print=1;
	MOVLW      1
	MOVWF      _print+0
;_.c,79 :: 		}
L_main19:
;_.c,82 :: 		if (print==1)
	MOVF       _print+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;_.c,84 :: 		if (memor[0]==memor[1])
	MOVF       _memor+4, 0
	MOVWF      R4+0
	MOVF       _memor+5, 0
	MOVWF      R4+1
	MOVF       _memor+6, 0
	MOVWF      R4+2
	MOVF       _memor+7, 0
	MOVWF      R4+3
	MOVF       _memor+0, 0
	MOVWF      R0+0
	MOVF       _memor+1, 0
	MOVWF      R0+1
	MOVF       _memor+2, 0
	MOVWF      R0+2
	MOVF       _memor+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main21
;_.c,86 :: 		printf("FORMA:");
	MOVLW      70
	MOVWF      ?lstr1__+0
	MOVLW      79
	MOVWF      ?lstr1__+1
	MOVLW      82
	MOVWF      ?lstr1__+2
	MOVLW      77
	MOVWF      ?lstr1__+3
	MOVLW      65
	MOVWF      ?lstr1__+4
	MOVLW      58
	MOVWF      ?lstr1__+5
	CLRF       ?lstr1__+6
	MOVLW      ?lstr1__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,87 :: 		printf("RECTANGULAR");
	MOVLW      82
	MOVWF      ?lstr2__+0
	MOVLW      69
	MOVWF      ?lstr2__+1
	MOVLW      67
	MOVWF      ?lstr2__+2
	MOVLW      84
	MOVWF      ?lstr2__+3
	MOVLW      65
	MOVWF      ?lstr2__+4
	MOVLW      78
	MOVWF      ?lstr2__+5
	MOVLW      71
	MOVWF      ?lstr2__+6
	MOVLW      85
	MOVWF      ?lstr2__+7
	MOVLW      76
	MOVWF      ?lstr2__+8
	MOVLW      65
	MOVWF      ?lstr2__+9
	MOVLW      82
	MOVWF      ?lstr2__+10
	CLRF       ?lstr2__+11
	MOVLW      ?lstr2__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,88 :: 		}
	GOTO       L_main22
L_main21:
;_.c,89 :: 		else if (memor[5]>=1)
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	MOVF       _memor+20, 0
	MOVWF      R0+0
	MOVF       _memor+21, 0
	MOVWF      R0+1
	MOVF       _memor+22, 0
	MOVWF      R0+2
	MOVF       _memor+23, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;_.c,91 :: 		printf("FORMA:");
	MOVLW      70
	MOVWF      ?lstr3__+0
	MOVLW      79
	MOVWF      ?lstr3__+1
	MOVLW      82
	MOVWF      ?lstr3__+2
	MOVLW      77
	MOVWF      ?lstr3__+3
	MOVLW      65
	MOVWF      ?lstr3__+4
	MOVLW      58
	MOVWF      ?lstr3__+5
	CLRF       ?lstr3__+6
	MOVLW      ?lstr3__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,92 :: 		printf("TRIANGULAR") ;
	MOVLW      84
	MOVWF      ?lstr4__+0
	MOVLW      82
	MOVWF      ?lstr4__+1
	MOVLW      73
	MOVWF      ?lstr4__+2
	MOVLW      65
	MOVWF      ?lstr4__+3
	MOVLW      78
	MOVWF      ?lstr4__+4
	MOVLW      71
	MOVWF      ?lstr4__+5
	MOVLW      85
	MOVWF      ?lstr4__+6
	MOVLW      76
	MOVWF      ?lstr4__+7
	MOVLW      65
	MOVWF      ?lstr4__+8
	MOVLW      82
	MOVWF      ?lstr4__+9
	CLRF       ?lstr4__+10
	MOVLW      ?lstr4__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,93 :: 		}
	GOTO       L_main24
L_main23:
;_.c,96 :: 		printf("FORMA:");
	MOVLW      70
	MOVWF      ?lstr5__+0
	MOVLW      79
	MOVWF      ?lstr5__+1
	MOVLW      82
	MOVWF      ?lstr5__+2
	MOVLW      77
	MOVWF      ?lstr5__+3
	MOVLW      65
	MOVWF      ?lstr5__+4
	MOVLW      58
	MOVWF      ?lstr5__+5
	CLRF       ?lstr5__+6
	MOVLW      ?lstr5__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,97 :: 		printf("SENOIDAL");
	MOVLW      83
	MOVWF      ?lstr6__+0
	MOVLW      69
	MOVWF      ?lstr6__+1
	MOVLW      78
	MOVWF      ?lstr6__+2
	MOVLW      79
	MOVWF      ?lstr6__+3
	MOVLW      73
	MOVWF      ?lstr6__+4
	MOVLW      68
	MOVWF      ?lstr6__+5
	MOVLW      65
	MOVWF      ?lstr6__+6
	MOVLW      76
	MOVWF      ?lstr6__+7
	CLRF       ?lstr6__+8
	MOVLW      ?lstr6__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,98 :: 		}
L_main24:
L_main22:
;_.c,100 :: 		printf("\n\rFRECUENCIA:\n\r");
	MOVLW      10
	MOVWF      ?lstr7__+0
	MOVLW      13
	MOVWF      ?lstr7__+1
	MOVLW      70
	MOVWF      ?lstr7__+2
	MOVLW      82
	MOVWF      ?lstr7__+3
	MOVLW      69
	MOVWF      ?lstr7__+4
	MOVLW      67
	MOVWF      ?lstr7__+5
	MOVLW      85
	MOVWF      ?lstr7__+6
	MOVLW      69
	MOVWF      ?lstr7__+7
	MOVLW      78
	MOVWF      ?lstr7__+8
	MOVLW      67
	MOVWF      ?lstr7__+9
	MOVLW      73
	MOVWF      ?lstr7__+10
	MOVLW      65
	MOVWF      ?lstr7__+11
	MOVLW      58
	MOVWF      ?lstr7__+12
	MOVLW      10
	MOVWF      ?lstr7__+13
	MOVLW      13
	MOVWF      ?lstr7__+14
	CLRF       ?lstr7__+15
	MOVLW      ?lstr7__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,101 :: 		IntToStr(frecuency, text);       //imprimimos el valor acumulado en TIM1L
	MOVF       _frecuency+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _frecuency+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _text+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;_.c,102 :: 		printf(text);
	MOVLW      _text+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,103 :: 		printf("HZ\r\n");
	MOVLW      72
	MOVWF      ?lstr8__+0
	MOVLW      90
	MOVWF      ?lstr8__+1
	MOVLW      13
	MOVWF      ?lstr8__+2
	MOVLW      10
	MOVWF      ?lstr8__+3
	CLRF       ?lstr8__+4
	MOVLW      ?lstr8__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,104 :: 		printf("AMPLITUD:\n\r   ");
	MOVLW      65
	MOVWF      ?lstr9__+0
	MOVLW      77
	MOVWF      ?lstr9__+1
	MOVLW      80
	MOVWF      ?lstr9__+2
	MOVLW      76
	MOVWF      ?lstr9__+3
	MOVLW      73
	MOVWF      ?lstr9__+4
	MOVLW      84
	MOVWF      ?lstr9__+5
	MOVLW      85
	MOVWF      ?lstr9__+6
	MOVLW      68
	MOVWF      ?lstr9__+7
	MOVLW      58
	MOVWF      ?lstr9__+8
	MOVLW      10
	MOVWF      ?lstr9__+9
	MOVLW      13
	MOVWF      ?lstr9__+10
	MOVLW      32
	MOVWF      ?lstr9__+11
	MOVLW      32
	MOVWF      ?lstr9__+12
	MOVLW      32
	MOVWF      ?lstr9__+13
	CLRF       ?lstr9__+14
	MOVLW      ?lstr9__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,105 :: 		floatToStr_FixLen(value, text,5);
	MOVF       _value+0, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+0
	MOVF       _value+1, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+1
	MOVF       _value+2, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+2
	MOVF       _value+3, 0
	MOVWF      FARG_FloatToStr_FixLen_fnum+3
	MOVLW      _text+0
	MOVWF      FARG_FloatToStr_FixLen_str+0
	MOVLW      5
	MOVWF      FARG_FloatToStr_FixLen_len+0
	CALL       _FloatToStr_FixLen+0
;_.c,106 :: 		printf(text);
	MOVLW      _text+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,107 :: 		printf("V");
	MOVLW      86
	MOVWF      ?lstr10__+0
	CLRF       ?lstr10__+1
	MOVLW      ?lstr10__+0
	MOVWF      FARG_printf_msg+0
	CALL       _printf+0
;_.c,108 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_main
;_.c,109 :: 		}
L_main20:
;_.c,111 :: 		}
	GOTO       L_main1
;_.c,112 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
