#!bin/groovy

def imageName = param.imageName "pkonieczny321/sw-movie-app"
def imageTag = param.imageTag "1.0.0"
def skipBuild = false

/** DEBUG
def imageName = "pkonieczny321/sw-movie-app"
def imageTag = "1.0.0"
def skipBuild = false
**/

node('docker-agent') {
    stage('Check if Docker Tag Exists') {
        echo "Checking if ${imageName}:${imageTag} already exists on Docker Hub..."
        def status = sh (
            script: """
                curl --silent --fail https://hub.docker.com/v2/repositories/${imageName}/tags/${imageTag}/ > /dev/null
            """,
            returnStatus: true
        )
        if (status == 0) {
            echo "Docker image ${imageName}:${imageTag} already exists. Skipping build & push."
            skipBuild = true
        } else {
            echo "Docker image tag does not exist. Proceeding with build."
        }
    }

    stage('Checkout App Source') {
        echo "Checking out sw-movie-app repository..."
        dir('sw-movie-app') {
            checkout([
                $class: 'GitSCM',
                branches: [[name: '*/main']],
                userRemoteConfigs: [[
                    url: 'https://github.com/lolek1979/sw-movie-app.git',
                    credentialsId: 'github-creds'
                ]]
            ])
        }
    }

    stage('Checkout K8s Manifests') {
        echo "Checking out sw-movie-app-k8s repository..."
        dir('sw-movie-app-k8s') {
            checkout([
                $class: 'GitSCM',
                branches: [[name: '*/main']],
                userRemoteConfigs: [[
                    url: 'https://github.com/lolek1979/sw-movie-app-k8s.git',
                    credentialsId: 'github-creds'
                ]]
            ])
        }
    }
    if (!skipBuild) {
        stage('Build Docker Image') {
            echo "Building Docker image ${imageName}:${imageTag}..."
            dir('sw-movie-app') {
                sh "docker build -t ${imageName}:${imageTag} ."
            }
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
    }

    stage('Deploy Argo CD Application') {
        dir('sw-movie-app-k8s') {
            sh 'kubectl apply -f argo-apps/sw-movie-app-argo.yaml -n argocd'
        }
    }

    stage('Post Deployment') {
        echo "Deployment triggered successfully. Check Argo CD for the updated sw-movie-app status."
    }
}