/*  EJEMPLO DE LA CLASE
void main() {
   char adres_l = 0, adres_h = 0;
   int pasos = 0;
   float resol = 0.00488;
   float resultado = 0;
   char str[14] = {0};
   TRISA = 0X01; //RA0 entrada
   ANSEL = 0x01; //RA0 Analoga
   ADCON0 = 0X01; // Max Velocidad, Channel AN0, ADC ON
   ADCON1 = 0X80; //Justificado Derecha, Vref (Vdd - Vss)
   UART1_Init(9600);
   Delay_ms(100);

   while(1){
      ADCON0.GO = 1; //Inicia una conversión
      while(ADCON0.GO);
      adres_h = ADRESH & 0x03;
      adres_l = ADRESL;
      pasos = (adres_h << 8) + adres_l;
      resultado = pasos * resol;
      FloatToStr(resultado, str);
      UART1_Write_Text(str);
      UART1_Write_Text("\r\n");
      Delay_ms(1000);
   }
}

*/


unsigned char ctrl=0,print=0,text[6]={0};
unsigned int frecuency = 0;


void printf(unsigned char msg[])
{
 UART1_Write_Text(msg);
}



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
    TMR1H  = 0x00;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
    TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1

    UART1_Init(9600);
    UART1_Write_Text("FRECUENCIA:\n\r");

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
            frecuency= (TMR1H<<8) + (TMR1L);
            IntToStr(frecuency, text); //imprimimos el valor acumulado en TIM1L
            printf(text);
            printf("HZ\r\n");
            return 1;
         }
    }
}