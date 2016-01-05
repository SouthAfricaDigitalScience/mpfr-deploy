#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
echo ""
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
make check

echo "exit code is $?"
make install

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
## Requires gmp
prereq gmp
setenv       MPFR_VERSION       $VERSION
setenv       MPFR_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(MPFR_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(MPFR_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -vp ${LIBRARIES_MODULES}/${NAME}
cp -v modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}
