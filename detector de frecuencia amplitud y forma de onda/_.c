
unsigned char ctrl=0,ctrl2=0,frecu=0,print=0,text[6]={0};
unsigned char registro1=0,registro2=0,temp=0,i=0,fi=0;
unsigned int frecuency = 0,pasos=0,aux=0;
float resolucion= 0.00488,resultado=0,value=0,memor[6]={0};

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
    TRISA = 0x01;
    PORTA = 0x01;
    ANSEL = 0x01;         //RA0 Analoga
    TRISD=0x01;
    PORTD=0x01;
    ADCON0= 0x01;        //configurando el ADC a la maxima velocidad por el canal 0
    ADCON1= 0x80;        //los justificamos a la derecha y usamos vdd y vss como los vref
    OPTION_REG = 0x24;    //configurando timer0 como temporizador con un preescalador de 1:32
    T1CON = 0x03;        //configurando timer1 como contador
    TMR0  = 0;           //inicializando timer0 en 0 para segurar que este limpio
    OPTION_REG.T0CS = 0;  //se habilita el timer 0
    INTCON =   0xE0;      //habilitando las interrupciones del timer0
    TMR1H  = 0x00;        //registro de los primeros 8 bits del timer1 se llena ya que solo trabajaremos con TMR1L
    TMR1L  = 0x00;        //registro de los segiundos 8 bits del timer1

    UART1_Init(9600);


    while(1)
    {

         ADCON0.GO=1;//inicia conversion
         while(ADCON0.GO);
         registro1=ADRESH & 0x03; //extraemos los bits del registro adresh
         registro2=ADRESL;        //extraemos los bits del registro adresl
         pasos= (registro1<<8)+registro2; //calculamos el numero de pasos
         resultado=pasos*resolucion;      //realizamos la conversion a voltaje


         memor[i]=resultado;
         if (i<3){i++;}


           ///////////////////////////////////////////////////////////////////
          if (RD0_bit && ctrl2==0){frecuency++;ctrl2=1;}
          else if (RD0_bit==0 && ctrl2==1){ctrl2=0;aux++;}
          if (ctrl2==1 && aux==0 && resultado<memor[4] && fi<3){memor[5]+=1;}
          memor[4]=resultado;
          fi++;
          if (resultado>value && resultado <=5)
          {
             value=resultado;
          }


          if (ctrl==123)
          {
             INTCON.GIE = 0;        // Se deshabilitan todas las interrupciones
             print=1; 

          }


          if (print==1)
         {
            if (memor[0]==memor[1])
            {
            printf("FORMA:");
            printf("RECTANGULAR");
            }
            else if (memor[5]>=1)
            {
            printf("FORMA:");
            printf("TRIANGULAR") ;
            }
            else 
            {
            printf("FORMA:");
            printf("SENOIDAL");
            }
            
            printf("\n\rFRECUENCIA:\n\r");
            IntToStr(frecuency, text);       //imprimimos el valor acumulado en TIM1L
            printf(text);
            printf("HZ\r\n");
            printf("AMPLITUD:\n\r   ");
            floatToStr_FixLen(value, text,5);
            printf(text);
            printf("V");
            return 1;
         }
         //////////////////////////////////////////////////////////////////////////////////77
    }
}