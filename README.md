Django Project Setup Script for Ubuntu Server
This script automates the process of setting up a Django development environment on an Ubuntu server. It installs and configures all the necessary components, including MySQL, Nginx, Gunicorn, and Python dependencies.

Features
Adds a new user with a home directory for the Django project.
Creates a Python virtual environment for your Django project.
Installs and configures essential packages (Python, MySQL, Nginx, Gunicorn, etc.).
Configures Nginx to serve static and media files.
Sets up a Gunicorn service to run the Django project.
Configures MySQL with a secure installation and creates a user and database.
Sets up SSH with password authentication for the newly created user.
Grants the user specific sudo privileges to manage essential system tasks.
Requirements
Ubuntu Server (any version that supports the necessary packages).
A basic understanding of Django and web deployment concepts.
A pre-existing Django project to deploy.
Getting Started
Prerequisites
Ensure you have the following:

An Ubuntu server instance (with a clean installation).
A GitHub repository or a local copy of your Django project.
Usage
Download or Clone the Script

Clone or download the bash script to your Ubuntu server:

bash
Copy code
git clone https://github.com/yourusername/yourrepository.git
Run the Script

Once you have the script, run it as a superuser (root or sudo):

bash
Copy code
chmod +x setup.sh
sudo ./setup.sh
Configure the Django Project

Ensure that your Django project’s requirements.txt file is in the /home/myuser/projects/ directory, or modify the script to point to your specific project directory.

Verify the Setup

After the script has completed, you should be able to:

Access the Django project through Nginx at http://<your_server_ip>/.
SSH into the server using the created user and password.
Use the configured MySQL database for your Django project.
Post-Setup Configuration
If you need to add other services or modify the Nginx configuration, you can edit the file in /etc/nginx/sites-available/myuser and reload Nginx:

bash
Copy code
sudo nginx -t && sudo systemctl reload nginx
To manage the Gunicorn service, you can use the following commands:

bash
Copy code
sudo systemctl start myuser-gunicorn
sudo systemctl stop myuser-gunicorn
sudo systemctl restart myuser-gunicorn
Sudo Access Configuration
The created user (myuser) will have specific sudo access to manage system tasks without requiring a password for the following commands:

/usr/bin/apt
/usr/bin/apt-get
/usr/bin/nano
/usr/bin/systemctl
To modify or add additional sudo permissions, you can edit the /etc/sudoers file.

MySQL Configuration
The script will create the following MySQL database setup:

Database Name: mydb
Database User: mydbuser
User Password: dbpassword
Make sure to modify these credentials if necessary.

Customization
You can modify several parts of the script to fit your specific environment:

Change the default values for the NEW_USER, PASSWORD, DB_NAME, DB_USER, and DB_PASSWORD variables.
Adjust the Nginx configuration if you're deploying a different project structure.
Add any additional software or services to the script as needed.
Troubleshooting
If you encounter any issues:

Check the Nginx error log located at /var/log/nginx/myuser-error.log.
Ensure that all necessary ports (e.g., 80, 443) are open in your firewall.
Verify the MySQL service is running with sudo systemctl status mysql.
