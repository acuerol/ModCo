: dar_tiempo
	d# 0 begin
		d# 4 d# 5 multiplicar
		drop
		1+ dup
		d# 100 >
	until
;

: main 
	s" HOLA" type-uart
	dar_tiempo
	d# 5 emit-uart
;

( emite HOLA y no más )
