pipeline {
    agent any

    environment {
        // Define environment variables here
        AWS_REGION = 'your-aws-region'
        AWS_ACCOUNT_ID = 'your-aws-account-id'
        ECR_REPO_NAME = 'your-ecr-repo-name'
        BENTOML_SERVICE_NAME = 'your-bentoml-service-name'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Checkout your GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/yourusername/your-repo.git']]])
            }
        }

        stage('Build Docker Image with BentoML') {
            steps {
                // Install Docker, BentoML, and any other dependencies here
                script {
                    sh "pip install bentoml"
                    sh "bentoml bundle create $BENTOML_SERVICE_NAME:latest /path/to/your/bentoml/service"
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Authenticate with AWS ECR
                    withAWS(credentials: 'your-aws-credentials-id', region: AWS_REGION) {
                        sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
                    }
                    
                    // Tag the Docker image
                    sh "docker tag $BENTOML_SERVICE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest"
                    
                    // Push the Docker image to ECR
                    sh "docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest"
                }
            }
        }

        stage('Deploy to ECS Fargate') {
            steps {
                script {
                    // Deploy to ECS Fargate
                    ecsPush(
                        awsAccessKey: 'your-aws-access-key',
                        awsSecretKey: 'your-aws-secret-key',
                        awsRegion: AWS_REGION,
                        cluster: 'your-ecs-cluster',
                        serviceName: 'your-ecs-service',
                        image: "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:latest",
                        taskDefinitionFile: 'ecs-task-definition.json'
                    )
                }
            }
        }
    }
}
