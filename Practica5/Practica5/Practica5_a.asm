/*
 * Practica5_a.asm
 *
 *  Created: 2/26/2020 1:28:59 PM
 *   Author: pjco9

 a) Implemente un programa el cual ponga en alto el primer bit del puerto D (pin 0), y haga
un corrimiento a la izquierda, hasta llegar al bit más significativo del puerto B (pin 13).
Una vez que llegue al pin 13, deberá repetir la secuencia y regresar al pin 0. Esto se
deberá de repetir infinitamente. Configure 4 push-buttons en el puerto C para que
realicen las siguientes acciones:
i. El primer push-button detiene o continua el corrimiento.
ii. El segundo push-button reinicia la secuencia.
iii. El tercer push-button niega la salida.
iv. El cuarto push-button termina el programa y apaga todos los leds

 */ 

 LDI r16, 0xFF //Cargar el valor 0x00 en el registro 16
 STS $0024,r16 // asignando 0x00 del registro 16 a el registro de direcciones del puerto B(output).
 STS $002A, r16 //Asignando el valor de r16 a la direccion de DDRD($002A) para hacer al Puerto D salidas

 LDI r16, 0x00
 STS $0027, r16
 
 JMP RESET

 //MAIN
START:
MOV r23,r21//copia registros r21 a r23
MOV r22,r20//copia registro r20 a r22

 LDS r16, $0026 //$0026Cargamos al registro 16 el valor del puerto C (I/O register).

 SBRC r16,0//skip if bit is clear.
 JMP RESET

 SBRC r16,1//skip if bit is clear.
 JMP COMPLEMENTO_PUSH

 SBRC r16,2//skip if bit is clear.
 JMP PAUSE

 SBRC r16,3//skip if bit is clear.
 JMP  END 

 CPI r24,0x01//checa que este habilitado el complemento.
 BREQ COMPLEMENTO
 
 STS $0025, r21//pone el primer bit del puerto B.
 STS $002B, r20//pone el puerto D.

 DESPUES_DE_ASIGNAR:
 
  DELAY_500MS:
  LDI r18,41
  LDI r17,150
  LDI r23,128
   L1: 
    DEC r23
    BRNE L1
	DEC r17
	BRNE L1
	DEC r18
	BRNE L1
	

 CPI r20,0b1000_0000
 BREQ PAPA_CALIENTE
 LSL r20
 CPI r21,0b0010_0000
 BREQ PAPA_CALIENTE_2
 LSL r21
 JMP START
 PAPA_CALIENTE:
 LDI r20,0x00
 LDI r21,0x01
 JMP START
 PAPA_CALIENTE_2:
 LDI r20,0x01
 LDI r21,0x00
 JMP START

  COMPLEMENTO:
 COM r23
 COM r22
 STS $0025, r23//pone el primer bit del puerto B.
 STS $002B, r22//pone el puerto D.
 JMP DESPUES_DE_ASIGNAR

  ROMPE: 
  LDS r19, $0026 // obtiene los valores de entrada en el puerto C
  ANDI r19, 0b0000_1111 // enmascara para solamente ver los bits de push y pop
  CPI r19, 0x00 // Compara si ya se dejaron de aplanar
  BREQ start // Si sí, salta al inicio  
  JMP ROMPE // si no vuelve a llamarse para esperar a que se dejen de apretar
 
 PAUSE:
  LDS r16, $0026 // obtiene los valores de entrada en el puerto C
  ANDI r16, 0b0000_0001 // enmascara para solamente ver los bits de push y pop
  CPI r16, 0x00 // Compara si ya se dejaron de aplanar
  BRNE PAUSE // salto a pause
CONTINUA_PAUSA:

 LDS r16, $0026 //$0026Cargamos al registro 16 el valor del puerto C (I/O register).
 SBRS r16,2//skip if bit is set.
 JMP CONTINUA_PAUSA
 JMP START

 RESET:
 LDI r20, 0x01
 LDI r21, 0x00
 JMP ROMPE

 COMPLEMENTO_PUSH:
 CPI r24,0x00
 BREQ SET_COMP
 CPI r24,0x01
 BREQ CLR_COMP

 SET_COMP:
 LDI r24, 0x01
 JMP ROMPE

 CLR_COMP:
 LDI r24, 0x00
 JMP ROMPE

 END:
 JMP END

// SBIS $0010, 4	// Skip if Bit in I/O Register is Set(1) para que siga buscando
 //JMP START