class activemq {

  $version = "5.13.0"

  package { "apache-activemq-$version-0.x86_64":
    ensure    => installed,
    require   => Class['yumrepo']
  }

  # default configuration for "activemq" instance, not used
  file { "/etc/default/activemq":
		source 		=> 'puppet:///modules/activemq/activemq',
		mode			=> "0644"
	}

  # don't start default broker
  service { 'apache-activemq':
    enable    => false,
  }

  # data dir for configured brokers
  file { "/var/lib/activemq":
    ensure    => directory,
    owner     => "activemq",
    group     => "activemq",
    mode      => "0644",
    require   => Package["apache-activemq-$version-0.x86_64"]
  }

  # config 1st broker: integration
  file { "/etc/default/activemq-instance-integration":
		source 		=> 'puppet:///modules/activemq/activemq-instance-integration.conf',
		mode			=> "0644"
	}

  # data dir for 1st broker: integration
  file { "/var/lib/activemq/activemq-instance-integration":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    force     => true,
    owner     => "activemq",
    group     => "activemq",
    mode      => "0644",
    source    => "puppet:///modules/activemq/activemq-instance-integration",
    require   => [ Package["apache-activemq-$version-0.x86_64"],
                    File['/var/lib/activemq']]
  }

  # 1st broker as running system service
  service { 'activemq-instance-integration':
    enable		=> true,
  	ensure 		=> running,
  	require		=> [Package["apache-activemq-$version-0.x86_64"],
                    File['/etc/init.d/activemq-instance-integration'],
                    File['/var/lib/activemq/activemq-instance-integration'],
                    File['/etc/default/activemq-instance-integration']]
  }

  # service symlink for 1st broker: integration
  file { '/etc/init.d/activemq-instance-integration':
    ensure    => 'link',
    target    => '/opt/apache-activemq/bin/activemq',
    require   => Package["apache-activemq-$version-0.x86_64"]
  }

  # config 2nd broker: integration-dlq
  file { "/etc/default/activemq-instance-integration-dlq":
		source 		=> 'puppet:///modules/activemq/activemq-instance-integration-dlq.conf',
		mode			=> "0644"
	}

  # data dir for 2nd broker: integration-dlq
  file { "/var/lib/activemq/activemq-instance-integration-dlq":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    force     => true,
    owner     => "activemq",
    group     => "activemq",
    mode      => "0644",
    source    => "puppet:///modules/activemq/activemq-instance-integration-dlq",
    require   => [Package["apache-activemq-$version-0.x86_64"],
                  File['/var/lib/activemq']]
  }

  # service symlink for 2nd broker: integration-dlq
  file { '/etc/init.d/activemq-instance-integration-dlq':
    ensure    => 'link',
    target    => '/opt/apache-activemq/bin/activemq',
    require   => Package["apache-activemq-$version-0.x86_64"]
  }

  # 2nd broker as running system service
  service { 'activemq-instance-integration-dlq':
  		enable		=> true,
  		ensure 		=> running,
  		require		=> [Package["apache-activemq-$version-0.x86_64"],
                    File['/etc/init.d/activemq-instance-integration-dlq'],
                    File['/var/lib/activemq/activemq-instance-integration-dlq'],
                    File['/etc/default/activemq-instance-integration-dlq']]
  }

}
