# Pull base image.
FROM ubuntu:24.04

ARG USERNAME=tester
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG TEST_DIR=/opt/fm

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update \
    && apt-get install -y \
        sudo \
        gnupg \
        locales \
        wget \
        nano \
	tmux \
        fonts-powerline \
        lsb-release \
        software-properties-common \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN locale-gen en_US.UTF-8 
 
RUN apt update \
    && apt install -y \
        build-essential \
        cmake \
        curl \
        cutils \
        git \
        make \
        pkg-config \
        python3 \
        python3-pip \
        neovim \
        bc \
	swig \
        cpio \
        rsync \
	which \
	sed \
	gcc \
	g++ \
	patch \
	gzip \
	bzip2 \
	tar \
	cpio \
	unzip \
	zip \
	binutils \
	diffutils \
	findutils \
	gawk \
	file \
	libgnutls28-dev \
	libncurses-dev \
	qemu-system-x86 \
	debootstrap \
	ostree \
        squashfs-tools \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --set python /usr/bin/python3 

RUN cd /opt && git clone https://github.com/EugeniyKozhanov/buildroot.git \
	&& cd buildroot && git checkout 2025.02_ostree

WORKDIR /opt/project_dir
CMD ["/bin/bash"]
