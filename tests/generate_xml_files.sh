#!/usr/bin/env bash
# shellcheck disable=SC2016
rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
wflow="${rundir}/../workflow"
cd "${wflow}" || exit 1
mkdir -p "${rundir}/xml"

# conus12km
myexp=conus12km
myfile=${wflow}/exp/exp.${myexp}
sed 's|^export OPSROOT=/scratch3/BMC/wrfruc/gge/OPSROOT/${EXP_NAME}|export OPSROOT=./OPSROOT/${EXP_NAME}|' "${myfile}" > "exp.test"
./setup_rocoto.py "exp.test"
mv "OPSROOT/hrly_12km/exp/rrfsdet/rrfs.xml" "${rundir}/xml/${myexp}_retro.xml"

{ cat "exp.test"; echo -e 'export REALTIME=true\nexport DO_IODA=false'; } > exp.tmp
./setup_rocoto.py exp.tmp
mv "OPSROOT/hrly_12km/exp/rrfsdet/rrfs.xml" "${rundir}/xml/${myexp}_rt.xml"

# ens_conus12km
myexp=ens_conus12km
myfile=${wflow}/exp/exp.${myexp}
sed 's|^export OPSROOT=/scratch3/BMC/wrfruc/gge/OPSROOT/${EXP_NAME}|export OPSROOT=./OPSROOT/${EXP_NAME}|' "${myfile}" > "exp.test"
./setup_rocoto.py "exp.test"
mv "OPSROOT/hrly_12km/exp/rrfsenkf/rrfs.xml" "${rundir}/xml/${myexp}_retro.xml"

{ cat "exp.test"; echo -e 'export REALTIME=true'; } > exp.tmp
./setup_rocoto.py exp.tmp
mv "OPSROOT/hrly_12km/exp/rrfsenkf/rrfs.xml" "${rundir}/xml/${myexp}_rt.xml"

# ens_conus12km
# conus3km
# ens_conus3km
# na12km
# ens_na12km
