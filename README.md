# ycrash-k8s

## Setup

1. Clone the repo: 

   ```sh
	SSH - git clone git@github.com:ycrash/ycrash-k8s.git
	HTTPS - git clone https://github.com/ycrash/ycrash-k8s.git
   
	cd ycrash-k8s
   ```

2. Download `license.lic` and put it into this directory
3. Copy `yc-agent-config.yaml.template` to `yc-agent-config.yaml` and set the values.


## Run locally with docker-compose

### Pre-requisite:

- [docker-compose installed](https://docs.docker.com/compose/install/)

### How to run

```sh
docker-compose up -d
```

Then see the services and the ports exposed:

```sh
docker-compose ps
```


## Run locally with Docker (Without docker-compose)

1. To build images:

   ```sh
   docker build -t ycrash ./docker-images/ycrash
   docker build -t buggyapp ./docker-images/buggyapp
   ```

2. To run the container locally:

   ```sh
   docker run -ti --rm -p 8080:8080 --name ycrash -v $(pwd)/license.lic:/opt/workspace/yc/license.lic ycrash
   ```

   ```sh
   docker run -ti --rm -p 9010:9010 -p 8085:8085 --name buggyapp -v $(pwd)/yc-agent-config.yaml:/opt/workspace/yc/agent/config.yaml buggyapp
   ```

   Then open http://localhost:8080 and http://localhost:9010



## Run on Kubernetes

Kubernetes manifests (yaml) resides in `kubernetes/` directory.

1. Copy `kubernetes/yc-license-secret.yaml.template` to `kubernetes/yc-license-secret.yaml`

   ```
   cp kubernetes/yc-license-secret.yaml.template kubernetes/yc-license-secret.yaml
   ```

2. Edit `kubernetes/yc-license-secret.yaml` and replace the license template with the real one.


3. Copy `kubernetes/buggyapp-secret.yaml.template` to `kubernetes/buggyapp-secret.yaml`

   ```
   cp kubernetes/buggyapp-secret.yaml.template kubernetes/buggyapp-secret.yaml
   ```

4. Edit `kubernetes/buggyapp-secret.yaml` and set the appropriate value

5. Assuming you have a running kubernetes cluster and kubectl ready to access the cluster, next step is to just run:

   ```
   kubectl apply -f kubernetes/ -R
   ```

   to verify the pods are running:

   ```
   kubectl get pods
   ```

6. There are a few ways of exposing a service in kubernetes to the outside. But for the initial scope, we can access it privately with port-forward:

   ```
   kubectl port-forward deployment/yc-web 8080
   ```

   ```
   kubectl port-forward deployment/buggyapp 9010 8085
   ```

7. Then the ycrash service should be accessible from http://localhost:8080 and buggyapp should be accessible from http://localhost:9010



## Notes

- Kubernetes deployment yaml is working. It's the simplest implementation, which is easy for initial review but not yet "production ready".
