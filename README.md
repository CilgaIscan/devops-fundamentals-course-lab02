# devops-fundamentals-course-lab02

A container project to manage the application. This project has `nginx` as reverse proxy.

## Folder Structure

## Setup
1. Create a folder in `/var` named `app` and change the workind directory
```bash
mkdir -p /var/app
cd /var/app
```

2. Clone the project with submodules in `/var/app`:
```bash
git clone --recurse-submodules https://github.com/CilgaIscan/devops-fundamentals-course-lab02.git .
```

## Update
1. After pushing the changes to the related repository, you must run the following to update the project's source code (in your local environment):
```bash
git submodule update --remote
```

2. Then, commit the changes and push to GitHub.

3. Run the update_app.sh script
```bash
./scripts/update_app.sh
```
