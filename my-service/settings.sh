# For simplicity, using the same settings file for both startstop and
# the actual daemon.

# startstop settings:

export SERVICE_NAME=my-service
# $SERVICE_NAME.{pid,lck} files will be created here:
# make sure they won't conflict with files from any other programs!
export SERVICE_RUN_DIR=/var/run

# SERVICE_DAEMON is being passed to sh -c, through system(3). For the
# fifo serving daemon:
export SERVICE_DAEMON=/opt/Daemon/_daemon
# (Note: _daemon can be called directly (no wrapper needed), since the
# settings are already loaded into the environment from the section
# below)

# daemon settings:

export DAEMON_SOCKET="$SERVICE_RUN_DIR/$SERVICE_NAME.sock"

# For DAEMON_SOCKET_GROUP, "" means world writable! To close it down,
# set to a group name. You have to remove the fifo (file at
# DAEMON_SOCKET) if you change this setting for it to have an effect.
export DAEMON_SOCKET_GROUP=""

# DAEMON_MAINPROGRAM will be run each time a message is received; the
# contents of this variable is passed to a shell (sh -c).  The message
# is presented on stdin.
export DAEMON_MAINPROGRAM="perl -wne 's/\0/(nullbyte)/sg; print'; echo"
