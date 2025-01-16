mkdir -p keys
rm -rf keys/*
touch keys/authorized_keys
chmod 600 keys/authorized_keys
while read IP FQDN HOST SUBNET; do
    ssh-keygen -t rsa -q -f "keys/${HOST}_id_rsa" -N ""
    cat "keys/${HOST}_id_rsa.pub" >> keys/authorized_keys
done < machines.txt
echo "SSH keys created"


