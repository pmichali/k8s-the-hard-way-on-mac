set -x
podman cp CA-certs.bash jumpbox:/root/
podman cp distribute-certs.bash jumpbox:/root/

podman cp kubeconfig-create.bash jumpbox:/root/
podman cp distribute-kubeconfigs.bash jumpbox:/root/

podman cp encryption.bash jumpbox:/root/

podman cp etcd-files.bash jumpbox:/root/
podman cp etcd-config.bash server:/root/

podman cp push-controller-settings.bash jumpbox:/root/
podman cp bootstrap-controllers.bash server:/root/

podman cp push-worker-settings.bash jumpbox:/root/
podman cp bootstrap-workers.bash node-0:/root/
podman cp bootstrap-workers.bash node-1:/root/

podman cp remote-access.bash jumpbox:/root/

podman cp set-routes.bash jumpbox:/root/
