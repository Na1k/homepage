# SSL Config with letsencrypt (certbot)
- Used this tutorial https://phoenixnap.com/kb/letsencrypt-docker

To renew the certificates, execute the following: 
``` bash 
sudo docker compose run --rm certbot renew [--dry-run]
```


# DEPRECATED Konfiguration im Server
1. Download der Zertifikate von Ionos
2. Übertragen auf Server (/srv/nginx/certs)
3. Zusammenfassen von Intermediate und vollem Zertifikat zu bundle
   - cat zertifikat.cer zertifikat_intermediate.cer > bundle.cer
4. Nginx-Konfigurationsdatei
``` bash
upstream webapp {
    server homepage:1234
}

server {
    listen 80;
    server_name *.nick-kramer.de

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name *.nick-kramer.de;

    ssl_certificate <path-in-container>/bundle.cer;
    ssl_certificate_key <path-in-container>/private_key.key;

    location / {
        proxy_pass http://webapp;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

5. Docker-Compose File (nginx part)
```
services:
    ...
    nginx:
        container_name: nginx
        restart: always
        image: "nginx:latest"
        ports:
          - "80:80"
          - "443:443"
        volumes:
          - ./nginx/homepage.conf:/etc/nginx/conf.d/default.conf
          - ./nginx/certs:/etc/nginx/ssl/:ro
        ...
```
