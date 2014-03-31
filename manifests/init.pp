# Class: activemq
#
# This module manages the ActiveMQ messaging middleware.
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   Class['java']
#
# Sample Usage:
#
# node default {
#   class { 'activemq': }
# }
#
# To supply your own configuration file:
#
# node default {
#   class { 'activemq':
#     server_config => template('site/activemq.xml.erb'),
#   }
# }
#
class activemq(
  $version                 = 'present',
<<<<<<< HEAD
  $package                 = 'activemq',
  $ensure                  = 'running',
  $instance                = 'activemq',
  $webconsole              = true,
  $server_config           = 'UNSET'
  $mq_admin_username       = 'admin',
  $mq_admin_password       = 'admin',
  $mq_cluster_username     = 'amq',
  $mq_cluster_password     = 'secret',
  $mq_cluster_brokers      = [],
=======
  $ensure                  = 'running',
  $instance                = 'activemq',
  $webconsole              = true,
  $mq_admin_username       = 'admin',
  $mq_admin_password       = 'admin',
  $mq_mcollective_username = 'mcollective',
  $mq_mcollective_password = 'marionette',
  $mq_cluster_username     = 'amq',
  $mq_cluster_password     = 'secret',
  $mq_cluster_brokers      = [],
  $server_config           = 'UNSET'
>>>>>>> 1f3644c4acb43680a86f35e9aafc2b4fb5d42b3d
) {

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[~+._0-9a-zA-Z:-]+$')
  validate_bool($webconsole)
  validate_string($mq_admin_username)
  validate_string($mq_admin_password)
  validate_string($mq_mcollective_username)
  validate_string($mq_mcollective_password)
  validate_string($mq_cluster_username)
  validate_string($mq_cluster_password)
  validate_array($mq_cluster_brokers)

<<<<<<< HEAD
  $package_real = $package
  $version_real = $version
  $ensure_real  = $ensure
  $webconsole_real = $webconsole
  $mq_admin_username_real       = $mq_admin_username
  $mq_admin_password_real       = $mq_admin_password
=======
  $version_real                 = $version
  $ensure_real                  = $ensure
  $webconsole_real              = $webconsole
  $mq_admin_username_real       = $mq_admin_username
  $mq_admin_password_real       = $mq_admin_password
  $mq_mcollective_username_real = $mq_mcollective_username
  $mq_mcollective_password_real = $mq_mcollective_password
>>>>>>> 1f3644c4acb43680a86f35e9aafc2b4fb5d42b3d
  $mq_cluster_username_real     = $mq_cluster_username
  $mq_cluster_password_real     = $mq_cluster_password
  $mq_cluster_brokers_real      = $mq_cluster_brokers

  if $mq_admin_username_real == 'admin' {
    warning '$mq_admin_username is set to the default value.  This should be changed.'
  }

  if $mq_admin_password_real == 'admin' {
    warning '$mq_admin_password is set to the default value.  This should be changed.'
  }

<<<<<<< HEAD
=======
  if $mq_mcollective_username_real == 'mcollective' {
    warning '$mq_mcollective_username is set to the default value.  This should be changed.'
  }

  if $mq_mcollective_password_real == 'marionette' {
    warning '$mq_mcollective_password is set to the default value.  This should be changed.'
  }

>>>>>>> 1f3644c4acb43680a86f35e9aafc2b4fb5d42b3d
  if size($mq_cluster_brokers_real) > 0 and $mq_cluster_username_real == 'amq' {
    warning '$mq_cluster_username is set to the default value.  This should be changed.'
  }

  if size($mq_cluster_brokers_real) > 0 and $mq_cluster_password_real == 'secret' {
    warning '$mq_cluster_password is set to the default value.  This should be changed.'
  }

  # Since this is a template, it should come _after_ all variables are set for
  # this class.
  $server_config_real = $server_config ? {
    'UNSET' => template("${module_name}/activemq.xml.erb"),
    default => $server_config,
  }

  # Anchors for containing the implementation class
  anchor { 'activemq::begin':
    before => Class['activemq::packages'],
    notify => Class['activemq::service'],
  }

  class { 'activemq::packages':
    version => $version_real,
    package => $package_real,
    notify  => Class['activemq::service'],
  }

  class { 'activemq::config':
    instance      => $instance,
    package       => $package_real,
    server_config => $server_config_real,
    require       => Class['activemq::packages'],
    notify        => Class['activemq::service'],
  }

  class { 'activemq::service':
    ensure => $ensure_real,
  }

  anchor { 'activemq::end':
    require => Class['activemq::service'],
  }

}

