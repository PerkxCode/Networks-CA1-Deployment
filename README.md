# Automated Container Deployment and Administration in the Cloud

**Module:** Network Systems and Administration CA 2026
**Author:** Perk Ramchandani

## 📌 Project Overview
The objective of this project is to bridge the gap between development and operations by building a fully automated, zero-touch deployment pipeline for a web application on AWS. By leveraging modern Infrastructure as Code (IaC) and Configuration Management tools, this project transitions away from manual server deployment to a system that automatically synchronizes and deploys code pushes straight to a live production environment. 

## 🛠️ Tools & Technologies Used
* **AWS (Amazon Web Services):** Cloud provider hosting the t3.micro EC2 instance.
* **Terraform:** Infrastructure as Code (IaC) tool used to provision the EC2 instance and configure security groups (allowing Port 80 and Port 22).
* **Ansible:** Configuration management tool utilized to automate server setup, update system packages, and install Docker via SSH.
* **Docker:** Containerization platform packaging the web application using a lightweight `nginx:alpine` base image.
* **GitHub Actions:** CI/CD automation engine that triggers on code pushes to the `main` branch to execute the deployment pipeline.

## 🏗️ Project Architecture & Workflow
1. **Infrastructure Setup:** Terraform provisions the AWS t3.micro EC2 instance.
2. **Server Configuration:** An Ansible playbook prepares the environment, installs Docker, and uses the `systemd` module to ensure Docker starts automatically on boot.
3. **Containerization:** A custom `Dockerfile` copies the local HTML/CSS files into the `/usr/share/nginx/html` directory of an `nginx:alpine` container.
4. **Continuous Deployment (CI/CD):** * A GitHub Actions workflow (`deploy.yml`) listens for pushes to the `main` branch.
   * It securely copies application files to `/home/ubuntu/app` on the EC2 instance using `appleboy/scp-action`.
   * It uses `appleboy/ssh-action` to remotely trigger a `docker build` (tagging the image `b9is121-webapp`) and run the container, exposing the application on Port 80.

## ⚙️ Configuration Details
### GitHub Actions (`deploy.yml`)
The deployment process relies on securely managed GitHub Secrets (`EC2_HOST`, `EC2_USERNAME`, `EC2_SSH_KEY`) to authenticate with the AWS server. The pipeline ensures clean deployments by stopping and removing the old container before spinning up the fresh build.

## 🔧 Troubleshooting & Known Fixes
During development, a few critical errors were resolved to ensure seamless automation:
* **"File Exists" SCP Conflict:** The pipeline initially failed because the SCP tool refused to overwrite existing files on the server. This was resolved by adding the `overwrite: true` flag to the YAML configuration.
* **Permission Denied Error:** The GitHub runner logged in as the standard `ubuntu` user but lacked authority to modify files originally created by the `root` user during the initial Ansible setup. This was fixed by SSHing directly into the instance and running `sudo chown -R ubuntu:ubuntu /home/ubuntu/app` to grant the pipeline the necessary write permissions.

## 🌐 Live Access
Following a successful pipeline run, the web application is actively served and mapped directly to port 80.
