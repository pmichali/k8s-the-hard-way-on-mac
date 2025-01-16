One you have a VM created, by following the steps from my blog:

https://blog.michali.net/2025/01/16/kubernetes-the-harder-way/

have SSHed into the VM, cloned this repo, and chdir to the repo area,
follow these steps from inside the VM...

(1)
Run prepare.bash to create SSH keys, build.bash to build image and create network.
Run run.bash NAME to run container in background.

./run.bash jumpbox
./run.bash server
./run.bash node-0
./run.bash node-1

while read IP FQDN HOST SUBNET; do
    echo "Node ${HOST}" ;
    docker exec ${HOST} /bin/bash -c ./set-known-hosts.bash
done < machines.txt


(2)
docker exec jumpbox /bin/bash -c ./jumpbox-install.bash
docker exec -it jumpbox /bin/bash

(3)
Nothing to do here. Can verify ssh from jumpbox to other nodes.

(4)
On jumpbox, do contents of CA-certs.bash and then distribute-certs.bash.

(5)
On jumpbox, do contents of kubeconfig-create.bash and then distribute-kubeconfigs.bash.

(6)
On jumpbox, do contents of encryption.bash.

(7)
Starting on jumpbox, do contents of etcd.bash, which involves SSHing into server, part way in.

(8)
Starting on jumpbox, do contents of bootstrap-controllers.bash, which involves SSHing into server, part way in.

9) On jumpbox, do contents of bootstrap-workers.bash.
