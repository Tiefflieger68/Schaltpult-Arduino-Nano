# Schaltpult Ardu Nano
# Schaltererweiterung für openTX und EdgeTX Sender

 
![image lost ?](Pics/MT12.jpg)

Entwickelt wurde die Schaltung für die Möglichkeiten von OpenTX und EdgeTX Fernsteuerungen.  
 
Anschlüsse für bis zu 14 zusätzliche Schalter und 2 Potis.  
Schalteingänge mit diesen Schalterkonfigurationen sind, beliebig kombiniert, nutzbar:  
•  2-Pos-Schalter  
•  3-Pos-Schalter  
•  Einfache Taster  
•  Doppeltaster (2 Taster auf einem Eingang)  

Details und Einstellungen für OpenTX und EdgeTX für siehe "DOCS"  

Die Schaltung erzeugt ein 16-Kanal PPM, SBUS und SBUS UART (nicht invertiert) Signal.  
Je nach Protokoll, stehen verschiedene Anschlussmöglichkeiten zur Verfügung und es ist der entsprechende Anschluss am Arduino Nano auszuwählen.  
- PPM: 16-Kanal PPM Signal (Modulschacht und Trainerport)  
- SBUS: Standard SBUS (Modulschacht)  
- SBUS UART: SBUS für non-inverted UART (AUX Ports)  

siehe „Anschaltung 0.3.x.pdf“

Nicht alle Möglichkeiten stehen bei allen Sendern zur Verfügung.
Es sollte möglichst eine Variante mit SBUS-Protokoll gewählt werden, da die Werte digital und damit genauer übertragen werden.

### Achtung mit EdgeTX 2.10.0 ist der Pin im Modulschacht für SBUS Trainer auf den S.Port Pin umgezogen !
 
Der Code wurde mit BASCOM-AVR erzeugt.  
Siehe "Source" und "Binary"

Support-Forum:  
https://www.rc-network.de/threads/schaltpult-nautik-modul-f%C3%BCr-frsky-opentx-sender.690399/  
und  
https://www.rockcrawler.de/thread/52817-abnehmbare-schaltererweiterung-f%C3%BCr-radiomaster-mt12/?pageNo=1  

Eine Materialliste findest Du hier: https://www.reichelt.de/my/2115155  


Neben dem Arduino Nano sind nur wenige Bauteile nötig  

![image lost ?](Pics/PCB02.jpg)

Auch fertig verdrahtet bleibt es übersichtlich  

![image lost ?](Pics/PCB06.jpg)



# English:  
By now, all documents are written in German. I will support English requests as well  