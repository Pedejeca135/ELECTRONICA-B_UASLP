/*
 * practica3.asm
 *
 *  Created: 2/13/2020 4:47:43 PM
 *   Author: pjco9
 */ 

 
//LDI, 0b0000_0001
 LDI r16, 0x00 //Cargar el valor 0x00 en el registro 16
 STS $0027, r16 //Asignando el valor de r16 a la direccion de DDRC($0027) para hacer al Puerto C entradas

 LDI r17, 0xFF//Cargar el valor 0xFF en el registro 17
 STS $002A, r17 //Asignando el valor de r17 a la direccion de DDRC($002A) para hacer al Puerto D salidas
 
 
 //MAIN
START:
 //LDI r20, 0x7C
 //STS $002B, r20
 LDS r16, $0026//Cargamos al registro 16 el valor del puerto C (I/O register)
 SBIS $0010, 4	// Skip if Bit in I/O Register is Set(1) para que siga buscando
 JMP START

 ANDI r16, 0x0F //Enmascarando el resultado del registro 16 para solo tomar los valores de entrada.
  
 CPI r16, 0x00//Compare Inmediate.
 LDS r18, $005F// Load Direct from Data Space $005F is the status register.
 SBIC $0012, 1 // Skip if Bit in I/O Register is Cleared(0)
 JMP CERO //if the 

 CPI r16, 0x01
 LDS r18, $005F
 SBIC $0012, 1
 JMP UNO

 CPI r16, 0x02
 LDS r18, $005F
 SBIC $0012, 1
 JMP DOS

 CPI r16, 0x03
 LDS r18, $005F
 SBIC $0012, 1
 JMP TRES

 CPI r16, 0x04
 LDS r18, $005F
 SBIC $0012, 1
 JMP CUATRO

 CPI r16, 0x05
 LDS r18, $005F
 SBIC $0012, 1
 JMP CINCO

 CPI r16, 0x06
 LDS r18, $005F
 SBIC $0012, 1
 JMP SEIS

 CPI r16, 0x07
 LDS r18, $005F
 SBIC $0012, 1
 JMP SIETE

 CPI r16, 0x08
 LDS r18, $005F
 SBIC $0012, 1
 JMP OCHO

 CPI r16, 0x09
 LDS r18, $005F
 SBIC $0012, 1
 JMP NUEVE

 CPI r16, 0x0A
 LDS r18, $005F
 SBIC $0012, 1
 JMP A

 CPI r16, 0x0B
 LDS r18, $005F
 SBIC $0012, 1
 JMP B

 CPI r16, 0x0C
 LDS r18, $005F
 SBIC $0012, 1
 JMP C

 CPI r16, 0x0D
 LDS r18, $005F
 SBIC $0012, 1
 JMP D

 CPI r16, 0x0E
 LDS r18, $005F
 SBIC $0012, 1
 JMP E

 CPI r16, 0x0F
 LDS r18, $005F
 SBIC $0012, 1
 JMP F



//Etiquetas de instrución
CERO:
 LDI r20, 0x3f//carga al registro r20 el valor en hexadecimal que le dara según la conexion del display la forma del valor comparado antes.
 STS $002B, r20//carga el valor de r20 a el registro 2B que es el puerto D de salida.
 JMP START//Regresa al principio del programa
UNO:
 LDI r20, 0x06
 STS $002B, r20
 JMP START
DOS:
 LDI r20, 0x5B
 STS $002B, r20
 JMP START
TRES:
 LDI r20, 0x4F
 STS $002B, r20
 JMP START
CUATRO:
 LDI r20, 0x66
 STS $002B, r20
 JMP START
CINCO:
 LDI r20, 0x6D
 STS $002B, r20
 JMP START
SEIS:
 LDI r20, 0x7D
 STS $002B, r20
 JMP START
SIETE:
 LDI r20, 0x07
 STS $002B, r20
 JMP START
OCHO:
 LDI r20, 0x7F
 STS $002B, r20
 JMP START
NUEVE:
 LDI r20, 0x67
 STS $002B, r20
 JMP START
A:
 LDI r20, 0x77
 STS $002B, r20
 JMP START
B:
 LDI r20, 0x7C
 STS $002B, r20
 JMP START
C:
 LDI r20, 0x39
 STS $002B, r20
 JMP START
D:
 LDI r20, 0x5E
  STS $002B, r20
 JMP START
E:
 LDI r20, 0x79
 STS $002B, r20
 JMP START
F: 
 LDI r20, 0x71
 STS $002B, r20
 JMP START




