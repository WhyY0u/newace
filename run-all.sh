#!/bin/bash

echo "🚀 Запуск всех серверов..."

cd "$(dirname "$0")"

node ratespot.org/server.js &
PID1=$!

node ocenkiru.life/server.js &
PID2=$!

node mneniyaplus.life/server.js &
PID3=$!

echo ""
echo "Все серверы запущены:"
echo "   ratespot.org:    http://localhost:8087"
echo "   ocenkiru.life:   http://localhost:8088"
echo "   mneniyaplus.life: http://localhost:8089"
echo ""
echo "Для остановки нажми Ctrl+C"
echo ""

trap "kill $PID1 $PID2 $PID3 2>/dev/null; echo 'Серверы остановлены'; exit" INT

wait $PID1 $PID2 $PID3
