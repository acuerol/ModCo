include util_str.fs

: send_inc_addres \ ( data add -- addr +1 )
  swap over ! 1+
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

variable a

: main 	
	
	\ str-to_RAM y char-at
	
	s" Hola Mundo" str-to-RAM


\	h# 5 char-at emit-uart
	
	\ first-index
	 
\	s" Hola Mundo" h# 00 str-to-RAM
\	s" Prueba concat" h# AA str-to-RAM
	
\	h# 00 dup load-str h# AA dup load-str concat
	
\	h# 00 load-str
	
\	h# 74 h# 00 first-index emit-uart
	
\	d# 8 h# 00 char-at emit-uart
	
	
	
	\ h# 61 first-index emit-uart
	
	(
	s" AT+CWMODE?"
	over h# 4 + c@ emit-uart
	
	type-to-ESP
	)
	
	d# 0 begin
	
	(
		d# 2000 count
		d# 2 emit-uart	
	)
	1+ again
		
;
