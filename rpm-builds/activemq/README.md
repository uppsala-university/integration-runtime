RPM-paket för Apache ActiveMQ
=============================
Det här är en byggmiljö för att skapa RPM-baserade installationspaket av Apache Karaf [( -> http://activemq.apache.org)](http://activemq.apache.org).

Miljön består av två filer

    build-rpm.sh
    apache-active.spec

ett byggskript och en byggspecifikation. Byggspecifikationen ska aldrig uppdateras med någon versionsinformation, det görs från byggskriptet.

Redigera alltså

	build-rpm.sh
	
för att matcha den version av Apache ActiveMQ som det ska skapas ett installationspaket för. Starta sedan byggprocessen med

	./build-rpm.sh

Observera att värdsystemet måste vara RPM-baserat för sina paket.

Installationspaketet kommer att installera aktuell version av Apache ActiveMQ under 
	
	/opt
	
och göra en länk till den enligt mönstret

	/opt/apache-activemq -> /opt/apache-activemq-$VERSION
	
där `$VERSION` översätts till den version av Apache ActiveMQ som har angivits i `build-rpm.sh`. Samtidigt kommer det att skapas en länk för att starta ActiveMQ som en tjänst enligt mönstret:

	/etc/init.d/apache-activemq -> /opt/apache-activemq/bin/activemq