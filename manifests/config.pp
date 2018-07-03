include '::mysql::server'

 class nextcloud::config inherits nextcloud {
    if $::nextcloud::manage_db {
        class { '::mysql::server':
                   root_password => $dbrootpassword,
                   remove_default_accounts => true,
                   #override_options => $override_options
              }

        mysql::db { $dbname:
              user     => $dbuser,
              password => $dbpass,
              host     => 'localhost',
              grant    => ['ALL'],
             }
    }
}
