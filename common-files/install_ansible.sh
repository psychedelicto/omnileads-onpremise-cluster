#!/bin/bash

installAnsible()
{
  pip3 install pip --upgrade
  pip3 install "ansible==$1"
  export PATH="$HOME/.local/bin/:$PATH"
}
