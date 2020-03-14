/*
 * Practica7_b.asm
 *
 *  Created: 3/12/2020 1:54:25 PM
 *   Author: pjco9

b) Desarrolle el programa de manera que requiera de un código de 4 dígitos ________,
proporcionado por el instructor, para ser activado/desactivado. Al estar “desactivado” el
dispositivo, al presionar alguna tecla, el display de siete segmentos parpadeará
repetidamente. Al estar “activado”, tendrá la funcionalidad del inciso a).
(30% - Opcional).
 */

 .def rotacion = r21  ;Registro de rotacion.
 .def lectura = r22  ; registro de lectura.
 .def columna = r23 ;
 .def fila = r24 ;
 .def mapeoR =  r25 ;
 .def salida = r17;registro de salida.
 .def alto = r10;
 //.def secuenciaR = r26;
 //.def banderaPass = r27;
 LDI r27, 0x00;
 LDI r27,0x00

 LDI rotacion,0x01

 LDI r16, 0xFF ;outputs
 MOV alto, r16;pone todos en alto en el registro alto(r26)
 STS $0027, r16;port C
 STS $002A,r16 ;port D

 LDI r16, 0x00 ;inputs
 STS $0024, r16; port B

 START:
 STS $0028, alto;pone todos en alto en la salda del puerto c.
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
 CALL DELAY_BUTTON;de cajon un delay para cuando se aprieta un boton.
 MOV fila, lectura;mueve la lectura de fila en el registro fila.
 ANDI fila,0x0F;
 LDI rotacion, 0x01//reinicia la rotacion
 JMP COLUM_VERIFY
 JMP MATRIX_VERIFY

 COLUM_VERIFY:
 SBRC rotacion,4//si el registro de rotacion esta en alto en el bit 3
 LDI rotacion, 0x01//reinicia la rotacion 
 STS $0028, rotacion;puerto c, tiene el valor del registro de rotacion.
 LDS lectura, $0023//da el valor del puerto B(REgnlones(rows)).
 ANDI lectura, 0x0F; 
 CPI lectura, 0x01
 BRGE MATRIX_VERIFY 
 LSL rotacion//desplazamiento a la izquierda.
 JMP COLUM_VERIFY

 MATRIX_VERIFY:
  MOV columna,rotacion;
  ANDI columna, 0x0F;
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
  CALL DELAY_BUTTON
  JMP START

  UNO:
  LDI salida,0x06
  LDI r26, 0x00;
  JMP ASIGNA

  DOS:
  LDI salida,0x5B
  LDI r26, 0x00;
  JMP ASIGNA

  TRES:
  LDI salida,0x4F

  SBRC r26,2
  LSL r26

  JMP ASIGNA

  A:
  LDI salida,0x77
  LDI r26, 0x00;
  JMP ASIGNA
  CUATRO:
  LDI salida,0x66

  SBRC r26,0
  LSL r26

  JMP ASIGNA
  CINCO:
  LDI salida,0x6D
  LDI r26, 0x00;
  JMP ASIGNA
  SEIS:
  LDI salida,0x7D
  LDI r26, 0x00;
  JMP ASIGNA
  B:
  LDI salida,0x7C

  SBRC r26,1
  LSL r26

  JMP ASIGNA
  
  BLINK_BLINK:
  LDI salida,0x80
  STS $002B, salida  
  CALL DELAY_BLINK
  LDI salida,0x00
  STS $002B, salida 
  CALL DELAY_BLINK



  
  ROMPE:
  LDS lectura, $0023
  ANDI lectura, 0x0F
  CPI lectura,0x00
  BREQ START_CITO
  JMP ROMPE

  ASIGNA:
  SBRC r27,0
  STS $002B, salida

  SBRS r27,0;
  CALL BLINK_BLINK;
  ANDI r26, 0x0F 

  SBRC r26,3
  CALL CHANGE_PASSWORD

  JMP ROMPE
  JMP TO_START

  CHANGE_PASSWORD:
  COM r26
  ANDI r27, 0x01
  RET

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
  LDI r26, 0x00;
  JMP ASIGNA
  OCHO:
  LDI salida,0x7F
  LDI r26, 0x00;
  JMP ASIGNA
  NUEVE:
  LDI salida,0x6F
  LDI r26, 0x00;
  JMP ASIGNA
  C:
  LDI salida,0x39
  LDI r26, 0x00;
  JMP ASIGNA
  ASTERIX:
  LDI salida,0x79
  LDI r26, 0x00;
  JMP ASIGNA
  CERO:
  LDI salida,0x3F
  LDI r26, 0x00;
  JMP ASIGNA
  GATO:
  LDI salida,0x71
  LDI r26, 0x00;
  JMP ASIGNA
  D:
  LDI salida,0x5E
  LDI r26, 0x01;
  JMP ASIGNA







