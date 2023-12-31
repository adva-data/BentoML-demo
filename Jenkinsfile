pipeline {
    agent any

    environment {
        // Define environment variables here
        AWS_REGION = 'eu-west-3'
        AWS_ACCOUNT_ID = '269147060643'
        ECR_REPO_NAME = 'email_pulses'
        BENTOML_SERVICE_NAME = 'iris_classifier'
        BENTO_SERVICE_VERSION= 'latest'
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"

          // PATH = "$PATH:/usr/local/bin"
    }




     stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId:'', url: 'https://github.com/adva-data/BentoML-demo']]])     
            }
        }

 

        stage('Install BentoML') {
            steps {
                // Install BentoML using pip
                
                // sh 'pip install bentoml'
                // sh 'pip install "bentoml[all]"'
                // sh 'pip install git+https://github.com/bentoml/bentoml'
                
                // sh 'git clone https://github.com/bentoml/bentoml.git'
                // sh 'cd bentoml'
                // sh 'pip install -e .'
                sh 'echo $PATH'
                sh "ls"
                sh "echo the pwd"
                sh "pwd"
               
                
                // Build the docker image using the defined service name and version
                script {
                     sh "pip install bentoml --pre -U"
                    }

                
                // script {
                // sh "bentoml containerize $BENTOML_SERVICE_NAME:$BENTO_SERVICE_VERSION -t $ECR_REPO_NAME:$BENTO_SERVICE_VERSION"
                // }
                  
            }
            
        }



          stage("Build docker image using BentoML"){
              steps{  
                   script {
                    sh "bentoml containerize $BENTOML_SERVICE_NAME:$BENTO_SERVICE_VERSION -t $ECR_REPO_NAME:$BENTO_SERVICE_VERSION"
                    }
              }
          }

         

    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
      }

 // Uploading Docker images into AWS ECS
      stage ('Updating ECS service') {
            steps {
                script {
                    sh """
                        aws ecs update-service --cluster email_pulses_clusrter --service email_pulses --force-new-deployment
                    """
                }
            }
        }
    }

}
