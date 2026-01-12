# Listen {{ .interface }}:{{ .port }}
Listen 8099

<VirtualHost *:{{ .port }}>
    DocumentRoot "/var/www/html"
    #RewriteEngine on
    #RewriteCond %{REQUEST_URI} ^/api/hassio_ingress/[^/]+(/.*)$
    #RewriteRule ^ /%1 [L,QSA]
    # Extract token and store in env var
    #RewriteRule ^api/hassio_ingress/([^/]+)/?(.*)$ - [E=INGRESS_TOKEN:$1]

    # Map ingress paths back into Grav
    #RewriteRule ^api/hassio_ingress/[^/]+/(.*)$ /$1 [QSA,L]

    <Directory "/var/www/html">
        RewriteBase {{ .ingress_path }}
        AllowOverride None
	Options Indexes FollowSymLinks
        Require all granted
        #Require ip 172.30.32.0/24
    </Directory>
</VirtualHost>

