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
                    // Automatically detect the OS and use the appropriate command
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
                    // Run unit tests
                    if (isUnix()) {
                        sh 'mvn test'
                    } else {
                        bat 'mvn test'
                    }
                }
            }
        }

        stage('build docker image'){
            steps {
                script{
                    sh 'docker build -t simha-image/jb-hello-world-maven-0.2.0 .'
                }
            }
        }

        stage('push docker image'){
            steps {
                script{
                    withCredentials([string(credentialsId: 'Docker-hub-pwd', variable: 'Docker-hub-pwd')]) {
                    sh 'docker login -u keerthansimhar6@gmail.com -p ${Docker-hub-pwd}'     
                    }
                    sh 'docker push keerthan66/jb-hello-world-maven-0.2.0'
                }
            }
        }
    }

    post {
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed.'
        }
        always {
            cleanWs()
        }
    }
}
