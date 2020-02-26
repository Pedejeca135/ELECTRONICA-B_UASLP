/*
 * practica4_b.asm
 *
 *  Created: 2/24/2020 12:58:10 PM
 *   Author: pjco9
 *
 *	objetivo:
 *	Implemente un programa el cual tenga la misma funcionalidad que el programa del
 *	inciso a), pero en vez de utilizar la RAM, utilice la EEPROM del dispositivo. La
 *  información guardada debe de estar disponible después de apagar y volver a prender el
 *	dispositivo
 */ 
LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs   Data direction register 

STS $0024,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto b para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

OUT EEARL, r17 // actualiza en el registro de direccion de bajo de la EEPROM
OUT EEARH, r17 // actualiza en el registro de direccion de alto de la EEPROM

LDI r17, 0x01 // carga a registro de 1
SBI EECR,EERE // pone un 1 en en el bit de habilitacion de lectura al registro de control de la EEPROM
IN r26,EEDR // pone en un registro el valor que leyó de la EEPROM
OUT EEARL, r17 // actualiza en el registro de direccion de bajo de la EEPROM
SBI EECR,EERE // pone un 1 en en el bit de habilitacion de lectura al registro de control de la EEPROM
IN r27, EEDR // pone en un registro el valor que leyó de la EEPROM

LDI r28, 0x02 // actualiza el registro de direccion bajo de Y en la posicion inicial de la pila en la EEPROM
LDI r29, 0x00 // actualiza el registro de direccion alto de Y en la posicion inicial de la pila en la EEPROM


LDI r22, 0xFF// para prender todos los leds cuando pila esta vacia
LDI r24, 0x26 // pone palabra de control para escritura en un registro

start:
LDI r21,0x00 // bandera de control de de pila vacia
LDS r17, $0023 // lectura de los 6 bits mas significativos
LDS r18, $0026 // lectura de los 2 bits menos significativos
LDS r19, $0026 // lectura de push buttons

SBRC r19,4 //  checa si el bit 4 del registro 19 esta en alto
JMP reset //

LSL r17 // desplazamiento a la izquierda del registro 17
LSL r17 // segundo desplazamiento a la izquierda del registro 17
ANDI r18, 0b0000_0011 // enmascaramiento para los bits menos significativos 
ADD r17,r18 // suma de los 8 bits de entrada
// ---------------------------------------------------------------------
//----------------------------------------------------------------------

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

 // ------------------------------------------------------------------
 // ------------------------------------------------------------------
 // ------------------------------------------------------------------
   rompe: 
   LDS r19, $0026 // obtiene los valores de entrada en el puerto B
   ANDI r19, 0b0001_1100 // enmascara para solamente ver los bits de push y pop
   CPI r19, 0x00 // Compara si ya se dejaron de aplanar
   BREQ start // Si sí, salta al inicio  
   JMP rompe // si no vuelve a llamarse para esperar a que se dejen de apretar

 poping:
 CPI r21,0xFF // comparacion de bandera para aver si la pila esta vacia
 BREQ start // Si sí, salta a inicio 

 
  CPI r26, 0x00 // compara el registro 26 con 0s 
  BREQ carry_invertido // salto a etiqueta
  DEC r26 // decrementa el valor del registro 26
continua_poping:
  write8: //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE 
	rjmp write8

 OUT EEARH, r27 // actualiza la direccion de la EEPROM en alto con x
 OUT EEARL, r26 // actualiza la direccion de la EEPROM en bajo con x


 SBI EECR,EERE // pone un 1 en en el bit de habilitacion de lectura al registro de control de la EEPROM
 IN r17,EEDR  // pone en un registro el valor que leyó de la EEPROM

 STS $002B,r17 // muestra en puerto D el valor obtenido del pop
 
 
 JMP sp_eeprom // salto a etiqueta

 pushing:
 LDI r20,0x00
 STS $002B, r20
  write7:  //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE
	rjmp write7

   OUT EEARH, r27 // actualiza la direccion de la EEPROM en alto con x
   OUT EEARL, r26 // actualiza la direccion de la EEPROM en bajo con x
   OUT EEDR,r17 // pone el dato en el registro de datos de la EEPROM

   SBI EECR, EEMPE // habilita el bit maestro de escritura
   SBI EECR, EEPE  // habilita la escritura
   
   CPI r26, 0xFF // compara si r26 tiene puros 1´s
   BREQ carry // si si, salta a etiqueta
   INC r26 // incrementa r26

   JMP sp_eeprom // salto a etiqueta


 
 reset:
   LDI r25, 0x00 // pone en 0's r25
   LDI r18, 0x01 // pone un 1 en r18
   LDI r24, 0x04 // pone un 4 en el registro 24
   LDI r23, 0x02 // pone un 2 en el registro 23

   write:   //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE 
	rjmp write 

   OUT EEARH,r25 // actualiza la direccion alta de la EEPROM
   OUT EEARL,r25 //  actualiza la direccion baja de la EEPROM
   OUT EEDR,r23 // Le pasa el dato de r23 al registro EEDR
   SBI EECR, EEMPE // Setea en 1 el bit EEMPE en el registro EECR
   SBI EECR, EEPE  // Setea en 1 el bit EEPE en el registro EECR
    
    write2:  //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE
	rjmp write2
   
   OUT EEARH,r25 // actualiza la direccion alta de la EEPROM
   OUT EEARL,r18 //  actualiza la direccion baja de la EEPROM
   OUT EEDR,r25 // Le pasa el dato de r25 al registro EEDR
   SBI EECR, EEMPE // Setea en 1 el bit EEMPE en el registro EECR
   SBI EECR, EEPE // Setea en 1 el bit EEPE en el registro EECR

    write5:  //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE
	rjmp write5

  OUT EEARL, r25
  OUT EEARH, r25

  LDI r17, 0x01
  SBI EECR,EERE
  IN r26,EEDR

   write6:  //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE
	rjmp write6

  OUT EEARL, r17
  SBI EECR,EERE
  IN r27, EEDR


   JMP rompe
      carry_invertido:
      DEC r27
	  LDI r26, 0xFF
	  JMP continua_poping

   carry: 
    INC r27
	LDI r26, 0x00
	JMP sp_eeprom

   sp_eeprom: // actualiza el valor de las direcciones en la EEPROM para cuando se apague y se prenda
   LDI r25, 0x00 // pone en 0's r25
   LDI r18, 0x01 // pone un 1 en r18

      write3:  //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE
	rjmp write3

   OUT EEARH, r25 
   OUT EEARL, r25
   OUT EEDR, r26
   SBI EECR, EEMPE
   SBI EECR, EEPE 

      write4:  //  ciclo para que termine la escritura en la EEPROM
    SBIC EECR,EEPE
	rjmp write4
   
   OUT EEARH, r25
   OUT EEARL, r18
   OUT EEDR, r27
   SBI EECR, EEMPE
   SBI EECR, EEPE 
   JMP rompe
