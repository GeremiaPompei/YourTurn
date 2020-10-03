# YourTurn
__YourTurn__ è un'applicazione che permette agli utenti di __mettersi in coda__ nei vari esercizi commerciali che ne offrono l'opportunità in maniera totalmente __digitale__. Questa app sostituisce del tutto e in maniera efficacie l'eliminacoda presente nei supermercati.
Ogni utente che si registra in __YourTurn__ puo sfruttare il suo servizio da entrambi i lati, ovvero:
- __Creare__ una coda tramite id univoco e luogo
- __Partecipare__ ad una coda gia creata da altri utenti
## Come funziona
Appena scaricata l'app appare la schermata di login e signin dove un utente puo autenticarsi o registrarsi tramite informazioni personali come __Nome, Cognome, Anno di nascita, Sesso, Email__ e __Numero di Telefono__.
Dopo essersi registrato o autenticato l'utente preme rispettivamente SignIn o LogIn ed entra nella prima delle due schermate principali. Esse sono:
- Crea
- Partecipa
#### Crea
Schermata dove un utente inserendo un __Id univoco__ e un luogo puo creare la propria coda. L'id viene controllato al momento della creazione e se ne è gia presente un altro uguale l'utente viene avvertito tramite un messaggio di errore.
Creata la coda si entra nella schermata di Servizio.
##### Schermata di Servizio
La Schermata di Servizio è dove vi sono le informazioni principali riguardantila fila al momento dell'esecuzione: 
- __Nome__ della coda
- __Qr__ corrispondente al link del pdf da condividere
- Pulsante per la condivisione del __documento pdf__ con qr (il Qr centrale è il pulsante)
- __Numero del ticket__ corrispondente all'utente servito al momento
- __Utenti rimanenti__ in coda
- __Utenti totali__ in coda
- Bottone per visualizzare il profilo dell'__utente che si sta servendo__ al momento che apre una schermata con le sue relative informazioni tra le quali numero di telefono e email.
- Bottone per proseguire in __avanti__ passando al prossimo utente
- Bottone per __interrompere__ la fila e ritornare alla schermata principale
#### Partecipa
Questa è la schermata dove sono presenti i tickets generati quando si partecipa ad una fila con relative informazioni. In basso a destra è presente un bottone che contiene due opzioni principali:
- Scannerizzare __Qr__
- Cercare coda tramite __Id__

Appena viene trovata una coda valida viene visualizzata sotto l'area di testo una spunta. Premuta la spunta si accede alle informazioni principali sulla coda mentra premuto il pulsante __Partecipa__ in basso a destra si genera il proprio ticket per partecipare alla coda.
Appena si partecipa alla coda dopo un __refresh__ (tramite lo scorrimento verso il basso) si possono visualizzare i ticket nella schermata partecipa fino a quando non si viene serviti.
#### Schermata Utente
In alto a destra in entrambe le schermate Cerca e Partecipa è presente un omino tramite il quale è possibile aprire una schermata con le info sull'utente e due opzioni:
- __Rimuovi Account__ (a sinistra)
- __LogOut__ (a destra) 
##### Rimuovi Account
Permette di eliminare l'account dell'utente che per farlo deve reinserire propri email e password
##### LogOut
Permette ad un utente di scollegarsi e si viene reindirizzati alla schermata iniziale di LogIn e SignIn.
## Funzionalità
Per implementare al meglio tale idea sotto forma di app sono state sfruttate diverse funzionalità:
- __Generazione Qr__ alla creazione della coda utile per partecipare alla fila in modo smart e veloce grazie alla webcam che scannerizza il qr e accede direttamente alla fila tramite conferma. Il codice Qr puo essere poi anche inviato tramite link che corrisponde alla risorsa PDF presente nel server. In tal modo basta condividere l'URL e scaricare o stampare la risorsa dal browser. Per utilizzare il lettore qr bisogna accettare le condizioni di utilizzo della telecamera.
- __Notifiche__ tramite le quali viene avvisato quando mancano tre, due e una persona prima di lui. L'utente riceve una notifica anche se la coda termina senza essere stato servito. Le notifiche funzionano sia in app che fuori da essa. Per abilitare le notifiche bisogna accettare all'istallazione dell'app le condizioni.
- Numeri di __telefono__ e __email__ collegati al sistema in modo tale che durante la coda viene agevolata la comunicazione tra gli utenti. Soprattutto viene favorita la comunicazione tra chi cea e chi partecipa alla fila che può essere chiamato dal primo se quest'ultimo non è presente.