# K8s Demo

This project can be used as a reference to deploy a simple flask application using:

- [Docker](https://docs.docker.com/get-started/)
- A [Kubernetes](https://kubernetes.io/docs/setup/) "cluster" running in a [Ubuntu](https://ubuntu.com/) machine with [Microk8s](https://microk8s.io/#get-started) on [AWS EC2](https://aws.amazon.com/pt/ec2/)
- [Helm](https://helm.sh/)
- [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Certmanager](https://cert-manager.io/docs/) + [Let’s Encrypt](https://letsencrypt.org/) for TLS

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
