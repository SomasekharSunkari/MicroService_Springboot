# ECR Image Pull Secrets Setup Guide

## Problem Identified
The "ImagePullBackOff" error was occurring because:
1. All services use AWS ECR (Elastic Container Registry) images from `068856380156.dkr.ecr.us-east-1.amazonaws.com`
2. ECR requires authentication to pull images
3. Only the `authservice` deployment had `imagePullSecrets` configured
4. All other deployments were missing the `imagePullSecrets` configuration

## Solution Implemented

### 1. Created ECR Docker Registry Secrets
- **Secret Name**: `ecr-registry-secret`
- **Type**: `kubernetes.io/dockerconfigjson`
- **Namespace**: `ecommerce`

### 2. Updated All Deployment Manifests
Added `imagePullSecrets` configuration to all deployment files:
- ✅ authservice/deployment.yml
- ✅ clientcode/deployment.yml  
- ✅ configserver/deployment.yml
- ✅ customer/deployment.yml
- ✅ discovery/deployment.yml
- ✅ gateway/deployment.yml
- ✅ notification/deployment.yml
- ✅ order/deployment.yml
- ✅ payment/deployment.yml
- ✅ product/deployment.yml

## Deployment Steps

### Step 1: Create ECR Registry Secret

#### Option A: Using the provided script (Recommended)

**For Linux/Mac:**
```bash
chmod +x k8s/create-ecr-secrets.sh
./k8s/create-ecr-secrets.sh
```

**For Windows:**
```cmd
k8s\create-ecr-secrets.bat
```

#### Option B: Manual creation
```bash
# Ensure namespace exists
kubectl create namespace ecommerce --dry-run=client -o yaml | kubectl apply -f -

# Create the ECR secret
aws ecr get-login-password --region us-east-1 | kubectl create secret docker-registry ecr-registry-secret \
    --docker-server=068856380156.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password-stdin \
    --namespace=ecommerce
```

### Step 2: Verify Secret Creation
```bash
kubectl get secret ecr-registry-secret -n ecommerce
kubectl describe secret ecr-registry-secret -n ecommerce
```

### Step 3: Deploy/Update Applications
```bash
# Apply all deployment manifests
kubectl apply -f k8s/shared/
kubectl apply -f k8s/configserver/
kubectl apply -f k8s/discovery/
kubectl apply -f k8s/authservice/
kubectl apply -f k8s/gateway/
kubectl apply -f k8s/customer/
kubectl apply -f k8s/product/
kubectl apply -f k8s/order/
kubectl apply -f k8s/payment/
kubectl apply -f k8s/notification/
kubectl apply -f k8s/clientcode/
```

### Step 4: Verify Deployments
```bash
# Check pod status
kubectl get pods -n ecommerce

# Check for any remaining ImagePullBackOff errors
kubectl get pods -n ecommerce | grep -E "(ImagePullBackOff|ErrImagePull)"

# Describe problematic pods if any
kubectl describe pod <pod-name> -n ecommerce
```

## Important Notes

### ECR Token Expiration
- ECR tokens expire after 12 hours
- You may need to recreate the secret periodically
- Consider using IAM roles for service accounts (IRSA) for production

### Alternative: Using IAM Roles for Service Accounts (IRSA)
For production environments, consider using IRSA instead of storing ECR tokens:

1. Create an IAM role with ECR permissions
2. Associate it with a Kubernetes service account
3. Use the service account in your deployments

### Troubleshooting

#### If pods still show ImagePullBackOff:
1. Verify the secret exists: `kubectl get secret ecr-registry-secret -n ecommerce`
2. Check if the ECR token is still valid: `aws ecr get-login-password --region us-east-1`
3. Recreate the secret if the token expired
4. Restart the deployment: `kubectl rollout restart deployment <deployment-name> -n ecommerce`

#### Common Issues:
- **AWS CLI not configured**: Run `aws configure` with proper credentials
- **Insufficient ECR permissions**: Ensure the AWS user/role has ECR read permissions
- **Wrong region**: Verify the ECR registry region matches your AWS CLI configuration
- **Network issues**: Ensure the Kubernetes cluster can reach ECR endpoints

## Files Created/Modified

### New Files:
- `k8s/shared/docker-registry-secrets.yml` - Secret manifest template
- `k8s/create-ecr-secrets.sh` - Linux/Mac script to create secrets
- `k8s/create-ecr-secrets.bat` - Windows script to create secrets
- `k8s/ECR-SETUP-GUIDE.md` - This guide

### Modified Files:
- All deployment.yml files in each service directory now include `imagePullSecrets`

## Security Best Practices

1. **Rotate ECR tokens regularly** (every 12 hours or less)
2. **Use least privilege IAM policies** for ECR access
3. **Consider using IRSA** for production workloads
4. **Monitor secret usage** and access patterns
5. **Use sealed secrets or external secret operators** for GitOps workflows