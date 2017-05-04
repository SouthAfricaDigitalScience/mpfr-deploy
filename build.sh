#!/bin/bash -e
. /etc/profile.d/modules.sh
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Add the module for the CI environment
module add ci
module add gmp

SOURCE_FILE=${NAME}-${VERSION}.tar.gz
echo "we'll now build ${NAME}-${VERSION} from ${SOURCE_FILE}"
mkdir -vp ${SRC_DIR}

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "Seems we are building from scratch - preparing "
  mkdir -p ${SRC_DIR}
  wget http://ftpmirror.gnu.org/mpfr/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
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
echo ${GMP_DIR}
ls ${GMP_DIR}/include
../configure \
CFLAGS=-fPIC \
--host=${ARCH} \
--enable-static \
--enable-shared \
--with-gmp=${GMP_DIR} \
--prefix ${SOFT_DIR}
make -j 2
