; Marcel Jarosz, ARKO 2020L, x86_2, Final version
; EAN-13 Barcode Generator
SECTION .DATA
    encoding: db "AAAAAAAABABBAABBABAABBBAABAABBABBAABABBBAAABABABABABBAABBABA", 60, 0
SECTION .bss
    chosen_encoding: resb 20

SECTION .TEXT
    global _get_encoding
    extern puts
_get_encoding:
get_encoding:
    get_encoding_function:  ;copies correct part of the encoding
        push ebp
        mov ebp, esp
        sub esp, 0
        mov ebx, [ebp+8]
        movzx eax, byte [ebx]
        mov ecx, encoding
        deb:
            sub eax, 0x30
        mov ebx, 6
        mul ebx
        add ecx, eax
        mov eax, ecx
        add eax, 0x06
        mov ebx, chosen_encoding
        loop_en:
            movzx edx, byte [ecx]
            h1:
            mov [ebx], dl
            h2:
            inc ecx
            h3:
            inc ebx
            h4:
            cmp ecx, eax
            h5:
            je enc_exit
            jmp loop_en
        enc_exit:
            ;push chosen_encoding
            ;call puts
            ;add esp, 4
            mov esp, ebp
            mov eax, chosen_encoding
            pop ebp
            ret
