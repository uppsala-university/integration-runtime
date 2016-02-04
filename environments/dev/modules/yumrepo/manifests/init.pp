class yumrepo {

  exec { "Initialize local yum repository":
    command => "/usr/bin/createrepo /opt/yumrepo",
    require => [Package["createrepo"],
      File['/opt/yumrepo/apache-activemq-5.13.0-0.x86_64.rpm'],
      File['/opt/yumrepo/apache-karaf-4.0.4-0.x86_64.rpm']]
    }

  package { 'createrepo':
    ensure  => installed
  }

  file { '/etc/yum.repos.d/local.repo':
    source  => "puppet:///modules/yumrepo/local.repo"
  }

  file { '/opt/yumrepo':
    ensure  => directory
  }

  file { "/opt/yumrepo/apache-activemq-5.13.0-0.x86_64.rpm":
  	source   => "puppet:///modules/yumrepo/apache-activemq-5.13.0-0.x86_64.rpm",
  	require  => File['/opt/yumrepo']
  }

  file { "/opt/yumrepo/apache-karaf-4.0.4-0.x86_64.rpm":
  	source 		=> "puppet:///modules/yumrepo/apache-karaf-4.0.4-0.x86_64.rpm",
  	require		=> File['/opt/yumrepo']
  }

}
