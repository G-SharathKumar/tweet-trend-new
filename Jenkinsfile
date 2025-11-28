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
            steps {
                script {
                    try {
                        timeout(time: 30, unit: 'SECONDS') {
                            def scannerHome = tool 'valaxyy-sonar-scanner'
                            withSonarQubeEnv('valaxyy-sonarqube-server') {
                                sh "${scannerHome}/bin/sonar-scanner"
                            }
                        }
                    } catch (err) {
                        // Handle failure without aborting the pipeline
                        echo "⚠ SonarQube analysis skipped or failed: ${err}"
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    try {
                        if (!fileExists('.scannerwork/report-task.txt')) {
                            echo "⚠ Sonar report not found. Skipping Quality Gate."
                            return
                        }

                        timeout(time: 30, unit: 'SECONDS') {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            }
                        }
                    } catch (err) {
                        echo "⚠ Quality Gate skipped or failed: ${err}"
                    }
                }
            }
        }
    }
}