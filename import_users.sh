#!/bin/bash
# Import all users listed in the IAM UsersGroup and assign each sudo privileges.

UsersGroup=""

aws iam get-group --group-name "${UsersGroup}" --query "Users[].[UserName]" --output text | while read User; do
  UserName="$User"

  # Replace any illegal characters
  UserName=${UserName//"+"/".plus."}
  UserName=${UserName//"="/".equal."}
  UserName=${UserName//","/".comma."}
  UserName=${UserName//"@"/".at."}

  # Add user if not already present
  if ! grep "^$UserName:" /etc/passwd > /dev/null; then
    /usr/sbin/useradd --create-home --shell /bin/bash "$UserName"
  fi

  # Add user entry in /etc/sudoers.d
  UserFileName=$(echo "$UserName" | tr "." " ")
  UserSudoFilePath="/etc/sudoers.d/$UserFileName"
  echo "$UserName ALL=(ALL) NOPASSWD:ALL" > "$UserSudoFilePath"
done
