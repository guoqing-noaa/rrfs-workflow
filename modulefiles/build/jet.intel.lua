help([[
This module loads libraries for building the MPAS App on
the NOAA RDHPC machine Jet using Intel-2021.5.0
]])

whatis([===[Loads libraries needed for building the MPAS Workflow on Jet ]===])
prepend_path("MODULEPATH","/mnt/lfs4/HFIP/hfv3gfs/role.epic/spack-stack/spack-stack-1.5.0/envs/unified-env-rocky8/install/modulefiles/Core")
prepend_path("MODULEPATH", "/lfs4/HFIP/hfv3gfs/spack-stack/modulefiles")

load("stack-intel/2021.5.0")
load("cmake/3.23.1")
load("gnu")
load("intel/2022.1.2")
load("impi/2022.1.2")

load("pnetcdf")
load("szip")
load("hdf5parallel/1.10.6")
load("netcdf-hdf5parallel/4.7.4")

setenv("PIO", "/lfs5/BMC/nrtrr/FIX_RRFS2/PIOV2")

prepend_path("MODULEPATH","/lfs5/BMC/nrtrr/FIX_RRFS2/modulefiles")
load("prod_util/2.1.1")

setenv("CMAKE_C_COMPILER","mpiicc")
setenv("CMAKE_CXX_COMPILER", "mpiicc")
setenv("CMAKE_Fortran_COMPILER", "mpiifort")
