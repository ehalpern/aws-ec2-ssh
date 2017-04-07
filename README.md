## Automatic SSH enabled accounts on EC2 from IAM accounts

Simply paste bootstrap.sh ()or cloud-init) into the instance user-data on startup.
The instance will be automatically configured with ssh-only accounts for IAM users.

### How it works

- Paste bootstrap.sh or clout-init script into the user-data field on instance creation
- This script runs the following steps when the instance boots
    1. Installs git and clones this repo
    2. Runs install.sh
        1. Creates an account for every user listed in the IAM group USER_GROUP (import_users.sh)
        2. Gives each user sudo access
        3. Configures sshd to obtain ssh public keys from IAM (authorized_keys_commands.sh)
        4. Installs a cron entry to periodically import new users as they appear in USER_GROUP
- This installition ensures that users added to USER_GROUP automatically get accounts. 
- And that each account can only be accessed using the current SSH key stored in their IAM account

### Limitations

* EC2 instances need access to the AWS API
* It can take up to 10 minutes until a new IAM user can log in
* If you delete the IAM user / ssh public key and the user is already logged in, the SSH session will not be closed
* Not all IAM user names are allowed in Linux user names. See section [IAM user names and Linux user names](#iam-user-names-and-linux-user-names) for further details.

### IAM user names and Linux user names

Allowed characters for IAM user names are:
> alphanumeric, including the following common characters: plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-).

Allowed characters for Linux user names are (POSIX ("Portable Operating System Interface for Unix") standard (IEEE Standard 1003.1 2008)):
> alphanumeric, including the following common characters: period (.), underscore (_), and hyphen (-).

Therefore, characters that are allowed in IAM user names but not in Linux user names:
> plus (+), equal (=), comma (,), at (@).

This solution will use the following mapping for those special characters when creating users:
* `+` => `.plus.`
* `=` => `.equal.`
* `,` => `.comma.`
* `@` => `.at.`

So instead of `name@email.com` you will need to use `name.at.email.com` when login via SSH.
