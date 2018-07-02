class nextcloud::install::redhat {

  package { 'epel-release':
    ensure => "installed",
  }

  package { 'webtatic-release':
    provider => "rpm",
    ensure => "installed",
    source => "https://mirror.webtatic.com/yum/el7/webtatic-release.rpm",
    require => Package['epel-release'],
  }

  #exec { 'remi-release-7-repo':
  #  command => '/usr/bin/rpm -Uhv http://rpms.remirepo.net/enterprise/remi-release-7.rpm',
  #  require => Package['epel-release'],
  #}

  #package { 'remi-release-7':
  #  package => "installed",
  #  require => Exec['remi-release-7-repo'],
  #}

  #package { 'epel-release-latest-7':
  #  ensure => "installed",
  #  require => Exec['remi-release-7'],
  #}

  #$prerequisites = ['httpd',
  #                   'mariadb-server',
  #                   'php',
  #                   'php-mysql',
  #                   'php-dom',
  #                   'php-pecl-apcu',
  #                   'php-opcache',
  #                   'php-mbstring',
  #                   'php-gd',
  #                   'php-pdo',
  #                   'php-json',
  #                   'php-xml',
  #                   'php-zip',
  #                   'php-curl',
  #                   'php-mcrypt',
  #                   'php-pear',
  #                   'php-ldap',
  #                   'php-smbclient',
  #                   'nfs-utils',
  #                   'samba-client',
  #                   'samba-common',
  #                   'mod_ssl',
  #                   'setroubleshoot-server',
  #                   'bzip2']
  $prerequisites = ['httpd',
                    'mariadb-server',
                    'mod_ssl',
                    'setroubleshoot-server',
                    'php71w',
                    'php71w-dom',
                    'php71w-mysql',
                    'php71w-mbstring',
                    'php71w-pecl-apcu',
                    'php71w-opcache',
                    'php71w-gd',
                    'php71w-pdo',
                    'php71w-json',
                    'php71w-xml',
                    'php71w-zip',
                    'php71w-curl',
                    'php71w-mcrypt',
                    'php71w-pear',
                    'php71w-ldap',
                    'bzip2',
                    'wget']
  package { $prerequisites:
    ensure => "installed",
    require => Package['webtatic-release'],
  }
  
  #package { 'mariadb-server':
  #  ensure => "installed",
  #  require => Package['epel-release'],
  #}





}
