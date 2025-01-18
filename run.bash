
more_hosts=""
while read IP FQDN HOST SUBNET; do
    if [ "${HOST}" == "$1" ]; then
	my_ip="${IP}"
    fi
    # Must have FQDN first
    more_hosts="${more_hosts} --add-host ${HOST}.kubernetes.local;${HOST}:${IP}"
done < machines.txt

podman run -d --rm --privileged -h $1 --name $1 --ip ${my_ip} ${more_hosts} --net k8snet localhost/${DOCKER_ID}/node:v0.1.0
podman exec $1 mv .ssh/$1_id_rsa .ssh/id_rsa
podman exec  $1 mv .ssh/$1_id_rsa.pub .ssh/id_rsa.pub


