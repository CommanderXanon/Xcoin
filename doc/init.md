Sample init scripts and service configuration for xcoind
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/xcoind.service:    systemd service unit configuration
    contrib/init/xcoind.openrc:     OpenRC compatible SysV style init script
    contrib/init/xcoind.openrcconf: OpenRC conf.d file
    contrib/init/xcoind.conf:       Upstart service configuration file
    contrib/init/xcoind.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "xcoin" user
and group.  They must be created before attempting to use these scripts.
The macOS configuration assumes xcoind will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, xcoind requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, xcoind will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that xcoind and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If xcoind is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running xcoind without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `share/examples/xcoin.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/xcoind`  
Configuration file:  `/etc/xcoin/xcoin.conf`  
Data directory:      `/var/lib/xcoind`  
PID file:            `/var/run/xcoind/xcoind.pid` (OpenRC and Upstart) or `/var/lib/xcoind/xcoind.pid` (systemd)  
Lock file:           `/var/lock/subsys/xcoind` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the xcoin user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
xcoin user and group.  Access to xcoin-cli and other xcoind rpc clients
can then be controlled by group membership.

### macOS

Binary:              `/usr/local/bin/xcoind`  
Configuration file:  `~/Library/Application Support/Xcoin/xcoin.conf`  
Data directory:      `~/Library/Application Support/Xcoin`  
Lock file:           `~/Library/Application Support/Xcoin/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start xcoind` and to enable for system startup run
`systemctl enable xcoind`

NOTE: When installing for systemd in Debian/Ubuntu the .service file needs to be copied to the /lib/systemd/system directory instead.

### OpenRC

Rename xcoind.openrc to xcoind and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/xcoind start` and configure it to run on startup with
`rc-update add xcoind`

### Upstart (for Debian/Ubuntu based distributions)

Upstart is the default init system for Debian/Ubuntu versions older than 15.04. If you are using version 15.04 or newer and haven't manually configured upstart you should follow the systemd instructions instead.

Drop xcoind.conf in /etc/init.  Test by running `service xcoind start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy xcoind.init to /etc/init.d/xcoind. Test by running `service xcoind start`.

Using this script, you can adjust the path and flags to the xcoind program by
setting the XCOIND and FLAGS environment variables in the file
/etc/sysconfig/xcoind. You can also use the DAEMONOPTS environment variable here.

### macOS

Copy org.xcoin.xcoind.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.xcoin.xcoind.plist`.

This Launch Agent will cause xcoind to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run xcoind as the current user.
You will need to modify org.xcoin.xcoind.plist if you intend to use it as a
Launch Daemon with a dedicated xcoin user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
