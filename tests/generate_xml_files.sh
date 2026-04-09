#!/usr/bin/env python
# shellcheck disable=SC1091
run_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
wflow="${run_dir}/../workflow"
cd "${wflow}" || exit 1

# conus12km
exp=conus12km
expfile=${wflow}/exp/exp.${exp}
sed -i 's|^export OPSROOT=/scratch3/BMC/wrfruc/gge/OPSROOT/${EXP_NAME}|export OPSROOT=./${EXP_NAME}|' "${expfile}"
./setup_rocoto.py "${expfile}"
mv "hrly_12km/rrfsdet/rrfs.xml" "${rundir}/xml/${exp}.xml"

# ens_conus12km
exp=ens_conus12km
expfile=${wflow}/exp/exp.${exp}
sed -i 's|^export OPSROOT=/scratch3/BMC/wrfruc/gge/OPSROOT/${EXP_NAME}|export OPSROOT=./${EXP_NAME}|' "${expfile}"
./setup_rocoto.py "${expfile}"
mv "hrly_12km/rrfsenkf/rrfs.xml" "${rundir}/xml/${exp}.xml"

# ens_conus12km
# conus3km
# ens_conus3km
# na12km
# ens_na12km
