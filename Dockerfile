
ARG FROM_IMAGE=gcc:13.2.0
FROM FROM_IMAGE

RUN apt-get update \
    apt-get install -y git make cmake libopenmpi-dev libhdf5-openmpi-dev python3-dev python3-pip g++ ninja-build

ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# openmpi in docker issue
# https://github.com/open-mpi/ompi/issues/4948#issuecomment-395468231
# ENV OMPI_MCA_btl_vader_single_copy_mechanism=none

RUN git clone https://github.com/PHAREHUB/PHARE -b master --depth 1 --recursive --shallow-submodules phare; \
      cd phare; python3 -m pip install -r requirements.txt; \
      mkdir build; cd build; cmake .. -G Ninja; ninja; cd ..; \
      PYTHONPATH=$PWD:$PWD/build:$PWD/pyphare mpirun -n 2 ./build/src/phare/phare-exe src/phare/phare_init_small.py
