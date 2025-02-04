pipeline{
    agent any
    environment {
        GIT_REPO_URL = 'https://github.com/varmaaradhula/Project-Jenkins-Infra.git'
        GIT_BRANCH = 'master'
        S3_BUCKET = 'vprofile-terraform-state'
        TF_PATH = 'terraform'
        S3_KEY = 'terraform/state/terraform.tfstate'
        AWS_REGION = 'eu-west-2'
       // AWS_CREDENTIALS = credentials('awscreds')
        TERRAFORM_APPLY_STATUS = 'false'
        GET_KUBECONFIG_STATUS = 'false'
    }

    stages{

        stage('Checkout code from Git Repo'){

            steps{
                echo "Checking out terraform repo from GitHub"

                git branch: "${GIT_BRANCH}", url: "${GIT_REPO_URL}"
            }
        }

        stage('Config AWS credentials'){
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', 
                     credentialsId: 'awscreds'] // Replace with your Jenkins credential ID
                ]) {
                    script {
                        // AWS credentials will be available as environment variables
                        sh '''
                        echo "Configuring AWS CLI"
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region ${AWS_REGION}
                        '''
                    }
                }
            }
        }

        stage('Intiate Terraform'){
            steps {
                echo 'Intiating Terraform'
                dir("${TF_PATH}"){

                    script{
                        sh '''
                        terraform init \
                          -backend-config="bucket=${S3_BUCKET}"
                          '''
                    }
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                dir("${TF_PATH}"){
                    script{
                sh 'terraform validate'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform and getting output file'
                dir("${TF_PATH}"){
                    script{
                        sh '''
                        terraform plan \
                          -out=tfplan.out
                        '''
                    }
                }
                    }
                }

        stage('Terraform Apply') {
            steps {
                echo ' Applying terraform plan'
                dir("${TF_PATH}"){
                    script{
                sh 'terraform apply tfplan.out'
                    }
                }
            }
            post {
                success {
                    script {
                        // Set a shared variable to indicate success
                        currentBuild.description = 'Terraform Apply Success'
                        env.TERRAFORM_APPLY_STATUS = 'true'
        }
                }
            }
        }

        stage('Wait Before Proceeding') {
            steps {
               echo 'Waiting for 120 seconds before proceeding...'
               sleep(time: 120, unit: 'SECONDS')  // Adjust time as needed
    }
}

        stage('Retrieve Kubeconfig') {
            steps {
                sh '''
                # Example for AWS EKS
                aws eks update-kubeconfig --region ${AWS_REGION} --name 'Prome-EKS-Cluster'
                '''
            }
        }
        stage('Install kubectl') {
            steps {
                script {
                    sh 'sudo curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'
                    sh 'sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl'
                    sh "sudo chmod +x kubectl"
                    sh "sudo mkdir -p ~/.local/bin"
                    sh 'sudo mv ./kubectl ~/.local/bin/kubectl'
                }
            }
        }

        stage('Install Ingress Controller') {
            steps {
                sh '''
                # Install NGINX Ingress Controller using kubectl
                # Install
                kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
                '''
            }

            

        }


                
        }
}