{
  apt-get update
  apt-get -y install socat conntrack ipset
}
echo "Installed OS dependencies"

swapon --show
swapoff -a    <--- does not work.

# Will try with swap on. If issue, run containers with --memory and --memory-swap set to the same value.
# Concern will be over Mac memory, as they suggest 2GB for nodes.

mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes
echo "Created installation directories"

{
  mkdir -p containerd
  tar -xvf crictl-v1.31.1-linux-arm64.tar.gz
  tar -xvf containerd-2.0.0-linux-arm64.tar.gz -C containerd
  tar -xvf cni-plugins-linux-arm64-v1.6.0.tgz -C /opt/cni/bin/
  mv runc.arm64 runc
  chmod +x crictl kubectl kube-proxy kubelet runc 
  mv crictl kubectl kube-proxy kubelet runc /usr/local/bin/
  mv containerd/bin/* /bin/
}
echo "Installing binaries"

mv 10-bridge.conf 99-loopback.conf /etc/cni/net.d/
echo "Created bridge config"

{
  mkdir -p /etc/containerd/
  mv containerd-config.toml /etc/containerd/config.toml
  mv containerd.service /etc/systemd/system/
  cp services/containerd /etc/init.d/
  cp defaults/containerd /etc/default/
}
echo "Configured containerd"

{
  mv kubelet-config.yaml /var/lib/kubelet/
  mv kubelet.service /etc/systemd/system/
  cp services/kubelet /etc/init.d/
  cp defaults/kubelet /etc/default/
}
echo "Configured kubelet"

{
  mv kube-proxy-config.yaml /var/lib/kube-proxy/
  mv kube-proxy.service /etc/systemd/system/
  cp services/kube-proxy /etc/init.d/
  cp defaults/kube-proxy /etc/default/
}
echo "Configured kube-proxy"

update-rc.d containerd defaults
update-rc.d kubelet defaults
update-rc.d kube-proxy defaults

service containerd start
service kubelet start
service kube-proxy start

service --status-all
