.global _start
.extern scanf
.extern printf

.data
a: .quad 0
b: .quad 0
c: .quad 0
ost: .quad 0
input_str: .asciz "%lld%lld%lld"
output_str: .asciz "Output value: %lld, %lld\n"

.text
_start:
movq %rsp, %rbp               
subq $32, %rsp                
andq $-16, %rsp               

leaq input_str(%rip), %rdi    
leaq a(%rip), %rsi            #  A
leaq b(%rip), %rdx            #  B
leaq c(%rip), %rcx            #  C
xor %eax, %eax
call scanf

movq a(%rip), %rax            #  a -> rax
movq %rax, %rbx               #  A --> rbx
imulq %rax, %rbx              # rbx = A^2
imulq %rax, %rbx              # rbx = A^3
imulq $5, %rbx, %rbx          # rbx = 5*A^3

movq c(%rip), %rax            #  c -> rax
imulq %rax, %rax              # rax = C^2

addq %rax, %rbx               # rbx = 5*A^3 + C^2

movq %rbx, %rax               
xor %rdx, %rdx                
movq b(%rip), %rdi            # B -> rdi
divq %rdi                     # y = (5*A^3 + C^2) / B

movq %rdx, ost(%rip)          # rdx -> ost

leaq output_str(%rip), %rdi   
movq %rax, %rsi               # Y -> rsi
movq ost(%rip), %rdx          # ost -> rdx
xor %eax, %eax                 
call printf                   

movq %rbp, %rsp               
movq $0, %rdi                 
movq $60, %rax                
syscall