/*
 * multiplicacion.asm
 *
 *  Created: 2/19/2020 1:59:54 PM
 *   Author: pjco9
 */ 
 LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs
start:

LDI r16, 0x0F // se carga un registro con el numero 0000 1111 para despues compararse
LDS r19,$0026 // se carga en un registro los valores de entrada por el dipswitch
CP r16, r19 // compara con una resta los valores de los registros
BRLT storage // si r16 es mas grande que r19 no salta a storage
JMP start // regresa a start

storage: 
LDS r20,$0026 // guarda en otro registro otra entrada en el dipswitch
CP r16, r20 // compara el nuevo valor con r16
BRLT multiply // si r16 es mas grande que r20 no salta a hacer la multiplicacion
JMP storage // se cicla esperando un nuevo resultado

multiply:
ANDI r19,0x0F // enmascara el bit del push button en r19
ANDI r20,0x0F // enmascara el bit del push button en r20 
mul r20,r19 // hace la multuplicacion de los dos registros y los guarda en dos diferentes
STS $002B, r0 // obtenemos el registro de los 8 bits meos significativos del resultado de la multiplicacion y se muestra en la salida del puerto d
JMP start // regresa al principio a repetir el ciclo 