# == Class: ntp::service
class nextcloud::service inherits nextcloud {

  service { 'httpd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package[$packages],
  }

  service { 'mariadb':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package['mariadb-server'],
  }

  $mysql_password = "myT0pS3cretPa55worD"
  exec { "set-mariadb-password":
    unless => "mysqladmin -uroot -p$mysql_password status",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password $mysql_password",
    require => Service["mariadb"],
  }

  $user = "nxtuser"
  $password = "Nextcloud@123#"
  $dbname = "nextcloud_db"
  exec { $dbname:
      unless => "/usr/bin/mysql -u${user} -p${password} ${dbname}",
      command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database ${dbname}; grant all on ${dbname}.* to ${user}@localhost identified by '$password';\"",
      require => Exec["set-mariadb-password"],
  }
}
