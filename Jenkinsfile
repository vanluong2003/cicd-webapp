pipeline {
    agent any
    tools {
        maven "MAVEN3.9"
        jdk "JDK17"
    }
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "172.31.34.143:8081"
        NEXUS_REPOSITORY = "vprofile-releases"
        NEXUS_CREDENTIALS_ID = "nexuscred"

        AWS_ACCOUNT_ID = "730335205826"
        AWS_REGION = "us-east-1"
        ECR_REPO_NAME = "vproimage"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        AWS_CREDS_ID = "awscred"
    }
    stages {
        stage("Fetch Code") {
            steps {
                git(url: "https://github.com/vanluong2003/cicd-webapp.git", branch: "main")
            }
        }
        stage("Unit Test") {
            steps {
                sh "mvn test"
            }
        }
        stage("Checkstyle") {
            steps {
                sh "mvn checkstyle:checkstyle"
            }
        }
        stage("Build") {
            steps {
                sh "mvn install -DskipTests"
            }
            post {
                success {
                    archiveArtifacts artifacts: "target/*.war", fingerprint: true
                }
            }
        }
        stage("Code Analysis") {
            steps {
                script {
                    def scannerHome = tool 'SONAR6.2'
                    withSonarQubeEnv('SONARSERVER') {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=vprofile \
                        -Dsonar.projectName=vprofile-repo \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=src/ \
                        -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                        -Dsonar.junit.reportsPath=target/surefire-reports/ \
                        -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                        """
                    }
                }
            }
            
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Upload Artifact to Nexus") {
            steps {
                script { 
                    nexusArtifactUploader(
                        nexusVersion: NEXUS_VERSION,
                        protocol: NEXUS_PROTOCOL,
                        nexusUrl: NEXUS_URL,
                        groupId: "com.visualpathit",
                        version: "v2--${BUILD_ID}--${BUILD_TIMESTAMP}",
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIALS_ID,
                        artifacts: [
                            [artifactId: 'vproapp', 
                            classifier: '', 
                            file: 'target/vprofile-v2.war', 
                            type: 'war']
                        ]
                    )
                }
            }
            
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build -t vproappimage:latest ."
                sh "docker tag vproappimage:latest vproappimage:${BUILD_ID}"
            }
        }
        stage("Push to ECR") {
            steps {
                withAWS(credentials: AWS_CREDS_ID, region: AWS_REGION) {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    sh "docker tag vproappimage:latest ${ECR_REGISTRY}/${ECR_REPO_NAME}:lastest"
                    sh "docker tag vproappimage:latest ${ECR_REGISTRY}/${ECR_REPO_NAME}:${BUILD_ID}"
                    sh "docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest"
                    sh "docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${BUILD_ID}"
                }
            }
        }
    }
    post {
        always {
            sh "docker image prune -f"
        }
    }
}