# For simplicity, using the same settings file for both startstop and
# the actual daemon.

# startstop settings:

export SERVICE_NAME=my-service
export SERVICE_RUN_DIR=/var/run

# SERVICE_DAEMON is being fed to system, thus can contain arguments
# (it's split on spaces etc.)
export SERVICE_DAEMON=/opt/my-daemon/daemon

# daemon settings:

export DAEMON_FIFO=/var/run/"$SERVICE_NAME".fifo
