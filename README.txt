One you have a VM created, by following the steps from my blog (TRY #3):

https://blog.michali.net/2025/01/16/kubernetes-the-harder-way/

After pulling this repo on your Mac, and changing to the directory, you can
follow these steps...

1) Prerequisites
Set environment variable for Docker ID:

export DOCKER_ID=YOUR_DOCKER_USERNAME

Run init.bash to create the podman machine and start it up.
Run prepare.bash to create SSH keys
Run build.bash to build image and create network.
Run run.bash NAME to run container in background.

./run.bash jumpbox
./run.bash server
./run.bash node-0
./run.bash node-1

./known-hosts.bash
./copy-scripts.bash

2) Setting up the Jumpbox
podman exec jumpbox /bin/bash -c ./jumpbox-install.bash

3) Provisioning Compute Resources
Nothing to do here. Can verify ssh from jumpbox to other nodes.

4) Provisioning the CA and Generating TLS Certificates
podman exec -it jumpbox /bin/bash
Invoke CA-certs.bash and then distribute-certs.bash.

5) Generating Kubernetes Configuration Files for Authentication 
Still on jumpbox, invoke kubeconfig-create.bash and then distribute-kubeconfigs.bash.

6) Generating the Data Encryption Config and Key
On jumpbox, invoke encryption.bash.

7) Bootstrapping the etcd Cluster
Starting on jumpbox, invoke etcd-files.bash. From the jumpbox, do "ssh server" to access
the server and then invoke etcd-config.bash.

8) Bootstrapping the Kubernetes Control Plane
Return back to jumpbox (exit), and invoke push-controller-settings.bash.
Next, ssh server and invoke bootstrap-controllers.bash to start up control plane services.
When done, exit to return to jumpbox and verify the controller is working by requesting
the version using the command:

curl -k --cacert ca.crt https://server.kubernetes.local:6443/version

9) Bootstrapping the Kubernetes Worker Nodes
From the jumpbox, invoke push-worker-settings.bash.
Then, ssh to node-0 and node-1 and modify kube-proxy-config.yaml appending:
conntrack:
  maxPerCore: 0

and then invoke bootstrap-workers.bash.

Go back(exit) to jumpbox and check nodes:
ssh server kubectl get nodes -o wide --kubeconfig admin.kubeconfig

10) Configuring kubectl for Remote Access
From the jumpbox, invoke remote-access.bash.

11) Provisioning Pod Network Routes
From jumpbox, invoke set-routes.bash.

12) Smoke Test
Create a secret with:
kubectl create secret generic kubernetes-the-hard-way \--from-literal="mykey=mydata"

Check the secret (output should have k8s:enc:aescbc:v1:key1 at the start):
ssh root@server 'etcdctl get /registry/secrets/default/kubernetes-the-hard-way | hexdump -C'

Create a deployment:
kubectl create deployment nginx --image=nginx:latest

Check that pod is running:
kubectl get all

[FAILURE HERE WITH POD NOT STARTING - failed to create containerd task and shim task]
