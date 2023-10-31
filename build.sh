set -ex
VERSION=${1:-"gcc:13.2.0"}
IMAGE="ghcr.io/pharehub/phare_debian/${VERSION}"
docker build --build-arg VERSION=$VERSION -t ${IMAGE} .
