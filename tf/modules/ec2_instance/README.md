# AWS EC2 Launch Template

You will need to create a EC2 Launch template in your desired region. In this repo we are assuming the launch template is called `jenkins-template`.
Below are the details we recommend for your launch template

## Things to note

- Applying these changes to will incur costs to your AWS account.
- This setup also assumes that you do not want to destroy your volumes. (So that Jenkins state can be saved and persisted)
- The most important part of this launch template is the custom script so be sure to copy this over.

## Custom Script (User data)

This is the user data script I recommend. If you do not Docker, Git, Docker Compose, or Vim feel free to remove those sections

```
#!/usr/bin/env bash

sudo yum update -y

# install vim
sudo yum install vim -y

# install git
sudo yum install git -y

# install docker
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins
chmod 777 /var/run/docker.sock

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version


# install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo dnf install java-11-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

```
