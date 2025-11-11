#!/bin/sh
set -e

# Start three raft nodes in background (they use localhost:50051..50053)
python main.py node1 > /proc/1/fd/1 2>/proc/1/fd/2 &
python main.py node2 > /proc/1/fd/1 2>/proc/1/fd/2 &
python main.py node3 > /proc/1/fd/1 2>/proc/1/fd/2 &

# Wait for all child processes (keeps container running)
wait