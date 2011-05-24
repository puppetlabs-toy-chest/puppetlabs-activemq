# Class: activemq::config
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq::config (
  $content = 'UNSET',
  $path    = '/etc/activemq/activemq.xml'
) {

  # JJM FIXME Validation!
  $path_real = $path

  # Since this is a template, it should come _after_ all variables are set for
  # this class.
  $content_real = $content ? {
    'UNSET' => template("${module_name}/activemq.xml.erb"),
    default => $content,
  }

  # Resource defaults
  File {
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package['activemq'],
  }

  # The configuration file itself.
  file { 'activemq.xml':
    ensure  => file,
    path    => $path_real,
    owner   => '0',
    group   => '0',
    content => $content_real,
  }

}
