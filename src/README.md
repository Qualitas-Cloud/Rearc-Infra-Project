# Rearc-Project

terraform-eks
A rearc repository to create EKS on AWS using Terraform.

Install AWS CLI
As the first step, you need to install AWS CLI as we will use the AWS CLI (aws configure) command to connect Terraform with AWS in the next steps.

Follow the below link to Install AWS CLI.

terraform-eks
A Rearc repository to create an EKS cluster on AWS using Terraform.

Install AWS CLI
As the first step, you need to install the AWS CLI, as we will use the aws configure command to connect Terraform with AWS in the next steps.

Follow the link below to install the AWS CLI:

Install AWS CLI

Install Terraform
Next, install Terraform using the link below:

Install Terraform

Connect Terraform with AWS
It's very easy to connect Terraform with AWS. Run the following command and provide your AWS security credentials:

bash
Copy code
aws configure
Initialize Terraform
Clone the repository and run the following command to initialize the Terraform environment. This will download the required modules, providers, and other configurations:

bash
Copy code
terraform init
Optionally Review the Terraform Configuration
You can review the configuration that will be created by running:

bash
Copy code
terraform plan
Apply Terraform Configuration to Create EKS Cluster with VPC
Finally, apply the Terraform configuration to create the EKS cluster along with the VPC:

bash
Copy code
terraform apply
Note:
This repository utilizes Terraform modules to simplify the creation of the EKS cluster, ensuring that the configurations are reusable and manageable.


