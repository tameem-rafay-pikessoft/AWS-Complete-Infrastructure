# Terraform Infrastructure Setup Guide

This repository contains the Terraform configuration for setting up infrastructure components including EC2 instances, Parameter Store, and AWS CodePipeline. Below is an overview of each module and the steps to deploy using Terraform.

## Table of Contents
- [EC2 Instance Module](#ec2-instance-module)
- [Parameter Store Module](#parameter-store-module)
- [AWS CodePipeline Module](#aws-codepipeline-module)
- [Usage](#usage)
- [Detailed Instructions](#detailed-instructions)

## EC2 Instance Module
In this module, an EC2 instance is created and configured with the necessary packages using user data. Additionally, a security group is attached to the instance, allowing open access to ports 80 and 443 while restricting port 22 to specific IP addresses for private access.

### Features
- Creation of an EC2 instance.
- Configuration using user data.
- Security group with rules:
  - Open access to ports 80 and 443.
  - Restricted access to port 22 for specific IPs.

## Parameter Store Module
The Parameter Store module serves as a simple solution for storing application environment variables (.env file). These secrets can be included during the build pipeline creation process.

### Features
- Storage of environment variables.
- Integration with the build pipeline.

## AWS CodePipeline Module
This module encompasses the creation of a pipeline to deploy changes to the server upon pushing changes to the master branch of the repository. The pipeline includes application and deployment group creation, with the existing EC2 instance added to the deployment group. While auto-scaling groups can be added for scalability, this setup focuses on simplicity by including only one instance in the group.

### Features
- Creation of a deployment pipeline.
- Integration with the master branch.
- Application and deployment group creation.
- Inclusion of the EC2 instance in the deployment group.

## Usage
1. **Initialize Terraform**
   ```sh
   terraform init
