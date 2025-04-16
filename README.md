
# k8s-apps

This repository contains Kubernetes deployment configurations for multiple applications, managed using **Argo CD** in a GitOps-style workflow.

---

## 📦 Project Structure

```
k8s-apps/
├── apps/
│   ├── default/
│   │   └── argocd-app-template.yaml     # Template for Argo CD apps
│   ├── fullstackapp/
│   │   ├── Helm chart: backend, frontend, postgres
│   │   └── values.yaml
│   └── sw-movie/
│       ├── Raw Kubernetes YAMLs
│       ├── MongoDB resources
│       └── README.md
├── argocd/
│   ├── fullstackapp/
│   │   └── fullstackapp-app-argocd.yaml
│   └── sw-movie/
│       └── sw-movie-app-argocd.yaml
└── README.md  (this file)
```

---

## 🚀 Applications

### 🧱 Fullstack App

- React frontend + Flask backend + PostgreSQL DB
- Managed via Helm chart (umbrella)
- Argo CD syncs from `apps/fullstackapp/`

### 🌌 SW Movie App

- Node.js + Express + MongoDB
- Managed via raw Kubernetes YAMLs in `apps/sw-movie/`
- Auto-deployed using Argo CD app definition in `argocd/sw-movie/`

---

## 🛠️ Deployment Instructions

### 1. Clone This Repo

```bash
git clone https://github.com/<your-username>/k8s-apps.git
cd k8s-apps
```

### 2. Apply Argo CD App

```bash
kubectl apply -f argocd/fullstackapp/fullstackapp-app-argocd.yaml -n argocd
kubectl apply -f argocd/sw-movie/sw-movie-app-argocd.yaml -n argocd
```

Argo CD will sync the app and deploy its manifests to the cluster.

---

## 🧪 Testing Access

### Fullstack App

```bash
kubectl port-forward svc/fullstackapp-frontend 3000:80 -n fullstack
```

Visit [http://localhost:3000](http://localhost:3000)

### SW Movie App

```bash
kubectl port-forward svc/sw-movie-app 8080:80 -n sw-movie
```

Then test:

```bash
curl http://localhost:8080/movies
```

---

## 🔄 Auto Sync (Argo CD)

Both Argo CD apps have automated sync enabled:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

Changes to this repo will trigger auto-deployments.

---

## 📌 Notes

- Make sure your Docker images exist and are accessible in your manifests or Helm values.
- Use `imagePullPolicy: Always` or unique tags (e.g., `1.0.0`, `sha256`) for CI/CD pipelines.
- Argo CD will automatically create namespaces if `syncOptions: [CreateNamespace=true]` is set.

---

## 🧩 Related Repos

- [sw-movie-app](https://github.com/<your-username>/sw-movie-app)
- [fullstackapp](https://github.com/<your-username>/fullstackapp)

