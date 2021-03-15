# Docker Dynamic DNS Updater

Extremely lightweight and portable Dynamic DNS updater.

## Getting Started

This image is currently in beta and is super simple. To use it, pull the latest image or build your own with the DockerFile. Currently this docker container only support DigitalOcean.

### Required

* Access Token for DigitalOcean API
  * Obtain based on the [DigitalOcean Docs](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/)
  * Make sure to apply both READ and WRITE permissions
* Domain
  * Should be your whole domain you want to keep up-to-date
  * Example: test.example.com
* Domain Provider
  * Currently only valid option is digitalocean

### Optional

* Sleep timer
  * Set to a value based on the standard bash [sleep](https://www.cyberciti.biz/faq/linux-unix-sleep-bash-scripting/) command
  * Examples:
    * 12h is 12 hours
    * 60m is 60 minutes
    * 60 is 60 seconds

### Running

0. Pull the image:

```bash
docker pull andrefecto/dynamic_dns_updater
```

1. Run from CLI:

```bash
docker run -e ACCESS_TOKEN="<your access token here>" -e DOMAIN="<full domain like test.example.me>" -e DOMAIN_PROVIDER="digitalocean" --name=<container name> -d andrefecto/dynamic_dns_updater
```

2. Or by using Docker Compose

```docker
version: '3.3'
services:
    <container_name_here>:
        environment:
            ACCESS_TOKEN: "<your access token here>"
            DOMAIN: "<full domain like test.example.me>"
            DOMAIN_PROVIDER: "digitalocean"
            SLEEP_DURATION: "<your duration>"
        image: andrefecto/dynamic_dns_updater
```

3. See the logs by running:

```bash
docker logs <container_name_here> -f
```

### Example Docker Compose

```docker
version: '3.3'
services:
    digital_ocean_dyndns:
        environment:
            ACCESS_TOKEN: "123918232token"
            DOMAIN: "test123.andrefecto.me"
            DOMAIN_PROVIDER: "digitalocean"
            SLEEP_DURATION: "3h"
        image: andrefecto/dynamic_dns_updater
```

## Contributing

If you have suggestionsf or features please open a Github issue. If you would like to propose code please create a pull request.

## Versioning

We use [SemVer](http://semver.org/) for versioning.


