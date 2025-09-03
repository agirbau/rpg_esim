FROM ros:kinetic

# Set proxy (if needed)
ENV no_proxy="10.81.0.0/16,172.16.0.0/16,localhost"
ENV http_proxy="http://10.81.247.64:8080"
ENV https_proxy="http://10.81.247.64:8080"

# Install system and ROS dependencies
RUN apt-get update && apt-get install -y \
    git wget curl build-essential cmake \
    vim x11-apps \
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
    ros-kinetic-opencv3 \
    libusb-1.0-0-dev \
    ros-kinetic-camera-info-manager \
    ros-kinetic-image-view \
    python3-catkin-pkg-modules \
    python3-pip \
    python3-tk \
    ros-kinetic-rqt* \
    ros-kinetic-rviz \
    dbus \
    && rm -rf /var/lib/apt/lists/*

RUN dbus-uuidgen > /etc/machine-id

# Update rosdep (already initialized in base image)
RUN rosdep update

# Setup catkin workspace
WORKDIR /home/user
RUN mkdir -p /home/user/sim_ws/src/rpg_esim
WORKDIR /home/user/sim_ws
RUN catkin init && \
    catkin config --extend /opt/ros/kinetic --cmake-args -DCMAKE_BUILD_TYPE=Release

# Copy ESIM repo into container
COPY . src/rpg_esim/.

# Import additional dependencies
WORKDIR /home/user/sim_ws/src
RUN vcs-import < rpg_esim/dependencies.yaml

# Patch SIMD flags if on ARM (e.g., macOS M1/M2)
RUN if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then \
    echo "Patching SIMD flags for ARM architecture..."; \
    sed -i '20,25 s/^/#/' /home/user/sim_ws/src/ze_oss/ze_cmake/cmake/modules/ze_setup.cmake; \
    fi

# Disable components we don't need
WORKDIR /home/user/sim_ws/src/ze_oss
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

WORKDIR /home/user/sim_ws

# build automatically
RUN catkin build esim_ros

# add shortcut to source the environment
RUN echo "source /home/user/sim_ws/devel/setup.bash" >> /home/user/setupeventsim.sh && \
    chmod +x /home/user/setupeventsim.sh && \
    echo "alias ssim='source /home/user/setupeventsim.sh'" >> /root/.bashrc

WORKDIR /home/user

CMD ["bash"]