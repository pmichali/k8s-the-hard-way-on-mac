while read IP FQDN HOST SUBNET; do
    echo "Generating new host keys for ${HOST}" ;
    podman exec ${HOST} find /etc/ssh -name "ssh_host_*" -exec rm {} \;
    podman exec ${HOST} ssh-keygen -A
done < machines.txt
echo "Done generating new host keys"

while read IP FQDN HOST SUBNET; do
    echo "Setting known hosts for ${HOST}" ;
    podman exec ${HOST} /bin/bash -c ./set-known-hosts.bash
done < machines.txt
echo "Created known-hosts"
