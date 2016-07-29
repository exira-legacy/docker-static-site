# exira/static-site

## Setup static site

 * Create a new project and add a `public_html` folder.
 * (Optionally) create a `config` folder with a `default.conf` NGINX configuration.
 * Copy `Dockerfile.template` to `Dockerfile`
 * Copy `docker-compose.template.yml` to `docker-compose.yml`
 * Build with `docker build -t exira/your-site .`
 * Run `docker-compose up -d`
