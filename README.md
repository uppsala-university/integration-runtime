# Utvecklingsmiljö för integrationer

Det här är en virtuell utvecklingsmiljö för att bygga integrationer baserat på olika komponenter från Apache Foundation. I miljön finns köhanterare, DBMS, och en OSGi-miljö för att exekvera de integrationspunkter som utvecklas - primärt integrationsflöden implementerade med Apache Camel. Komponenterna är sammansatta för att stödja implementation av integrationspunkter baserade på tankar och tekniker beskrivna i [Enterprise Integraton Patterns](http://www.enterpriseintegrationpatterns.com).

Miljön är framtagen som ett led i det förändringsarbete svenska lärosäten genomgår genom att en ny version av det centrala systemet för studieadministration, [Ladok](http://www.ladok.se/ladok/nya-ladok/integrationer/), är under framtagande.


## Starta miljön
Miljön bygger på att Vagrant och Virtual Box finns installerat på värdsystemet. Den aktuella versionen av Virtual Box drivrutiner i gästsystemet är 5.0.14, för att undvika konflikter mellan värd- och gästsystem bör samma version användas i värdsystemet.

Ladda ner maskinen via antingen den länkade zip-filen eller om `git` finns installerat i värdsystemet checka ut maskinen med

	git clone https://github.com/uppsala-university/integration-runtime/

I den nedladdade katalogen startas miljön med

    vagrant up

Efter att maskinen startats och provisionerats är följande komponenter installerade

* OSGi-miljö: *Apache Karaf*
* Köhanterare: *Apache ActiveMQ*
* DBMS: *MariaDB*
* Testmiljö: *Webbserver för att simulera nya Ladok's händelseflöde via statiska filer (Atom feeds)*


## Tjänsterna
Tjänsterna startas per automatik. Logga in i maskinens skal med

    vagrant ssh

och kontrollera att tjänsterna är startade med

    sudo service apache-karaf status
    sudo service activemq-instance-integration status
    sudo service activemq-instance-integration-dlq status
    sudo service mysql status

Monitorera genom att hålla koll på /opt/apache-karaf/data/log/karaf.log.


## Konsoll för OSGi-miljö
Kör ssh mot OSGi-milöjn. Lösenordet är "karaf"

    ssh -p 8101 karaf@localhost

I konsollen får man hjälp genom:

    help

Ett exempel kan ges att det går att följa loggen med:

    log:tail


## Grafisk administrationsmiljö
Som grafiskt administrationsgränssnitt installeras Hawtio tillsammans med övrig miljö i provisioneringen. Öppna <http://localhost:8181/hawtio> och använd karaf/karaf för inloggning.

Eftersom att Hawtio körs direkt i OSGi-kontainern kommer Hawtio att per automatik att kunna monitorera allt som går att monitoreras i OSGi-kontainern. ActiveMQ körs inte i samma miljö utan exekveras som *en enskild process per broker*.

För att ansluta till *respektive broker* välj menyalternativet **[ Container | Connect ]** i Hawtio. I **Connection Settings** anges:

| Setting       | Value         |
| ------------- |:-------------:|
| Name          | integration   |
| Scheme        | http          |
| Host          | localhost     |
| Path          | api/jolokia   |
| Port          | 8161          |
| User name     | *****         |
| Password      | *****         |

Om inte användarnamn och lösenord ändrats i installationen för ActiveMQ är de `admin/admin`.

I installationen av ActiveMQ installeras två brokers, en för alla integrationsteknikens meddelanden samt en broker för att skriva de meddelanden som av någon anledning inte kan skickas (dead letters). Dead letters kan inte hanteras i samma broker eftersom att de inte ska transaktionshanteras tillsammans (i en Apache Camel route kan man inte ha två separata parallela handtag till samma broker). Broker två namnges `integration-dlq` och publicerar sitt REST-baserade adminstrationsgränssnitt (Jolokia) på port 8162. 


## Installera certifikat för nya Ladok
För installation av certifikat i en OSGi-miljö, se "Konfiguration i OSGi-miljö (Karaf)".

Klienterna som används för att hämta händelser från Ladok's ATOM-gränssnitt och för att komma åt nya Ladok's REST-gränssnitt finns i biblioteket <https://github.com/uppsala-university/ladok>.

Klientcertifikat till nya Ladok måste läggas in någonstans i filsystemet på den provisionerade maskinen. Certifikatet ska vara på PKCS 12-format.

I `ladok3atom-client/src/main/resources` finns en exempelfil för fordrade egenskaper. Använd den genom att döpa om den

    mv atomclient.properties.sample atomclient.properties

Redigera sedan filen `ladok3atom-client/src/main/resources/atomclient.properties` för att innehålla rätt namn och plats på certifikatfil och lösenord.

För REST-klienten krävs motsvarande konfiguration (`ladok3rest-client/src/main/resources/restclient.properties`). Till REST-klienten behövs även en nyckelring med certifikat för att verifiera den krypterade kommunikationen med nya Ladok. Det går bra att använda sig av den nyckelring som installeras tillsammans med Java (filen cacerts som har lösenordet *changeit* som standardlösenord).

För att slippa lägga in certifikat i den provisionerade maskinen varje gång den rensas rekommenderas att lägga filerna i den katalog som har maskinkonfigurationen (`integration-runtime`) som sedan per automatik monsteras på `/vagrant` i gästsystemet. Referera sedan till `/vagrant/certifikatsfil` i konfigurationsfilen.


## Driftsätt händelsehanteraren i OSGi-miljö
Checka ut projekten `ladok`, `ladok-integration`, `common-integration` och eventuellt `uu-integration`:

    git clone git@github.com/uppsala-university/ladok
    git clone git@github.com/uppsala-university/ladok-integration
    git clone git@github.com/uppsala-university/common-integration
    git clone git@github.com/uppsala-university/uu-integration

Driftsättning i OSGi-miljön görs genom provisioneringsmetoden "features" (Apache Karaf).
I projektet "ladok-integration" finns modulen "ladok-integration-packaging-karaf" som innehåller vidare information om hur driftsättning enklast görs.
Motsvarande beskrivning för uu-integration finns i uu-integration/uu-integration-packaging-karaf.


## Konfiguration i OSGi-miljö (Karaf)
Apache Karaf läser in property-filer i $KARAF_HOME/etc/, så för att konfigurera händelsekonsumtionssystemet och dess hjälpbibliotek,
kopiera filerna

    common-integration/common-integration-packaging-karaf/se.sunet.ati.integration.common.cfg
    ladok-integration/ladok-integration-packaging-karaf/se.sunet.ati.integration.ladok.cfg
    uu-integration/uu-integration-packaging-karaf/se.uu.its.integration.cfg
	
till $KARAF_HOME/etc/ och uppdatera dessa med aktuella värden.

Filen se.sunet.ati.integration.ladok.cfg innehåller motsvarande properties (men med ett extra prefix) som filerna

    atomclient.properties
    restclient.properties

som beskrevs i "Installera certifikat för nya Ladok". I en Karaf OSGi-container så är det mer praktiskt att kunna konfigurera properties
i en extern property-fil i $KARAF_HOME/etc/ än en property-fil inbakad i motsvarande jar-fil.

Om både t.ex. atomclient.properties finns i jar-filen och se.sunet.ati.integration.ladok.cfg finns i $KARAF_HOME/etc/, så kommer 
property-värdena i se.sunet.ati.integration.ladok.cfg att gälla.

Anledningen till att det finns två sätt att konfigurera properties för dessa klient-bibliotek är för att de ska kunna köras både fristående
och som en OSGi-bundle i en container.
