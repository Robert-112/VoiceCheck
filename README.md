# VoiceCheck
AutoIt-Script um dauerhaft den Status eines Buttons innerhalb einer bestimmten Anwendung per UDP weiterzuleiten.

## Installation
Benötigt AutoIt (https://www.autoitscript.com/) zum kompilieren.

## Anwendung
Beim ersten Start werden die notwendigen Parameter abgefragt und in einer *config.ini* gespeichert:

 - IP-Adresse des Servers an die UDP-Pakete gesendet werden (Port 45621)
 - Titel der zu überwachenden Anwendung (z.B. "Unbenannt - Editor" beim Windows-Notepad)
 - ClassID das zu kontrollierenden Elements (z.B. "Button1")
 Kann mit dem "AutoIt Window Info Tool" (Link: https://www.autoitscript.com/autoit3/docs/intro/au3spy.htm) ausgelesen werden.

Anschließend läuft das Programm im Hintergrund und kann über das Symbol ![enter image description here](https://raw.githubusercontent.com/Robert-112/VoiceCheck/master/speaker-network.ico) im Tray beendet werden. 
