#!/bin/bash

# Install ros kinetic on raspian buster
cd ~
wget http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz
tar xvzf boost_1_58_0.tar.gz
mkdir ~/build
cd boost_1_58_0/
sudo ./bootstrap.sh
sudo ./b2 install —prefix="../build"
cd ~
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
sudo rosdep init
rosdep update
mkdir -p ~/ros_catkin_ws
rosinstall_generator ros_comm --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall
wstool init src kinetic-ros_comm-wet.rosinstall
mkdir -p ~/ros_catkin_ws/external_src
cd ~/ros_catkin_ws/external_src
wget http://sourceforge.net/projects/assimp/files/assimp-3.1/assimp-3.1.1_no_test_models.zip/download -O assimp-3.1.1_no_test_models.zip
unzip assimp-3.1.1_no_test_models.zip
cd assimp-3.1.1
cmake .
make
sudo make install
cd ~/ros_catkin_ws
rosdep install -y --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:buster
# modify files ~/ros_catkin_ws/src/rospack/CMakeLists.txt
# and ~/ros_catkin_ws/src/catkin/CMakeLists.txt
# writing after line containing "project" 
# set(BOOST_ROOT ~/build)
# set(BOOST_INCLUDEDIR ~/build/include)
# set(BOOST_LIBRARYDIR ~/build/lib)
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j2
sudo ln -s /home/pi/build/lib/* /usr/lib/
