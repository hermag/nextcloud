# Class: nextcloud
# ===========================
#
# Full description of class nextcloud here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'nextcloud':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class nextcloud (
  $dbuser                   = 'nextcloud',
  $dbpass                   = 'Nextcloud@123#',
  $dbrootpassword           = 'myT0pS3cretPa55Word#*',
  $dbhost                   = 'localhost',
  $dbname                   = 'nextcloud',
  $dbtype                   = 'mysql',
  $install_file             = 'nextcloud-13.0.4.tar.bz2',
  $install_url              = "https://download.nextcloud.com/server/releases/${install_file}",
  $fresh_install            = true,
  #$db_backup_path = '/vagrant/nextcloud.sql',
  $manage_db                = true,
  $manage_apache            = true,
  $datadir_default_location = false,
  $docroot                  = '/var/www/html',
  $certroot                 = '/etc/ssl/certs',
  $keyroot                  = '/etc/ssl/private',
  #$datadir                  = "${docroot}/nextcloud/data",
  $datadir                  = '/home/nextcloudDATA',
  $import_db                = false,
  )
  {
    include nextcloud::install
    include nextcloud::config
    include nextcloud::service
  }
