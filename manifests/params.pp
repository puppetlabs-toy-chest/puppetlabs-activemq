# Class: activemq::params
#
#   ActiveMQ Parameters
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq::params {
  $version       = 'present'
  $ensure        = 'running'
  $instance      = 'activemq'
  $webconsole    = true
  $server_config = 'UNSET'

  # Default authentication entries
  $authentication = [ {
                      'username'  => 'admin',
                      'password'  => 'secret',
                      'groups'    => 'mcollective,admin,everyone'
                    }, {
                      'username'  => 'mcollective',
                      'password'  => 'marionette',
                      'groups'    => 'mcollective,everyone'
                    } ]

  #Default authorization entries
  $authorization = [ {
                      'queue' => '>',
                      'write' => 'admins',
                      'read'  => 'admins',
                      'admin' => 'admins'
                    }, {
                      'topic' => '>',
                      'write' => 'admins',
                      'read'  => 'admins',
                      'admin' => 'admins'
                    }, {
                      'topic' => 'mcollective.>',
                      'write' => 'mcollective',
                      'read'  => 'mcollective',
                      'admin' => 'mcollective'
                    }, {
                      'queue' => 'mcollective.>',
                      'write' => 'mcollective',
                      'read'  => 'mcollective',
                      'admin' => 'mcollective'
                    }, {
                      'topic' => 'ActiveMQ.Advisory.>',
                      'write' => 'everyone',
                      'read'  => 'everyone',
                      'admin' => 'everyone'
                    } ]
}
