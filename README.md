# Docker Dynamic DNS Updater

Super lightweight and portable Dynamic DNS updater.

## Getting Started

This image is currently in early beta and is super simple. There isn't a lot of error checking and not a lot of features. To use it, pull the latest image or build your own with the DockerFile.

### Running

1. Pull the image:

```
docker pull andrefecto/dynamic_dns_updater
```

2. Run from CLI:

```
docker run -e ACCESS_TOKEN="<your access token here>" -e DOMAIN="<full domain like example.me>" -e SUBDOMAIN="<subdomain of example.me you want to update>" -e RECORD_ID="<record ID of sub.example.me>" --name=<container name> -d andrefecto/dynamic_dns_updater
```

2. Or by using Docker Compose

```
version: '3.3'
services:
    <container_name_here>:
        environment:
            - 'ACCESS_TOKEN=<your access token here>'
            - 'DOMAIN=<full domain like example.me>'
            - 'SUBDOMAIN=<subdomain of example.me you want to update>'
            - 'RECORD_ID=<record ID of sub.example.me>'
        image: andrefecto/dynamic_dns_updater
```

3. See the logs by running:

```
docker logs <container_name_here>
```

## Contributing

If you have suggestionsf or features please open a Github issue. If you would like to propose code please create a pull request.

## Versioning

We use [SemVer](http://semver.org/) for versioning.


