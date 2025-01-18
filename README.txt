One you have a VM created, by following the steps from my blog (TRY #3):

https://blog.michali.net/2025/01/16/kubernetes-the-harder-way/

After pulling this repo on your Mac, and changing to the directory, you can
follow these steps...

1) Prerequisites
Run init.bash to create the podman machine and start it up.
Run prepare.bash to create SSH keys, build.bash to build image and create network.
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




9) On jumpbox, do contents of bootstrap-workers.bash.
