Run prepare.bash to create SSH keys, build.bash to build image and create network.
Run run.bash NAME to run container in background.

./run.bash jumpbox
./run.bash server
./run.bash node-0
./run.bash node-1

3) while read IP FQDN HOST SUBNET; do
    echo "Node ${HOST}" ;
    docker exec ${HOST} /bin/bash -c ./set-known-hosts.bash
done < machines.txt

# Prepare jumpbox
2) docker exec jumpbox /bin/bash -c ./jumpbox-install.bash

For SysV services...
docker cp defaults jumpbox:/root/kubernetes-the-hard-way
docker cp services jumpbox:/root/kubernetes-the-hard-way
docker exec jumpbox chown -R root:root /root/


# Access jumpbox
docker exec -it jumpbox /bin/bash

4) On jumpbox, do contents of CA-certs.bash and then distribute-certs.bash.
5) Then, do contents of kubeconfig-create.bash and then distribute-kubeconfigs.bash.
6) Next, do contents of encryption.bash.

7) Then, do contents of etcd.bash, which involves SSHing into server, part way in.

8) On jumpbox, do contents of bootstrap-controllers.bash, which involves SSHing into server, part way in.

9) On jumpbox, do contents of bootstrap-workers.bash.
