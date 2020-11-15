#line 1 "D:/CODES 2.0/frecuenciometro/frecunciometro.c"


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


unsigned char ctrl=0,printf=0,text[5]={0};


void interrupt(void)
{
 INTCON.GIE = 0;
 if (INTCON.T0IF == 1 )
 {
 INTCON.T0IF = 0;
 ctrl++;
 }
 INTCON.GIE = 1;
}


int main(void)
{

 TRISC = 0x00;
 PORTC = 0x00;
 OPTION_REG = 0x24;
 T1CON = 0x03;
 TMR0 = 0;
 OPTION_REG.T0CS = 0;
 INTCON = 0xE0;
 TMR1H = 0xFF;
 TMR1L = 0x00;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(2,5,"FRECUENCIA:");

 while(1)
 {







 if (ctrl==123)
 {
 printf=1;
 }
 if (printf==1)
 {
 IntToStr(TMR1L, text);
 Lcd_Out(3,5,text);
 Lcd_Out_CP("HZ");
 return 1;
 }
 }
}
