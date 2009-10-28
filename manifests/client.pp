class postgres::client {
    package{'postgresql':
        ensure => present,
    }
}
