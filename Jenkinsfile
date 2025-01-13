pipeline {
    agent any
    
    tools {
        maven 'maven'
        jdk 'java'
    }

    environment {
        REMOTE_SERVER = '98.80.72.129'    // IP or hostname of the target server
        REMOTE_USER = 'ubuntu'             // SSH username for the target server
        REMOTE_PATH = '/var/www/html/myapp' // The path where you want to deploy
        SSH_KEY_ID = 'ssh-agnet'      // Jenkins credentials ID for the SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/deploy']], 
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

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ssh-agnet']) {
                    script {
                        // Deploy the artifact to the remote server
                        if (isUnix()) {
                            sh """
                               scp  -i /home/ubuntu/.ssh/id_rsa /var/lib/jenkins/workspace/build_and_deploy/target/jb-hello-world-maven-0.2.0.jar  ubuntu@ec2-98-80-72-129.compute-1.amazonaws.com:/var/www/html/myapp
                               ssh  -i /home/ubuntu/.ssh/id_rsa ubuntu@ec2-98-80-72-129.compute-1.amazonaws.com
                            """
                        } else {
                            bat """
                               pscp -i /home/ubuntu/.ssh/id_ed25519 target\\jb-hello-world-maven-0.2.0.jar   ubuntu@ec2-23-20-91-130.compute-1.amazonaws.com:/var/www/html/myapp
                               plink -i /home/ubuntu/.ssh/id_ed25519 ubuntu@ec2-23-20-91-130.compute-1.amazonaws.com "cd /var/www/html/myapp && java -jar jb-hello-world-maven-0.2.0.jar"
                            """
                        }
                    }
                }
            }
        }

        stage('Clean') {
            steps {
                script {
                    // Clean up the workspace
                    if (isUnix()) {
                        sh 'mvn clean'
                    } else {
                        bat 'mvn clean'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            echo 'Build or deployment failed.'
        }
        always {
            cleanWs()
        }
    }
}
