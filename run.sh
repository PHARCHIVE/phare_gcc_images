#!/usr/bin/env bash

set -ex

apt-get update
apt-get install -y git make cmake libopenmpi-dev libhdf5-openmpi-dev g++ ninja-build python3-dev python3-pip gfortran-

git clone https://github.com/PHAREHUB/PHARE -b master --depth 1 --recursive --shallow-submodules phare

(
    cd phare
    python3 -m pip install --break-system-packages -r requirements.txt;
    mkdir build
    cd build
    cmake ..
)

(
    cd phare/subprojects/samrai
    mkdir build
    cd build
    cmake .. -DENABLE_SAMRAI_TESTS=OFF -DCMAKE_BUILD_TYPE=Release
    make -j2
    make install
    cd ../..
    rm -rf samrai
)

(
    cd phare/build
    rm -rf *
    cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -G Ninja            \
          -DlowResourceTests=ON -DCMAKE_BUILD_TYPE=Release     \
          -DCMAKE_CXX_FLAGS="-DPHARE_DIAG_DOUBLES=1 -O2" ..
    ninja 2>&1 | tee ../build.log
    ctest -j2 --output-on-failure
    cd ..
    PYTHONPATH=$PWD:$PWD/build:$PWD/pyphare mpirun -n 2 ./build/src/phare/phare-exe src/phare/phare_init_small.py
)

apt-get autoremove -y libgfortran* g++ gfortran* cmake make
apt-get autoclean
