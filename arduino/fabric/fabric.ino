#include <avr/sleep.h> 

uint16_t sample = 0;
uint8_t analogPIN = 11; // channel = 9 

// global variable
#define VOLTAGE_DIV_FACTOR 1
#define REF_VCC 3.3

#define BAUD 115200
#define CRYSTAL 8000000
#define BAUD_SETTING (unsigned int)((unsigned long)CRYSTAL / (16 * (unsigned long)BAUD) - 1)

void initUSART(unsigned int baud)
{
	/* Set baud rate */
	UBRR1H = (unsigned char)(baud >> 8);
	UBRR1L = (unsigned char)baud;

	UCSR1A &= ~(1 << U2X1);
	/* Enable receiver and transmitter */
	UCSR1B = (1 << RXEN1) | (1 << TXEN1);
	/* Set frame format: 8 bits data, 1 stop bit */
	// UCSR1C = (UCSR1C & ~(1 << USBS1)) | (3 << UCSZ10);
	UCSR1C = (UCSR1C & ~(1 << USBS1)) | (1 << UCSZ11) | (1 << UCSZ10);
}

void transmitByte(unsigned char data)
{
	while (!(UCSR1A & (1 << UDRE1)));
	// loop_until_bit_is_set(UCSR1A, UDRE1);
	UDR1 = data;
}


uint8_t receiveByte(void)
{
	loop_until_bit_is_set(UCSR1A, RXC1);
	return UDR1;
}

void printString(const char myString[])
{
	uint8_t i = 0;
	while (myString[i]) {
		transmitByte(myString[i]);
		i++;
	}
}

void setupADCSleepMode(void)
{
	set_sleep_mode(SLEEP_MODE_ADC);
	ADCSRA |= (1 << ADIE);
	sei();
}

EMPTY_INTERRUPT(ADC_vect);

void initADC(uint8_t channel)
{
	channel = pgm_read_byte(analog_pin_to_channel_PGM + (channel)); // convert the analogPIN
													// because beginning with ADC8, MUX = 1. so >> 3 to know whether MUX5 should be set to 1
	ADCSRB = (ADCSRB & ~(1 << MUX5)) | (((channel >> 3) & 0x01) << MUX5);
	ADMUX |= (1 << REFS0); // 0x01  Use voltage at AVcc; 

	DIDR2 = 0x08; // disable ADC11 digital input
	ADMUX |= channel & 0x07; // set channel low-four bits given the 0-7 or 8-15

	ADCSRA |= (1 << ADPS2) | (1 << ADPS0); // Prescaler 0b101 8MHz / 32 = 250kHz

	// ADMUX |= (1 << ADLAR); // left side alignment
	// ADCSRA |= (1 << ADEN); // enable ADC
}

uint16_t oversample16x(void)
{
	uint16_t oversampledValue = 0;
	uint8_t i;

	for (i = 0; i < 16; i++) {
		sleep_mode();
		oversampledValue += ADC;
	}

	return (oversampledValue >> 2);
}

void printFloat(float number) {
	number = round(number * 100) / 100; /* round off to 2 decimal places */
	transmitByte('0' + number / 10); /* tens place */
	transmitByte('0' + number - 10 * floor(number / 10)); /* ones */
	transmitByte('.');
	transmitByte('0' + (number * 10) - floor(number) * 10); /* tenths */	
	transmitByte('0' + (number * 100) - floor(number * 10) * 10); /* hundredths place */
	printString("\r\n");
}

uint16_t readADC()
{
	uint8_t high, low;

	ADCSRA |= (1 << ADSC); // first time ADC conversion, 25 clocks
	while (bit_is_set(ADCSRA, ADSC)); // busy wait first conversion result

	low = ADCL;
	high = ADCH;

	sample = (high << 8) | low;

	return high;
}

void setup()
{
	Serial.begin(115200);
	initUSART(BAUD_SETTING);
	//printString("\r\nDigital Voltmeter\r\n\r\n");
	initADC(analogPIN);
	setupADCSleepMode();
}

void loop()
{
	float voltage;
	voltage = oversample16x() * VOLTAGE_DIV_FACTOR * REF_VCC / 4096;
	// printFloat(voltage);
	Serial.println(voltage);
	delay(2);
}

