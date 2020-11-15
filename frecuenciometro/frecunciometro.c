
// LCD module connections
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
// End LCD module connections

/////////////////////////////////////////////////////////////////////////////////////////////

unsigned int  frecuencia=0;
unsigned char ctrl[2]={0x00,0x00},printf=0,text[6]={0};

//////////////////////////////////////////////////////////////////////////////////////////////

void interrupt(void)  //ist
{
   INTCON.GIE = 0; //Deshabilito todas las interrupciones
   if(INTCON.T0IF == 1 )
   {  
      INTCON.T0IF = 0; //Bajar la bandera
      ctrl[0]++;
   }
   INTCON.GIE = 1;//Habilito todas las interrupciones
   
   INTCON.GIE = 0; //Deshabilito todas las interrupciones
  if (TMR1IF_bit==1){
    TMR1IF_bit = 0;
    TMR1H	 = 0xFF;
    TMR1L	 = 0x00;
    frecuencia++;

  }
   INTCON.GIE = 1;//Habilito todas las interrupciones
}

///////////////////////////////////////////////////////////////////////////////////////////////
int main(void)
{

   TRISC = 0x00;
   PORTC=0x00;
   OPTION_REG = 0x27;    //configurando timer0 como temporizador
   T1CON=0x07;           //configurando timer1 como contador
   TMR0   = 0;          // inicializando timer 0 en 0
   OPTION_REG.T0CS = 0; //HABILITO EL TIMER
   INTCON =   0xE0;     //habilitando las interrupciones del timer0
   PIE1=0x01;            //hablitanfo las interrupciones del timer 1
   TMR1H	 = 0xFF; //timer de los primeros 8 bits
   TMR1L	 = 0x00; //timer de ls segundos 8 bits
   TMR1IF_bit=0;



   Lcd_Init();                        // Initialize LCD
   Lcd_Cmd(_LCD_CLEAR);               // Clear display
   Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
   Lcd_Out(2,5,"FRECUENCIA:");                 // Write text in second row

   while(1)
   {               
        if (ctrl[0]==16)
        {
        ctrl[0]=0;
        printf=1;
        }

        if (printf==1)
        {
           IntToStr(TMR1L, text);
           Lcd_Out(3,5,text);
           Lcd_Out_CP("HZ");
           return -1;
        }             

    }
}