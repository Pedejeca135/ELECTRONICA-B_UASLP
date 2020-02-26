/*
 * practica3_b.asm
 *
 *  Created: 2/14/2020 2:09:10 PM
 *   Author: pjco9

 objetivo:
Desarrolle un programa en ensamblador AVR el cual lea 2 datos (4 bits cada uno), cada
vez que se presione un push-button (eliminar los rebotes por hardware) realice una
multiplicación de los datos y muestre el resultado en 8 puntas de prueba (acomodarlas de
LSB al MSB). Utilice los puertos necesarios a su discreción. (Manejar valores en
hexadecimal dentro del programa).
 */ 

 //0x27 registro de direccion del puerto C.
 //0x2A registro de direccion del puerto D.
 //0x24 registro de direccion del puerto B.
  
//LDI, 0b0000_0001
 LDI r16, 0x00 //Cargar el valor 0x00 en el registro 16 PARA ENTRADAS
 STS $0027, r16 //Asignando el valor de r16 a la direccion de DDRC($0027) para hacer al Puerto C entrada

 STS $0024, r16 //Asignando el valor de r16 a la direccion de DDRC($0024) para hacer al Puerto  B

 LDI r16, 0xFF//Cargar el valor 0xFF en el registro 16
 STS $002A, r16 //Asignando el valor de r16 a la direccion de DDRC($002A) para hacer al Puerto D 
 

 
 //0x23 adress for dataPins of portB
 //0x26 adress for dataPins of portC
 //0x2B adress for data Output of portD

 START:
 LDS r17, $0026 //Cargamos al registro 17 el valor del puerto B (I/O register)
 SBIC $0011, 4	// Skip if Bit in I/O Register is Set(0) para que siga buscando
 JMP STORAGE

 JMP START

 STORAGE:
 ANDI r17,0x0F		;enmascaramos el valor de entrada del registro que ya esta almacenado(r17).
 LDS  r18, $0023	;cargamos el valor del puerto B en el registro r18 (I/O register).
 ANDI r18,0x0F		;enmascaramos el valor del registro r18.
 JMP MULTIPLICACION

 MULTIPLICACION:
 MUL r17,r18 ;el valor bajo de la multiplicacion se guarda en el registro cero con direccion 0x00
 STS $002B,r0
 JMP START
