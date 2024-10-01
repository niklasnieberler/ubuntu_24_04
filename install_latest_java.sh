#!/bin/bash

# Update the package index
sudo apt update -y

# Install required tools
sudo apt install -y screen curl jq

# Check if Java is already installed
if java -version &>/dev/null; then
  echo "Java is already installed."
  current_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  echo "Currently installed Java version: $current_version"
else
  echo "Java is not installed."
fi

# Get the latest version of OpenJDK from Adoptium API
latest_version=$(curl -s https://api.adoptium.net/v3/info/available_releases | jq -r '.available_lts_releases[-1]')

echo "The latest available Java version is: OpenJDK $latest_version"

# Build download URL for the latest OpenJDK (Linux x64)
download_url=$(curl -s "https://api.adoptium.net/v3/assets/latest/$latest_version/hotspot" | jq -r '.[] | select(.binary.architecture == "x64" and .binary.image_type == "jdk" and .binary.os == "linux") | .binary.package.link')

# Download the latest OpenJDK tarball
echo "Downloading OpenJDK $latest_version..."
curl -L -o openjdk.tar.gz "$download_url"

# Extract the tarball
echo "Extracting the OpenJDK files..."
sudo tar xzf openjdk.tar.gz -C /opt

# Find the extracted folder name (assumes only one folder in /opt after extraction)
jdk_folder=$(ls /opt | grep jdk)

# Set up alternatives for java and javac
sudo update-alternatives --install /usr/bin/java java /opt/$jdk_folder/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /opt/$jdk_folder/bin/javac 1

# Automatically select the newly installed Java as the default version
sudo update-alternatives --set java /opt/$jdk_folder/bin/java
sudo update-alternatives --set javac /opt/$jdk_folder/bin/javac

# Verify the installation and show the current Java version
java -version

# Clean up
rm openjdk.tar.gz

echo "The latest Java version ($latest_version) has been successfully installed and set as the default!"
