include '::mysql::server'

class { '::mysql::server':
      root_password => $dbrootpassword,
      remove_default_accounts => true,
      override_options => $override_options
}

class nextcloud::config inherits nextcloud {
    # if $::nextcloud::manage_db {
    #    class { 'mysql::server':
    #       root_password           => $dbrootpassword,
    #       remove_default_accounts => true,
    #    }
    # }

    # $mysql_password = "myT0pS3cretPa55worD"
    # exec { "set-mariadb-password":
    #     unless => "mysqladmin -uroot -p$mysql_password status",
    #     path => ["/bin", "/usr/bin"],
    #     command => "mysqladmin -uroot password $mysql_password",
    #     require => Service["mariadb"],
    # }

    $user = "nxtuser"
    $password = "Nextcloud@123#"
    $dbname = "nextcloud_db"
    exec { $dbname:
        unless => "/usr/bin/mysql -u${user} -p${password} ${dbname}",
        command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database ${dbname}; grant all on ${dbname}.* to ${user}@localhost identified by '$password';\"",
        require => Exec["set-mariadb-password"],
    }
}
