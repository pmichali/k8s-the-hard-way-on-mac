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

mv etcd.service /etc/systemd/system/
{
  systemctl daemon-reload
  systemctl enable etcd
  systemctl start etcd
}


etcdctl member list

echo "Started etcd service"
