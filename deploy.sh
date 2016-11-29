#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
# Now, dependencies
module add gmp
echo "GMP is at ${GMP_DIR}"
ls -l ${GMP_DIR}/include
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
echo "All tests have passed, will now build into ${SOFT_DIR}"
rm -rf *
../configure \
--with-gmp=${GMP_DIR} \
--prefix ${SOFT_DIR}
make install
mkdir -vp ${LIBRARIES_MODULES}/${NAME}

# Now, create the module file for deployment
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
prereq gmp
module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/mpfr-deploy"
setenv       MPFR_VERSION       $VERSION
setenv       MPFR_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(MPFR_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(MPFR_DIR)/include
MODULE_FILE
) > ${LIBRARIES_MODULES}/${NAME}/${VERSION}
