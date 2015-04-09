#!/bin/bash

SERVER_PID=""
if [[ -e /tmp/dart-pad.py.pid ]]; then
	SERVER_PID=$( cat /tmp/dart-pad.py.pid )
fi

if [[ $SERVER_PID != "" ]]; then
	kill $SERVER_PID
	rm /tmp/dart-pad.py.pid
fi
