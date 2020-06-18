#!/bin/sh
function cleanup()
{
    local pids=`jobs -p`
    if [[ "${pids}" != ""  ]]; then
        kill ${pids} >/dev/null 2>/dev/null
    fi
}

service="all"
if [[ "$1" != "" ]];then
    service=$1
fi

trap cleanup EXIT
if [[ "$1" == "sh" ]];then
    sh
else
    python kubeops.py start ${service}
fi