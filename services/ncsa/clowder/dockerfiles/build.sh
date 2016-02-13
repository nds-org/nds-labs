#!/bin/bash

#DEBUG=echo
#VERBOSE="YES"
#PUSH="push"

create() {
  if [ -z "$1" ]; then echo "Missing repo/Dockerfile name."; exit -1; fi
  if [ -n "$VERBOSE" ]; then echo "Started $1"; fi
  if [ -z "$2" ]; then echo "Missing versions for $1."; exit -1; fi
  if [ -z "$4" -a -n "$VERBOSE" ]; then echo "Will not push $1 to hub.docker.org"; fi

  # create image using temp id
  local ID=$(uuidgen)
  ${DEBUG} docker build -t ${ID} $1
  if [ $? -ne 0 ]; then
    echo "FAILED build of $1/Dockerfile"
    exit -1
  fi

  # tag all versions
  for r in $1 $3; do
    for v in $2; do
      ${DEBUG} docker tag -f ${ID} ${r}:${v}
      if [ "$4" == "push" ]; then
        ${DEBUG} docker push ${r}:${v}
      fi
    done
  done

  # delete image with temp id
  ${DEBUG} docker rmi ${ID}
  if [ -n "$VERBOSE" ]; then echo "Finished $1"; fi
}

# ----------------------------------------------------------------------
# PECAN IMAGES
# ----------------------------------------------------------------------
# default pecan stuff
create "pecan/base" "1.4.3 latest" "" "${PUSH}"
create "pecan/core" "1.4.3 latest" "" "${PUSH}"
create "pecan/db"   "1.4.3 latest" "" "${PUSH}"

# ----------------------------------------------------------------------
# POLYGLOT IMAGES
# ----------------------------------------------------------------------
create "polyglot/server" "2.1.0 latest" "" "${PUSH}"
create "polyglot/imagemagick" "2.1.0 latest" "" "${PUSH}"
create "polyglot/pecan" "1.4.3 latest" "" "${PUSH}"
