#!/bin/bash
# Завершаем скрипт при любой ошибке
set -e

# 1. Запускаем SSH-демон в фоновом режиме (требует прав root)
echo "Starting SSH service..."
service ssh start

# 2. Понижаем привилегии и запускаем основное приложение.
# Ключевое слово 'exec' заменяет текущий процесс оболочки (bash) процессом dotnet.
# Это делает dotnet процессом с PID 1, что гарантирует корректную обработку сигналов (SIGTERM/SIGINT).
# "$@" позволяет передавать дополнительные аргументы при запуске контейнера (docker run ...).
echo "Starting .NET application as nonroot user..."
exec sudo --preserve-env=ASPNETCORE_URLS -u nonroot dotnet ApiGateway.dll "$@"