#!/usr/bin/env bash
set -euo pipefail

# Prevent Git Bash (MSYS) from rewriting Linux container paths like /opt/... to C:/...
MSYS_NO_PATHCONV=1 docker compose exec hive-server2 \
	/opt/hive/bin/schematool \
	-initSchema \
	-dbType hive \
	-metaDbType postgres \
	-url jdbc:hive2://localhost:10000/default