node default {
  notify { 'alpha': }
  ->
  class  { 'java':
    distribution => 'jdk',
    version      => 'latest',
  }
  ->
  class  { 'activemq':
    webconsole => false,
  }
  ->
  notify { 'omega': }
}
