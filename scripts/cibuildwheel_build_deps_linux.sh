#! /bin/bash

# ==============================================================================

install_from_github()
{
    base_url=https://github.com/Takishima/manylinux2010/releases/download/
    pkg_full=$1
    shift
    pkg_name=$1
    shift

    echo "wget -nv $base_url/$pkg_full/${pkg_name}_$(uname -p).tar.gz"
    wget -nv $base_url/$pkg_full/${pkg_name}_$(uname -p).tar.gz
    
    echo "tar zxvf ${pkg_name}_$(uname -p).tar.gz && rm -f ${pkg_name}_$(uname -p).tar.gz"
    tar zxvf ${pkg_name}_$(uname -p).tar.gz && rm -f ${pkg_name}_$(uname -p).tar.gz
    
    echo "rpm -i $(uname -p)/*.rpm && /bin/rm -rf $(uname -p)"
    rpm -i $(uname -p)/*.rpm && /bin/rm -rf $(uname -p)
}

# ==============================================================================

if [[ $(rpm -E %{rhel}) -gt 6 ]]; then
    echo 'source scl_source enable devtoolset-9' >> ~/.bashrc
    source scl_source enable devtoolset-9
else
    echo 'source scl_source enable devtoolset-8' >> ~/.bashrc
    source scl_source enable devtoolset-8
fi

yum install -y git wget
yum install -y openmpi-devel

if [[ $(rpm -E %{rhel}) -gt 6 ]]; then
    if [[ $(uname -p) == 'x86_64' ]]; then
        yum install -y cmake3
    else
	echo 'i686 not supported right now!'
	exit 1
    fi

    ALT_FAMILY_ARG=('--family' 'cmake')
else
    install_from_github "cmake-3.17.3" "cmake3"

    ALT_FAMILY_ARG=()
fi

alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
             --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
             --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
             --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
             ${ALT_FAMILY_ARG[@]}

# ==============================================================================

