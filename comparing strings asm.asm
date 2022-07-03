;this program will compare the first string with "BUG" string,
;if it equals it , it will display Y,
;if it is not it will display N.
;You can edit the string
.MODEL small
.DATA
tobecompared db "SbSSSDFSSDSDUGLSDFDKLNSLVSLVNKBUS", '$'
word db "BUG",'$'
.CODE
mov ax,@data
mov ds,ax
mov es,ax
;ds and es now are on the same address
; si associated with ds, and di associated with es
mov di, OFFSET tobecompared ;save the string in di
mov cx , 32
L1:
mov al , 0
mov si , offset word
lodsb    ; causes a byte to be loaded into AL, so it will equal b

scasb  ;The opcode used for byte comparison
je equal-b  ;when B found
loop L1   ;si increment
jmp print

equal-b:

DEC CX ; WE decrement it because when the program access here the it will not pass with loop in L1
mov al , 0
lodsb
scasb

je equal-u  ;when U found

loop L1
jmp print;this will print that there is no equality

equal-u:
DEC CX ; WE decrement it because when the program access here the it will not pass with loop in B_found
mov al , 0
lodsb
scasb
je equal-g   ;when g found
loop L1
jmp print




print:
mov dl,'N'
mov ah,2
int 21h
jmp exit

equal-g:
mov dl,'Y'
mov ah,2
int 21h
jmp exit

exit:
mov AH,4cH ;exit to DOS
int 21H
END ;end of file