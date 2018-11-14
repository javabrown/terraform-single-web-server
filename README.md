 # Simple Hello Service on AWS by Terraform
 
 
 1. Setup the AWS credential in environment variable (Reference is in aws-credential-setup.bat)
    (Make sure to not check-in credential in git)

 1. Run following command to create and destroy the Hello World Web Server in AWS:
    `terraform init` : To initialize the Terraform for your environment.
    `terraform plan` : To verify the planned changes.
 
 1. `terraform apply` : To execute and setup the environment  (validated the running hello-world application in generated AWS URL `http://{public-ip}:8080` )
 
 1. `terraform destroy` : To destroy the EC2 instance.
 
 

 ### Please note that nothing in Free in AWS, so you might get billed by running this application. So run this script with your own risk :)
 ### Comment or email if you have any question: raja khan <getrk@yahoo.com>

 
 
