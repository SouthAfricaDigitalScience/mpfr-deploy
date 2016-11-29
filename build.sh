#!/bin/bash -e
. /etc/profile.d/modules.sh
# Add the module for the CI environment
module load ci
module add gmp
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
echo "we'll now build ${NAME}-${VERSION} from ${SOURCE_FILE}"
echo "GCC Include path is now : "
echo ${GCC_INCLUDE_DIR}
mkdir -vp ${SRC_DIR}

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "Seems we are building from scratch - preparing "
  mkdir -p ${SRC_DIR}
  wget http://mirror.ufs.ac.za/gnu/gnu/mpfr/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi

tar -xzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
mkdir ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
../configure \
--with-gmp=${GMP_DIR}\
--prefix ${SOFT_DIR}
make -j 2
