pipeline {
  agent {
    docker {
      image 'koswu/aosp-buildenv'
    }

  }
  stages {
    stage('fetch') {
      steps {
        git(url: 'https://github.com/Koswu/lineage_xiaomi_vangogh_build.git', branch: 'main')
      }
    }

  }
}