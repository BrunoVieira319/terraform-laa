pipeline {
    agent any
    stages {
        stage('Deploy Packer Image') {
            steps {
                sh '''
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }
    }
}