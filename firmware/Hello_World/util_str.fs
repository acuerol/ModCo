variable addr
variable addr2
variable addr_start
variable addr_temp
variable length
variable length2
variable pos
variable pos_temp
variable flag
variable c

\ Test Util
: ver ( dat -- dat )
	h# 33 h# FF save-str
	dup h# FF save-str
;

: mark ( flag -- )
	h# 55 h# FF save-str
	h# FF save-str
;

\ over h# 5A save-str dup h# 5B save-str
\ Pasa length elementos a partir de addr a la RAM, partiendo de start, en start-1 almacena la longitud y en length+1 almacena h# 3 (end of text)
: str-to-RAM ( addr length addr_start -- )

	1+ addr_start !
	length !
	addr !
	h# 0 pos !
	
	length get h# 0 do					( length 0 )
		addr get pos get +				( addr pos ) ( addr+pos )						
		pos get addr_start get +		( addr+pos pos addr_start ) ( addr+pos pos+addr_start )
		swap c@ swap save-str			( pos+addr_start addr+pos ) ( pos+addr_start c{addr} ) ( c{addr} pos+addr_start )
		pos get 1+ pos !					( pos 1 )
		1+
	loop
	
	pos get addr_start get h# 1 - save-str
;

: char-at ( pos addr_start -- )
	+			( pos addr_start ) ( pos+addr_start)
	load-str
;

: compare ( addr1 length1 addr2 length2 )
	length2 ! addr2 ! length ! addr ! h# 1 flag ! h# 1 pos !
	
	length2 get load-str length get load-str = if
		begin
			addr get pos get + load-str addr2 get pos get + load-str = if
				h# 1 flag !
			else
				h# 0 flag !
			then
				
			pos get dup 1+ pos ! ( pos ) ( pos pos+1 ) ( pos )
			length get > flag get 0= or until
		else
			h# 0 flag !
	then
	
	flag get
;

: concat ( addr length addr2 length2 -- )
	h# 1 pos !
	length2 ! addr2 ! over over length ! addr ! + addr_temp ! ( addr1 length1 addr2 length2 ) ( addr1 length1 addr1 length1 ) ( addr1+length1 )
	
	addr2 get h# FE save-str
	
	begin
		addr_temp get pos get swap over + swap addr2 get + load-str swap save-str	
		pos get 1+ pos !
	pos get length get length2 get + > until
	pos get addr get save-str
;



\ Busca el string que comienza en addr en el string que empieza en addr2.
: contains ( addr length addr2 length2 -- )
	length2 ! addr2 ! length ! addr ! h# 2 flag ! h# 1 pos ! h# 1 pos_temp !
	
	length get length2 get < if
		begin
			addr2 get pos get + load-str addr get pos_temp get + load-str = if
				pos get 1+ pos !
				pos_temp get 1+ pos_temp !
				
				length2 get pos get < if \ Si supera la longitud de la cadena donde se busca.
					h# 0 flag !
					length get pos_temp get < if \ Si supera la longitud de la cadena buscada.
						h# 1 flag !
					then
				else
					length get pos_temp get < if \ Si supera la longitud de la cadena buscada.
						h# 1 flag !
					then			
				then
			else
				pos get 1+ pos !
				h# 1 pos_temp !
			then
		flag get 0= flag get h# 1 = or until
	else
		length get length2 get = if
			addr get length get addr2 get length2 get compare flag !
		else
			h# 0 flag ! \ Si la cadena buscada es más grande.
		then
	then
	
	flag get
;

\ Almacena en el stack la primera posición en la que se encuentra el caracter c dentro de la cadena con inicio en addr
: first-index ( c addr )
	dup 1+ addr ! load-str length ! c !
	
	d# 1 flag !
	h# 0 pos !
	
	begin
		pos get addr get + load-str					( pos+addr ) ( c{pos+addr} )
		c c@ = if											( c{pos+addr} c{c} ) ( flag )
			h# 0 flag !
		else
			pos get 1+ pos !								( pos 1 ) ( pos+1 )
		then
	flag get 0= pos get length get > or until
	
	flag get 0= if
		pos get
	else
		h# FF
	then
;

: last-index ( c addr )
	dup addr ! load-str length ! c !
	d# 1 flag !	h# 1 pos ! h# FF pos_temp !
	
	begin
		pos get addr get + load-str					( pos+addr ) ( c{pos+addr} )
		c c@ = if											( c{pos+addr} c{c} ) ( flag )
			pos get pos_temp !
			pos get 1+ pos !
		else
			pos get 1+ pos !								( pos 1 ) ( pos+1 )
		then
	pos get length get > until
	
	pos_temp get
;

\ Extrae un substring de longitud length de addr2 y lo guarda en addr1
: substring ( addr1 addr2 length -- )
	length ! addr2 ! addr ! h# 0 pos !
	
	begin
		addr2 get pos get + load-str addr get pos get + save-str
		pos get 1+ pos !
	pos get length get > until
;
