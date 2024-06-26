#!/bin/bash

set -x

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd "${SCRIPTPATH}/../"
export PYTHONPATH="${SCRIPTPATH}/../"
nohup poetry run python "${SCRIPTPATH}/../qianfan/tests/utils/mock_server.py" > /tmp/mock_server 2>&1 & 

for i in {1..20}; do 
    curl 127.0.0.1:8866 > /dev/null 2>&1
    if [ $? = 0 ];
    then 
        exit 0
    fi
    sleep 0.5
done
echo "Start mock server failed"
cat /tmp/mock_server
exit 1