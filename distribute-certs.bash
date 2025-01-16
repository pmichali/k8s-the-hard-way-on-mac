cd ~/kubernetes-the-hard-way
for host in node-0 node-1; do
  ssh root@$host mkdir /var/lib/kubelet/
  
  scp ca.crt root@$host:/var/lib/kubelet/
    
  scp $host.crt \
    root@$host:/var/lib/kubelet/kubelet.crt
    
  scp $host.key \
      root@$host:/var/lib/kubelet/kubelet.key

  echo "Copied certs and private keys to ${host}"
done

scp \
  ca.key ca.crt \
  kube-api-server.key kube-api-server.crt \
  service-accounts.key service-accounts.crt \
  root@server:~/
echo "Copied certs and private keys to server"
