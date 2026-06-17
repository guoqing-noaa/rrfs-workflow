#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2153,SC2154
declare -rx PS4='+${SECONDS}s $(basename ${BASH_SOURCE[0]:-${FUNCNAME[0]:-"Unknown"}})[${LINENO}]: '
set -x
cpreq=${cpreq:-cpreq}

cd "${DATA}" || exit 1

# link the prepbufr file
${cpreq} "${OBSPATH}/${CDATE}.rap.t${cyc}z.prepbufr.tm00" prepbufr
${cpreq} "${EXECrrfs}"/bufr2ioda.x .
${cpreq} "${EXECrrfs}"/bufr2netcdf.x .

# generate the namelist on the fly
REFERENCE_TIME="${CDATE:0:4}-${CDATE:4:2}-${CDATE:6:2}T${CDATE:8:2}:00:00Z"
yaml_list=(
"prepbufr_adpsfc.yaml"
#"prepbufr_adpupa.yaml"
#"prepbufr_aircar.yaml"
#"prepbufr_aircft.yaml"
#"prepbufr_ascatw.yaml"
"prepbufr_msonet.yaml"
#"prepbufr_proflr.yaml"
#"prepbufr_rassda.yaml"
#"prepbufr_sfcshp.yaml"
#"prepbufr_vadwnd.yaml"
#"bufr2ioda_cris-fsr.yaml"
)


# run bufr2ioda.x
for yaml in "${yaml_list[@]}"; do
 sed -e "s/@referenceTime@/${REFERENCE_TIME}/" "${PARMrrfs}/${yaml}" > "${yaml}"
 source prep_step
 ./bufr2ioda.x "${yaml}"
 # some data may not be available at all cycles, so we don't check whether bufr2ioda.x runs successfully
done


# file count sanity check and copy to COMOUT
if ls ./ioda*nc; then
  ${cpreq} "${DATA}"/ioda*.nc "${COMOUT}/ioda_bufr/${WGF}"
else
  echo "FATAL ERROR: no ioda files generated."
  err_exit # err_exit if no ioda files generated at the development stage
fi
