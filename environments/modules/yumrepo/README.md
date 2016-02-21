Lokalt Yum-bibliotek
====================
För paket som inte finns i vare sig *Maven Central Repository* eller har ett eget (som MariaDB) så behöver paketen kunna installeras på ett sätt som passar *Puppet* som provisioneringsteknik. Det är det lokala Yum-biblioteket som erbjuder den tjänsten.

Lägg bara till RPM-paket i `files/yumrepo` så kommer modulen att göra dem tillgängliga för installation. 

Ex. lägg till filen 

	files/yumrepo/my-package-1.0.0-0.x86_64.rpm
	
så kan man sedan installera paket genom 

	yum install my-package-1.0.0-0.x86_64
	
eller hänvisa till paketet i en annan Puppet-modul. Paketet måste då har ett beroende till det lokala Yum-biblioteket. 

	package { "my-package-1.0.0-0.x86_64":
   		ensure    => installed,
   		require   => Class['yumrepo']
  	}