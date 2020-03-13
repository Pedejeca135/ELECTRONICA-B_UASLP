/*
 * Practica5_b.asm
 *
 *  Created: 2/26/2020 1:29:21 PM
 *   Author: pjco9

 b) Utilizando el programa de la práctica 4, inciso a), modifíquelo de manera que cada vez
que se presione el push-button de salida, el dato que se elimine de la pila y se muestre
sea el menor de los datos restantes.

 */ 
//definiciones de nombres para registros. 
 .def full_FF = r25 
 .def menor = r16// para el valor menor
 .def menorL = r23//para la parte baja de la direccion donde se encontro el numero menor.
 .def menorH = r24 //parte alta de la direccion donde se encuentra el menor
 .def consulta = r20 //registro para el valor de consulta en el recorrido.

LDI full_FF, 0xFF//se asigna el valor maximo al registro full_FF.
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

 sta:// para alcanzar la insruccion de vuelta al inicio.(no lo mas optimo pero funciona).
 JMP start

  poping://haciendo pop.
 CPI r21,0xFF // comparacion de bandera para aver si la pila esta vacia
 BREQ start // Si sí, salta a inicio 
 LDI menor, 0xFF//se inicializa el valor del menor a FF antes del while.
 MOV r30,r28//copiar la direccion de Y a Z para empezar el ciclo en bajo
 MOV r31,r29// "" en alto.

 ciclo_while_poping://empieza el "ciclo while".
CP r31, r27 // comparacion si X y Z apuntan a la misma direccion en alto 
BREQ comp_while // salto si son iguales
JMP ciclo_while_continue // si son diferentes continua en el ciclo
comp_while://continua la comparacion.
CP r30,r26 // comparacion si X y Z apuntan a la misma direccion en bajo
BREQ Termina_while // salto si son iguales. quiere decir que ya se recorrio toda la pila.
ciclo_while_continue://continua el ciclo.
LD consulta,Z//se carga el valor de la direccion a la que apunta Z en consulta.
CP consulta,menor//compara el valor de consulta con el valor menor(al momento).
//brinca si es menor
BRLO if_consulta_menor_true//si consulta es menor que el valor menor brinca.
LD consulta,Z+//solo para el aumento de Z
JMP ciclo_while_poping//regresa alinicio del ciclo.

//despues del ciclo las asignaciones correspondientes.
 Termina_while:
 //Z apuntara a la direccion donde se encontro el menor para sobreescribirlo con FF
 MOV r30,menorL
 MOV r31,menorH

 MOV r17,menor // pone el valor de la direccion Z en r17 
 STS $002B,r17//asignar elvalor del registro 17 menor a la salida del puerto D.
 ST Z,full_FF//se asigna FF a la direccion del menor encontrado.
 JMP rompe // salto a etiqueta

 //subrutina if(consulta<menor)-> entra.
 if_consulta_menor_true:
 MOV menor,consulta//copia el valor de consulta en menor.
 //cambia la direccion de Z con la del menor encontrado.
 MOV menorH,r31
 MOV menorL,r30
 //se avanza el valor de Z para seguir recorriendo la pila
 LD consulta,Z+
 //regresa al ciclo.
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
 

