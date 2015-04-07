# Private
class activemq::params {
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
  $mq_transports           = []
  $mq_truststore           = 'puppet:///modules/activemq/truststore.jks'
  $mq_keystore             = 'puppet:///modules/activemq/keystore.jks'
  $mq_truststore_password  = 'secret'
  $mq_keystore_password    = 'secret'
  $mq_users                = [{ "name" => "mcollective", "password" => "marionette", "groups" => "mcollective" }]
  $mq_queues               = [{ "path" => "mcollective.>", "writegroups" => "mcollective", "readgroups" => "mcollective", "admingroups" => "mcollective" }]
  $mq_topics               = [{ "path" => "mcollective.>", "writegroups" => "mcollective", "readgroups" => "mcollective", "admingroups" => "mcollective" }]
  $mq_memory_usage         = "20 mb"
  $mq_store_usage_limit    = "1 gb"
  $mq_store_usage_name     = "foo"
  $mq_temp_usage           = "100 mb"

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
