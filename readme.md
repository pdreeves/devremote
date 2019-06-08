# Container Commands

## Create .ssh container
docker volume create devVolume

## Start Container
docker run -d -v devVolume:/root/.ssh pdreeves/devremote
docker run -d -P -v devVolume:/root/.ssh devremote

## Build image
docker image build . --file Dockerfile --tag devremote

## Delete image
docker image rm devremote
