
more_hosts=""
while read IP FQDN HOST SUBNET; do
    if [ "${HOST}" == "$1" ]; then
	my_ip="${IP}"
    else
	more_hosts="${more_hosts} --add-host ${HOST}:${IP} --add-host ${HOST}.kubernetes.local:${IP}"
    fi
done < machines.txt

docker run -d --rm -h $1 --domainname kubernetes.local --name $1 --ip ${my_ip} ${more_hosts} --net k8snet pmichali/node:v0.1.0
docker exec $1 mv .ssh/$1_id_rsa .ssh/id_rsa
docker exec  $1 mv .ssh/$1_id_rsa.pub .ssh/id_rsa.pub


