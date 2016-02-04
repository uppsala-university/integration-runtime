class karaf {

	$version = "4.0.4"

	package { "apache-karaf-$version-0.x86_64":
    ensure    => installed,
    require   => Class['yumrepo']
  }

	file { "/opt/apache-karaf/etc/org.ops4j.pax.url.mvn.cfg":
		source 		=> 'puppet:///modules/karaf/org.ops4j.pax.url.mvn.cfg',
		mode			=> "0644",
		owner			=> karaf,
		group			=> karaf,
		require		=> Package["apache-karaf-$version-0.x86_64"]
	}

	service { 'apache-karaf':
		enable		=> true,
		ensure 		=> running,
		require		=> [Package["apache-karaf-$version-0.x86_64"],
									File['/opt/apache-karaf/etc/org.ops4j.pax.url.mvn.cfg']]
	}

}
