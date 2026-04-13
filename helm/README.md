# Helm — Hello Chart Deployment

This folder contains a simple **Helm chart** (`hello-chart`) used to deploy an example workload (NGINX) onto the AKS cluster.

---

## 🧩 Structure

```
hello-chart/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── _helpers.tpl
    ├── configmap.yaml
    ├── deployment.yaml
    ├── ingress.yaml
    └── service.yaml
```

---

## ⚙️ Configuration

Key parameters in `values.yaml`:

| Parameter          | Description                             | Default                            |
| ------------------ | --------------------------------------- | ---------------------------------- |
| `replicaCount`     | Number of pod replicas                  | `1`                                |
| `service.type`     | Service type (LoadBalancer / ClusterIP) | `LoadBalancer`                     |
| `image.repository` | Container image                         | `nginxnginxinc/nginx-unprivileged` |
| `image.tag`        | Image tag                               | `stable`                           |

Example override:

```bash
helm upgrade --install hello ./hello-chart   --namespace hello --create-namespace   --set replicaCount=2
```

---

## 🧪 Validation

```bash
kubectl get pods -n hello
kubectl get svc -n hello
```

Access the service via the **EXTERNAL-IP** from the LoadBalancer.

---

## 🔮 Improvements

- Add `kubectl rollout status` in CI/CD for verification
- Enable ingress by default with self-signed TLS
- Add `helm test` suite for smoke checks
