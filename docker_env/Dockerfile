FROM ros:kinetic-ros-base

# Set proxy (if needed)
ENV no_proxy="10.81.0.0/16,172.16.0.0/16,localhost"
ENV http_proxy="http://10.81.247.64:8080"
ENV https_proxy="http://10.81.247.64:8080"

# Install system and ROS dependencies
RUN apt-get update && apt-get install -y \
    git wget curl build-essential cmake \
    vim \
    autoconf automake libtool \
    libopencv-dev \
    libassimp-dev \
    openssh-client \
    libyaml-cpp-dev \
    ros-kinetic-image-transport ros-kinetic-cv-bridge ros-kinetic-eigen-conversions ros-kinetic-tf-conversions \
    ros-kinetic-tf \
    ros-kinetic-nodelet \
    ros-kinetic-message-filters \
    ros-kinetic-dynamic-reconfigure \
    python-catkin-tools python-vcstool \
    python-rosdep \
    ros-kinetic-pcl-ros \
    libproj-dev libglfw3 libglfw3-dev libglm-dev \
    ros-kinetic-hector-trajectory-server \
    && rm -rf /var/lib/apt/lists/*

# Update rosdep (already initialized in base image)
RUN rosdep update

# Setup catkin workspace
WORKDIR /root
RUN mkdir -p /root/sim_ws/src/rpg_esim
WORKDIR /root/sim_ws
RUN catkin init && \
    catkin config --extend /opt/ros/kinetic --cmake-args -DCMAKE_BUILD_TYPE=Release

COPY . src/rpg_esim/.
WORKDIR /root/sim_ws/src
RUN vcs-import < rpg_esim/dependencies.yaml

WORKDIR /root/sim_ws/src/ze_oss
RUN touch imp_3rdparty_cuda_toolkit/CATKIN_IGNORE \
    imp_app_pangolin_example/CATKIN_IGNORE \
    imp_benchmark_aligned_allocator/CATKIN_IGNORE \
    imp_bridge_pangolin/CATKIN_IGNORE \
    imp_cu_core/CATKIN_IGNORE \
    imp_cu_correspondence/CATKIN_IGNORE \
    imp_cu_imgproc/CATKIN_IGNORE \
    imp_ros_rof_denoising/CATKIN_IGNORE \
    imp_tools_cmd/CATKIN_IGNORE \
    ze_data_provider/CATKIN_IGNORE \
    ze_geometry/CATKIN_IGNORE \
    ze_imu/CATKIN_IGNORE \
    ze_trajectory_analysis/CATKIN_IGNORE

WORKDIR /root/sim_ws
RUN catkin build esim_ros

RUN echo "source ~/sim_ws/devel/setup.bash" >> ~/setupeventsim.sh
RUN chmod +x ~/setupeventsim.sh
RUN alias ssim='source ~/setupeventsim.sh'

WORKDIR /root

CMD ["bash"]