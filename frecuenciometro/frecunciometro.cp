#line 1 "D:/CODES 2.0/frecuenciometro/frecunciometro.c"
unsigned int frecuencia=0;


void interrupt(void)
{
 INTCON.GIE = 0;
 if(INTCON.T0IF == 1)
 {
 INTCON.T0IF = 0;
 frecuencia++;

 }
 INTCON.GIE = 1;
}


void main(void) {

 TRISA = 0X00;
 ANSELH = 0X00;
 TRISD = 0X00;
 PORTD = 0X00;
 OPTION_REG = 0x3F;
 INTCON = 0xA0;
 TMR0 = 0x00;
 OPTION_REG.T0CS = 0;

 UART1_Init(9600);
 UART1_Write_Text("frecenciometro");

 while(1)
 {
 PORTD=~PORTD;
 Delay_ms(100);
 }

}
