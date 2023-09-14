MACHINE="orion"
ACCOUNT="fv3-cam"
HPSS_ACCOUNT="fv3-cam"
EXPT_SUBDIR="test_nonDA_netcdf"

envir="test"
NET="test"
TAG="c0v00"
MODEL="test"
RUN="test"

STMP="/work/noaa/fv3-cam/${USER}/test_nonDA_netcdf"
PTMP="/work/noaa/fv3-cam/${USER}/test_nonDA_netcdf"

VERBOSE="TRUE"
PRINT_ESMF="TRUE"

USE_CRON_TO_RELAUNCH="TRUE"
CRON_RELAUNCH_INTVL_MNTS="03"

PREEXISTING_DIR_METHOD="rename"

WFLOW_XML_TMPL_FN="FV3LAM_wflow_nonDA.xml"

PREDEF_GRID_NAME="RRFS_CONUS_25km"
QUILTING="TRUE"

CCPP_PHYS_SUITE="FV3_GFS_v16"
FCST_LEN_HRS="6"
LBC_SPEC_INTVL_HRS="6"

DATE_FIRST_CYCL="20230217"
DATE_LAST_CYCL="20230217"
CYCL_HRS=( "06" )

RUN_TASK_MAKE_GRID="TRUE"
RUN_TASK_MAKE_OROG="TRUE"
RUN_TASK_MAKE_SFC_CLIMO="TRUE"

EXTRN_MDL_NAME_ICS="FV3GFS"
EXTRN_MDL_NAME_LBCS="FV3GFS"

FV3GFS_FILE_FMT_ICS="netcdf"
FV3GFS_FILE_FMT_LBCS="netcdf"

WTIME_RUN_FCST="00:30:00"
PPN_RUN_FCST="12"

DO_NON_DA_RUN="TRUE"
DO_RETRO="TRUE"
VCOORD_FILE="global_hyblev.l65.txt"

USE_USER_STAGED_EXTRN_FILES="TRUE"
EXTRN_MDL_SOURCE_BASEDIR_ICS="/work/noaa/epic-ps/role-epic-ps/UFS_SRW_data/develop/input_model_data/FV3GFS/netcdf/2023021706"
EXTRN_MDL_SOURCE_BASEDIR_LBCS="/work/noaa/epic-ps/role-epic-ps/UFS_SRW_data/develop/input_model_data/FV3GFS/netcdf/2023021706"
