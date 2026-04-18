#!/bin/bash

# Полная автоматизация Cloudflare Tunnel setup
# Использование: ./setup-cloudflare.sh [tunnel-name] [backend-path]

TUNNEL_NAME="${1:-ratespott}"
BACKEND_PATH="${2:-.}"  # По умолчанию текущая папка
CONFIG_FILE="/root/.cloudflared/config.yml"
CREDENTIALS_FILE="/root/.cloudflared/d8bbe393-6b04-4669-8cf5-d27473b6bbc2.json"

echo "🚀 Cloudflare Tunnel автоматическая настройка"
echo "================================================"
echo "Backend путь: $BACKEND_PATH"
echo "Tunnel: $TUNNEL_NAME"
echo ""

# Шаг 1: Генерировать config.yml
echo "📝 Шаг 1: Генерируем config.yml..."

cat > "$CONFIG_FILE" << EOF
tunnel: $TUNNEL_NAME
credentials-file: $CREDENTIALS_FILE

ingress:
EOF

# Найти все папки с сайтами
found_count=0
for dir in "$BACKEND_PATH"/*/; do
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
    ((found_count++))
done

cat >> "$CONFIG_FILE" << EOF
  - service: http_status:403
EOF

if [ $found_count -eq 0 ]; then
    echo "  ⚠ Сайты не найдены в $BACKEND_PATH"
    echo "  Проверь что папка содержит папки с server.js файлами"
else
    echo "  ✅ Найдено доменов: $found_count"
fi

echo ""
echo "✅ Config создан: $CONFIG_FILE"
echo ""

# Шаг 2: Регистрировать DNS маршруты
echo "📡 Шаг 2: Регистрируем DNS маршруты..."
echo ""

success=0
for dir in "$BACKEND_PATH"/*/; do
    domain=$(basename "$dir")
    server_js="$dir/server.js"

    if [ ! -f "$server_js" ]; then
        continue
    fi

    echo -n "  Регистрирую $domain... "

    if cloudflared tunnel route dns "$TUNNEL_NAME" "$domain" > /dev/null 2>&1; then
        echo "✓"
        ((success++))
    else
        echo "✗ (возможно уже зарегистрирован)"
    fi
done

echo ""
echo "================================================"
echo "✅ Настройка завершена! ($success доменов)"
echo ""
echo "Проверить статус туннеля:"
echo "  cloudflared tunnel info $TUNNEL_NAME"
echo ""
echo "Запустить туннель:"
echo "  cloudflared tunnel run $TUNNEL_NAME"
echo ""
echo "Или с кастомным config:"
echo "  cloudflared tunnel run --config $CONFIG_FILE $TUNNEL_NAME"
