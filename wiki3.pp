package {
  'apache2':
    ensure => 'present';

  'php7.3':
    ensure => 'present';
}

file {
  'dl':
    ensure         => 'present',
    source         => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
    path           => '/usr/src/dokuwiki.tgz',
    checksum_value => '8867b6a5d71ecb5203402fe5e8fa18c9';
    
  'rename-dokuwiki':
    ensure  => 'present',
    source  => '/usr/src/dokuwiki-2020-07-29',
    path    => '/usr/src/dokuwiki',
    require => Exec['unzip'];
    
  'create-dir-recettes':
    ensure  => 'present',
    path    => '/var/www/recettes_wiki/',
    source  => '/usr/src/dokuwiki',
    ignore  => '/var/www/',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    require => File['rename'];
    
  'create-dir-politique':
    ensure  => 'present',
    path    => '/var/www/politique_wiki/',
    source  => '/usr/src/dokuwiki',
    ignore  => '/var/www/',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    require => File['rename'];
    
  'config-recettes':
    ensure  => 'present',
    source  => '/etc/apache2/sites-available/000-default.conf',
    path    => '/etc/apache2/sites-available/recettes.conf',
    require => Package['apache2'];
    
  'config-politique':
    ensure  => 'present',
    source  => '/etc/apache2/sites-available/000-default.conf',
    path    => '/etc/apache2/sites-available/politique.conf',
    require => Package['apache2'];
    
}

exec {
  'unzip':
    path    => ['/usr/bin/'],
    command => 'tar -xavf dokuwiki.tgz',
    cwd     => '/usr/src',
    creates => 'usr/src/dokuwiki-2020-07-29',
    require => File['dl'];
    
  'recettes.conf':
    path    => '/usr/bin/',
    command => "sed -e 's%#ServerName www.example.com%ServerName www.recettes.com%' -e 's%html%recettes%' /etc/apache2/sites-available/000-default.conf > /etc/apache2/sites-available/recettes.conf",
    require => File['config-recettes'];
    
  'politique.conf':
    path    => '/usr/bin',
    command => "sed -e 's%#ServerName www.example.com%ServerName www.politique.com%' -e 's%html%politique%' /etc/apache2/sites-available/000-default.conf > /etc/apache2/sites-available/politique.conf",
    require => File['config-politique'];
    
  'enable-virtualhosts':
    path    => ['/usr/bin','/bin'],
    cwd     => '/etc/apache2/sites-available/',
    command => "a2ensite recettes.conf && a2ensite politique.conf",
    require => [Exec['recettes.conf'], Exec['politique.conf']],
    notify  => Service['reload-apache2'];

}


service {
  'reload-apache2':
    ensure => 'running',
    name   => 'apache2';
}

host {
  'recettes.wiki':
    ip => '127.0.0.1';
  'politique.wiki':
    ip => '127.0.0.1';
}
