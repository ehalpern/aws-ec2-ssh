#!/bin/bash -e
# ssh_config AuthorizedKeysCommand script. Obtains the authorized key for a user using from IAM
# using aws iam list-ssh-public-keys

if [ -z "$1" ]; then
  exit 1
fi

User="$1"

# Transform into a legal username
User=${User//"+"/".plus."}
User=${User//"="/".equal."}
User=${User//","/".comma."}
User=${User//"@"/".at."}

aws iam list-ssh-public-keys --user-name "$User" --query "SSHPublicKeys[?Status == 'Active'].[SSHPublicKeyId]" --output text | while read KeyId; do
  aws iam get-ssh-public-key --user-name "$User" --ssh-public-key-id "$KeyId" --encoding SSH --query "SSHPublicKey.SSHPublicKeyBody" --output text
done
