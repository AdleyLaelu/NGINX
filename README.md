
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

![Capture d’écran 2024-12-24 211250](https://github.com/user-attachments/assets/47217485-fbb0-4844-b95e-6eaa75113c92)

📁 Project Structure
Here’s an overview of the files in this repository:

File	Description
Here’s an overview of the files in this repository:

| **File**          | **Description**                                                              |
|--------------------|------------------------------------------------------------------------------|
| `main.tf`          | Core Terraform configuration file for provisioning AWS resources.           |
| `variables.tf`     | Defines input variables for resource customization.                         |
| `outputs.tf`       | Specifies outputs, such as the ALB DNS name, ECS Cluster name, and Task ARN.|
| `.gitignore`       | Excludes `.terraform/` and state files from version control.                |
| `README.md`        | Documentation for understanding and deploying the project.                  |

---

## Resources Created

This Terraform configuration creates the following AWS resources:

### ECS Cluster
- A cluster to host the ECS tasks.

### ECS Task Definition
- Defines the Nginx container task to be run on Fargate.

### Application Load Balancer (ALB)
- Routes incoming HTTP traffic to the ECS service.

### IAM Roles
1. **Task Role**: Grants permissions for the ECS tasks to interact with AWS services.
2. **Execution Role**: Allows ECS to pull container images and write logs.

### Security Group
- Configured to allow inbound HTTP traffic on port 80.


## 📤 Outputs

After running `terraform apply`, the following outputs will be displayed:

- **ALB DNS Name**: The public DNS name of the Application Load Balancer (use this to access the app).
- **ECS Cluster Name**: The name of the ECS cluster created.
- **Task Definition ARN**: The ARN of the ECS task definition.

---

## ⚠️ Important Notes

### Exclude State Files
- The `.terraform/` directory and `terraform.tfstate` files are excluded from version control using `.gitignore`.

### Destroy Resources
- To avoid unnecessary AWS charges, destroy the resources when they are no longer needed:
  ```bash
  terraform destroy

## 🛡 Troubleshooting

If you encounter any issues, check the following:

1. **AWS CLI Configuration**:
   - Ensure your credentials are configured correctly using:
     ```bash
     aws configure
     ```

2. **Terraform Plan**:
   - Always run `terraform plan` before applying changes to catch any errors.

3. **Security Group**:
   - Verify that the security group allows inbound HTTP traffic on port 80.

  # CI/CD Pipeline with GitHub Actions

This repository contains a **CI/CD pipeline** setup for deploying a simple Nginx-based web application using **GitHub Actions**, **Docker**, and **AWS ECS (Elastic Container Service)**.

## 📋 Overview

The GitHub Actions pipeline performs the following tasks:
1. **Checkout Code**: Pulls the latest changes from the `main` branch.
2. **Build Docker Image**: Builds a Docker container for the Nginx application.
3. **Push Image to Amazon ECR**: Pushes the Docker image to **Amazon Elastic Container Registry (ECR)**.
4. **Deploy to AWS ECS**: Deploys the container to **AWS ECS Fargate**.
5. **Secure Secrets Management**: Uses **GitHub Secrets** for environment variables and sensitive information.
6. **Triggers**: Automatically triggered when changes are pushed to the `main` branch.

---

## 🛠 Prerequisites

Before running the pipeline, ensure you have the following:

1. **AWS Account**
   - Permissions for ECS, ECR, and Docker image management.

2. **GitHub Repository**
   - Repository with the application code and a `Dockerfile`.

3. **GitHub Secrets**
   - Configure the following secrets in your GitHub repository:
     - `AWS_ACCESS_KEY_ID`: AWS access key ID.
     - `AWS_SECRET_ACCESS_KEY`: AWS secret access key.
     - `ECR_URL`: Amazon ECR repository URL (e.g., `123456789012.dkr.ecr.us-east-1.amazonaws.com`).

4. **Dockerfile**
   - Dockerfile for building the Nginx container.

---

## 🚀 Workflow Configuration

### GitHub Actions Workflow File

```yaml
name: CI/CD Pipeline
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml      # GitHub Actions workflow file
├── Dockerfile             # Dockerfile for building the container
├── index.html             # HTML file served by the application
├── main.tf                # Terraform configuration file (optional)
├── variables.tf           # Terraform variables file (optional)
├── outputs.tf             # Terraform outputs file (optional)


# 🌟 Features

- **Automated Deployment**: The pipeline automatically builds, pushes, and deploys the application.
- **Secure Secrets Management**: Environment variables like AWS credentials are securely stored using GitHub Secrets.
- **Dockerized Application**: The Nginx-based web app is fully containerized for efficient deployment.
- **Terraform Support (Optional)**: Option to use Terraform for managing AWS infrastructure.

---

## 🔧 How to Run the Pipeline

### 1. Push Code
Commit and push changes to the `main` branch. This action triggers the GitHub Actions pipeline.

### 2. Monitor the Workflow
Navigate to the **Actions** tab in your GitHub repository to monitor the progress of the pipeline.

### 3. Access the Application
Once deployed, retrieve the **ALB DNS Name** from AWS ECS or Terraform outputs. Use the following URL to access the application:

http://<ALB_DNS_NAME>


---

## 📝 Notes

### Optional Terraform Deployment
If you prefer using Terraform for deployment, replace the AWS CLI deployment step with the following commands in your GitHub Actions workflow:
```yaml
- name: Deploy to ECS using Terraform
  run: |
    terraform init
    terraform plan
    terraform apply -auto-approve

