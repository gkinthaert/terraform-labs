# Deploy an NGINX Server in AWS

deploy an NGINX server in AWS, as part of a VPC, with public and private subnets. The EC2 instance uses an Ubuntu AMI initially. 
Later, replace the instance with an NGINX Bitnami AMI and associate it with a security group. Finally, test the website accessibility and tag the resources with project information. Use Terraform for as many resources as possible, and delete all the resources at the end of the project to avoid unnecessary costs.

## Desired Outcome

1. Deploy a new VPC in AWS in the Ohio (us-east-2) region.
2. Within the VPC, deploy a public and a private subnet.
3. The public subnet should be associated with a custom route table containing a route to an Internet Gateway.
4. Create a security group that allows traffic only on ports 80 (HTTP) and 443 (HTTPS).
5. Deploy an EC2 instance in the public subnet using the Ubuntu AMI.
6. Delete the previous instance and deploy another EC2 instance using the NGINX Bitnami AMI, since it's free of charge.
7. Associate the deployed NGINX instance with the created security group.
8. confirm that it's possible to access the website via its public IP.
9. Tag resources with useful information about your project.
10. Make sure to delete all the resources as this is a PoC

### diagram

![vpc-ec2-nginx,png](vpc-ec2-nginx.png)