; Marcel Jarosz, ARKO 2020L, x86_1, Final version
; EAN-13 Barcode Generator
SECTION .DATA
    encoding: db "AAAAAAAABABBAABBABAABBBAABAABBABBAABABBBAAABABABABABBAABBABA", 60, 0
    a_code: db "0001101001100100100110111101010001101100010101111011101101101110001011", 70, 0
    b_code: db "0100111011001100110110100001001110101110010000101001000100010010010111", 70, 0
    c_code: db "1110010110011011011001000010101110010011101010000100010010010001110100", 70, 0

SECTION .bss
    result: resb 97

SECTION .TEXT
    global _func, _create_bin_data, _get_encoding_function
    extern puts
_create_bin_data:
create_bin_data:
    push ebp
    mov ebp, esp
creating_the_result:
    mov eax, result
    mov ebx, [ebp+8]
    inc ebx
    mov ecx, [ebp+12]
    ;call calc_control_digit_function
    call create_bin_data_function
exit:
    mov esp, ebp
    mov eax, result   ;returns bin(char) representation of the barcode
    pop ebp
    ret

; ==================FUNCTIONS=====================

create_bin_data_function:   ;converts input into readable '1's and '0's
    start:                  ;start symbol
        mov [eax], byte '0'
        inc eax
        mov [eax], byte '1'
        inc eax
        mov [eax], byte '0'
        inc eax
        mov [eax], byte '1'
        inc eax
    a_b_type:   ;left part of the barcode
        mov esi, eax ;copy for counting length
        add esi, 7
        movzx edx, byte [ebx]
        sub edx, 48
        mov edi, edx
        shl edx, 3
        sub edx, edi
        cmp [ecx], byte 'A'
        je a_type
        jg b_type
        jl mid_chk
        a_type:
            mov edi, a_code
            add edi, edx
            inc ecx
            inc ebx
            a_loop:
                cmp eax, esi
                je a_b_type
                movzx edx, byte [edi]
                mov [eax], dl
                inc edi
                inc eax
                jmp a_loop
        b_type:
            mov edi, b_code
            add edi, edx
            inc ecx
            inc ebx
            b_loop:
                cmp eax, esi
                je a_b_type
                movzx edx, byte [edi]
                mov [eax], dl
                inc edi
                inc eax
                jmp b_loop
    mid_chk:    ;middle point symbol
        mov [eax], byte '0'
        inc eax
        mov [eax], byte '1'
        inc eax
        mov [eax], byte '0'
        inc eax
        mov [eax], byte '1'
        inc eax
        mov [eax], byte '0'
        inc eax
    c_type:     ;right part of the barcode
        mov esi, eax ;copy for counting length
        add esi, 7
        movzx edx, byte [ebx]
        cmp edx, ' '
        jl stop
        inc ebx
        sub edx, 48
        mov edi, edx
        shl edx, 3
        sub edx, edi
        mov edi, c_code
        add edi, edx
        c_loop:
            cmp eax, esi
            je c_type
            movzx edx, byte [edi]
            mov [eax], dl
            inc edi
            inc eax
            jmp c_loop
    stop:       ;stop symbol
        mov [eax], byte '1'
        inc eax
        mov [eax], byte '0'
        inc eax
        mov [eax], byte '1'
        inc eax
        mov [eax], byte '0'
        inc eax
    bin_data_exit:
        ret

calc_control_digit_function: ;calculates the control digit and puts it as a last digit in the code
        mov ecx, [ebp+8]
        mov esi, 0x01
        mov eax, 0x00
    get_control_digit:
        movzx edx, byte [ecx]
        ; eax - sum
        ; ebx - temp for mul 3
        ; ecx - code string ptr
        ; edx - char
        ; esi - odd/even
        cmp edx, 0x20
        jl put_control_digit
        cmp esi, 0x01
        je odd
        sub edx, 0x30
        mov ebx, edx
        shl edx, 2
        sub edx, ebx
        add eax, edx
        mov esi, 0x01
        inc ecx
        jmp get_control_digit
    odd:
        sub edx, 0x30
        add eax, edx
        mov esi, 0x00
        inc ecx
        jmp get_control_digit

    put_control_digit:
        push ecx
        mov esi, 10
        mov edx, 0x00
        mov ecx, 0x0a
        div ecx
        sub esi, edx
        cmp esi, 10
        jl pre_exit
        mov esi, 0
    pre_exit:
        add esi, 0x30
        pop ecx
        mov [ecx], esi
        mov esi, 0x00
        ret

