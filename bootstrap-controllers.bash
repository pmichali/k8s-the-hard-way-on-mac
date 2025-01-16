docker exec -it jumpbox /bin/bash

cd kubernetes-the-hard-way/

scp \
  downloads/kube-apiserver \
  downloads/kube-controller-manager \
  downloads/kube-scheduler \
  downloads/kubectl \
  units/kube-apiserver.service \
  units/kube-controller-manager.service \
  units/kube-scheduler.service \
  configs/kube-scheduler.yaml \
  configs/kube-apiserver-to-kubelet.yaml \
  root@server:~/

ssh server mkdir -p services defaults

scp \
  services/kube-apiserver \
  services/kube-controller-manager \
  services/kube-scheduler \
  root@server:~/services/

scp \
  defaults/kube-apiserver \
  defaults/kube-controller-manager \
  defaults/kube-scheduler \
  root@server:~/defaults/



ssh root@server

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
echo "Installed controller binaries"

{
  mkdir -p /var/lib/kubernetes/

  mv ca.crt ca.key \
    kube-api-server.key kube-api-server.crt \
    service-accounts.key service-accounts.crt \
    encryption-config.yaml \
    /var/lib/kubernetes/
}

cp services/kube-apiserver /etc/init.d/
cp defaults/kube-apiserver /etc/default/

echo "Configured API server"

mv kube-controller-manager.kubeconfig /var/lib/kubernetes/

cp services/kube-controller-manager /etc/init.d/
cp defaults/kube-controller-manager /etc/default/

echo "Configured controller manager"

mv kube-scheduler.kubeconfig /var/lib/kubernetes/
mv kube-scheduler.yaml /etc/kubernetes/config/

cp services/kube-scheduler /etc/init.d/
cp defaults/kube-scheduler /etc/default/

echo "Configured scheduler"


update-rc.d kube-apiserver defaults
update-rc.d kube-controller-manager defaults
update-rc.d kube-scheduler defaults

service kube-apiserver start
service kube-controller-manager start
service kube-scheduler start

service --status-all

sleep 10
kubectl cluster-info --kubeconfig admin.kubeconfig
echo "Started controller services:"

kubectl apply -f kube-apiserver-to-kubelet.yaml \
    --kubeconfig admin.kubeconfig
echo "Created ClusterRole to give access to kubelet API"



# Go back to jumpbox to verify
exit

curl -k --cacert ca.crt https://server.kubernetes.local:6443/version

