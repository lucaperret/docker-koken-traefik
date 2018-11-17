# Koken within docker

[![Koken logo](http://koken.me/img/koken-logo-head.svg)](https://koken.me)
> Content management and web site publishing for photographers

*I had an old [1&1](https://www.ionos.fr) hosting plan for 20$/month, which was really slow: 1.3 seconds to load Koken, I migrated it to [DigitalOcean](https://m.do.co/c/58adfdffc5f1) with [Traefik](https://traefik.io) and the loading time is now 350ms...*

## Features

- Simple to start quickly
- Use Let's Encrypt to automatically generate SSL certificates (thanks Traefik).
- Latest version of Koken and all necessary system requirements
- PHP configured for best Koken performance
- MariaDB for the database

## How to use it

### Prerequisites

- Install [Docker](https://www.docker.com)
- `git clone https://github.com/lucaperret/docker-koken-traefik.git`

### Development

1. Make a copy of *.env.sample*, rename it to *.env* and adapt it to your needs.
2. Run `docker-compose up` ☕️
3. Access [http://localhost](http://localhost) to install Koken
4. Enter your database settings and fill `db` for the host (or your docker-compose service name)

### Production

1. Install [Traefik](https://docs.traefik.io/user-guide/docker-and-lets-encrypt)
2. Make a copy of *.env.sample*, rename it to *.env* and adapt it to your needs
    1. `DOMAIN` will be the Host rule
    2. `TRAEFIK_NETWORK` should be the one created for Traefik
3. Run `docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d` ☕️
4. Access your domain name to install Koken.

Your files reside in *data/koken* on the host machine, while the MySQL data lives in *data/mysql*.

## Inspired by

- [Docker Koken Let's Encrypt](https://github.com/pspoerri/docker-koken-letsencrypt)
- [Docker container with Koken and Apache](https://github.com/nicokaiser/docker-koken)