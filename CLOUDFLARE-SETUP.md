# Cloudflare Tunnel автоматическая настройка

Полная автоматизация настройки Cloudflare Tunnel для всех сайтов.

## 📋 Скрипты

### 1. `setup-cloudflare.sh` - Полная автоматизация (РЕКОМЕНДУЕТСЯ)

Делает всё в одном скрипте:
- Генерирует `config.yml` для всех сайтов
- Регистрирует DNS маршруты для каждого домена

**Использование:**
```bash
./setup-cloudflare.sh [tunnel-name]
```

**Примеры:**
```bash
./setup-cloudflare.sh ratespott
./setup-cloudflare.sh my-tunnel
```

**Что происходит:**
```
📝 Шаг 1: Генерируем config.yml...
  ✓ ratespot.org → localhost:8087
  ✓ ocenkiru.life → localhost:8088
  ✓ mneniyaplus.life → localhost:8089
  ✓ technow.cc → localhost:8090
  ✓ otzyvy.space → localhost:8091
  ✓ kache.pro → localhost:8092
  ✓ rating-ru.cc → localhost:8093

📡 Шаг 2: Регистрируем DNS маршруты...
  ✓ ratespot.org успешно зарегистрирован
  ✓ ocenkiru.life успешно зарегистрирован
  ...
```

### 2. `generate-cloudflare-config.sh` - Только конфиг

Генерирует только `config.yml` без регистрации DNS.

**Использование:**
```bash
./generate-cloudflare-config.sh [tunnel-name] [credentials-file] [output-file]
```

**Примеры:**
```bash
# Использовать defaults
./generate-cloudflare-config.sh

# Кастомные параметры
./generate-cloudflare-config.sh ratespott /root/.cloudflared/creds.json /root/.cloudflared/config.yml
```

### 3. `register-dns-routes.sh` - Только DNS регистрация

Регистрирует DNS маршруты для всех доменов.

**Использование:**
```bash
./register-dns-routes.sh [tunnel-name]
```

**Примеры:**
```bash
./register-dns-routes.sh ratespott
```

## 🚀 Быстрый старт

### Первый раз (полная настройка)

```bash
# На сервере где cloudflared установлен
cd /home/dissimilate/backend  # или где у вас Backend папка

# Запустить полную автоматизацию
./setup-cloudflare.sh ratespott
```

Это:
1. Создаст `/root/.cloudflared/config.yml` со всеми доменами
2. Зарегистрирует DNS маршруты для каждого домена

### Когда добавишь новый сайт

```bash
# Обновить config и DNS маршруты
./setup-cloudflare.sh ratespott
```

Или отдельно:
```bash
# Только обновить config
./generate-cloudflare-config.sh ratespott

# Только добавить DNS маршруты для новых доменов
./register-dns-routes.sh ratespott
```

## ✅ Проверки

**Проверить config.yml:**
```bash
cat /root/.cloudflared/config.yml
```

**Проверить зарегистрированные маршруты:**
```bash
cloudflared tunnel route ls ratespott
```

**Проверить статус туннеля:**
```bash
cloudflared tunnel info ratespott
```

## 🔄 Запуск туннеля

После настройки:

```bash
# С дефолтным config
cloudflared tunnel run ratespott

# С кастомным config
cloudflared tunnel run --config /root/.cloudflared/config.yml ratespott
```

## 📊 Как это работает

Скрипты:
1. **Сканируют** все папки в `/home/whyy0u/VsCode/Dissimilate/Backend/`
2. **Читают** PORT из `server.js` каждого сайта
3. **Используют** доменное имя (название папки) как hostname
4. **Генерируют** ingress правила в config.yml
5. **Регистрируют** DNS маршруты через `cloudflared tunnel route dns`

## 🔍 Текущие домены

```
ratespot.org         → localhost:8087
ocenkiru.life        → localhost:8088
mneniyaplus.life     → localhost:8089
technow.cc           → localhost:8090
otzyvy.space         → localhost:8091
kache.pro            → localhost:8092
rating-ru.cc         → localhost:8093
```

## 💡 Советы

- Запускай `setup-cloudflare.sh` каждый раз когда добавляешь новый сайт
- Скрипты автоматически найдут PORT из `server.js`
- DNS маршруты нужно регистрировать только один раз
- Если домен уже зарегистрирован, скрипт пропустит его (это нормально)

## 🆘 Проблемы

**Скрипт не находит домены:**
- Проверь что папки находятся в `/home/whyy0u/VsCode/Dissimilate/Backend/`
- Убедись что в каждой папке есть `server.js`

**Ошибка при регистрации DNS:**
```bash
# Возможно не установлен cloudflared
brew install cloudflared  # или apt install cloudflared

# Или нет доступа к tunnel
# Проверь что ты залогирован: cloudflared tunnel login
```

**Config.yml не создается:**
- Проверь права доступа: `chmod 777 /root/.cloudflared/`
- Проверь что указан правильный credentials-file
