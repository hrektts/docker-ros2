#!/bin/bash
set -e

source "/root/ros2_ws/install/local_setup.bash"
export OSPL_URI=file:///usr/etc/opensplice/config/ospl.xml
exec "$@"
