#!/usr/bin/env bash

HOST="${HOST:-"localhost"}"

set -e

mkdir -p /etc/caddy

cat > /etc/caddy/Caddyfile <<EOF
:8080

reverse_proxy :8000 {
	header_up Host $HOST
	header_up X-Forwarded-Proto https
}
EOF

cat > /usr/local/share/caddy-init.sh <<EOF
#!/bin/sh

/usr/local/bin/caddy run --environ --config /etc/caddy/Caddyfile
EOF

chmod +x /usr/local/share/caddy-init.sh
