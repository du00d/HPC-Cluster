#!/bin/bash

mv * ../
cd ../
echo "INSTALLATION BEGINS"
echo "####### HPL #######"

wget https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz

tar -xvf hpl-2.3.tar.gz
rm hpl-2.3.tar.gz
cp Make.Linux_AMD_BLIS ./hpl-2.3
cd ./hpl-2.3
make arch=Linux_AMD_BLIS

echo "HPL DONE"

echo "###### CESM #######"

cd /data

wget http://www.zlib.net/zlib-1.2.11.tar.gz
wget https://support.hdfgroup.org/ftp/HDF5/prev-releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz

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
cd ..

#Build HDF5

cd hdf5-1.12.0/
H5DIR=/usr/local
sudo ./configure --with-zlib=${ZDIR} --prefix=${H5DIR} --enable-hl
sudo make check
sudo make install

#Build netCDF
cd netcdf-c-4.7.4
NCDIR=/usr/local
sudo CPPFLAGS='-I${H5DIR}/include -I${ZDIR}/include' LDFLAGS='-L${H5DIR}/lib -L${ZDIR}/lib' ./configure --prefix=${NCDIR} --disable-dap
LD_LIBRARY_PATH=/usr/local/lib

sudo echo '/usr/local/lib' >> /etc/ld.so.conf

sudo ldconfig

sudo make check

sudo make install

echo "CESM DONE"
