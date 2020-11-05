#!/bin/bash

echo "INSTALLATION BEGINS"
echo "####### HPL #######"

wget https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz

tar -xvf hpl-2.3.tar.gz
rm hpl-2.3.tar.gz
cp Make.Linux_AMD_BLIS ./hpl-2.3
cd ./hpl-2.3
make arch=Linux_AMD_BLIS

echo "HPL DONE"


