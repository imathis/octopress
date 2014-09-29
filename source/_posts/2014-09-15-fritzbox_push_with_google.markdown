---
layout: post
title: "FritzBox PushService vs Gmail 2-Factor Anmeldung"
date: 2014-09-12 21:15:53 +0200
comments: false
categories: [configuration, fritzbox, 2-factor]
---

Wenn man den Push-Service der FritzBox mit Google-Mail verknüpfen will muss man ein wenig tricksen, wenn die 2-factor Anmeldung eingeschaltet ist.

<!--more-->

### In Google:

#### Anwendungsspezifisches Passwort erstellen

{% img right http://gvr.me/media/googleAppPassword.png 150 150 googleAppPassword %}

Unter den [securtiy settings](https://www.google.com/settings/security)  des Google-Accounts definiert man sich ein (eigenes) Anwendungsspezifisches Passwort. Dieses Passwort merken oder aber einfach den Tab offenlassen.

### In der Fritzbox:
#### Aktivieren des PushService

1. Navigiere to System-&gt;Push Service
2. Aktiviere die "FRITZ!Box Push Service aktiv" checkbox, jetzt kann man die Mailservereinstellungen anpassen.

{% img right http://gvr.me/media/fritzPushService.png 250 250 fritzPushService %}

#### Eingabe der Account Daten

1. Im _Feld E-Mail_ die vollständige E-Mail Adresse eingeben ```fritz.beispiel@gmail.com```
   - Die FRITZ!Box erkennt nun den Mail-Anbieter und schreibt ihn hinter die entsprechende Eingabezeile. 
2. Nun den domain-Teil der E-Mail Adresse löschen ```@gmail.com```
   - Zwei neue Eingabefelder werden eingeblendet: _E-Mail Benutzername_ und _SMTP-Server_.
3. Im Feld _E-Mail-Benutzername_ wird der local-part der E-Mail Adresse eingegeben. ```fritz.beispiel```
4. Im Feld _SMTP-Server_: ```smtp.googlemail.com``` sowie den _Port_ ```465``` eingeben.
5. Nun wird die E-Mail Adresse wieder um den in Punkt 2. gelöschten domain-Part ```@gmail.com``` erweitert.
   - Die Felder _E-Mail-Benutzername_ und _SMTP-Server_ werden wieder ausgeblendet.
6. Das anwendungsspezifische Passwort wird nun in das Feld _Kennwort_ kopiert.
7. Durch klicken  auf Übernehmen werden die Konfigurationen gespeichert.

