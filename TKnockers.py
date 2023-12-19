from machine import ADC, Pin
import math
import utime
import ustruct
import random

THRESHOLD = 1000 # Ignore sensor values below this value

#Hardware
led = Pin(25, Pin.OUT)
knock = ADC(26)
uart = machine.UART(0,31250)

def debounce_knock_read(threshold, bounce):
    # it needs to be stable for a continuous 20ms
    klvl = knock.read_u16()
    b = 1
    t = 1
    while t < bounce / 1:
        klvl2 = knock.read_u16()
        if klvl2 > 0:
            klvl += klvl2
            b += 1
        t += 1
        utime.sleep_ms(1)
    return math.floor(klvl / b)
    
while True:          
    knockLvl = debounce_knock_read(THRESHOLD, 500)
    #if knockLvl > THRESHOLD:
    print(f"KNOCK:{knockLvl}")
    #utime.sleep_ms(1)
