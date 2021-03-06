def DownloadSourceFiles(version,source,destination, params) {
    build job: $project, parameters: $params
            sh 'mkdir -vp ${SRC_DIR}'
            script {
              if(!fileExists("${SRC_DIR}/${SRC_FILE}")  && !fileExists("${SRC_DIR}/${SRC_FILE}.lock")) {
                echo "${SRC_DIR}/${SRC_FILE} not present"
                touch "${SRC_DIR}/${SRC_FILE}.lock"
                sh 'wget ${SRC_URL}/${SRC_FILE} -O ${SRC_DIR}/${SRC_FILE}'
                sh 'rm ${SRC_DIR}/${SRC_FILE}.lock' 
              }     
              else if(fileExists("${SRC_DIR}/${SRC_FILE}.lock"))
                while (!fileExists("${SRC_DIR}/${SRC_FILE}.lock")) {
                  sh 'file busy downloading there'
                }
              else {
                echo "file is already there"
              }
            }
}


pipeline {
  agent any
  environment {
    ARCH    = 'x86_64'
    SITE    = 'generic'
    NAME    = 'mpfr'
    SRC_URL = 'http://ftpmirror.gnu.org/mpfr/'
  }


  stages {
    stage('Sanity Tests') {
      steps {
        fileExists 'build.sh check-build.sh deploy.sh'
      }
    }


  stages {
    stage('cache tarball') {
      parallel { #download versions in parallel
        stage ('3.1.2') {
          options { retry(3) }
          environment {
            VERSION   = '3.1.2'
            SRC_FILE  = "${env.NAME + '-' + env.VERSION + '.tar.gz'}"
            SRC_DIR   = "${'/data/src/' + env.NAME }"
          }
          agent { label 'centos7' }
        }
        stage ('4.0.1') {
          environment {
            VERSION='4.0.1'
            SRC_FILE="${env.NAME + '-' + env.VERSION + '.tar.gz'}"
            SRC_DIR = "${'/data/src/' + env.NAME }"
          }
          agent { label 'centos7' }
          steps {
            sh 'mkdir -vp $SRC_DIR'
            sh 'wget ${SRC_URL}/${SRC_FILE} -O ${SRC_DIR}/${SRC_FILE}'
          }
        }
      }
    }
    stage('build') {
      parallel {
        stage('build 3.1.2 on centos6') {
          environment {
            OS = 'centos6'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + env.NAME + '/' + env.VERSION + '/' + env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label 'centos6' }
          steps {
            sh 'pwd'
            sh 'echo $SITE $NME $OS $ARCH $VERSION $WORKSPACE'
            sh './build.sh'
            sh ''
          }
        }
        stage('build 4.0.1 on centos6') {
          environment {
            OS = 'centos6'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "centos6" }
          steps {
            sh './build.sh'
          }
        }
        stage('build 3.1.2 on centos7') {
          environment {
            OS = 'centos7'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "centos7" }
          steps {
            sh './build.sh'
          }
        }
        stage('build 4.0.1 on centos7') {
          environment {
            OS = 'centos7'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3)
            skipDefaultCheckout() 
          }
          agent { label "centos7" }
          steps {
            sh './build.sh'
          }
        }
        stage('build 3.1.2 on ubuntu 1404') {
          environment {
            OS = 'u1404'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1404" }
          steps {
            sh './build.sh'
          }
        }
        stage('build 4.0.1 on ubuntu 1404') {
          environment {
            OS = 'u1404'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1404" }
          steps {
            sh './build.sh'
          }
        }
        stage('build 3.1.2 on ubuntu 1610') {
          environment {
            OS = 'u1610'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1610" }
          steps {
            sh './build.sh'
          }
        }
        stage('build 4.0.1 on ubuntu 1610') {
          environment {
            OS = 'u1610'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1610" }
          steps {
            sh './build.sh'
          } // steps
        } // stage
      } // parallel
    } // stage build
    stage('test') {
      parallel {
        stage('test 3.1.2 on centos6') {
          environment {
            OS = 'centos6'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "centos6" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 4.0.1 on centos6') {
          environment {
            OS = 'centos6'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "centos6" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 3.1.2 on centos7') {
          environment {
            OS = 'centos7'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "centos7" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 4.0.1 on centos7') {
          environment {
            OS = 'centos7'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "centos7" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 3.1.2 on ubuntu 1404') {
          environment {
            OS = 'u1404'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1404" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 4.0.1 on ubuntu 1404') {
          environment {
            OS = 'u1404'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1404" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 3.1.2 on ubuntu 1610') {
          environment {
            OS = 'u1610'
            VERSION = '3.1.2'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1610" }
          steps {
            sh './check-build.sh'
          }
        }
        stage('test 4.0.1 on ubuntu 1610') {
          environment {
            OS = 'u1610'
            VERSION = '4.0.1'
            WORKSPACE = "${'/home/jenkins/workspace/' + \
                            env.NAME + '/' + \
                            env.VERSION + '/' + \
                            env.OS}"
          }
          options { 
            retry(3) 
            skipDefaultCheckout() 
          }
          agent { label "u1610" }
          steps {
            sh 'echo $SITE $NAME $OS $ARCH $VERSION'
            sh './check-build.sh'
          } // steps
        } // stage
      } // parallel
    } // stage test
    stage('ship CI') {
      environment {
        TARBALL = "${env.NAME + \
                  '-' + env.SITE + \
                  '-' + env.ARCH + \
                  '-' + env.BUILD_NUMBER + \
                  '-' + '.tar.gz'}"
        ZENODO_API_KEY = credentials('zenodo_access_token')
        PATH = "$PATH:$HOME/.local/bin"
      }
      options { 
        retry(3) 
        skipDefaultCheckout() 
      }
      agent { label 'dockyard' }
      steps {
        sh "tar cvfz ${TARBALL} \
          /data/ci-build/generic/*/${ARCH}/${NAME} \
          /data/modules/libraries/gmp"
        sh "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py"
        sh "python get-pip.py --user"
        sh "pip install --user requests"
        sh "python publish-ci.py"
        archiveArtifacts artifacts: 'zenodo.json', fingerprint: true
      } // steps
    } // ship stage
    stage('build deploy') {
        parallel {
          stage('deploy 3.1.2 on centos6') {
            environment {
              OS = 'centos6'
              VERSION = '3.1.2'
              WORKSPACE = "${'/home/jenkins/workspace/' +\
                            env.NAME + '/' \
                            + env.VERSION + '/' \
                            + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label 'centos6' }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 4.0.1 on centos6') {
            environment {
              OS = 'centos6'
              VERSION = '4.0.1'
              WORKSPACE = "${'/home/jenkins/workspace/' + \
                              env.NAME + '/' + env.VERSION + \
                              '/' + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label "centos6" }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 3.1.2 on centos7') {
            environment {
              OS = 'centos7'
              VERSION = '3.1.2'
              WORKSPACE = "${'/home/jenkins/workspace/' + \
                              env.NAME + \
                              '/' + env.VERSION + \
                              '/' + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label "centos7" }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 4.0.1 on centos7') {
            environment {
              OS = 'centos7'
              VERSION = '4.0.1'
              WORKSPACE = "${'/home/jenkins/workspace/' \
                              + env.NAME \
                              + '/' + env.VERSION \
                              + '/' + env.OS}"
            }
            options { 
              retry(3)
              skipDefaultCheckout() 
            }
            agent { label "centos7" }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 3.1.2 on ubuntu 1404') {
            environment {
              OS = 'u1404'
              VERSION = '3.1.2'
              WORKSPACE = "${'/home/jenkins/workspace/' \
                              + env.NAME \
                              + '/' + env.VERSION \
                              + '/' + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label "u1404" }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 4.0.1 on ubuntu 1404') {
            environment {
              OS = 'u1404'
              VERSION = '4.0.1'
              WORKSPACE = "${'/home/jenkins/workspace/' \
                              + env.NAME \
                              + '/' + env.VERSION \
                              + '/' + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label "u1404" }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 3.1.2 on ubuntu 1610') {
            environment {
              OS = 'u1610'
              VERSION = '3.1.2'
              WORKSPACE = "${'/home/jenkins/workspace/' \
                              + env.NAME \
                              + '/' + env.VERSION \
                              + '/' + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label "u1610" }
            steps {
              sh './deploy.sh'
            }
          }
          stage('deploy 4.0.1 on ubuntu 1610') {
            environment {
              OS = 'u1610'
              VERSION = '4.0.1'
              WORKSPACE = "${'/home/jenkins/workspace/' \
                              + env.NAME + '/' \
                              + env.VERSION + '/' \
                              + env.OS}"
            }
            options { 
              retry(3) 
              skipDefaultCheckout() 
            }
            agent { label "u1610" }
            steps {
              sh './deploy.sh'
            } // steps
          } // stage
        } // parallel
      } // stage deploy
  }// stages
} // pipeline
