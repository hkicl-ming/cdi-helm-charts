# CDI [Helm](https://helm.sh) Charts

This repository contains [Helm](https://helm.sh) charts for CDI AWS projects

* [Argo CD](charts/argocd/)

## Installing Charts from this Repository

Add the Repository to Helm:
```
helm repo add cdi-helm-charts https://hkicl-ming.github.io/cdi-helm-charts
```

### ArgoCD

Install ArgoCD:
```
helm install cdi-helm-charts/argocd
```

### Reference
- Custom Helm Repo
[Paul Czarkowski : Creating a Helm Chart Repository - Part 1](https://tech.paulcz.net/blog/creating-a-helm-chart-monorepo-part-1/)

- GitHub Action on Helm Chart Release
[Chart Releaser Action](https://github.com/helm/chart-releaser-action)

- Helm Chart Release
[Chart Releaser](https://github.com/helm/chart-releaser)
