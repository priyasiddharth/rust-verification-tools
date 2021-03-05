#!/bin/bash
# Run commands in the Docker container with a particular UID and GID.
# The idea is to run the container like
#   docker run -i \
#     -v `pwd`:/work \
#     -e LOCAL_USER_ID=`id -u $USER` \
#     -e LOCAL_GROUP_ID=`id -g $USER` \
#     image-name bash
# where the -e flags pass the env vars to the container, which are read by this script.
# By setting copying this script to the container and setting it to the
# ENTRYPOINT, and subsequent commands run in the container will run as the user
# who ran `docker` on the host, and so any output files will have the correct
# permissions.

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-$USER_ID}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
groupadd -g $GROUP_ID thegroup
useradd --shell /bin/bash -u $USER_ID -g thegroup -o -c "" -m user
export HOME=/home/s2priya/
exec /usr/bin/gosu user:thegroup "$@"
