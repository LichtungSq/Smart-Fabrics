#define ADC9  0x21 //(100001)

int analog9;
volatile int ADCW;

void ADC_setup(void)
{
//ADMUX = (0<<REFS0) | (0<<REFS1); // select external AREF
DIDR2 = (1<<ADC8D) | (1<<ADC9D); // digital input disable
ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0); // enable ADC, 128 clk divider
}

void ADC_select(uint8_t chan)
{
ADMUX |= chan & 0x1F; //select channel (MUX0-4 bits)
ADCSRB |= chan & 0x20;  //select channel (MUX5 bit)
ADCSRA |= (1<<ADSC);  // ADC Start Conversion
}

uint16_t ADC_read(void)
{
  return (ADCW);
}

int main(void)
{
  ADC_select(ADC9);
  analog9 = ADC_read();

  Serial.println(analog9);
}

