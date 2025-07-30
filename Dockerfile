# Use a base Ubuntu image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    screen \
    build-essential \
    nano \
    vim \
    sudo \
    wget \
    curl \
    unzip \
    g++ \
    make \
    pkg-config \
    python-is-python3 \
    python3-dev \
    python3-numpy \
    python3-opencv \
    python3-pyparsing \
    python3-scipy \
    python3-matplotlib \
    python3-lxml \
    && rm -rf /var/lib/apt/lists/*

# packages for Pip3 
RUN pip3 install pexpect empy==3.3.4

# Copy the ArduPilot repository from local directory
COPY ardupilot /opt/ardupilot

# Create a non-root user
RUN useradd -ms /bin/bash ardupilot_user

# Set up the environment for ArduPilot
WORKDIR /opt/ardupilot
RUN git submodule update --init --recursive

# Switch to non-root user
USER ardupilot_user

# Set the working directory
WORKDIR /workspace/

# Copy the Flask app folder into the container
COPY ardupilot /workspace/ardupilot

# Switch back to root for package installations
USER root

# Install Python packages
RUN pip3 install --no-cache-dir dronekit==2.9.2 mavproxy==1.8.70 pymavlink==2.4.41

# Expose necessary ports
EXPOSE 14550
EXPOSE 5000

# Default command
CMD ["/bin/bash"]