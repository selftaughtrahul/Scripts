#!/bin/bash

# Update and upgrade the instance
sudo apt update -y && sudo apt upgrade -y

# Add a new user
NEW_USER="myuser"
PASSWORD="mypassword"
HOME_DIR="/home/$NEW_USER"
PROJECTS_DIR="$HOME_DIR/projects"

sudo adduser --disabled-password --gecos "" $NEW_USER
echo "$NEW_USER:$PASSWORD" | sudo chpasswd

# Create the projects directory and set permissions
sudo mkdir -p $PROJECTS_DIR/static $PROJECTS_DIR/media
sudo chown -R $NEW_USER:$NEW_USER $PROJECTS_DIR
sudo chmod -R 755 $PROJECTS_DIR

# Install required packages
sudo apt install -y python3 python3-venv python3-pip nginx git ufw mysql-server

# Secure MySQL installation
sudo mysql_secure_installation

# Create MySQL user and database
MYSQL_ROOT_PASSWORD="rootpassword"
DB_NAME="mydb"
DB_USER="mydbuser"
DB_PASSWORD="dbpassword"

# Set MySQL root password and create the database and user
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Configure the firewall
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx Full'
sudo ufw enable

# Remove default Nginx site configuration
sudo rm /etc/nginx/sites-enabled/default

# Set up Nginx configuration
NGINX_CONF="/etc/nginx/sites-available/$NEW_USER"
NGINX_LINK="/etc/nginx/sites-enabled/$NEW_USER"

cat <<EOL | sudo tee $NGINX_CONF
server {
    listen 80;
    server_name localhost;

    location /static/ {
        alias $PROJECTS_DIR/static/;
    }

    location /media/ {
        alias $PROJECTS_DIR/media/;
    }

    location / {
        proxy_pass http://127.0.0.1:8001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    client_max_body_size 100M;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    error_log /var/log/nginx/$NEW_USER-error.log;
    access_log /var/log/nginx/$NEW_USER-access.log;
}
EOL

# Enable the Nginx configuration
if [ ! -L $NGINX_LINK ]; then
    sudo ln -s $NGINX_CONF $NGINX_LINK
fi
sudo nginx -t && sudo systemctl reload nginx

# Create a Python virtual environment
sudo -u $NEW_USER python3 -m venv $PROJECTS_DIR/venv

# Activate the virtual environment and install requirements
source $PROJECTS_DIR/venv/bin/activate
if [ -f "$PROJECTS_DIR/requirements.txt" ]; then
    pip install --no-cache-dir -r "$PROJECTS_DIR/requirements.txt"
fi
deactivate

# Create Gunicorn service file
GUNICORN_SERVICE="/etc/systemd/system/$NEW_USER-gunicorn.service"

cat <<EOL | sudo tee $GUNICORN_SERVICE
[Unit]
Description=gunicorn daemon for $NEW_USER Django project
After=network.target

[Service]
User=$NEW_USER
Group=$NEW_USER
WorkingDirectory=$PROJECTS_DIR
ExecStart=$PROJECTS_DIR/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8001 myproject.wsgi:application

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable Gunicorn service
sudo systemctl daemon-reload
sudo systemctl enable $NEW_USER-gunicorn
sudo systemctl start $NEW_USER-gunicorn

# Print completion message
echo "Setup completed successfully!"
