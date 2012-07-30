#!/bin/bash
source config
if [ -f "$1" ] ; then
    MACHINE_LIST=$(cat $1)
    shift
else
    MACHINE_LIST=$(cat $MACHINES)
fi
for m in $MACHINE_LIST ; do
    if [[ "$m" != "`hostname -s`" ]]; then
	echo $m:
	echo ssh $m $@
    fi
done