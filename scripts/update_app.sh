#!/bin/bash

APP_ROOT=/var/app

BACKEND_SRC=$APP_ROOT/projects/backend
BACKEND_DIST=$BACKEND_SRC/dist

FRONTEND_SRC=$APP_ROOT/projects/frontend
FRONTEND_DIST=$FRONTEND_SRC/dist

DOMAIN_NAME=devops-lab02
NGINX_CONF_FILENAME=$DOMAIN_NAME.conf
NGINX_CONF_SRC=$(pwd)/nginx
NGINX_CONF_SRC_PATH=$NGINX_CONF_SRC/$NGINX_CONF_FILENAME

NGINX_TARGET_ROOT=/etc/nginx
NGINX_TARGET_SITES_AVAILABLE=$NGINX_TARGET_ROOT/sites-available
NGINX_TARGET_SITES_ENABLED=$NGINX_TARGET_ROOT/sites-enabled
NGINX_TARGET_PATH=$NGINX_TARGET_SITES_AVAILABLE/$DOMAIN_NAME
NGINX_TARGET_SYM_LINK=$NGINX_TARGET_SITES_ENABLED/$DOMAIN_NAME

update_source() {
    cd $APP_ROOT
    git pull --recurse-submodules

}

update_nginx() {
    sudo cp $NGINX_CONF_SRC_PATH $NGINX_TARGET_PATH
    
    if [[ -f $NGINX_TARGET_SYM_LINK ]]; then
        echo "File exists: $NGINX_TARGET_SYM_LINK"
    else
        echo "File not found: $NGINX_TARGET_SYM_LINK! We are creating the symbolic link..."
        sudo ln -s $NGINX_TARGET_PATH $NGINX_TARGET_SITES_ENABLED
    fi
}

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
    echo "Updating source code..."
    update_source
    echo "[COMPLETED] Updating source code..."

    echo "Updating NGINX config..."
    update_nginx
    echo "[COMPLETED] Updating NGINX config..."

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
