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

 LDI r16, 0x00//entradas en el puerto C (c direccion : 0x27).
 STS $0027, r16
 
 JMP RESET//salto a RESET para empesar todo el proceso.

 //MAIN
START:
MOV r23,r21//copia registros r21 a r23
MOV r22,r20//copia registro r20 a r22

 LDS r16, $0026 //$0026Cargamos al registro 16 el valor del puerto C (I/O register).

 SBRC r16,0//skip if bit is clear.
 JMP RESET// si es apretado el boton en el pin 0 regresa a RESET.

 SBRC r16,1//skip if bit is clear.
 JMP COMPLEMENTO_PUSH//si el boton del bit 1 prinde la bandera para el complemento.

 SBRC r16,2//skip if bit is clear.
 JMP PAUSE//si el boton del bit 2 es apretado de va a la PAUSA.

 SBRC r16,3//skip if bit is clear.
 JMP  BEFORE_END//si el push button del bit 3 esta en alto se salta a BEFORE_END 
 //que apaga todos los leds y va a la etiqueta END para terminar el programa.

 CPI r24,0x01//checa que este habilitado el complemento.
 BREQ COMPLEMENTO//si la bandera esta prendida hace el complemento.
 
 STS $0025, r21//pone el primer bit del puerto B.
 STS $002B, r20//pone el puerto D.

 DESPUES_DE_ASIGNAR:// para indicar en lugar 
 //donde ya se ha asignado el valor a los puertos de salida.
 
 //delay de 500MS.
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
	
//compara si ya llego al ultimo bit del puerto D para pasar al puerto B.
 CPI r20,0b1000_0000
 BREQ PAPA_CALIENTE// pasa el conteo de D a B.
 LSL r20//recorre el registro r20 a la izquierda.
 //compara si ya llego al ultimo bit del puerto B para pasar al puerto D.
 CPI r21,0b0010_0000
 BREQ PAPA_CALIENTE_2//pasa el conteo de B a D.
 LSL r21// recorre el registro r21 a la izquierda.
 JMP START//si no hay que pasar la papa regresa al start.
 
 //cambia D a B.
 PAPA_CALIENTE:
 LDI r20,0x00//r20 es para D. Se pone en cero.
 LDI r21,0x01//r21 es para B. se ingresa un uno.
 JMP START//regresa al inicio.

 //cambia B a D.
 PAPA_CALIENTE_2:
 LDI r20,0x01//r20 es para D. Se pone en 1 para empezar con el recorrido.
 LDI r21,0x00//r21 es para B. se ingresa en cero.
 JMP START//regresa al inicio.

 COMPLEMENTO:
 COM r23//hace el complemento del registro 23 copiado en el inicio a 21(B).
 COM r22//hace el complemento del registro 22 copiado en el inicio a 20(D).
 STS $0025, r23//pone el primer bit del puerto B.
 STS $002B, r22//pone el puerto D.
 JMP DESPUES_DE_ASIGNAR//va a despues de asignar.

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

 RESET:// reset para iniciar de nuevo el recorrido.
 LDI r20, 0x01//inicia r20(D) en uno.
 LDI r21, 0x00//inicia r21(B) en cero.
 JMP ROMPE

 COMPLEMENTO_PUSH:// si se aprieta el push button del complemento
 CPI r24,0x00//si la bandera esta en  cero
 BREQ SET_COMP// se setea la bandera.
 CPI r24,0x01// si la bandera esta en uno.
 BREQ CLR_COMP//se limpia la bandera.

 SET_COMP:// prende la bandera.
 LDI r24, 0x01
 JMP ROMPE//control de botones.

 CLR_COMP:// apaga la bandera.
 LDI r24, 0x00
 JMP ROMPE//control de botones.

 BEFORE_END:// apagar todos los leds.
 LDI r17,0x00
 STS $002B,r17
 STS $0025 ,r17
 JMP END

 END:/fin del programa.
 JMP END

// SBIS $0010, 4	// Skip if Bit in I/O Register is Set(1) para que siga buscando
 //JMP START