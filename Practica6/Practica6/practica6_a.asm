/*
 * practica6_a.asm
 *
 *  Created: 3/11/2020 6:14:42 PM
 *   Author: pjco9
 */ 

LDI r16,0x00
STS $0027,r16 // configurar como imputs 
LDI r16,0xFF 
STS $002A,r16 // configurar como outputs
STS $0024,r16 // configurar como outputs

LDI r26,0x01 // bajo en puerto d
LDI r27,0x00 // alto en puerto b

start:

STS $0025,r27//
STS $002B,r26//

LDS r17, $0026//lo lees.
SBRC r17,0 // derecha 
JMP despl_der//salta al desplazamiento a la derecha.
SBRC r17,1 // izquierda
JMP despl_izq // salta al desplazamiento a la izquierda.
JMP start//regresa al inicio.

DELAY_20: // delay de 20 milisegundos(regresa al lugar donde fue llamado->subrutina)
    ldi  r18, 2
    ldi  r19, 160
    ldi  r22, 147
L1: dec  r22
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    RET

	DELAY_2://delay de 20 milisegundos(salta a estart cuando acaba).
    ldi  r18, 2
    ldi  r19, 160
    ldi  r22, 147
L2: dec  r22
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    JMP start

//etiqueta del desplazaminto a la derecha
 despl_izq:
  CALL DELAY_20

 CPI r26,0b1000_0000
 BREQ SALTO_D_B//salto de D a B
 LSL r26
 
 CPI r27,0b0010_0000
 BREQ SALTO_B_D//salto de B a D
 LSL r27

 JMP rompe//salta al verificador del boton.

 SALTO_D_B://salto a B
 LDI r26,0x00//pone en ceros D
 LDI r27,0x01//one el primer uno en B
 JMP rompe//salto a rompe
 SALTO_B_D://salto a D
 LDI r26,0x01//pone el primer uno en D
 LDI r27,0x00//limpia B
 JMP rompe//salto a rompe
 
  rompe: // rompe de desplazamiento a la izquierda
   LDS r25, $0026 // obtiene los valores de entrada en el puerto c
   SBRS r25, 1 // ignora si el bit 1 este en 1
   JMP DELAY_2//delay para retrornar al start
   JMP rompe
  rompe2: // rompe de desplazamiento a la izquierda
   LDS r25, $0026 // obtiene los valores de entrada en el puerto c
   SBRS r25, 0 // ignora si el bit 1 este en 1
   JMP DELAY_2//delay para retornar al start
   JMP rompe2


  despl_der:   
//cuando se hace un desplazamiento a la derecha.
 CALL DELAY_20
 CPI r26,0b0000_0001 // registro del D
 BREQ D_B//salto de d a b derecha, si esta en el limite de D.
 LSR r26//desplazamiento a la derecha.
 
 CPI r27,0b0000_0001 // registro del B
 BREQ B_D//salto de b a d derecha, si esta en el limite de b.
 LSR r27//desplazamiento a la derecha

 JMP rompe2//salta al rompe
 D_B://desplazamiento de d a b derecha
 LDI r26,0x00//se borra D 
 LDI r27,0x20//se setea B en el pin mas significativo.
 JMP rompe2//salto a rompe para derecha.
 B_D://desplazamiento de b a d derecha
 LDI r26,0x80//se setea el valor del puerto D.
 LDI r27,0x00//se borra el puerto B.
 JMP rompe2//salto a rompe para derecha.