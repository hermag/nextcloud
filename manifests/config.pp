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
          $datadir:
              ensure => "directory",
              owner => "apache",
              group => "apache",
              mode => "0774",
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

    file {
           "$docroot/nextcloud/config/config.php":
              notify  => Service['httpd'],
              content => template('nextcloud/nextcloud/config.php.erb'),
              owner   => "apache",
              group   => "apache",
    }

    exec {
           'httpd_can_network_connect_db':
              command => "/usr/sbin/setsebool -P httpd_can_network_connect_db 1",
              provider => shell,
    }

    exec {
           'httpd_use_nfs':
              command => "/usr/sbin/setsebool -P httpd_use_nfs on",
              provider => shell,
              require => Exec[$httpd_can_network_connect_db],
    }

    exec {
           'httpd_use_cifs':
              command => "/usr/sbin/setsebool -P httpd_use_cifs on",
              provider => shell,
              require => Exec[$httpd_use_nfs],
    }

    exec {
           'httpd_can_connect_ldap':
              command => "/usr/sbin/setsebool -P httpd_can_connect_ldap on",
              provider => shell,
              require => Exec[$httpd_use_cifs],
    }

    exec {
           'httpd_can_sendmail':
              command => "/usr/sbin/setsebool -P httpd_can_sendmail on",
              provider => shell,
              require => Exec[$httpd_can_connect_ldap],
    }

    exec {
           'httpd_can_network_connect':
              command => "/usr/sbin/setsebool -P httpd_can_network_connect on",
              provider => shell,
              require => Exec[$httpd_can_sendmail],
    }

    exec {
           'httpd_can_network_connect':
              command => "/usr/sbin/setsebool -P httpd_can_network_connect on",
              provider => shell,
              require => Exec[$httpd_can_sendmail],
    }

    exec {
           'allow_data_dir_root':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$datadirroot(/.*)?'",
              provider => shell,
              require => Exec[$httpd_can_network_connect],
    }
    exec {
           'allow_data_dir':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$datadir(/.*)?'",
              provider => shell,
              require => Exec[$allow_data_dir_root],
    }
    exec {
           'allow_config':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$docroot/nextcloud/config(/.*)?'",
              provider => shell,
              require => Exec[$allow_data_dir],
    }
    exec {
           'allow_apps':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$docroot/nextcloud/apps(/.*)?'",
              provider => shell,
              require => Exec[$allow_config],
    }
    exec {
           'allow_3rdparty':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$docroot/nextcloud/3rdparty(/.*)?'",
              provider => shell,
              require => Exec[$allow_apps],
    }
    exec {
           'allow_htaccess':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$docroot/nextcloud/.htaccess'",
              provider => shell,
              require => Exec[$allow_3rdparty],
    }
    exec {
           'allow_user_ini':
              command => "/usr/sbin/semanage fcontext -a -t httpd_sys_rw_content_t '$docroot/nextcloud/.user.ini'",
              provider => shell,
              notify  => Service['httpd'],
              require => Exec[$allow_htaccess],
    }

    exec {
           'refresh_nextcloud':
              command => "/usr/sbin/restorecon -Rv '$datadirroot(/.*)?'",
              provider => shell,
              notify  => Service['httpd'],
              require => Exec[$allow_htaccess],
    }

    exec {
           'refresh_datadir_root':
              command => "/usr/sbin/restorecon -Rv '$datadir(/.*)?'",
              provider => shell,
              notify  => Service['httpd'],
              require => Exec[$allow_htaccess],
    }

    exec {
           'refresh_datadir_root':
              command => "/usr/sbin/restorecon -Rv '$docroot/nextcloud(/.*)?'",
              provider => shell,
              notify  => Service['httpd'],
              require => Exec[$allow_htaccess],
    }
}
