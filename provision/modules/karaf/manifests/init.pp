class karaf {

	$version = "4.0.4"

	file { "/opt/rpm/apache-karaf-$version-0.x86_64.rpm":
 		source 		=> "puppet:///modules/karaf/apache-karaf-$version-0.x86_64.rpm",
		require		=> Class['directorystructure']
	}

	file { "/opt/apache-karaf/etc/org.ops4j.pax.url.mvn.cfg":
		source 		=> 'puppet:///modules/karaf/org.ops4j.pax.url.mvn.cfg',
		mode			=> 0644,
		owner			=> karaf,
		group			=> karaf,
		require		=> Package['apache-karaf']
	}

	package { 'apache-karaf':
		require 	=> File["/opt/rpm/apache-karaf-$version-0.x86_64.rpm"],
		provider 	=> 'rpm',
		source 		=> "/opt/rpm/apache-karaf-$version-0.x86_64.rpm"
	}

	service { 'apache-karaf':
		enable		=> true,
		ensure 		=> running,
		require		=> [Class['java'],
		                Package['apache-karaf'],
		                File["/opt/apache-karaf/etc/org.ops4j.pax.url.mvn.cfg"]]
	}

}
