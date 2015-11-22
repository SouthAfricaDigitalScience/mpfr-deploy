#!/bin/bash -e
. /etc/profile.d/modules.sh
# Add the module for the CI environment
module load ci
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
echo "we'll now build ${NAME}-${VERSION} from ${SOURCE_FILE}"

# add dependencies
module add gmp/5.1.3
echo "GCC Include path is now : "
echo ${GCC_INCLUDE_DIR}

if [[ -s ${SRC_DIR/$SOURCE_FILE} ]] ; then
  echo "Seems we are building from scratch - preparing "
  mkdir -p ${SRC_DIR}
  wget http://mirror.ufs.ac.za/gnu/gnu/mpfr/${SOURCE_FILE} -O ${SRC_DIR/}${SOURCE_FILE}
else
  echo "Seems we already have that source file $SRC_DIR/$SOURCE_FILE"
  echo "unpacking from here."
fi
tar -xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE}
cd ${WORKSPACE}/${NAME}-${VERSION}
./configure  --with-gmp=${GMP_DIR}--prefix ${SOFT_DIR}
make -j 8
