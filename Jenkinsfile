pipeline {
  agent {
    docker {
      image 'koswu/aosp-buildenv'
      args '-v $HOME/lineage:/code -v $HOME/ccache:/cache -v $HOME/'
    }

  }
  stages {
    stage('fetch') {
      steps {
        sh 'cp -r local_manifests /code/.repo/ && cd /code && repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-18.1'
        retry(count: 3) {
          sh 'cd /code && repo sync -j 10 -c --force-sync'
        }

        sh 'cp $BUILD_KEY_FILE /tmp/key.tar.gz && cd /tmp && tar xzvf key.tar.gz  '
        sh 'mkdir -p $WORKSPACE/build_result'
      }
    }

    stage('build') {
      environment {
        USE_CCACHE = '1'
      }
      steps {
        sh 'bash -c "cd /code && . build/envsetup.sh;lunch lineage_vangogh-user &&  mka bacon"'
      }
    }

    stage('sign') {
      steps {
        sh 'bash -c \'cd /code && . build/envsetup.sh && croot && /code/build/tools/releasetools/sign_target_files_apks -o -d /tmp/android-certs $OUT/out/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip /tmp/signed-target_files.zip\''
        sh '''base -c \'cd /code && . build/envsetup.sh && lunch $BUILD_TARGET && $OUT/build/tools/releasetools/ota_from_target_files -k /tmp/android-certs/releasekey --block --backup=true /tmp/signed-target_files.zip 
$WORKSPACE/build_result/signed-ota_update.zip\''''
      }
    }

    stage('archive') {
      steps {
        archiveArtifacts(artifacts: 'build_result/*', fingerprint: true)
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
    BUILD_KEY_FILE = credentials('d25cb702-701b-40b3-9b1d-e8ec716c61f4')
    BUILD_TARGET = 'lineage_vangogh-user'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    disableConcurrentBuilds()
  }
}