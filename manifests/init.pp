# @summary Configure NTP on Windows
#
# Configure NTP on Windows when not being managed by a windows domain, eg for
# DMZs.
#
# You must specify an NTP server to sync from in the `server` parameter for the
# module to configure your system. Some common public NTP servers are:
#   * time.windows.com
#   * pool.ntp.org
#
# @see https://support.microsoft.com/en-us/help/262680/a-list-of-the-simple-network-time-protocol-sntp-time-servers-that-are
#
# @see http://support.ntp.org/bin/view/Servers/WebHome
#
# @example Hiera data
#   windows_ntp::server: "time.windows.com"
#
# @example use the default NTP server (data from Hiera)
#   include windows_ntp
#
# @example use a specific NTP server
#   class { "windows_ntp":
#     server => "nz.pool.ntp.org",
#   }
#
# @param server NTP server to sync time from
class windows_ntp(
    Optional[String] $server = undef,
) {

  if $server {
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
}
