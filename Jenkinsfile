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
                    sh 'docker build -t jb-hello-world-maven-0.2.0 .'
                }
            }
        }

        stage('Transfer Docker Image to SSH Agent') {
            agent {
                label 'ssh-1' // Run this stage on the specific agent
            }
            steps {
                script {
                    sh 'docker save -o jb-hello-world-maven-0.2.0.tar jb-hello-world-maven-0.2.0'
                    sh 'scp jb-hello-world-maven-0.2.0.tar user@ssh-1:/home/user/' // Replace user and path accordingly
                }
            }
        }

        stage('Load and Run Docker Container on SSH Agent') {
            agent {
                label 'ssh-1' // Ensure this runs on the remote agent
            }
            steps {
                script {
                    sh 'ssh user@ssh-1 "docker load -i /home/user/jb-hello-world-maven-0.2.0.tar"'
                    sh 'ssh user@ssh-1 "docker run -d --name tmt -p 8080:8080 jb-hello-world-maven-0.2.0"'
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
