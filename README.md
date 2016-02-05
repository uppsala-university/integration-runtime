Utvecklingsmiljö för integrationer
==================================
TODO: Kort beskrivning av integrationskonceptet och miljön.

Starta miljö
------------
Miljön bygger på att Vagrant och Virtual Box finns instalerat på värdsystemet. Checka ut maskinen med

	git clone https://github.com/uppsala-university/integration-runtime/

I den utcheckade katalogen startas miljön med

    vagrant up

Efter att masknien startats och provisionerats är följande komponenter installerade

* Apache Karaf
* Apache ActiveMQ
* MariaDB
* Lokal httpd (för att simulera Ladok Feeds via statiska filer)

Tjänsterna
----------

Tjänsterna ska startas per automatik. Logga in i maskinens skal med

    vagrant ssh

Kontrollera att tjänsterna är startade med

    sudo service apache-karaf status
    sudo service activemq-instance-integration status
    sudo service activemq-instance-integration-dlq status
    sudo service mysql status

Monitorera genom att hålla koll på /opt/apache-karaf/data/log/karaf.log.

Konsoll för OSGi-miljö
----------------------
Kör ssh mot OSGi-milöjn. Lösenordet är "karaf"

    ssh -p 8101 karaf@localhost

I konsollen får man hjälp genom:

    help

Ett exempel kan ges att det går att följa loggen med:

    log:tail


Grafisk administrationsmiljö
----------------------------
Som grafiskt adminiistrationsgränssnitt installeras Hawtio tillsammans med övrig miljö i provisioneringen.

Gå till <http://localhost:8181/hawtio> oc använd karaf/karaf för inloggning.

Eftersom att Hawtio körs direkt i OSGi-kontainern kommer Hawtio att per automatik att kunna monitorera allt som går att monitoreras i OSGi-kontainern. ActiveMQ körs inte i samma miljö utan exekveras som *en enskild process per broker*.

För att ansluta till *respektive broker* välj menyalternativet **[ Container | Connect ]** i Hawtio. I **Connection Settings** anges:

| Setting       | Value         |
| ------------- |:-------------:|
| Name          | integration   |
| Scheme        | http          |
| Port          | 8161          |
| User name     | *****         |
| Password      | *****         |

Om inte användarnamn och lösenord ändrats i installationen för ActiveMQ är de `admin/admin`.

I installationen av ActiveMQ installeras två brokers, en för alla integrationsteknikens meddelanden samt en broker för att skriva de meddelanden som av någon anledning inte kan skickas (dead letters). Dead letters kan inte hanteras i samma broker eftersom att de inte ska transaktionshanteras tillsammans (i en Apache Camel route kan man inte ha två separata parallela handtag till samma broker). Broker två namnges `integration-dlq` och publicerar sitt REST-baserade adminstrationsgränssnitt (Jolokia) på port 8162. 

Installera certifikat för nya Ladok
-----------------------------------
Klienterna som används för att hämta händelser från Ladok's ATOM-gränssnitt och för att komma åt nya Ladok's REST-gränssnitt finns i biblioteket <https://github.com/uppsala-university/ladok>.

Klientcertifikat till nya Ladok måste läggas in någonstans i filsystemet på den provisionerade maskinen. Certifikatet ska vara på PKCS 12-format.

I `ladok3atom-client/src/main/resources` finns en exempelfil för fordrade egenskaper. Använd den genom att döpa om den

    mv atomclient.properties.sample atomclient.properties

Redigera sedan filen `ladok3atom-client/src/main/resources/atomclient.properties` för att innehålla rätt namn och plats på certifikatfil och lösenord.

För REST-klienten krävs motsvarande konfiguration (`ladok3rest-client/src/main/resources/restclient.properties`). Till REST-klienten behövs även en nyckelring med certifikat för att verifiera den krypterade kommunikationen med nya Ladok. Det går bra att använda sig av den nyckelring som installeras tillsammans med Java (filen cacerts som har lösenordet *changeit* som standardlösenord).

För att slippa lägga in certifikat i den provisionerade maskinen varje gång den rensas rekommenderas att lägga filerna i den katalog som har maskinkonfigurationen (`integration-runtime`) som sedan per automatik monsteras på `/vagrant` i gästsystemet. Referera sedan till `/vagrant/certifikatsfil` i konfigurationsfilen.

Driftsätt händelsehanteraren i OSGi-miljö
-----------------------------------------
Checka ut projekten `common-integration`, `ladok` och `ladok-integration`: 

    git clone git@github.com/uppsala-university/ladok
    git clone git@github.com/uppsala-university/ladok-integration
    git clone git@github.com/uppsala-university/common-integration    

Driftsättning i OSGi-miljön görs genom provisioneringsmetoden "features" (Apache Karaf). I projektet "ladok-integration" finns modulen "ladok-integration-packaging-karaf" som innehåller vidare information om hur man enklast driftsätter.