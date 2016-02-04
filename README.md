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

Eftersom att Hawtio körs direkt i OSGi-kontainern kommer Hawtio att per automatik kunna monitorera allt som går att monitoreras i OSGi-kontainern. ActiveMQ körs inte i samma miljö utan exekveras som en enskild process per <b>broker</b>.

För att ansluta till respektive broker välj menyalternativet <b>[ Container | Connect ]</b> i Hawtio. I <b>Connection Settings</b> anges:

| Setting       | Value         |
| ------------- |:-------------:|
| Name          | integration   |
| Scheme        | http          |
| Port          | 8161          |
| User name     | *****         |
| Password      | *****         |

Om inte användarnamn och lösenord ändrats i installationen för ActiveMQ är de `admin/admin`.

I installationen av ActiveMQ installeras två brokers, en för alla integrationsteknikens meddelanden samt en broker för att skriva de meddelanden som av någon anledning inte kan skickas (dead letters). Dead letters kan inte hanteras i samma broker eftersom att de inte ska transaktionshanteras tillsammans (i en Apache Camel route kan man inte ha två separata parallela handtag till samma broker). Broker två namnges `integration-dlq` och publicerar sitt REST-baserade adminstrationsgränssnitt (Jolokia) på port 8162. 

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