#!/bin/sh
set -e
PORT=${PORT:-8080}
UUID=${UUID:-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo 00000000-0000-0000-0000-000000000000)}
WS_PATH=${WS_PATH:-ws-default}
# normalize: server path must start with /
case "$WS_PATH" in
  /*) ;;
  *) WS_PATH="/$WS_PATH" ;;
esac
cat > /app/config.json <<JSON
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "listen": "0.0.0.0",
    "port": ${PORT},
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "${UUID}", "flow": ""}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {"path": "${WS_PATH}"}
    },
    "sniffing": {"enabled": true, "destOverride": ["http", "tls"]}
  }],
  "outbounds": [{"protocol": "freedom"}]
}
JSON
exec /app/xray run -c /app/config.json
