# exira/static-site

## Setup static site

 * Create a new project and add a `public_html` folder.
 * (Optionally) create a `config` folder with a `default.conf` NGINX configuration.
 * (Optionally) create a `certs` folder with SSL certificate files.
 * In case of a `certs` folder, remember to run `openssl dhparam -out certs/dhparams.pem 4096`
 * Copy `Dockerfile.template` to `Dockerfile`
 * Copy `docker-compose.template.yml` to `docker-compose.yml`
 * Build with `docker build -t exira/your-site .`
 * Run `docker-compose up -d`
