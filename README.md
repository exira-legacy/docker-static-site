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

## Example default.conf

```
server {
    # Redirect all to canonical no-www version
    server_name www.example.org;
    return 301 https://example.org$request_uri;
}

server {
    # Redirect HTTP to HTTPS
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name example.org;

    return 301 https://example.org$request_uri$is_args$args;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name example.org;

    include /etc/nginx/configs/security.conf;

    more_set_headers "Content-Security-Policy-Report-Only: default-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; script-src 'self' 'unsafe-inline' data: https://www.google-analytics.com";

    # Setup HSTS, this will force browsers to go directly to HTTPS for one year, as well as all subdomains
    # Keep in mind, of a location block uses another add_header, you have to redefine it
    # Also preload the site at https://hstspreload.appspot.com/
    # add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;

    # Used for OCSP stapling
    ssl_trusted_certificate /etc/nginx/ssl/example_org.crt;

    # SSL Certs
    ssl_certificate /etc/nginx/ssl/example_org.crt;
    ssl_certificate_key /etc/nginx/ssl/example_org.key;

    # Secure Diffie-Hellman for TLS
    ssl_dhparam /etc/nginx/ssl/dhparams.pem;

    # Just allow GET and HEAD for static sites
    if ($request_method !~ ^(GET|HEAD)$) {
        return 405;
    }

    location /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        access_log off;
        log_not_found off;
    }

    location ~ /\.git {
        deny all;
    }

    location ~ /\.svn {
        deny all;
    }

    # cache static resources
    location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|css|rss|atom|js|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
        access_log off;
        log_not_found off;
        expires max;
    }

    # Example to prevent image hotlinking
    # Stop deep linking or hot linking
    #location /images/ {
    #    valid_referers none blocked server_names ~\.google\.;
    #    if ($invalid_referer) {
    #        return 403;
    #    }
    #}
}
```
