#!/bin/bash

# Function to add a user
add_user() {
    read -p "Enter the new username: " username
    if id "$username" &>/dev/null; then
        echo "User $username already exists!"
    else
        sudo useradd -m "$username"
        echo "User $username created successfully."
        sudo passwd "$username"
    fi
}
# Function to delete a user
delete_user() {
    read -p "Enter the username to delete: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "User $username deleted successfully."
    else
        echo "User $username does not exist!"
    fi
}
# Function to list all users
list_users() {
    echo "Listing all users:"
    cut -d: -f1 /etc/passwd | sort
}
# Function to set password expiration policy
set_password_policy() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        sudo chage -M 30 -W 7 "$username"
        echo "Password policy updated: $username must change password every 30 days."
    else
        echo "User $username does not exist!"
    fi
}

add_user() {
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



#!/bin/bash

echo "===== User Management System ====="
echo "1. Add User"
echo "2. Delete User"
echo "3. List Users"
echo "4. Set Password Policy"
echo "5. Exit"
read -p "Enter your choice: " choice

case $choice in
    1) add_user ;;
    2) delete_user ;;
    3) list_users ;;
    4) set_password_policy ;;
    5) exit ;;
    *) echo "Invalid option!" ;;
esac
