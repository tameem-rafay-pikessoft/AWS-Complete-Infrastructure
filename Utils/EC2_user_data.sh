#!/bin/bash

# Install the CodeDeploy agent for pipeline
sudo su
yum update -y
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




#-- Install the CLOUD_WATCH agent and send the required matrices to the cloudwatch 
# So, that we can add the cloudwatch alarm based on that matrices

# Install the CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm


# Create the CloudWatch agent configuration file
sudo bash -c 'cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
    "agent": {
        "metrics_collection_interval": 300,
        "run_as_user": "root"
    },
    "metrics": {
        "append_dimensions": {
            "InstanceId": "${aws:InstanceId}"
        },
        "metrics_collected": {
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "disk": {
                "measurement": [
                    "disk_used_percent"
                ],
                "metrics_collection_interval": 300,
                "resources": [
                    "*"
                ]
            }
        }
    }
}
EOF'

# Start the CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# to check the status of code deploy agent
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
# sudo journalctl -u amazon-cloudwatch-agent.service
# sudo systemctl restart amazon-cloudwatch-agent.service


# Install NGINX For reverse proxy
yum install -y nginx

# Create the NGINX configuration file for the reverse proxy
cat > /etc/nginx/conf.d/reverse-proxy.conf <<EOF
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:3000; # Replace 3000 with the port your application is running on
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Remove the default configuration to avoid conflicts
rm -f /etc/nginx/conf.d/default.conf

# Start and enable NGINX service
service nginx start
chkconfig nginx on

# Install the certificate 
# sudo yum install -y certbot
# sudo yum install -y certbot-nginx
# # sudo certbot renew

# # renew it 
# sudo yum install cronie -y
# sudo systemctl start crond
# sudo systemctl enable crond

# sudo crontab -e --> UPDATE TODO: this will create the file and write it like this
# 34 7 * * * sudo certbot renew --quiet --renew-hook "sudo systemctl reload nginx" >> /var/log/cron-certbot.log 2>&1

# 3 AM EVERY DAY
# 0 3 * * * sudo certbot renew --quiet --renew-hook "sudo systemctl reload nginx" >> /var/log/cron-certbot.log 2>&1





# ----------------- REMOVE IT -----------------------------------------
# This would install the dummy project so that we can access the project. 
# It is just for testing purposes you can remove it


yum install -y nodejs npm
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

# ----------------- REMOVE IT -----------------------------------------

