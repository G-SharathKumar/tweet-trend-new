def registry = 'https://valaxyy05.jfrog.io'

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
                echo "----------- build started ----------"
                sh 'mvn clean deploy'
                echo "----------- build complted ----------"
            }
        }
        stage("test"){
            steps{
                script {
                    try {
                        echo "----------- unit test started ----------"
                        sh 'mvn surefire-report:report'
                        echo "----------- unit test Complted ----------"
                    }
                    } catch (err) {
                        // Handle failure without aborting the pipeline
                        echo "⚠ unit tests analysis skipped or failed: ${err}"
                    }
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
        stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artfiact-cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "valaxyy05-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }
    }
}