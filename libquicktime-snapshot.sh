#!/bin/bash
version=1.2.4
set -e

tmp=$(mktemp -d)

trap cleanup EXIT
cleanup() {
    set +e
    [ -z "$tmp" -o ! -d "$tmp" ] || rm -rf "$tmp"
}

unset CDPATH
pwd=$(pwd)
name=libquicktime
package=libquicktime

pushd "$tmp"
cvs -d:pserver:anonymous@libquicktime.cvs.sourceforge.net:/cvsroot/libquicktime login
cvs -z3 -d:pserver:anonymous@libquicktime.cvs.sourceforge.net:/cvsroot/libquicktime co -D "2015-02-23" -P libquicktime
cd ${tmp}
tar Jcf "$pwd"/${name}-${version}.tar.xz ${package}

popd
upload_source=$( curl --upload-file ${name}-${version}.tar.xz https://transfer.sh/${name}-${version}.tar.xz )

if [ -n "$upload_source" ]; then
GCOM=$( sed -n '/Source0:/=' ${name}.spec)
sed -i "${GCOM}s#.*#Source0:	${upload_source}#" ${name}.spec
fi
