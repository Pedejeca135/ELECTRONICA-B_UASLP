/*
 * Practica11_a.asm
 *
 *  Created: 5/29/2020 7:12:58 PM
 *   Author: pjco9
	Objetivo:

a) Desarrolle un programa basado en la comunicación serial y en el teclado matricial. Con
cada pulso de tecla del teclado matricial (eliminar rebotes por software) se generará una
interrupción externa y se transmitirá por la USART del Arduino UNO la tecla presionada
en código ASCII. La USART será configurada en modo asíncrono. Se utilizará un
baudaje de 9600 baudios, 8 bits, 1 bit de parada y sin paridad. Utilizando el programa
proporcionado por el instructor, configure la conexión de manera que muestre los datos
recibidos del Arduino UNO en la pantalla de la PC.
(20% - Obligatorio)
		
 */ 

.org 0x00 //configuracion inicial
jmp conf_sist

//.ORG 0x02 ;Vector de int. “INT0”
//JMP MANEJO_INT0

.org 0x100
 conf_sist: 
 //------definicion de registros para su uso ------//
 .def rotacion = r18  ;Registro de rotacion.
 .def lectura = r20  ; registro de lectura.
 .def columna = r21 ;auxiliar para la columna.
 .def renglon = r22 ;auxiliar para el renglon.
 .def mapeo =  r23 ;registro para el mapeo.
 .def EXIT = r24 ;
 .def control = r16
// ---------------------------Configuracion de interrupcion externa INT0-----------------------------------------//
LDI control, 0b0000_0011 ;Dirección 100h.
STS 0x69, control ;EICRA = r16, esta instrucción está en la dirección 101h, ya que LDI solo ocupa 16 bits. Se configura EICRA //para que la señal de interrupción de INT1 sea en cualquier cambio lógico.
LDI control, 0b0000_0001;SE HABILITA INT 0
OUT 0x1D, control ;EIMSK = control, habilitando INT0.
SEI ;Habilitamos las interrupciones globales.

 // ------------------------------Configuracion de USART-------------------------------------//
 ldi control, 0x08 // UCSR0B habilitacion de transmisor
 STS $00C1, control
 ldi control, 0x06 // UCSR0C configuracion de USART para 8 bits y modo de operaciones sin paridad
 STS $00C2, control
 ldi control, 0x68 // UBRR0L baudaje de 9600 
 STS $00C4, control 
 LDI control, 0x00 // UBRR0H baudaje de 9600 
 STS $00C5, control 

 //UBRRn=fOSC/16*BAUD -1
 //BAUD = 9600
 //UBRRn = 104.1666

 // ------------ cosas del teclado ---------------- //
LDI rotacion,0x01

//------------- configuracion de puertos --------------//
 LDI control, 0xFF ;outputs
 STS $0027, control;port C

 LDI control, 0x00 ;inputs
 STS $0024, control; port B

 LDI control, 0xFF
 LDI r17, 0x0f
 JMP START ;Saltamos al inicio de programa.

.ORG 0x500
start:
 STS $0028, r17
 LDS lectura, $0023//da el valor del puerto B(REgnlones(rows)).
 ANDI LECTURA, 0X0F
 CPI lectura, 0x01
 BRGE FILA_VERIFY // DELAY
 JMP START

 //Para verificar la fila que esta aprentandose.
 FILA_VERIFY:
 CALL DELAY_20
 MOV RENGLON, lectura;mueve la lectura de fila en el registro fila.
 LDI rotacion, 0x01//reinicia la rotacion
 JMP COLUM_VERIFY
 JMP MATRIX_VERIFY

 //Para verificar la columna que esta apretandose.
 COLUM_VERIFY:
 SBRC rotacion,4//si el registro de rotacion esta en alto en el bit 3
 LDI rotacion, 0x01//reinicia la rotacion 
 ANDI rotacion, 0x1F
 STS $0028, rotacion;puerto c, tiene el valor del registro de rotacion.
 LDS lectura, $0023//da el valor del puerto B(REgnlones(rows)). 
 ANDI LECTURA, 0X0F
 CPI lectura, 0x01
 BRGE MATRIX_VERIFY 
 LSL rotacion//desplazamiento a la izquierda.
 JMP COLUM_VERIFY
 
 /******************** DELAYS ******************/
  DELAY_20:
    ldi  r27, 2
    ldi  r28, 160
    ldi  r29, 147
L1: dec  r29
    brne L1
    dec  r28
    brne L1
    dec  r27
    brne L1
    nop
    RET

    DELAY_2:
    ldi  r27, 2
    ldi  r28, 160
    ldi  r29, 147
L2: dec  r29
    brne L2
    dec  r28
    brne L2
    dec  r27
    brne L2
    nop
    JMP START

Delay_500:
    ldi  r27, 41
    ldi  r28, 150
    ldi  r29, 128
L3: dec  r29
    brne L3
    dec  r28
    brne L3
    dec  r27
    brne L3
	RET

//etiqueta para la muestra y transmision
  MUESTRA:
  LDI control,0x00
  STS UCSR0A,control;
  STS UDR0,EXIT
  TRANS:
  LDS control,UCSR0A
  SBRS control,6
  JMP TRANS
  JMP START

//verificacion final para saber que tecla se presiono.
 MATRIX_VERIFY:
  MOV columna,rotacion;
  MOV mapeo,columna;
  ANDI mapeo, 0x0F
  LSL mapeo;
  LSL mapeo;
  LSL mapeo;
  LSL mapeo;
  ANDI mapeo, 0xF0
  ANDI renglon, 0x0F
  ADD mapeo, renglon;
  JMP MAPEO1

  MAPEO1:  
  CPI mapeo, 0x11
  BREQ UNO
  CPI mapeo, 0x21
  BREQ DOS
  CPI mapeo, 0x41
  BREQ TRES
  CPI mapeo, 0x12
  BREQ CUATRO
  CPI mapeo, 0x22
  BREQ CINCO
  CPI mapeo, 0x42
  BREQ SEIS
  CPI mapeo, 0x14
  BREQ SIETE
  CPI mapeo, 0x24
  BREQ OCHO
  JMP MAPEO2

  UNO:
   LDI EXIT, 0x31
   JMP MUESTRA
  DOS:
  LDI EXIT, 0x32
   JMP MUESTRA
  TRES:
  LDI EXIT, 0x33
   JMP MUESTRA
  CUATRO:
  LDI EXIT, 0x34
   JMP MUESTRA
  CINCO:
  LDI EXIT, 0x35
   JMP MUESTRA
  SEIS:
  LDI EXIT, 0x36
   JMP MUESTRA
  SIETE:
  LDI EXIT, 0x37
   JMP MUESTRA
  OCHO:
  LDI EXIT, 0x38
  JMP MUESTRA

  MAPEO2:
  CPI mapeo, 0x44
  BREQ NUEVE
  CPI mapeo, 0x28
  BREQ CERO
  CPI mapeo, 0x81
  BREQ A
  CPI mapeo, 0x82
  BREQ B
  CPI mapeo, 0x84
  BREQ C
  CPI mapeo, 0x88
  BREQ D
  CPI mapeo, 0x18
  BREQ E
  CPI mapeo, 0x48
  BREQ F

  NUEVE:
  LDI EXIT, 0x39
   JMP MUESTRA
  CERO:
  LDI EXIT, 0x30
   JMP MUESTRA
  A:
  LDI EXIT, 0X41
   JMP MUESTRA
  B:
  LDI EXIT, 0X42
   JMP MUESTRA
  C:
  LDI EXIT, 0X43
   JMP MUESTRA
  D:
  LDI EXIT, 0X44
   JMP MUESTRA
  E:
  LDI EXIT, 0X45
   JMP MUESTRA
  F:
  LDI EXIT, 0X46
   JMP MUESTRA
    rjmp start


