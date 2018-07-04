# == Class: ntp::service
class nextcloud::service inherits nextcloud {
  service { 'httpd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package[$packages],
  }
  service { 'firewalld':
    ensure  => 'running',
    enable  => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
