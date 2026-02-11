#!/bin/sh
#
ushdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
basedir="$(dirname "$ushdir")"

agentfile=${basedir}/fix/.agent
filetype=$(file ${agentfile})
if [[ ! "${filetype}" == *"symbolic link"* ]]; then
  rm -rf ${agentfile}
fi
mkdir -p ${basedir}/fix
ln -snf ${RDAS_DATA}/fix ${agentfile}
touch ${basedir}/fix/INIT_DONE
