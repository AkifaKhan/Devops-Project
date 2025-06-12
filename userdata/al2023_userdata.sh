#!/bin/bash

# Update system
sudo dnf update -y

# Install required packages
sudo dnf install -y git
sudo dnf install -y nginx
sudo dnf install -y docker
sudo dnf install -y git nginx docker git python3 python3-pip curl python3-certbot-nginx

# Enable and start Docker service before use
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl enable docker --now
sudo systemctl start docker

# Enable and start nginx services
sudo systemctl enable nginx --now
sudo systemctl enable nginx
sudo systemctl start nginx

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Restart Docker service to be safe
sudo systemctl restart docker

# Prepare app directory and clone repos as ec2-user
mkdir -p /home/ec2-user/myapp
chown ec2-user:ec2-user /home/ec2-user/myapp
cd /home/ec2-user/myapp

if [ ! -d "nodeapp-iba" ]; then
  sudo -u ec2-user git clone https://github.com/Khhafeez47/nodeapp-iba.git
fi

if [ ! -d "reactapp" ]; then
  sudo -u ec2-user git clone https://github.com/AkifaKhan/reactapp.git
fi

# Create docker-compose.yml as ec2-user
cat <<EOF > /home/ec2-user/myapp/docker-compose.yml
version: '3'
services:
  backend:
    build:
      context: ./nodeapp-iba
      dockerfile: Dockerfile
    container_name: backend
    ports:
      - "5000:5000"

  frontend:
    build:
      context: ./reactapp
      dockerfile: Dockerfile
    container_name: frontend
    ports:
      - "300:80"
EOF

chown ec2-user:ec2-user /home/ec2-user/myapp/docker-compose.yml

# Run docker-compose up as root
docker-compose -f /home/ec2-user/myapp/docker-compose.yml up -d

# Configure Nginx reverse proxy
cat <<EOF | sudo tee /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    server_name akifa-al2023.codelessops.site;

    location /api/ {
        proxy_pass http://127.0.0.1:5000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
        proxy_pass http://127.0.0.1:300/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Test and restart Nginx
sudo nginx -t && sudo systemctl restart nginxyes

# Wait for DNS propagation (optional)
sleep 180

# Issue SSL certificate (ensure domain is pointed correctly)
sudo certbot --nginx -d akifa-al2023.codelessops.site --non-interactive --agree-tos -m akifakhan@hotmail.com

# Dry-run renewal check
sudo certbot renew --dry-run