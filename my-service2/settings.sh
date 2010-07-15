# see my-service/settings.sh for documentation

export SERVICE_NAME=my-service2
export SERVICE_RUN_DIR=/var/run
export SERVICE_DAEMON=/opt/Daemon/_daemon

export DAEMON_SOCKET="$SERVICE_RUN_DIR/$SERVICE_NAME.sock"
export DAEMON_SOCKET_GROUP=""
# ^ give everybody write access

export DAEMON_MAINPROGRAM=/opt/Daemon/my-service2/inputfilter
