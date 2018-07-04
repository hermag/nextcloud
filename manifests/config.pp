include '::mysql::server'
include firewalld

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
           "$keyroot/apache-selfsigned.key":
              content => template('nextcloud/apache/apache-selfsigned.key.erb'),
              owner   => "root",
              group   => "root",
              mode    => "644",
              require => File["$keyroot"],
    }

    file {
           "$certroot/apache-selfsigned.crt":
              content => template('nextcloud/apache/apache-selfsigned.crt.erb'),
              owner   => "root",
              group   => "root",
              mode    => "644",
              require => File["$keyroot/apache-selfsigned.key"],
    }

    file {
           "$apacheroot/ssl.conf":
              notify  => Service['httpd'],
              content => template('nextcloud/apache/ssl.conf.erb'),
              owner   => "root",
              group   => "root",
              mode    => "644",
              require => File["$certroot/apache-selfsigned.crt"],
    }

    file {
           "$apacheroot/non-ssl.conf":
              notify  => Service['httpd'],
              content => template('nextcloud/apache/non-ssl.conf.erb'),
              owner   => "root",
              group   => "root",
              mode    => "644",
              require => File["$apacheroot/ssl.conf"],
    }

    firewalld_port {
           "Open port 443 in the public Zone":
              notify  => Service['firewalld'],
              ensure   => 'present',
              zone     => 'public',
              port     => '443',
              protocol => 'tcp',
    }

}
