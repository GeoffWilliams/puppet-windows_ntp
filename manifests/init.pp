# Windows_ntp
#
# Configure NTP on windows when not being managed by a windows domain, eg for
# DMZs
#
# @example use the default NTP server
#   include windows_ntp
#
# @example use a specific NTP server
#   class { "windows_ntp":
#     server => "nz.pool.ntp.org",
#   }
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
