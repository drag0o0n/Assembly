.model small
.data
message db 0dh,0ah,"enter number",0dh,0ah,"$"
message1 db "enter num of repeating",0Dh,0ah,"$"

.code

mov Ax,@data
mov ds,ax

LEA DX, MESSAGE1
MOV AH,09H
INT 21H

mov ah,01h
int 21h
mov bl,al
mov ah,0
 
lea dx,message
 mov ah,09h
 int 21h
 
 mov ah,01h
 int 21h

 
 
 mov ah,9
 ;mov al,bl
 mov bh,0
 ;mov bl,2fh 
 mov bh,0h 
 sub bx,30h
 mov cx,bx
 int 10h
end
