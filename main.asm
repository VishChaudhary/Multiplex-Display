;
; multiplex_display.asm
;
; Created: 11/3/2021 11:13:30 AM
; Author : vish75000
;


; Replace with your application code
.dseg

bcd_entries: .byte 4
led_display:     .byte 4
digit_num: .byte 1

.cseg

setup:
ldi r16, 0xFF	;load r16 with all 1s
sts PORTD_DIR, r16    ;Set vportd as outputs
sts PORTA_DIR, r16		;set vporta as output
ldi r16, 0x00		;load r16 with all 0s
sts PORTC_DIR, r16    ;set vportc as inputs

main:
rcall multiplex_display
rjmp main

multiplex_display:
multiplex_display_push:		;saves r16, r17, and r18 on the stack
push r16		
push r17
push r18

turn_off:
ldi r16, 0xFF
sts PORTA_OUT, r16

lds r17, digit_num        ;load digit_num into r17
inc r17                    
cpi r17, 0x04            ;compare digit_sum to 4
breq overflow            ;next digit becomes 0

output:
sts digit_num, r17
ldi ZH, HIGH(led_display)
ldi ZL, LOW(led_display)
ldi r18, 0x00
add ZL, r17
adc ZH, r18
ld r16, Z
sts PORTD_OUT, r16        ;outputing that number

checking_what_digit:
cpi r17, 0x00            ;compare digit_num to 0
breq digit0
cpi r17, 0x01            ;compare digit_num to 1
breq digit1
cpi r17, 0x02            ;compare digit_num to 2
breq digit2
cpi r17, 0x03            ;compare digit_num to 3
breq digit3

digit0:
ldi r18, 0x70            ;0111 0000 turning on rightmost digit
sts PORTA_OUT, r18
rjmp multiplex_display_pop
 
digit1:
ldi r18, 0xB0            ;1011 0000 turning on second rightmost digit
sts PORTA_OUT, r18
rjmp multiplex_display_pop

digit2:
ldi r18, 0xD0            ;1101 0000 turning on second leftmost digit 
sts PORTA_OUT, r18
rjmp multiplex_display_pop

digit3:
ldi r18, 0xE0            ;1110 0000 turning on leftmost digit
sts PORTA_OUT, r18
rjmp multiplex_display_pop

multiplex_display_pop:		;restoring r16, r17, r18 from the stack
pop r18
pop r17
pop r16
ret

overflow:
ldi r17, 0x00            ;setting digit_num to 0
sts digit_num, r17
ldi ZH, HIGH(led_display)    ;resetting the pointer
ldi ZL, LOW(led_display)
rjmp output
