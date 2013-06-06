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
# To change ActiveMQ memory and default user/password from the defaults:
#
# node default {
#   class { 'activemq':
#     activemq_mem_min => '2G',
#     activemq_mem_max => '3G',
#     stomp_user       => 'stompuser',
#     stomp_passwd     => 'stomppass',
#     stomp_admin      => 'adminuser',
#     stomp_adminpw    => 'adminpasswd',
#   }
# }
#
class activemq(
  $version                 = 'present',
  $ensure                  = 'running',
  $webconsole              = true,
  $server_config           = 'UNSET',
  $activemq_binary_version = 'apache-activemq-5.7.0',
  $activemq_mem_min        = '1G',
  $activemq_mem_max        = '1G',
  $stomp_user              = 'mcollective',
  $stomp_passwd            = 'marionette',
  $stomp_admin             = 'admin',
  $stomp_adminpw           = 'secret',
) {

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[._0-9a-zA-Z:-]+$')
  validate_bool($webconsole)

  $version_real = $version
  $ensure_real  = $ensure
  $webconsole_real = $webconsole
  $activemq_binary_version_real = $activemq_binary_version
  $activemq_mem_min_real = $activemq_mem_min
  $activemq_mem_max_real = $activemq_mem_max
  $stomp_user_real = $stomp_user
  $stomp_passwd_real = $stomp_passwd
  $stomp_admin_real = $stomp_admin
  $stomp_adminpw_real = $stomp_adminpw

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
    version                 => $version_real,
    activemq_binary_version => $activemq_binary_version_real,
    activemq_mem_min        => $activemq_mem_min_real,
    activemq_mem_max        => $activemq_mem_max_real,
    notify                  => Class['activemq::service'],
  }

  class { 'activemq::config':
    server_config    => $server_config_real,
    stomp_user       => $stomp_user_real,
    stomp_passwd     => $stomp_passwd_real,
    stomp_admin      => $stomp_admin_real,
    stomp_adminpw    => $stomp_adminpw_real,
    require          => Class['activemq::packages'],
    notify           => Class['activemq::service'],
  }

  class { 'activemq::service':
    ensure => $ensure_real,
  }

  anchor { 'activemq::end':
    require => Class['activemq::service'],
  }

}

