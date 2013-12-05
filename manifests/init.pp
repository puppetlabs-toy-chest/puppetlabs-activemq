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
  $version       = 'present',
  $ensure        = 'running',
  $instance      = 'activemq',
  $brokername    = 'localhost',
  $webconsole    = true,
  $server_config = 'UNSET',
  $wrapper       = 'tanuki',
  $transport     = 'openwire',
  $admin_password = 'secret',
  $mcollective_username = 'mcollective',
  $mcollective_password = 'marionette',
  $webconsole_password = 'msgbusadminsecret',
  $webconsole_interface = 'all'
) {

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[._0-9a-zA-Z:-]+$')
  validate_bool($webconsole)

  $version_real = $version
  $ensure_real  = $ensure
  $webconsole_real = $webconsole

  # Since this is a template, it should come _after_ all variables are set for
  # this class.

  $transport_config = $transport ? {
    'stomp' => "${module_name}/activemq-stomp.xml.erb",
    'UNSET' => "${module_name}/activemq.xml.erb",
    default => "${module_name}/activemq.xml.erb",
  }
  
  $server_config_real = $server_config ? {
    'UNSET' => template($transport_config),
    default => $server_config,
  }

  case $wrapper {
    'integrated': {
      $wrapper_cmd = '/usr/lib/activemq/linux/wrapper'
      $wrapper_conf = '/etc/activemq/wrapper.conf'
    }
    'tanuki', default: {
      $wrapper_cmd = '/usr/sbin/tanukiwrapper'
      $wrapper_conf = '${ACTIVEMQ_HOME}/conf/activemq-wrapper.conf'      
    }
  }
  
  # Anchors for containing the implementation class
  anchor { 'activemq::begin':
    before => Class['activemq::packages'],
    notify => Class['activemq::service'],
  }

  class { 'activemq::packages':
    version => $version_real,
    notify  => Class['activemq::service'],
  }

  class { 'activemq::config':
    instance      => $instance,
    brokername    => $brokername,
    server_config => $server_config_real,
    require       => Class['activemq::packages'],
    notify        => Class['activemq::service'],
  }

  if $webconsole {
    class { 'activemq::webconsole':
      interface => $webconsole_interface,
      password => $webconsole_password,
      require  => Class['activemq::packages'],
      notify   => Class['activemq::service'],
    }
  }
  
  class { 'activemq::service':
    ensure => $ensure_real,
  }

  anchor { 'activemq::end':
    require => Class['activemq::service'],
  }

}

