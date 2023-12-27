# ycrash-k8s

If you want to quickly run the latest yCrash version on Kubernetes then follow steps given [here](https://docs.ycrash.io/ycrash-server/administration/kubernetes.html). 

You can also integrate yCrash with the Prometheus. For more details visit [Integrate yCrash with Prometheus](https://docs.ycrash.io/ycrash-integration/monitoring-tools/prometheus.html#prerequisites) page.

If you wish to build Docker image of yCrash server and run it on Kubernetes by yourself then follow the setps given below:

## Setup

1. Clone the repo: 

   ```sh
	SSH - git clone git@github.com:ycrash/ycrash-k8s.git
	HTTPS - git clone https://github.com/ycrash/ycrash-k8s.git
   
	cd ycrash-k8s
   ```

2. Download `license.lic` and put it into this directory
3. Copy `yc-agent-config.yaml.template` to `yc-agent-config.yaml` and set the values.

	```sh
	cp yc-agent-config.yaml.template yc-agent-config.yaml
	```
	
## Run locally with docker-compose

*Prometheus integration is only supported in kubernetes setup.*

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


## Run locally with Docker with default params (Without docker-compose) 

*Prometheus integration is only supported in a Kubernetes setup. Please note that this option runs with default arguments.*

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
   docker run -ti --rm -p 9010:9010 -p 8085:8085 --name buggyapp -v $(pwd)/yc-agent-config.yaml:/opt/workspace/yc/config.yaml buggyapp
   ```

   Then open http://localhost:8080 and http://localhost:9010
   
## Run locally with Docker passing in runtime params

*The yCrash server parameter is passed during runtime*

1. To build images:

   ```sh
  docker build -t ycrash -f ./docker-images/ycrash/DockerfileNoDefaults .
   ```

2. To run the container locally:

   ```sh
   docker run -ti --rm -p 8080:8080 --name ycrash -v $(pwd)/license.lic:/opt/workspace/yc/license.lic ycrash -Xms2g -Xmx4g -Dapp=yc -DlogDir=. -DuploadDir=. -jar webapp-runner.jar -AconnectionTimeout=3600000 --port 8080 yc.war
   ```
   
The above demonstrates how to pass various parameters, such as Xmx, Xms, -DuploadDir, etc., to the yCrash server during runtime.

## Run on Kubernetes

*If you run containers with the above steps, please stop them first before continuing.*

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
