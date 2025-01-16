cd ~/kubernetes-the-hard-way

for host in node-0 node-1; do
  ssh root@$host "mkdir -p /var/lib/{kube-proxy,kubelet}"
  
  scp kube-proxy.kubeconfig \
    root@$host:/var/lib/kube-proxy/kubeconfig \
  
  scp ${host}.kubeconfig \
    root@$host:/var/lib/kubelet/kubeconfig

  echo "Distributed kubeconfig for ${host}"
done

scp admin.kubeconfig \
  kube-controller-manager.kubeconfig \
  kube-scheduler.kubeconfig \
  root@server:~/
echo "Distributed kubeconfigs for server"
