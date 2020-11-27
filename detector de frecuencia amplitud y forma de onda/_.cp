#line 1 "D:/CODES 2.0/detector de frecuencia amplitud y forma de onda/_.c"
#line 32 "D:/CODES 2.0/detector de frecuencia amplitud y forma de onda/_.c"
unsigned char ctrl=0,ctrl2=0,ctrl3=0,frecu=0,print=0,text[6]={0},fi=0;
unsigned char registro1=0,registro2=0,temp=0,i=0;
unsigned int frecuency = 0,pasos=0;
float resolucion= 0.00488,resultado=0,value=0,memor[3];

void printf(unsigned char msg[])
{
 UART1_Write_Text(msg);
}




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
 TRISA = 0x01;
 PORTA = 0x01;
 ANSEL = 0x01;
 TRISD=0x01;
 PORTD=0x01;
 ADCON0= 0x01;
 ADCON1= 0x80;
 OPTION_REG = 0x24;
 T1CON = 0x03;
 TMR0 = 0;
 OPTION_REG.T0CS = 0;
 INTCON = 0xE0;
 TMR1H = 0x00;
 TMR1L = 0x00;

 UART1_Init(9600);


 while(1)
 {

 ADCON0.GO=1;
 while(ADCON0.GO);
 registro1=ADRESH & 0x03;
 registro2=ADRESL;
 pasos= (registro1<<8)+registro2;
 resultado=pasos*resolucion;
 memor[i]=resultado;
 if (i<3){i++;}

 if ( ctrl3==2 && (resultado>=value-(value*0.04)) && resultado <=5);
 {
 fi++;
 }


 if (RD0_bit && ctrl2==0){frecuency++;ctrl2=1;}
 else if (RD0_bit==0 && ctrl2==1){ctrl2=0;ctrl3++;}

 if (resultado>value && resultado <=5)
 {
 value=resultado;
 }
 if (ctrl==123)
 {
 INTCON.GIE = 0;
 ByteToStr(fi,text);
 printf(text);
 print=1; return 0;
 }
#line 132 "D:/CODES 2.0/detector de frecuencia amplitud y forma de onda/_.c"
 }
}
