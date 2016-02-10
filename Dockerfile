# Dockerfile for building gnuradio with rtl-sdr support
FROM debian:jessie
MAINTAINER Ash Wilson

ENV GNURADIO_REPO_TAG=v3.7.9.1

ENV GIT_BASE=/src/git
ENV RTLSDR_GIT=git://git.osmocom.org/rtl-sdr
ENV GR_IQBAL_GIT=git://git.osmocom.org/gr-iqbal.git
ENV UHD_GIT=https://github.com/EttusResearch/uhd
ENV GNURADIO_GIT=http://git.gnuradio.org/git/gnuradio.git
ENV OSMOCORE_GIT=git://git.osmocom.org/libosmocore.git
ENV GR_OSMOSDR_GIT=git://git.osmocom.org/gr-osmosdr


RUN apt-get update && apt-get install -y \
    python-pip \
    python-gps \
    lshw \
    psmisc\
    bcrypt\
    unzip\
    wget \
    gpsd \
    libfontconfig1-dev \
    libxrender-dev \
    libpulse-dev \
    swig \
    g++ \
    automake \
    autoconf \
    libtool \
    python-dev \
    libfftw3-dev \
    libcppunit-dev \
    libboost-all-dev \
    libusb-dev \
    libusb-1.0-0-dev \
    fort77 \
    libsdl1.2-dev \
    python-wxgtk3.0-dev \
    git-core \
    libqt4-dev \
    python-numpy \
    ccache \
    python-opengl \
    libgsl0-dev \
    python-cheetah \
    python-mako \
    python-lxml \
    doxygen \
    qt4-dev-tools \
    libusb-1.0-0-dev \
    libqwt5-qt4-dev \
    libqwtplot3d-qt4-dev \
    pyqt4-dev-tools \
    python-qwt5-qt4 \
    cmake \
    git-core \
    wget \
    libxi-dev \
    python-docutils \
    gtk2-engines-pixbuf \
    r-base-dev \
    python-tk \
    liborc-0.4-0 \
    liborc-0.4-dev \
    libasound2-dev \
    python-gtk2 \
    libportaudio2 \
    portaudio19-dev \
    ca-certificates \
    libzmq-dev \
    python-requests \
    libncurses5 \
    libncurses5-dev \
    liblog4cpp5-dev \
    python-scipy \
    python-talloc-dev \
    libtalloc2 \
    libtalloc-dev \
    libpcsclite-dev \
    build-essential \
    shtool \
    pkg-config \
    gcc && \
    pip install kalibrate &&\
    dpkg -r python-pip && \
    apt-get clean

# Setup for source download...
RUN mkdir -p $GIT_BASE

# Build UHD
RUN cd $GIT_BASE && \
    git clone -c pack.threads=1 --recursive $UHD_GIT && \
    cd $GIT_BASE/uhd/host && \
    mkdir build && cd build && \
    cmake .. && \
    make clean && \
    make && \
    make install && \
    ldconfig && \
    rm -rf $GIT_BASE/uhd

# Build gnuradio
RUN cd $GIT_BASE && \
    git clone -c pack.threads=1 --recursive $GNURADIO_GIT \
    --branch $GNURADIO_REPO_TAG && \
    cd $GIT_BASE/gnuradio && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && \
    make clean && \
    make && \
    make install && \
    ldconfig && \
    rm -rf $GIT_BASE/gnuradio

# Build RTLSDR
RUN cd $GIT_BASE && \
    git clone -c pack.threads=1 --recursive $RTLSDR_GIT && \
    cd $GIT_BASE/rtl-sdr && \
    cmake . && \
    make clean && \
    make && \
    make install && \
    ldconfig && \
    rm -rf $GIT_BASE/rtl-sdr

# Build OSMO core
RUN cd $GIT_BASE && \
    git clone -c pack.threads=1 --recursive $OSMOCORE_GIT && \
    cd $GIT_BASE/libosmocore && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install && \
    ldconfig -i && \
    rm -rf $GIT_BASE/libosmocore

# Build gr-osmosdr
RUN cd $GIT_BASE && \
    git clone -c pack.threads=1 --recursive $GR_OSMOSDR_GIT && \
    cd gr-osmosdr && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    ldconfig && \
    rm -rf $GIT_BASE/gr-osmosdr
