#!/bin/bash

# Параметры по умолчанию
HOST="https://lkmp-test.k-telecom.org:9797"

# Создание окружения
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Активация и установка зависимостей
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "Error in activating virtual environment"
    exit 1
fi

# Установка библиотек
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Error in downloading dependencies"
    exit 1
fi

# Проверка порта
echo "Check if port 8089 is busy..."
if ss -tulpn | grep -q ":8089"; then
    echo "ERROR: Port 8089 is busy!"
    exit 1
else
    echo "Port 8089 is free"
fi

echo "Starting test..."
echo "Host: $HOST"

# Запуск теста в соответствии с выбранным режимом
if [ "$1" == "--divide" ]; then
    echo "Starting Locust in distributed mode..."

    # Запуск мастера в новом терминале (если доступен)
    if command -v x-terminal-emulator &> /dev/null; then
        x-terminal-emulator -e "bash -c 'locust --master -f locustfile.py --host $HOST; exec bash'" &
    else
        echo "Could not find terminal emulator, running in background..."
        locust --master -f locustfile.py --host "$HOST" &
    fi

    # Ждём, чтобы мастер успел запуститься
    sleep 3

    echo "Starting workers in background..."
    locust --worker -f locustfile.py --master-host=localhost &
    locust --worker -f locustfile.py --master-host=localhost &
    locust --worker -f locustfile.py --master-host=localhost &
    locust --worker -f locustfile.py --master-host=localhost &

    echo "Workers started. Use 'pkill -f locust' to stop all processes."
else
    # Обычный режим
    locust -f locustfile.py --host "$HOST"
fi