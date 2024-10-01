#!/bin/bash

# Update the package index
sudo apt update -y

# Install screen
sudo apt install -y screen

# Install prerequisites for adding new repositories
sudo apt install -y software-properties-common

# Add the repository for the latest OpenJDK
sudo add-apt-repository -y ppa:openjdk-r/ppa

# Update the package index after adding the repository
sudo apt update -y

# Install the latest OpenJDK version
sudo apt install -y openjdk-21-jdk

# Verify the installation
java -version

# Done
echo "Installation abgeschlossen!"
