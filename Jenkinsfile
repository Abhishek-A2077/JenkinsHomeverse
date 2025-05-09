pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t abhisheka2077/homeverse-app:${BUILD_NUMBER} .'
            }
        }
        
        stage('Push to Registry') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_PWD')]) {
                    sh 'docker login -u abhisheka2077 -p ${DOCKER_PWD}'
                    sh 'docker push abhisheka2077/homeverse-app:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "sed -i 's|abhisheka2077/homeverse-app:v1|abhisheka2077/homeverse-app:${BUILD_NUMBER}|' homeverse-deployment.yaml"
                sh 'kubectl apply -f homeverse-deployment.yaml'
            }
        }
    }
}
