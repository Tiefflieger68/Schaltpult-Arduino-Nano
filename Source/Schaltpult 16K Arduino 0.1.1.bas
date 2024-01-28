
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



Const V1 = 0
Const V2 = 1
Const V3 = 1



$regfile = "m328pdef.dat"
$crystal = 16000000

$hwstack = 32                                               ' default use 32 for the hardware stack
$swstack = 10                                               ' default use 10 for the SW stack
$framesize = 40                                             ' default use 40 for the frame space



'negative Pulse
Const On = 1
Const Off = 0

'positive Pulse  -  openTX frisst beides
'Const On = 0
'Const Off = 1


Const Puls = 300                                            'uS
Const ppm_Pause = 10                                        'mS - min 4 mS
Const Pp1 = 986 - Puls                                      'uS  -100%  ("puls" ist abzuziehen)
Const Pp2 = 1499 - Puls                                     'uS  0%
Const Pp3 = 2012 - Puls                                     'uS  +100%


CONST Updateeprom=1                                         'EEProm nur schreiben wenn Wert <>
dim V1_ee as ERAM byte
dim V2_ee as ERAM byte
dim V3_ee as ERAM byte

V1_ee = V1
V2_ee = V2
V3_ee = V3



Dim A As Byte
Dim Pp As word                                           'Pulslänge in uS

Dim Chan(16) As word

Dim Poti1 As word                                      'Werte der Potis
Dim Poti2 As word


Dim Poti As Byte                                               'Poti's aktivieren




'Setup - Definition der Funktionen
poti = 1                           '1 = Potis für Kanal 15 u 16  ###  0 = kein Poti, Kanal 15,16 auf Schalter





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



Ppmout Alias Portb.5           'PortB.5 = LED
Config Ppmout = Output




'AD-Wandler für Poti's aktivieren
'if poti >= 1 then

   Config Adc = Single , Prescaler = Auto , Reference = Avcc   'AD-Wandler aktivieren
   Start Adc

'end if





Ppmout = Off
Waitms 100


Do


'3-Pos-Schalter einlesen
'pro Eingang 100k gegen Gnd

If Eing1 = 1 Then
   Chan(1) = Pp3
   Else
   Chan(1) = Pp2
End If


If Eing2 = 1 Then
   Chan(2) = Pp3
   Else
   Chan(2) = Pp2
End If


If Eing3 = 1 Then
   Chan(3) = Pp3
   Else
   Chan(3) = Pp2
End If


If Eing4 = 1 Then
   Chan(4) = Pp3
   Else
   Chan(4) = Pp2
End If


If Eing5 = 1 Then
   Chan(5) = Pp3
   Else
   Chan(5) = Pp2
End If


If Eing6 = 1 Then
   Chan(6) = Pp3
   Else
   Chan(6) = Pp2
End If
If Eing7 = 1 Then
   Chan(7) = Pp3
   Else
   Chan(7) = Pp2
End If


If Eing8 = 1 Then
   Chan(8) = Pp3
   Else
   Chan(8) = Pp2
End If


If Eing9 = 1 Then
   Chan(9) = Pp3
   Else
   Chan(9) = Pp2
End If


If Eing10 = 1 Then
   Chan(10) = Pp3
   Else
   Chan(10) = Pp2
End If


If Eing11 = 1 Then
   Chan(11) = Pp3
   Else
   Chan(11) = Pp2
End If


If Eing12 = 1 Then
   Chan(12) = Pp3
   Else
   Chan(12) = Pp2
End If


If Eing13 = 1 Then
   Chan(13) = Pp3
   Else
   Chan(13) = Pp2
End If


If Eing14 = 1 Then
   Chan(14) = Pp3
   Else
   Chan(14) = Pp2
End If


If Eing15 = 1 Then
   Chan(15) = Pp3
   Else
   Chan(15) = Pp2
End If


If Eing16 = 1 Then
   Chan(16) = Pp3
   Else
   Chan(16) = Pp2
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


poti1 = getadc(6)                                   'Potis abfragen
poti2 = getadc(7)


Waitms 1                                             'bisschen auf die Eing-Up's warten


If Eing1 = 0 Then
   Chan(1) = Pp1
End If


If Eing2 = 0 Then
   Chan(2) = Pp1
End If


If Eing3 = 0 Then
   Chan(3) = Pp1
End If


If Eing4 = 0 Then
   Chan(4) = Pp1
End If


If Eing5 = 0 Then
   Chan(5) = Pp1
End If


If Eing6 = 0 Then
   Chan(6) = Pp1
End If


If Eing7 = 0 Then
   Chan(7) = Pp1
End If


If Eing8 = 0 Then
   Chan(8) = Pp1
End If


If Eing9 = 0 Then
   Chan(9) = Pp1
End If


If Eing10 = 0 Then
   Chan(10) = Pp1
End If


If Eing11 = 0 Then
   Chan(11) = Pp1
End If


If Eing12 = 0 Then
   Chan(12) = Pp1
End If


If Eing13 = 0 Then
   Chan(13) = Pp1
End If


If Eing14 = 0 Then
   Chan(14) = Pp1
End If


If Eing15 = 0 Then
   Chan(15) = Pp1
End If


If Eing16 = 0 Then
   Chan(16) = Pp1
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




if poti >= 1 then

   Chan(15) = poti1 + pp1
   Chan(16) = poti2 + pp1

end if




For A = 1 To 16                                             'Anzahl Kanäle

   Pp = Chan(a)                                             'Schalter-Position auf Kanal ausgeben

   'PPM-Puls erzeugen
   Ppmout = On
   Waitus Puls
   Ppmout = Off
   Waitus Pp

Next A


'PPM-Pause:
   Ppmout = On
   Waitus Puls
   Ppmout = Off
   Waitms ppm_Pause


Loop
End


