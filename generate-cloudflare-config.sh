#!/bin/bash

# Скрипт для автоматической генерации Cloudflare Tunnel config.yml
# Использование: ./generate-cloudflare-config.sh [tunnel-name] [credentials-file]

TUNNEL_NAME="${1:-ratespott}"
CREDENTIALS_FILE="${2:-/root/.cloudflared/d8bbe393-6b04-4669-8cf5-d27473b6bbc2.json}"
OUTPUT_FILE="${3:-/root/.cloudflared/config.yml}"

# Начать конфиг
cat > "$OUTPUT_FILE" << EOF
tunnel: $TUNNEL_NAME
credentials-file: $CREDENTIALS_FILE

ingress:
EOF

# Найти все папки с сайтами и их портами
for dir in /home/whyy0u/VsCode/Dissimilate/Backend/*/; do
    domain=$(basename "$dir")
    server_js="$dir/server.js"

    # Пропустить если это не папка с сайтом
    if [ ! -f "$server_js" ]; then
        continue
    fi

    # Извлечь PORT из server.js
    port=$(grep -oP 'const PORT = \K[0-9]+' "$server_js")

    if [ -z "$port" ]; then
        echo "⚠ Не найден PORT для $domain, пропускаю..."
        continue
    fi

    # Добавить ингресс правило
    cat >> "$OUTPUT_FILE" << EOF
  - hostname: $domain
    service: http://localhost:$port

EOF

    echo "✓ Добавлен: $domain → localhost:$port"
done

# Добавить fallback правило
cat >> "$OUTPUT_FILE" << EOF
  - service: http_status:403
EOF

echo ""
echo "✅ Config создан: $OUTPUT_FILE"
echo ""
echo "Содержимое:"
cat "$OUTPUT_FILE"
