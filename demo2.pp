file {
  'creation_fichier':
    path    => "/tmp/hello",
    mode    => "0600",
    content => "Hello world",
    owner   => "root";
    group   => 'root',

}
