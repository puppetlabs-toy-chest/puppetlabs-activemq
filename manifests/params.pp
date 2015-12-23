# Private
class activemq::params {
  $install_from_binary     = false
  $home                    = '/opt/apache-activemq'
  $log_path                = '/var/log/activemq'
  $version                 = 'present'
  $package                 = 'activemq'
  $ensure                  = 'running'
  $instance                = 'activemq'
  $server_config           = 'UNSET'
  $server_config_show_diff = 'UNSET'
  $mq_broker_name          = $::fqdn
  $mq_admin_username       = 'admin'
  $mq_admin_password       = 'admin'
  $mq_cluster_username     = 'amq'
  $mq_cluster_password     = 'secret'
  $mq_cluster_brokers      = []

  # Debian does not include the webconsole
  case $::osfamily {
    'Debian': {
      $webconsole = $install_from_binary
    }
    default: {
      $webconsole = true
    }
  }
  # OpenBSD system user/group differs
  case $::osfamily {
    'OpenBSD': {
      $system_user  = '_activemq'
      $system_group = '_activemq'
    }
    default: {
      $system_user  = 'activemq'
      $system_group = 'activemq'
    }
  }
}
