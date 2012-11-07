#!/bin/sh

function usage() {
  echo ""
  echo "Release script v0.1"
  echo ""
  echo "usage: release.sh <project> [<tag>]"
  echo "where <project> = the project ot release e.g. CAPI"
  echo "and   <tag> (optional) = the tag add to git e.g. v1.3 - defaults to yyyy_mm_dd_seconds-since-epoch"
  echo ""
}

if [ -z "$1" ]; then
  usage
  exit -1
fi

TMP_DIR=/var/tmp/release

if [ ! -d "$TMP_DIR" ]; then
  mkdir -p $TMP_DIR
fi

BUILD=$(uuidgen)
RELEASE_DATE=$(date "+%Y-%m-%d %H:%M:%S")
RELEASED_BY=$(id -un)

BASE=$(pwd)
BUILDS_DIR=$BASE/builds
TARGET=$(echo "$1.tgz" | tr '[:upper:]' '[:lower:]')

TAG="$2"
if [ -z "$TAG" ]; then
  # set tag to year_month_day_seconds since epoch
  TAG=$(date "+%Y_%m_%d_%s")
fi

ARCHIVE="$BASE/builds/tgz/$1-$TAG.tgz"

set -e

echo ""
echo "Preparing release for $1"
echo "Build: $BUILD"
echo "Date: $RELEASE_DATE"
echo "Release Engineer: $RELEASED_BY"
echo "Tag: $TAG"
echo ""

if [ -d "$TMP_DIR/$1" ]; then
  echo "* Cleaning up tmp working folder: $TMP_DIR/$1"
  rm -rf $TMP_DIR/$1
fi

cd $1
echo "* Pulling from remote git repo..."
git pull origin master
git tag "$TAG"
echo "* Archiving $1 (tag=$TAG)"
git archive --format=tar --prefix=$1/ $TAG | (cd /var/tmp/release && tar xf -)
echo "{ \"name\": \"$1\", \"tag\": \"$TAG\", \"build\": \"$BUILD\", \"date\": \"$RELEASE_DATE\", \"releasedBy\": \"$RELEASED_BY\" }" > $TMP_DIR/$1/version.json
cd - > /dev/null
cd $TMP_DIR
tar -czf $ARCHIVE $1
cd $BASE/builds
if [ -f "$BUILDS_DIR/$TARGET" ]; then
  rm $BUILDS_DIR/$TARGET
fi
ln -s $ARCHIVE $TARGET
echo "* Linking $BUILDS_DIR/$TARGET -> $ARCHIVE"

echo ""
echo "Done!"
echo ""

