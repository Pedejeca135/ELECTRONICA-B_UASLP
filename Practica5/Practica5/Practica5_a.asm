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

 LDI r16, 0x00 //Cargar el valor 0x00 en el registro 16
 STS DDRB,r16 // asignando 0x00 del registro 16 a el registro de direcciones del puerto B(output).
 STS DDRD, r16 //Asignando el valor de r17 a la direccion de DDRD($002A) para hacer al Puerto D salidas

 LDI r16, 0xFF
 STS DDRC, r16
 
 LDI r20, 0x01
 STS $002B, r20//pone el primer bit del puerto D en alto.
 LDI r21, 0x00
 STS PORTC, r20//pone el puerto C en bajo.

 //MAIN
START: 

 LDS r16, PINC //$0026Cargamos al registro 16 el valor del puerto C (I/O register).

 SBIC r16,0//skip if bit is clear.
 JMP PAUSE

 SBIC r16,1//skip if bit is clear.
 JMP RESET

 SBIC r16,2//skip if bit is clear.
 JMP COMPLEMENTO

 SBIC r16,3//skip if bit is clear.
 JMP  END

    rompe2: 
   LDS r19, $0026 // obtiene los valores de entrada en el puerto B
   ANDI r19, 0b0001_1100 // enmascara para solamente ver los bits de push y pop
   CPI r19, 0x00 // Compara si ya se dejaron de aplanar
   BREQ start // Si sí, salta al inicio  
   JMP rompe // si no vuelve a llamarse para esperar a que se dejen de apretar
 
 PAUSE:
  LDS r16, PINC // obtiene los valores de entrada en el puerto C
  ANDI r16, 0b0000_0001 // enmascara para solamente ver los bits de push y pop
  CPI r16, 0x00 // Compara si ya se dejaron de aplanar
  BRNE PAUSE // salto a pause
CONTINUA_PAUSA:
 LDS r16, PINC //$0026Cargamos al registro 16 el valor del puerto C (I/O register).
 SBIS r16,0//skip if bit is set.
 JMP CONTINUA_PAUSA
 JMP START




  CPI r20,0b1000_0000
 BREQ 
 LSL r20
 STS PORD,r20 

 PAPA_CALIENTE:
 
 CPI r21,0b0010_0000

 RESET:
 COMPLEMENTO:

 END:
 JMP END

 

 SBIS $0010, 4	// Skip if Bit in I/O Register is Set(1) para que siga buscando
 JMP START