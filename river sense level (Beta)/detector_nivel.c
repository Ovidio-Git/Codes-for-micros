char i=0,ctrl=0,acumulado_tiempo=0,sirena=0;

void printf(unsigned char msg[])
{
     UART1_Write_Text(msg);
}

int main(void)
{

     ///////////////////////////////////////////
     TRISD0_bit=0;
     TRISD2_bit=0;
     RD0_bit=0;   // iniciamos en cero el pin donde se encuentra conectada la alarma
     RD2_bit=0;   // iniciamos en cero el pin que controla el encendido y apagado del led guia que nos ayuda a visualizar
                   //en que momento se esta enviando un sms
     TRISC=0;
     UART1_Init(9600);        // inicializamos el puerto serial a 9600
     printf("AT+CMGF=1\n\r"); //Habilitamos el modo texto de los sms del modulo sim800 para que no envie los mensajes en hexadecimal

     while(1)
     {

           if(RB5_bit==1 && RB6_bit==0 && RB7_bit==0)
           {
              RD2_bit=1;  //encendemos el led guia
              printf("AT+CMGF=1\n\r");
              Delay_ms(500);
              printf("AT+CMGS=\"+573017759550\"\n\r");//Num de celular a quien le envío el sms
              Delay_ms(500);
              printf("Nivel del rio: 1 metro\n\r");//mensaje que se desea enviar enviado
              UART_Write(26);
              Delay_ms(1000);
              RD2_bit=0;;  //apagamos el led guia
           }

            if(RB5_bit==1 && RB6_bit==1 && RB7_bit==0)
           {
              RD2_bit=1;  //encendemos el led guia
              Delay_ms(500);
              printf("AT+CMGS=\"+573017759550\"\n\r");//Num de celular a quien le envío el sms
              Delay_ms(500);
              printf("Nivel del rio: 2 metros\n\r");//mensaje que se desea enviar enviado
              UART_Write(26);
              Delay_ms(1000);
              RD2_bit=0;  //apagamos el led guia
           }

            if(RB5_bit==1 && RB6_bit==1 && RB7_bit==1)
           {
              RD2_bit=1;  //encendemos el led guia
              Delay_ms(500);
              printf("AT+CMGS=\"+573017759550\"\n\r");//Num de celular a quien le envío el sms
              Delay_ms(500);
              printf("Nivel del rio: 3 metros\n\r");//mensaje que se desea enviar enviado
              UART_Write(26);
              RD2_bit=0;  //apagamos el led guia
              sirena=1;           //asignamos 1 a la variable sirena
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
              printf("AT+CMGS=\"3017759550\"\n\r");//Num de celular a quien le envío el sms
              Delay_ms(500);
              printf("Ya la sirena esta apagada\n\r");//mensaje que se desea enviar enviado
              UART_Write(26);
              Delay_ms(1000);
            }
              Delay_ms(1000);
      }
      
      
      
}
      