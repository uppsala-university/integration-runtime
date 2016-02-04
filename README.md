Du behöver Vagrant och Virtual Box på din dator.

Starta miljön
=============

Starta maskinen med vagrant

    vagrant up

Efter en stunds tuggande bör maskinen komma igång med följande komponenter installerade

* Apache Karaf
* Apache ActiveMQ
* MariaDB
* Lokal httpd (för att simulera Ladok Feeds via statiska filer)

Tjänsterna
=================

Tjänsterna ska startas per automatik. Logga in i maskinens skal med

    vagrant ssh

Kontrollera att tjänsterna är startade med

    sudo service apache-karaf status
    sudo service apache-activemq status
    sudo service mysql status

Monitorera genom att hålla koll på /opt/apache-karaf/data/log/karaf.log.

Konsoll för OSGi-miljö
======================
Kör ssh mot OSGi-milöjn. Lösenordet är "karaf"

    ssh -p 8101 karaf@localhost

I konsollen får man hjälp genom:

    help

Ett exempel kan ges att det går att följa loggen med:

    log:tail


Installera grafisk administrationsmiljö
=======================================
Som grafiskt adminiistrationsgränssnitt rekommenderas Hawtio. Hawtio installeras inte per autmatik utan installeras genom:
(Hawtio i korthet...)

	`repo-add hawtio`
	`feature:install hawtio`

Gå sedan till <http://localhost:8181/hawtio> oc använd smx/smx för inloggning.

TODO: Lägg till inforamtion om hur man konfigurerar Hawtio för att även monitorera ActiveMQ.

Installera klientcertifikat för nya Ladok
=========================================
Klienten som används för att hämta händelser från Ladok's ATOM-gränssnitt finns i biblioteket <https://github.com/uppsala-university/ladok>.

Kopiera klientcertifikat till nya Ladok någonstans i filsystemet på den provisionerade maskinen. Certifikatet ska vara på PKCS 12-format.

I `ladok3atom-client/src/main/resources` finns en exempelfil för fordrade egenskaper. Använd den genom att döpa om den

    mv atomclient.properties.sample atomclient.properties

Redigera sedan filen `ladok3atom-client/src/main/resources/atomclient.properties` för att innehålla rätt namn och plasts på certifikatfil och lösenord.

Driftsätt händelsehanteraren i den OSGi-miljö
=============================================
Checka ut projekten `ladok`, `ladok-integration`: 

    git clone git@github.com/uppsala-university/ladok
    git clone git@github.com/uppsala-university/ladok-integration
    git clone git@github.com/uppsala-university/common-integration    

Driftsättning i OSGi-miljön görs genom provisioneringsmetoden "features" (Apache Karaf). I projektet "ladok-integration" finns modulen "ladok-integration-packaging-karaf" som innehåller information om hur driftsättning görs.