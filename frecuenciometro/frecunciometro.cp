#line 1 "D:/CODES 2.0/frecuenciometro/frecunciometro.c"
unsigned int frecuencia=0,text[4]={0};


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






void interrupt(void)
{
 INTCON.GIE = 0;
 if(INTCON.T0IF == 1)
 {
 INTCON.T0IF = 0;


 }
 INTCON.GIE = 1;
}


void main(void) {

 TRISA = 0X00;
 ANSELH = 0X00;
 TRISD = 0X00;
 PORTD = 0X00;
 OPTION_REG = 0x3F;
 INTCON = 0xA0;
 TMR0 = 0x00;
 OPTION_REG.T0CS = 0;

 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_Out(2,4,"FRECUENCIOMETRO:");

 while(1)
 {
 ByteToStr(frecuencia, text);
 Lcd_Out(3,7,text);
 Lcd_Out_CP("HZ");
 frecuencia++;
 Delay_ms(500);
 }

}
