#!/bin/bash
#
# This script will allow you to perform a bulk power operation on selected
# VMs within a host. You must provide a host name, a regular expression
# pattern for the VM names that you wish to change and, finally, the command
# you wish to perform

HOST=$1
VM_PATTERN=$2
COMMAND=$3

if [ "$#" -lt 3 ]; then
    echo -e "Usage: $0 \033[4mhost_name\033[0m \033[4mvm_pattern\033[0m \033[4mcommand\033[0m"
    exit 1
fi

commands="on off reboot reset shutdown suspend suspendResume getstate hibernate"

if [[ $commands =~ $COMMAND ]]; then
    ssh $HOST "vim-cmd vmsvc/getallvms" | awk -F ' {2,}' '/^[0-9]+/ { if ($2 ~ "'$VM_PATTERN'") print $1 }' | xargs -n 1 ssh $HOST "vim-cmd vmsvc/power.$COMMAND"
else
    echo "Command must be one of:" $commands
    exit 2
fi
