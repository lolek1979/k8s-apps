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

    stage('Deploy via Argo CD') {
        withCredentials([string(credentialsId: 'ARGOCD_AUTH_TOKEN', variable: 'ARGOCD_TOKEN')]) {
        sh '''
            echo "Token length: ${#ARGOCD_TOKEN}"
            argocd login k8s.orb.local --auth-token=$ARGOCD_TOKEN --grpc-web --insecure
            argocd app sync sw-movie-app
            argocd app wait sw-movie-app --health --timeout 120
        '''
        }
    }

    stage('Post Deployment') {
        echo "Deployment triggered successfully. Check Argo CD for the updated sw-movie-app status."
    }
}
