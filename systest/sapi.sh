#!/bin/sh

echo ""
echo "1. Checkout SAPI"
echo "2. Build / assemble using SBT"
echo "3. Run SAPI to update cache"
echo ""

git clone git@github.com:BetterPlaceAustralia/SAPI.git
cd SAPI
sbt "project knightsbridge-sapi-web" assembly
java -Dconfig.url=http://config.betterp.lc/systest/sapi.conf -jar SAPI/web/target/knightsbridge-sapi-web-assembly-0.1-SNAPSHOT.jar
cd -


