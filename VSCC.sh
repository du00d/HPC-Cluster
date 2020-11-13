#!/bin/bash

mv * /data
cd /data
echo "INSTALLATION BEGINS"

#install cuda 11.0
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
sudo yum install cuda-11.0.1-1.x86_64

touch /etc/profile.d/cuda110.sh
export PATH=/usr/local/cuda-11.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
source /etc/profile.d/cuda110.sh

echo "####### HPCG ######"
wget http://www.hpcg-benchmark.org/downloads/xhpcg-3.1_cuda-11_ompi-4.0_sm_60_sm70_sm80

echo "####### HPL #######"

wget https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz

tar -xvf hpl-2.3.tar.gz
rm hpl-2.3.tar.gz
cp Make.Linux_AMD_BLIS ./hpl-2.3
cd ./hpl-2.3
make arch=Linux_AMD_BLIS

echo "HPL DONE"

echo "###### CESM #######"

sudo yum install "perl(XML::LibXML)" -y

cd /data

wget http://www.zlib.net/zlib-1.2.11.tar.gz
wget https://support.hdfgroup.org/ftp/HDF5/prev-releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz

tar -xvf netcdf-fortran-4.5.3.tar.gz
rm netcdf-fortran-4.5.3.tar.gz
tar -xvf zlib-1.2.11.tar.gz
rm zlib.1.2.11.tar.gz
tar -xvf hdf5-1.12.0.tar.gz
rm hdf5-1.12.0.tar.gz
tar -xvf netcdf-c.4.7.4.tar.gz
rm netcdf-c.4.7.4.tar.gz

#Build zlib

cd /data/zlib-1.2.11
ZDIR=/usr/local
sudo ./configure --prefix=${ZDIR}
sudo make check
sudo make install

#Build HDF5

cd /data/hdf5-1.12.0/
H5DIR=/usr/local
sudo ./configure --with-zlib=${ZDIR} --prefix=${H5DIR} --enable-hl
sudo make check
sudo make install

#Build netCDF
cd /data/netcdf-c-4.7.4
NCDIR=/usr/local
sudo CPPFLAGS='-I${H5DIR}/include -I${ZDIR}/include' LDFLAGS='-L${H5DIR}/lib -L${ZDIR}/lib' ./configure --prefix=${NCDIR} --disable-dap
LD_LIBRARY_PATH=/usr/local/lib

sudo echo '/usr/local/lib' >> /etc/ld.so.conf

sudo ldconfig

sudo make check

sudo make install

cd /data

#Build netCDF Fortran
cd /data/netcdf-fortran-4.5.3
NFDIR=/usr/local
sudo CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR}
sudo make check
sudo make install

#General weirdness and dependencies
sudo yum-config-manager --enable epel -y
sudo yum install netcdf-devel -y
sudo yum install cmake -y
sudo yum install netcdf-fortran-devel.x86_64 -y

echo "CESM DONE"
