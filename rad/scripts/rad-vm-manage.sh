#!/bin/bash
#
# Manage home R&D network buils on VMs

VM_MANAGE=VBoxManage

# file listing all VMs for R&D home network
RAD_VMS_LIST="~/.rad_vms"

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

# list available R&D VMs
function rad_list_vms()
{
   local rad_vms=
   local available_vms=
   local available_rad_vms=

   # read all VMs belonging to R&D network   
   if [ -f "$RAD_VMS_LIST" ]; then
      echo "Found $RAD_VMS_LIST"

      rad_vms=cat "$RAD_VMS_LIST"

      echo "*** RAD VMS ***"
      echo "$rad_vms"
   fi

   # read all available VMs
   available_vms=$(vm_manage list vms)
 
   echo "*** AVAILABLE VMS ***"
   echo "$available_vms"

   # get the list of VMs that are available
   # for each rad vm
   #  check if available
   #     if yes, add to available rad vms

}

function rad_start_all_vms()
{
   local rad_vms=$(rad_list_vms)

   # for each rad_vm
   #  vm_manage start rad_vm
  
}

function rad_add_rad_vm()
{
   exit
}

if [ "$1" == "startvm-all" ]; then
   rad_start_all_vms
elif [ "$1" == "list-vms" ]; then
   rad_list_vms
else
   vm_manage $1 $2
fi


exit 0
