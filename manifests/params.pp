# Private
class activemq::params {
  $version                 = 'present'
  $package                 = 'activemq'
  $ensure                  = 'running'
  $instance                = 'activemq'
  $server_config           = 'UNSET'
  $server_config_show_diff = 'UNSET'
  $service_enable          = true
  $mq_broker_name          = $::fqdn
  $mq_admin_username       = 'admin'
  $mq_admin_password       = 'admin'
  $mq_cluster_username     = 'amq'
  $mq_cluster_password     = 'secret'
  $mq_cluster_brokers      = []

  # Debian does not include the webconsole
  case $::osfamily {
    'Debian': {
      $webconsole = false
    }
    default: {
      $webconsole = true
    }
  }
}
