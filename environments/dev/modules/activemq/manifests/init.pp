class activemq {

  $version = "5.13.0"

  file { "/etc/default/activemq":
		source 		=> 'puppet:///modules/activemq/activemq',
		mode			=> "0644"
	}

  package { "apache-activemq-$version-0.x86_64":
    ensure    => installed,
    require   => Class['yumrepo']
  }

  service { 'apache-activemq':
		enable		=> true,
		ensure 		=> running,
		require		=> [Package["apache-activemq-$version-0.x86_64"],
                  File['/etc/default/activemq']]
	}


  # From http://activemq.apache.org/unix-shell-script.html#UnixShellScript-Version5.11.0andhigher
  #
  # Hint: If you are using multiple instances you can only add the main instance to the automatic
  # system start using ("update-rc.d" or "chkconfig") because the LSB Header "Provides" needs to
  # be uniq.
}
