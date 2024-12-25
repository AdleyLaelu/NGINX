# NGINX

# Terraform AWS ECS Fargate Project

This project deploys a simple Nginx web application using **AWS ECS (Fargate)**, an **Application Load Balancer (ALB)**, and supporting infrastructure using **Terraform**.

---

## 📋 Prerequisites

Ensure you have the following tools installed and configured:
- An **AWS account** with appropriate permissions.
- **Terraform** (latest version installed).
- **AWS CLI** (configured with your credentials using `aws configure`).

---

## 🚀 Deployment Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/<your-username>/NGINX.git
   cd NGINX
Initialize Terraform:

bash
Copy code
terraform init
Review the Terraform Plan:

bash
Copy code
terraform plan
Apply the Configuration:

bash
Copy code
terraform apply
Type yes to confirm resource creation.
Access the Application:

Copy the ALB DNS name from the Terraform outputs.
Open the application in your browser:
arduino
Copy code
http://<ALB_DNS_NAME>
📁 Project Structure
Here’s an overview of the files in this repository:

File	Description
main.tf	Core Terraform code for provisioning AWS resources.
variables.tf	Defines input variables used across the Terraform code.
outputs.tf	Specifies outputs like the ALB DNS name, ECS Cluster name, and Task ARN.
.gitignore	Ensures Terraform state files and .terraform/ directory are ignored.
README.md	Documentation for understanding and deploying the project.
🛠 Resources Created
This Terraform configuration creates the following resources:

ECS Cluster:

A cluster to host the ECS tasks.
ECS Task Definition:

Defines the Nginx container task to be run on Fargate.
Application Load Balancer (ALB):

Routes incoming HTTP traffic to the ECS service.
IAM Roles:

Task Role: Allows the container to perform actions within AWS.
Execution Role: Allows ECS to pull container images and write logs.
Security Group:

Configured to allow inbound HTTP traffic on port 80.
📤 Outputs
After running terraform apply, the following outputs will be displayed:

ALB DNS Name: The public DNS name of the Application Load Balancer (use this to access the app).
ECS Cluster Name: The name of the ECS cluster created.
Task Definition ARN: The ARN of the ECS task definition.
⚠️ Important Notes
Exclude State Files:
The .terraform/ directory and terraform.tfstate files are excluded from version control using .gitignore.
Destroy Resources:
To avoid unnecessary AWS charges, destroy the resources when no longer needed:
bash
Copy code
terraform destroy
🛡 Troubleshooting
If you encounter any issues, check the following:

AWS CLI Configuration:
Ensure your credentials are configured correctly using:
bash
Copy code
aws configure
Terraform Plan:
Always run terraform plan before applying changes to catch any errors.
Security Group:
Verify that the security group allows inbound HTTP traffic on port 80
