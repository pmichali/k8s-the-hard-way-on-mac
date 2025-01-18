mkdir -p /etc/kubernetes/config

{
   chmod +x kube-apiserver \
    kube-controller-manager \
    kube-scheduler kubectl
    
    mv kube-apiserver \
    kube-controller-manager \
    kube-scheduler kubectl \
    /usr/local/bin/
}
echo "Installed binaries"

{
    mkdir -p /var/lib/kubernetes/

    mv ca.crt ca.key \
    kube-api-server.key kube-api-server.crt \
    service-accounts.key service-accounts.crt \
    encryption-config.yaml \
    /var/lib/kubernetes/
}

mv kube-apiserver.service \
   /etc/systemd/system/kube-apiserver.service
echo "Configured API server"

mv kube-controller-manager.kubeconfig /var/lib/kubernetes/
mv kube-controller-manager.service /etc/systemd/system/
echo "Configured controller manager"

mv kube-scheduler.kubeconfig /var/lib/kubernetes/
mv kube-scheduler.yaml /etc/kubernetes/config/
mv kube-scheduler.service /etc/systemd/system/
echo "Configured scheduler"

{
  systemctl daemon-reload
  
  systemctl enable kube-apiserver \
    kube-controller-manager kube-scheduler
    
  systemctl start kube-apiserver \
    kube-controller-manager kube-scheduler
}
echo "Started services"
sleep 10

echo "Verifying control plane is running"
kubectl cluster-info --kubeconfig admin.kubeconfig


kubectl apply -f kube-apiserver-to-kubelet.yaml \
    --kubeconfig admin.kubeconfig
echo "Created ClusterRole to give access to kubelet API"
