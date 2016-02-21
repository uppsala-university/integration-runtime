class yumrepo {

  exec { "Initialize local yum repository":
    command => "/usr/bin/createrepo /opt/yumrepo",
    require => [Package["createrepo"], File['/opt/yumrepo']]
  }

  package { 'createrepo':
    ensure  => installed
  }

  file { '/etc/yum.repos.d/local.repo':
    source  => "puppet:///modules/yumrepo/local.repo"
  }

  file { "/opt/yumrepo":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    force     => true,
    owner     => "root",
    group     => "root",
    mode      => "0644",
    source    => "puppet:///modules/yumrepo/yumrepo"
  }

}
