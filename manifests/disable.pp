# manifests/disable.pp

class postgres::disable {
   include postgres::base::disable 
}

class postgres::base::disable inherits postgres::base {
    Service['postgresql']{
        ensure => stopped,
        enable => false,
    }

    File['/etc/cron.d/pgsql_backup.cron']{
        ensure => absent,
    }

}
