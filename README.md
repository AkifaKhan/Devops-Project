# AWS Containerized Sales Dashboard

A complete, production-ready AWS deployment with Terraform, Docker, and BI analytics. This project includes:

- A *React frontend* 
- A *Node.js backend* 
- *Metabase BI dashboard* (https://akifa-ubuntu.codelessops.site)
- *MySQL and PostgreSQL RDS* instances secured in private subnets, entered through SSH Tunnel
- An *Application Load Balancer* with HTTPS and host-based routing

---

## 📂 Project Structure


- Terraform/ # Terraform configuration files
- Userdata/ # EC2 setup scripts: Ubuntu, AL2, AL2023
- Reactapp/ # React frontend (Docker build)
- Nodeapp-iba/ # Node.js backend (Docker build)
- README.md # This file



---

## 🔧 Deployment Instructions

1. *Clone this repo*  
   ```bash
   git clone https://github.com/AkifaKhan/Devops-Project
2. *Prepare Terraform variables*
   ```bash
 terraform init
 terraform plan
 terraform apply

- Load data into RDS
- Use SSH tunneling (via EC2) and DBeaver or CLI to import car dealership data.

Access the services

Frontend: (On two intances) https://akifa-al2.codelessops.site, https://ayeshal2023.unmashable.online

Backend: (On two intances)  http://akifa-al2.codelessops.site, http://ayeshal2023.unmashable.online

Metabase: https://akifa-ubuntu.codelessops.site

Build dashboards

## 🚀 What's Inside
IAC: Modular .tf files for VPC, subnets, EC2, ALB, ACM, DNS, RDS, security policies

User-data scripts: Automated setup of Docker, Nginx, Certbot, and Docker Compose

Dockerized apps: Multi-stage Dockerfiles for React & Node services

SSL & Routing: ALB with host header rules and ACM-managed HTTPS

RDS: Private MySQL & PostgreSQL, secure access via SSH tunnel

BI & Analytics: Metabase dashboard showing live sales data
