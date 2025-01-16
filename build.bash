docker buildx build . -t ${DOCKER_ID}/node:v0.1.0
echo "Image built"

have_net=$(docker network ls | grep k8snet)
if [ -z "${have_net}" ]; then
    docker network create --subnet=10.10.10.0/24 k8snet
    echo "Network created"
else
    echo "Network already exists"
fi
