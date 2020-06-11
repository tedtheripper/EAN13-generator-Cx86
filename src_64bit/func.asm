; Marcel Jarosz, ARKO 2020L, x64_1, Final version
; EAN-13 Barcode Generator
SECTION .DATA
    encoding: db "AAAAAAAABABBAABBABAABBBAABAABBABBAABABBBAAABABABABABBAABBABA", 60, 0
    a_code: db "0001101001100100100110111101010001101100010101111011101101101110001011", 70, 0
    b_code: db "0100111011001100110110100001001110101110010000101001000100010010010111", 70, 0
    c_code: db "1110010110011011011001000010101110010011101010000100010010010001110100", 70, 0

SECTION .bss
    result: resb 97

SECTION .TEXT
    global _func, create_bin_data, get_encoding_function
    extern puts
create_bin_data:
_create_bin_data:
    push rbp
    mov rbp, rsp
creating_the_result:
    mov rax, result
    mov rbx, rdi
    inc rbx
    mov rcx, rsi
    call create_bin_data_function
exit:
    mov rsp, rbp
    mov rax, result   ;returns bin(char) representation of the barcode
    pop rbp
    ret

; ==================FUNCTIONS=====================

create_bin_data_function:   ;converts input into readable '1's and '0's
    start:                  ;start symbol
        mov [rax], byte '0'
        inc rax
        mov [rax], byte '1'
        inc rax
        mov [rax], byte '0'
        inc rax
        mov [rax], byte '1'
        inc rax
    a_b_type:   ;left part of the barcode
        mov rsi, rax ;copy for counting length
        add rsi, 7
        movzx rdx, BYTE [rbx]
        sub rdx, 48
        mov rdi, rdx
        shl rdx, 3
        sub rdx, rdi
        cmp [rcx], BYTE 'A'
        jg b_type
        jl mid_chk
        a_type:
            mov rdi, a_code
            add rdi, rdx
            inc rcx
            inc rbx
            a_loop:
                cmp rax, rsi
                je a_b_type
                movzx rdx, byte [rdi]
                mov [rax], dl
                inc rdi
                inc rax
                jmp a_loop
        b_type:
            mov rdi, b_code
            add rdi, rdx
            inc rcx
            inc rbx
            b_loop:
                cmp rax, rsi
                je a_b_type
                movzx rdx, byte [rdi]
                mov [rax], dl
                inc rdi
                inc rax
                jmp b_loop
    mid_chk:    ;middle point symbol
        mov [rax], byte '0'
        inc rax
        mov [rax], byte '1'
        inc rax
        mov [rax], byte '0'
        inc rax
        mov [rax], byte '1'
        inc rax
        mov [rax], byte '0'
        inc rax
    c_type:     ;right part of the barcode
        mov rsi, rax ;copy for counting length
        add rsi, 7
        movzx rdx, BYTE [rbx]
        cmp rdx, '0'
        jl stop
        cmp rdx, '9'
        jg stop
        inc rbx
        sub rdx, 48
        mov rdi, rdx
        shl rdx, 3
        sub rdx, rdi
        mov rdi, c_code
        add rdi, rdx
        c_loop:
            cmp rax, rsi
            je c_type
            movzx rdx, byte [rdi]
            mov [rax], dl
            inc rdi
            inc rax
            jmp c_loop
    stop:       ;stop symbol
        mov [rax], byte '1'
        inc rax
        mov [rax], byte '0'
        inc rax
        mov [rax], byte '1'
        inc rax
        mov [rax], byte '0'
        inc rax
    bin_data_exit:
        ret
