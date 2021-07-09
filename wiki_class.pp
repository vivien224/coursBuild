class development {
  package { 
    'vim':
      ensure =>  installed;
    'make':
      ensure =>  installed;
    'gcc':
      ensure =>  installed;
  }
}

class hosting {
  package { 
    'apache2':
      ensure =>  installed;
    'php7.3':
      ensure =>  installed;
  }
}


node 'control' { 
  include development
}

node 'server0' {
  include hosting
}

node 'server1' {
  include hosting
}
