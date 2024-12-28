### Open Questions:

2) 
   a) The problem can occur due to a failure in 3 different locations:
   - The "TEST SPOKE" VPC:  
      - Need to check if the instance allows outbound traffic to the "INSPECTION" VPC.  
      - Same for the subnet level (NACL).  
      - The routing table of the subnet must have the "INSPECTION" VPC as the target.  

   - The transit gateway  
      - Need to make sure both VPCs are attached to it.  
      - Ensure they appear as targets in its route table.  

   - The "INSPECTION" VPC  
      - Perhaps the checkpoint firewall blocks requests from the "TEST SPOKE" VPC.  
      - There might be a problem with the DNS resolver. 

   b) 
   - Same as before, misconfiguration at the "TEST SMOKE" VPC and the "ENGRESS" VPC, and their attachments to the TGW.  

   - The NFW blocks outbound requests from the test VPC.  

   - Problem with the NAT Gateway.

   c)
   1) The error indicates there is a problem with the test-ec2 permissions to access the repository,  
   Perhaps the repository requires credentials.  
   The test-ec2 instance might require an IAM role to access the repository.  

   2) The error probably refers to a network problem between the two instances.  
       Check the security groups, NACLs, route tables, and TGW attachments for both VPCs.  

   3) The Docker daemon is not running.  
      Check the status using `sudo systemctl status docker`.  
      If it exists, restart it using `sudo systemctl restart docker`.  
      If it doesn’t exist, install it.

3)  A possible cause for this scenario is:  
    - The instance (or the subnet) does not accept traffic through port 443 or from the relevant source IP address.  
    - The SSL certificate might have expired, requiring a new one.  

4) Install telnet using the following command:  
   `sudo yum install telnet`.
   If the instalation fails, perhaps the repository is not updated, and running `sudo yum update` will solve it.

### Practical Questions

#### Question 1:

##### Jenkins: 


Jenkins is running on his own vpc, both the master and the agent. The Jenkinsfile is located within the *Jenkins* directory. The pipeline runs within a container, and the image is being built using the dockerfile within *Jenkins/Agent* directory. The pipeline builds and image, using a dockerfile that wraps the application code, located at the *App* directory, publish the image to ECR, and deploy the new version to an *EKS* cluster using *helm*.

##### EKS: #####
 The cluster is created within a new vpc, using terraform.
 After running `terraform apply`, please copy the newly created *vpc-id* attribute and paste it in the *installLbController.sh* script, that will install the aws load balancer controller. The application will be accessible through port 443, using an ALB that will be created using an ingress resource. All the other k8s resources are located within the *AppChart* directory.

 #### Question 5: 
 Running `terraform apply`, will create a new vpc, with 1 public subnet, matching route table and igw. In addition, an ec2 instance will be created, with an elastic ip and security groups attached to it, as well as an nlb to forward requests to it. The ec2 instance will run a user data script: *installApache.sh*, that will make sure the instance runs the server at port 80.

