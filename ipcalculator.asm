  include "emu8086.inc"

NAM MACRO array, p1, p2, p3, p4 ,p5
    
    mov loopCon, 0
    mov si, 0
    mov al, array[si]
    sub al, 30h
    mov bl, 2
	
    p1:
    mov ah, 0
    mul bl
    inc si
    cmp array[si], '.'
    je p2
    add al, array[si]
    sub al, 30h
    mov dl, al
    
    add loopCon, 1
    cmp loopCon, 31
    jne p1
    jmp p5
	
    p2:
    mov ah, 0
    mov al, dl
    call print_num
    cmp loopCon, 1Ah
    jle p4
	
    p3:
    inc si
    mov al, array[si]
    mov ah, 0
    add loopCon, 1
    jmp p1
	
    p4:
    putc '.'
    jmp p3
	
    p5:
    mov al, dl
    mov ah, 0
    call print_num
	
ENDM

.model small
.stack 100h

.data

ipbinary db 35 dup('0')
netbin db 35 dup('0')
brdbin db 35 dup('1')
subnet db 35 dup('0')
wildmask db 35 dup('1')
mask db 2 dup(?)
ip db 4 dup(?)

loopCon db 0
dot dw 8
c dw 0
e dw 0
f dw 0
g db 10
prefix db 0

.code
main proc
    mov ax, @data
    mov ds, ax
   
    printn "Hello "
  
     
    printn "Welcome to our IP calculator"   

    start:
    print "Enter octet: "
    call    scan_num
    printn ""
    
    mov ip[si], cl  
    
    inc si
    inc e           
    
    cmp e, 4
    jne start      
    
    

 
    printn ""
    print "Prefix: "
    
    mov cx, 2               
    mov si, 0
    prefixing:
    mov ah, 1
    int 21h
    cmp al, 13              
    je calc
    mov mask[si],al
    inc si
    loop prefixing

    calc:
    cmp si, 1               
    je line1
	
    
    mov dx, 0
    mov cx, si
    mov si,0
    multiple:
    mov al, mask[si]
    sub al, 30h             
    mov bl, g
    mul bl
    add dx, ax             
    mov g,1
    inc si
    loop multiple
    
    mov prefix, dl         
    mov dx, 0
    mov ax, 0
    
    jmp print
    
    line1:                 
    mov si, 0
    mov al, mask[si]
    mov prefix, al
    sub prefix, 30h
    

    print:
    mov e, 0
    printn ""
    printn ""
    print "IP Address: "    
    mov cx, 3                
    mov si, 0
    
    move:
    mov al, ip[si]
    mov ah, 0
    call print_num
    mov dl, '.'              
    mov ah, 2
    int 21h
    inc si
    loop move
    mov al, ip[si]
    mov ah, 0
    call print_num
	

    mov c, 7                     
    mov si, 0
    mov f, 4                     
    
    moving:
    mov ah, 0
    mov al, ip[si]               
    mov e, si
    mov bh, 0
    
    MOV bl, 2                    
    mov si, c
    
    calcbinary:
    div bl                        
    add ah, '0'                 
    mov ipbinary[si], ah          
    mov ah, 00                    
    dec si
    cmp al, 00                     
    jne calcbinary
	
    mov si, dot
    mov ipbinary[si], '.'          
    mov netbin[si], '.'
    mov brdbin[si], '.'
    mov subnet[si], '.'
    mov wildmask[si], '.'
    
    add e, 1                     
    mov si, e
    
    add c, 9                      
    add dot, 9                    
        
    sub f, 1
    cmp f, 0                      
    
    jne loop moving


    cmp prefix, 8
    jle netpart1
    cmp prefix, 16
    jle part1
    jmp check1
    
    part1:
    add prefix, 1
    jmp netpart1
     
    check1:
    cmp prefix, 24
    jle part2
    jmp check2
    part2:
    add prefix, 2
    jmp netpart1
    
    check2:
    add prefix, 3
    
    netpart1:
    mov si, 0
    add cl, prefix
    mov ch, 0
    networking:
    mov bl, ipbinary[si]
    mov netbin[si], bl
    inc si
    loop networking
    
  
    printn ""
    printn ""
    print "Network Address: "
    NAM netbin, n1 ,n2, n3, n4, n5
    

    brdcast:
    mov cl, prefix
    mov ch, 0
    mov si, 0
    brdcalc:
    mov al, netbin[si]
    mov brdbin[si], al
    inc si
    loop brdcalc
    
   
    printn ""
    printn ""
    print "Broadcast Address: "
    NAM brdbin , b1, b2, b3, b4, b5
   

    mov cl, prefix
    mov ch, 0
    mov si, 0
    mov subnet[si], 31h
    sub cl, 1
    mov si, 1
    subcalc:
    cmp subnet[si], 46
    je temp
    mov subnet[si], 31h
    temp:
    inc si
    loop subcalc
    
 
    printn ""
    printn ""
    print "Subnet Mask Address: "
    NAM subnet, s1, s2, s3, s4, s5
        

    mov si, 34
    add netbin[si], 1
    
    
    printn ""
    printn ""
    print "First Host Address: "
    NAM netbin, f1, f2, f3, f4, f5


    mov si, 34
    mov brdbin[si], 30h
    
    
    printn ""
    printn ""
    print "Last Host Address: "
    NAM brdbin, l1, l2, l3, l4, l5


    mov cl, prefix
    mov ch, 0
    mov si, 0
    mov wildmask[si], 30h
    sub cl, 1
    mov si, 1
    
    wildcalc:
    cmp wildmask[si], 46
    je temp1
    mov wildmask[si], 30h
    temp1:
    inc si
    loop wildcalc
  
    printn ""
    printn ""
    print "Wild Mask Address: "
    NAM wildmask, w1, w2, w3, w4, w5
    
    mov ah, 4ch
    int 21h  
    main endp
     define_scan_num
    define_print_string
    define_print_num
    define_print_num_uns
    define_clear_screen

end main




