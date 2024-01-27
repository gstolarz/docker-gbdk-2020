# Docker images with GBDK-2020

## Building Docker images

### Building Docker image based on Ubuntu
```shell-script
docker build -t gstolarz/gbdk-2020 -t gstolarz/gbdk-2020:4.2.0 \
  --build-arg SDCC_VERSION=4.3.0 --build-arg GBDK_2020_VERSION=4.2.0 .
```

### Building Docker image based on Alpine
```shell-script
docker build -t gstolarz/gbdk-2020:alpine -t gstolarz/gbdk-2020:4.2.0-alpine \
  --build-arg SDCC_VERSION=4.3.0 --build-arg GBDK_2020_VERSION=4.2.0 -f Dockerfile-alpine .
```
