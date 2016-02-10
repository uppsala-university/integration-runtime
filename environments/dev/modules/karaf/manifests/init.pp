class karaf {

	$major_minor = "3.0"
	$patch = "5"
	$version = "${major_minor}.${patch}"

	package { "apache-karaf-$version-0.x86_64":
    		ensure    => installed,
    		require   => Class['yumrepo']
  }

	file { "/opt/apache-karaf/etc/org.ops4j.pax.url.mvn.cfg":
		source 		=> "puppet:///modules/karaf/$major_minor.x/org.ops4j.pax.url.mvn.cfg",
		mode		=> "0644",
		owner		=> karaf,
		group		=> karaf,
		require		=> Package["apache-karaf-$version-0.x86_64"]
	}

	file { "/opt/apache-karaf/deploy/integration-plattform.xml":
		source 		=> "puppet:///modules/karaf/$major_minor.x/integration-plattform.xml",
		mode		=> "0644",
		owner		=> karaf,
		group		=> karaf,
		require		=> Package["apache-karaf-$version-0.x86_64"]
	}

	service { 'apache-karaf':
		enable		=> true,
		ensure 		=> running,
		require		=> [Package["apache-karaf-$version-0.x86_64"],
					File['/opt/apache-karaf/etc/org.ops4j.pax.url.mvn.cfg']]
	}

}
