#! /usr/bin/env bash
#
# Author: Larissa Reames CIWRO/NOAA/NSSL/FRDD

#set -eux

set_defaults() {
    target=""
    compiler="intel"
    debug="true"
    config_yaml=""
}

usage() {
    set_defaults # restore defaults so usage is correct
    echo
    echo "Usage: $0 [options]"
    echo
    echo "  -c  compiler to use for build                 DEFAULT: $compiler"
    echo "  -d  build with debug options [true | false]   DEFAULT: $debug"
    echo "  -h  display this message and quit"
    echo "  -m  target machine   Name of machine to use for build target"
    echo "  -y  config.yaml      Name of yaml config file to configure build environment"
    echo "                       The -c and -m options are ignored if this option is used."
    echo
    exit 1
}

set_defaults

while getopts ":c:d:m:y:h" opt; do
    case $opt in
        c)
        compiler=$OPTARG
        ;;
        d)
        debug=$OPTARG
        ;;
        m)
        target=$OPTARG
        ;;
        y)
        config_yaml=$OPTARG
        ;;
        h)
        usage
        ;;
        \?)
        echo "Invalid option: -$OPTARG" >&2
        usage
        ;;
        :)
        echo "Option -$OPTARG requires an argument." >&2
        usage
        ;;
    esac
done

# Set base CMAKE flags
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=../ -DEMC_EXEC_DIR=ON -DBUILD_TESTING=OFF"

if [[ -z "$config_yaml" ]]; then
    # Auto-detect platform and load modules

    # If target is not set
    if [[ "$target" == "" ]]; then
        source ./machine-setup.sh
    fi

    echo "target=$target, compiler=$compiler"

    if [[ "$target" == "" ]]; then
    echo "target is not set and the platform name cannot be detected automatically"
    exit 1
    fi

    # Check for platform/compiler configuration file
    if [[ ! -f modulefiles/build.$target && ! -f modulefiles/build.$target.$compiler.lua && ! -f modulefiles/build.$target.$compiler ]]; then
        echo "Platform ${target} configuration file not found in ./modulefiles, neither build.$target nor build.$target.$compiler.lua"
        exit 1
    fi

    if [[ "$target" == "vecna" ]]; then
        echo "Use platform configuration file: build.$target.$compiler"
        source ./modulefiles/build.$target.$compiler > /dev/null
    elif [[ "$target" == "linux.*" || "$target" == "macosx.*" ]]; then
        unset -f module
        echo "Use platform configuration file: build.$target"
        source ./modulefiles/build.$target > /dev/null
    else
        echo "Use platform configuration file: build.$target.$compiler.lua"
        module use ./modulefiles
        module load build.$target.$compiler.lua
        module list
    fi

    # CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=../ -DEMC_EXEC_DIR=ON -DBUILD_TESTING=OFF"
    if [[ "$target" == "wcoss2" ]]; then
        CMAKE_FLAGS="${CMAKE_FLAGS} -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=CC -DCMAKE_Fortran_COMPILER=ftn"
    elif [[ "$compiler" == "intel-llvm" ]]; then
        CMAKE_FLAGS="${CMAKE_FLAGS} -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DCMAKE_Fortran_COMPILER=ifx"
    fi
else
    # Set up the environment based on provided config yaml file
    mpassit_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    set +x
    source "${mpassit_home}/configure.sh" "${config_yaml}" "mpassit" || exit 1
    module list
    set -x
fi

if [[ "${debug}" == "true" ]]; then
    CMAKE_FLAGS="${CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=Debug"
else
    CMAKE_FLAGS="${CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=Release"
fi

# for a clean build folder
rm -fr ./build
mkdir ./build && cd ./build || exit 0

# do the building
cmake .. ${CMAKE_FLAGS}

make -j 8 VERBOSE=1
make install

exit 0
