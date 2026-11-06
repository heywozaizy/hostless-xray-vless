#!/bin/sh
set -e
PORT=${PORT:-8080}
UUID=${UUID:-34eb6fde-d911-4547-bfa0-0f11d9fe3985}
WS_PATH=${WS_PATH:-ws-d9c71cb1}
case "$WS_PATH" in
  /*) ;;
  *) WS_PATH="/$WS_PATH" ;;
esac

XRAY_BIN="./xray"
if [ ! -x "$XRAY_BIN" ]; then
  echo "xray binary missing in image" >&2
  exit 127
fi

cat > /tmp/xray-config.json <<JSON
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
exec ./xray run -c /tmp/xray-config.json
