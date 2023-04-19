#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
echo $SCRIPT_DIR
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts
echo $ARTIFACTS_DIR

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/opt/jboss/container/openjdk/jre/*

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

# Set this JDK as the alternative in use
_arch="$(uname -i)"
alternatives --set java java-11-openjdk.${_arch}
