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
  $mq_admin_username,
  $mq_admin_password,
  $install_from_source     = $activemq::params::install_from_source,
  $home                    = $activemq::params::home,
  $user                    = $activemq::params::user,
  $group                   = $activemq::params::group,
  $version                 = $activemq::params::version,
  $package                 = $activemq::params::package,
  $ensure                  = $activemq::params::ensure,
  $instance                = $activemq::params::instance,
  $webconsole              = $activemq::params::webconsole,
  $server_config           = $activemq::params::server_config,
  $server_config_show_diff = $activemq::params::server_config,
  $mq_broker_name          = $activemq::params::mq_broker_name,
  $mq_admin_username       = $activemq::params::mq_admin_username,
  $mq_admin_password       = $activemq::params::mq_admin_password,
  $mq_cluster_username     = $activemq::params::mq_cluster_username,
  $mq_cluster_password     = $activemq::params::mq_cluster_password,
  $mq_cluster_brokers      = $activemq::params::mq_cluster_brokers,
) inherits activemq::params {

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[~+._0-9a-zA-Z:-]+$')
  validate_bool($webconsole)

  if size($mq_cluster_brokers) > 0 and $mq_cluster_username == 'amq' {
    warning '$mq_cluster_username is set to the default value.  This should be changed.'
  }

  if size($mq_cluster_brokers) > 0 and $mq_cluster_password == 'secret' {
    warning '$mq_cluster_password is set to the default value.  This should be changed.'
  }

  if $home != $activemq::params::home and !$install_from_source {
    fail "home must not be set when install_from_source=false(default)"
  }

  $config_path = $install_from_source ? {
    true    => "${home}/conf/activemq.xml",
    default => '/etc/activemq/activemq.xml',
  }

  # Since this is a template, it should come _after_ all variables are set for
  # this class.
  $server_config_content = $server_config ? {
    'UNSET' => template("${module_name}/activemq.xml.erb"),
    default => $server_config,
  }

  # Anchors for containing the implementation class
  anchor { 'activemq::begin':
    before => Class['activemq::packages'],
    notify => Class['activemq::service'],
  }

  class { 'activemq::packages':}
  ~>
  class { 'activemq::service': }

  class { 'activemq::config':
    require                 => Class['activemq::packages'],
    notify                  => Class['activemq::service'],
  }

  anchor { 'activemq::end':
    require => Class['activemq::service'],
  }

}

