pipeline {
    agent any
    environment { 
        DOCKERCRED = credentials('dockerhub')
        DOCKER_USERNAME = '${DOCKERCRED_USR}'
        DOCKER_PASSWORD = '${DOCKERCRED_PSW}'
        JAVA_HOME = '/opt/jdk1.8.0_131/'
    }
    parameters {
    string(name: 'DEPLOY_TARGET', defaultValue: '', description: 'TARGET-IP')
    }
    stages {
        stage('GIT SCM CHECKOUT') {
            steps {
                git 'https://github.com/rohanshinde08/pet-project-app.git'
            }
        }
        stage('Maven Build') {
            steps {
                sh '''
                echo 'Maven job building..'
                git clone 'https://github.com/spring-projects/spring-petclinic.git'
                cp Dockerfile ./hosts deploy_app.yml spring-petclinic
                cd spring-petclinic
                ./mvnw clean install
                '''
            }
        }
        stage('Docker stage') {
            steps {
                sh '''
                echo 'Docker build'
                cd spring-petclinic
                docker build -t rohanshinde08/spring-petclinic .
                echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin
                docker push rohanshinde08/spring-petclinic
                '''
            }
        }
        stage('ansible stage') {
            steps {
                sh '''
                echo 'Deploying app with ansible'
                export ANSIBLE_HOST_KEY_CHECKING=False
                sed -i 's|ip_address|${DEPLOY_TARGET}|g' ./hosts
                ansible-playbook -i ./hosts ./deploy_app.yml 
                '''
            }
        }
    }
    post {
        // Clean after build
        always {
            cleanWs()
        }
    }
}
