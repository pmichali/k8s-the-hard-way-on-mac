cd ~/kubernetes-the-hard-way

export ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
echo "Created encryption key"

envsubst < configs/encryption-config.yaml \
	 > encryption-config.yaml
echo "Created encryption config"

scp encryption-config.yaml root@server:~/
echo "Copied encryption config to controller"
