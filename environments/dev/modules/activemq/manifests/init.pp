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

  # We do not use the default broker service.
  #service { 'apache-activemq':
	#	enable		=> true,
	#	ensure 		=> running,
	#	require		=> [Package["apache-activemq-$version-0.x86_64"],
  #                File['/etc/default/activemq']]
	#}

  # From http://activemq.apache.org/unix-shell-script.html#UnixShellScript-Version5.11.0andhigher
  #
  # Hint: If you are using multiple instances you can only add the main instance to the automatic
  # system start using ("update-rc.d" or "chkconfig") because the LSB Header "Provides" needs to
  # be uniq.
