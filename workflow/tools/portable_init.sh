#!/usr/bin/env bash
#
# shellcheck disable=SC1091
run_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
agent_dir="${run_dir}/../../fix/.agent"

mkdir -p "${run_dir}/../../fix"

filetype=$(file "${agent_dir}")
if [[ ! "${filetype}" == *"symbolic link"* ]]; then
  rm -rf "${agent_dir}"
fi
ln -snf "${FIX_RRFS_LOCATION}"  "${agent_dir}"

touch "${run_dir}/../../fix/INIT_DONE"
"${run_dir}"/link_extra_meshes.sh
