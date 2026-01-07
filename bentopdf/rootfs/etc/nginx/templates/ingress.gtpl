server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    location / {
        allow   172.30.32.2;
        deny    all;

        proxy_pass {{ .protocol }}://backend;
        proxy_set_header Accept-Encoding "";
	# Rewrite HTML, JS strings, asset and API calls
	sub_filter_types text/html text/css application/javascript;
	sub_filter_once off;

        # Rewrite all absolute URLs to relative
        sub_filter '"href":"/' '"href":"{{ .ingress_path }}/';
        sub_filter 'href="/' 'href="{{ .ingress_path }}/';
        sub_filter 'src="/' 'src="{{ .ingress_path }}/';
	sub_filter '"\/src\/pages\/' '"{{ .ingress_path }}/src/pages/';
        sub_filter 'url(/' 'url({{ .ingress_path }}/';
	sub_filter '"\/assets\/' '"{{ .ingress_path }}/assets/';
        
	sub_filter 'link rel="canonical" href="https://' 'link rel="canonical" href="https://';  # leave canonical

        # Rewrite internal Anchor/spa links
        sub_filter '="/' '="{{ .ingress_path }}/';
	sub_filter "='/" "='{{ .ingress_path }}/";

	# Rewrite navigation where JS builds URLs manually
	sub_filter 'base href="/"' 'base href="{{ .ingress_path }}/"';

	# Handles fetch/XHR calls with leading slash
	sub_filter '"\/' '"{{ .ingress_path }}\/';
	sub_filter 'fetch("/' 'fetch("{{ .ingress_path }}/';
	sub_filter 'axios.get("/' 'axios.get("{{ .ingress_path }}/';

	# Translate ingress-prefixed url to real path
	rewrite ^{{ .ingress_path }}(/.*)$ /$1 break;
	rewrite ^{{ .ingress_path }}$ / last;

	# try_files $uri $uri/ /index.html;
    }
}
