
// LCD module connections
sbit LCD_RS at RC4_bit;
sbit LCD_EN at RC5_bit;
sbit LCD_D4 at RC0_bit;
sbit LCD_D5 at RC1_bit;
sbit LCD_D6 at RC2_bit;
sbit LCD_D7 at RC3_bit;

sbit LCD_RS_Direction at TRISC4_bit;
sbit LCD_EN_Direction at TRISC5_bit;
sbit LCD_D4_Direction at TRISC0_bit;
sbit LCD_D5_Direction at TRISC1_bit;
sbit LCD_D6_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISC3_bit;
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
      PORTD=~PORTD;
      ctrl[0]++;
   }
   INTCON.GIE = 1;//Habilito todas las interrupciones
}

///////////////////////////////////////////////////////////////////////////////////////////////
int main(void)
{
   TRISB  = 0x00;
   TRISA  = 0xFF;
   PORTA  = 0x00;
   ANSELH = 0x00;
   TRISD  = 0x00;
   PORTD  = 0x00;
   OPTION_REG = 0x27;
   INTCON =   0xA0;
   TMR0   = 0;
   OPTION_REG.T0CS = 0; //HABILITO EL TIMER

   Lcd_Init();                        // Initialize LCD
   Lcd_Cmd(_LCD_CLEAR);               // Clear display
   Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
   Lcd_Out(2,5,"FRECUENCIA:");                 // Write text in second row

   while(1)
   {               
   
       PORTA=~PORTA;
        if (RA4_bit==1 && ctrl[1]==0 )
        {
        ctrl[1]=1;
        frecuencia++;
        RB1_bit=1;
        }
        if (RA4_bit==0 && ctrl[1]==1){
        ctrl[1]=0;
        RB1_bit=0;
        }


        if (ctrl[0]==16)
        {
        ctrl[0]=0;
        printf=1;
        }


        if (printf==1)
        {
           IntToStr(frecuencia, text);
           Lcd_Out(3,5,text);
           Lcd_Out_CP("HZ");
           return -1;
        }             

    }
}