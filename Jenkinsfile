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
        environment { scannerHome = tool 'valaxyy-sonar-scanner'}
            steps {
                withSonarQubeEnv('valaxyy-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
                sh "${scannerHome}/bin/sonar-scanner"
    }
    }
  }
    }
}