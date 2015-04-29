define mariadb::user ( $password, $database, $host="localhost", $admin="root", $adminPwd="" ){
    exec { "MySQL: create user $name":
      command => "/usr/bin/mysql -u$admin -p$adminPwd --execute=\"GRANT ALL PRIVILEGES ON ${database}.* TO '${name}'@'${host}' IDENTIFIED BY '${password}' WITH GRANT OPTION;\";",
      unless => "/usr/bin/mysql -u$admin -p$adminPwd -e 'select * from mysql.users|grep $name",
      require => Service ['mysql']
    }
}
