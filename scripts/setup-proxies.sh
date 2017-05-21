#!/bin/bash

#sed '/\# PROXIES/,$d' ~/.bashrc >> ~/.bashrc
source ~/.zshrc
cat <<EOF >> ~/.zshrc

# PROXIES

export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=<PROXY> -Dhttp.proxyPort=<PORT> -Dhttp.proxyUser=<USERNAME> -Dhttp.proxyPassword=<PASSWORD>"
export SBT_OPTS="$SBT_OPTS -Dhttp.proxyHost=<PROXY> -Dhttp.proxyPort=<PORT> -Dhttp.proxyUser=<USERNAME> -Dhttp.proxyPassword=<PASSWORD>"
export http_proxy=http://<USERNAME>:<PASSWORD>@<PROXY>:<PORT>
export https_proxy=http://<USERNAME>:<PASSWORD>@<PROXY>:<PORT>
export HTTP_PROXY=http://<USERNAME>:<PASSWORD>@<PROXY>:<PORT>
export HTTPS_PROXY=https://<USERNAME>:<PASSWORD>@<PROXY>:<PORT>

EOF
