@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo Verificando archivo .env ...
echo ===========================================

if not exist ".env" (
    echo Creando archivo .env ...
    (
        # Variables de Django
        echo DB_ENGINE=django.db.backends.mysql
        echo DB_NAME=myqlvirtual
        echo DB_USER=Greminger
        echo DB_PASSWORD=12345678
        echo DB_HOST=127.0.0.1
        echo DB_PORT=3308
        # Variables de MySQL (Docker)
        echo MYSQL_ROOT_PASSWORD=12345678
        echo MYSQL_DATABASE=myqlvirtual
        echo MYSQL_USER=Greminger
        echo MYSQL_PASSWORD=12345678
    ) > .env
) else (
    echo Archivo .env ya existe, no se modificará.
)

echo ===========================================
echo Iniciando contenedor Docker ...
echo ===========================================
docker compose up -d

echo Esperando que MySQL inicie ...
timeout /t 10 >nul

echo ===========================================
echo Creando entorno virtual ...
echo ===========================================
if not exist "docker\Scripts\activate" (
    python -m venv docker
)
call .\docker\Scripts\activate

echo ===========================================
echo Instalando dependencias ...
echo ===========================================
pip install -r requirements.txt

echo ===========================================
echo Mostrando migraciones ...
echo ===========================================
python manage.py showmigrations

echo ===========================================
echo Ejecutando servidor Django ...
echo ===========================================
python manage.py runserver

endlocal
