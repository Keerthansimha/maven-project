pipeline {
    agent {
        label 'ssh-agent' // Replace with your agent's label
    }

    tools {
        maven 'maven'
        jdk 'java'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/docker-deploy']], 
                    extensions: [], 
                    userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/Keerthansimha/maven-project.git']]
                ])
            }
        }

        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'mvn package'
                    } else {
                        bat 'mvn package'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'mvn test'
                    } else {
                        bat 'mvn test'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t keerthan66/jb-hello-world-maven-0.2.0 .'

                    // Push the Docker image
                    withCredentials([string(credentialsId: 'Docker-pass', variable: 'Docker')]) {
                        sh 'docker login -u keerthan66 -p ${Docker}'                  
                    }
                    sh 'docker push keerthan66/jb-hello-world-maven-0.2.0'
                }
            }
        }

        stage('Docker Deploy to Container') {
            agent {
                label 'ssh-1' // Run this stage on the specific agent
            }
            steps {
                script {
                    withCredentials([string(credentialsId: 'Docker-pass', variable: 'Docker')]) {
                        sh 'docker login -u keerthan66 -p ${Docker}'                  
                    }
                    sh 'docker run -d --name keer -p 8080:8080 keerthan66/jb-hello-world-maven-0.2.0'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            cleanWs()
        }
    }
}
