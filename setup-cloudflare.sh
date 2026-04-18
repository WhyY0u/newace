#!/bin/bash

# Полная автоматизация Cloudflare Tunnel setup
# Использование: ./setup-cloudflare.sh [tunnel-name]

TUNNEL_NAME="${1:-ratespott}"
CONFIG_FILE="/root/.cloudflared/config.yml"
CREDENTIALS_FILE="/root/.cloudflared/d8bbe393-6b04-4669-8cf5-d27473b6bbc2.json"

echo "🚀 Cloudflare Tunnel автоматическая настройка"
echo "================================================"
echo ""

# Шаг 1: Генерировать config.yml
echo "📝 Шаг 1: Генерируем config.yml..."
cd /home/whyy0u/VsCode/Dissimilate/Backend

cat > "$CONFIG_FILE" << EOF
tunnel: $TUNNEL_NAME
credentials-file: $CREDENTIALS_FILE

ingress:
EOF

# Найти все папки с сайтами
for dir in /home/whyy0u/VsCode/Dissimilate/Backend/*/; do
    domain=$(basename "$dir")
    server_js="$dir/server.js"

    if [ ! -f "$server_js" ]; then
        continue
    fi

    port=$(grep -oP 'const PORT = \K[0-9]+' "$server_js")

    if [ -z "$port" ]; then
        continue
    fi

    cat >> "$CONFIG_FILE" << EOF
  - hostname: $domain
    service: http://localhost:$port

EOF

    echo "  ✓ $domain → localhost:$port"
done

cat >> "$CONFIG_FILE" << EOF
  - service: http_status:403
EOF

echo ""
echo "✅ Config создан: $CONFIG_FILE"
echo ""

# Шаг 2: Регистрировать DNS маршруты
echo "📡 Шаг 2: Регистрируем DNS маршруты..."
echo ""

for dir in /home/whyy0u/VsCode/Dissimilate/Backend/*/; do
    domain=$(basename "$dir")
    server_js="$dir/server.js"

    if [ ! -f "$server_js" ]; then
        continue
    fi

    echo "Регистрирую: $domain..."

    # Выполнить команду route dns
    cloudflared tunnel route dns "$TUNNEL_NAME" "$domain" 2>&1

    if [ $? -eq 0 ]; then
        echo "  ✓ $domain успешно зарегистрирован"
    else
        echo "  ⚠ Ошибка при регистрации $domain"
    fi
done

echo ""
echo "================================================"
echo "✅ Настройка завершена!"
echo ""
echo "Проверить статус туннеля:"
echo "  cloudflared tunnel info $TUNNEL_NAME"
echo ""
echo "Запустить туннель:"
echo "  cloudflared tunnel run $TUNNEL_NAME"
echo ""
echo "Или с кастомным config:"
echo "  cloudflared tunnel run --config $CONFIG_FILE $TUNNEL_NAME"
