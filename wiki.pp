file {
  'creation_fichier':
    path           => '/usr/src/dokuwiki.tgz',
    source         => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
    checksum_value => '8867b6a5d71ecb5203402fe5e8fa18c9',
    owner          => root,
    group          => root;

}

exec {
  'unzip':
    command => 'tar -xavf dokuwiki.tgz',
    path    => ['/usr/bin'],
    cwd     => '/usr/src',
    creates => '/usr/src/dokuwiki';

}

package {

  'apache2':
    ensure => 'present';

  'php':
    ensure => present,
    name   => 'php7.3';

}

service {
  'apache2' :
    ensure => running;
}
