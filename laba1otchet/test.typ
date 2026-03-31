#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1cm),
  numbering: none,
  footer: context {
    let p = counter(page).get().first()
    if p > 1 {
      align(center)[#p]
    }
  }
)

#set text(
  lang: "ru",
  font: "Times New Roman",
  size: 12pt
)

//Рамка для блока с кодом
#show raw: block.with(
  fill: luma(245),
  inset: 10pt,
  radius: 5pt,
  stroke: luma(200),
)

//Для таблиц - подпись сверху
#show figure.where(kind: table): set figure.caption(position: top)



#align(center)[
  #upper[ГУАП]
  #v(0.5cm)
  #upper[КАФЕДРА № 14]
  #v(2cm)
]

#grid(
  columns: (2fr),
  align(left)[
    #upper[ОТЧЕТ]\
    #upper[ЗАЩИЩЕН С ОЦЕНКОЙ]\
    #upper[]\
    #upper[ПРЕПОДАВАТЕЛЬ]
  ],
  align(center)[
    #v(0.5cm)
    #grid(
      columns: (2fr, 1fr, 2fr),
      gutter: 0.3em,
      [старший преподаватель],
      [],
      [Н.И. Синёв],
      line(length: 100%),
      line(length: 100%),
      line(length: 100%),
      [должность, уч. степень, звание],
      [подпись, дата],
      [инициалы, фамилия]
    )
  ]
)

#align(center)[
  #v(2cm)
  #upper[ОТЧЕТ О ЛАБОРАТОРНОЙ РАБОТЕ]
  #v(0.8cm)
  #text[Название лабораторной работы]
  #v(0.8cm)
  #text[по курсу:]
  #text[Название курса]
  #v(4cm)
]

#grid(
  columns: (2fr),
  align(left)[
    #upper[РАБОТУ ВЫПОЛНИЛ]
  ],
  align(center)[
    #v(0.5cm)
    #grid(
      columns: (1fr, 1fr, 1fr, 1.5fr),
      gutter: 0.3em,
      align(left)[#upper[СТУДЕНТ гр. №]],
      [1446],
      [28.03.2026],
      [А.С. Папко],
      line(length: 0%),
      line(length: 100%),
      line(length: 100%),
      line(length: 100%),
      [],
      [],
      [подпись, дата],
      [инициалы, фамилия]
    )

    #v(4cm)

    Санкт-Петербург 2026
]
)


= Описание задачи
Вычислить значение функции с использованием ассемблера (GAS или Apple ARM 64) для беззнаковых чисел. Функция: $ Y = (5 * A^3 + C^2) / B $

= Формализация

Вводимые значения – целые неотрицательные числа. B (второе вводимое значение) не должно быть нулём. 

= Исходный код программы


Код на ассемблере:
```asm
.global _start
.extern scanf
.extern printf

.data
a: .quad 0
b: .quad 0
c: .quad 0
input_str: .asciz "%lld%lld%lld"
output_str: .asciz "Output value: %lld\n"

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

movq c(%rip), %rax            # з c -> rax
imulq %rax, %rax              # rax = C^2

addq %rax, %rbx               # rbx = 5*A^3 + C^2

movq %rbx, %rax               
xor %rdx, %rdx                
movq b(%rip), %rdi            # B -> rdi
divq %rdi                     # y = (5*A^3 + C^2) / B

leaq output_str(%rip), %rdi   
movq %rax, %rsi               # Y -> rsi
xor %eax, %eax                 
call printf                   

movq %rbp, %rsp               
movq $0, %rdi                 
movq $60, %rax                
syscall
```

= Тестирование
#figure(
  table(
    columns: 6,
    align: center + horizon,
    // stroke: none,
    table.hline(),
    [*Набор тестовых данных *], [*A*], [*B*], [*C*], [*Частное*],[*Остаток*],
    table.hline(),
    [1], [5],   [5],   [5],  [$ (625 + 25)/ 5 = 130$],[0],
    [2], [5],  [10],  [2],  [$ (625 + 4)/ 10 = 62$],[9],
    [3], [6],  [3],   [7],  [$ (1080 + 49)/ 3 = 376$],[1],
    table.hline(),
  ),
  caption: [Расчёт выражения $ Y = (5 * A^3 + C^2) / B $ для трёх различных наборов],
)

#figure(
  image("lab1test1.png",width: 80%),
  caption: [Вывод тестовых результатов],
) <glacier>

#figure(
  image("lab1test2.png",width: 80%),
  caption: [Вывод тестовых результатов],
) <glacier>

#figure(
  image("lab1test3.png",width: 80%),
  caption: [Вывод тестовых результатов],
) <glacier>

= Выводы

В ходе выполнения лабораторной работы была разработана программа на языке ассемблера, выполняющая ввод исходных данных, арифметические операции и вывод результата, включая частное и остаток от деления. Для решения задачи были использованы инструкции умножения, сложения и деления, а также функции стандартной библиотеки для организации ввода и вывода данных. В процессе работы было проведено тестирование программы на нескольких наборах входных данных, результаты которого совпали с результатами ручных вычислений. Следовательно, можно сделать вывод, что лабораторная работа выполнена верно и все поставленные цели достигнуты.