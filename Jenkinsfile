pipeline {
    agent any
    
    environment {
        S3_BUCKET = "primer-proyecto-tf"
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCESS_KEY_ID = credentials('aws_access_key')
        AWS_SECRET_KEY_ID = credentials('aws_secret_key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gastonbarbaccia/jenkins_terraform_s3_demo.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Format') {
            steps {
                script {
                    sh 'terraform fmt'
                }
            }
        }
        
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        
        stage('Check S3 File - Tfstate') {
            steps {
                script {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_ID}", "AWS_REGION=${AWS_DEFAULT_REGION}"]) {
                        
                        def bucketExists = sh(script: "aws s3api head-bucket --bucket ${S3_BUCKET} > /dev/null 2>&1 && echo 'Bucket exists' || echo 'Bucket does not exist'", returnStdout: true).trim()

                        // Verifica la salida y actúa en consecuencia
                        if (bucketExists == 'Bucket exists') {
                            
                            def fileExists = sh(script: 'aws s3 ls s3://${S3_BUCKET}/terraform.tfstate', returnStatus: true) == 0
                            if (fileExists) {
                                sh 'aws s3 cp s3://${S3_BUCKET}/terraform.tfstate ./terraform.tfstate'
                            }

                        } else {

                            def createBucket = sh(script: 'aws s3api create-bucket --bucket ${S3_BUCKET} --region us-east-1', returnStatus: true)

                                // Verifica si el comando fue exitoso
                                if (createBucket == 0) {
                                    echo "Bucket ${S3_BUCKET} created successfully in the region ${AWS_REGION}."
                                } else {
                                    error "Error in the creation of the Bucket ${S3_BUCKET}."
                                }
                            
                        }
                    }
                }
            }
        }
       
        stage('Terraform Plan') {
            steps {
                script {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_ID}", "AWS_REGION=${AWS_DEFAULT_REGION}"]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_ID}", "AWS_REGION=${AWS_DEFAULT_REGION}"]) {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
        
        stage('Terraform Tfstate Upload') {
            steps {
                script {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_ID}", "AWS_REGION=${AWS_DEFAULT_REGION}"]) {
                        sh 'aws s3 cp terraform.tfstate s3://${S3_BUCKET}'
                    }
                }
            }
        }
    }
}