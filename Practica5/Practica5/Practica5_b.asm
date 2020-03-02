/*
 * Practica5_b.asm
 *
 *  Created: 2/26/2020 1:29:21 PM
 *   Author: pjco9

 b) Utilizando el programa de la práctica 4, inciso a), modifíquelo de manera que cada vez
que se presione el push-button de salida, el dato que se elimine de la pila y se muestre
sea el menor de los datos restantes.

 */ 

 .def full_FF = r25 
 .def menor = r16
 .def menorL = r23
 .def menorH = r24 
 .def consulta = r20 

LDI full_FF, 0xFF
LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs   Data direction register 

STS $0024,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto b para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

LDI r26, 0x55 // es la parte de la direccion en bajo para x 
LDI r27, 0x01 // parte de la direccion en alto para x

LDI r28, 0x55 // es la parte de la direccion en bajo para y
LDI r29, 0x01 //parte de la direccion en alto para y

LDI r22, 0xFF// para prender todos los leds

start:
LDI r21,0x00 // bandera de control de de pila vacia

LDS r17, $0023 // lectura de los 6 bits mas significativos
LDS r18, $0026 // lectura de los 2 bits menos significativos
LDS r19, $0026 // lectura de push buttons

LSL r17 // desplazamiento a la izquierda del registro 17
LSL r17 // segundo desplazamiento a la izquierda del registro 17
ANDI r18, 0b0000_0011 // enmascaramiento para los bits menos significativos 
ADD r17,r18 // suma de los 8 bits de entrada

CP r27, r29 // comparacion si x y Y apuntan a la misma direccion en alto 
BREQ comp // salto si son iguales
JMP Operacion_pila // salto
comp:
 CP r26,r28 // comparacion si x y Y apuntan a la misma direccion en bajo
 BREQ prende_leds // salto si son iguales
 JMP Operacion_pila // salto

 prende_leds:
  STS $002B, r22 // datos de salida a puerto D 
  LDI r21,0xFF // registro para saber si esta vacia la pila

 Operacion_pila:
 SBRC r19,2 // indica si en el bit 2 del r19 esta en alto (pop)
 JMP poping // salta 
 SBRC r19,3 // indica si en el bit 3 del r19 esta en alto (push)
 JMP pushing // salta
 JMP start // salto a inicio

 sta:
 JMP start

  poping:
 CPI r21,0xFF // comparacion de bandera para aver si la pila esta vacia
 BREQ start // Si sí, salta a inicio 
 ;;; la siguiente linea es la unica que cambia en la
 ;;; implementacion de la fila con respecto al programa a)
 LDI menor, 0xFF
 MOV r30,r28
 MOV r31,r29

 ciclo_while_poping:
CP r31, r27 // comparacion si x y Y apuntan a la misma direccion en alto 
BREQ comp_while // salto si son iguales
JMP ciclo_while_continue // salto
comp_while:
CP r30,r26 // comparacion si x y Y apuntan a la misma direccion en bajo
BREQ Termina_while // salto si son iguales
ciclo_while_continue:
LD consulta,Z
CP consulta,menor
//brinca si es menor
BRLO if_consulta_menor_true
LD consulta,Z+
JMP ciclo_while_poping

 Termina_while:
 MOV r30,menorL
 MOV r31,menorH
 MOV r17,menor // pone el valor de la direccion Z en r17 
 STS $002B,r17//asignar elvalor del registro menor a la salida del puerto D // muestra en puerto D el valor obtenido del pop
 ST Z,full_FF
 JMP rompe // salto a etiqueta

 //subrutina if(consulta<menor)
 if_consulta_menor_true:
 MOV menor,consulta
 MOV menorH,r31
 MOV menorL,r30
 LD consulta,Z+
 JMP ciclo_while_poping

 pushing:
  ST X+,r17 // hace un push a la pila
  JMP rompe // salto a etiqueta

  rompe: 
   LDS r19, $0026 // obtiene los valores de entrada en el puerto B
   ANDI r19, 0b0000_1100 // enmascara para solamente ver los bits de push y pop
   CPI r19, 0x00 // Compara si ya se dejaron de aplanar
   BREQ sta // Si sí, salta al inicio  
   JMP rompe // si no vuelve a llamarse para esperar a que se dejen de apretar
 

