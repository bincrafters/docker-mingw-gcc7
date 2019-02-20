FROM ubuntu:18.04
MAINTAINER SSE4 <tomskside@gmail.com>

ENV CMAKE_VERSION=3.11.4

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    python-setuptools \
    sudo \
    python-pip && \
    python -m pip install --upgrade pip && \
    python -m pip install --upgrade conan && \
    groupadd 1001 -g 1001 && \
    groupadd 1000 -g 1000 && \
    groupadd 2000 -g 2000 && \
    groupadd 999 -g 999 && \
    useradd -ms /bin/bash conan -g 1001 -G 1000,2000,999 && \
    printf "conan:conan" | chpasswd && \
    adduser conan sudo && \
    printf "conan ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

RUN curl https://cmake.org/files/v3.11/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz | tar -xz

RUN apt-get install -y g++-mingw-w64-x86-64 && \
    printf "1\n" | update-alternatives --config x86_64-w64-mingw32-gcc && \
    printf "1\n" | update-alternatives --config x86_64-w64-mingw32-g++

RUN apt-get install -y autoconf libtool

ENV CC=/usr/bin/x86_64-w64-mingw32-gcc \
    CXX=/usr/bin/x86_64-w64-mingw32-g++ \
    CMAKE_C_COMPILER=/usr/bin/x86_64-w64-mingw32-gcc \
    CMAKE_CXX_COMPILER=/usr/bin/x86_64-w64-mingw32-g++ \
    STRIP=/usr/bin/x86_64-w64-mingw32-strip \
    RANLIB=/usr/bin/x86_64-w64-mingw32-gcc-ranlib \
    AS=/usr/bin/x86_64-w64-mingw32-gcc-as \
    AR=/usr/bin/x86_64-w64-mingw32-gcc-ar \
    WINDRES=/usr/bin/x86_64-w64-mingw32-windres \
    RC=/usr/bin/x86_64-w64-mingw32-windres \
    CONAN_CMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32 \
    CHOST=x86_64-w64-mingw32

USER conan
WORKDIR /home/conan
RUN mkdir -p /home/conan/.conan

RUN conan profile new default --detect && \
    conan profile update settings.os=Windows default

ENV PATH=$PATH:/cmake-${CMAKE_VERSION}-Linux-x86_64/bin
