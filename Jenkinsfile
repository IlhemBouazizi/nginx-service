pipeline 
{
    agent any // Jenkins will be able to select all available agents
    stages 
    {
        stage('Pre-Build')
        { //we pass the built image to our docker hub account
            environment
            {
                DOCKER_PASS = credentials("DOCKER_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
                DOCKER_ID = 'ilhemb'
                BRANCH_NAME = "${GIT_BRANCH.split("/")[1]}"
            }
            steps 
            {
                script 
                {
                    sh '''
                    echo "Pulling $BRANCH_NAME branch"

                    git branch
                    
                    docker login -u $DOCKER_ID -p $DOCKER_PASS
                    '''
                }
            }
        }
        stage('Build')
        { // docker build image stage
            steps {
                script 
                {
                    sh '''
                    echo ""
                    echo "-----  Build nginx service"
                    docker image build webapp/nginx-service/ -t nginx-service:latest
                    docker tag nginx-service ilhemb/nginx-service:latest
                    docker image push ilhemb/nginx-service:latest
                    '''
                }
            }
        }
        stage('Deploiement en dev')
        {
            environment
            {
                KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                NAMESPACE = 'dev'
                NODEPORT = '30100'
                TARGETPORT = '8000'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install nginx-microservice-$NAMESPACE  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE" --set nginx.service.nodePort="$NODEPORT" --set nginx.service.targetPort="$TARGETPORT" --set nginx.service.port="$TARGETPORT"
                    '''
                }
            }
        }
        stage('Test deploiement en dev')
        {    
            environment
            {
                NODEPORT = '30100'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 70
                    curl "http://localhost:$NODEPORT/api/v1/movies/docs"
                    curl "http://localhost:$NODEPORT/api/v1/casts/docs"
                    '''
                }
            }            
        }
        stage('Deploiement en qa')
        {
            environment
            {
                KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                NAMESPACE = 'qa'
                NODEPORT = '30101'
                TARGETPORT = '8001'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install nginx-microservice-$NAMESPACE  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE" --set nginx.service.nodePort="$NODEPORT" --set nginx.service.targetPort="$TARGETPORT" --set nginx.service.port="$TARGETPORT"
                    '''
                }
            }
        }
        stage('Test deploiement en qa')
        {    
            environment
            {
                NODEPORT = '30101'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 70
                    curl "http://localhost:$NODEPORT/api/v1/movies/docs"
                    curl "http://localhost:$NODEPORT/api/v1/casts/docs"
                    '''
                }
            }            
        }
        stage('Deploiement en staging')
        {
            environment
            {
                KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                NAMESPACE = 'dev'
                NODEPORT = '30100'
                TARGETPORT = '8000'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install nginx-microservice-$NAMESPACE  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE" --set nginx.service.nodePort="$NODEPORT" --set nginx.service.targetPort="$TARGETPORT" --set nginx.service.port="$TARGETPORT"
                    '''
                }
            }
        }
        stage('Test deploiement en staging')
        {    
            environment
            {
                NODEPORT = '30100'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 70
                    curl "http://localhost:$NODEPORT/api/v1/movies/docs"
                    curl "http://localhost:$NODEPORT/api/v1/casts/docs"
                    '''
                }
            }            
        }
        stage('Deploiement en prod')
        {
            environment
            {
                KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                NAMESPACE = 'dev'
                NODEPORT = '30100'
                TARGETPORT = '8000'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install nginx-microservice-$NAMESPACE  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE" --set nginx.service.nodePort="$NODEPORT" --set nginx.service.targetPort="$TARGETPORT" --set nginx.service.port="$TARGETPORT"
                    '''
                }
            }
        }
        stage('Test deploiement en prod')
        {    
            environment
            {
                NODEPORT = '30100'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 70
                    curl "http://localhost:$NODEPORT/api/v1/movies/docs"
                    curl "http://localhost:$NODEPORT/api/v1/casts/docs"
                    '''
                }
            }            
        }
    }
}