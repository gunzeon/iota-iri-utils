#! /bin/bash -u

# *** /home/iota/iota-iri.sh ***

#  $1 - start|stop
#  $2 - PIDFILE

IOTA_NODE_LIST=(
udp://iotatangle.be:14600                               # George Gunzeon BE
udp://somenode.be:14600                                 # comment here
udp://another.be:14600                                  # comment here
)

IOTA_NODES="${IOTA_NODE_LIST[@]}"

IOTA_DIR=$HOME/iri/target
IOTA_CMD="java -Xmx10g -jar iri-1.3.1.jar --config /home/iota/iota-iri.ini -n \''$IOTA_NODES'\'"

IOTA_IRI_CMD='java -Xmx10g -jar iri-1.3.1.jar --config /home/iota/iota-iri.ini -n '\'${IOTA_NODE_LIST[@]}\'
IOTA_PM_CMD='iota-pm -i http://localhost:14265 -p 8888'

case "$1" in
start)
        # *** IOTA-IRI ***
        screen -S iota-iri -d -m -h 10000
        screen -S iota-iri -X stuff 'echo \$PPID > '"$2 $(printf \\r)"
        screen -S iota-iri -X stuff "cd $IOTA_DIR $(printf \\r)"
        screen -S iota-iri -X stuff "$IOTA_IRI_CMD $(printf \\r)"
        # *** IOTA-PM ***
        screen -S iota-pm -d -m -h 10000
        screen -S iota-pm -X stuff "$IOTA_PM_CMD$(printf \\r)"
        ;;
stop)
        # *** IOTA-IRI ***
        screen -S iota-iri -X stuff "\003$(printf \\r)"
        while ps -fU iota | grep ' [j]ava .*iri'; do
                sleep 1
        done
        screen -S iota-iri -X stuff "exit$(printf \\r)"
        rm $2
        # *** IOTA-PM ***
#       screen -S iota-pm -X stuff "\003$(printf \\r)"
#       screen -S iota-pm -X stuff "exit$(printf \\r)"
        ;;
esac

exit 0
