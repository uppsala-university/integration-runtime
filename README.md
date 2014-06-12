Du behöver vagrant och virtualbox på din dator.

Starta miljön
=============

Starta maskinen med vagrant

`$ vagrant up`

Efter en stunds tuggande bör maskinen komma igång med följande komponenter installerade

* servicemix
* httpd (för att simulera Ladok Feeds via statiska filer)

Starta servicemix
=================

Starta servicmix i den virtuella miljön

`$ vagrant ssh`

`$ sudo service apache-servicemix start`

Håll sedan koll på filen /var/lib/servicemix/log/servicemix.log. 

Konsol för servicemix
=====================
Kör ssh mot servicemix. Lösenorder är "smx"

`$ ssh -p 8101 smx@localhost`

I konsollen kan du t.ex. titta på inkommande kön:

`activemq:browse --amqurl tcp://localhost:61616 ladok3-event-distribution`

eller följa loggen:

`log:tail`


Installera webkonsoll för ActiveMQ samt Hawtio
==============================================

Om du vill, se följande adresser:

* <http://marcelojabali.blogspot.se/2011/08/how-to-enable-activemq-web-console-on.html>
* <http://hawt.io/getstarted/index.html>

	(Hawtio i korthet...) 
	 
	features:addurl mvn:io.hawt/hawtio-karaf/1.0/xml/features
	features:install hawtio
	
Installera klientcertifikat för Ladok3
================================
Kopiera ditt klientcertifikat för Ladok3 till katalogen `feedhandler/src/main/resources/`. Certifikatet ska vara på PKCS 12-format.

Redigera filen `feedhandler/src/main/resources/feedfetcher.properties`. Skriv in namnet på din certifikatfil och lösenordet.

Deploya Feedhander i vagrant-miljö
==================================

Från den här katalogen, kör följande för att bygga all kod. Detta är ett "maven multi module project"

`$ mvn clean package`

Nu går det att deploya till servicemix. Det görs genom att kopiera filer till deploy-katalogen som
ligger under "smx/deploy" relativt denna fil. Detta är en specialare för vagrant-miljöerna. En närmare
titt i filen provision/manifests/default.pp indikerar att puppet kommer länka om deploy-katalogen så 
att den hamnar på den delade disken mellan vagrant-maskinen och värd-maskinen. Detta gör det smidigare
att utveckla. 

`$ cp feedhandler/target/feedhandler-0.0.1-SNAPSHOT.jar smx/deploy/`

`$ cp feedhandler-servicemix/target/feedhandler-servicemix-0.0.1-SNAPSHOT.jar smx/deploy/`

Deploya även en konsument om du vill det

`$ cp feedhandler-consumer-servicemix/target/feedhandler-consumer-servicemix-0.0.1-SNAPSHOT.jar smx/deploy/`

Din deploy-katalog på den här delade disken kommer överleva omstarter och ominstallationer (vagrant destroy) 
av den virtuella maskinen.

Deploya Feedhandler i ICKE-vagrant-miljö
========================================

Samma jar-filer som ovan men de ska kopieras in i `/opt/servicemix/apache-servicemix-4.5.3/deploy`