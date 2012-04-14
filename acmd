#!/bin/bash
source config
for m in `cat $MACHINES` ; do
    if [[ "$m" != "`hostname -s`" ]]; then
	echo $m:
	ssh $m $@
    fi
done