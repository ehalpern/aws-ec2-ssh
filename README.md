## Manage AWS EC2 SSH access with IAM

This package automatically configures a Linux EC2 instance with SSH enabled
accounts that are defined and managed in IAM.
 
To enable, simply paste cloud-init into the instance **User Data** on launch.
When the instance boots, it will be automatically configured with SSH enabled
accounts configured in IAM.

### How it works

- The cloud-init script runs the follow steps when the instance launches (more info [here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-cloud-init))
    1. Installs git and clones this repo
    2. Runs install.sh which
        1. Creates an account for every user listed in the IAM group SSHUsers (import_users.sh)
        2. Gives each user sudo access
        3. Configures sshd to obtain ssh public keys from IAM (authorized_keys_commands.sh)
        4. Installs a cron entry to periodically import new users as they appear in SSHUsers
- This installation ensures that users added to SSHUsers automatically get accounts 
- And that each account can only be accessed using the current SSH key stored in their IAM account

### Troubleshooting

- The EC2 instance requires the permissions listed in iam_ssh_policy.json
- The logs for cloud-init can be found in /var/log/cloud-init.log and cloud-init-output.log
