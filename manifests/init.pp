# Windows_ntp
#
# Configure NTP on windows when not being managed by a windows domain, eg for
# DMZs
#
# @param server NTP server to sync time from
class windows_ntp(
    $server = "pool.ntp.org",
) {

  # https://stackoverflow.com/a/35626035/3441106
  exec { "enable and configure windows ntp server":
    command  => "w32tm /config /syncfromflags:manual /manualpeerlist:\"${server}\"",
    unless   => "w32tm /query /peers | findstr ${server}",
    notify   => Service["w32time"],
    provider => powershell,
    path     => 'c:/windows/system32',
  }

  service { "w32time":
    ensure => running,
    enable => true,
  }
}
