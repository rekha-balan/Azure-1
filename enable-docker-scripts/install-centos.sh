sudo yum check-update
sudo yum install sysstat epel-release -y
sudo yum siege epel-release -y
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl status docker
sudo systemctl enable docker
sudo usermod -aG docker azuretest
docker run -d -p 80:80 mvsoares/nginx-centos:v1
