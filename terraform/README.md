# Microservices E-commerce Platform - Terraform Infrastructure

This Terraform configuration creates a complete AWS infrastructure for a microservices-based e-commerce platform following a **sequential modular approach**.

## 🏗️ Architecture Overview

### Sequential Module Deployment Flow:
1. **Network Module** → Creates VPC, subnets, security groups, load balancer, and target groups
2. **ECR Module** → Creates Docker repositories (uses network outputs)
3. **CodeBuild Module** → Creates build projects (uses ECR outputs)
4. **ECS Module** → Creates cluster, tasks, and services (uses network + ECR outputs)
5. **CodePipeline Module** → Creates CI/CD pipelines (uses all previous outputs)

## 📁 Module Structure

```
terraform/
├── main.tf              # Main configuration calling all modules
├── variables.tf         # Variable definitions (no hardcoded values)
├── terraform.tfvars     # Actual values for your environment
├── provider.tf          # AWS provider configuration
├── 02-iam.tf           # IAM roles and policies
└── modules/
    ├── network/         # VPC, subnets, ALB, target groups
    ├── ecr/            # ECR repositories
    ├── codebuild/      # CodeBuild projects
    ├── ecs/            # ECS cluster, tasks, services
    └── codepipeline/   # CI/CD pipelines
```

## 🚀 Deployment Process

### Prerequisites
1. **Remove conflicting old terraform files** (if they exist):
   ```bash
   cd terraform
   rm -f 01-network.tf 04-ecr.tf 05-ecs.tf 06-codebuild.tf 07-codepipeline.tf
   rm -f ecr.tf ecs.tf codebuild.tf codepipeline.tf
   ```

2. **Configure AWS credentials**:
   ```bash
   aws configure set aws_access_key_id YOUR_ACCESS_KEY
   aws configure set aws_secret_access_key YOUR_SECRET_KEY
   aws configure set region eu-north-1
   ```

### Step-by-Step Deployment

1. **Initialize Terraform**:
   ```bash
   cd terraform
   terraform init
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Plan Deployment**:
   ```bash
   terraform plan
   ```

4. **Deploy Infrastructure** (Sequential flow):
   ```bash
   terraform apply
   ```

The terraform will automatically follow this sequence:
- **Step 1**: Network infrastructure (VPC, subnets, ALB, target groups)
- **Step 2**: ECR repositories for each microservice
- **Step 3**: CodeBuild projects (after ECR is ready)
- **Step 4**: ECS cluster, task definitions, and services (after network + ECR)
- **Step 5**: CodePipeline (after all previous components are ready)

## 🔧 Manual Steps After Terraform Apply

### 1. Connect GitHub to CodeStar
After the first `terraform apply`, you need to manually activate the GitHub connection:
```bash
# Get the connection ARN from terraform output
terraform output

# Go to AWS Console > Developer Tools > Settings > Connections
# Find your connection and click "Update pending connection"
# Follow the GitHub authorization process
```

### 2. Run Initial CodeBuild (First time only)
To get the first Docker images into ECR:
```bash
# For each service, trigger the first build manually:
aws codebuild start-build --project-name microservices-ecommerce-payment-build
aws codebuild start-build --project-name microservices-ecommerce-auth-build
aws codebuild start-build --project-name microservices-ecommerce-order-build
aws codebuild start-build --project-name microservices-ecommerce-notification-build
aws codebuild start-build --project-name microservices-ecommerce-client-build
aws codebuild start-build --project-name microservices-ecommerce-config-build
aws codebuild start-build --project-name microservices-ecommerce-product-build
```

### 3. Update ECS Services (After first build)
Once images are in ECR, update the ECS services:
```bash
# The ECS services will automatically start using the new images
# You can force a new deployment if needed:
aws ecs update-service --cluster sophisticated-fish-p08ixg --service payment-service-service --force-new-deployment
aws ecs update-service --cluster sophisticated-fish-p08ixg --service auth-service-service --force-new-deployment
# ... repeat for all services
```

## 🔄 How the Pipeline Works

### Automatic Triggers
Each CodePipeline is configured to trigger on:
- **Push to main branch**
- **Changes to specific service directory** (e.g., `payment/**` for payment service)

### Pipeline Stages
1. **Source**: Pulls code from GitHub
2. **Build**: Uses CodeBuild to create Docker image and push to ECR
3. **Deploy**: Updates ECS service with new image

## 🌐 Service Access

### Public Services (via Load Balancer):
- **Client Service**: `http://public-ms-balancer-968609518.eu-north-1.elb.amazonaws.com/`
- **Auth Service**: `http://public-ms-balancer-968609518.eu-north-1.elb.amazonaws.com/auth`
- **Order Service**: `http://public-ms-balancer-968609518.eu-north-1.elb.amazonaws.com/order`
- **Payment Service**: `http://public-ms-balancer-968609518.eu-north-1.elb.amazonaws.com/payment`
- **Product Service**: `http://public-ms-balancer-968609518.eu-north-1.elb.amazonaws.com/product`

### Internal Services (Service Discovery):
- **Config Server**: `config-server.microservices-ecommerce.local:8888`
- **Notification Service**: `notification-service.microservices-ecommerce.local:8050`

## 📊 Monitoring & Logs

### CloudWatch Logs
Each service has its own log group:
- `/ecs/payment-service`
- `/ecs/auth-service`
- `/ecs/order-service`
- `/ecs/notification-service`
- `/ecs/client-service`
- `/ecs/config-server`
- `/ecs/product-api`

### ECS Service Monitoring
```bash
# Check service status
aws ecs describe-services --cluster sophisticated-fish-p08ixg --services payment-service-service

# Check running tasks
aws ecs list-tasks --cluster sophisticated-fish-p08ixg --service-name payment-service-service
```

## 🔧 Troubleshooting

### Common Issues

1. **CodeStar Connection Pending**:
   - Go to AWS Console > CodeStar Connections
   - Activate the pending connection

2. **ECS Tasks not starting**:
   - Check ECR repository has images: `aws ecr describe-images --repository-name payment-service`
   - Check CloudWatch logs for container errors

3. **Load Balancer Health Checks Failing**:
   - Verify service health check endpoints
   - Check security group rules
   - Verify target group configurations

### Commands for Manual Operations

```bash
# Check terraform state
terraform state list

# Get specific outputs
terraform output deployment_summary

# Destroy infrastructure (BE CAREFUL!)
terraform destroy

# Apply specific module changes
terraform apply -target=module.network
terraform apply -target=module.ecr
terraform apply -target=module.ecs
```

## 🔄 Making Changes

When you need to make changes to services:

1. **Code Changes**: Push to GitHub → Pipeline auto-triggers
2. **Infrastructure Changes**: Modify terraform files → `terraform apply`
3. **Service Scaling**: Update `desired_count` in terraform.tfvars → `terraform apply`

## 📝 Notes

- **Target Groups**: Automatically created and associated with ECS services
- **Service Discovery**: Internal communication via DNS names
- **Auto Scaling**: Can be added by updating ECS service configurations
- **SSL/HTTPS**: Can be added by updating load balancer listener configuration

This setup replicates your existing AWS infrastructure using terraform modules with proper input/output chaining, avoiding hardcoded values.