#!/bin/sh
# ----------------------------------------------------------------------------
# Maven Wrapper (only-script): descarga la versión de Maven declarada en
# .mvn/wrapper/maven-wrapper.properties la primera vez y la reutiliza después.
# ----------------------------------------------------------------------------
set -eu

BASEDIR=$(cd "$(dirname "$0")" && pwd)
PROPS="$BASEDIR/.mvn/wrapper/maven-wrapper.properties"
[ -f "$PROPS" ] || { echo "mvnw: no existe $PROPS" >&2; exit 1; }

DIST_URL=$(sed -n 's/^distributionUrl=//p' "$PROPS" | tr -d '\r')
[ -n "$DIST_URL" ] || { echo "mvnw: distributionUrl vacío" >&2; exit 1; }

DIST_FILE=${DIST_URL##*/}
DIST_NAME=${DIST_FILE%-bin.tar.gz}
WRAPPER_HOME=${MAVEN_USER_HOME:-"$HOME/.m2"}/wrapper/dists/$DIST_NAME
MAVEN_HOME="$WRAPPER_HOME/$DIST_NAME"

if [ ! -x "$MAVEN_HOME/bin/mvn" ]; then
  mkdir -p "$WRAPPER_HOME"
  TMP="$WRAPPER_HOME/$DIST_FILE.part"
  echo "mvnw: descargando $DIST_URL" >&2
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$TMP" "$DIST_URL"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$TMP" "$DIST_URL"
  else
    echo "mvnw: se necesita curl o wget" >&2; exit 1
  fi
  tar -xzf "$TMP" -C "$WRAPPER_HOME"
  rm -f "$TMP"
fi

exec "$MAVEN_HOME/bin/mvn" -f "$BASEDIR/pom.xml" "$@"
