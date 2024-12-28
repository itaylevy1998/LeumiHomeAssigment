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
1) create multibranch pipeline and point to the github repository
2) add the github pat as a jenkins credential.
3) add iam user 'leumi-user' as credentials
4) install plugins: docker pipeline, Amazon ECR.

Question1:
setting up the jenkins master and agent within a seperate vpc.
setting up the eks vpc and the whole cluster, using terraform init within the EKS folder. 
after running init, must copy the new vpc id into the script 'installlbcontroller', and run the script.



