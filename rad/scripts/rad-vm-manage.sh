#!/bin/bash
#
# Manage home R&D network buils on VMs

VM_MANAGE=VBoxManage

# file listing all VMs for R&D home network
RAD_VMS=.rad_vms
HOME_DIR=~
ETC_DIR=/etc/rad.d

USER_RAD_VMS=$HOME_DIR/$RAD_VMS
GLOBAL_RAD_VMS=$ETC_DIR/$RAD_VMS

# TODO: alternatively think of entire setup suites that will put this into /ets/rad.d/rad_vms

function usage()
{
   echo "Manage R&D home network."
   echo "list-vms"
   echo "startvm-all"
   echo "else: wrap VBoxManage command"
}

function vm_manage()
{
   $VM_MANAGE $1 $2
}

function rad_get_rad_vms()
{
   [ -e "$USER_RAD_VMS" ] && echo "$USER_RAD_VMS"
   [ -e "$GLOBAL_RAD_VMS" ] && echo "$GLOBAL_RAD_VMS"

   echo ""
}

# check if VM is available
function rad_is_available_vm()
{
   local vm="$1"

   if [ ! -z "$vm" ]; then
      # read all available VMs
      available_vms=$(vm_manage list vms)
      # TODO: more robust solution if vm is temporarly commented out
      [ ! -z "$(echo $available_vms | grep $vm)" ] && return 0
   fi

   return 1
}

# list available R&D VMs
function rad_list_vms()
{
   local rad_vms=
   local available_vms=
   local available_rad_vms=

   # read all VMs belonging to R&D network   
   if [ -e "$USER_RAD_VMS" ]; then
      rad_vms="$(cat $USER_RAD_VMS)"
   fi

   # read all available VMs
   available_vms=$(vm_manage list vms)
 
   # get the list of VMs that are available
   local vm   
   while read vm; do
      [ ! -z "$(echo $available_vms | grep $vm)" ] && available_rad_vms="$available_rad_vms$vm "
   done < "$USER_RAD_VMS"

   echo "$available_rad_vms"
}

# list available R&D VMs
function rad_list_vms2()
{
   local available_rad_vms=

   # get the list of VMs that are available
   while read vm; do
      rad_is_available_vm $vm && available_rad_vms="$available_rad_vms$vm "
   done < "$(rad_get_rad_vms)"

   echo "$available_rad_vms"
}


function rad_start_all_vms()
{
   local vm

   for vm in $(rad_list_vms); do
      #TODO: if not already running
      echo "vm_manage startvm $vm"
   done
}

function rad_vm_add()
{
   local vm="$1"

   # TODO: more robust solution if we want to temporarly comment out machine
   # make sure it's not already on the list   
   if [ -z "$(cat $(rad_get_rad_vms) | grep $vm)" ] ; then
      rad_is_available_vm $vm && echo "$vm" >> "$(rad_get_rad_vms)"  
   fi
}

if [ "$1" == "startvm-all" ]; then
   rad_start_all_vms
elif [ "$1" == "list-vms" ]; then
   rad_list_vms2
elif [ "$1" == "add-vm" ]; then
   rad_vm_add $2
else
   vm_manage $1 $2
fi


exit 0
