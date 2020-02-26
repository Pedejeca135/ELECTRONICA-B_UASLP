/*
 * Decrementor.asm *
 *  Created: 2/19/2020 2:41:07 PM
 *   Author: pjco9
 */ 
  //0x27 registro de direccion del puerto C.
 //0x2A registro de direccion del puerto D.
 //0x24 registro de direccion del puerto B.
  
//LDI, 0b0000_0001
 LDI r16, 0x00 //Cargar el valor 0x00 en el registro 16 PARA ENTRADAS
 STS $0027, r16 //Asignando el valor de r16 a la direccion de DDRC($0027) para hacer al Puerto C entrada

 LDI r17, 0xFF//Cargar el valor 0xFF en el registro 17
 STS $002A, r17 //Asignando el valor de r17 a la direccion de DDRC($002A) para hacer al Puerto D 

 LDI r18,0x00//registro de control de signo direccion: 0x12

 //0x26 adress for dataPins of portC
 //0x2B adress for data Output of portD   
 //r18 va a ser de operacion.

 START:
 LDS r17, $0026 //Cargamos al registro 17 el valor del puerto C (I/O register)
 SBIC $0011, 0	// Skip if Bit in I/O Register is Set(0) para que siga buscando.
 JMP INCREMENTO//saltamos a la etiqueta de incremento.
 SBIC $0011,1// Skip if Bit in I/O Register is Set(0) para que siga buscando.
 JMP DECREMENTO//saltamos a la etiqueta de decremento.
 //STS $002B,r18
 JMP START

 INCREMENTO:
 CPI r18, 0xFF//Compare Inmediate.
 LDS r19, $005F// Load Direct from Data Space $005F is the status register. return 1 if is equal
 SBIC $0013, 1 // Skip if Bit in I/O Register is Cleared(0)
 JMP CLEAR_ZERO//significa que la cuenta empieza nuevamente.
 JMP SUMA_UNO //sino no es asi se suma uno a la cuenta.

 DECREMENTO:
 CPI r18, 0x00//Compare Inmediate.
 LDS r19, $005F// Load Direct from Data Space $005F is the status register.
 SBIC $0013, 1 // Skip if Bit in I/O Register is Cleared(0) 
 JMP COMPLEMENTO_A_DOS//significa que empiezan numeros negativos(brinca para hacer el complemento).
 JMP RESTA_UNO//si no es el caso anterior se decrementa uno.

 CLEAR_ZERO:
 LDI r18, 0x00//pone el valor del registro de operacion en cero.
 JMP ASIGNA//brinca a la etiqueta de asignacion.

 SUMA_UNO:
 INC r18//suma uno al registro de operacion.
 JMP ASIGNA//brinca a la asignacion.

 RESTA_UNO:
 DEC r18//resta uno al registro de operacion.
 JMP ASIGNA//brinca a la etiqueta de asignacion.

 COMPLEMENTO_A_DOS:
 INC r18//incrementa uno el registro de operacion.
 NEG r18//niega el valor del registro de operacion.
 JMP ASIGNA//brinca a la asignacion.

 ASIGNA:
 STS $002B,r18//se asigna el valor del registro de operacion al valor del puerto D
 LDS r19,$0026//se lee el valor del puerto C(entradas de push buttons).
 CPI r19,0x00
 BREQ START//si es cero brinca al inicio.
 JMP ASIGNA//si son diferente decero no saldran de la etiqueta asigna.

 




