pipeline {
    agent any
    
    environment {
        // Se obtiene la dirección de Vault de las credenciales
        VAULT_ADDR = credentials('vault-address')  // ID de la credencial de la dirección de Vault
        VAULT_TOKEN = credentials('vault-token')   // ID de la credencial del token de Vault
        S3_BUCKET = "primer-proyecto-tf"    
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCESS_KEY_ID = credentials('aws_access_key')
        AWS_SECRET_KEY_ID = credentials('aws_secret_key')
        
    }
    
    stages {
  
    /*    stage('Fetch Secret from Vault') {
            steps {
                script {
                    // Fetch the secret using curl
                    def secret = sh(script: 'curl -H "X-Vault-Token: $VAULT_TOKEN" -X GET $VAULT_ADDR/v1/secret/data/devops/jenkins | jq -r .data.data.host', returnStdout: true).trim()

                    // Utiliza el secreto según sea necesario
                    echo "Fetched secret: ${secret}"
                }
            }
        }
    */   
        
        stage('Checkout') {
            steps {
               git branch: 'main', url:'https://github.com/gastonbarbaccia/jenkins_terraform_s3_demo.git'
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
    /*    
        stage('Check S3 File - Tfstate') {
            steps {
                script {
                        def fileExists = sh(script: "aws s3 ls s3://${S3_BUCKET}/terraform.tfstate", returnStatus: true) == 0
                        
                        if (fileExists) {
                            
                            sh 'aws s3 cp s3://${S3_BUCKET}/terraform.tfstate ./terraform.tfstate'
                        
                        }
                }
            }
        }
    */   
        stage('Terraform Plan') {
            steps {
                script {
                    sh '''
                    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_ID}
                    export AWS_REGION=${AWS_DEFAULT_REGION}
                    terraform plan -out=tfplan
                    '''
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    sh '''
                    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY_ID}
                    export AWS_REGION=${AWS_DEFAULT_REGION}
                    terraform apply -auto-approve "tfplan"
                    '''
                }
            }
        }
        
    /*    
        stage('Terraform Tftate Upload') {
            steps {
                script {
                    sh 'aws s3 cp terraform.tfstate s3://${S3_BUCKET}'
                }
            }
        }
    */    

    }
    
    post {
        always {
            cleanWs()
        }
    }
    
}
