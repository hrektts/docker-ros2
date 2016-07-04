FROM hrektts/ubuntu:16.04.20160629
MAINTAINER mps299792458@gmail.com

RUN locale-gen en_US en_US.UTF-8 \
 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
    --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116 \
 && echo "deb http://packages.ros.org/ros/ubuntu xenial main" \
    > /etc/apt/sources.list.d/ros-latest.list \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
    --recv-keys D2486D2DD83DB69272AFE98867170598AF249743 \
 && echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" \
    > /etc/apt/sources.list.d/gazebo-latest.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    build-essential \
    clang-format \
    cmake \
    cppcheck \
    git \
    libboost-all-dev \
    libopencv-dev \
    libopensplice64 \
    pydocstyle \
    pyflakes3 \
    python3-coverage \
    python3-dev \
    python3-empy \
    python3-mock \
    python3-nose \
    python3-pep8 \
    python3-pip \
    python3-setuptools \
    python3-vcstool \
    uncrustify \
 && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-login --gecos 'Developper' dev \
 && passwd -d dev \
 && gpasswd -a dev sudo

ENV HOME /root
ENV ROS2_VERSION alpha6

RUN mkdir -p ${HOME}/ros2_ws/src
WORKDIR ${HOME}/ros2_ws
RUN wget https://raw.githubusercontent.com/ros2/ros2/release-${ROS2_VERSION}/ros2.repos \
 && vcs import ${HOME}/ros2_ws/src < ros2.repos

RUN touch src/eProsima/ROS-RMW-Fast-RTPS-cpp/AMENT_IGNORE \
 && src/ament/ament_tools/scripts/ament.py build --build-tests --symlink-install

COPY entrypoint.sh /sbin/entrypoint.sh
RUN sudo chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["bash"]
