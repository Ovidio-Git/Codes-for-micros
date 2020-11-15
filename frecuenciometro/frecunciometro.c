
////////////////////////////     CONEXION DEL MODULO LCD     /////////////////////////////////
sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;
//////////////////////////////////////////////////////////////////////////////////////////////

unsigned char ctrl=0,printf=0,text[5]={0};

//////////////////////////////     INTERRUPCION     //////////////////////////////////////////
void interrupt(void)
{
   INTCON.GIE = 0;       // Se deshabilitan todas las interrupciones
   if(INTCON.T0IF == 1 ) // se chequea si el timer 1 fue el causante
   {
      INTCON.T0IF = 0;   //se baja la bandera del timer 1
      ctrl++;            // se lleva control del numero de interrupciones
   }
   INTCON.GIE = 1;       //se Habilitan todas las interrupciones
}
///////////////////////////////////////////////////////////////////////////////////////////////

int main(void)
{

   TRISC = 0x00;
   PORTC = 0x00;         //se inicializa el puerto c e 0
   OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
   T1CON  = 0x03;           //configurando timer1 como contador
   TMR0   = 0;           //inicializando timer0 en 0 para segurar que este limpio
   OPTION_REG.T0CS = 0;  //se habilita el timer 0
   INTCON =   0xE0;      //habilitando las interrupciones del timer0
   TMR1H  = 0xFF;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
   TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1



   Lcd_Init();                        // Initialize LCD
   Lcd_Cmd(_LCD_CLEAR);               // Clear display
   Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
   Lcd_Out(2,5,"FRECUENCIA:");        // Write text in second row

   while(1)
   {
       //el tmr0 lo tenemos inicializado con el prescaler de 1:32 por ende cada interrupcion se dara pasado 8.1ms
       //para poder calcular la frecuencia necesitamos saber cuantos pasos da en 1 segundo asi que para poder llegar a ese segundo
       //multiplucamos 8.1ms por 123 lo cual nos da 1.0038s lo que nos dice que
       //para lograr el segundo necesitamos 123 interrupciones

       // (255us*32)*123=1.00368s

        if (ctrl==123)
        {
           printf=1;
        }
        if (printf==1)
        {
           IntToStr(TMR1L, text); //imprimimos el valor acumulado en TIM1L
           Lcd_Out(3,5,text);
           Lcd_Out_CP("HZ");
           return 1;
        }

    }
}