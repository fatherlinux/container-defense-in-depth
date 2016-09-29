#!/bin/bash
#
# Written by: Scott McCarty
# Email: smccarty@redhat.com
# Description: This code will demonstrate read only containers in action and free logging of data access.
#              These commands can be ran manually or automatically with this script.
#
# Demo #1: For slide 14: http://bit.ly/container-did
# This demonstrates read only containers, bind mounts (known data), and svirt

# Configure auditd
echo "# Monitor read-access of container mount point
-w /mnt/container01 -p rwxa" > /etc/audit/rules.d/container.rules
service auditd restart
echo ""

# Start the container
CONTAINER_ID=`docker run -dt --read-only -v /mnt/container01/:/mnt/container01:Z rhel7 bash`
echo ""

# Cannot touch a file in temp
docker exec $CONTAINER_ID touch /tmp/scott
echo ""

# Now touch a file on the bind mount
docker exec $CONTAINER_ID touch /mnt/container01/test
echo ""

# Check the log
ausearch -c touch -f "/mnt/container01/test" --start recent --end now -i --just-one
echo ""

# Stop the container
docker kill $CONTAINER_ID
echo ""
