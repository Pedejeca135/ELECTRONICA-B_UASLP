/*
 * practica3_2.asm
 *
 *  Created: 2/14/2020 2:09:10 PM
 *   Author: pjco9
 */ 

 //0x27 registro de direccion del puerto C.
 //0x2A registro de direccion del puerto D.
 //0x24 registro de direccion del puerto B.
  
//LDI, 0b0000_0001
 LDI r16, 0x00 //Cargar el valor 0x00 en el registro 16 PARA ENTRADAS
 STS $0027, r16 //Asignando el valor de r16 a la direccion de DDRC($0027) para hacer al Puerto C entrada

 LDI r16, 0xFF//Cargar el valor 0xFF en el registro 17
 STS $002A, r16 //Asignando el valor de r17 a la direccion de DDRC($002A) para hacer al Puerto D 
 
 LDI r16, 0x00//Cargar el valor 0xFF en el registro 17
 STS $0024, r16 //Asignando el valor de r17 a la direccion de DDRC($0024) para hacer al Puerto  B
 
 //0x23 adress for dataPins of portB
 //0x26 adress for dataPins of portC
 //0x2B adress for data Output of portD

 START:
 LDS r17, $0026 //Cargamos al registro 17 el valor del puerto B (I/O register)
 SBIC $0011, 4	// Skip if Bit in I/O Register is Set(0) para que siga buscando
 STORAGE
 JMP START

 STORAGE:
 ANDI r17,0x0F		;enmascaramos el valor de entrada del registro que ya esta almacenado(r17).
 LDS  r18, $0023	;cargamos el valor del puerto B en el registro r18 (I/O register).
 ANDI r18,0x0F		;enmascaramos el valor del registro r18.
 JMP MULTIPLICACION

 MULTIPLICACION:
 MUL r17,r18 ;el valor bajo de la multiplicacion se guarda en el registro cero con direccion 0x00
 STS $002B, r0 ;poner el valor de salida del puerto d con el valor de la multiplicacion.
 LDI r17, 0x00
 JMP START

