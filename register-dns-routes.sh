#!/bin/bash

# Скрипт для регистрации DNS маршрутов для всех доменов
# Использование: ./register-dns-routes.sh [tunnel-name]

TUNNEL_NAME="${1:-ratespott}"

echo "📡 Регистрация DNS маршрутов для Cloudflare Tunnel"
echo "===================================================="
echo "Tunnel: $TUNNEL_NAME"
echo ""

success=0
failed=0

# Для каждого сайта регистрируем DNS маршрут
for dir in /home/whyy0u/VsCode/Dissimilate/Backend/*/; do
    domain=$(basename "$dir")
    server_js="$dir/server.js"

    if [ ! -f "$server_js" ]; then
        continue
    fi

    echo -n "Регистрирую $domain... "

    if cloudflared tunnel route dns "$TUNNEL_NAME" "$domain" > /dev/null 2>&1; then
        echo "✓"
        ((success++))
    else
        echo "✗ (возможно уже зарегистрирован)"
        ((failed++))
    fi
done

echo ""
echo "===================================================="
echo "✅ Результат: $success успешно, $failed пропущено"
echo ""
echo "Проверить маршруты:"
echo "  cloudflared tunnel route ls $TUNNEL_NAME"
