class nextcloud::config inherits nextcloud {
    if $::nextcloud::manage_db {
       class { 'mysql::server':
          root_password           => $dbrootpassword,
          remove_default_accounts => true,
       }
}

#{
#  $user = "nxtuser"
#  $password = "Nextcloud@123#"
#  $mysql_password = "myT0pS3cretPa55worD"
#  $dbname = "nextcloud_db"
#  define mysqldb( $user, $password ) {
#    exec { $dbname:
#      unless => "/usr/bin/mysql -u${user} -p${password} ${dbname}",
#      command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database ${dbname}; grant all on ${dbname}.* to ${user}@localhost identified by '$password';\"",
#      require => Service["mariadb"],
#    }
#  }
#}
