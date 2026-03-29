#!/bin/bash
set -x
exec > /var/log/user-data.log 2>&1
sudo apt update -y
sudo apt install zip -y
sudo apt install unzip -y
sudo apt install tar -y 
sudo apt install openjdk-17-jdk -y


version=$(java -version 2>&1)
echo "Java is installed: $version"

echo " installation of jenkins begins....."

curl -fsSL https://pkg.origin.jenkins.io/debian-stable/jenkins.io-2026.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.origin.jenkins.io/debian-stable/ binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins

JenkinsVersion=$(jenkins --version 2>&1)
echo "jenkins is installed : $JenkinsVersion"

echo "installation of docker begins....."

sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)

# Add Docker's official GPG key:
sudo apt update -y 
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

DockerVersion=$(docker --version 2>&1)
echo "jenkins is installed : $DockerVersion"
sudo usermod -aG docker jenkins
newgrp docker
sudo systemctl restart jenkins

sudo gpasswd -a jenkins ubuntu
docker run -dt --name sonarqube -p 9000:9000 sonarqube:latest

echo "sonarqube is running on port 9000"

echo "Trivy installation started........"

TRIVY_VERSION=$(curl -s "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')

wget -qO trivy.tar.gz https://github.com/aquasecurity/trivy/releases/latest/download/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

sudo tar xf trivy.tar.gz -C /usr/local/bin trivy

TrivyVersion=$(trivy --version 2>&1)
echo "Trivy is installed : $TrivyVersion)"

#upgradation of java version:
#sudo apt install openjdk-21-jdk -y        #--installation of java 21
#sudo update-alternatives --config java    #--- to switch the versions
#readlink -f $(which java)                 #--- to see which jdk is running 


