# Gazes-utils

## Installation

```bash
git clone https://github.com/deril-fr/gazes-utils && cd gazes-utils && ./setup.sh
```

## Commands

### Docker-run

#### Description
Start a new container with the specified image, container name and port in daemon mode.

#### Usage
```bash
docker-run <port> <container-name> <image-name>
```
#### Example
```bash
docker-run 8080 my-container my-image
```

### Docker-clean

#### Description
Remove the specified container, and remove the old image and start a new one with the new image.

[WARNING]: Use this only for an unique container and only with images from the same repository.

#### Usage
```bash
docker-clean <container-name> <image-name>
```
#### Example
```bash
docker-clean my-container my-image
```

## License  
[MIT](https://choosealicense.com/licenses/mit/)
