$src_dir = '/usr/src'
$dokuwiki_archive = "${src_dir}/dokuwiki.tgz"
$dokuwiki_dir = "${src_dir}/dokuwiki-2020-07-29"

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

class dl_unzip_conf {
  file {
  '/usr/src/dokuwiki.tgz':
    ensure => 'present',
    source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',

    '/var/www/"${site_hostname}"':
      ensure  => 'directory',
      owner   => 'www-data',
      group   => 'www-data',
      # mode    => '0755',
      source  => "${dokuwiki_dir}",
      recurse => true;

    '/etc/apache2/sites-available/"${site_hostname}".conf':
      ensure  => present,
      content => template('/home/vagrant/demo/demo3/site.conf'),
      require => [Package['apache2'],File['/var/www/"${site_hostname}"']];
  }

  exec {
  'dokuwiki::unarchive':
    cwd     => "${src_dir}",
    command => "tar xavf ${dokuwiki_archive}",
    creates => "${dokuwiki_dir}",
    path    => ['/bin','/usr/bin'],
    require => File["${dokuwiki_archive}"],

  'enable-vhost-1':
    command => 'a2ensite "${site_hostname}"',
    path    => ['/usr/bin', '/usr/sbin'],
    require => [File['/etc/apache2/sites-available/"${site_hostname}".conf'],
      Package['apache2']];
  }


node 'control' {
  include development
}

node 'server0' {
  $site_hostname = 'politique.wiki'
  $site_dir = 'politique-wiki'

  include hosting
  include dl_unzip_conf

}

node 'server1' {
  $site_hostname = 'recette.wiki'
  $site_dir = 'recette-wiki'

  include hosting
  include dl_unzip_conf
}
