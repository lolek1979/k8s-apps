#!/usr/bin/groovy

// def imageName = param.imageName
// def imageTag = param.imageTag
def imageName = "pkonieczny321/sw-movie-app"
def imageTag = "1.0.0"
/** DEBUG
def imageName = "pkonieczny321/sw-movie-app"
def imageTag = "1.0.0"
**/
node('docker-agent') {
    // Define image details. You can change the tag as needed (here it's hard-coded to "1.0.0")


    stage('Checkout') {
        echo "Checking out sw-movie-app repository..."
        checkout([
            $class: 'GitSCM',
            branches: [[name: '*/main']],  // Adjust branch if needed
            userRemoteConfigs: [[
                url: 'https://github.com/lolek1979/sw-movie-app.git',
                credentialsId: 'github-creds'
            ]]
        ])
    }

    stage('Build Docker Image') {
        echo "Building Docker image ${imageName}:${imageTag}..."
        // Use the docker CLI available in the container to build the image.
        sh "docker build -t ${imageName}:${imageTag} ."
    }

    stage('Push Docker Image') {
        echo "Logging in to Docker Hub and pushing the image..."
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
        sh '''
            echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
        '''
        }
        sh "docker push ${imageName}:${imageTag}"
    }

    stage('Deploy Argo CD Application') {
        withCredentials([string(credentialsId: 'KUBECONFIG_CONTENT', variable: 'KUBECONFIG_CONTENT')]) {
            writeFile file: 'kubeconfig.yaml', text: env.KUBECONFIG_CONTENT
            withEnv(["KUBECONFIG=${env.WORKSPACE}/kubeconfig.yaml"]) {
                sh '''
                # Apply the Application YAML to register it with Argo CD
                kubectl apply -f argo-apps/sw-movie-app-argo.yaml -n argocd
                '''
            }
        }
    }
    stage('ArgoCD sync/health apps') {
        withCredentials([string(credentialsId: 'argocd-token', variable: 'ARGOCD_TOKEN')]) {
        sh '''
            # Sync the application
            argocd app sync sw-movie-app \
            --grpc-web --insecure \
            --auth-token "$ARGOCD_TOKEN" \
            --server k8s.orb.local

            # Wait until the app is healthy
            argocd app wait sw-movie-app \
            --health \
            --timeout 120 \
            --grpc-web --insecure \
            --auth-token "$ARGOCD_TOKEN" \
            --server k8s.orb.local
        '''
        }
    }

    stage('Post Deployment') {
        echo "Deployment triggered successfully. Check Argo CD for the updated sw-movie-app status."
    }
}
