RPM-paket för Apache Karaf
==========================
Det här är en byggmiljö för att skapa RPM-baserade installationspaket av Apache Karaf [( -> http://karaf.apache.org)](http://karaf.apache.org).

Miljön består i huvudsak av två filer

    build-rpm.sh
    apache-karaf.spec

ett byggskript och en byggspecifikation. Byggspecifikationen ska aldrig uppdateras med någon versionsinformation, det görs från byggskriptet.

Redigera alltså

	build-rpm.sh
	
för att matcha den version av Apache Karaf som det ska skapas ett installationspaket för. Starta sedan byggprocessen med

	./build-rpm.sh

Observera att värdsystemet måste vara RPM-baserat för sina paket.

Installationspaketet kommer att installera aktuell version av Apache Karaf under 
	
	/opt
	
och göra en länk till den enligt mönstret

	/opt/apache-karaf -> /opt/apache-karaf-$VERSION
	
där `$VERSION` översätts till den version av Apache Karaf som har angivits i `build-rpm.sh`. Samtidigt kommer det att skapas en länk för att starta Karaf som en tjänst enligt mönstret:

	/etc/init.d/apache-karaf -> /opt/apache-karaf/bin/karaf-service

Modifiering av källan
=====================
Apache Karaf kommer utan startskript för olika miljöer. Installation av dessa görs inifrån Karaf's administrationskonsoll. För att få tillhörande filer i installationspaketet måste de därför extraheras och modifieras innan de kan läggas in. Nuvarande versioner och konfigurationer kommer från version 4.0.4 av Karaf. Filterna är:

	karaf-service		
	karaf-wrapper-main.jar	
	karaf-wrapper.jar	
	libwrapper.so
	karaf-wrapper		
	karaf-wrapper.conf	
	karaf.service
	
I filen
 
	karaf-service 

anger man vilken användare som Karaf ska köras med och i 

	karaf-wrapper.conf
	
anges sökvägar till var Karaf ska lagra sina filer. 

Om inte någon förändring har skett i filerna behöver de inte uppdateras i en versionsuppgradering.