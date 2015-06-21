( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map multiplier:
h# 6700 constant multi_a	
h# 6702 constant multi_b
h# 6704 constant multi_init
h# 6706 constant multi_done
h# 6708 constant multi_pp_high
h# 670A constant multi_pp_low


\ memory map divider:
h# 6800 constant div_a		
h# 6802 constant div_b
h# 6804 constant div_init
h# 6806 constant div_done
h# 6808 constant div_c

\ Mapa de memoria de la UART.
h# 6900 constant uart_write
h# 6902 constant uart_read
h# 6904 constant uart_tx_busy
h# 6906 constant uart_rx_busy
h# 6908 constant uart_tx_init
h# 690A constant uart_rx_init
h# 690B constant uart_done
h# 690C constant uart_stop

\ Mapa de memoria de la RAM.
h# 7000 constant RAM_write
h# 7002 constant RAM_read
h# 7004 constant RAM_set_addr
h# 7008 constant RAM_init

\ Mapa de memoria del espDriver
h# 7100 constant module_rst

\ Mapa de memoria del Timer
h# 7200 constant timer_cycles
h# 7202 constant timer_rst

\ Mapa de memoria de la RAM.
h# 7300 constant strRAM_write
h# 7302 constant strRAM_read
h# 7304 constant strRAM_set_addr
h# 7308 constant strRAM_init


