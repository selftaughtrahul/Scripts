Django Project Setup Script 🚀
This script automates the setup of a Django project on an Ubuntu server, including configuring MySQL, Nginx, and Gunicorn for a seamless deployment environment.

Features ⚙️
System Updates: Updates and upgrades the server packages.
User Setup: Creates a new user and project directory.
Permissions: Configures correct file permissions for the project.
MySQL Setup: Installs and configures MySQL, creates a database and user.
Nginx Configuration: Sets up Nginx to serve static/media files and proxy Django requests.
Virtual Environment: Creates a Python virtual environment and installs dependencies.
Gunicorn Setup: Configures Gunicorn to serve the Django app.
Firewall Configuration: Allows necessary ports for SSH and Nginx.
Sudoers Setup: Grants specific sudo privileges to the user.
Requirements 🛠️
Ubuntu Server (any version supporting necessary packages).
Django Project (with requirements.txt).
Installation 📝
Clone or Download the Script:

bash
Copy code
git clone (https://github.com/selftaughtrahul/Scripts.git)
Run the Script:

bash
Copy code
chmod +x setup.sh
sudo ./setup.sh
Verify:

Access the project at http://<your_server_ip>/.
Check MySQL connection and configure as needed.
Customization 🔧
Modify NEW_USER, PASSWORD, DB_NAME, DB_USER, DB_PASSWORD in the script to match your requirements.
Adjust the Nginx config and Gunicorn service as needed.
