;number gussing game

includelib ucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN srand: PROC
EXTERN rand: PROC
EXTERN scanf: PROC
EXTERN _time64: PROC


.DATA
    StrAskNumber      DB    "Guess the number (between 0 and %d):", 0
    StrGreaterThan    DB    "Nope, try a higher number!", 10, 0
    StrLessThan       DB    "Nope, try a lower number!", 10, 0
    StrCorrect        DB    "You guessed the number!", 10, 0
    ScanfFmtString    DB    "%d", 0
    ScanfOutput       DD    0
    MaxNumber         DD    15
    RandomNumber      DQ    0

.CODE

main PROC
    sub rsp, 28h
    call GetRandomNumber

startAskNumber:
    lea rcx, StrAskNumber
    mov edx, DWORD PTR [MaxNumber]
    xor eax, eax
    call printf
    call scanfIntiger      ;procedure to read user input
    cmp eax, 1             ; expect 1 intiger to be successfully read
    jne exit               ; If not, exit program (illegal character)

    mov eax, DWORD PTR [MaxNumber]     
    cmp eax, DWORD PTR [ScanfOutput]  ; if max number is less than output
    jl startAskNumber                 ; jump to label startAskNumber

    mov eax, DWORD PTR [ScanfOutput] 
    cmp rax, [RandomNumber]     ;compare user input to the number to be guessed
    jg needLower               
    jl needHigher              
    je equal

needHigher:
    lea rcx, StrGreaterThan
    call print
    jmp startAskNumber

needLower:
    lea rcx, StrLessThan
    call print
    jmp startAskNumber

equal:
    lea rcx, StrCorrect
    call print

exit:
    add rsp, 28h 
    mov rax, 0
    ret
main ENDP

scanfIntiger PROC
    sub rsp, 28h
    lea rcx, ScanfFmtString
    lea rdx, ScanfOutput
    xor eax, eax
    call scanf
    add rsp, 28h
    ret
scanfIntiger ENDP

print PROC
    sub rsp, 28h
    xor eax, eax 
    call printf
    add rsp, 28h
    ret
print ENDP

getRandomNumber PROC
    sub rsp, 28h            ; 20h shadow + 8 for alignment safety
    xor ecx, ecx            ; time() takes one argument (NULL here)
    call _time64               ; get current time
    mov ecx, eax            ; use time as seed
    call srand
    call rand
    xor edx, edx                        ; clear high part for division
    mov ecx, DWORD PTR [MaxNumber]      ; load max value
    inc ecx
    div ecx
    mov eax, edx                        ; move remainder to EAX
    mov QWORD PTR [RandomNumber], rax   ; store final random number
    add rsp, 28h
    ret
getRandomNumber ENDP

END