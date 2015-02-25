#! /bin/sh

if [ $1 ]; then
  wget "http://doepner.net/software/vms/installers/$1.tgz"
  tar xvzf "$1.tgz"
  cd "$1"
  ./install.sh
  cd
else 
  echo "Usage: install.sh [installer-name]"
fi
