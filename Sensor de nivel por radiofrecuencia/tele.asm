
_main:

;tele.c,6 :: 		void main() {
;tele.c,7 :: 		TRISD=0x00;TRISB=0xff; TRISC=0x00;
	CLRF       TRISD+0
	MOVLW      255
	MOVWF      TRISB+0
	CLRF       TRISC+0
;tele.c,8 :: 		PORTD=0x00;PORTB=0x00; PORTC=0x00;
	CLRF       PORTD+0
	CLRF       PORTB+0
	CLRF       PORTC+0
;tele.c,10 :: 		while(1){
L_main0:
;tele.c,11 :: 		for  (conteo=0;conteo<5;conteo++) {
	CLRF       _conteo+0
L_main2:
	MOVLW      5
	SUBWF      _conteo+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;tele.c,12 :: 		if (Start==1){
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_main5
;tele.c,13 :: 		SALIDA=Llenado[conteo];
	MOVF       _conteo+0, 0
	ADDLW      _Llenado+0
	MOVWF      R0+0
	MOVLW      hi_addr(_Llenado+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;tele.c,14 :: 		Delay_ms(3);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	NOP
;tele.c,15 :: 		}
L_main5:
;tele.c,11 :: 		for  (conteo=0;conteo<5;conteo++) {
	INCF       _conteo+0, 1
;tele.c,16 :: 		}
	GOTO       L_main2
L_main3:
;tele.c,17 :: 		Delay_ms(200);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
;tele.c,18 :: 		}
	GOTO       L_main0
;tele.c,19 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
