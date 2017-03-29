#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

# Installed from git clone https://github.com/ehalpern/aws-ec2-ssh.git

# IAM group containing users that should have sudo access
SUDOERS_GROUP=Sudoers

cp authorized_keys_command.sh /opt/authorized_keys_command.sh
cp import_users.sh /opt/import_users.sh

sudo sed -i 's/SudoersGroup=""/SudoersGroup="${SUDOERS_GROUP}"/' /opt/import_users.sh

sed -i 's:#AuthorizedKeysCommand none:AuthorizedKeysCommand /opt/authorized_keys_command.sh:g' /etc/ssh/sshd_config
sed -i 's:#AuthorizedKeysCommandUser nobody:AuthorizedKeysCommandUser nobody:g' /etc/ssh/sshd_config

echo "*/10 * * * * root /opt/import_users.sh" > /etc/cron.d/import_users
chmod 0644 /etc/cron.d/import_users

/opt/import_users.sh

service sshd restart
