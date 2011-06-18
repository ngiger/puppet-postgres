define postgres::database($ensure, $owner = false) {
  $ownerstring = $owner ? {
    false => "",
    default => "-O $owner"
  }
  case $ensure {
    present: {
      exec{"Create $name postgres db":
        user => "postgres",
        unless => "/usr/bin/psql -l | grep '$name  *|'",
        command => "/usr/bin/createdb $ownerstring $name",
        require => Service[postgresql],
      }
    }
    absent: {
      exec{"Remove $name postgres db":
        user => "postgres",
        onlyif => "/usr/bin/psql -l | grep '$name  *|'",
        command => "/usr/bin/dropdb $name",
        require => Service[postgresql],
      }
    }
    default: {
      fail("Invalid 'ensure' value '$ensure' for postgres::database")
    }
  }
}
    # Xinetd::File['git']{
    #  source => "puppet:///modules/git/xinetd.d/git.disabled"
    #}

$postgres_cfg_path = "/files/etc/postgresql/8.4/main/pg_hba.conf"
 
#define postgres::database_allow($ensure, $type="host", $database="all", $user="all", $address="::1/128", $method="md5") {
#  augeas{ "$postgres_cfg_path":
#      context => "$postgres_cfg_path",
#	context => "/files/etc/postgresql/8.4/main/pg_hba.conf",
#      changes => [
#       "set \"*[database = '$database' and user = '$user'and type = '$type']/type\" $type",
#       "set \"*[database = '$database' and user = '$user'and type = '$type']/database\" $database",
#       "set \"*[database = '$database' and user = '$user'and type = '$type']/user\" $user",
#       "set \"*[database = '$database' and user = '$user'and type = '$type']/address\" $address",
#       "set \"*[database = '$database' and user = '$user'and type = '$type']/method\" $method",
#      ],
#    #  require => Package["augeas-lenses"],
#     onlyif => "match  \"*[database = '$database' and user = '$user'and type = '$type']/method\" size > 0",
#    }
# }
