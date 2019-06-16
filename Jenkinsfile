pipeline {
    agent any
    stages {
        stage('Deploy Packer Image') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=plan'
                sh 'terraform apply plan'
            }
        }
    }
    post {
        unsuccessful {
            sh 'terraform destroy'
        }
    }
}