%macro EXIT 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

%macro putchar 1
    pushd
    jmp %%work
    %%char db %1
%%work:
    mov eax, 4
    mov ebx, 1
    mov ecx, %%char
    mov edx, 1
    int 0x80
    popd
%endmacro

%macro const_print 1
    pushd
    jmp %%print 
    %%str db %1, 0xA
    %%len equ $ - %%str
%%print:  
    mov eax, 4
    mov ebx, 1
    mov ecx, %%str
    mov edx, %%len
    int 0x80
    popd
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro printd 0
    pushd
    mov bx, 0
    mov ecx, 10
    %%_divide:
    mov edx, 0
    div ecx
    push dx
    inc bx
    test eax, eax
    jnz %%_divide
    %%_digit:
    pop ax
    add ax, '0'
    mov [result], ax
    print 1, result
    dec bx
    cmp bx, 0
    jg %%_digit
    popd
%endmacro

%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro


section .text
    global _start

_start:
    mov ebx, 0
    mov eax, 0
_sum_x:
    add al, [x + ebx*4]
    inc ebx
    cmp ebx, array_len
    jl _sum_x

    mov [x_sum], eax
    mov ebx, 0
    mov eax, 0
_sum_y:
    add al, [y + ebx*4]
    inc ebx
    cmp ebx, array_len
    jl _sum_y

    mov [y_sum], eax
    xor edx, edx
    mov ebx, [x_sum]
    sub eax, ebx
    putchar 0xA
    mov ebx, array_len
    div ebx
    const_print "Среднее арифметическое разности двух массивов: "
    printd
    putchar '.'
    mov eax, edx
    printd
    putchar 0xA
    mov eax, array_len
    putchar 0xA

    print nl_len, new_line
    print len, message
    print nl_len, new_line

    EXIT 0

section .data
    x dd 5, 3, 2, 6, 1, 7, 4
    y dd 0, 10, 1, 9, 2, 8, 5
    array_len equ ($ - y) / 4
    new_line db 0xA, 0xB
    nl_len equ $ - new_line
    message db "Done!"
    len equ $ - message
section .bss
    result resb 1
    x_sum resb 10
    y_sum resb 10
