VPC setup:
1) create A new VPC named "exam-vpc", with cidr of 10.0.0.0/16
2) Create 4 subnets: 2 public, 1 in each AZ, and 2 private, 1 in each AZ.
the cidr blocks are 10.0.0.0, 10.0.0.1, 10.0.0.2, 10.0.0.3, with subnet mask of 24
3) create IGW, and attach it to the VPC
4) create 2 routing tables:
* public RT, with 2 routes, 1 for vpc and 1 for igw (0.0.0.0), assign it to the 2 public subnets.
* private RT, with 1 route, only for vpc, assign it to the 2 private subnets.
5) create NAT gateway, and add it to the private-rt as gateway. (or nat instance)

IAM:
1) create a group, and add the policies for ECR, and add a user to it.

Jenkins setup:
1) Launch an EC2 instance, with a t2.medium type (ubuntu image).
2) sg for jenkins: [ssh 22 only medium, port 8080 for anyone (needs to be changed!!!)] 
3) ssh into the instance, install docker (script), and create a container running jenkins(using compose).
4) Install Amazon ECR plugin and Docker pipeline.
5) Add credentials: the 'leumi' IAM user.
6) configure github as a repository to checkout the code.
7) configure ECR as the container registry instead of dockerhub/

Agent setup:
1) create a dockerfile with everything needed for the agent to run the pipeline
2) push it to ECR
3) install docker and java on the agent
4) add the ssh key for the agent as a jenkins credential, and create a node for this agent. 

pipeline setup:
1) create multibranch pipeline and point to the github repositoryEST SPOKE VPCT
2) add the github pat as a jenkins credential.
3) add iam user 'leumi-user' as credentials
4) install plugins: docker pipeline, Amazon ECR.

Question1:
setting up the jenkins master and agent within a seperate vpc.
setting up the eks vpc and the whole cluster, using terraform init within the EKS folder. 
after running init, must copy the new vpc id into the script 'installlbcontroller', and run the script.

# Open Questions

## Question 2

2a) The problem can occur due to a failure in 3 different locations:
   1) The "TEST SPOKE" VPC  
      - Need to check if the instance allows outbound traffic to the "INSPECTION" VPC.  
      - Same for the subnet level (NACL).  
      - The routing table of the subnet must have the "INSPECTION" VPC as the target.  

   2) The transit gateway  
      - Need to make sure both VPCs are attached to it.  
      - Ensure they appear as targets in its route table.  

   3) The "INSPECTION" VPC  
      - Perhaps the checkpoint firewall blocks requests from the "TEST SPOKE" VPC.  
      - There might be a problem with the DNS resolver.  

2b)  
   1) Same as before, misconfiguration at the "TEST SMOKE" VPC and the "ENGRESS" VPC, and their attachments to the TGW.  

   2) The NFW blocks outbound requests from the test VPC.  

   3) Problem with the NAT Gateway.  

2c)  
   i) The error indicates there is a problem with the test-ec2 permissions to access the repository,  
      - Perhaps the repository requires credentials.  
      - The test-ec2 instance might require an IAM role to access the repository.  

   ii) The error probably refers to a network problem between the two instances.  
       - Check the security groups, NACLs, route tables, and TGW attachments for both VPCs.  

   iii) The Docker daemon is not running.  
        - Check the status using `sudo systemctl status docker`.  
        - If it 


Open Questions:
2a) The problem can occur due to a fialure in 3 different locations:
    1) The "TEST SPOKE" vpc => need to check if the instance allow outbound traffic to the "INSPECTION" vpc, same for the subnet level (NACL). Also, the routing table of the subnet must have the "INSPECTION" vpc as target.
    2) The transit gateway => need to make sure both vpc's are attached to it, and that they appear as targets in his route table.
    3) The "INSPECTION" vpc => perhaps the checkpoint firewall blocks requests from the "TEST SPOKE" vpc, also there might be a problem with the DNS resolver.

2b) 1) Same as before, misconfiguration at the "TEST SMOKE" vpc and the "ENGRESS" vpc, and their attachments to the TGW.
    2) The NFW blocks outbound requests from the test vpc.
    3) Problem with the NAT Gateway.

2c-i)  The error indicates there is a problem with the test-ec2 permissions to access the repository, perhaps the repository
       requires credentials, or the test-ec2 instance requires and IAM role to access the repository.

2c-ii) The error probably refers to a network problem between the 2 instances, therefore we must check the security groups,
       NACL , and route tables + TGW attachments for both of the vpc's.

2c-iii)The docker daemon is not running, we can check the status using 'sudo systemctl status docker'. If it exists, we can 
       restart it using the restart command with systemctl. If it does'nt exist, we need to install it.

3) A possible cause for this scenario is that the instance (or the subnet) won't accept traffic through port 443, or from the relevant source ip address.
Also, there is a possibility that the ssl certificate has expired, and we need to generate a new one.

4) sudo yum install telnet.