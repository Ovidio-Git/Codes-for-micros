#line 1 "D:/CODES 2.0/detector de frecuencia amplitud y forma de onda/_.c"
void printf(unsigned char msg[])
{
 UART1_Write_Text(msg);
}



unsigned char ctrl=0,print=0,text[5]={0};


void interrupt(void)
{
 INTCON.GIE = 0;
 if (INTCON.T0IF == 1 )
 {
 INTCON.T0IF = 0;
 ctrl++;
 }
 INTCON.GIE = 1;
}


int main(void)
{

 TRISC = 0x00;
 PORTC = 0x00;
 OPTION_REG = 0x24;
 T1CON = 0x03;
 TMR0 = 0;
 OPTION_REG.T0CS = 0;
 INTCON = 0xE0;
 TMR1H = 0xFF;
 TMR1L = 0x00;

 UART1_Init(9600);
 UART1_Write_Text("se arreglo esta mierda");

 while(1)
 {







 if (ctrl==123)
 {
 print=1;
 }
 if (print==1)
 {
 IntToStr(TMR1L, text);
 printf(text);
 printf("HZ\r\n");
 return 1;
 }
 }
}
