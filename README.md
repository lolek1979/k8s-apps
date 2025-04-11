# sw-movie-app-k8s

Kubernetes deployment manifests for the **Star Wars Movie App** (`sw-movie-app`).  
This repository is designed to be used with **Argo CD** for GitOps-style continuous deployment.

---

## 📦 Project Structure

```
sw-movie-app-k8s/
├── apps/
│   └── sw-movie-app/
│       ├── deployment.yaml              # App Deployment
│       ├── service.yaml                 # App Service
│       ├── mongodb-deployment.yaml      # MongoDB Deployment
│       ├── mongodb-service.yaml         # MongoDB Service
│       └── kustomization.yaml           # Kustomize config (optional)
├── argo-apps/
│   └── sw-movie-app-argo.yaml           # Argo CD Application definition
└── README.md
```

---

## 🚀 What It Deploys

- `sw-movie-app`: A Node.js + Express API app that fetches data from SWAPI and saves favorites in MongoDB.
- `mongodb`: A MongoDB instance to store user favorites.

---

## 🧠 Prerequisites

- Kubernetes cluster (e.g. Minikube, OrbStack, or cloud)
- [Argo CD](https://argo-cd.readthedocs.io/en/stable/) installed and configured
- Docker image built and pushed (e.g. `docker.io/<your-username>/sw-movie-app:latest`)

---

## 🛠️ Deployment Instructions

### 1. Clone This Repo

```bash
git clone https://github.com/<your-username>/sw-movie-app-k8s.git
cd sw-movie-app-k8s
```

### 2. Update Docker Image in `deployment.yaml`

Make sure the container image is correctly set:

```yaml
image: <your-dockerhub-username>/sw-movie-app:latest
```

### 3. Apply Argo CD Application

This creates an Argo CD application that watches this repo.

```bash
kubectl apply -f argo-apps/sw-movie-app-argo.yaml -n argocd
```

Argo CD will then sync and deploy everything from `apps/sw-movie-app/`.

---

## 🔎 Accessing the App

If you're running locally (e.g. Minikube):

```bash
kubectl port-forward svc/sw-movie-app 8080:80
```

Then visit:  
**[http://localhost:8080/movies](http://localhost:8080/movies)**  
**[http://localhost:8080/favorites](http://localhost:8080/favorites)**

---

## 🧪 Example POST to `/favorites`

```bash
curl -X POST http://localhost:8080/favorites \
  -H "Content-Type: application/json" \
  -d '{
        "name": "Luke Skywalker",
        "type": "character",
        "url": "https://swapi.dev/api/people/1/"
      }'
```

---

## 🔄 Argo CD Auto-Sync

The `syncPolicy` is set to:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

So any changes to manifests in this repo will auto-deploy.

---

## 📌 Notes

- MongoDB uses `emptyDir` by default – data won't persist across pod restarts.
- You can improve this setup by adding:
  - Persistent volumes for MongoDB
  - Ingress + TLS via cert-manager
  - Secrets for DB connection string

---

## 📎 Related Repos

- App source code: [sw-movie-app](https://github.com/<your-username>/sw-movie-app)
