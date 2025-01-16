known_hosts=""
NL=$'\n'
while read IP FQDN HOST SUBNET; do
    this_host=$(ssh-keyscan ${HOST} 2> /dev/null | grep ssh-rsa)
    if [ -z "${this_host}" ]; then
	echo "Cannot find host key for ${HOST}"
    else
	known_hosts="${known_hosts}${NL}${this_host}"
    fi
done < machines.txt
echo "Obtained all host keys"
echo "${known_hosts}" > ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts
echo "Created known hosts"
ssh-keygen -Hf ~/.ssh/known_hosts
echo "Hashed known hosts"
