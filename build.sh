
set -ex
FROM_IMAGE=${1:-"gcc:13.2.0"}
IMAGE="ghcr.io/pharchive/phare_debian/${FROM_IMAGE}"
docker build --build-arg FROM_IMAGE=$FROM_IMAGE -t ${IMAGE} .
