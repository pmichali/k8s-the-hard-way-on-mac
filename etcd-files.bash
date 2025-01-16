# Run on jumpbox

cd kubernetes-the-hard-way/

scp \
  downloads/etcd-v3.4.34-linux-arm64.tar.gz \
  units/etcd.service \
  root@server:~/
echo "Copied etcd to server"
