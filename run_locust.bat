@echo off

:: Параметры по умолчанию
set HOST=https://lkmp-test.k-telecom.org:9797

:: Создание окружения
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
)

:: Активация и установка зависимостей
call venv\Scripts\activate
if errorlevel 1 (
    echo Error in activating virtual environment
    pause
    exit /b 1
)

:: Установка библиотек
pip install -r requirements.txt
if errorlevel 1 (
    echo Error in downloading dependencies
    pause
    exit /b 1
)

:: Проверка порта
echo Check if port 8089 is busy...
netstat -ano | findstr :8089 >nul && (
    echo ERROR: Port 8089 is busy!
    pause
    exit /b 1
) || echo Port 8089 is free


echo Starting test...
echo Host: %HOST%

:: Запуск теста в соответствии с выбранным режимом
if "%1"=="--divide" (
    echo Starting Locust in distributed mode...

    :: Запуск мастера в отдельном окне
    start "Locust Master" cmd /k ^
        locust --master -f locustfile.py --host %HOST%

    :: Ждём, чтобы мастер успел запуститься
    timeout /t 3 >nul

    echo Starting workers in background...
    start /B locust --worker -f locustfile.py --master-host=localhost
    start /B locust --worker -f locustfile.py --master-host=localhost
    start /B locust --worker -f locustfile.py --master-host=localhost
    start /B locust --worker -f locustfile.py --master-host=localhost

    echo Workers started. Press CTRL+C in the master window to stop.
) else (
    :: Обычный режим
    locust -f locustfile.py --host "%HOST%"
)