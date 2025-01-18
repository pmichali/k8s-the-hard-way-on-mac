podman cp CA-certs.bash jumpbox:/root/
podman cp distribute-certs.bash jumpbox:/root/

podman cp kubeconfig-create.bash jumpbox:/root/
podman cp distribute-kubeconfigs.bash jumpbox:/root/

podman cp encryption.bash jumpbox:/root/

podman cp etcd-files.bash jumpbox:/root/
podman cp etcd-config.bash server:/root/

podman cp push-controller-settings.bash jumpbox:/root/
podman cp bootstrap-controllers.bash server:/root/
