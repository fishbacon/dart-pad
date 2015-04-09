#!/bin/bash
cd web
python main.py > ~/logs/dart-pad.log 2>&1 &
SERVER_PID=$!
echo "Started server with PID $SERVER_PID"
echo $SERVER_PID > /tmp/dart-pad.py.pid
