class nextcloud::install::redhat {

  package { 'epel-release':
    ensure => "installed",
  }

  exec { 'remi-release-7-repo':
    command => '/usr/bin/rpm -Uhv http://rpms.remirepo.net/enterprise/remi-release-7.rpm',
    require => Package['epel-release'],
  }

  package { 'remi-release-7':
    package => "installed",
    require => Exec['remi-release-7-repo'],
  }

  package { 'epel-release-latest-7':
    ensure => "installed",
    require => Exec['remi-release-7'],
  }

  $prerequisites = ['httpd','mariadb-server','php','php-mysql','php-dom','php-pecl-apcu','php-opcache','php-mbstring','php-gd','php-pdo','php-json','php-xml','php-zip','php-curl','php-mcrypt','php-pear','php-ldap','php-smbclient','nfs-utils','samba-client','samba-common','mod_ssl','setroubleshoot-server','bzip2']
  package { $prerequisites:
    ensure => "installed",
    require => Exec['epel-release-latest-7'],
  }
  
  package { 'mariadb-server':
    ensure => "installed",
    require => Package['epel-release'],
  }
}
