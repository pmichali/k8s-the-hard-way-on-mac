podman build . -t ${DOCKER_ID}/node:v0.1.0
echo "Image built"

have_net=$(podman  network ls | grep k8snet)
if [ -z "${have_net}" ]; then
    podman network create --dns 10.11.12.1 --subnet "10.10.10.0/24" k8snet
    echo "Network created"
else
    echo "Network already exists"
fi
