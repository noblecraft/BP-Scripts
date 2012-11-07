#!/bin/sh

set -e

echo "Bootstrap Script"

WORKING_DIR=$1

if [ -z "$WORKING_DIR" ]; then 
  WORKING_DIR="/tmp/$(uuidgen)"
fi

if [ ! -d "$WORKING_DIR" ]; then 
  mkdir -p $WORKING_DIR > /dev/null
fi

CAPI_DIR=$WORKING_DIR/CAPI

git clone git@github.com:BetterPlaceAustralia/CAPI.git $CAPI_DIR
cd $CAPI_DIR
npm install > /dev/null
export NODE_ENV=systest
cd -

SAPI_DIR=$WORKING_DIR/SAPI

git clone git@github.com:BetterPlaceAustralia/SAPI.git $SAPI_DIR
cd $SAPI_DIR
sbt "project knightsbridge-sapi-web" assembly

echo "Bootstrap complete, working dir: [$WORKING_DIR]"

