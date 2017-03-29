#!/bin/bash
# Installed and then called from bootstrap.sh or cloud-init

# IAM group containing users who should have ssh accessible accounts
SSH_USERS=${SSH_USERS-SSHUsers}

cd "$( dirname "${BASH_SOURCE[0]}" )"

cp authorized_keys_command.sh /opt/authorized_keys_command.sh
cp import_users.sh /opt/import_users.sh

sudo sed -i "s/UsersGroup=\"\"/UsersGroup='${SSH_USERS}'/" /opt/import_users.sh

sed -i 's:#AuthorizedKeysCommand none:AuthorizedKeysCommand /opt/authorized_keys_command.sh:g' /etc/ssh/sshd_config
sed -i 's:#AuthorizedKeysCommandUser nobody:AuthorizedKeysCommandUser nobody:g' /etc/ssh/sshd_config

echo "*/10 * * * * root /opt/import_users.sh" > /etc/cron.d/import_users
chmod 0644 /etc/cron.d/import_users

/opt/import_users.sh

service sshd restart
