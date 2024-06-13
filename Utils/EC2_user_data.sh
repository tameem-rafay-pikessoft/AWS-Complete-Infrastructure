#!/bin/bash

# Install the CodeDeploy agent
sudo yum update -y
yum install -y ruby
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto

service codedeploy-agent start
chkconfig codedeploy-agent on

#install the docker 
yum install -y docker
service docker start
chkconfig docker on
usermod -aG docker ec2-user

#install docker compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# install caddy_data volume
docker volume create caddy_data


# This would install the dummy project so that we can access the project. 
# It is just for testing purposes


sudo yum install -y nodejs npm
# Create a simple Node.js server file
cat <<EOF > server.js
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello from your EC2 instance!');
});

server.listen(3000, '0.0.0.0', () => {
  console.log('Server running at http://0.0.0.0:3000/');
});
EOF

node server.js


# Install the CLOUD_WATCH agent and send the required matrices to the cloudwatch 
# So, that we can add the cloudwatch alarm based on that matrices

# Install the CloudWatch agent
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
# sudo rpm -U ./amazon-cloudwatch-agent.rpm


# Create the CloudWatch agent configuration file
# cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
# {
#     "agent": {
#         "metrics_collection_interval": 300,
#         "run_as_user": "root"
#     },
#     "metrics": {
#         "append_dimensions": {
#             "InstanceId": "instance_matrices"
#         },
#         "metrics_collected": {
#             "mem": {
#                 "measurement": [
#                     "mem_used_percent"
#                 ],
#                 "metrics_collection_interval": 60,
#                 "resources": [
#                     "*"
#                 ]
#             },
#             "disk": {
#                 "measurement": [
#                     "used_percent"
#                 ],
#                 "metrics_collection_interval": 300,
#                 "resources": [
#                     "*"
#                 ]
#             }
#         }
#     }
# }
# EOF

# # Start the CloudWatch agent
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json