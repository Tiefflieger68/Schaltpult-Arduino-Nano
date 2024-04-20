
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



Const V1 = 0           'Version in eeProm schreiben
Const V2 = 2
Const V3 = 1



$regfile = "m328pdef.dat"
$crystal = 16000000

$hwstack = 32                                               ' default use 32 for the hardware stack
$swstack = 10                                               ' default use 10 for the SW stack
$framesize = 40                                             ' default use 40 for the frame space


'positive Pulse  -  openTX frisst beides
Const On = 1
Const Off = 0

'negative Pulse
'Const On = 0
'Const Off = 1


'Werte für PPM
Const Puls = 300                                            'uS
Const ppm_Pause = 10                                        'mS - min 4 mS
Const Pp1 = 986 - Puls                                      'uS  -100%  ("puls" ist abzuziehen)
Const Pp2 = 1499 - Puls                                     'uS  0%
Const Pp3 = 2012 - Puls                                     'uS  +100%
Const Pppoti = 988 - Puls                                   '

'Werte für SBUS
const sb1 = &B00000000_10100000                            ' 160
const sb2 = &B00000011_11100000                            ' 992
const sb3 = &B00000111_00100000                            ' 1824
const sbpoti = &B00000000_10100000                         ' 160
const sbus_frame = 14                                      'Framerate setzen: Serial Out = 3ms  , Processing = 2ms


CONST Updateeprom=1                                         'EEProm nur schreiben wenn Wert <>
dim V1_ee as ERAM byte
dim V2_ee as ERAM byte
dim V3_ee as ERAM byte

dim conf_ee as ERAM byte
dim conf as  byte

Dim Pp As word                                           'Pulslänge in uS

Dim Chan(16) As word

dim cl1 as word                                          'Kanalwerte anhängig von PPM oder SBUS
dim cl2 as word
dim cl3 as word

dim sbus_load(22) as byte

dim Chan_nr as byte
dim Chan_bit as byte
dim sbus_byte as byte
dim sbus_bit as byte


Dim Poti1 As word                                      'Werte der Potis
Dim Poti2 As word

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

eing15 Alias Pinb.2
pull15 Alias Portb.2

eing16 Alias Pinb.3
pull16 Alias Portb.3


data_out Alias Portb.5           'PortB.5 = LED


'####################################################################################################################
'Configuration definieren
' "1" aktiviert Funktion
conf.0 = 1               'bit 0  Potis auf Kanal 15 u 16
conf.1 = 1               'bit 1  SBUS
conf.2 = 0               'bit 2  SBUS für UART (nicht invertiert) - Open "COMB.5:100000..." muss angepasst werden
conf.3 = 0               'bit 3
conf.4 = 0               'bit 4
conf.5 = 0               'bit 5
conf.6 = 0               'bit 6
conf.7 = 1               'bit 7  nv - immer 1

'####################################################################################################################





'####################################################################################################################
if conf.1 = 1 then                             'SBUS aktivieren

   Open "COMB.5:100000,8,E,2,INVERTED" For Output As #1
   conf.2 = 0

'   Open "COMB.5:100000,8,E,2" For Output As #1
'   conf.2 = 1

   cl1 = sb1
   cl2 = sb2
   cl3 = sb3


else                              'PPM aktivieren

   Config data_out = Output
   data_out = Off

   cl1 = pp1
   cl2 = pp2
   cl3 = pp3

end if



'AD Wandler aktivieren
Config Adc = Single , Prescaler = Auto , Reference = Avcc   'AD-Wandler aktivieren
Start Adc


conf_ee = conf                'Config in eeProm sichtbar machen
Waitms 100



Do


'3-Pos-Schalter einlesen
'pro Eingang 100k gegen Gnd

If Eing1 = 1 Then
   Chan(1) = cl3
   Else
   Chan(1) = cl2
End If


If Eing2 = 1 Then
   Chan(2) = cl3
   Else
   Chan(2) = cl2
End If


If Eing3 = 1 Then
   Chan(3) = cl3
   Else
   Chan(3) = cl2
End If


If Eing4 = 1 Then
   Chan(4) = cl3
   Else
   Chan(4) = cl2
End If


If Eing5 = 1 Then
   Chan(5) = cl3
   Else
   Chan(5) = cl2
End If


If Eing6 = 1 Then
   Chan(6) = cl3
   Else
   Chan(6) = cl2
End If
If Eing7 = 1 Then
   Chan(7) = cl3
   Else
   Chan(7) = cl2
End If


If Eing8 = 1 Then
   Chan(8) = cl3
   Else
   Chan(8) = cl2
End If


If Eing9 = 1 Then
   Chan(9) = cl3
   Else
   Chan(9) = cl2
End If


If Eing10 = 1 Then
   Chan(10) = cl3
   Else
   Chan(10) = cl2
End If


If Eing11 = 1 Then
   Chan(11) = cl3
   Else
   Chan(11) = cl2
End If


If Eing12 = 1 Then
   Chan(12) = cl3
   Else
   Chan(12) = cl2
End If


If Eing13 = 1 Then
   Chan(13) = cl3
   Else
   Chan(13) = cl2
End If


If Eing14 = 1 Then
   Chan(14) = cl3
   Else
   Chan(14) = cl2
End If


If Eing15 = 1 Then
   Chan(15) = cl3
   Else
   Chan(15) = cl2
End If


If Eing16 = 1 Then
   Chan(16) = cl3
   Else
   Chan(16) = cl2
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
pull15 = 1
pull16 = 1



Waitus 10                                             'bisschen auf die Eing-Up's warten


If Eing1 = 0 Then
   Chan(1) = cl1
End If


If Eing2 = 0 Then
   Chan(2) = cl1
End If


If Eing3 = 0 Then
   Chan(3) = cl1
End If


If Eing4 = 0 Then
   Chan(4) = cl1
End If


If Eing5 = 0 Then
   Chan(5) = cl1
End If


If Eing6 = 0 Then
   Chan(6) = cl1
End If


If Eing7 = 0 Then
   Chan(7) = cl1
End If


If Eing8 = 0 Then
   Chan(8) = cl1
End If


If Eing9 = 0 Then
   Chan(9) = cl1
End If


If Eing10 = 0 Then
   Chan(10) = cl1
End If


If Eing11 = 0 Then
   Chan(11) = cl1
End If


If Eing12 = 0 Then
   Chan(12) = cl1
End If


If Eing13 = 0 Then
   Chan(13) = cl1
End If


If Eing14 = 0 Then
   Chan(14) = cl1
End If


If Eing15 = 0 Then
   Chan(15) = cl1
End If


If Eing16 = 0 Then
   Chan(16) = cl1
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
pull15 = 0
pull16 = 0



poti1 = getadc(6)                                   'Potis abfragen
poti2 = getadc(7)





if conf.1 = 1 then        'SBUS

if conf.0 = 1 then         'Poti 1,2 auf Kanal 15,16

   Poti1 = Poti1 * 13       'Wert strecken
   Poti1 = Poti1 / 8
   Poti2 = Poti2 * 13
   Poti2 = Poti2 / 8

   Chan(15) = poti1 + sbpoti
   Chan(16) = poti2 + sbpoti

end if


'Kanal > SBUS_Load

sbus_byte = 1
sbus_bit = 0

for Chan_nr = 1 to 16
   for Chan_bit = 0 to 10

      sbus_load(sbus_byte).sbus_bit = chan(chan_nr).chan_bit

      incr sbus_bit

      if sbus_bit >=8 then
         sbus_bit = 0
         incr sbus_byte
      end if

   next Chan_bit
next Chan_nr



'sbus out
printbin #1, &B00001111       'start byte
printbin #1, sbus_load(1) ; 22     'SBUS load data
printbin #1, &B00000000       'SBUS flag
printbin #1, &B00000000       'end byte

waitms sbus_frame

end if





if conf.1 = 0 then              'PPM


if conf.0 = 1 then         'Poti 1,2 auf Kanal 15,16
   Chan(15) = poti1 + pppoti
   Chan(16) = poti2 + pppoti
end if



' PPM-Signal erzeugen
For chan_nr = 1 To 16                                             'Anzahl Kanäle

   Pp = Chan(chan_nr)                                             'Schalter-Position auf Kanal ausgeben

   'PPM-Puls erzeugen
   data_out = On
   Waitus Puls
   data_out = Off
   Waitus Pp

Next


'PPM-Pause:
   data_out = On
   Waitus Puls
   data_out = Off
   Waitms ppm_Pause

end if


Loop
End