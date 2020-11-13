unsigned int frecuencia=0,text[4]={0};

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





void interrupt(void)  //ist
{
   INTCON.GIE = 0; //Deshabilito todas las interrupciones
   if(INTCON.T0IF == 1)
   {
      INTCON.T0IF = 0; //Bajar la bandera
      frecuencia++; //codigo a ehecuta

   }
   INTCON.GIE = 1;//Habilito todas las interrupciones
}


void main(void) {

   TRISA = 0X00;
   ANSELH = 0X00;
   TRISD = 0X00;
   PORTD = 0X00;
   OPTION_REG = 0x3F;
   INTCON =   0xA0;
   TMR0 = 0x00;
   OPTION_REG.T0CS = 0; //HABILITO EL TIMER

    Lcd_Init();                        // Initialize LCD

    Lcd_Cmd(_LCD_CLEAR);               // Clear display
    Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
    Lcd_Out(1,6,"HOLA PERRA");                 // Write text in first row

  Lcd_Out(2,6,"PERRISIMA");                 // Write text in second row
  Delay_ms(2000);
  Lcd_Cmd(_LCD_CLEAR);               // Clear display

  Lcd_Out(1,1,"AHORA");                 // Write text in first row
  Lcd_Out(2,5,"PUEDE QUE SI");                 // Write text in second row

   while(1)
   {
    PORTD=~PORTD;
    Delay_ms(100);
    ByteToStr(frecuencia, text);

   }

}