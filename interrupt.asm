;Last program was modified in order to display a number in decimal format using INT 62H.
;The code

.model small  
.data  

temp db 10 dup(?) ;as a stack


radex db 10 ;to set for decimal 
num dw 0efe4h ; the number to be converted 
mess db "welcome to encs311 lab $"
.code



mov ax,@data
mov ds,ax



org 100h ;force code at offset 100h
.startup

jmp enter    

interrupt proc

mov ax, 10h
   

mov cx, 0000 ; counter cleared      
mov bh,00

mov bl, 10; for decimal and clear bh

mov si, 0000
desplay1:
mov dx, 0000 ; clear dx
div bx ; divide dx:ax by 10
mov temp[si], dl ; save remainder 
inc si
inc cx ; count remainder
add ax, 00 ; check if the quotient is zero
; if it is not zero go back 
jnz desplay1 


dec si
desplay2:
mov dl, temp[si] ; get remainder
mov ah, 02h ; 
add dl, 30h ; convert to ascii
int 21h ;print the digit 
dec si
loop dispx2 ; loop for all digits


iret  

interrupt endp
enter:
;set  new interrupt vector.
mov ah, 25h 
mov al, 62h
mov dx, cs
mov ds, dx
mov dx, offset interrupt
int 21h

mov ax, 3100h
int 21h
end
