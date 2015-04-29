 define mariadb::database ( $ensure, $sql = NONE, $admin="root", $adminPwd="" ) {
    case $ensure {
      present: {
        exec { "MySQL: create database $name":
          command => "/usr/bin/mysql -u$admin -p$adminPwd --execute=\"CREATE DATABASE ${name}\";",
          unless => "/usr/bin/mysql -u$admin -p$adminPwd --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
		  require => Service ['mysql']
        }
      }

      importdb: {
        exec { "MySQL: create and import database $name from $sql":
          command => "/usr/bin/mysql -u$admin -p$adminPwd --execute=\"CREATE DATABASE ${name}\";
                      /usr/bin/mysql  -u$admin -p$adminPwd ${name} < ${sql}",
          unless => "/usr/bin/mysql  - -u$admin -p$adminPwd -execute=\"SHOW DATABASES;\" | grep -x '${name}'",
		  require => Service ['mysql']
        }
      }

      absent: {
        exec { "MySQL: drop database $name ":
          command => "/usr/bin/mysql  -u$admin -p$adminPwd --execute=\"DROP DATABASE ${name}\";",
          onlyif => "/usr/bin/mysql -u$admin -p$adminPwd --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
		  require => Service ['mysql']
        }
      }

      default: {
        fail "Invalid 'ensure' value '$ensure' for mariadb::database"
      }
    }
}

