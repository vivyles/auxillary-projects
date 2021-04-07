#!/bin/bash

# Author: Vivian V
# Date      : 04/06/2021
# Purpose   : Onboarding users, adding users to a specified group.

clear


# user names are in
file=names.csv

# default of ssh directory stored in a variable
ssh=/etc/skel/.ssh

# authorized key file in a variable
key=authorized_keys

# Ensure Group has been created manually, then  add and set default user password and group to new user
group='developers'
pass='America@2016'

# populate skel directory with ssh folder
if [ -d "$ssh" ] ;
then
    echo
    echo "ssh folder already exist."
    echo
else
    sudo mkdir -p $ssh
    sudo bash -c "echo $key >> $ssh/authorized_keys"
    echo "$ssh directory is now created and ready for use"
    echo 
fi

while IFS= read user
    do
        # check if user already exists
        if [ $(getent passwd $user) ] ;
        then
            echo " This user - $user already exists."
            echo
        else

            sudo useradd -m -G $group -s /bin/bash $user
            sudo echo -e "$pass\n$pass" | sudo passwd "${user}"
            sudo passwd -x 3 ${user}
            sudo chmod 600 /home/$user/.ssh
            sudo chmod 600 /home/$user/.ssh/authorized_keys
            sudo chown $user /home/$user/.ssh/authorized_keys
            echo "$user created..."
            echo 
        fi
        done < $file && echo "User creation successfully completed."
