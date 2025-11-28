pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.11/bin:$PATH"
}
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube analysis') {
        options { timeout(time: 30, unit: 'SECONDS') }
        environment { scannerHome = tool 'valaxyy-sonar-scanner'}
            steps {
                withSonarQubeEnv('valaxyy-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
                sh "${scannerHome}/bin/sonar-scanner"
    }
    }
  }
        stage("Quality Gate"){
            steps {
                script {
                    timeout(time: 30, unit: 'SECONDS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                    def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                    if (qg.status != 'OK') {
                    error "Pipeline aborted due to quality gate failure: ${qg.status}"
    }
  }
}
    }
  }
    }
}