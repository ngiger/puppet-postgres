define postgres::load( $database, $dumpFile) {
  $passtext = $password ? {
    false => "",
    default => "ENCRYPTED PASSWORD '$password'"
  }
  exec { "load posgres dumpfile":
    user => "postgres",
    command => "/usr/bin/psql -f $dumpFile $database", 
# it is up to the caller to define a requirement to the database !!
  }
}
