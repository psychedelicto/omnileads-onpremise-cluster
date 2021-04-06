#!/bin/bash

echo "******************** fix hostname and localhost issue on some cloud instances ***************************"
echo "******************** fix hostname and localhost issue on some cloud instances ***************************"
TEMP_HOSTNAME=$(hostname)
sed -i 's/127.0.0.1 '$TEMP_HOSTNAME'/#127.0.0.1 '$TEMP_HOSTNAME'/' /etc/hosts
sed -i 's/::1 '$TEMP_HOSTNAME'/#::1 '$TEMP_HOSTNAME'/' /etc/hosts
