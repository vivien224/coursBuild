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
    creates => '/usr/src/dokuwiki-2020-07-29',
    require => File['creation_fichier'];

  'rename' :
    path    => ['/usr/bin/'],
    command => 'mv dokuwiki-2020-07-29 dokuwiki',
    cwd     => '/usr/src',
    require => Exec['unzip'];
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
    ensure  => running,
    require => Package['apache2','php'];
}


file {
  "/var/www/dokuwiki_virtualhost":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755';
}

exec {
  'copie_dans_dokuwiki_virtualhost':
    command => 'rsync -av /usr/src/dokuwiki/ /var/www/dokuwiki_virtualhost',
    path    => ['/usr/bin'],
    require => File['/var/www/dokuwiki_virtualhost'];

  'droit':
    command => 'chown -R www-data:www-data dokuwiki_virtualhost',
    path    => ['/usr/bin'],
    cwd     => '/var/www';

  'configuration_wiki':
    command => 'cp /etc/apache2/site-available/000-default.conf /etc/apache2/site-available/dokuwiki_virtualhost.conf',
    path    => ['/usr/bin'],
     cwd     => '/var/www';

  'sed_conf':
    command => 'sed -i \'s/html/dokuwiki_virtualhost/g\' /var/www/dokuwiki_virtualhost/dokuwiki_virtualhost.conf  && sed -i \'s/*:80/*:1080/g\' /var/www/dokuwiki_virtualhost/dokuwiki_virtualhost.conf',
    path    => ['/usr/bin'];

  'activation':
    command => 'a2ensite dokuwiki_virtualhost',
    path    => ['/usr/bin'];
}

service {
  'apache2':
    ensure  => 'running';
}
