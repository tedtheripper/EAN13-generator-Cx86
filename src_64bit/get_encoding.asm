; Marcel Jarosz, ARKO 2020L, x64_2, Final version
; EAN-13 Barcode Generator
SECTION .data
    encoding: db "AAAAAAAABABBAABBABAABBBAABAABBABBAABABBBAAABABABABABBAABBABA", 60
SECTION .bss
    chosen_encodin: resb 20

SECTION .TEXT
    global get_encoding
get_encoding:
    get_encoding_function:  ;copies correct part of the encoding
        push rbp
        mov rbp, rsp
        sub rsp, 0
        mov rbx, [rdi]
        movzx eax, bl
        mov ecx, encoding
        deb:
            sub eax, 0x30
        mov rbx, 6
        mul rbx
        add rcx, rax
        mov rax, rcx
        add rax, 0x06
        mov rbx, chosen_encodin
        loop_en:
            movzx rdx, byte [rcx]
            mov [rbx], dl
            inc rcx
            inc rbx
            cmp rcx, rax
            jl loop_en
        enc_exit:
            mov rsp, rbp
            pop rbp
            mov rax, chosen_encodin
            ret
