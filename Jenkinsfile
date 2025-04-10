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
        echo "Deploying sw-movie-app via Argo CD..."
        withCredentials([string(credentialsId: 'argocd-token', variable: 'ARGOCD_AUTH_TOKEN')]) {
            sh '''
                echo "$ARGOCD_AUTH_TOKEN" | argocd login k8s.orb.local --auth-token=$ARGOCD_AUTH_TOKEN --grpc-web --insecure
            '''
        }
        // Trigger a sync of the sw-movie-app Argo CD Application.
        sh "argocd app sync sw-movie-app"
        // Optionally, wait until the application is fully synced and healthy.
        sh "argocd app wait sw-movie-app --sync --health --timeout 300"
    }

    stage('Post Deployment') {
        echo "Deployment triggered successfully. Check Argo CD for the updated sw-movie-app status."
    }
}
