include '::mysql::server'

 class nextcloud::config inherits nextcloud {
    if $::nextcloud::manage_db {
        class {
               '::mysql::server':
                   root_password => $dbrootpassword,
                   remove_default_accounts => true,
                   #override_options => $override_options
              }

        mysql::db {
                   $dbname:
                      user     => $dbuser,
                      password => $dbpass,
                      host     => 'localhost',
                      grant    => ['ALL'],
                     }
    }

    file {
          $keyroot:
              ensure => "directory",
              owner => "root",
              group => "root",
              mode => "0700",
    }

    file {
           "$keyroot/apache-selfsigned.crt.erb":
              content => template('nextcloud/apache-selfsigned.crt.erb'),
              owner   => "root",
              group   => "root",
              mode    => "644",
    }

    file {
           "$certroot/apache-selfsigned.crt.erb":
              content => template('nextcloud/apache-selfsigned.key.erb'),
              owner   => "root",
              group   => "root",
              mode    => "644",
    }

}
