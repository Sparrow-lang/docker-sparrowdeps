FROM ubuntu:16.04

# Install needed packages
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties python-pip cmake
RUN apt-get install -y m4 perl xz-utils

RUN add-apt-repository ppa:ubuntu-toolchain-r/test --yes

RUN apt-get update
RUN apt-get install -y gcc-5 g++-5
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5

RUN pip install --upgrade pip
RUN pip install conan

RUN conan user

# Copy the conanfile.txt and ensure that all dependencies are built
RUN mkdir /sparrow_deps
COPY conanfile.txt /sparrow_deps/
RUN mkdir /sparrow_deps/build
WORKDIR /sparrow_deps/build
RUN conan install .. --build=missing

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /sparrow_deps/*
