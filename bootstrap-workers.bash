{
  apt-get update
  apt-get -y install socat conntrack ipset
}
echo "Installed OS dependencies"

if [ -z `swapon --show` ]; then
    echo "Swap is OFF, as desired"
else
    # NOTE: With podman, may be able to run container with --memory and --memory-swap with same value
    echo "Swap is on - run the following to disable, and then consult OS doc to disable permanently:"
    echo "    swapoff -a"
    exit 1
fi

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
  sed -i '/ExecStartPre=.*modprobe overlay/d' containerd.service
  mv containerd.service /etc/systemd/system/
}
echo "Configured containerd"

{
  mv kubelet-config.yaml /var/lib/kubelet/
  mv kubelet.service /etc/systemd/system/
}
echo "Configured kubelet"

{
  mv kube-proxy-config.yaml /var/lib/kube-proxy/
  mv kube-proxy.service /etc/systemd/system/
}
echo "Configured kube-proxy"

{
  systemctl daemon-reload
  systemctl enable containerd kubelet kube-proxy
  systemctl start containerd kubelet kube-proxy
}
echo "Started worker services"
