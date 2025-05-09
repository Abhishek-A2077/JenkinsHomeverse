pipeline {
  agent any

  environment {
    // Jenkins credentials IDs-create these in Manage Jenkins → Credentials
    GITHUB_CREDS    = 'github-creds'         // your GitHub PAT (Username+Token)
    DOCKERHUB_CREDS = 'docker-hub-password'  // using your existing credential ID
    EC2_SSH_KEY     = 'ec2-ssh-key'          // SSH key to access EC2 as ec2-user
    IMAGE_NAME      = 'abhisheka2077/homeverse-app'
    EC2_HOST        = 'ec2-user@3.84.197.34'  // your EC2 public IP
  }

  stages {
    stage('Checkout') {
      steps {
        git credentialsId: env.GITHUB_CREDS,
            url: 'https://github.com/Abhishek-A2077/JenkinsHomeverse',
            branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', env.DOCKERHUB_CREDS) {
            docker.image("${IMAGE_NAME}:${env.BUILD_NUMBER}").push()
            docker.image("${IMAGE_NAME}:${env.BUILD_NUMBER}").push('latest')
          }
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        // Use SSH Agent plugin to provide your private key
        sshagent([env.EC2_SSH_KEY]) {
          sh """
            ssh -o StrictHostKeyChecking=no ${EC2_HOST} \\
              'docker pull ${IMAGE_NAME}:${env.BUILD_NUMBER} &&
               docker stop homeverse-app || true &&
               docker rm homeverse-app || true &&
               docker run -d --name homeverse-app -p 80:80 ${IMAGE_NAME}:${env.BUILD_NUMBER}'
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Build #${env.BUILD_NUMBER} succeeded and deployed."
    }
    failure {
      echo "❌ Build failed."
    }
  }
}
