#!/bin/bash

BACKEND_SRC=$(pwd)/projects/backend
BACKEND_DIST=$BACKEND_SRC/dist

FRONTEND_SRC=$(pwd)/projects/frontend
FRONTEND_DIST=$FRONTEND_SRC/dist

main() {
    mkdir -p /var/app
    cd /var/app
    
    git clone --recurse-submodules https://github.com/CilgaIscan/devops-fundamentals-course-lab02.git .
}

main $@
