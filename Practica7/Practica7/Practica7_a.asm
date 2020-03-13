/*
 * Practica7_a.asm
 *
 *  Created: 3/12/2020 1:53:52 PM
 *   Author: pjco9
 */ 

 .def rotacion = r21  ;Registro de rotacion.
 .def lectura = r22  ; registro de lectura.
 .def columna = r23 ;
 .def fila = r24 ;
 .def mapeoR =  r25 ;
 .def salida = r17;registro de salida.

 LDI rotacion,0x01

 LDI r16, 0xFF ;outputs
 STS $0027, r16;port C
 STS $002A,r16 ;port D

 LDI r16, 0x00 ;inputs
 STS $0024, r16; port B

 START:
 LDS lectura, $0023;da el valor del puerto B(REgnlones(rows)).
 ANDI lectura, 0x0F;
 CPI lectura, 0x01;
 BRGE FILA_VERIFY;
 JMP START;

 DELAY_BUTTON:
; Delay 320 000 cycles
; 20ms at 16 MHz
    ldi  r18, 2
    ldi  r19, 160
    ldi  r20, 147
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop
 RET

 FILA_VERIFY:
//CALL DELAY_BUTTON;
 MOV fila, lectura;mueve la lectura de fila en el registro fila.
 LDI rotacion, 0x01//reinicia la rotacion
 JMP COLUM_VERIFY
 JMP MATRIX_VERIFY

 COLUM_VERIFY:
 SBRC rotacion,3//si el registro de rotacion esta en alto en el bit 3
 LDI rotacion, 0x01//reinicia la rotacion 
 STS $0027, rotacion;puerto c, tiene el valor del registro de rotacion.
 LDS lectura, $0023//da el valor del puerto B(REgnlones(rows)).
 ANDI lectura, 0x0F; 
 CPI lectura, 0x01
 BRGE MATRIX_VERIFY 
 LSL rotacion//desplazamiento a la izquierda.
 JMP COLUM_VERIFY

 MATRIX_VERIFY:
  MOV columna,rotacion;
  MOV mapeoR,columna;
  LSL mapeoR;-
  LSL mapeoR;
  LSL mapeoR;
  LSL mapeoR;
  ADD mapeoR, fila;
  JMP MAPEO

  TO_START:
  jmp START

  MAPEO:
  CPI mapeoR, 0b0001_0001
  BREQ UNO;
  CPI mapeoR, 0b0010_0001
  BREQ DOS;
  CPI mapeoR, 0b0100_0001
  BREQ TRES;
  CPI mapeoR, 0b1000_0001
  BREQ A;
  CPI mapeoR, 0b0001_0010
  BREQ CUATRO;
  CPI mapeoR, 0b0010_0010
  BREQ CINCO;
  CPI mapeoR, 0b0100_0010
  BREQ SEIS;
  CPI mapeoR, 0b1000_0010
  BREQ B;
  JMP MAPEO2
  
  START_CITO:
  //CALL DELAY_BUTTON
  JMP START

  UNO:
  LDI salida,0x06
  JMP ASIGNA
  DOS:
  LDI salida,0x5B
  JMP ASIGNA
  TRES:
  LDI salida,0x4F
  JMP ASIGNA
  A:
  LDI salida,0x06
  JMP ASIGNA
  CUATRO:
  LDI salida,0x66
  JMP ASIGNA
  CINCO:
  LDI salida,0x6D
  JMP ASIGNA
  SEIS:
  LDI salida,0x7D
  JMP ASIGNA
  B:
  LDI salida,0x06
  JMP ASIGNA
  
  ROMPE:
  LDS lectura, $0023
  ANDI lectura, 0x0F
  CPI lectura,0x00
  BREQ START_CITO
  JMP ROMPE

  ASIGNA:
  STS $002B, salida
  JMP ROMPE
  JMP TO_START

  MAPEO2:
  CPI mapeoR, 0b0001_0100
  BREQ SIETE;
  CPI mapeoR, 0b0010_0100
  BREQ OCHO;
  CPI mapeoR, 0b0100_0100
  BREQ NUEVE;
  CPI mapeoR, 0b1000_0100
  BREQ C;
  CPI mapeoR, 0b0001_1000
  BREQ ASTERIX;
  CPI mapeoR, 0b0010_1000
  BREQ CERO;
  CPI mapeoR, 0b0100_1000
  BREQ GATO;
  CPI mapeoR, 0b1000_1000
  BREQ D;

  SIETE:
  LDI salida,0x07
  JMP ASIGNA
  OCHO:
  LDI salida,0x7F
  JMP ASIGNA
  NUEVE:
  LDI salida,0x6F
  JMP ASIGNA
  C:
  LDI salida,0x39
  JMP ASIGNA
  ASTERIX:
  LDI salida,0x79
  JMP ASIGNA
  CERO:
  LDI salida,0x3F
  JMP ASIGNA
  GATO:
  LDI salida,0x71
  JMP ASIGNA
  D:
  LDI salida,0x5E
  JMP ASIGNA






