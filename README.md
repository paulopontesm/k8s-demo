# K8s Demo

This project can be used as a reference to deploy a simple flask application running in AWS in Kubernetes.

The stack for this example is the following:

- [Docker](https://docs.docker.com/get-started/)
- A [Kubernetes](https://kubernetes.io/docs/setup/) "cluster" running in a [Ubuntu](https://ubuntu.com/) machine with [Microk8s](https://microk8s.io/#get-started) on [AWS EC2](https://aws.amazon.com/pt/ec2/)
- [Helm](https://helm.sh/)
- [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Certmanager](https://cert-manager.io/docs/) + [Let’s Encrypt](https://letsencrypt.org/) for TLS
- [GitHub Actions](.github/workflows/deploy.yml) for CI/CD

## Our application

For reference this repository uses the [Flask Minimal Application](https://flask.palletsprojects.com/en/1.1.x/quickstart/#a-minimal-application) that returns a simple "Hello world".

```bash
$ flask run
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
```

Also, when starting the application we are warned by Flask to `Use a production WSGI server instead`. There are [many ways](https://flask.palletsprojects.com/en/1.1.x/deploying/) to deploy a flask app, but since our goal is to use it in a docker container, let's use one of the recommended [Standalone WSGI Containers](https://flask.palletsprojects.com/en/1.1.x/deploying/wsgi-standalone/), in our case [Gunicorn](https://gunicorn.org/).

```bashq
$ gunicorn -w 4 --bind 0.0.0.0:5000 app:app
[2020-05-23 18:50:56 +0100] [14880] [INFO] Starting gunicorn 20.0.4
[2020-05-23 18:50:56 +0100] [14880] [INFO] Listening at: http://0.0.0.0:5000 (14880)
[2020-05-23 18:50:56 +0100] [14880] [INFO] Using worker: sync
[2020-05-23 18:50:56 +0100] [14883] [INFO] Booting worker with pid: 14883
[2020-05-23 18:50:56 +0100] [14884] [INFO] Booting worker with pid: 14884
[2020-05-23 18:50:56 +0100] [14885] [INFO] Booting worker with pid: 14885
[2020-05-23 18:50:56 +0100] [14886] [INFO] Booting worker with pid: 14886
```

## Create a Docker Image

The definition for the Docker image can be found in the [Dockerfile](Dockerfile).

As a base image for our docker image we are using one of the [official docker images](https://hub.docker.com/_/python/) for python. For our application we use the tag `python:3.8-slim-buster`. The `3.8` stands for the python version, the `buster` stands for the [version of debian](https://www.debian.org/releases/buster/) that is used as the underlying image, and the `slim` stands for the [image variant](https://hub.docker.com/_/debian?tab=description) of debian which is more or less half the size as the "full fledged" debian image.

Other than that we just need to copy our `requirements.pip` and `app.py` to the workdir of our docker image and define the initial command to be executed when our image is ran.

```bash
$ docker run -it --name k8s-demo k8s-demo:latest
[2020-05-23 19:59:05 +0000] [6] [INFO] Starting gunicorn 20.0.4
[2020-05-23 19:59:05 +0000] [6] [INFO] Listening at: http://0.0.0.0:11130 (6)
[2020-05-23 19:59:05 +0000] [6] [INFO] Using worker: sync
[2020-05-23 19:59:05 +0000] [8] [INFO] Booting worker with pid: 8
[2020-05-23 19:59:05 +0000] [9] [INFO] Booting worker with pid: 9
[2020-05-23 19:59:05 +0000] [10] [INFO] Booting worker with pid: 10
[2020-05-23 19:59:05 +0000] [11] [INFO] Booting worker with pid: 11
```

## Create an Helm Chart

The easiest way to create a chart is by using the `helm create` [command](https://helm.sh/docs/helm/helm_create/#helm).
The default chart already brings some really interesting things that make it easier for us to be following some kubernetes best practices:

- Standard labels that are added to all the kubernetes resources
- A [Deployment](./chart/k8s-demo/templates/deployment.yaml) file with configurable resources, nodeSelectors, affinity and tolerations.
- An [HorizontalPodAutoscaler](./chart/k8s-demo/templates/hpa.yaml) that will add or remove containers/pods based on a target CPU and Memory usage.
- A new [ServiceAccount](chart/k8s-demo/templates/serviceaccount.yaml) specific to our application. By default, new service accounts don't have any permissions.
- A [Service](chart/k8s-demo/templates/service.yaml) to make our application accessible by other pods **inside** the cluster.
- An [Ingress](chart/k8s-demo/templates/ingress.yaml) to make our application accessible **outside** of our cluster.
- A [Helm test](chart/k8s-demo/templates/tests/test-connection.yaml) that can be used to check if our application is running after we install it. By default it runs a simple `$ wget {service.name}:{service.port}`.

In this repository the helm chart can be found under the `chart/` directory.
The only change we need to do to have a working Helm chart is to change the `image.repostory` in the [values.yaml](chart/k8s-demo/values.yaml) to use our docker image.

## Infrastructure

There are thousands of ways of deploying a kubernetes cluster, some are free and some are not.
The goal of this demo is to deploy the application in AWS, and unfortunately AWS doesn't include
their managed Kubernetes solution (AWS EKS) in the free tier.
For this demo we are creating a simple EC2 instance running ubuntu and install MicroK8s which will be
our lightweight kubernetes cluster.

<image>

Everything that is necessary is already being installed in our Ubuntu machine using the UserData that is ran when our machine starts.
Essentially the following is installed:

export AWS_SDK_LOAD_CONFIG=1
cd backend/
terraform init && terraform apply
cd ../main/
terraform init && terraform apply

- Microk8s, with the following plugins enabled:
  - DNS
  - Storage
- Helm
-

```bash
  $ helm repo add stable https://kubernetes-charts.storage.googleapis.com
```

### Usage

<Create a keypair >

<Deploy>

If are looking for a more "Production Ready" solution take a look at the Quickstart provided by AWS to create
the EKS cluster: https://github.com/aws-quickstart/quickstart-amazon-eks.

## Deploying our Application

### Enable TLS

## Github Action
