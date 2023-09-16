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
                CHARTNAME = 'nginx-microservice-dev'                
                NODEPORT_NGINX = '30000'
                CLUSTERIP_MOVIE = '10.43.50.0'
                CLUSTERIP_CAST = '10.43.50.1'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install $CHARTNAME  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE"  --set nginx.service.nodePort="$NODEPORT_NGINX" --set movie.service.clusterIP="$CLUSTERIP_MOVIE" --set cast.service.clusterIP="$CLUSTERIP_CAST"
                    '''
                }
            }
        }
        stage('Test deploiement en dev')
        {    
            environment
            {
                NODEPORT_NGINX = '30000'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 90
                    curl "http://localhost:$NODEPORT_NGINX"
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
                CHARTNAME = 'nginx-microservice-qa'                
                NODEPORT_NGINX = '30001'
                CLUSTERIP_MOVIE = '10.43.51.0'
                CLUSTERIP_CAST = '10.43.51.1'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install $CHARTNAME  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE"  --set nginx.service.nodePort="$NODEPORT_NGINX" --set movie.service.clusterIP="$CLUSTERIP_MOVIE" --set cast.service.clusterIP="$CLUSTERIP_CAST"
                    '''
                }
            }
        }
        stage('Test deploiement en qa')
        {    
            environment
            {
                NODEPORT_NGINX = '30001'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 90
                    curl "http://localhost:$NODEPORT_NGINX"
                    '''
                }
            }            
        }
        stage('Deploiement en staging')
        {
            environment
            {
                KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                NAMESPACE = 'staging'
                CHARTNAME = 'nginx-microservice-staging'                
                NODEPORT_NGINX = '30002'
                CLUSTERIP_MOVIE = '10.43.52.0'
                CLUSTERIP_CAST = '10.43.52.1'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install $CHARTNAME  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE"  --set nginx.service.nodePort="$NODEPORT_NGINX" --set movie.service.clusterIP="$CLUSTERIP_MOVIE" --set cast.service.clusterIP="$CLUSTERIP_CAST"
                    '''
                }
            }
        }
        stage('Test deploiement en staging')
        {    
            environment
            {
                NODEPORT_NGINX = '30002'
            }
            steps 
            {
                script 
                {
                    sh '''
                    sleep 90
                    curl "http://localhost:$NODEPORT_NGINX"
                    '''
                }
            }            
        }
        stage('Deploiement en prod')
        {
            when 
            {
                branch 'master'
            }            
            input
            {
                message "Confirmer le deployment en prod"
            }
            environment
            {
                KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                NAMESPACE = 'prod'
                CHARTNAME = 'nginx-microservice-prod'                
                NODEPORT_NGINX = '30003'
                CLUSTERIP_MOVIE = '10.43.53.0'
                CLUSTERIP_CAST = '10.43.53.1'
            }
            steps 
            {
                script 
                {
                    sh '''
                    cat $KUBECONFIG > k8s_config
                    helm upgrade --kubeconfig k8s_config --install $CHARTNAME  helm/nginx-microservice/ --values=helm/nginx-microservice/values.yaml --set nameSpace="$NAMESPACE"  --set nginx.service.nodePort="$NODEPORT_NGINX" --set movie.service.clusterIP="$CLUSTERIP_MOVIE" --set cast.service.clusterIP="$CLUSTERIP_CAST"
                    '''
                }
            }
        }
        stage('Test deploiement en prod')
        {    
            environment
            {
                NODEPORT_NGINX = '30003'
            }
            
            steps 
            {
                script 
                {
                    sh '''
                    sleep 90
                    curl "http://localhost:$NODEPORT_NGINX"
                    '''
                }
            }            
        }        
    }
}