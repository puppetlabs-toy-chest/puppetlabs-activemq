node default {
  notify { 'alpha': }
  ->
  class  { 'java':
    distribution => 'jdk',
    version      => 'latest',
  }
  ->
  class  { 'activemq':
    webconsole       => true,
    stomp_user       => 'mcollective',
    stomp_passwd     => 'marionette',
    stomp_admin      => 'admin',
    stomp_adminpw    => 'secret',
    activemq_mem_min => '10M',
    activemq_mem_max => '10M',
  }
  ->
  notify { 'omega': }
}
