;Ahmad Barhoum 

;this program will keep taking the date and time from the computer
;convert them to a readable format and orint them 
;tell the user enters 'ESC' on the keyboard
 
.MODEL SMALL
.STACK 100h
 .DATA 
   ;this section contains all data to be used in the program
Message0 DB 0ah,0dh,'Press (ESC) to stop the program',0ah,0dh,'$'
Message DB 0ah,0dh,'Ahmad Barhoum  ','$' 
Message1 DB '1183231',0ah,0dh,'$' 
Message2 DB 0ah,0dh,'date and time : ' ,0ah,0dh,'$' 

   .CODE   



MOV AX,@DATA  
MOV DS,AX         ;set DS to the data segement
LEA DX, Message0  ; point to the offset address of message , the data will be printed must be in dx
MOV AH,09h       ; function to print string till it's end ($)
int 21h 








   
     main:
mov ah,0bh ; read the status of the stdin
int 21h
cmp al,0ffh ; FF there is character , 00 there is no character
jnz skip
mov ah,8 ; read character
int 21h
cmp al,27
jz exit
skip:
mov ah,2ch
int 21h
mov dl,dh
and dl,0fh
add dl,48
;mov ah,2
;int 21h
mov ah,2
mov dl,13
int 21h  
   
   
   
    MOV AX,@DATA  
MOV DS,AX         ;set DS to the data segement
LEA DX, Message  ; point to the offset address of message , the data will be printed must be in dx
MOV AH,09h       ; function to print string till it's end ($)
int 21h          ; Execute
call printColon  ;function call to print ':'
 
LEA DX, Message1
MOV AH,09h
int 21h
LEA DX, Message2
MOV AH,09h
int 21h

time proc near  
   
    ;to do the operation on the data coming from 2ch function
    ;to then print it in a readable format 
    
    
mov ax,2c00h         ;get the time of the computer /dos function
int  21h      ;to excute the function

;the return values from 2ch function are as the follows 
 
;DL :hundredths of a second
;DH : seconds 
;CH : hour
;CL : minutes 

     ;Save the values of the registers in the stack to be sure 
     ;values will not be lost 

  push dx
  push cx  
   mov  ah,0 
   
   mov  al,ch          ;dividend
   mov  cl,10          ;divisor
   div  cl             ;remainder will be saved in ah and quotient will be saved in al

   push ax           
   ;save the division result in the stack
   or  al,30h                      
   ;this or is to invert the hours to decimal format

   mov  dl,al
   mov  ah,02h
   int  21h         
   ; print first digit of hours

   pop  ax       ;retrieve quotient and remainder
   or   ah,30h   ;this or is to invert untis of hours to decimal format
   
   ; print second digit:
   mov  dl,ah
   mov  ah,02h
   int  21h   

    call printColon  ;print ":"  after printing hours

   pop cx                     ;retrieve minutes

   mov  ah,0
   mov  al,cl
   mov  cl,10
   div  cl

   push ax             
     ;save quotient & remainder

   or  al,30h                  
       ;tens of minutes to ascii

   mov  dl,al
   mov  ah,02h
   int  21h

    pop ax                       
       ;retrieve quotient & remainder

   or   ah,30h                 
    ;units of minutes to ascii

   mov  dl,ah
   mov  ah,02h
   int  21h

    call printColon    
    ; print ':' after minutes
    
    ;Seconds
    

   pop  dx                          
   ;retrieve seconds and hundredths of a second
   push dx                         
    ;save it again

   mov  ah,0
   mov  al,dh                       
   ;seconds
   mov  cl,10
   div  cl

    push ax                        
     ;save tens and units of seconds

    or  al,30h                      
    ;tens of seconds to ascii

    mov dl,al
    mov ah,02h
    int 21h

    pop ax

    or  ah,30h                      
     ;units of seconds to ascii
    mov dl,ah
    mov ah,02h
    int 21h

    call printColon  ;print ':' after seconds
    
   ; hundredths of a second
    pop dx                       
     ;retrieve seconds and hundredths of a second

   mov  ah,0
   mov  al,dl                      
   
    ;hundredths of a second
   mov  cl,10
   div  cl

    push ax                        
     

    or  al,30h                    
    
      ;tens of hundredths of a seconds to ascii

    mov dl,al
    mov ah,02h
    int 21h

    pop ax

    or  ah,30h                      
     ;units of hundredths of a second to ascii
    mov dl,ah
    mov ah,02h
    int 21h

    call printSpace 
    
    

   mov ax,2a00h                     
  ;get the date of the computer 
   int  21h
   ;Execution
   
 ;the return values from 2ch function are as the follows 



;AL day of the week as numbers starts from sunday=0 ,...
;DL :the day
;DH :the month
;CX :the year from 1980 to 2099





    push CX 
    ;save the  year in the stack
    push DX                         
    ;save the  month (DH) and the day (DL) in the stack

  ;DAY
   mov  ah,0   ;in order to make the devision with the right values 
   ;so al will keep it is value as it is , and ah will be 00
   mov  al,dl     
                     
   mov  cl,10
   div  cl      
   ; al has the quotient of the division
   ;and ah has the remainder of the devision
   

    push ax   
     

    or  al,30h   
    ;tens of day to ascii

    mov dl,al
    mov ah,02h
    int 21h   
     ; print first digit in day
    

    pop ax  
     ;to print unit return the al , ah of days 

    or  ah,30h    
    ;units of day to ascii
    mov dl,ah
    mov ah,02h
    int 21h

    call printSlash 
    ;MONTH
    

    pop dx        
    ;retrieve month (dh) 

   mov  ah,0
   mov  al,dh       
    ;month
   mov  cl,10
   div  cl

    push ax                 
     ;save al and ah in the stack
                                                     
    or  al,30h               
     ;tens of month to ascii

    mov dl,al
    mov ah,02h
    int 21h

    pop ax

    or  ah,30h               
     ;units of month to ascii
    mov dl,ah
    mov ah,02h
    int 21h

    call printSlash ;to print '/' after 
     
    
 ;YEAR;
    
    pop ax                          
    ;year
    mov dx,0                       
     ;clear the most significant byte of dividend then divide it by 1K to get the thousands only
    mov cx,1000                     
    div cx                         
     ;quotient in ax, remainder in dx

    push dx                         
    ;save remainder

    or  al,30h                     
     ;convert to ascii
    mov ah,02h
    mov dl,al
    int 21h

    pop ax                          
    ;retrieve remainder

    mov dx,0                        
    ;clear most significant bit
    mov cx,100                      
    ;get hundreds
    div cx                          
    ; remainder in dx 
    ;quotient in ax

    push dx                        
     ;save remainder

    or  al,30h                     
     ;convert to ascii
    mov ah,02h
    mov dl,al
    int 21h

    pop ax                         
     ;retrieve remainder

    mov dx,0                       
     ;clear most significant bit
    mov cx,10                       
    ;get tens
    div cx                          


    push dx                       
      ;save remainder which is stored in dx

    or  al,30h                    
    ;convert to ascii
    mov ah,02h
    mov dl,al
    int 21h

    pop ax                         
     ;retrieve remainder 
     
     
     or al,30h                      
     
     ;convert to ascii
     
     
     
         mov ah,02h                     
    
    
    mov dl,al
    int 21h
;the functions
         
   
   jmp main  ;in order to intialize a loop and go back to line  16
   exit:
   mov  aX,4c00h                    
     ;DOS terminate program function
   int  21h                        
    ;terminate the program
    endp
   
   
   ;near is usd as the function and it's call are at the same code segment
   
printSpace proc near
    
      ;to keep the value of ax and dx as the same as it was before using them in this function
    push ax  
    ;saving them in the stack before editting them
    push dx
    mov ah,02
    mov dl,' ' ;print space
    int 21h
    pop dx 
    ;pop their value out of the stack
    pop ax
    ret   
    ;to go back to the next line after the call was executed before to execute this function
    endp

printColon proc near
    push ax
    push dx
    mov ah,02
    mov dl,':' ;print the ':'
    int 21h 
    ;to Execute the fuunction (print a character':')
    
    pop dx
    pop ax
    ret
    endp

printSlash proc near
    push ax
    push dx
    mov ah,02
    mov dl,'/'
    int 21h
    pop dx
    pop ax
    ret
endp 
;to determine the end of the function


    



   END