# For simplicity, using the same settings file for both startstop and
# the actual daemon.

# startstop settings:

export SERVICE_NAME=my-service
# $SERVICE_NAME.{pid,lck} files will be created here:
# make sure they won't conflict with files from any other programs!
export SERVICE_RUN_DIR=/var/run

# SERVICE_DAEMON is being fed to a shell through system(2), thus can
# contain arguments (the string will be split on spaces etc.)
export SERVICE_DAEMON=/opt/Daemon/my-service/daemon

# daemon settings:

export DAEMON_FIFO=/var/run/"$SERVICE_NAME".fifo

# For DAEMON_FIFO_GROUP, "" means world writable! To close it down,
# set to a group name.
export DAEMON_FIFO_GROUP=""

