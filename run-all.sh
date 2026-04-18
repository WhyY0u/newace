#!/bin/bash

echo "🚀 Запуск всех серверов..."

cd "$(dirname "$0")"

node ratespot.org/server.js &
PID1=$!

node ocenkiru.life/server.js &
PID2=$!

node mneniyaplus.life/server.js &
PID3=$!

node technow.cc/server.js &
PID4=$!

node otzyvy.space/server.js &
PID5=$!

node kache.pro/server.js &
PID6=$!

node rating-ru.cc/server.js &
PID7=$!

echo ""
echo "✅ Все серверы запущены:"
echo ""
echo "   📊 СТАРЫЕ САЙТЫ:"
echo "      ratespot.org:      http://localhost:8087"
echo "      ocenkiru.life:     http://localhost:8088"
echo "      mneniyaplus.life:  http://localhost:8089"
echo ""
echo "   📊 НОВЫЕ САЙТЫ:"
echo "      technow.cc:        http://localhost:8090"
echo "      otzyvy.space:      http://localhost:8091"
echo "      kache.pro:         http://localhost:8092"
echo "      rating-ru.cc:      http://localhost:8093"
echo ""
echo "⏹️  Для остановки нажми Ctrl+C"
echo ""

trap "kill $PID1 $PID2 $PID3 $PID4 $PID5 $PID6 $PID7 2>/dev/null; echo '🛑 Серверы остановлены'; exit" INT

wait $PID1 $PID2 $PID3 $PID4 $PID5 $PID6 $PID7
