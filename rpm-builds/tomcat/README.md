# RPM-paket för Apache Tocat
Det här är en byggmiljö för att skapa RPM-baserade installationspaket av Apache Tomcat [( -> http://tomcat.apache.org)](http://tomcat.apache.org).

Miljön består i huvudsak av två filer

    build-rpm.sh
    apache-tomcat.spec

ett byggskript och en byggspecifikation. Byggspecifikationen ska aldrig uppdateras med någon versionsinformation, det görs från byggskriptet.

Redigera alltså

	build-rpm.sh
	
för att matcha den version av Apache Tomcat som det ska skapas ett installationspaket för. Starta sedan byggprocessen med

	./build-rpm.sh

Observera att värdsystemet måste vara RPM-baserat för sina paket.

Installationspaketet kommer att installera aktuell version av Apache Tomcat under 
	
	/opt
	
och göra en länk till den enligt mönstret

	/opt/apache-tomcat -> /opt/apache-tomcat-$VERSION
	
där `$VERSION` översätts till den version av Apache Tomcat som har angivits i `build-rpm.sh`. Samtidigt kommer det att skapas en länk för att starta Tomcat som en tjänst enligt mönstret:

	/etc/init.d/apache-tomcat -> /opt/apache-karaf/bin/karaf-service

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