include '::archive'

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

  $prerequisites = ['httpd',
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

  exec { 'GetNextCloud':
    command => "/usr/bin/wget $nextcloud::install_url -O /tmp/nextcloud.tar.bz2",
    unless  => "/usr/bin/ls -laF $nextcloud::docroot | grep nextcloud",
    provider => shell,
    require => Package[$prerequisites],
  }

  exec { 'ExtractNextCloud':
    command => "/usr/bin/tar -jxvf /tmp/nextcloud.tar.bz2 -C $nextcloud::docroot/",
    unless  => "/usr/bin/ls -laF $nextcloud::docroot | grep nextcloud",
    provider => shell,
    require => Exec["GetNextCloud"],
  }

}
