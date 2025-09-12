#!/bin/bash

# ================================================================
# MICROSERVICES TERRAFORM DEPLOYMENT SCRIPT
# Sequential deployment with automatic cleanup
# ================================================================

echo "🚀 Starting Microservices Infrastructure Deployment"
echo "=============================================="

# Step 1: Clean up old conflicting terraform files
echo "🧹 Step 1: Cleaning up old terraform files..."
rm -f 01-network.tf 04-ecr.tf 05-ecs.tf 06-codebuild.tf 07-codepipeline.tf 2>/dev/null
rm -f ecr.tf ecs.tf codebuild.tf codepipeline.tf 2>/dev/null
rm -f main.tf.backup 2>/dev/null
echo "✅ Old files cleaned up"

# Step 2: Initialize terraform
echo "🔧 Step 2: Initializing Terraform..."
terraform init
if [ $? -ne 0 ]; then
    echo "❌ Terraform init failed"
    exit 1
fi
echo "✅ Terraform initialized"

# Step 3: Validate configuration
echo "🔍 Step 3: Validating Terraform configuration..."
terraform validate
if [ $? -ne 0 ]; then
    echo "❌ Terraform validation failed"
    exit 1
fi
echo "✅ Configuration validated"

# Step 4: Plan deployment
echo "📋 Step 4: Planning deployment..."
terraform plan -out=deployment.tfplan
if [ $? -ne 0 ]; then
    echo "❌ Terraform plan failed"
    exit 1
fi
echo "✅ Deployment plan created"

# Step 5: Apply infrastructure
echo "🚀 Step 5: Applying infrastructure..."
echo "This will create resources in the following order:"
echo "  1. Network (VPC, subnets, ALB, target groups)"
echo "  2. ECR repositories"
echo "  3. CodeBuild projects" 
echo "  4. ECS cluster, tasks, and services"
echo "  5. CodePipeline for CI/CD"
echo ""
read -p "Do you want to proceed? (yes/no): " -r
if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    terraform apply deployment.tfplan
    if [ $? -ne 0 ]; then
        echo "❌ Terraform apply failed"
        exit 1
    fi
else
    echo "❌ Deployment cancelled by user"
    exit 1
fi

echo ""
echo "🎉 Infrastructure deployment completed!"
echo "=============================================="

# Step 6: Show next manual steps
echo "📝 MANUAL STEPS REQUIRED:"
echo ""
echo "1. 🔗 Activate GitHub Connection:"
echo "   - Go to AWS Console > Developer Tools > Settings > Connections"
echo "   - Find 'microservices-ecommerce-github-connection'"
echo "   - Click 'Update pending connection' and authorize GitHub"
echo ""
echo "2. 🏗️ Run Initial Builds (to get first Docker images):"
terraform output -json | jq -r '.codebuild.value.projects | to_entries[] | "aws codebuild start-build --project-name \(.value.name)"'
echo ""
echo "3. 🔄 Monitor ECS Services:"
echo "   aws ecs describe-services --cluster sophisticated-fish-p08ixg --services \$(aws ecs list-services --cluster sophisticated-fish-p08ixg --query 'serviceArns[*]' --output text | tr '\t' ' ')"
echo ""
echo "4. 🌐 Access Application:"
terraform output -json | jq -r '.application_urls.value.load_balancer_url'
echo ""
echo "✅ All done! Your microservices platform is ready."