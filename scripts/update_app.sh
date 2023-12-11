#!/bin/bash

APP_ROOT=/var/app

BACKEND_SRC=$APP_ROOT/projects/backend
BACKEND_DIST=$BACKEND_SRC/dist

FRONTEND_SRC=$APP_ROOT/projects/frontend
FRONTEND_DIST=$FRONTEND_SRC/dist

install_dependencies() {
    cd $1
    npm i
}

build_project() {
    cd $1
    npm run build
}

restart_backend() {
    cd $BACKEND_SRC
    npm run stop:pm2
    npm run start:pm2
}

restart_nginx() {
    sudo systemctl restart nginx
}

main() {
    echo "Installing the dependencies for backend..."
    install_dependencies $BACKEND_SRC
    echo "[COMPLETED] Installing the dependencies for backend..."

    echo "Building backend..."
    build_project $BACKEND_SRC
    echo "[COMPLETED] Building backend..."

    echo "Restarting backend..."
    restart_backend
    echo "[COMPLETED] Restarting backend..."

    echo "Installing the dependencies for frontend..."
    install_dependencies $FRONTEND_SRC
    echo "[COMPLETED] Installing the dependencies for frontend..."

    echo "Building frontend..."
    build_project $FRONTEND_SRC
    echo "[COMPLETED] Building frontend..."

    echo "Restarting NGINX..."
    restart_nginx
    echo "[COMPLETED] Restarting NGINX..."
}

main $@
