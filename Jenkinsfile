	pipeline {
		
		agent any

		environment {
        		ACR_LOGINSERVER = credentials('ACR_LOGINSERVER')
        		ACR_ID = credentials('ACR_ID')
			ACR_PASSWORD = credentials('ACR_PASSWORD')
    		}
		
		stages {
			
			stage ('azure-voting-app-redis - Checkout') {
				steps {
						checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/ViniciusSouza/azure-voting-app-redis']]])
				}
			}
			stage ('Build, Lint, & Unit Test') {
				steps{
						//exectute build, linter, and test runner here    
						sh '''
						echo "exectute build, linter, and test runner here"
						'''
				}
		}
			stage ('Docker Build and Push to ACR'){
				steps{
						
						sh '''
						#Azure Container Registry config
						REPO_NAME="azure-voting-app-redis"
						ACR_LOGINSERVER="myrepo.azurecr.io"
                        ACR_ID="myACRid"
                        ACR_PASSWORD="myACRpassword"
						IMAGE_NAME="$ACR_LOGINSERVER/$REPO_NAME:jenkins${BUILD_NUMBER}"

						#Docker build and push to Azure Container Registry
						cd ./azure-vote
						docker build -t $IMAGE_NAME .
						cd ..
						
						docker login $ACR_LOGINSERVER -u $ACR_ID -p $ACR_PASSWORD
						docker push $IMAGE_NAME
						'''
				}
		}
			stage ('Helm Deploy to K8s'){
				steps{
						sh '''
                        #Docker Repo Config
						REPO_NAME="azure-voting-app-redis"
						ACR_LOGINSERVER="myrepo.azurecr.io"

                    	#HELM config
						NAME="azure-voting-app-redis"
						HELM_CHART="./helm/azure-voting-app-redis"
						
						#Kubenetes config (for safety, in order to make sure it runs in the selected K8s context)
						KUBE_CONTEXT="jenkins-k8s-azure"
						kubectl config --kubeconfig=/var/lib/jenkins/.kube/config view
						kubectl config set-context $KUBE_CONTEXT
						
						#Helm Deployment
						helm --kube-context $KUBE_CONTEXT upgrade --install --force $NAME $HELM_CHART --set image.repository=$ACR_LOGINSERVER/$REPO_NAME --set image.tag=jenkins${BUILD_NUMBER} 
						
						#If credentials are required for pulling docker image, supply the credentials to AKS by running the following:
						#kubectl create secret -n $NAME docker-registry regcred --docker-server=$ACR_LOGINSERVER --docker-username=$ACR_ID --docker-password=$ACR_PASSWORD --docker-email=myemail@contoso.com
						'''
					}
			}	
		}

		post { 
			always { 
				echo 'Build Steps Completed'
			}
		}
	}
