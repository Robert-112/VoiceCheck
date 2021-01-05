;==============================================
;==============================================
;
; VoiceCheck
; Version: 3.1 2021
; Ersteller: Robert Richter
;
;==============================================
;==============================================

#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#include <Date.au3>


; Ini-Datei einlesen, bzw. erzeugen
;==============================================

if not Fileexists(@ScriptDir & "\config.ini") then
   ; Server-IP
   $server_ip = Inputbox("Server-IP", "Wie lautet die IP-Adresse des Servers?", "127.0.0.1")
   Iniwrite(@Scriptdir & "\config.ini", "Einstellungen", "Server-IP", $server_ip)
   ; Titel
   $titel = Inputbox("Titel", "Wie lautet der Titel der auszuwertenden Anwendung?", "Notepad")
   Iniwrite(@Scriptdir & "\config.ini", "Einstellungen", "Titel", $titel)
   ; ClassNN
   $classnn = Inputbox("Objekt", "Wie lautet das auszuwertende Control-Objekt innerhalb der Anwendung?", "Button380")
   Iniwrite(@Scriptdir & "\config.ini", "Einstellungen", "ClassNN", $classnn)
endif

$server_ip = IniRead(@ScriptDir & "\config.ini", "Einstellungen", "Server-IP", "")
$titel = IniRead(@ScriptDir & "\config.ini", "Einstellungen", "Titel", "")
$classnn = IniRead(@ScriptDir & "\config.ini", "Einstellungen", "ClassNN", "")


; Tray-Icon erzeugen
;==============================================

Opt("TrayMenuMode", 3)
; Tray-Icon, Eintrag erzeugen und anzeigen
TraySetToolTip("VoiceCheck")
TraySetIcon(".\speaker-network.ico")
Local $idExit = TrayCreateItem("Programm beenden")
TraySetState($TRAY_ICONSTATE_SHOW)


; UDP-Dienst erstellen
;==============================================

UDPStartup()
; Cleanup-Funktion für Exit hinzufügen
OnAutoItExitRegister("Cleanup")
; Socket auf Port 45621 öffnen
$socket = UDPOpen($server_ip, 45621)
If @error <> 0 Then Exit


; auf eigentliche auszuwertende Anwendung warten
; und Button-Status laufend auswerten
;==============================================

WinWait($titel)
$old_button_status = ""

While 1
   Switch TrayGetMsg()
   Case $idExit
	  Exit
   EndSwitch
   ; Status des Button abfragen
   $button_status = ControlCommand($titel, "", "[CLASSNN:" & $classnn &"]", "isEnabled")
   ; hat sich button_status veraendert?
   if $button_status <> $old_button_status Then
	  ; Status uebersetzen
	  if $button_status = 0 Then
		 $sende_status = "talking"
	  EndIf
	  if $button_status = 1 Then
		 $sende_status = "idle"
	  EndIf
	  if $button_status = -1 Then
		 $sende_status = "error"
	  EndIf
	  ; VERALTET - Status als Text per UDP senden
	  $status = UDPSend($socket, @ipaddress1 & "#" & $sende_Status)
	  ; NEU - Status als JSON per UDP senden
	  $json = '{"client": "' & @ipaddress1 & '","status": "' & $sende_Status & '", "timestamp": "' & _Now() & '"}'
	  $status = UDPSend($socket, $json)
	  ; Fehlermeldung
	  If $status = 0 then
		 MsgBox(0, "ERROR", "Fehler beim Senden des UDP-Pakets: " & @error)
		 Exit
	  EndIf
	  ;aktuellen button_status sichern
	  $old_button_status = $button_status
   EndIf
   ; warten im CPU zu schonen
   Sleep(25)
WEnd


; Programm sauber beenden
;==============================================

Func Cleanup()
    UDPCloseSocket($socket)
    UDPShutdown()
EndFunc