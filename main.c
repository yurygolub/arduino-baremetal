#include <avr/io.h>
#include <util/delay.h>

#ifdef DEBUG
#include <avr8-stub.h>
#endif

int main(void)
{
#ifdef DEBUG
    debug_init(); // initialize the debugger
    breakpoint();
#endif

    int a = 1;

    a += 3;
    a += 5;

#ifdef DEBUG
    breakpoint();
#endif

    // set PORTB5 as an output
    DDRB = DDRB | (1 << DDB5);

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
