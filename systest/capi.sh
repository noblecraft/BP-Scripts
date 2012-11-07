#!/bin/sh

set -e

echo ""
echo "1. Checkout CAPI"
echo "2. Build / assemble using SBT"
echo "3. Run SAPI to update cache"
echo ""

WORKING_DIR=$1

if [ -z "$WORKING_DIR" ]; then 
  WORKING_DIR="/tmp/$(uuidgen)"
fi

if [ ! -d "$WORKING_DIR" ]; then 
  mkdir -p $WORKING_DIR
fi

git clone git@github.com:BetterPlaceAustralia/CAPI.git $WORKING_DIR
cd $WORKING_DIR
npm install
export NODE_ENV=systest
node app.js
cd -

