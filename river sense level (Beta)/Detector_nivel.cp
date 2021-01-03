#line 1 "D:/CODES 2.0/Detector nivel del rio/Detector_nivel.c"
char i=0,ctrl=0,acumulado_tiempo=0,sirena=0;

void printf(unsigned char msg[])
{
 UART1_Write_Text(msg);
}

int main(void)
{


 TRISD0_bit=0;
 TRISD2_bit=0;
 RD0_bit=0;
 RD2_bit=0;

 TRISC=0;
 UART1_Init(9600);
 printf("AT+CMGF=1\n\r");

 while(1)
 {

 if(RB5_bit==1 && RB6_bit==0 && RB7_bit==0)
 {
 RD2_bit=1;
 printf("AT+CMGF=1\n\r");
 Delay_ms(500);
 printf("AT+CMGS=\"+573017759550\"\n\r");
 Delay_ms(500);
 printf("Nivel del rio: 1 metro\n\r");
 UART_Write(26);
 Delay_ms(1000);
 RD2_bit=0;;
 }

 if(RB5_bit==1 && RB6_bit==1 && RB7_bit==0)
 {
 RD2_bit=1;
 Delay_ms(500);
 printf("AT+CMGS=\"+573017759550\"\n\r");
 Delay_ms(500);
 printf("Nivel del rio: 2 metros\n\r");
 UART_Write(26);
 Delay_ms(1000);
 RD2_bit=0;
 }

 if(RB5_bit==1 && RB6_bit==1 && RB7_bit==1)
 {
 RD2_bit=1;
 Delay_ms(500);
 printf("AT+CMGS=\"+573017759550\"\n\r");
 Delay_ms(500);
 printf("Nivel del rio: 3 metros\n\r");
 UART_Write(26);
 RD2_bit=0;
 sirena=1;
 Delay_ms(5000);
 }

 if (sirena==1)
 {

 ctrl=0;
 while (ctrl<=20)
 {
 RD0_bit=~RD0_bit;
 Delay_ms(250);
 ctrl++;
 }
 RD0_bit=0;
 sirena=0;
 printf("AT+CMGS=\"3017759550\"\n\r");
 Delay_ms(500);
 printf("Ya la sirena esta apagada\n\r");
 UART_Write(26);
 Delay_ms(1000);
 }
 Delay_ms(1000);
 }



}
