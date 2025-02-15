# linux-user-management
A Bash script for automating user management in Linux with MySQL integration and security policies.

# User Management System

## Overview
This project is a **User Management System** that provides basic functionalities to add, delete, list users, and enforce password policies. It is implemented using a **Bash script** and optionally integrates with **MySQL** for user record storage.

## Features
- **Add users** with password authentication
- **Delete users** from the system
- **List all users** in the system
- **Enforce password expiration policies**
- **Optional MySQL integration** for logging user data
- **Automated execution using cron jobs**

## Prerequisites
- Linux system (Ubuntu/CentOS recommended)
- Sudo (root) privileges
- Basic understanding of Bash scripting
- (Optional) MySQL installed for database logging

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/user-management-system.git
cd user-management-system
```

### 2. Install Required Packages
```bash
sudo apt update
sudo apt install mysql-server mysql-client -y
```

### 3. Setup MySQL Database (Optional)
If you want to store user records in MySQL, set up a database:

```sql
CREATE DATABASE user_management;
USE user_management;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Usage

### 1. Make the Script Executable
```bash
chmod +x user_management.sh
```

### 2. Run the Script
```bash
./user_management.sh
```

### 3. User Management Menu
When you run the script, it will display:
```
===== User Management System =====
1. Add User
2. Delete User
3. List Users
4. Set Password Policy
5. Exit
Enter your choice:
```

## Script Functions

### 1. Add User
Creates a new user and stores the record in MySQL (if enabled).
```bash
function add_user() {
    read -p "Enter the new username: " username
    if id "$username" &>/dev/null; then
        echo "User $username already exists!"
    else
        sudo useradd -m "$username"
        echo "User $username created successfully."
        sudo passwd "$username"

        # Store in MySQL
        mysql -u root -p -e "INSERT INTO user_management.users (username) VALUES ('$username');"
    fi
}
```

### 2. Delete User
Deletes a user from the system.
```bash
function delete_user() {
    read -p "Enter the username to delete: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "User $username deleted successfully."
    else
        echo "User $username does not exist!"
    fi
}
```

### 3. List Users
Lists all users on the system.
```bash
function list_users() {
    echo "Listing all users:"
    cut -d: -f1 /etc/passwd | sort
}
```

### 4. Set Password Policy
Enforces password expiration policies.
```bash
function set_password_policy() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        sudo chage -M 30 -W 7 "$username"
        echo "Password policy updated: $username must change password every 30 days."
    else
        echo "User $username does not exist!"
    fi
}
```

## Automating with Cron Jobs
To automate the execution of the script, use **cron jobs**.

### 1. Edit the Cron Jobs
```bash
crontab -e
```

### 2. Add the Following Entry (Runs the Script Daily at Midnight)
```bash
0 0 * * * /path/to/user_management.sh
```

## Troubleshooting

### 1. MySQL Connection Error: `Can't connect to local MySQL server`
- Ensure MySQL is installed:
  ```bash
  dpkg -l | grep mysql-server
  ```
- Start MySQL service:
  ```bash
  sudo systemctl start mysql
  ```
- Restart MySQL:
  ```bash
  sudo systemctl restart mysql
  ```

### 2. Permission Denied Error
- Run the script with sudo:
  ```bash
  sudo ./user_management.sh
  ```




