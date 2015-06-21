variable length
variable addr_start
variable addr
variable pos

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
	
	length2 get length get = if
		begin
		addr get load-str addr2 get load-str = if
			h# 1 flag !
		else
			h# 0 flag !
		then
				
		pos get h# 1 + pos !
		flag get 0= until
	else
		h# 0 flag !
	then
	
	flag get
;

variable length2
variable addr2
variable addr_temp

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

: contains
	
;

variable c
variable flag

: first-index ( c addr_start )
	dup 1+ addr_start ! load-str length !
	c !
	
	d# 1 flag !
	h# 0 pos !
	
	begin
		pos get addr_start get + load-str			( pos+addr_start ) ( c{pos+addr_start} )
		c c@ = if											( c{pos+addr_start} c{c} ) ( flag )
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

: last-index
	
;

: length
	
;

: replace
	
;

: substring
	
;
