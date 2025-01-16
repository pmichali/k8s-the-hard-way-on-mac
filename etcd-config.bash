# Run on server node
{
  tar -xvf etcd-v3.4.34-linux-arm64.tar.gz
  mv etcd-v3.4.34-linux-arm64/etcd* /usr/local/bin/
}
echo "Extracted etcd binaries"

{
  mkdir -p /etc/etcd /var/lib/etcd
  chmod 700 /var/lib/etcd
  cp ca.crt kube-api-server.key kube-api-server.crt \
    /etc/etcd/
}
echo "Configured etcd server"

cp services/etcd /etc/init.d/
cp defaults/etcd /etc/default/

update-rc.d etcd defaults
service etcd start
service --status-all

etcdctl member list

echo "Started etcd service"
