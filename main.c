#include <avr/io.h>
#include <util/delay.h>

#include <app_api.h>
#include <avr8-stub.h>

int main(void)
{
    debug_init(); // initialize the debugger

    // set PORTB5 as an output
    DDRB = DDRB | (1 << DDB5);

    breakpoint();

    for(;;)
    {
        // set PORTB5
        PORTB = PORTB | (1 << PORTB5);
        _delay_ms(1000);

        // unset PORTB5
        PORTB = PORTB & ~(1 << PORTB5);
        _delay_ms(1000);
    }
}
