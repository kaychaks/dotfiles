#!/usr/bin/env bash
#
# This script is useful to setup additional users in EC2 instances who can login with their own public keys rather than using a global public key
# We should do it via OpsWorks but sometimes when OpsWorks go crazy, we have to take things in our hand
# There will be bugs
#

declare -r script_name="add-user"

log () { echo >&2 "$@"; }

usage () {
    cat <<EOF
Usage: $script_name <user name> <path to public key>

NOTE: User name should not have any space and public key file should be present
EOF
}

createUser () {
    local username="$1"

    getent group admin || groupadd admin
    sudo adduser --quiet --home /home/"$username" --shell /bin/bash --ingroup admin "$username" --disabled-password --gecos ""
}

addUserToSudoers () {
    local username="$1"

    echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
}

loadSSHKeyForUser () {
    local username="$1"
    local keyfile="$2"

    sudo -u "$username" mkdir /home/"$username"/.ssh
    cat "$keyfile" |  sudo -u "$username" tee -a /home/"$username"/.ssh/authorized_keys > /dev/null
}

fixPermissionsOnFiles () {
    local username="$1"

    sudo -u "$username" chmod 600 /home/"$username"/.ssh/*;sudo -u "$username" chmod 700 /home/"$username"/.ssh
}

process_args () {
    local username="$1"
    local keyfile="$2"
    
    if [[ -n "$username" && -f "$keyfile"  ]]; then
        createUser "$username"
        addUserToSudoers "$username"
        loadSSHKeyForUser "$username" "$keyfile"
        fixPermissionsOnFiles "$username"
    else
        usage
    fi
}

process_args "$1" "$2"
