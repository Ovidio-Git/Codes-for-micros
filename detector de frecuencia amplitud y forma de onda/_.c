void printf(unsigned char msg[])
{
 UART1_Write_Text(msg);
}



unsigned char ctrl=0,print=0,text[5]={0};

//////////////////////////////     INTERRUPCION     //////////////////////////////////////////
void interrupt(void)
{
     INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
     if (INTCON.T0IF == 1 ) // se chequea si el timer 0 fue el causante
     {
         INTCON.T0IF = 0;   //se baja la bandera del timer0
         ctrl++;            // se lleva control del numero de interrupciones
     }
     INTCON.GIE = 1;        //se Habilitan todas las interrupciones
}
///////////////////////////////////////////////////////////////////////////////////////////////

int main(void)
{

    TRISC = 0x00;
    PORTC = 0x00;         //se inicializa el puerto c e 0
    OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
    T1CON  = 0x03;        //configurando timer1 como contador
    TMR0   = 0;           //inicializando timer0 en 0 para segurar que este limpio
    OPTION_REG.T0CS = 0;  //se habilita el timer 0
    INTCON =   0xE0;      //habilitando las interrupciones del timer0
    TMR1H  = 0xFF;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
    TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1

    UART1_Init(9600);
    UART1_Write_Text("se arreglo esta mierda");

    while(1)
    {
         //el tmr0 lo tenemos inicializado con el prescaler de 1:32 por ende cada interrupcion se dara pasado 8.1ms
         //para poder calcular la frecuencia necesitamos saber cuantos pasos da en 1 segundo asi que para poder llegar al segundo
         //multiplucamos 8.1ms por 123 lo cual nos da 1.0038s lo que nos dice que
         //para lograr el segundo necesitamos 123 interrupciones

         // (255us*32)*123=1.00368s

         if (ctrl==123)
         {
             print=1;
         }
         if (print==1)
         {
            IntToStr(TMR1L, text); //imprimimos el valor acumulado en TIM1L
            printf(text);
            printf("HZ\r\n");
            return 1;
         }
    }
}