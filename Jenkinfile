
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rukevweubio/my-jenkin-app"
        DOCKER_TAG   = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image ${DOCKER_IMAGE}:${DOCKER_TAG}..."
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Logging in to Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Pull Docker Image from Hub') {
            steps {
                script {
                    echo "Pulling Docker image from Docker Hub..."
                    sh "docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Verify Docker Image') {
            steps {
                script {
                    echo "Checking if Docker image exists locally..."
                    sh "docker image inspect ${DOCKER_IMAGE}:${DOCKER_TAG} > /dev/null"
                }
            }
        }

        stage('Run Docker Image') {
            steps {
                script {
                    echo "Running Docker container on port 8082..."
                    // Stop existing container from this image if any
                    sh "docker ps -q --filter ancestor=${DOCKER_IMAGE} | xargs -r docker stop"
                    sh "docker run -d -p 8082:80 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Docker image built, pushed, pulled, and running successfully!"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
