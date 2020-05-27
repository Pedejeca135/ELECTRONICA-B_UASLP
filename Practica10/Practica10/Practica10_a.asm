/*
 * Practica10_a.asm
 *
 *  Created: 5/25/2020 6:26:27 AM
 *   Author: pjco9

 a) Objetivo: Desarrolle un programa el cual configurará las interrupciones internas para el módulo
8bit/Counter0 del ATmega328P. Cada vez que el contador cumpla una condición dada,
se generara una interrupción interna. Este módulo obtendrá su señal de reloj de un reloj
externo de 1hz, alambrado por el alumno y conectado al pin T0 (PD4). Cada vez que se
genere la interrupción interna se cambiará de estado un pin, el cual mostrara su estado
por una punta de prueba.
(20% - Obligatorio)
 */ 

.org 0x00 
jmp conf_sist

.org 0x001E //direccion del vector de interrupcion TIMER0_COMPB 
jmp MANEJO_TIMER0_B //etiqueta a la que se tiene que acceder en la interrupcion

.org 0x100
conf_sist:
// definicion de registros 
.def conf = r16 
.def led = r17 

ldi led, 0x00// para apagar todos el registro led

//configuracion del puerto b y d 
LDI conf, 0xFF 
sts $0024, conf// salidas (Port B Data Direction Register).
 LDI conf, 0x00 
STS $002A, conf //entradas (Port D Data Direction Register).

// configuracion de interrupcion interna 
LDI conf, 0x04 //
STS $006E, conf//configuracion del registro de Mascara de interrupcion  de TC0, 
			   //para compararla con el registro de comparacion B(OCIEB).

LDI conf, 0x00//
sts $0046, conf // configuracion de contador TC0 Counter Value Register, en ceros.

LDI conf, 0x04//cuatro ciclos de reloj.
sts $0048, conf // configuracion del valor del registro de comparacion B de TC0
SEI //set interrupt enable.

LDI conf, 0x07
sts $0045, conf// Configuracion de TC0 Control Register B  
			   //External clock source on T0(PD4) pin. Clock on rising edge.
jmp start

.org 0x500 
start: 
jmp start//ciclo start que soporta interrupciones.

.org 0x700
MANEJO_TIMER0_B://lo que pasa con la interrupcion del contador del timer externo.
com led//complemento del estado de led.
sts $0025,led//asignacion de valor del registro led a la salida del puertoB
LDI conf, 0x00 
sts $0046, conf // configuracion de contador TC0, para que empiece de nuevo
//sts $0046, conf // configuracion de contador TC0, para que empiece de nuevo
RETI