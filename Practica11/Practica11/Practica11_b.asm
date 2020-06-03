/*
 * Practica11_b.asm
 *
 *  Created: 5/29/2020 7:13:13 PM
 *   Author: pjco9
 Objetivo:
b) Modifique el programa anterior de manera que ahora pueda recibir datos por medio de la
comunicación serial desde la PC. Cada vez que se reciba un dato, se generará una
interrupción interna, la cual mostrará el dato recibido en un display de 7 segmentos. Solo
se mostrarán los valores 0-9 y A-F.
(20% - Obligatorio)
		
 */ 

 /*configuracion del sistema*/
 .org 0x00 
jmp conf_sist

/*interrupcion para cuando llegue un mensaje*/
.org 0x0024
jmp int_Recep

.org 0x100
 conf_sist:
  //------definicion de registros para su uso ------//
 .def control = r16//para el control de los registros.
 .def ascii = r17//variable que representa el valor ascii del mensje recibido.
 .def exit = r19 //la salida para el display.
 // ------------------------------Configuracion de USART-------------------------------------//
 ldi control, 0x90 // UCSR0B habilitacion de transmisor
 STS $00C1, control
 ldi control, 0x06 // UCSR0C configuracion de USART para 8 bits y modo de operaciones sin paridad
 STS $00C2, control
 ldi control, 0x67 // UBRR0L baudaje de 9600 
 STS $00C4, control 
 LDI control, 0x00 // UBRR0H baudaje de 9600 
 STS $00C5, control 
 SEI //set interruption enable.

//------------- configuracion de puertos --------------//
LDI control, 0xFF //para hacer todosw los pines salidas.
STS $0024, control //puertoB salidas.
STS $002A, CONTROL //puertoD salidas.
JMP START ;Saltamos al inicio de programa.

.ORG 0x500
start:
LDS control, $00C0
SBRS control, 7
RJMP start
LDS ascii, $00C6
JMP start 

.org 0x700
int_Recep:
  CPI ascii, 0x31//codigo en ascii
  BREQ UNO//salta a la etiqueta correspondiente para la asignacion del valor del registro exit
  CPI ascii, 0x32
  BREQ DOS
  CPI ascii, 0x33
  BREQ TRES
  CPI ascii, 0x34
  BREQ CUATRO
  CPI ascii, 0x35
  BREQ CINCO
  CPI ascii, 0x36
  BREQ SEIS
  CPI ascii, 0x37
  BREQ SIETE
  CPI ascii, 0x38
  BREQ OCHO  
  JMP MAPEO2//si no cumplio ninguno de los anteriores salta a MAPEO2

  UNO:
   LDI exit, 0X06//valor que mostrara 1 en el display.
   JMP MUESTRA//salta a la etiqueta MUESTRA
  DOS:
  LDI exit, 0X5B
   JMP MUESTRA
  TRES:
  LDI exit, 0X4F
   JMP MUESTRA
  CUATRO:
  LDI exit, 0X66
   JMP MUESTRA
  CINCO:
  LDI exit, 0X6D
   JMP MUESTRA
  SEIS:
  LDI exit, 0X7D
   JMP MUESTRA
  SIETE:
  LDI exit, 0X07
   JMP MUESTRA
  OCHO:
  LDI exit, 0X7F
  JMP MUESTRA

  MAPEO2:
  CPI ascii, 0x39//codigo en ascii
  BREQ NUEVE//salta a la etiqueta correspondiente para la asignacion del valor del registro exit
  CPI ascii, 0x30
  BREQ CERO
  CPI ascii, 0x41
  BREQ A
  CPI ascii, 0x42
  BREQ B
  CPI ascii, 0x43
  BREQ C
  CPI ascii, 0x44
  BREQ D
  CPI ascii, 0x45
  BREQ E
  CPI ascii, 0x46
  BREQ F

  NUEVE:
  LDI exit, 0X6F
   JMP MUESTRA
  CERO:
  LDI exit, 0X3F
   JMP MUESTRA
  A:
  LDI exit, 0X77
   JMP MUESTRA
  B:
  LDI exit, 0X7C
   JMP MUESTRA
  C:
  LDI exit, 0X39
   JMP MUESTRA
  D:
  LDI exit, 0X5E
   JMP MUESTRA
  E:
  LDI exit, 0X79
   JMP MUESTRA
  F:
  LDI exit, 0X71
   JMP MUESTRA

 MUESTRA: //saca el valor de exit a los puertos d
  STS $002B,exit
RETI
