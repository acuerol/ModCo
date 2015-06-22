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

: main
	s" Inicia" type-uart emit-cmd-end
	
	listen-and-save	
	received-uart dup load-str type-str-uart

	s" Final" type-uart emit-cmd-end
	(
	s" AT+CWMODE?" h# 00 str-to-RAM \ h# 00 str-to-RAM
	h# 00 dup load-str type-str-uart
	h# 0d emit-uart h# 0a emit-uart
	
	d# 1000 count
	
	s" AT+CWMODE=1" h# 00 str-to-RAM \ h# 00 str-to-RAM
	h# 00 dup load-str type-str-uart
	h# 0d emit-uart h# 0a emit-uart
	
	d# 1000 count
	
	s" AT+CWMODE?" h# 00 str-to-RAM \ h# 00 str-to-RAM
	h# 00 dup load-str type-str-uart
	h# 0d emit-uart h# 0a emit-uart
	
	h# 63 emit-uart
	listen-and-save
	h# 64 emit-uart
	h# 64 load-str emit-uart
	)
	\ type-str-uart
	
	\ listen-and-save
	\ h# 64 dup load-str type-str-uart
	
\	h# 00 dup load-str h# CC dup load-str contains emit-uart
	
\	s" Hola Mundo" h# 00 str-to-RAM
	
\	h# AA h# 05 h# 3 substring
\	h# AA dup load-str type-str-uart
	
\	h# 6F h# 00 last-index emit-uart
	
	(
	s" Hola Mundoi" h# 00 str-to-RAM
	s" Hola Mundo" h# CC str-to-RAM
	
	h# 00 dup load-str h# CC dup load-str compare emit-uart
	)

\	h# 5 char-at emit-uart
	
\ 	h# 61 h# CC first-index emit-uart
	 
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
\		d# 5000 count
	1+ again
		
;
