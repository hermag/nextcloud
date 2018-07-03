# == Class: nextcloud::install
class nextcloud::install inherits nextcloud {
  case $osfamily {
    'RedHat': { include nextcloud::install::redhat }
     default: { warning("${osfamily} is not supported") }
  }
}
