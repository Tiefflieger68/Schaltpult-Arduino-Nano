
'Bascom 2.0.8.4
' 16 Kanäle
' Abfrage 3-Pos-Schalter
' PPM-Signal generieren


'V 0.0.3
'Abfrage Potis vorbereitet
'Portzuordnung geändert (Excel Liste)
'Pulsdauer angepasst


'V 0.1.1
'Schalter Kanal 1-14
'Abfrage Potis Kanal 15,16
'Pulsdauer angepasst


'V 0.2.0
'Config in Variable (conf) und eeProm ablegen
'über conf.0 Poti für Kanal 15,16 auswählbar
'über conf.1 SBUS oder PPM auswählbar
'ToDo: Loaddata für SBUS generieren

'V 0.2.1
'SBUS LoadData generiert
'Alle Funktionen ausgetestet

'Fehler beim Compilieren?
'V 0.2.2
'neu compiliert

'V 0.3.0
'Bascom 2.0.8.6
'PPM, SBUS und SBUS UART "gleichzeitig" auf 3 verschiedenen Pins ausgeben
'serout: achtung Bugfix für "INVERTED" !!!

'V 0.3.1
'House keeping



Const V1 = 0           'Version in eeProm schreiben
Const V2 = 3
Const V3 = 1



$regfile = "m328pdef.dat"
$crystal = 16000000

$hwstack = 32                                               ' default use 32 for the hardware stack
$swstack = 10                                               ' default use 10 for the SW stack
$framesize = 40                                             ' default use 40 for the frame space

$LIB "serout.lib"                                            'bugfix for serout INVERTED - find https://www.mcselec.com/index2.php?option=com_forum&Itemid=59&page=viewtopic&p=84137#84137

CONST Updateeprom=1                                         'EEProm nur schreiben wenn Wert <>
const SEROUT_EXTPULL = 1                                    'external Pullup for SEROUT is needed !



'positive Pulse  -  openTX frisst beides
Const On = 1
Const Off = 0

'negative Pulse
'Const On = 0
'Const Off = 1


'Werte für PPM
Const Puls = 300                                            'uS
Const cl1= 986 - Puls                                      'uS  -100%  ("puls" ist abzuziehen)
Const cl2 = 1499 - Puls                                     'uS  0%
Const cl3 = 2012 - Puls                                     'uS  +100%
Const Pppoti = 988 - Puls                                   '

'Werte für SBUS
const sbuscl1 = &B00000000_10100000                            ' 160
const sbuscl2 = &B00000011_11100000                            ' 992
const sbuscl3 = &B00000111_00100000                            ' 1824
const sbpoti = &B00000000_10100000                         ' 160
const sbus_frame = 5                                      'Framerate setzen: Serial Out = 3ms  , Processing = 2ms


dim V1_ee as ERAM byte
dim V2_ee as ERAM byte
dim V3_ee as ERAM byte

Dim Chan(16) As word
Dim SBUSChan(16) As word

dim sbus_load(25) as byte

dim Chan_nr as byte
dim Chan_bit as byte
dim sbus_byte as byte
dim sbus_bit as byte

Dim Poti1 As word                                      'Werte der Potis
Dim Poti2 As word

Dim sbusPoti1 As word                                      'Werte der Potis
Dim sbusPoti2 As word

V1_ee = V1                    'Version in eeProm sichbar machen
V2_ee = V2
V3_ee = V3



'Eingänge den Pins zuordnen

eing1 Alias Pind.2
pull1 Alias Portd.2

eing2 Alias Pind.3
pull2 Alias Portd.3

eing3 Alias Pind.4
pull3 Alias Portd.4

eing4 Alias Pind.5
pull4 Alias Portd.5

eing5 Alias Pind.6
pull5 Alias Portd.6

eing6 Alias Pind.7
pull6 Alias Portd.7

eing7 Alias Pinb.0
pull7 Alias Portb.0

eing8 Alias Pinb.1
pull8 Alias Portb.1

eing9 Alias Pinc.5
pull9 Alias Portc.5

eing10 Alias Pinc.4
pull10 Alias Portc.4

eing11 Alias Pinc.3
pull11 Alias Portc.3

eing12 Alias Pinc.2
pull12 Alias Portc.2

eing13 Alias Pinc.1
pull13 Alias Portc.1

eing14 Alias Pinc.0
pull14 Alias Portc.0

jumper alias pinb.2

ppm_out Alias Portb.5           'PortB.5 = LED



sbus_load(1) = &B00001111     'sbus_start
sbus_load(24) = &B00000000    'sbus_flag
sbus_load(25) = &B00000000    'sbus_stop



Config ppm_out = Output
ppm_out = Off


Jumper = 1     'Pullup für Jumper (zZt. ohne Funktion)


'AD Wandler aktivieren
Config Adc = Single , Prescaler = Auto , Reference = Avcc   'AD-Wandler aktivieren
Start Adc


Waitms 100



Do

'Potis abfragen
poti1 = getadc(6)
poti2 = getadc(7)


'3-Pos-Schalter einlesen
'pro Eingang 100k Pulldown

If Eing1 = 1 Then
   Chan(1) = cl3
   sbusChan(1) = sbuscl3
   Else
   Chan(1) = cl2
   sbusChan(1) = sbuscl2
End If


If Eing2 = 1 Then
   Chan(2) = cl3
   sbusChan(2) = sbuscl3
   Else
   Chan(2) = cl2
   sbusChan(2) = sbuscl2
End If


If Eing3 = 1 Then
   Chan(3) = cl3
   sbusChan(3) = sbuscl3
   Else
   Chan(3) = cl2
   sbusChan(3) = sbuscl2
End If


If Eing4 = 1 Then
   Chan(4) = cl3
   sbusChan(4) = sbuscl3
   Else
   Chan(4) = cl2
   sbusChan(4) = sbuscl2
End If


If Eing5 = 1 Then
   Chan(5) = cl3
   sbusChan(5) = sbuscl3
   Else
   Chan(5) = cl2
   sbusChan(5) = sbuscl2
End If


If Eing6 = 1 Then
   Chan(6) = cl3
   sbusChan(6) = sbuscl3
   Else
   Chan(6) = cl2
   sbusChan(6) = sbuscl2
End If
If Eing7 = 1 Then
   Chan(7) = cl3
   sbusChan(7) = sbuscl3
   Else
   Chan(7) = cl2
   sbusChan(7) = sbuscl2
End If


If Eing8 = 1 Then
   Chan(8) = cl3
   sbusChan(8) = sbuscl3
   Else
   Chan(8) = cl2
   sbusChan(8) = sbuscl2
End If


If Eing9 = 1 Then
   Chan(9) = cl3
   sbusChan(9) = sbuscl3
   Else
   Chan(9) = cl2
   sbusChan(9) = sbuscl2
End If


If Eing10 = 1 Then
   Chan(10) = cl3
   sbusChan(10) = sbuscl3
   Else
   Chan(10) = cl2
   sbusChan(10) = sbuscl2
End If


If Eing11 = 1 Then
   Chan(11) = cl3
   sbusChan(11) = sbuscl3
   Else
   Chan(11) = cl2
   sbusChan(11) = sbuscl2
End If


If Eing12 = 1 Then
   Chan(12) = cl3
   sbusChan(12) = sbuscl3
   Else
   Chan(12) = cl2
   sbusChan(12) = sbuscl2
End If


If Eing13 = 1 Then
   Chan(13) = cl3
   sbusChan(13) = sbuscl3
   Else
   Chan(13) = cl2
   sbusChan(13) = sbuscl2
End If


If Eing14 = 1 Then
   Chan(14) = cl3
   sbusChan(14) = sbuscl3
   Else
   Chan(14) = cl2
   sbusChan(14) = sbuscl2
End If


pull1 = 1                                            'Pullups einschalten
pull2 = 1
pull3 = 1
pull4 = 1
pull5 = 1
pull6 = 1
pull7 = 1
pull8 = 1
pull9 = 1
pull10 = 1
pull11 = 1
pull12 = 1
pull13 = 1
pull14 = 1


Waitus 10                                             'bisschen auf die Eing-Up's warten


If Eing1 = 0 Then
   Chan(1) = cl1
   sbusChan(1) = sbuscl1
End If


If Eing2 = 0 Then
   Chan(2) = cl1
   sbusChan(2) = sbuscl1
End If


If Eing3 = 0 Then
   Chan(3) = cl1
   sbusChan(3) = sbuscl1
End If


If Eing4 = 0 Then
   Chan(4) = cl1
   sbusChan(4) = sbuscl1
End If


If Eing5 = 0 Then
   Chan(5) = cl1
   sbusChan(5) = sbuscl1
End If


If Eing6 = 0 Then
   Chan(6) = cl1
   sbusChan(6) = sbuscl1
End If


If Eing7 = 0 Then
   Chan(7) = cl1
   sbusChan(7) = sbuscl1
End If


If Eing8 = 0 Then
   Chan(8) = cl1
   sbusChan(8) = sbuscl1
End If


If Eing9 = 0 Then
   Chan(9) = cl1
   sbusChan(9) = sbuscl1
End If


If Eing10 = 0 Then
   Chan(10) = cl1
   sbusChan(10) = sbuscl1
End If


If Eing11 = 0 Then
   Chan(11) = cl1
   sbusChan(11) = sbuscl1
End If


If Eing12 = 0 Then
   Chan(12) = cl1
   sbusChan(12) = sbuscl1
End If


If Eing13 = 0 Then
   Chan(13) = cl1
   sbusChan(13) = sbuscl1
End If


If Eing14 = 0 Then
   Chan(14) = cl1
   sbusChan(14) = sbuscl1
End If



pull1 = 0
pull2 = 0
pull3 = 0
pull4 = 0
pull5 = 0
pull6 = 0
pull7 = 0
pull8 = 0
pull9 = 0
pull10 = 0
pull11 = 0
pull12 = 0
pull13 = 0
pull14 = 0



'Poti-Kanäle für SBUS setzen
sbusPoti1 = Poti1 * 13       'Wert strecken
sbusPoti1 = sbusPoti1 / 8
sbusPoti2 = Poti2 * 13
sbusPoti2 = sbusPoti2 / 8

sbusChan(15) = sbuspoti1 + sbpoti
sbusChan(16) = sbuspoti2 + sbpoti


'Kanal > SBUS_Load
sbus_byte = 2
sbus_bit = 0

for Chan_nr = 1 to 16
   for Chan_bit = 0 to 10

      sbus_load(sbus_byte).sbus_bit = sbuschan(chan_nr).chan_bit

      incr sbus_bit

      if sbus_bit >=8 then
         sbus_bit = 0
         incr sbus_byte
      end if

   next Chan_bit
next Chan_nr



'sbus out UART - externer Pullup nötig
Serout sbus_load , 25 , PORTB , 3 , 100000 , 1 , 8 , 2 , INVERTED    'SBUS (Bugfix: Startbit zu lang)
Serout sbus_load , 25 , PORTB , 4 , 100000 , 1 , 8 , 2               'SBUS UART



'Poti-Kanäle für PPM setzen
Chan(15) = poti1 + pppoti
Chan(16) = poti2 + pppoti


' PPM-Signal erzeugen
For chan_nr = 1 To 16                      'Anzahl Kanäle

   'PPM-Puls erzeugen
   ppm_out = On
   Waitus Puls
   ppm_out = Off
   Waitus Chan(chan_nr)                   'Pause zwischen den Pulsen entsprechend der Kanalwerte

Next

   ppm_out = On      'End-Puls erzeugen
   Waitus Puls
   ppm_out = Off

'   Waitms ppm_Pause   'PPM-Pause - nicht nötig, da Pause durch 2x SBUS gegeben



Loop
End