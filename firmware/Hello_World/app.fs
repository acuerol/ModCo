: send_inc_addres \ ( data add -- addr +1 )
  swap  over ! 1+
;

: num2char
d# 48 + 
;

: multiplier	\ implementado con manejo del stack
d# 0 d# 12 d# 7
begin  
dup d# 1 and 0= invert  if swap rot swap dup rot + swap rot then 
d# 1 rshift swap d# 1 lshift swap
dup 0= until 2drop emit-uart 
;

: fibonaccis
d# 1 d# 0 d# 10 d# 0 
do
  over + dup emit-uart swap
loop
;

variable now
variable ant

: fibonacci
d# 1 now ! d# 0 ant !  
d# 4 d# 0
do
  now dup @ emit-uart drop
  now dup @ swap drop ant dup @ swap drop +
  now dup @ ant ! drop
  now !  
loop
;

: multiplicar		 \ utiliza peripheral_mult.v
swap multi_a !
multi_b !
d# 1 multi_init !
begin multi_done @ d# 1 = until \ espera hasta que la señal done del multiplicador este en 1
multi_pp_high @
multi_pp_low @
\ d# 2 + multi_a !
;

: dividir		 \ utiliza peripheral_div.v
swap div_a !
div_b !
d# 1 div_init !
begin div_done @ d# 1 = until \ espera hasta que la señal done del divisor este en 1
div_c @
\ d# 3 + div_a !
;

: usar_dpRAM \ envia los 6 primeros terminos de la serie de Fibonnacci a la dpRAM, el periferico invierte su orden, luego son leidos de vuelta

d# 1 h# 7000 !  \ escribe 1 en el registro h# 7000
d# 2 h# 7002 !  \ escribe 2 en el registro h# 7002
d# 3 h# 7004 !  \ escribe 3 en el registro h# 7004
d# 5 h# 7006 !  \ escribe 4 en el registro h# 7006
d# 8 h# 7008 !  \ escribe 8 en el registro h# 7008
d# 13 h# 700A !  \ escribe 13 en el registro h# 700A

begin h# 7008 @ d# 2 = until \ espera hasta que el registro 7008 sea 2, o sea hasta que el periferico reorganize la secuencia

h# 7000 @ \ lee lo que hay en el registro h# 7000, queda almacenado en la pila
h# 7002 @ \ lee lo que hay en el registro h# 7002, queda almacenado en la pila
h# 7004 @ \ lee lo que hay en el registro h# 7004, queda almacenado en la pila
h# 7006 @ \ lee lo que hay en el registro h# 7006, queda almacenado en la pila
h# 7008 @ \ lee lo que hay en el registro h# 7008, queda almacenado en la pila
h# 700A @ \ lee lo que hay en el registro h# 700A, queda almacenado en la pila
;

: emit_ciclo
	d# 2 begin
		dup emit-uart
		1+ dup
		d# 200 >
	until
;

: dar_tiempo
	d# 0 begin
		1+ dup
		d# 10 >
	until
;

: emit_1
	h# A emit-uart
;

: emit_2
	h# B emit-uart
;

: emit_3
	h# C emit-uart
;

: main 	
	
	(
	s" AT+CWMODE?" type-uart
	h# 0d emit-uart h# 0a emit-uart
	)
	
	d# 0 begin
		d# 2000 count
		d# 2 emit-uart	
	1+ again

;
