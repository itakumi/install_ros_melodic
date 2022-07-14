#!/bin/bash
# Orbbec Persee+のROS使い方
# Ubuntu18.04 インストール
#Please refer to lab's GDrive(https://drive.google.com/drive/u/0/folders/1yZFs0YkXfXYHU9EdqzqpLJ3OwG9LPWYY) and find OS image from  https://www.dropbox.com/s/d6ihapkdaak0bou/Orbbec_Persee%2B_Ubuntu_20220509.zip?dl=0
#インストールし、ssh後
sudo apt update
sudo apt upgrade
#rosをインストールするときにデフォルトで入っているopencv3が依存関係エラーになるため、削除
sudo apt purge opencv3

#https://qiita.com/applepieqiita/items/4cd57e337d8756c8db44
#に従い、ROSをインストール
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt -y install ros-melodic-desktop-full

sudo apt -y install python-rosdep
sudo rosdep init
rosdep update

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt -y install python-rosinstall python-rosinstall-generator python-wstool build-essential

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
source devel/setup.bash

cd ~
wget https://dl.orbbec3d.com/dist/orbbecsdk/ROS/v1.0/OrbbecSDK_1.0.0_20211125_f226d0f_Release_ros.zip
unzip OrbbecSDK_1.0.0_20211125_f226d0f_Release_ros.zip
mv ~/orbbec_camera/ ~/catkin_ws/src/
cd ~/catkin_ws
catkin_make
roscd orbbec_camera

cd script
chmod 777 install.sh
./install.sh

echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt -y install x11-apps

sudo ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'Asia/Tokyo' | sudo tee /etc/timezone

roslaunch orbbec_camera device.launch

echo "please run rosrun image_view image_view image:=/camera/depth/image_raw"
#以降は確認
#rostopic list
#rostopic hz /camera/color/image_raw
#rostopic hz /camera/depth/image_raw

#$ rosservice call /get_device_list

#タイムゾーン変更
#$ ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
#$ sudo vim /etc/timezone
#Asia/Tokyo
#と変更
