# Use the official HashiCorp Terraform image as the base
FROM hashicorp/terraform:latest

# Set the working directory inside the container
WORKDIR /workspace

# Copy your Terraform configuration files to the container
COPY . /workspace

# (Optional) Install additional tools if needed
# For example, installing Git
RUN apk add --no-cache git

# (Optional) Set Terraform as the default command
CMD ["terraform"]

# Instructions
# To build the Docker image, run the following command:
# docker build -t terraform:latest -f docker/terraform/terraform2.Dockerfile .
#
# To run the Docker container, use the following command:
# docker run -it --rm terraform:latest
#
# To verify that Terraform is installed, run the following command:
# terraform --version
#
# To verify that Git is installed, run the following command:
# git --version
#
# To verify that the working directory is set to /workspace, run the following command:
# pwd
#
# To verify that the Terraform configuration files are copied to the container, run the following command:
# ls -l
#
# To verify that Terraform is set as the default command, run the following command:
# terraform

# Commands to interact with terraform
# Initialize terraform
#docker run --rm -it -v $(pwd):/workspace terraform-container init

# PLan infrastructure changes
#docker run --rm -it -v $(pwd):/workspace terraform-container plan

# Apply infrastructure changes
#docker run --rm -it -v $(pwd):/workspace terraform-container apply

# Destroy infrastructure
#docker run --rm -it -v $(pwd):/workspace terraform-container destroy


