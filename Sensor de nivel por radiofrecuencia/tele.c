#define Start RB1_bit
#define SALIDA PORTD
const char Llenado[]={0b10010000,0b10011000,0b10011100,0b10011110,0b00011111};
char conteo;

void main() 
{

  TRISD=0x00;TRISB=0xff; TRISC=0x00;
  PORTD=0x00;PORTB=0x00; PORTC=0x00;
  while(1)
  {
    for  (conteo=0;conteo<5;conteo++) 
    {
      if (Start==1)
      {
        SALIDA=Llenado[conteo];
        Delay_ms(3);
      }
    }
    Delay_ms(200);
  }

}
