# dj-controller

dj-controller manage tracks and their pods.

Setup template deployment and CRDs for dj-kubelet/console

```
docker build -t dj-controller .
kind load docker-image --name dj-kubelet dj-controller:latest

kubectl create namespace dj-controller
kubectl apply -k ./development
```
